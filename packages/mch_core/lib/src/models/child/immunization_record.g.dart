// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'immunization_record.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ImmunizationRecordImpl _$$ImmunizationRecordImplFromJson(
        Map<String, dynamic> json) =>
    _$ImmunizationRecordImpl(
      id: json['id'] as String?,
      childId: json['child_profile_id'] as String,
      vaccineType: $enumDecode(_$ImmunizationTypeEnumMap, json['vaccine_type']),
      vaccineName: json['vaccine_name'] as String?,
      dateGiven: DateTime.parse(json['date_given'] as String),
      ageInWeeks: (json['age_in_weeks'] as num).toInt(),
      ageAtVaccinationMonths:
          (json['age_at_vaccination_months'] as num?)?.toInt(),
      ageAtVaccinationWeeks:
          (json['age_at_vaccination_weeks'] as num?)?.toInt(),
      doseNumber: (json['dose_number'] as num?)?.toInt(),
      dosage: json['dosage'] as String?,
      administrationRoute: json['route'] as String?,
      administrationSite: json['site'] as String?,
      batchNumber: json['batch_number'] as String?,
      manufacturer: json['manufacturer'] as String?,
      manufactureDate: json['manufacture_date'] == null
          ? null
          : DateTime.parse(json['manufacture_date'] as String),
      expiryDate: json['expiry_date'] == null
          ? null
          : DateTime.parse(json['expiry_date'] as String),
      healthFacilityName: json['health_facility'] as String?,
      bcgScarChecked: json['bcg_scar_checked'] as bool?,
      bcgScarPresent: json['bcg_scar_present'] as bool?,
      bcgScarCheckDate: json['bcg_scar_check_date'] == null
          ? null
          : DateTime.parse(json['bcg_scar_check_date'] as String),
      givenBy: json['administered_by'] as String?,
      adverseEventReported: json['adverse_reaction'] as bool? ?? false,
      adverseEventDescription: json['reaction_details'] as String?,
      reactionSeverity: json['reaction_severity'] as String?,
      reactionReportedToAuthority: json['reaction_reported'] as bool? ?? false,
      givenOnSchedule: json['given_on_schedule'] as bool? ?? true,
      reasonForDelay: json['reason_for_delay'] as String?,
      catchUpDose: json['catch_up_dose'] as bool? ?? false,
      nextDoseDate: json['next_dose_due_date'] == null
          ? null
          : DateTime.parse(json['next_dose_due_date'] as String),
      nextVaccineDue: json['next_vaccine_due'] as String?,
      notes: json['notes'] as String?,
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
      updatedAt: json['updated_at'] == null
          ? null
          : DateTime.parse(json['updated_at'] as String),
    );

Map<String, dynamic> _$$ImmunizationRecordImplToJson(
        _$ImmunizationRecordImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'child_profile_id': instance.childId,
      'vaccine_type': _$ImmunizationTypeEnumMap[instance.vaccineType]!,
      'vaccine_name': instance.vaccineName,
      'date_given': instance.dateGiven.toIso8601String(),
      'age_in_weeks': instance.ageInWeeks,
      'age_at_vaccination_months': instance.ageAtVaccinationMonths,
      'age_at_vaccination_weeks': instance.ageAtVaccinationWeeks,
      'dose_number': instance.doseNumber,
      'dosage': instance.dosage,
      'route': instance.administrationRoute,
      'site': instance.administrationSite,
      'batch_number': instance.batchNumber,
      'manufacturer': instance.manufacturer,
      'manufacture_date': instance.manufactureDate?.toIso8601String(),
      'expiry_date': instance.expiryDate?.toIso8601String(),
      'health_facility': instance.healthFacilityName,
      'bcg_scar_checked': instance.bcgScarChecked,
      'bcg_scar_present': instance.bcgScarPresent,
      'bcg_scar_check_date': instance.bcgScarCheckDate?.toIso8601String(),
      'administered_by': instance.givenBy,
      'adverse_reaction': instance.adverseEventReported,
      'reaction_details': instance.adverseEventDescription,
      'reaction_severity': instance.reactionSeverity,
      'reaction_reported': instance.reactionReportedToAuthority,
      'given_on_schedule': instance.givenOnSchedule,
      'reason_for_delay': instance.reasonForDelay,
      'catch_up_dose': instance.catchUpDose,
      'next_dose_due_date': instance.nextDoseDate?.toIso8601String(),
      'next_vaccine_due': instance.nextVaccineDue,
      'notes': instance.notes,
      'created_at': instance.createdAt?.toIso8601String(),
      'updated_at': instance.updatedAt?.toIso8601String(),
    };

const _$ImmunizationTypeEnumMap = {
  ImmunizationType.bcg: 'BCG',
  ImmunizationType.bopv: 'bOPV',
  ImmunizationType.ipv: 'IPV',
  ImmunizationType.pentavalent: 'Pentavalent',
  ImmunizationType.pcv10: 'PCV10',
  ImmunizationType.rotavirus: 'Rotavirus',
  ImmunizationType.measlesRubella: 'Measles-Rubella',
  ImmunizationType.yellowFever: 'Yellow Fever',
};
