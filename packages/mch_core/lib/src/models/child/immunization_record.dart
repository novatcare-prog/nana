import 'package:freezed_annotation/freezed_annotation.dart';
import '../../enums/immunization_type.dart';

part 'immunization_record.freezed.dart';
part 'immunization_record.g.dart';

/// Immunization Record - MCH Handbook Pages 33-34
/// Schedule:
/// - BCG: At birth
/// - bOPV: Birth, 6w, 10w, 14w
/// - Pentavalent: 6w, 10w, 14w
/// - PCV10: 6w, 10w, 14w
/// - Rotavirus: 6w, 10w
/// - IPV: 14w
/// - Measles-Rubella: 6m (outbreak/HEI), 9m, 18m
/// - Yellow Fever: 9m (selected counties)
@freezed
class ImmunizationRecord with _$ImmunizationRecord {
  const factory ImmunizationRecord({
    required String id,
    required String childId,
    required ImmunizationType vaccineType,
    required DateTime dateGiven,
    required int ageInWeeks, // Child's age when vaccine given
    
    // Dose Information
    int? doseNumber, // 1st, 2nd, 3rd dose
    String? dosage, // e.g., "0.05ml", "0.5ml", "2 drops"
    String? administrationRoute, // Oral, IM, Intradermal, Subcutaneous
    String? administrationSite, // Left forearm, Right thigh, etc.
    
    // Vaccine Details
    String? batchNumber,
    String? manufacturer,
    DateTime? manufactureDate,
    DateTime? expiryDate,
    
    // BCG Specific
    bool? bcgScarChecked,
    bool? bcgScarPresent,
    DateTime? bcgScarCheckDate,
    
    // Administration
    String? givenBy, // Health worker name
    String? healthFacilityName,
    
    // AEFI (Adverse Events Following Immunization)
    bool? adverseEventReported,
    String? adverseEventDescription,
    DateTime? adverseEventDate,
    
    // Next Due
    DateTime? nextDoseDate,
    
    // Notes
    String? notes,
    
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _ImmunizationRecord;

  factory ImmunizationRecord.fromJson(Map<String, dynamic> json) =>
      _$ImmunizationRecordFromJson(json);
}