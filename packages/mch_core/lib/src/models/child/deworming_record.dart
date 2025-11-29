import 'package:freezed_annotation/freezed_annotation.dart';

part 'deworming_record.freezed.dart';
part 'deworming_record.g.dart';

/// Deworming - MCH Handbook Page 38
/// Schedule: Every 6 months from 12 months to 59 months
/// Drugs: Albendazole 400mg or Mebendazole 500mg
@freezed
class DewormingRecord with _$DewormingRecord {
  const factory DewormingRecord({
    @JsonKey(name: 'id') String? id,
    @JsonKey(name: 'child_profile_id') required String childId,
    @JsonKey(name: 'date_given') required DateTime dateGiven,
    @JsonKey(name: 'age_in_months') required int ageInMonths,
    @JsonKey(name: 'dose_number') int? doseNumber,
    
    // Drug Information
    @JsonKey(name: 'drug_name') required String drugName, // Albendazole or Mebendazole
    @JsonKey(name: 'dosage') required String dosage, // "400mg" or "500mg"
    
    // Administration
    @JsonKey(name: 'given_by') String? givenBy,
    @JsonKey(name: 'health_facility') String? healthFacilityName,
    
    // Side Effects
    @JsonKey(name: 'side_effects_reported') @Default(false) bool sideEffectsReported,
    @JsonKey(name: 'side_effects_description') String? sideEffectsDescription,
    
    // Next Due
    @JsonKey(name: 'next_dose_due_date') DateTime? nextDoseDate,
    
    // Notes
    @JsonKey(name: 'notes') String? notes,
    
    @JsonKey(name: 'created_at') DateTime? createdAt,
    @JsonKey(name: 'updated_at') DateTime? updatedAt,
  }) = _DewormingRecord;

  factory DewormingRecord.fromJson(Map<String, dynamic> json) =>
      _$DewormingRecordFromJson(json);
}