// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vitamin_a_record.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$VitaminARecordImpl _$$VitaminARecordImplFromJson(Map<String, dynamic> json) =>
    _$VitaminARecordImpl(
      id: json['id'] as String,
      childId: json['childId'] as String,
      dateGiven: DateTime.parse(json['dateGiven'] as String),
      ageInMonths: (json['ageInMonths'] as num).toInt(),
      dosageIU: (json['dosageIU'] as num).toInt(),
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

Map<String, dynamic> _$$VitaminARecordImplToJson(
        _$VitaminARecordImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'childId': instance.childId,
      'dateGiven': instance.dateGiven.toIso8601String(),
      'ageInMonths': instance.ageInMonths,
      'dosageIU': instance.dosageIU,
      'givenBy': instance.givenBy,
      'healthFacilityName': instance.healthFacilityName,
      'nextDoseDate': instance.nextDoseDate?.toIso8601String(),
      'notes': instance.notes,
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
    };
