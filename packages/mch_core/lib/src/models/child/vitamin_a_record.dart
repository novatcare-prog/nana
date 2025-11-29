import 'package:freezed_annotation/freezed_annotation.dart';

part 'vitamin_a_record.freezed.dart';
part 'vitamin_a_record.g.dart';

/// Vitamin A Supplementation - MCH Handbook Page 37
/// Schedule: Every 6 months from 6 months to 59 months (5 years)
/// Dosage: 100,000 IU at 6m, 200,000 IU from 12m onwards
@freezed
class VitaminARecord with _$VitaminARecord {
  const factory VitaminARecord({
    @JsonKey(name: 'id') String? id,
    @JsonKey(name: 'child_profile_id') required String childId,
    @JsonKey(name: 'date_given') required DateTime dateGiven,
    @JsonKey(name: 'age_in_months') required int ageInMonths,
    @JsonKey(name: 'dose_number') int? doseNumber,
    
    // Dosage
    @JsonKey(name: 'dosage_iu') required int dosageIU, // 100,000 or 200,000
    
    // Administration
    @JsonKey(name: 'given_by') String? givenBy,
    @JsonKey(name: 'health_facility') String? healthFacilityName,
    
    // Next Due
    @JsonKey(name: 'next_dose_due_date') DateTime? nextDoseDate, // 6 months later
    
    // Notes
    @JsonKey(name: 'notes') String? notes,
    
    @JsonKey(name: 'created_at') DateTime? createdAt,
    @JsonKey(name: 'updated_at') DateTime? updatedAt,
  }) = _VitaminARecord;

  factory VitaminARecord.fromJson(Map<String, dynamic> json) =>
      _$VitaminARecordFromJson(json);
}