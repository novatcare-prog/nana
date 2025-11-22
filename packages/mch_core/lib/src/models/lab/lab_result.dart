import 'package:freezed_annotation/freezed_annotation.dart';

part 'lab_result.freezed.dart';
part 'lab_result.g.dart';

/// Lab Test Types (Based on MCH Handbook 2020 Section 4)
enum LabTestType {
  @JsonValue('hemoglobin')
  hemoglobin,           // Hb test
  
  @JsonValue('blood_group')
  bloodGroup,           // ABO & Rhesus
  
  @JsonValue('urinalysis')
  urinalysis,           // Protein & Glucose
  
  @JsonValue('vdrl_syphilis')
  vdrlSyphilis,         // Syphilis screening
  
  @JsonValue('hiv_test')
  hivTest,              // HIV screening
  
  @JsonValue('blood_sugar')
  bloodSugar,           // RBS/FBS
  
  @JsonValue('hepatitis_b')
  hepatitisB,           // HBsAg
  
  @JsonValue('tb_screening')
  tbScreening,          // TB test
}

@freezed
class LabResult with _$LabResult {
  const factory LabResult({
    String? id,
    @JsonKey(name: 'maternal_profile_id') required String maternalProfileId,
    @JsonKey(name: 'patient_name') @Default('') String patientName,
    @JsonKey(name: 'anc_visit_id') String? ancVisitId,
    @JsonKey(name: 'test_type') required LabTestType testType,
    @JsonKey(name: 'test_name') required String testName,
    @JsonKey(name: 'test_date') required DateTime testDate,
    @JsonKey(name: 'result_value') required String resultValue,
    @JsonKey(name: 'result_unit') String? resultUnit,
    @JsonKey(name: 'reference_range') String? referenceRange,
    @JsonKey(name: 'is_abnormal') @Default(false) bool isAbnormal,
    String? notes,
    @JsonKey(name: 'facility_id') required String facilityId,
    @JsonKey(name: 'facility_name') @Default('') String facilityName,
    @JsonKey(name: 'performed_by') required String performedBy,
    @JsonKey(name: 'performed_by_name') String? performedByName,
    @JsonKey(name: 'created_at') DateTime? createdAt,
    @JsonKey(name: 'updated_at') DateTime? updatedAt,
  }) = _LabResult;

  factory LabResult.fromJson(Map<String, dynamic> json) =>
      _$LabResultFromJson(json);
}