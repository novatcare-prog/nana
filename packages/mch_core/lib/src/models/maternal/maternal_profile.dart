import 'package:freezed_annotation/freezed_annotation.dart';
import '../../enums/blood_group.dart';
import '../../enums/hiv_test_result.dart';

part 'maternal_profile.freezed.dart';
part 'maternal_profile.g.dart';

@freezed
class MaternalProfile with _$MaternalProfile {
  const factory MaternalProfile({
    // ✅ FIX: 'required' has been REMOVED from all fields with @Default
    @Default('') String id,
    @Default('') String facilityId,
    @Default('') String kmhflCode,
    @Default('') String facilityName,
    @Default('') String ancNumber,
    String? pncNumber,
    @Default('') String clientName,
    String? idNumber,
    @Default(0) int age,
    String? telephone,
    String? county,
    String? subCounty,
    String? ward,
    String? village,
    @Default(0) int gravida,
    @Default(0) int parity,
    @Default(0.0) double heightCm,
    @Default(0.0) double weightKg,
    
    // ✅ FIX: Made dates nullable to prevent the 'Null' crash
    DateTime? lmp, 
    DateTime? edd,
    
    int? gestationAtFirstVisit,
    BloodGroup? bloodGroup,
    bool? diabetes,
    bool? hypertension,
    bool? tuberculosis,
    bool? bloodTransfusion,
    bool? drugAllergy,
    String? allergyDetails,
    bool? previousCs,
    int? previousCsCount,
    bool? bleedingHistory,
    int? stillbirths,
    int? neonatalDeaths,
    bool? fgmDone,
    HivTestResult? hivResult,
    bool? testedForSyphilis,
    HivTestResult? syphilisResult,
    bool? testedForHepatitisB,
    HivTestResult? hepatitisBResult,
    bool? partnerTestedForHiv,
    HivTestResult? partnerHivStatus,
    String? nextOfKinName,
    String? nextOfKinRelationship,
    String? nextOfKinPhone,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _MaternalProfile;

  factory MaternalProfile.fromJson(Map<String, dynamic> json) =>
      _$MaternalProfileFromJson(json);
}