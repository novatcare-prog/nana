import 'package:mch_core/mch_core.dart';
import '../models/ai_risk_assessment.dart';

/// Prompt for Gemini risk assessment.
const String _riskAssessmentSystemPrompt = '''
You are a clinical AI assistant specialized in maternal health for Kenya.
You are trained on Kenya Ministry of Health Antenatal Care (ANC) guidelines (MCH Handbook 2020).

Analyze the patient data provided and return a structured JSON risk assessment.
Be precise, evidence-based, and focused on actionable insights for the health worker.

CRITICAL: Return ONLY valid JSON, no markdown, no explanation outside the JSON.

Required JSON format:
{
  "riskLevel": "LOW" | "MEDIUM" | "HIGH" | "CRITICAL",
  "riskScore": <integer 0-100>,
  "summary": "<2-3 sentence clinical summary>",
  "riskFactors": [
    "<specific risk factor with clinical reasoning>",
    ...
  ],
  "recommendations": [
    "<specific actionable recommendation for the health worker>",
    ...
  ]
}

Risk level definitions:
- LOW (0-30): Routine care, no immediate concerns
- MEDIUM (31-60): Increased monitoring needed, schedule earlier follow-up
- HIGH (61-80): Urgent attention required, consider referral
- CRITICAL (81-100): Immediate action required, emergency referral
''';

class RiskAssessmentService {
  final GeminiService _gemini;

  RiskAssessmentService(this._gemini);

  /// Assess patient risk using full clinical context.
  Future<AiRiskAssessment> assessPatientRisk({
    required MaternalProfile profile,
    required List<ANCVisit> ancVisits,
    required List<LabResult> labResults,
    List<NutritionRecord> nutritionRecords = const [],
    List<Appointment> appointments = const [],
  }) async {
    final context = PatientContextBuilder.buildMaternalContext(
      profile: profile,
      ancVisits: ancVisits,
      labResults: labResults,
      nutritionRecords: nutritionRecords,
      appointments: appointments,
    );

    final prompt = '''$_riskAssessmentSystemPrompt

$context

Assess this patient's risk and respond with JSON only.''';

    final responseText = await _gemini.generateText(prompt);
    return AiRiskAssessment.fromGeminiResponse(profile.id ?? '', responseText);
  }
}
