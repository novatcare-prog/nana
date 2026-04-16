import 'dart:convert';
import 'package:mch_core/mch_core.dart';

const String _clinicalSupportPrompt = '''
You are a clinical AI assistant specializing in maternal health, trained on Kenya MOH ANC Guidelines (MCH Handbook 2020).

A health worker is about to conduct ANC visit number {visitNumber} for this patient. Review the patient's full history and generate a focused pre-visit briefing.

CRITICAL: Return ONLY valid JSON, no markdown, no explanation outside the JSON.

Required JSON format:
{
  "suggestedQuestions": [
    "<specific clinical question to ask the patient at this visit>",
    ...
  ],
  "overdueScreenings": [
    "<specific screening or test that is overdue or due based on ANC guidelines>",
    ...
  ],
  "alertsAndWarnings": [
    "<specific clinical alert or warning based on history and trends>",
    ...
  ],
  "visitSummaryTemplate": "<2-3 sentence pre-filled starting text for visit notes, summarising key clinical points>"
}

Rules:
- Limit suggestedQuestions to 4 maximum
- Limit overdueScreenings to 4 maximum
- Limit alertsAndWarnings to 3 maximum — only flag genuinely concerning findings
- The visitSummaryTemplate should be a professional clinical note starter
''';

// ── Clinical Briefing Model ───────────────────────────────────────────────────

/// Represents a pre-visit AI briefing for health workers.
class ClinicalBriefing {
  final List<String> suggestedQuestions;
  final List<String> overdueScreenings;
  final List<String> alertsAndWarnings;
  final String visitSummaryTemplate;
  final String patientId;
  final DateTime generatedAt;

  ClinicalBriefing({
    required this.suggestedQuestions,
    required this.overdueScreenings,
    required this.alertsAndWarnings,
    required this.visitSummaryTemplate,
    required this.patientId,
    required this.generatedAt,
  });

  factory ClinicalBriefing.fromGeminiResponse(
      String patientId, String jsonText) {
    try {
      var clean = jsonText.trim();
      if (clean.startsWith('```')) {
        clean = clean.replaceAll(RegExp(r'```(?:json)?\n?'), '').trim();
      }

      final Map<String, dynamic> data =
          jsonDecode(clean) as Map<String, dynamic>;

      List<String> list(String key) =>
          (data[key] as List<dynamic>?)?.map((e) => e.toString()).toList() ??
          [];

      return ClinicalBriefing(
        patientId: patientId,
        suggestedQuestions: list('suggestedQuestions'),
        overdueScreenings: list('overdueScreenings'),
        alertsAndWarnings: list('alertsAndWarnings'),
        visitSummaryTemplate: data['visitSummaryTemplate']?.toString() ?? '',
        generatedAt: DateTime.now(),
      );
    } catch (_) {
      return ClinicalBriefing.error(patientId);
    }
  }

  factory ClinicalBriefing.error(String patientId) => ClinicalBriefing(
        patientId: patientId,
        suggestedQuestions: [],
        overdueScreenings: [],
        alertsAndWarnings: [],
        visitSummaryTemplate: '',
        generatedAt: DateTime.now(),
      );

  bool get hasAlerts => alertsAndWarnings.isNotEmpty;
}

// ── Clinical Support Service ─────────────────────────────────────────────────

class ClinicalSupportService {
  final GeminiService _gemini;

  ClinicalSupportService(this._gemini);

  Future<ClinicalBriefing> generateVisitBriefing({
    required MaternalProfile profile,
    required List<ANCVisit> previousVisits,
    required List<LabResult> labResults,
    required int expectedVisitNumber,
  }) async {
    final context = PatientContextBuilder.buildMaternalContext(
      profile: profile,
      ancVisits: previousVisits,
      labResults: labResults,
    );

    final prompt =
        '${_clinicalSupportPrompt.replaceAll('{visitNumber}', '$expectedVisitNumber')}\n\n$context\n\nGenerate the pre-visit briefing JSON now.';

    final responseText = await _gemini.generateText(prompt);
    return ClinicalBriefing.fromGeminiResponse(profile.id ?? '', responseText);
  }
}
