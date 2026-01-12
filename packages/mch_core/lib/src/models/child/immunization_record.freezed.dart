// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'immunization_record.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

ImmunizationRecord _$ImmunizationRecordFromJson(Map<String, dynamic> json) {
  return _ImmunizationRecord.fromJson(json);
}

/// @nodoc
mixin _$ImmunizationRecord {
  @JsonKey(name: 'id')
  String? get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'child_profile_id')
  String get childId => throw _privateConstructorUsedError;
  @JsonKey(name: 'vaccine_type')
  ImmunizationType get vaccineType => throw _privateConstructorUsedError;
  @JsonKey(name: 'vaccine_name')
  String? get vaccineName => throw _privateConstructorUsedError;
  @JsonKey(name: 'date_given')
  DateTime get dateGiven => throw _privateConstructorUsedError;
  @JsonKey(name: 'age_in_weeks')
  int get ageInWeeks =>
      throw _privateConstructorUsedError; // Child's age when vaccine given
  @JsonKey(name: 'age_at_vaccination_months')
  int? get ageAtVaccinationMonths => throw _privateConstructorUsedError;
  @JsonKey(name: 'age_at_vaccination_weeks')
  int? get ageAtVaccinationWeeks =>
      throw _privateConstructorUsedError; // Dose Information
  @JsonKey(name: 'dose_number')
  int? get doseNumber =>
      throw _privateConstructorUsedError; // 1st, 2nd, 3rd dose
  @JsonKey(name: 'dosage')
  String? get dosage =>
      throw _privateConstructorUsedError; // e.g., "0.05ml", "0.5ml", "2 drops"
  @JsonKey(name: 'route')
  String? get administrationRoute =>
      throw _privateConstructorUsedError; // Oral, IM, Intradermal, Subcutaneous
  @JsonKey(name: 'site')
  String? get administrationSite =>
      throw _privateConstructorUsedError; // Left forearm, Right thigh, etc.
// Vaccine Details
  @JsonKey(name: 'batch_number')
  String? get batchNumber => throw _privateConstructorUsedError;
  @JsonKey(name: 'manufacturer')
  String? get manufacturer => throw _privateConstructorUsedError;
  @JsonKey(name: 'manufacture_date')
  DateTime? get manufactureDate => throw _privateConstructorUsedError;
  @JsonKey(name: 'expiry_date')
  DateTime? get expiryDate => throw _privateConstructorUsedError; // Location
  @JsonKey(name: 'health_facility')
  String? get healthFacilityName =>
      throw _privateConstructorUsedError; // BCG Specific
  @JsonKey(name: 'bcg_scar_checked')
  bool? get bcgScarChecked => throw _privateConstructorUsedError;
  @JsonKey(name: 'bcg_scar_present')
  bool? get bcgScarPresent => throw _privateConstructorUsedError;
  @JsonKey(name: 'bcg_scar_check_date')
  DateTime? get bcgScarCheckDate =>
      throw _privateConstructorUsedError; // Administration
  @JsonKey(name: 'administered_by')
  String? get givenBy =>
      throw _privateConstructorUsedError; // Health worker name
// AEFI (Adverse Events Following Immunization)
  @JsonKey(name: 'adverse_reaction')
  bool get adverseEventReported => throw _privateConstructorUsedError;
  @JsonKey(name: 'reaction_details')
  String? get adverseEventDescription => throw _privateConstructorUsedError;
  @JsonKey(name: 'reaction_severity')
  String? get reactionSeverity => throw _privateConstructorUsedError;
  @JsonKey(name: 'reaction_reported')
  bool get reactionReportedToAuthority =>
      throw _privateConstructorUsedError; // Schedule Status
  @JsonKey(name: 'given_on_schedule')
  bool get givenOnSchedule => throw _privateConstructorUsedError;
  @JsonKey(name: 'reason_for_delay')
  String? get reasonForDelay => throw _privateConstructorUsedError;
  @JsonKey(name: 'catch_up_dose')
  bool get catchUpDose => throw _privateConstructorUsedError; // Next Due
  @JsonKey(name: 'next_dose_due_date')
  DateTime? get nextDoseDate => throw _privateConstructorUsedError;
  @JsonKey(name: 'next_vaccine_due')
  String? get nextVaccineDue => throw _privateConstructorUsedError; // Notes
  @JsonKey(name: 'notes')
  String? get notes => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_at')
  DateTime? get createdAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'updated_at')
  DateTime? get updatedAt => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ImmunizationRecordCopyWith<ImmunizationRecord> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ImmunizationRecordCopyWith<$Res> {
  factory $ImmunizationRecordCopyWith(
          ImmunizationRecord value, $Res Function(ImmunizationRecord) then) =
      _$ImmunizationRecordCopyWithImpl<$Res, ImmunizationRecord>;
  @useResult
  $Res call(
      {@JsonKey(name: 'id') String? id,
      @JsonKey(name: 'child_profile_id') String childId,
      @JsonKey(name: 'vaccine_type') ImmunizationType vaccineType,
      @JsonKey(name: 'vaccine_name') String? vaccineName,
      @JsonKey(name: 'date_given') DateTime dateGiven,
      @JsonKey(name: 'age_in_weeks') int ageInWeeks,
      @JsonKey(name: 'age_at_vaccination_months') int? ageAtVaccinationMonths,
      @JsonKey(name: 'age_at_vaccination_weeks') int? ageAtVaccinationWeeks,
      @JsonKey(name: 'dose_number') int? doseNumber,
      @JsonKey(name: 'dosage') String? dosage,
      @JsonKey(name: 'route') String? administrationRoute,
      @JsonKey(name: 'site') String? administrationSite,
      @JsonKey(name: 'batch_number') String? batchNumber,
      @JsonKey(name: 'manufacturer') String? manufacturer,
      @JsonKey(name: 'manufacture_date') DateTime? manufactureDate,
      @JsonKey(name: 'expiry_date') DateTime? expiryDate,
      @JsonKey(name: 'health_facility') String? healthFacilityName,
      @JsonKey(name: 'bcg_scar_checked') bool? bcgScarChecked,
      @JsonKey(name: 'bcg_scar_present') bool? bcgScarPresent,
      @JsonKey(name: 'bcg_scar_check_date') DateTime? bcgScarCheckDate,
      @JsonKey(name: 'administered_by') String? givenBy,
      @JsonKey(name: 'adverse_reaction') bool adverseEventReported,
      @JsonKey(name: 'reaction_details') String? adverseEventDescription,
      @JsonKey(name: 'reaction_severity') String? reactionSeverity,
      @JsonKey(name: 'reaction_reported') bool reactionReportedToAuthority,
      @JsonKey(name: 'given_on_schedule') bool givenOnSchedule,
      @JsonKey(name: 'reason_for_delay') String? reasonForDelay,
      @JsonKey(name: 'catch_up_dose') bool catchUpDose,
      @JsonKey(name: 'next_dose_due_date') DateTime? nextDoseDate,
      @JsonKey(name: 'next_vaccine_due') String? nextVaccineDue,
      @JsonKey(name: 'notes') String? notes,
      @JsonKey(name: 'created_at') DateTime? createdAt,
      @JsonKey(name: 'updated_at') DateTime? updatedAt});
}

/// @nodoc
class _$ImmunizationRecordCopyWithImpl<$Res, $Val extends ImmunizationRecord>
    implements $ImmunizationRecordCopyWith<$Res> {
  _$ImmunizationRecordCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? childId = null,
    Object? vaccineType = null,
    Object? vaccineName = freezed,
    Object? dateGiven = null,
    Object? ageInWeeks = null,
    Object? ageAtVaccinationMonths = freezed,
    Object? ageAtVaccinationWeeks = freezed,
    Object? doseNumber = freezed,
    Object? dosage = freezed,
    Object? administrationRoute = freezed,
    Object? administrationSite = freezed,
    Object? batchNumber = freezed,
    Object? manufacturer = freezed,
    Object? manufactureDate = freezed,
    Object? expiryDate = freezed,
    Object? healthFacilityName = freezed,
    Object? bcgScarChecked = freezed,
    Object? bcgScarPresent = freezed,
    Object? bcgScarCheckDate = freezed,
    Object? givenBy = freezed,
    Object? adverseEventReported = null,
    Object? adverseEventDescription = freezed,
    Object? reactionSeverity = freezed,
    Object? reactionReportedToAuthority = null,
    Object? givenOnSchedule = null,
    Object? reasonForDelay = freezed,
    Object? catchUpDose = null,
    Object? nextDoseDate = freezed,
    Object? nextVaccineDue = freezed,
    Object? notes = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(_value.copyWith(
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String?,
      childId: null == childId
          ? _value.childId
          : childId // ignore: cast_nullable_to_non_nullable
              as String,
      vaccineType: null == vaccineType
          ? _value.vaccineType
          : vaccineType // ignore: cast_nullable_to_non_nullable
              as ImmunizationType,
      vaccineName: freezed == vaccineName
          ? _value.vaccineName
          : vaccineName // ignore: cast_nullable_to_non_nullable
              as String?,
      dateGiven: null == dateGiven
          ? _value.dateGiven
          : dateGiven // ignore: cast_nullable_to_non_nullable
              as DateTime,
      ageInWeeks: null == ageInWeeks
          ? _value.ageInWeeks
          : ageInWeeks // ignore: cast_nullable_to_non_nullable
              as int,
      ageAtVaccinationMonths: freezed == ageAtVaccinationMonths
          ? _value.ageAtVaccinationMonths
          : ageAtVaccinationMonths // ignore: cast_nullable_to_non_nullable
              as int?,
      ageAtVaccinationWeeks: freezed == ageAtVaccinationWeeks
          ? _value.ageAtVaccinationWeeks
          : ageAtVaccinationWeeks // ignore: cast_nullable_to_non_nullable
              as int?,
      doseNumber: freezed == doseNumber
          ? _value.doseNumber
          : doseNumber // ignore: cast_nullable_to_non_nullable
              as int?,
      dosage: freezed == dosage
          ? _value.dosage
          : dosage // ignore: cast_nullable_to_non_nullable
              as String?,
      administrationRoute: freezed == administrationRoute
          ? _value.administrationRoute
          : administrationRoute // ignore: cast_nullable_to_non_nullable
              as String?,
      administrationSite: freezed == administrationSite
          ? _value.administrationSite
          : administrationSite // ignore: cast_nullable_to_non_nullable
              as String?,
      batchNumber: freezed == batchNumber
          ? _value.batchNumber
          : batchNumber // ignore: cast_nullable_to_non_nullable
              as String?,
      manufacturer: freezed == manufacturer
          ? _value.manufacturer
          : manufacturer // ignore: cast_nullable_to_non_nullable
              as String?,
      manufactureDate: freezed == manufactureDate
          ? _value.manufactureDate
          : manufactureDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      expiryDate: freezed == expiryDate
          ? _value.expiryDate
          : expiryDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      healthFacilityName: freezed == healthFacilityName
          ? _value.healthFacilityName
          : healthFacilityName // ignore: cast_nullable_to_non_nullable
              as String?,
      bcgScarChecked: freezed == bcgScarChecked
          ? _value.bcgScarChecked
          : bcgScarChecked // ignore: cast_nullable_to_non_nullable
              as bool?,
      bcgScarPresent: freezed == bcgScarPresent
          ? _value.bcgScarPresent
          : bcgScarPresent // ignore: cast_nullable_to_non_nullable
              as bool?,
      bcgScarCheckDate: freezed == bcgScarCheckDate
          ? _value.bcgScarCheckDate
          : bcgScarCheckDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      givenBy: freezed == givenBy
          ? _value.givenBy
          : givenBy // ignore: cast_nullable_to_non_nullable
              as String?,
      adverseEventReported: null == adverseEventReported
          ? _value.adverseEventReported
          : adverseEventReported // ignore: cast_nullable_to_non_nullable
              as bool,
      adverseEventDescription: freezed == adverseEventDescription
          ? _value.adverseEventDescription
          : adverseEventDescription // ignore: cast_nullable_to_non_nullable
              as String?,
      reactionSeverity: freezed == reactionSeverity
          ? _value.reactionSeverity
          : reactionSeverity // ignore: cast_nullable_to_non_nullable
              as String?,
      reactionReportedToAuthority: null == reactionReportedToAuthority
          ? _value.reactionReportedToAuthority
          : reactionReportedToAuthority // ignore: cast_nullable_to_non_nullable
              as bool,
      givenOnSchedule: null == givenOnSchedule
          ? _value.givenOnSchedule
          : givenOnSchedule // ignore: cast_nullable_to_non_nullable
              as bool,
      reasonForDelay: freezed == reasonForDelay
          ? _value.reasonForDelay
          : reasonForDelay // ignore: cast_nullable_to_non_nullable
              as String?,
      catchUpDose: null == catchUpDose
          ? _value.catchUpDose
          : catchUpDose // ignore: cast_nullable_to_non_nullable
              as bool,
      nextDoseDate: freezed == nextDoseDate
          ? _value.nextDoseDate
          : nextDoseDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      nextVaccineDue: freezed == nextVaccineDue
          ? _value.nextVaccineDue
          : nextVaccineDue // ignore: cast_nullable_to_non_nullable
              as String?,
      notes: freezed == notes
          ? _value.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String?,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ImmunizationRecordImplCopyWith<$Res>
    implements $ImmunizationRecordCopyWith<$Res> {
  factory _$$ImmunizationRecordImplCopyWith(_$ImmunizationRecordImpl value,
          $Res Function(_$ImmunizationRecordImpl) then) =
      __$$ImmunizationRecordImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'id') String? id,
      @JsonKey(name: 'child_profile_id') String childId,
      @JsonKey(name: 'vaccine_type') ImmunizationType vaccineType,
      @JsonKey(name: 'vaccine_name') String? vaccineName,
      @JsonKey(name: 'date_given') DateTime dateGiven,
      @JsonKey(name: 'age_in_weeks') int ageInWeeks,
      @JsonKey(name: 'age_at_vaccination_months') int? ageAtVaccinationMonths,
      @JsonKey(name: 'age_at_vaccination_weeks') int? ageAtVaccinationWeeks,
      @JsonKey(name: 'dose_number') int? doseNumber,
      @JsonKey(name: 'dosage') String? dosage,
      @JsonKey(name: 'route') String? administrationRoute,
      @JsonKey(name: 'site') String? administrationSite,
      @JsonKey(name: 'batch_number') String? batchNumber,
      @JsonKey(name: 'manufacturer') String? manufacturer,
      @JsonKey(name: 'manufacture_date') DateTime? manufactureDate,
      @JsonKey(name: 'expiry_date') DateTime? expiryDate,
      @JsonKey(name: 'health_facility') String? healthFacilityName,
      @JsonKey(name: 'bcg_scar_checked') bool? bcgScarChecked,
      @JsonKey(name: 'bcg_scar_present') bool? bcgScarPresent,
      @JsonKey(name: 'bcg_scar_check_date') DateTime? bcgScarCheckDate,
      @JsonKey(name: 'administered_by') String? givenBy,
      @JsonKey(name: 'adverse_reaction') bool adverseEventReported,
      @JsonKey(name: 'reaction_details') String? adverseEventDescription,
      @JsonKey(name: 'reaction_severity') String? reactionSeverity,
      @JsonKey(name: 'reaction_reported') bool reactionReportedToAuthority,
      @JsonKey(name: 'given_on_schedule') bool givenOnSchedule,
      @JsonKey(name: 'reason_for_delay') String? reasonForDelay,
      @JsonKey(name: 'catch_up_dose') bool catchUpDose,
      @JsonKey(name: 'next_dose_due_date') DateTime? nextDoseDate,
      @JsonKey(name: 'next_vaccine_due') String? nextVaccineDue,
      @JsonKey(name: 'notes') String? notes,
      @JsonKey(name: 'created_at') DateTime? createdAt,
      @JsonKey(name: 'updated_at') DateTime? updatedAt});
}

/// @nodoc
class __$$ImmunizationRecordImplCopyWithImpl<$Res>
    extends _$ImmunizationRecordCopyWithImpl<$Res, _$ImmunizationRecordImpl>
    implements _$$ImmunizationRecordImplCopyWith<$Res> {
  __$$ImmunizationRecordImplCopyWithImpl(_$ImmunizationRecordImpl _value,
      $Res Function(_$ImmunizationRecordImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? childId = null,
    Object? vaccineType = null,
    Object? vaccineName = freezed,
    Object? dateGiven = null,
    Object? ageInWeeks = null,
    Object? ageAtVaccinationMonths = freezed,
    Object? ageAtVaccinationWeeks = freezed,
    Object? doseNumber = freezed,
    Object? dosage = freezed,
    Object? administrationRoute = freezed,
    Object? administrationSite = freezed,
    Object? batchNumber = freezed,
    Object? manufacturer = freezed,
    Object? manufactureDate = freezed,
    Object? expiryDate = freezed,
    Object? healthFacilityName = freezed,
    Object? bcgScarChecked = freezed,
    Object? bcgScarPresent = freezed,
    Object? bcgScarCheckDate = freezed,
    Object? givenBy = freezed,
    Object? adverseEventReported = null,
    Object? adverseEventDescription = freezed,
    Object? reactionSeverity = freezed,
    Object? reactionReportedToAuthority = null,
    Object? givenOnSchedule = null,
    Object? reasonForDelay = freezed,
    Object? catchUpDose = null,
    Object? nextDoseDate = freezed,
    Object? nextVaccineDue = freezed,
    Object? notes = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(_$ImmunizationRecordImpl(
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String?,
      childId: null == childId
          ? _value.childId
          : childId // ignore: cast_nullable_to_non_nullable
              as String,
      vaccineType: null == vaccineType
          ? _value.vaccineType
          : vaccineType // ignore: cast_nullable_to_non_nullable
              as ImmunizationType,
      vaccineName: freezed == vaccineName
          ? _value.vaccineName
          : vaccineName // ignore: cast_nullable_to_non_nullable
              as String?,
      dateGiven: null == dateGiven
          ? _value.dateGiven
          : dateGiven // ignore: cast_nullable_to_non_nullable
              as DateTime,
      ageInWeeks: null == ageInWeeks
          ? _value.ageInWeeks
          : ageInWeeks // ignore: cast_nullable_to_non_nullable
              as int,
      ageAtVaccinationMonths: freezed == ageAtVaccinationMonths
          ? _value.ageAtVaccinationMonths
          : ageAtVaccinationMonths // ignore: cast_nullable_to_non_nullable
              as int?,
      ageAtVaccinationWeeks: freezed == ageAtVaccinationWeeks
          ? _value.ageAtVaccinationWeeks
          : ageAtVaccinationWeeks // ignore: cast_nullable_to_non_nullable
              as int?,
      doseNumber: freezed == doseNumber
          ? _value.doseNumber
          : doseNumber // ignore: cast_nullable_to_non_nullable
              as int?,
      dosage: freezed == dosage
          ? _value.dosage
          : dosage // ignore: cast_nullable_to_non_nullable
              as String?,
      administrationRoute: freezed == administrationRoute
          ? _value.administrationRoute
          : administrationRoute // ignore: cast_nullable_to_non_nullable
              as String?,
      administrationSite: freezed == administrationSite
          ? _value.administrationSite
          : administrationSite // ignore: cast_nullable_to_non_nullable
              as String?,
      batchNumber: freezed == batchNumber
          ? _value.batchNumber
          : batchNumber // ignore: cast_nullable_to_non_nullable
              as String?,
      manufacturer: freezed == manufacturer
          ? _value.manufacturer
          : manufacturer // ignore: cast_nullable_to_non_nullable
              as String?,
      manufactureDate: freezed == manufactureDate
          ? _value.manufactureDate
          : manufactureDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      expiryDate: freezed == expiryDate
          ? _value.expiryDate
          : expiryDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      healthFacilityName: freezed == healthFacilityName
          ? _value.healthFacilityName
          : healthFacilityName // ignore: cast_nullable_to_non_nullable
              as String?,
      bcgScarChecked: freezed == bcgScarChecked
          ? _value.bcgScarChecked
          : bcgScarChecked // ignore: cast_nullable_to_non_nullable
              as bool?,
      bcgScarPresent: freezed == bcgScarPresent
          ? _value.bcgScarPresent
          : bcgScarPresent // ignore: cast_nullable_to_non_nullable
              as bool?,
      bcgScarCheckDate: freezed == bcgScarCheckDate
          ? _value.bcgScarCheckDate
          : bcgScarCheckDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      givenBy: freezed == givenBy
          ? _value.givenBy
          : givenBy // ignore: cast_nullable_to_non_nullable
              as String?,
      adverseEventReported: null == adverseEventReported
          ? _value.adverseEventReported
          : adverseEventReported // ignore: cast_nullable_to_non_nullable
              as bool,
      adverseEventDescription: freezed == adverseEventDescription
          ? _value.adverseEventDescription
          : adverseEventDescription // ignore: cast_nullable_to_non_nullable
              as String?,
      reactionSeverity: freezed == reactionSeverity
          ? _value.reactionSeverity
          : reactionSeverity // ignore: cast_nullable_to_non_nullable
              as String?,
      reactionReportedToAuthority: null == reactionReportedToAuthority
          ? _value.reactionReportedToAuthority
          : reactionReportedToAuthority // ignore: cast_nullable_to_non_nullable
              as bool,
      givenOnSchedule: null == givenOnSchedule
          ? _value.givenOnSchedule
          : givenOnSchedule // ignore: cast_nullable_to_non_nullable
              as bool,
      reasonForDelay: freezed == reasonForDelay
          ? _value.reasonForDelay
          : reasonForDelay // ignore: cast_nullable_to_non_nullable
              as String?,
      catchUpDose: null == catchUpDose
          ? _value.catchUpDose
          : catchUpDose // ignore: cast_nullable_to_non_nullable
              as bool,
      nextDoseDate: freezed == nextDoseDate
          ? _value.nextDoseDate
          : nextDoseDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      nextVaccineDue: freezed == nextVaccineDue
          ? _value.nextVaccineDue
          : nextVaccineDue // ignore: cast_nullable_to_non_nullable
              as String?,
      notes: freezed == notes
          ? _value.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String?,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ImmunizationRecordImpl implements _ImmunizationRecord {
  const _$ImmunizationRecordImpl(
      {@JsonKey(name: 'id') this.id,
      @JsonKey(name: 'child_profile_id') required this.childId,
      @JsonKey(name: 'vaccine_type') required this.vaccineType,
      @JsonKey(name: 'vaccine_name') this.vaccineName,
      @JsonKey(name: 'date_given') required this.dateGiven,
      @JsonKey(name: 'age_in_weeks') required this.ageInWeeks,
      @JsonKey(name: 'age_at_vaccination_months') this.ageAtVaccinationMonths,
      @JsonKey(name: 'age_at_vaccination_weeks') this.ageAtVaccinationWeeks,
      @JsonKey(name: 'dose_number') this.doseNumber,
      @JsonKey(name: 'dosage') this.dosage,
      @JsonKey(name: 'route') this.administrationRoute,
      @JsonKey(name: 'site') this.administrationSite,
      @JsonKey(name: 'batch_number') this.batchNumber,
      @JsonKey(name: 'manufacturer') this.manufacturer,
      @JsonKey(name: 'manufacture_date') this.manufactureDate,
      @JsonKey(name: 'expiry_date') this.expiryDate,
      @JsonKey(name: 'health_facility') this.healthFacilityName,
      @JsonKey(name: 'bcg_scar_checked') this.bcgScarChecked,
      @JsonKey(name: 'bcg_scar_present') this.bcgScarPresent,
      @JsonKey(name: 'bcg_scar_check_date') this.bcgScarCheckDate,
      @JsonKey(name: 'administered_by') this.givenBy,
      @JsonKey(name: 'adverse_reaction') this.adverseEventReported = false,
      @JsonKey(name: 'reaction_details') this.adverseEventDescription,
      @JsonKey(name: 'reaction_severity') this.reactionSeverity,
      @JsonKey(name: 'reaction_reported')
      this.reactionReportedToAuthority = false,
      @JsonKey(name: 'given_on_schedule') this.givenOnSchedule = true,
      @JsonKey(name: 'reason_for_delay') this.reasonForDelay,
      @JsonKey(name: 'catch_up_dose') this.catchUpDose = false,
      @JsonKey(name: 'next_dose_due_date') this.nextDoseDate,
      @JsonKey(name: 'next_vaccine_due') this.nextVaccineDue,
      @JsonKey(name: 'notes') this.notes,
      @JsonKey(name: 'created_at') this.createdAt,
      @JsonKey(name: 'updated_at') this.updatedAt});

  factory _$ImmunizationRecordImpl.fromJson(Map<String, dynamic> json) =>
      _$$ImmunizationRecordImplFromJson(json);

  @override
  @JsonKey(name: 'id')
  final String? id;
  @override
  @JsonKey(name: 'child_profile_id')
  final String childId;
  @override
  @JsonKey(name: 'vaccine_type')
  final ImmunizationType vaccineType;
  @override
  @JsonKey(name: 'vaccine_name')
  final String? vaccineName;
  @override
  @JsonKey(name: 'date_given')
  final DateTime dateGiven;
  @override
  @JsonKey(name: 'age_in_weeks')
  final int ageInWeeks;
// Child's age when vaccine given
  @override
  @JsonKey(name: 'age_at_vaccination_months')
  final int? ageAtVaccinationMonths;
  @override
  @JsonKey(name: 'age_at_vaccination_weeks')
  final int? ageAtVaccinationWeeks;
// Dose Information
  @override
  @JsonKey(name: 'dose_number')
  final int? doseNumber;
// 1st, 2nd, 3rd dose
  @override
  @JsonKey(name: 'dosage')
  final String? dosage;
// e.g., "0.05ml", "0.5ml", "2 drops"
  @override
  @JsonKey(name: 'route')
  final String? administrationRoute;
// Oral, IM, Intradermal, Subcutaneous
  @override
  @JsonKey(name: 'site')
  final String? administrationSite;
// Left forearm, Right thigh, etc.
// Vaccine Details
  @override
  @JsonKey(name: 'batch_number')
  final String? batchNumber;
  @override
  @JsonKey(name: 'manufacturer')
  final String? manufacturer;
  @override
  @JsonKey(name: 'manufacture_date')
  final DateTime? manufactureDate;
  @override
  @JsonKey(name: 'expiry_date')
  final DateTime? expiryDate;
// Location
  @override
  @JsonKey(name: 'health_facility')
  final String? healthFacilityName;
// BCG Specific
  @override
  @JsonKey(name: 'bcg_scar_checked')
  final bool? bcgScarChecked;
  @override
  @JsonKey(name: 'bcg_scar_present')
  final bool? bcgScarPresent;
  @override
  @JsonKey(name: 'bcg_scar_check_date')
  final DateTime? bcgScarCheckDate;
// Administration
  @override
  @JsonKey(name: 'administered_by')
  final String? givenBy;
// Health worker name
// AEFI (Adverse Events Following Immunization)
  @override
  @JsonKey(name: 'adverse_reaction')
  final bool adverseEventReported;
  @override
  @JsonKey(name: 'reaction_details')
  final String? adverseEventDescription;
  @override
  @JsonKey(name: 'reaction_severity')
  final String? reactionSeverity;
  @override
  @JsonKey(name: 'reaction_reported')
  final bool reactionReportedToAuthority;
// Schedule Status
  @override
  @JsonKey(name: 'given_on_schedule')
  final bool givenOnSchedule;
  @override
  @JsonKey(name: 'reason_for_delay')
  final String? reasonForDelay;
  @override
  @JsonKey(name: 'catch_up_dose')
  final bool catchUpDose;
// Next Due
  @override
  @JsonKey(name: 'next_dose_due_date')
  final DateTime? nextDoseDate;
  @override
  @JsonKey(name: 'next_vaccine_due')
  final String? nextVaccineDue;
// Notes
  @override
  @JsonKey(name: 'notes')
  final String? notes;
  @override
  @JsonKey(name: 'created_at')
  final DateTime? createdAt;
  @override
  @JsonKey(name: 'updated_at')
  final DateTime? updatedAt;

  @override
  String toString() {
    return 'ImmunizationRecord(id: $id, childId: $childId, vaccineType: $vaccineType, vaccineName: $vaccineName, dateGiven: $dateGiven, ageInWeeks: $ageInWeeks, ageAtVaccinationMonths: $ageAtVaccinationMonths, ageAtVaccinationWeeks: $ageAtVaccinationWeeks, doseNumber: $doseNumber, dosage: $dosage, administrationRoute: $administrationRoute, administrationSite: $administrationSite, batchNumber: $batchNumber, manufacturer: $manufacturer, manufactureDate: $manufactureDate, expiryDate: $expiryDate, healthFacilityName: $healthFacilityName, bcgScarChecked: $bcgScarChecked, bcgScarPresent: $bcgScarPresent, bcgScarCheckDate: $bcgScarCheckDate, givenBy: $givenBy, adverseEventReported: $adverseEventReported, adverseEventDescription: $adverseEventDescription, reactionSeverity: $reactionSeverity, reactionReportedToAuthority: $reactionReportedToAuthority, givenOnSchedule: $givenOnSchedule, reasonForDelay: $reasonForDelay, catchUpDose: $catchUpDose, nextDoseDate: $nextDoseDate, nextVaccineDue: $nextVaccineDue, notes: $notes, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ImmunizationRecordImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.childId, childId) || other.childId == childId) &&
            (identical(other.vaccineType, vaccineType) ||
                other.vaccineType == vaccineType) &&
            (identical(other.vaccineName, vaccineName) ||
                other.vaccineName == vaccineName) &&
            (identical(other.dateGiven, dateGiven) ||
                other.dateGiven == dateGiven) &&
            (identical(other.ageInWeeks, ageInWeeks) ||
                other.ageInWeeks == ageInWeeks) &&
            (identical(other.ageAtVaccinationMonths, ageAtVaccinationMonths) ||
                other.ageAtVaccinationMonths == ageAtVaccinationMonths) &&
            (identical(other.ageAtVaccinationWeeks, ageAtVaccinationWeeks) ||
                other.ageAtVaccinationWeeks == ageAtVaccinationWeeks) &&
            (identical(other.doseNumber, doseNumber) ||
                other.doseNumber == doseNumber) &&
            (identical(other.dosage, dosage) || other.dosage == dosage) &&
            (identical(other.administrationRoute, administrationRoute) ||
                other.administrationRoute == administrationRoute) &&
            (identical(other.administrationSite, administrationSite) ||
                other.administrationSite == administrationSite) &&
            (identical(other.batchNumber, batchNumber) ||
                other.batchNumber == batchNumber) &&
            (identical(other.manufacturer, manufacturer) ||
                other.manufacturer == manufacturer) &&
            (identical(other.manufactureDate, manufactureDate) ||
                other.manufactureDate == manufactureDate) &&
            (identical(other.expiryDate, expiryDate) ||
                other.expiryDate == expiryDate) &&
            (identical(other.healthFacilityName, healthFacilityName) ||
                other.healthFacilityName == healthFacilityName) &&
            (identical(other.bcgScarChecked, bcgScarChecked) ||
                other.bcgScarChecked == bcgScarChecked) &&
            (identical(other.bcgScarPresent, bcgScarPresent) ||
                other.bcgScarPresent == bcgScarPresent) &&
            (identical(other.bcgScarCheckDate, bcgScarCheckDate) ||
                other.bcgScarCheckDate == bcgScarCheckDate) &&
            (identical(other.givenBy, givenBy) || other.givenBy == givenBy) &&
            (identical(other.adverseEventReported, adverseEventReported) ||
                other.adverseEventReported == adverseEventReported) &&
            (identical(
                    other.adverseEventDescription, adverseEventDescription) ||
                other.adverseEventDescription == adverseEventDescription) &&
            (identical(other.reactionSeverity, reactionSeverity) ||
                other.reactionSeverity == reactionSeverity) &&
            (identical(other.reactionReportedToAuthority,
                    reactionReportedToAuthority) ||
                other.reactionReportedToAuthority ==
                    reactionReportedToAuthority) &&
            (identical(other.givenOnSchedule, givenOnSchedule) ||
                other.givenOnSchedule == givenOnSchedule) &&
            (identical(other.reasonForDelay, reasonForDelay) ||
                other.reasonForDelay == reasonForDelay) &&
            (identical(other.catchUpDose, catchUpDose) ||
                other.catchUpDose == catchUpDose) &&
            (identical(other.nextDoseDate, nextDoseDate) ||
                other.nextDoseDate == nextDoseDate) &&
            (identical(other.nextVaccineDue, nextVaccineDue) ||
                other.nextVaccineDue == nextVaccineDue) &&
            (identical(other.notes, notes) || other.notes == notes) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hashAll([
        runtimeType,
        id,
        childId,
        vaccineType,
        vaccineName,
        dateGiven,
        ageInWeeks,
        ageAtVaccinationMonths,
        ageAtVaccinationWeeks,
        doseNumber,
        dosage,
        administrationRoute,
        administrationSite,
        batchNumber,
        manufacturer,
        manufactureDate,
        expiryDate,
        healthFacilityName,
        bcgScarChecked,
        bcgScarPresent,
        bcgScarCheckDate,
        givenBy,
        adverseEventReported,
        adverseEventDescription,
        reactionSeverity,
        reactionReportedToAuthority,
        givenOnSchedule,
        reasonForDelay,
        catchUpDose,
        nextDoseDate,
        nextVaccineDue,
        notes,
        createdAt,
        updatedAt
      ]);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ImmunizationRecordImplCopyWith<_$ImmunizationRecordImpl> get copyWith =>
      __$$ImmunizationRecordImplCopyWithImpl<_$ImmunizationRecordImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ImmunizationRecordImplToJson(
      this,
    );
  }
}

abstract class _ImmunizationRecord implements ImmunizationRecord {
  const factory _ImmunizationRecord(
      {@JsonKey(name: 'id') final String? id,
      @JsonKey(name: 'child_profile_id') required final String childId,
      @JsonKey(name: 'vaccine_type')
      required final ImmunizationType vaccineType,
      @JsonKey(name: 'vaccine_name') final String? vaccineName,
      @JsonKey(name: 'date_given') required final DateTime dateGiven,
      @JsonKey(name: 'age_in_weeks') required final int ageInWeeks,
      @JsonKey(name: 'age_at_vaccination_months')
      final int? ageAtVaccinationMonths,
      @JsonKey(name: 'age_at_vaccination_weeks')
      final int? ageAtVaccinationWeeks,
      @JsonKey(name: 'dose_number') final int? doseNumber,
      @JsonKey(name: 'dosage') final String? dosage,
      @JsonKey(name: 'route') final String? administrationRoute,
      @JsonKey(name: 'site') final String? administrationSite,
      @JsonKey(name: 'batch_number') final String? batchNumber,
      @JsonKey(name: 'manufacturer') final String? manufacturer,
      @JsonKey(name: 'manufacture_date') final DateTime? manufactureDate,
      @JsonKey(name: 'expiry_date') final DateTime? expiryDate,
      @JsonKey(name: 'health_facility') final String? healthFacilityName,
      @JsonKey(name: 'bcg_scar_checked') final bool? bcgScarChecked,
      @JsonKey(name: 'bcg_scar_present') final bool? bcgScarPresent,
      @JsonKey(name: 'bcg_scar_check_date') final DateTime? bcgScarCheckDate,
      @JsonKey(name: 'administered_by') final String? givenBy,
      @JsonKey(name: 'adverse_reaction') final bool adverseEventReported,
      @JsonKey(name: 'reaction_details') final String? adverseEventDescription,
      @JsonKey(name: 'reaction_severity') final String? reactionSeverity,
      @JsonKey(name: 'reaction_reported')
      final bool reactionReportedToAuthority,
      @JsonKey(name: 'given_on_schedule') final bool givenOnSchedule,
      @JsonKey(name: 'reason_for_delay') final String? reasonForDelay,
      @JsonKey(name: 'catch_up_dose') final bool catchUpDose,
      @JsonKey(name: 'next_dose_due_date') final DateTime? nextDoseDate,
      @JsonKey(name: 'next_vaccine_due') final String? nextVaccineDue,
      @JsonKey(name: 'notes') final String? notes,
      @JsonKey(name: 'created_at') final DateTime? createdAt,
      @JsonKey(name: 'updated_at')
      final DateTime? updatedAt}) = _$ImmunizationRecordImpl;

  factory _ImmunizationRecord.fromJson(Map<String, dynamic> json) =
      _$ImmunizationRecordImpl.fromJson;

  @override
  @JsonKey(name: 'id')
  String? get id;
  @override
  @JsonKey(name: 'child_profile_id')
  String get childId;
  @override
  @JsonKey(name: 'vaccine_type')
  ImmunizationType get vaccineType;
  @override
  @JsonKey(name: 'vaccine_name')
  String? get vaccineName;
  @override
  @JsonKey(name: 'date_given')
  DateTime get dateGiven;
  @override
  @JsonKey(name: 'age_in_weeks')
  int get ageInWeeks;
  @override // Child's age when vaccine given
  @JsonKey(name: 'age_at_vaccination_months')
  int? get ageAtVaccinationMonths;
  @override
  @JsonKey(name: 'age_at_vaccination_weeks')
  int? get ageAtVaccinationWeeks;
  @override // Dose Information
  @JsonKey(name: 'dose_number')
  int? get doseNumber;
  @override // 1st, 2nd, 3rd dose
  @JsonKey(name: 'dosage')
  String? get dosage;
  @override // e.g., "0.05ml", "0.5ml", "2 drops"
  @JsonKey(name: 'route')
  String? get administrationRoute;
  @override // Oral, IM, Intradermal, Subcutaneous
  @JsonKey(name: 'site')
  String? get administrationSite;
  @override // Left forearm, Right thigh, etc.
// Vaccine Details
  @JsonKey(name: 'batch_number')
  String? get batchNumber;
  @override
  @JsonKey(name: 'manufacturer')
  String? get manufacturer;
  @override
  @JsonKey(name: 'manufacture_date')
  DateTime? get manufactureDate;
  @override
  @JsonKey(name: 'expiry_date')
  DateTime? get expiryDate;
  @override // Location
  @JsonKey(name: 'health_facility')
  String? get healthFacilityName;
  @override // BCG Specific
  @JsonKey(name: 'bcg_scar_checked')
  bool? get bcgScarChecked;
  @override
  @JsonKey(name: 'bcg_scar_present')
  bool? get bcgScarPresent;
  @override
  @JsonKey(name: 'bcg_scar_check_date')
  DateTime? get bcgScarCheckDate;
  @override // Administration
  @JsonKey(name: 'administered_by')
  String? get givenBy;
  @override // Health worker name
// AEFI (Adverse Events Following Immunization)
  @JsonKey(name: 'adverse_reaction')
  bool get adverseEventReported;
  @override
  @JsonKey(name: 'reaction_details')
  String? get adverseEventDescription;
  @override
  @JsonKey(name: 'reaction_severity')
  String? get reactionSeverity;
  @override
  @JsonKey(name: 'reaction_reported')
  bool get reactionReportedToAuthority;
  @override // Schedule Status
  @JsonKey(name: 'given_on_schedule')
  bool get givenOnSchedule;
  @override
  @JsonKey(name: 'reason_for_delay')
  String? get reasonForDelay;
  @override
  @JsonKey(name: 'catch_up_dose')
  bool get catchUpDose;
  @override // Next Due
  @JsonKey(name: 'next_dose_due_date')
  DateTime? get nextDoseDate;
  @override
  @JsonKey(name: 'next_vaccine_due')
  String? get nextVaccineDue;
  @override // Notes
  @JsonKey(name: 'notes')
  String? get notes;
  @override
  @JsonKey(name: 'created_at')
  DateTime? get createdAt;
  @override
  @JsonKey(name: 'updated_at')
  DateTime? get updatedAt;
  @override
  @JsonKey(ignore: true)
  _$$ImmunizationRecordImplCopyWith<_$ImmunizationRecordImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
