// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'maternal_profile.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$MaternalProfileImpl _$$MaternalProfileImplFromJson(
        Map<String, dynamic> json) =>
    _$MaternalProfileImpl(
      id: json['id'] as String? ?? '',
      facilityId: json['facility_id'] as String,
      kmhflCode: json['kmhfl_code'] as String? ?? '',
      facilityName: json['facility_name'] as String? ?? '',
      ancNumber: json['anc_number'] as String? ?? '',
      pncNumber: json['pnc_number'] as String?,
      clientName: json['client_name'] as String? ?? '',
      idNumber: json['id_number'] as String?,
      age: (json['age'] as num?)?.toInt() ?? 0,
      telephone: json['telephone'] as String?,
      county: json['county'] as String?,
      subCounty: json['sub_county'] as String?,
      ward: json['ward'] as String?,
      village: json['village'] as String?,
      gravida: (json['gravida'] as num?)?.toInt() ?? 0,
      parity: (json['parity'] as num?)?.toInt() ?? 0,
      heightCm: (json['height_cm'] as num?)?.toDouble() ?? 0.0,
      weightKg: (json['weight_kg'] as num?)?.toDouble() ?? 0.0,
      lmp: json['lmp'] == null ? null : DateTime.parse(json['lmp'] as String),
      edd: json['edd'] == null ? null : DateTime.parse(json['edd'] as String),
      gestationAtFirstVisit:
          (json['gestation_at_first_visit'] as num?)?.toInt(),
      bloodGroup: $enumDecodeNullable(_$BloodGroupEnumMap, json['blood_group']),
      diabetes: json['diabetes'] as bool?,
      hypertension: json['hypertension'] as bool?,
      tuberculosis: json['tuberculosis'] as bool?,
      bloodTransfusion: json['blood_transfusion'] as bool?,
      drugAllergy: json['drug_allergy'] as bool?,
      allergyDetails: json['allergy_details'] as String?,
      previousCs: json['previous_cs'] as bool?,
      previousCsCount: (json['previous_cs_count'] as num?)?.toInt(),
      bleedingHistory: json['bleeding_history'] as bool?,
      stillbirths: (json['stillbirths'] as num?)?.toInt(),
      neonatalDeaths: (json['neonatal_deaths'] as num?)?.toInt(),
      fgmDone: json['fgm_done'] as bool?,
      hivResult:
          $enumDecodeNullable(_$HivTestResultEnumMap, json['hiv_result']),
      testedForSyphilis: json['tested_for_syphilis'] as bool?,
      syphilisResult:
          $enumDecodeNullable(_$HivTestResultEnumMap, json['syphilis_result']),
      testedForHepatitisB: json['tested_for_hepatitis_b'] as bool?,
      hepatitisBResult: $enumDecodeNullable(
          _$HivTestResultEnumMap, json['hepatitis_b_result']),
      partnerTestedForHiv: json['partner_tested_for_hiv'] as bool?,
      partnerHivStatus: $enumDecodeNullable(
          _$HivTestResultEnumMap, json['partner_hiv_status']),
      nextOfKinName: json['next_of_kin_name'] as String?,
      nextOfKinRelationship: json['next_of_kin_relationship'] as String?,
      nextOfKinPhone: json['next_of_kin_phone'] as String?,
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
      updatedAt: json['updated_at'] == null
          ? null
          : DateTime.parse(json['updated_at'] as String),
    );

Map<String, dynamic> _$$MaternalProfileImplToJson(
        _$MaternalProfileImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'facility_id': instance.facilityId,
      'kmhfl_code': instance.kmhflCode,
      'facility_name': instance.facilityName,
      'anc_number': instance.ancNumber,
      'pnc_number': instance.pncNumber,
      'client_name': instance.clientName,
      'id_number': instance.idNumber,
      'age': instance.age,
      'telephone': instance.telephone,
      'county': instance.county,
      'sub_county': instance.subCounty,
      'ward': instance.ward,
      'village': instance.village,
      'gravida': instance.gravida,
      'parity': instance.parity,
      'height_cm': instance.heightCm,
      'weight_kg': instance.weightKg,
      'lmp': instance.lmp?.toIso8601String(),
      'edd': instance.edd?.toIso8601String(),
      'gestation_at_first_visit': instance.gestationAtFirstVisit,
      'blood_group': _$BloodGroupEnumMap[instance.bloodGroup],
      'diabetes': instance.diabetes,
      'hypertension': instance.hypertension,
      'tuberculosis': instance.tuberculosis,
      'blood_transfusion': instance.bloodTransfusion,
      'drug_allergy': instance.drugAllergy,
      'allergy_details': instance.allergyDetails,
      'previous_cs': instance.previousCs,
      'previous_cs_count': instance.previousCsCount,
      'bleeding_history': instance.bleedingHistory,
      'stillbirths': instance.stillbirths,
      'neonatal_deaths': instance.neonatalDeaths,
      'fgm_done': instance.fgmDone,
      'hiv_result': _$HivTestResultEnumMap[instance.hivResult],
      'tested_for_syphilis': instance.testedForSyphilis,
      'syphilis_result': _$HivTestResultEnumMap[instance.syphilisResult],
      'tested_for_hepatitis_b': instance.testedForHepatitisB,
      'hepatitis_b_result': _$HivTestResultEnumMap[instance.hepatitisBResult],
      'partner_tested_for_hiv': instance.partnerTestedForHiv,
      'partner_hiv_status': _$HivTestResultEnumMap[instance.partnerHivStatus],
      'next_of_kin_name': instance.nextOfKinName,
      'next_of_kin_relationship': instance.nextOfKinRelationship,
      'next_of_kin_phone': instance.nextOfKinPhone,
      'created_at': instance.createdAt?.toIso8601String(),
      'updated_at': instance.updatedAt?.toIso8601String(),
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
