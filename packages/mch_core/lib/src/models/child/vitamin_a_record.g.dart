// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vitamin_a_record.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$VitaminARecordImpl _$$VitaminARecordImplFromJson(Map<String, dynamic> json) =>
    _$VitaminARecordImpl(
      id: json['id'] as String?,
      childId: json['child_profile_id'] as String,
      dateGiven: DateTime.parse(json['date_given'] as String),
      ageInMonths: (json['age_in_months'] as num).toInt(),
      doseNumber: (json['dose_number'] as num?)?.toInt(),
      dosageIU: (json['dosage_iu'] as num).toInt(),
      givenBy: json['given_by'] as String?,
      healthFacilityName: json['health_facility'] as String?,
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

Map<String, dynamic> _$$VitaminARecordImplToJson(
        _$VitaminARecordImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'child_profile_id': instance.childId,
      'date_given': instance.dateGiven.toIso8601String(),
      'age_in_months': instance.ageInMonths,
      'dose_number': instance.doseNumber,
      'dosage_iu': instance.dosageIU,
      'given_by': instance.givenBy,
      'health_facility': instance.healthFacilityName,
      'next_dose_due_date': instance.nextDoseDate?.toIso8601String(),
      'notes': instance.notes,
      'created_at': instance.createdAt?.toIso8601String(),
      'updated_at': instance.updatedAt?.toIso8601String(),
    };
