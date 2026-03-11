import 'dart:convert';

/// Result of an AI risk assessment for a maternal patient.
class AiRiskAssessment {
  final String patientId;
  final RiskLevel riskLevel;
  final int riskScore; // 0-100
  final List<String> riskFactors;
  final List<String> recommendations;
  final String summary;
  final DateTime assessedAt;
  final bool isFromCache;

  AiRiskAssessment({
    required this.patientId,
    required this.riskLevel,
    required this.riskScore,
    required this.riskFactors,
    required this.recommendations,
    required this.summary,
    required this.assessedAt,
    this.isFromCache = false,
  });

  AiRiskAssessment copyWith({bool? isFromCache}) => AiRiskAssessment(
        patientId: patientId,
        riskLevel: riskLevel,
        riskScore: riskScore,
        riskFactors: riskFactors,
        recommendations: recommendations,
        summary: summary,
        assessedAt: assessedAt,
        isFromCache: isFromCache ?? this.isFromCache,
      );

  /// Parse from Gemini JSON output.
  factory AiRiskAssessment.fromGeminiResponse(String patientId, String responseText) {
    try {
      // Strip markdown code fences if present
      final cleaned = responseText
          .replaceAll(RegExp(r'```json\s*'), '')
          .replaceAll(RegExp(r'```\s*'), '')
          .trim();

      final json = jsonDecode(cleaned) as Map<String, dynamic>;
      final levelStr = (json['riskLevel'] as String? ?? 'LOW').toUpperCase();

      return AiRiskAssessment(
        patientId: patientId,
        riskLevel: RiskLevel.values.firstWhere(
          (e) => e.name.toUpperCase() == levelStr,
          orElse: () => RiskLevel.low,
        ),
        riskScore: (json['riskScore'] as num?)?.toInt() ?? 0,
        riskFactors: List<String>.from(json['riskFactors'] as List? ?? []),
        recommendations: List<String>.from(json['recommendations'] as List? ?? []),
        summary: json['summary'] as String? ?? '',
        assessedAt: DateTime.now(),
      );
    } catch (_) {
      // Graceful fallback if JSON parsing fails
      return AiRiskAssessment(
        patientId: patientId,
        riskLevel: RiskLevel.unknown,
        riskScore: 0,
        riskFactors: [],
        recommendations: ['Could not parse AI response. Please retry.'],
        summary: responseText.length > 200 ? responseText.substring(0, 200) : responseText,
        assessedAt: DateTime.now(),
      );
    }
  }
}

enum RiskLevel { low, medium, high, critical, unknown }

extension RiskLevelDisplay on RiskLevel {
  String get label {
    switch (this) {
      case RiskLevel.low:
        return 'LOW RISK';
      case RiskLevel.medium:
        return 'MEDIUM RISK';
      case RiskLevel.high:
        return 'HIGH RISK';
      case RiskLevel.critical:
        return 'CRITICAL';
      case RiskLevel.unknown:
        return 'UNKNOWN';
    }
  }
}
