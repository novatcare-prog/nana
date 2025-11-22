import 'package:freezed_annotation/freezed_annotation.dart';

part 'nutrition_record.freezed.dart';
part 'nutrition_record.g.dart';

/// Supplement Types
enum SupplementType {
  @JsonValue('iron_folate')
  ironFolate,
  @JsonValue('calcium')
  calcium,
  @JsonValue('deworming')
  deworming,
  @JsonValue('vitamin_a')
  vitaminA,
}

/// Nutrition Record - Supplements, MUAC, Counseling
/// Based on MCH Handbook 2020 - Section 7
@freezed
class NutritionRecord with _$NutritionRecord {
  const factory NutritionRecord({
    String? id,
    @JsonKey(name: 'maternal_profile_id') required String maternalProfileId,
    @JsonKey(name: 'patient_name') @Default('') String patientName,
    @JsonKey(name: 'anc_visit_id') String? ancVisitId,
    @JsonKey(name: 'record_date') required DateTime recordDate,
    
    // MUAC (Mid-Upper Arm Circumference)
    @JsonKey(name: 'muac_cm') double? muacCm,
    @JsonKey(name: 'is_malnourished') @Default(false) bool isMalnourished, // <23cm
    
    // Iron/Folate
    @JsonKey(name: 'iron_folate_given') @Default(false) bool ironFolateGiven,
    @JsonKey(name: 'iron_folate_tablets') int? ironFolateTablets, // Number of tablets given
    
    // Calcium
    @JsonKey(name: 'calcium_given') @Default(false) bool calciumGiven,
    @JsonKey(name: 'calcium_tablets') int? calciumTablets,
    
    // Deworming
    @JsonKey(name: 'deworming_given') @Default(false) bool dewormingGiven,
    @JsonKey(name: 'deworming_drug') String? dewormingDrug, // Albendazole/Mebendazole
    
    // Counseling
    @JsonKey(name: 'nutrition_counseling_given') @Default(false) bool nutritionCounselingGiven,
    @JsonKey(name: 'counseling_topics') String? counselingTopics, // JSON array of topics
    
    String? notes,
    
    @JsonKey(name: 'facility_id') required String facilityId,
    @JsonKey(name: 'facility_name') @Default('') String facilityName,
    @JsonKey(name: 'recorded_by') required String recordedBy,
    @JsonKey(name: 'recorded_by_name') String? recordedByName,
    @JsonKey(name: 'created_at') DateTime? createdAt,
    @JsonKey(name: 'updated_at') DateTime? updatedAt,
  }) = _NutritionRecord;

  factory NutritionRecord.fromJson(Map<String, dynamic> json) =>
      _$NutritionRecordFromJson(json);
}

/// MUAC Measurement (separate tracking)
@freezed
class MuacMeasurement with _$MuacMeasurement {
  const factory MuacMeasurement({
    String? id,
    @JsonKey(name: 'maternal_profile_id') required String maternalProfileId,
    @JsonKey(name: 'patient_name') @Default('') String patientName,
    @JsonKey(name: 'measurement_date') required DateTime measurementDate,
    @JsonKey(name: 'muac_cm') required double muacCm,
    @JsonKey(name: 'is_malnourished') required bool isMalnourished,
    @JsonKey(name: 'gestation_weeks') int? gestationWeeks,
    String? notes,
    @JsonKey(name: 'facility_id') required String facilityId,
    @JsonKey(name: 'recorded_by') required String recordedBy,
    @JsonKey(name: 'recorded_by_name') String? recordedByName,
    @JsonKey(name: 'created_at') DateTime? createdAt,
    @JsonKey(name: 'updated_at') DateTime? updatedAt,
  }) = _MuacMeasurement;

  factory MuacMeasurement.fromJson(Map<String, dynamic> json) =>
      _$MuacMeasurementFromJson(json);
}