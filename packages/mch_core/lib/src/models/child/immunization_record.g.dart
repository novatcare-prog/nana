// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'immunization_record.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ImmunizationRecordImpl _$$ImmunizationRecordImplFromJson(
        Map<String, dynamic> json) =>
    _$ImmunizationRecordImpl(
      id: json['id'] as String,
      childId: json['childId'] as String,
      vaccineType: $enumDecode(_$ImmunizationTypeEnumMap, json['vaccineType']),
      dateGiven: DateTime.parse(json['dateGiven'] as String),
      ageInWeeks: (json['ageInWeeks'] as num).toInt(),
      doseNumber: (json['doseNumber'] as num?)?.toInt(),
      dosage: json['dosage'] as String?,
      administrationRoute: json['administrationRoute'] as String?,
      administrationSite: json['administrationSite'] as String?,
      batchNumber: json['batchNumber'] as String?,
      manufacturer: json['manufacturer'] as String?,
      manufactureDate: json['manufactureDate'] == null
          ? null
          : DateTime.parse(json['manufactureDate'] as String),
      expiryDate: json['expiryDate'] == null
          ? null
          : DateTime.parse(json['expiryDate'] as String),
      bcgScarChecked: json['bcgScarChecked'] as bool?,
      bcgScarPresent: json['bcgScarPresent'] as bool?,
      bcgScarCheckDate: json['bcgScarCheckDate'] == null
          ? null
          : DateTime.parse(json['bcgScarCheckDate'] as String),
      givenBy: json['givenBy'] as String?,
      healthFacilityName: json['healthFacilityName'] as String?,
      adverseEventReported: json['adverseEventReported'] as bool?,
      adverseEventDescription: json['adverseEventDescription'] as String?,
      adverseEventDate: json['adverseEventDate'] == null
          ? null
          : DateTime.parse(json['adverseEventDate'] as String),
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

Map<String, dynamic> _$$ImmunizationRecordImplToJson(
        _$ImmunizationRecordImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'childId': instance.childId,
      'vaccineType': _$ImmunizationTypeEnumMap[instance.vaccineType]!,
      'dateGiven': instance.dateGiven.toIso8601String(),
      'ageInWeeks': instance.ageInWeeks,
      'doseNumber': instance.doseNumber,
      'dosage': instance.dosage,
      'administrationRoute': instance.administrationRoute,
      'administrationSite': instance.administrationSite,
      'batchNumber': instance.batchNumber,
      'manufacturer': instance.manufacturer,
      'manufactureDate': instance.manufactureDate?.toIso8601String(),
      'expiryDate': instance.expiryDate?.toIso8601String(),
      'bcgScarChecked': instance.bcgScarChecked,
      'bcgScarPresent': instance.bcgScarPresent,
      'bcgScarCheckDate': instance.bcgScarCheckDate?.toIso8601String(),
      'givenBy': instance.givenBy,
      'healthFacilityName': instance.healthFacilityName,
      'adverseEventReported': instance.adverseEventReported,
      'adverseEventDescription': instance.adverseEventDescription,
      'adverseEventDate': instance.adverseEventDate?.toIso8601String(),
      'nextDoseDate': instance.nextDoseDate?.toIso8601String(),
      'notes': instance.notes,
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
    };

const _$ImmunizationTypeEnumMap = {
  ImmunizationType.bcg: 'bcg',
  ImmunizationType.bopv: 'bopv',
  ImmunizationType.ipv: 'ipv',
  ImmunizationType.pentavalent: 'pentavalent',
  ImmunizationType.pcv10: 'pcv10',
  ImmunizationType.rotavirus: 'rotavirus',
  ImmunizationType.measlesRubella: 'measlesRubella',
  ImmunizationType.yellowFever: 'yellowFever',
};
