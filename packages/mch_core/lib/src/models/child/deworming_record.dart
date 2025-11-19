import 'package:freezed_annotation/freezed_annotation.dart';

part 'deworming_record.freezed.dart';
part 'deworming_record.g.dart';

/// Deworming Record - MCH Handbook Page 35
/// Schedule: Every 6 months from 12 months (1 year) to 59 months (5 years)
/// Dosage: Albendazole 200mg (half tablet) for 1-2 years, 400mg (one tablet) for 2+ years
@freezed
class DewormingRecord with _$DewormingRecord {
  const factory DewormingRecord({
    required String id,
    required String childId,
    required DateTime dateGiven,
    required int ageInMonths,
    
    // Dosage
    required String dosage, // "200mg" or "400mg"
    required String tabletCount, // "Half tablet" or "One tablet"
    
    // Administration
    String? givenBy,
    String? healthFacilityName,
    
    // Next Due
    DateTime? nextDoseDate, // 6 months later
    
    // Notes
    String? notes,
    
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _DewormingRecord;

  factory DewormingRecord.fromJson(Map<String, dynamic> json) =>
      _$DewormingRecordFromJson(json);
}