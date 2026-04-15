import '../../models/maternal/maternal_profile.dart';
import '../../models/maternal/anc_visit.dart';
import '../../models/maternal/nutrition_record.dart';
import '../../models/appointment/appointment.dart';
import '../../models/lab/lab_result.dart';
import '../../models/child/child_profile.dart';
import '../../enums/hiv_test_result.dart';

/// Builds structured text context strings from patient data
/// to inject into Gemini prompts.
class PatientContextBuilder {
  /// Strips characters and patterns that could be used for prompt injection.
  /// Applied to all free-text patient fields before they enter any AI prompt.
  static String _sanitize(String? value) {
    if (value == null || value.trim().isEmpty) return 'Unknown';
    return value
        // Remove instruction-override phrases
        .replaceAll(
          RegExp(
            r'(?i)(ignore|disregard|forget|override).{0,30}(above|previous|instruction|prompt|system)',
          ),
          '[removed]',
        )
        // Strip characters used in prompt template injection
        .replaceAll(RegExp(r'[<>{}\[\]\\|`]'), '')
        // Collapse excessive whitespace
        .replaceAll(RegExp(r'\s{3,}'), '  ')
        .trim();
  }

  /// Full maternal context for risk assessment and clinical decision support.
  static String buildMaternalContext({
    required MaternalProfile profile,
    List<ANCVisit> ancVisits = const [],
    List<LabResult> labResults = const [],
    List<NutritionRecord> nutritionRecords = const [],
    List<Appointment> appointments = const [],
  }) {
    final buffer = StringBuffer();

    buffer.writeln('=== PATIENT CONTEXT ===');
    buffer.writeln('Name: ${_sanitize(profile.clientName)}');
    buffer.writeln('Age: ${profile.age} years');
    buffer.writeln('Gravida: ${profile.gravida}  |  Parity: ${profile.parity}');

    if (profile.edd != null) {
      final edd = profile.edd!;
      final now = DateTime.now();
      final daysToEdd = edd.difference(now).inDays;
      // Calculate gestational age: 280 days gestation - daysRemaining = days elapsed
      final gestationalDays = 280 - daysToEdd;
      final gestationalWeeks = (gestationalDays / 7).round();
      if (gestationalWeeks > 0 && gestationalWeeks <= 42) {
        buffer.writeln('Gestational Age: ~$gestationalWeeks weeks');
      }
      buffer.writeln('Expected Delivery Date: ${_formatDate(edd)}');
    }
    if (profile.lmp != null) {
      buffer.writeln('Last Menstrual Period: ${_formatDate(profile.lmp!)}');
    }

    // Known conditions
    final conditions = <String>[];
    if (profile.diabetes == true) conditions.add('Diabetes');
    if (profile.hypertension == true) conditions.add('Hypertension');
    if (profile.tuberculosis == true) conditions.add('Tuberculosis');
    if (profile.hivResult == HivTestResult.reactive) conditions.add('HIV Positive');
    if (profile.bleedingHistory == true) conditions.add('Bleeding history');
    if (profile.previousCs == true) {
      conditions.add('Previous C-section (x${profile.previousCsCount ?? 1})');
    }
    if (profile.stillbirths != null && profile.stillbirths! > 0) {
      conditions.add('Previous stillbirths: ${profile.stillbirths}');
    }
    if (profile.neonatalDeaths != null && profile.neonatalDeaths! > 0) {
      conditions.add('Previous neonatal deaths: ${profile.neonatalDeaths}');
    }
    if (conditions.isNotEmpty) {
      buffer.writeln('Known Conditions / Risk Factors: ${conditions.join(", ")}');
    }

    buffer.writeln('Blood Group: ${profile.bloodGroup?.name ?? "Unknown"}');

    // ANC Visit history
    if (ancVisits.isNotEmpty) {
      buffer.writeln('\n=== ANC VISIT HISTORY (${ancVisits.length} visits) ===');
      final sorted = [...ancVisits]..sort((a, b) => b.visitDate.compareTo(a.visitDate));
      for (final visit in sorted.take(5)) {
        buffer.writeln('Contact ${visit.contactNumber} — ${_formatDate(visit.visitDate)} '
            '(${visit.gestationWeeks}w gestation):');
        if (visit.bloodPressure != null) buffer.writeln('  BP: ${visit.bloodPressure}');
        if (visit.weightKg != null) buffer.writeln('  Weight: ${visit.weightKg} kg');
        if (visit.fundalHeight != null) buffer.writeln('  Fundal Height: ${visit.fundalHeight} cm');
        if (visit.foetalHeartRate != null) buffer.writeln('  FHR: ${visit.foetalHeartRate} bpm');
        if (visit.haemoglobin != null) buffer.writeln('  Hb: ${visit.haemoglobin} g/dL');
        if (visit.urineProtein != null) buffer.writeln('  Urine Protein: ${visit.urineProtein}');
        if (visit.pallor == true) buffer.writeln('  PALLOR detected');
        if (visit.isHighRisk == true) buffer.writeln('  [FLAGGED HIGH RISK]');
        if (visit.complaints != null && visit.complaints!.isNotEmpty) {
          buffer.writeln('  Complaints: ${_sanitize(visit.complaints)}');
        }
      }
    }

    // Lab results
    if (labResults.isNotEmpty) {
      buffer.writeln('\n=== LAB RESULTS ===');
      for (final lab in labResults.take(10)) {
        final abnormal = lab.isAbnormal ? ' [ABNORMAL]' : '';
        buffer.writeln('${_formatDate(lab.testDate)} ${lab.testName}: '
            '${lab.resultValue} ${lab.resultUnit ?? ""}$abnormal');
      }
    }

    // Nutrition
    if (nutritionRecords.isNotEmpty) {
      final latest = nutritionRecords.reduce(
        (a, b) => a.recordDate.isAfter(b.recordDate) ? a : b,
      );
      buffer.writeln('\n=== NUTRITION ===');
      if (latest.muacCm != null) buffer.writeln('Latest MUAC: ${latest.muacCm} cm');
      if (latest.isMalnourished) buffer.writeln('  [MALNOURISHED — MUAC < 23cm]');
    }

    // Appointments
    if (appointments.isNotEmpty) {
      final missed = appointments.where((a) => a.appointmentStatus == AppointmentStatus.missed).length;
      final completed = appointments.where((a) => a.appointmentStatus == AppointmentStatus.completed).length;
      final missedRate = appointments.isNotEmpty ? (missed / appointments.length * 100).round() : 0;
      buffer.writeln('\n=== APPOINTMENT ADHERENCE ===');
      buffer.writeln('Completed: $completed  |  Missed: $missed  |  Total: ${appointments.length}');
      buffer.writeln('Missed Rate: $missedRate%');
    }

    return buffer.toString();
  }

  /// Lightweight patient-facing system prompt for the AI chatbot.
  static String buildChatbotSystemPrompt({
    MaternalProfile? profile,
    List<ChildProfile> children = const [],
  }) {
    final buffer = StringBuffer();
    buffer.writeln(
      'You are Mama AI, a friendly maternal and child health assistant for MCH Kenya. '
      'You provide evidence-based health education following Kenya Ministry of Health guidelines. '
      'Always recommend consulting a health professional for medical decisions. '
      'Be warm, encouraging, and use simple language. '
      'If the patient uses Swahili words, respond in both English and Swahili.',
    );

    if (profile != null) {
      buffer.writeln('\n--- PATIENT CONTEXT ---');
      if (profile.edd != null) {
        final weeksLeft = profile.edd!.difference(DateTime.now()).inDays ~/ 7;
        if (weeksLeft > 0 && weeksLeft <= 42) {
          final weeksPregnant = 40 - weeksLeft;
          buffer.writeln('Patient is approximately $weeksPregnant weeks pregnant '
              '($weeksLeft weeks until expected delivery).');
        }
      }
      if (profile.diabetes == true) {
        buffer.writeln('Patient has diabetes — tailor nutrition advice accordingly.');
      }
      if (profile.hypertension == true) {
        buffer.writeln('Patient has hypertension — advise on blood pressure management.');
      }
      if (profile.hivResult == HivTestResult.reactive) {
        buffer.writeln('Patient is HIV positive — provide appropriate PMTCT guidance when relevant.');
      }
    }

    if (children.isNotEmpty) {
      buffer.writeln('\n--- CHILDREN ---');
      for (final child in children) {
        final ageMonths = DateTime.now().difference(child.dateOfBirth).inDays ~/ 30;
        buffer.writeln('Child "${child.childName}": $ageMonths months old, ${child.sex}.');
      }
    }

    buffer.writeln('\n--- CURRENT DATE ---');
    buffer.writeln('Today is ${_formatDate(DateTime.now())} (East Africa Time).');

    return buffer.toString();
  }

  /// Dropout prediction context from appointment and visit history.
  static String buildDropoutContext({
    required MaternalProfile profile,
    required List<Appointment> appointments,
    required List<ANCVisit> visits,
  }) {
    final buffer = StringBuffer();
    buffer.writeln('=== DROPOUT RISK ANALYSIS ===');
    buffer.writeln('Patient: ${profile.clientName}  |  Age: ${profile.age}');
    buffer.writeln('Gravida: ${profile.gravida}  |  Parity: ${profile.parity}');
    buffer.writeln('Total appointments scheduled: ${appointments.length}');

    final missed = appointments.where((a) => a.appointmentStatus == AppointmentStatus.missed).toList();
    final completed = appointments.where((a) => a.appointmentStatus == AppointmentStatus.completed).toList();
    buffer.writeln('Missed: ${missed.length}  |  Completed: ${completed.length}');
    if (appointments.isNotEmpty) {
      final rate = (missed.length / appointments.length * 100).round();
      buffer.writeln('Missed rate: $rate%');
    }

    if (visits.isNotEmpty) {
      buffer.writeln('ANC visits attended: ${visits.length}');
      final lastVisit = visits.reduce((a, b) => a.visitDate.isAfter(b.visitDate) ? a : b);
      final daysSince = DateTime.now().difference(lastVisit.visitDate).inDays;
      buffer.writeln('Days since last visit: $daysSince');
    }

    // Last 4 appointments for pattern detection
    if (appointments.length >= 2) {
      final recent = [...appointments]
        ..sort((a, b) => b.appointmentDate.compareTo(a.appointmentDate));
      buffer.writeln('Recent appointment pattern:');
      for (final appt in recent.take(4)) {
        buffer.writeln('  ${_formatDate(appt.appointmentDate)}: ${appt.appointmentStatus.name}');
      }
    }

    return buffer.toString();
  }

  static String _formatDate(DateTime date) =>
      '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
}
