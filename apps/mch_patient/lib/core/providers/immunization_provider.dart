import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:mch_core/mch_core.dart';
import 'child_provider.dart';

/// Immunization Repository Provider
final immunizationRepositoryProvider = Provider<ImmunizationRepository>((ref) {
  return ImmunizationRepository(Supabase.instance.client);
});

/// Get immunization records for a specific child
final childImmunizationsProvider =
    FutureProvider.family<List<ImmunizationRecord>, String>(
        (ref, childId) async {
  final repository = ref.read(immunizationRepositoryProvider);

  try {
    return await repository.getImmunizationsByChildId(childId);
  } catch (e) {
    print('Error fetching immunizations: $e');
    return <ImmunizationRecord>[];
  }
});

/// Get immunization coverage (doses received per vaccine type)
final immunizationCoverageProvider =
    FutureProvider.family<Map<ImmunizationType, int>, String>(
        (ref, childId) async {
  final repository = ref.read(immunizationRepositoryProvider);

  try {
    return await repository.getImmunizationCoverage(childId);
  } catch (e) {
    print('Error fetching immunization coverage: $e');
    return <ImmunizationType, int>{};
  }
});

/// Kenya EPI Schedule - MCH Handbook Pages 33-34
/// Returns the expected vaccines at each age milestone
class KenyaEPISchedule {
  static const List<VaccineSchedule> schedule = [
    // At Birth
    VaccineSchedule(
      ageLabel: 'At Birth',
      ageInWeeks: 0,
      vaccines: [
        ScheduledVaccine(type: ImmunizationType.bcg, dose: 1, name: 'BCG'),
        ScheduledVaccine(
            type: ImmunizationType.bopv, dose: 1, name: 'OPV 0 (Birth)'),
      ],
    ),
    // 6 Weeks
    VaccineSchedule(
      ageLabel: '6 Weeks',
      ageInWeeks: 6,
      vaccines: [
        ScheduledVaccine(type: ImmunizationType.bopv, dose: 2, name: 'OPV 1'),
        ScheduledVaccine(
            type: ImmunizationType.pentavalent, dose: 1, name: 'Pentavalent 1'),
        ScheduledVaccine(
            type: ImmunizationType.pcv10, dose: 1, name: 'PCV10 1'),
        ScheduledVaccine(
            type: ImmunizationType.rotavirus, dose: 1, name: 'Rotavirus 1'),
      ],
    ),
    // 10 Weeks
    VaccineSchedule(
      ageLabel: '10 Weeks',
      ageInWeeks: 10,
      vaccines: [
        ScheduledVaccine(type: ImmunizationType.bopv, dose: 3, name: 'OPV 2'),
        ScheduledVaccine(
            type: ImmunizationType.pentavalent, dose: 2, name: 'Pentavalent 2'),
        ScheduledVaccine(
            type: ImmunizationType.pcv10, dose: 2, name: 'PCV10 2'),
        ScheduledVaccine(
            type: ImmunizationType.rotavirus, dose: 2, name: 'Rotavirus 2'),
      ],
    ),
    // 14 Weeks
    VaccineSchedule(
      ageLabel: '14 Weeks',
      ageInWeeks: 14,
      vaccines: [
        ScheduledVaccine(type: ImmunizationType.bopv, dose: 4, name: 'OPV 3'),
        ScheduledVaccine(
            type: ImmunizationType.pentavalent, dose: 3, name: 'Pentavalent 3'),
        ScheduledVaccine(
            type: ImmunizationType.pcv10, dose: 3, name: 'PCV10 3'),
        ScheduledVaccine(type: ImmunizationType.ipv, dose: 1, name: 'IPV'),
      ],
    ),
    // 9 Months
    VaccineSchedule(
      ageLabel: '9 Months',
      ageInWeeks: 39, // ~9 months
      vaccines: [
        ScheduledVaccine(
            type: ImmunizationType.measlesRubella,
            dose: 1,
            name: 'Measles-Rubella 1'),
        ScheduledVaccine(
            type: ImmunizationType.yellowFever, dose: 1, name: 'Yellow Fever'),
      ],
    ),
    // 18 Months
    VaccineSchedule(
      ageLabel: '18 Months',
      ageInWeeks: 78, // ~18 months
      vaccines: [
        ScheduledVaccine(
            type: ImmunizationType.measlesRubella,
            dose: 2,
            name: 'Measles-Rubella 2'),
      ],
    ),
  ];

  /// Get the vaccination status for a child
  static VaccinationStatus getChildVaccinationStatus({
    required DateTime dateOfBirth,
    required Map<ImmunizationType, int> coverage,
  }) {
    final detailed = getDetailedVaccinationStatus(
        dateOfBirth: dateOfBirth, coverage: coverage);
    return VaccinationStatus(
      totalDue: detailed.totalDue,
      totalReceived: detailed.totalReceived,
      overdue: detailed.overdue,
      percentComplete: detailed.percentComplete,
    );
  }

  /// Get detailed vaccination status including specific overdue vaccines
  static DetailedVaccinationStatus getDetailedVaccinationStatus({
    required DateTime dateOfBirth,
    required Map<ImmunizationType, int> coverage,
  }) {
    final now = DateTime.now();
    final ageInWeeks = now.difference(dateOfBirth).inDays ~/ 7;

    int totalDue = 0;
    int totalReceived = 0;
    int overdue = 0;
    final overdueList = <String>[];

    for (final milestone in schedule) {
      if (ageInWeeks >= milestone.ageInWeeks) {
        // This milestone is due
        for (final vaccine in milestone.vaccines) {
          totalDue++;
          final receivedDoses = coverage[vaccine.type] ?? 0;
          if (receivedDoses >= vaccine.dose) {
            totalReceived++;
          } else {
            overdue++;
            overdueList.add(vaccine.name);
          }
        }
      }
    }

    return DetailedVaccinationStatus(
      totalDue: totalDue,
      totalReceived: totalReceived,
      overdue: overdue,
      percentComplete:
          totalDue > 0 ? (totalReceived / totalDue * 100).round() : 0,
      overdueVaccines: overdueList,
    );
  }
}

/// A scheduled vaccine milestone
class VaccineSchedule {
  final String ageLabel;
  final int ageInWeeks;
  final List<ScheduledVaccine> vaccines;

  const VaccineSchedule({
    required this.ageLabel,
    required this.ageInWeeks,
    required this.vaccines,
  });
}

/// A single vaccine in the schedule
class ScheduledVaccine {
  final ImmunizationType type;
  final int dose;
  final String name;

  const ScheduledVaccine({
    required this.type,
    required this.dose,
    required this.name,
  });
}

/// Vaccination status summary
class VaccinationStatus {
  final int totalDue;
  final int totalReceived;
  final int overdue;
  final int percentComplete;

  const VaccinationStatus({
    required this.totalDue,
    required this.totalReceived,
    required this.overdue,
    required this.percentComplete,
  });

  bool get isUpToDate => overdue == 0;
}

/// Alert object for urgent actions
class UrgentAlert {
  final String childId;
  final String childName;
  final String title;
  final String message;
  final String vaccineName;
  final int weeksOverdue;

  UrgentAlert({
    required this.childId,
    required this.childName,
    required this.title,
    required this.message,
    required this.vaccineName,
    required this.weeksOverdue,
  });
}

/// Provider to get urgent alerts for all children
/// Returns a list of urgent alerts (e.g. missed vaccines)
final urgentAlertsProvider = FutureProvider<List<UrgentAlert>>((ref) async {
  // 1. Get all children
  // We need to use the ChildRepository directly to avoid circular dependency or complex watching
  // assuming patientChildrenProvider is safe to read here?
  // Actually, let's use the repository pattern to be safe and clean.

  // Actually, we can just read the repository and fetch children for the current mother manually
  // Or better, let's assume the UI will watch patientChildrenProvider separately.
  // But to keep it simple, let's look at `patientChildrenProvider`:
  // It uses `currentMaternalProfileProvider`.

  // Let's try to read the children provider. If it's not ready, we return empty.
  final childrenAsync = ref.watch(patientChildrenProvider);

  return childrenAsync.maybeWhen(
    data: (children) async {
      final alerts = <UrgentAlert>[];
      final repository = ref.read(immunizationRepositoryProvider);

      for (final child in children) {
        if (child.childName.isEmpty) continue;

        // Fetch coverage
        final coverage = await repository.getImmunizationCoverage(child.id);

        // Check status
        final status = KenyaEPISchedule.getDetailedVaccinationStatus(
          dateOfBirth: child.dateOfBirth,
          coverage: coverage,
        );

        if (status.overdue > 0 && status.overdueVaccines.isNotEmpty) {
          // Create an alert for the first overdue vaccine (to avoid clutter)
          // In a real app, maybe list all or group them
          final vaccine = status.overdueVaccines.first;

          // Calculate how overdue? (Roughly based on current age vs schedule)
          // For simplicity, just say "Overdue"

          alerts.add(UrgentAlert(
            childId: child.id,
            childName: child.childName,
            title: 'Action Required',
            message: '${child.childName.split(' ').first} missed $vaccine',
            vaccineName: vaccine,
            weeksOverdue: 0, // We could calculate this more precisely if needed
          ));
        }
      }
      return alerts;
    },
    orElse: () => <UrgentAlert>[],
  );
});

// Update VaccinationStatus to include specific overdue details
class DetailedVaccinationStatus extends VaccinationStatus {
  final List<String> overdueVaccines;

  const DetailedVaccinationStatus({
    required super.totalDue,
    required super.totalReceived,
    required super.overdue,
    required super.percentComplete,
    required this.overdueVaccines,
  });
}
