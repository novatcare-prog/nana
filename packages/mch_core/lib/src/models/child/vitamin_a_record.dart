import 'package:freezed_annotation/freezed_annotation.dart';

part 'vitamin_a_record.freezed.dart';
part 'vitamin_a_record.g.dart';

/// Vitamin A Supplementation - MCH Handbook Page 35
/// Schedule: Every 6 months from 6 months to 59 months (5 years)
/// Dosage: 100,000 IU at 6m, 200,000 IU from 12m onwards
@freezed
class VitaminARecord with _$VitaminARecord {
  const factory VitaminARecord({
    required String id,
    required String childId,
    required DateTime dateGiven,
    required int ageInMonths,
    
    // Dosage
    required int dosageIU, // 100,000 or 200,000
    
    // Administration
    String? givenBy,
    String? healthFacilityName,
    
    // Next Due
    DateTime? nextDoseDate, // 6 months later
    
    // Notes
    String? notes,
    
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _VitaminARecord;

  factory VitaminARecord.fromJson(Map<String, dynamic> json) =>
      _$VitaminARecordFromJson(json);
}