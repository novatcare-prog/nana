// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'maternal_profile.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$MaternalProfileImpl _$$MaternalProfileImplFromJson(
        Map<String, dynamic> json) =>
    _$MaternalProfileImpl(
      id: json['id'] as String? ?? '',
      facilityId: json['facilityId'] as String? ?? '',
      kmhflCode: json['kmhflCode'] as String? ?? '',
      facilityName: json['facilityName'] as String? ?? '',
      ancNumber: json['ancNumber'] as String? ?? '',
      pncNumber: json['pncNumber'] as String?,
      clientName: json['clientName'] as String? ?? '',
      idNumber: json['idNumber'] as String?,
      age: (json['age'] as num?)?.toInt() ?? 0,
      telephone: json['telephone'] as String?,
      county: json['county'] as String?,
      subCounty: json['subCounty'] as String?,
      ward: json['ward'] as String?,
      village: json['village'] as String?,
      gravida: (json['gravida'] as num?)?.toInt() ?? 0,
      parity: (json['parity'] as num?)?.toInt() ?? 0,
      heightCm: (json['heightCm'] as num?)?.toDouble() ?? 0.0,
      weightKg: (json['weightKg'] as num?)?.toDouble() ?? 0.0,
      lmp: json['lmp'] == null ? null : DateTime.parse(json['lmp'] as String),
      edd: json['edd'] == null ? null : DateTime.parse(json['edd'] as String),
      gestationAtFirstVisit: (json['gestationAtFirstVisit'] as num?)?.toInt(),
      bloodGroup: $enumDecodeNullable(_$BloodGroupEnumMap, json['bloodGroup']),
      diabetes: json['diabetes'] as bool?,
      hypertension: json['hypertension'] as bool?,
      tuberculosis: json['tuberculosis'] as bool?,
      bloodTransfusion: json['bloodTransfusion'] as bool?,
      drugAllergy: json['drugAllergy'] as bool?,
      allergyDetails: json['allergyDetails'] as String?,
      previousCs: json['previousCs'] as bool?,
      previousCsCount: (json['previousCsCount'] as num?)?.toInt(),
      bleedingHistory: json['bleedingHistory'] as bool?,
      stillbirths: (json['stillbirths'] as num?)?.toInt(),
      neonatalDeaths: (json['neonatalDeaths'] as num?)?.toInt(),
      fgmDone: json['fgmDone'] as bool?,
      hivResult: $enumDecodeNullable(_$HivTestResultEnumMap, json['hivResult']),
      testedForSyphilis: json['testedForSyphilis'] as bool?,
      syphilisResult:
          $enumDecodeNullable(_$HivTestResultEnumMap, json['syphilisResult']),
      testedForHepatitisB: json['testedForHepatitisB'] as bool?,
      hepatitisBResult:
          $enumDecodeNullable(_$HivTestResultEnumMap, json['hepatitisBResult']),
      partnerTestedForHiv: json['partnerTestedForHiv'] as bool?,
      partnerHivStatus:
          $enumDecodeNullable(_$HivTestResultEnumMap, json['partnerHivStatus']),
      nextOfKinName: json['nextOfKinName'] as String?,
      nextOfKinRelationship: json['nextOfKinRelationship'] as String?,
      nextOfKinPhone: json['nextOfKinPhone'] as String?,
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$$MaternalProfileImplToJson(
        _$MaternalProfileImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'facilityId': instance.facilityId,
      'kmhflCode': instance.kmhflCode,
      'facilityName': instance.facilityName,
      'ancNumber': instance.ancNumber,
      'pncNumber': instance.pncNumber,
      'clientName': instance.clientName,
      'idNumber': instance.idNumber,
      'age': instance.age,
      'telephone': instance.telephone,
      'county': instance.county,
      'subCounty': instance.subCounty,
      'ward': instance.ward,
      'village': instance.village,
      'gravida': instance.gravida,
      'parity': instance.parity,
      'heightCm': instance.heightCm,
      'weightKg': instance.weightKg,
      'lmp': instance.lmp?.toIso8601String(),
      'edd': instance.edd?.toIso8601String(),
      'gestationAtFirstVisit': instance.gestationAtFirstVisit,
      'bloodGroup': _$BloodGroupEnumMap[instance.bloodGroup],
      'diabetes': instance.diabetes,
      'hypertension': instance.hypertension,
      'tuberculosis': instance.tuberculosis,
      'bloodTransfusion': instance.bloodTransfusion,
      'drugAllergy': instance.drugAllergy,
      'allergyDetails': instance.allergyDetails,
      'previousCs': instance.previousCs,
      'previousCsCount': instance.previousCsCount,
      'bleedingHistory': instance.bleedingHistory,
      'stillbirths': instance.stillbirths,
      'neonatalDeaths': instance.neonatalDeaths,
      'fgmDone': instance.fgmDone,
      'hivResult': _$HivTestResultEnumMap[instance.hivResult],
      'testedForSyphilis': instance.testedForSyphilis,
      'syphilisResult': _$HivTestResultEnumMap[instance.syphilisResult],
      'testedForHepatitisB': instance.testedForHepatitisB,
      'hepatitisBResult': _$HivTestResultEnumMap[instance.hepatitisBResult],
      'partnerTestedForHiv': instance.partnerTestedForHiv,
      'partnerHivStatus': _$HivTestResultEnumMap[instance.partnerHivStatus],
      'nextOfKinName': instance.nextOfKinName,
      'nextOfKinRelationship': instance.nextOfKinRelationship,
      'nextOfKinPhone': instance.nextOfKinPhone,
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
    };

const _$BloodGroupEnumMap = {
  BloodGroup.aPositive: 'aPositive',
  BloodGroup.aNegative: 'aNegative',
  BloodGroup.bPositive: 'bPositive',
  BloodGroup.bNegative: 'bNegative',
  BloodGroup.oPositive: 'oPositive',
  BloodGroup.oNegative: 'oNegative',
  BloodGroup.abPositive: 'abPositive',
  BloodGroup.abNegative: 'abNegative',
};

const _$HivTestResultEnumMap = {
  HivTestResult.reactive: 'reactive',
  HivTestResult.nonReactive: 'nonReactive',
  HivTestResult.notTested: 'notTested',
  HivTestResult.inconclusive: 'inconclusive',
};
