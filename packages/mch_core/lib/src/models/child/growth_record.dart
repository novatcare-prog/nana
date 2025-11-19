import 'package:freezed_annotation/freezed_annotation.dart';

part 'growth_record.freezed.dart';
part 'growth_record.g.dart';

/// Growth Monitoring Record - MCH Handbook Pages 27-30
/// Tracks weight and height from birth to 5 years (60 months)
@freezed
class GrowthRecord with _$GrowthRecord {
  const factory GrowthRecord({
    required String id,
    required String childId,
    required DateTime measurementDate,
    required int ageInMonths,
    
    // Weight Measurement
    required double weightKg,
    String? weightForAgeZScore, // +3, +2, +1, -1, -2, -3
    String? weightInterpretation, // Good, Danger, Very Dangerous
    
    // Length/Height Measurement
    required double lengthHeightCm,
    bool? measuredLying, // True = length (lying), False = height (standing)
    String? heightForAgeZScore, // +3, +2, +1, -1, -2, -3
    String? heightInterpretation, // Good, Dangerous
    
    // MUAC (Mid-Upper Arm Circumference) - for children 6-59 months
    double? muacCm,
    String? muacInterpretation,
    
    // Edema (for malnutrition screening)
    bool? edemaPresent,
    String? edemaGrade, // +, ++, +++
    
    // Nutritional Status
    String? nutritionalStatus, // Well-nourished, Moderate malnutrition, Severe malnutrition
    bool? referredForNutrition,
    
    // Counseling Given
    bool? feedingCounselingGiven,
    String? feedingRecommendations,
    
    // Clinical Notes
    String? notes,
    String? measuredBy,
    
    // Next Visit
    DateTime? nextVisitDate,
    
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _GrowthRecord;

  factory GrowthRecord.fromJson(Map<String, dynamic> json) =>
      _$GrowthRecordFromJson(json);
}