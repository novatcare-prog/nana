import 'package:freezed_annotation/freezed_annotation.dart';

part 'growth_record.freezed.dart';
part 'growth_record.g.dart';

/// Growth Monitoring Record - MCH Handbook Pages 27-30
/// Tracks weight and height from birth to 5 years (60 months)
@freezed
class GrowthRecord with _$GrowthRecord {
  const factory GrowthRecord({
    @JsonKey(name: 'id') String? id,
    @JsonKey(name: 'child_profile_id') required String childId,
    @JsonKey(name: 'visit_date') required DateTime measurementDate,
    @JsonKey(name: 'age_in_months') required int ageInMonths,
    
    // Weight Measurement
    @JsonKey(name: 'weight_kg') required double weightKg,
    @JsonKey(name: 'weight_for_age_z_score') double? weightForAgeZScore,
    @JsonKey(name: 'weight_interpretation') String? weightInterpretation,
    
    // Length/Height Measurement
    @JsonKey(name: 'length_cm') double? lengthCm, // For < 2 years (lying)
    @JsonKey(name: 'height_cm') double? heightCm, // For >= 2 years (standing)
    @JsonKey(name: 'measured_lying') bool? measuredLying,
    @JsonKey(name: 'height_for_age_z_score') double? heightForAgeZScore,
    @JsonKey(name: 'height_interpretation') String? heightInterpretation,
    
    // Additional Z-scores
    @JsonKey(name: 'weight_for_height_z_score') double? weightForHeightZScore,
    @JsonKey(name: 'bmi_for_age_z_score') double? bmiForAgeZScore,
    
    // MUAC (Mid-Upper Arm Circumference)
    @JsonKey(name: 'muac_cm') double? muacCm,
    @JsonKey(name: 'muac_interpretation') String? muacInterpretation,
    
    // Head Circumference
    @JsonKey(name: 'head_circumference_cm') double? headCircumferenceCm,
    
    // Edema (for malnutrition screening)
    @JsonKey(name: 'edema_present') @Default(false) bool edemaPresent,
    @JsonKey(name: 'edema_grade') String? edemaGrade,
    
    // Nutritional Status
    @JsonKey(name: 'nutritional_status') String? nutritionalStatus,
    @JsonKey(name: 'growth_assessment') String? growthAssessment,
    @JsonKey(name: 'referred_for_nutrition') bool? referredForNutrition,
    
    // Counseling Given
    @JsonKey(name: 'feeding_counseling_given') bool? feedingCounselingGiven,
    @JsonKey(name: 'feeding_recommendations') String? feedingRecommendations,
    
    // Clinical Notes
    @JsonKey(name: 'concerns') String? concerns,
    @JsonKey(name: 'interventions') String? interventions,
    @JsonKey(name: 'next_visit_date') DateTime? nextVisitDate,
    
    // Health Worker Info
    @JsonKey(name: 'recorded_by') String? recordedBy,
    @JsonKey(name: 'health_facility') String? healthFacility,
    
    // Legacy/Additional fields
    @JsonKey(name: 'notes') String? notes,
    @JsonKey(name: 'measured_by') String? measuredBy,
    
    @JsonKey(name: 'created_at') DateTime? createdAt,
    @JsonKey(name: 'updated_at') DateTime? updatedAt,
  }) = _GrowthRecord;

  factory GrowthRecord.fromJson(Map<String, dynamic> json) =>
      _$GrowthRecordFromJson(json);
}