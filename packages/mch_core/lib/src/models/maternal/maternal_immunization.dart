import 'package:freezed_annotation/freezed_annotation.dart';

part 'maternal_immunization.freezed.dart';
part 'maternal_immunization.g.dart';

/// Maternal Immunization (TT doses)
/// Based on MCH Handbook 2020 - Section 6
@freezed
class MaternalImmunization with _$MaternalImmunization {
  const factory MaternalImmunization({
    String? id,
    @JsonKey(name: 'maternal_profile_id') required String maternalProfileId,
    @JsonKey(name: 'patient_name') @Default('') String patientName,
    @JsonKey(name: 'anc_visit_id') String? ancVisitId,
    @JsonKey(name: 'tt_dose') required int ttDose, // 1, 2, 3, 4, 5, or 6 (TT+)
    @JsonKey(name: 'dose_date') required DateTime doseDate,
    @JsonKey(name: 'next_dose_due') DateTime? nextDoseDue,
    @JsonKey(name: 'batch_number') String? batchNumber,
    String? notes,
    @JsonKey(name: 'facility_id') required String facilityId,
    @JsonKey(name: 'facility_name') @Default('') String facilityName,
    @JsonKey(name: 'administered_by') required String administeredBy,
    @JsonKey(name: 'administered_by_name') String? administeredByName,
    @JsonKey(name: 'created_at') DateTime? createdAt,
    @JsonKey(name: 'updated_at') DateTime? updatedAt,
  }) = _MaternalImmunization;

  factory MaternalImmunization.fromJson(Map<String, dynamic> json) =>
      _$MaternalImmunizationFromJson(json);
}

/// IPTp (Intermittent Preventive Treatment for Malaria)
/// Based on MCH Handbook 2020 - Section 8
@freezed
class MalariaPreventionRecord with _$MalariaPreventionRecord {
  const factory MalariaPreventionRecord({
    String? id,
    @JsonKey(name: 'maternal_profile_id') required String maternalProfileId,
    @JsonKey(name: 'patient_name') @Default('') String patientName,
    @JsonKey(name: 'anc_visit_id') String? ancVisitId,
    @JsonKey(name: 'sp_dose') required int spDose, // 1, 2, 3, 4+
    @JsonKey(name: 'dose_date') required DateTime doseDate,
    @JsonKey(name: 'gestation_weeks') int? gestationWeeks,
    @JsonKey(name: 'next_dose_due') DateTime? nextDoseDue,
    @JsonKey(name: 'itn_given') @Default(false) bool itnGiven, // Insecticide Treated Net
    @JsonKey(name: 'itn_date') DateTime? itnDate,
    String? notes,
    @JsonKey(name: 'facility_id') required String facilityId,
    @JsonKey(name: 'facility_name') @Default('') String facilityName,
    @JsonKey(name: 'administered_by') required String administeredBy,
    @JsonKey(name: 'administered_by_name') String? administeredByName,
    @JsonKey(name: 'created_at') DateTime? createdAt,
    @JsonKey(name: 'updated_at') DateTime? updatedAt,
  }) = _MalariaPreventionRecord;

  factory MalariaPreventionRecord.fromJson(Map<String, dynamic> json) =>
      _$MalariaPreventionRecordFromJson(json);
}