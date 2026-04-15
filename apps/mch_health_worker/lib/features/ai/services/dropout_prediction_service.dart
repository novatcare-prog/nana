import 'dart:convert';
import 'package:mch_core/mch_core.dart';

const String _dropoutPrompt = '''
You are a maternal health AI assistant trained on Kenya MOH ANC guidelines.

Analyze this patient's appointment history and ANC visit patterns to predict their risk of missing future appointments (dropout).

CRITICAL: Return ONLY valid JSON, no markdown, no explanation outside the JSON.

Required JSON format:
{
  "dropoutRisk": "LOW" | "MEDIUM" | "HIGH",
  "dropoutScore": <integer 0-100>,
  "keyRiskFactors": [
    "<specific factor contributing to dropout risk>",
    ...
  ],
  "recommendedFollowUpDays": <integer: recommended days from today for follow-up>,
  "suggestedOutreachMessage": "<ready-to-send outreach message in simple, warm English — max 2 sentences>"
}

Risk level definitions:
- LOW (0-30): Patient is attending regularly, standard monitoring
- MEDIUM (31-65): Some inconsistency in attendance, proactive engagement recommended  
- HIGH (66-100): Significant risk of dropout, outreach needed urgently

The suggestedOutreachMessage should address the patient by name placeholder {name} and mention their clinic.
Limit keyRiskFactors to 3 maximum.
''';

// ── Dropout Prediction Model ──────────────────────────────────────────────────

class DropoutPrediction {
  final String patientId;
  final String dropoutRisk; // LOW | MEDIUM | HIGH
  final int dropoutScore; // 0-100
  final List<String> keyRiskFactors;
  final int recommendedFollowUpDays;
  final String suggestedOutreachMessage;
  final DateTime generatedAt;

  DropoutPrediction({
    required this.patientId,
    required this.dropoutRisk,
    required this.dropoutScore,
    required this.keyRiskFactors,
    required this.recommendedFollowUpDays,
    required this.suggestedOutreachMessage,
    required this.generatedAt,
  });

  factory DropoutPrediction.fromGeminiResponse(
      String patientId, String patientName, String clinicName, String jsonText) {
    try {
      var clean = jsonText.trim();
      if (clean.startsWith('```')) {
        clean = clean.replaceAll(RegExp(r'```(?:json)?\n?'), '').trim();
      }

      final Map<String, dynamic> data =
          jsonDecode(clean) as Map<String, dynamic>;

      List<String> list(String key) =>
          (data[key] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? [];

      final rawMessage =
          data['suggestedOutreachMessage']?.toString() ?? '';
      final personalizedMessage = rawMessage
          .replaceAll('{name}', patientName)
          .replaceAll('{clinic}', clinicName);

      return DropoutPrediction(
        patientId: patientId,
        dropoutRisk: data['dropoutRisk']?.toString() ?? 'LOW',
        // Clamp to valid range — prevents manipulated AI responses
        dropoutScore: ((data['dropoutScore'] as num?)?.toInt() ?? 0).clamp(0, 100),
        keyRiskFactors: list('keyRiskFactors'),
        recommendedFollowUpDays:
            ((data['recommendedFollowUpDays'] as num?)?.toInt() ?? 30).clamp(1, 365),
        suggestedOutreachMessage: personalizedMessage,
        generatedAt: DateTime.now(),
      );
    } catch (_) {
      return DropoutPrediction.unknown(patientId);
    }
  }

  factory DropoutPrediction.unknown(String patientId) => DropoutPrediction(
        patientId: patientId,
        dropoutRisk: 'LOW',
        dropoutScore: 0,
        keyRiskFactors: [],
        recommendedFollowUpDays: 30,
        suggestedOutreachMessage: '',
        generatedAt: DateTime.now(),
      );

  bool get isHighRisk => dropoutRisk == 'HIGH';
  bool get isMediumRisk => dropoutRisk == 'MEDIUM';
}

// ── Dropout Prediction Service ────────────────────────────────────────────────

class DropoutPredictionService {
  final GeminiService _gemini;

  DropoutPredictionService(this._gemini);

  Future<DropoutPrediction> predictDropout({
    required MaternalProfile profile,
    required List<Appointment> appointmentHistory,
    required List<ANCVisit> visitHistory,
  }) async {
    final context = PatientContextBuilder.buildMaternalContext(
      profile: profile,
      ancVisits: visitHistory,
      appointments: appointmentHistory,
    );

    final prompt = '$_dropoutPrompt\n\n$context\n\nGenerate the dropout prediction JSON now.';

    final responseText = await _gemini.generateText(prompt);
    return DropoutPrediction.fromGeminiResponse(
      profile.id ?? '',
      profile.clientName,
      profile.facilityName,
      responseText,
    );
  }
}
