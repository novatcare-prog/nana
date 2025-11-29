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
    @JsonKey(name: 'id') String? id,
    @JsonKey(name: 'child_profile_id') required String childId,
    @JsonKey(name: 'vaccine_type') required ImmunizationType vaccineType,
    @JsonKey(name: 'vaccine_name') String? vaccineName,
    @JsonKey(name: 'date_given') required DateTime dateGiven,
    @JsonKey(name: 'age_in_weeks') required int ageInWeeks, // Child's age when vaccine given
    @JsonKey(name: 'age_at_vaccination_months') int? ageAtVaccinationMonths,
    @JsonKey(name: 'age_at_vaccination_weeks') int? ageAtVaccinationWeeks,
    
    // Dose Information
    @JsonKey(name: 'dose_number') int? doseNumber, // 1st, 2nd, 3rd dose
    @JsonKey(name: 'dosage') String? dosage, // e.g., "0.05ml", "0.5ml", "2 drops"
    @JsonKey(name: 'route') String? administrationRoute, // Oral, IM, Intradermal, Subcutaneous
    @JsonKey(name: 'site') String? administrationSite, // Left forearm, Right thigh, etc.
    
    // Vaccine Details
    @JsonKey(name: 'batch_number') String? batchNumber,
    @JsonKey(name: 'manufacturer') String? manufacturer,
    @JsonKey(name: 'manufacture_date') DateTime? manufactureDate,
    @JsonKey(name: 'expiry_date') DateTime? expiryDate,
    
    // Location
    @JsonKey(name: 'health_facility') String? healthFacilityName,
    
    // BCG Specific
    @JsonKey(name: 'bcg_scar_checked') bool? bcgScarChecked,
    @JsonKey(name: 'bcg_scar_present') bool? bcgScarPresent,
    @JsonKey(name: 'bcg_scar_check_date') DateTime? bcgScarCheckDate,
    
    // Administration
    @JsonKey(name: 'administered_by') String? givenBy, // Health worker name
    
    // AEFI (Adverse Events Following Immunization)
    @JsonKey(name: 'adverse_reaction') @Default(false) bool adverseEventReported,
    @JsonKey(name: 'reaction_details') String? adverseEventDescription,
    @JsonKey(name: 'reaction_severity') String? reactionSeverity,
    @JsonKey(name: 'reaction_reported') @Default(false) bool reactionReportedToAuthority,
    
    // Schedule Status
    @JsonKey(name: 'given_on_schedule') @Default(true) bool givenOnSchedule,
    @JsonKey(name: 'reason_for_delay') String? reasonForDelay,
    @JsonKey(name: 'catch_up_dose') @Default(false) bool catchUpDose,
    
    // Next Due
    @JsonKey(name: 'next_dose_due_date') DateTime? nextDoseDate,
    @JsonKey(name: 'next_vaccine_due') String? nextVaccineDue,
    
    // Notes
    @JsonKey(name: 'notes') String? notes,
    
    @JsonKey(name: 'created_at') DateTime? createdAt,
    @JsonKey(name: 'updated_at') DateTime? updatedAt,
  }) = _ImmunizationRecord;

  factory ImmunizationRecord.fromJson(Map<String, dynamic> json) =>
      _$ImmunizationRecordFromJson(json);
}