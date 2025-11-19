// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'deworming_record.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$DewormingRecordImpl _$$DewormingRecordImplFromJson(
        Map<String, dynamic> json) =>
    _$DewormingRecordImpl(
      id: json['id'] as String,
      childId: json['childId'] as String,
      dateGiven: DateTime.parse(json['dateGiven'] as String),
      ageInMonths: (json['ageInMonths'] as num).toInt(),
      dosage: json['dosage'] as String,
      tabletCount: json['tabletCount'] as String,
      givenBy: json['givenBy'] as String?,
      healthFacilityName: json['healthFacilityName'] as String?,
      nextDoseDate: json['nextDoseDate'] == null
          ? null
          : DateTime.parse(json['nextDoseDate'] as String),
      notes: json['notes'] as String?,
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$$DewormingRecordImplToJson(
        _$DewormingRecordImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'childId': instance.childId,
      'dateGiven': instance.dateGiven.toIso8601String(),
      'ageInMonths': instance.ageInMonths,
      'dosage': instance.dosage,
      'tabletCount': instance.tabletCount,
      'givenBy': instance.givenBy,
      'healthFacilityName': instance.healthFacilityName,
      'nextDoseDate': instance.nextDoseDate?.toIso8601String(),
      'notes': instance.notes,
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
    };
