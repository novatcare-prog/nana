import 'package:freezed_annotation/freezed_annotation.dart';
import '../../enums/blood_group.dart';
import '../../enums/hiv_test_result.dart';

part 'maternal_profile.freezed.dart';
part 'maternal_profile.g.dart';

@freezed
class MaternalProfile with _$MaternalProfile {
  const factory MaternalProfile({
    @Default('') String? id,
  @JsonKey(name: 'facility_id') required String facilityId,
    @JsonKey(name: 'kmhfl_code') @Default('') String kmhflCode,
    @JsonKey(name: 'facility_name') @Default('') String facilityName,
    @JsonKey(name: 'anc_number') @Default('') String ancNumber,
    @JsonKey(name: 'pnc_number') String? pncNumber,
    @JsonKey(name: 'client_name') @Default('') String clientName,
    @JsonKey(name: 'id_number') String? idNumber,
    @Default(0) int age,
    String? telephone,
    String? county,
    @JsonKey(name: 'sub_county') String? subCounty,
    String? ward,
    String? village,
    @Default(0) int gravida,
    @Default(0) int parity,
    @JsonKey(name: 'height_cm') @Default(0.0) double heightCm,
    @JsonKey(name: 'weight_kg') @Default(0.0) double weightKg,
    DateTime? lmp, 
    DateTime? edd,
    @JsonKey(name: 'gestation_at_first_visit') int? gestationAtFirstVisit,
    @JsonKey(name: 'blood_group') BloodGroup? bloodGroup,
    bool? diabetes,
    bool? hypertension,
    bool? tuberculosis,
    @JsonKey(name: 'blood_transfusion') bool? bloodTransfusion,
    @JsonKey(name: 'drug_allergy') bool? drugAllergy,
    @JsonKey(name: 'allergy_details') String? allergyDetails,
    @JsonKey(name: 'previous_cs') bool? previousCs,
    @JsonKey(name: 'previous_cs_count') int? previousCsCount,
    @JsonKey(name: 'bleeding_history') bool? bleedingHistory,
    int? stillbirths,
    @JsonKey(name: 'neonatal_deaths') int? neonatalDeaths,
    @JsonKey(name: 'fgm_done') bool? fgmDone,
    @JsonKey(name: 'hiv_result') HivTestResult? hivResult,
    @JsonKey(name: 'tested_for_syphilis') bool? testedForSyphilis,
    @JsonKey(name: 'syphilis_result') HivTestResult? syphilisResult,
    @JsonKey(name: 'tested_for_hepatitis_b') bool? testedForHepatitisB,
    @JsonKey(name: 'hepatitis_b_result') HivTestResult? hepatitisBResult,
    @JsonKey(name: 'partner_tested_for_hiv') bool? partnerTestedForHiv,
    @JsonKey(name: 'partner_hiv_status') HivTestResult? partnerHivStatus,
    @JsonKey(name: 'next_of_kin_name') String? nextOfKinName,
    @JsonKey(name: 'next_of_kin_relationship') String? nextOfKinRelationship,
    @JsonKey(name: 'next_of_kin_phone') String? nextOfKinPhone,
    @JsonKey(name: 'photo_url') String? photoUrl,
    @JsonKey(name: 'created_at') DateTime? createdAt,
    @JsonKey(name: 'updated_at') DateTime? updatedAt,
  }) = _MaternalProfile;

  factory MaternalProfile.fromJson(Map<String, dynamic> json) =>
      _$MaternalProfileFromJson(json);
}