// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'deworming_record.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$DewormingRecordImpl _$$DewormingRecordImplFromJson(
        Map<String, dynamic> json) =>
    _$DewormingRecordImpl(
      id: json['id'] as String?,
      childId: json['child_profile_id'] as String,
      dateGiven: DateTime.parse(json['date_given'] as String),
      ageInMonths: (json['age_in_months'] as num).toInt(),
      doseNumber: (json['dose_number'] as num?)?.toInt(),
      drugName: json['drug_name'] as String,
      dosage: json['dosage'] as String,
      givenBy: json['given_by'] as String?,
      healthFacilityName: json['health_facility'] as String?,
      sideEffectsReported: json['side_effects_reported'] as bool? ?? false,
      sideEffectsDescription: json['side_effects_description'] as String?,
      nextDoseDate: json['next_dose_due_date'] == null
          ? null
          : DateTime.parse(json['next_dose_due_date'] as String),
      notes: json['notes'] as String?,
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
      updatedAt: json['updated_at'] == null
          ? null
          : DateTime.parse(json['updated_at'] as String),
    );

Map<String, dynamic> _$$DewormingRecordImplToJson(
        _$DewormingRecordImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'child_profile_id': instance.childId,
      'date_given': instance.dateGiven.toIso8601String(),
      'age_in_months': instance.ageInMonths,
      'dose_number': instance.doseNumber,
      'drug_name': instance.drugName,
      'dosage': instance.dosage,
      'given_by': instance.givenBy,
      'health_facility': instance.healthFacilityName,
      'side_effects_reported': instance.sideEffectsReported,
      'side_effects_description': instance.sideEffectsDescription,
      'next_dose_due_date': instance.nextDoseDate?.toIso8601String(),
      'notes': instance.notes,
      'created_at': instance.createdAt?.toIso8601String(),
      'updated_at': instance.updatedAt?.toIso8601String(),
    };
