// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'deworming_record.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

DewormingRecord _$DewormingRecordFromJson(Map<String, dynamic> json) {
  return _DewormingRecord.fromJson(json);
}

/// @nodoc
mixin _$DewormingRecord {
  @JsonKey(name: 'id')
  String? get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'child_profile_id')
  String get childId => throw _privateConstructorUsedError;
  @JsonKey(name: 'date_given')
  DateTime get dateGiven => throw _privateConstructorUsedError;
  @JsonKey(name: 'age_in_months')
  int get ageInMonths => throw _privateConstructorUsedError;
  @JsonKey(name: 'dose_number')
  int? get doseNumber => throw _privateConstructorUsedError; // Drug Information
  @JsonKey(name: 'drug_name')
  String get drugName =>
      throw _privateConstructorUsedError; // Albendazole or Mebendazole
  @JsonKey(name: 'dosage')
  String get dosage => throw _privateConstructorUsedError; // "400mg" or "500mg"
// Administration
  @JsonKey(name: 'given_by')
  String? get givenBy => throw _privateConstructorUsedError;
  @JsonKey(name: 'health_facility')
  String? get healthFacilityName =>
      throw _privateConstructorUsedError; // Side Effects
  @JsonKey(name: 'side_effects_reported')
  bool get sideEffectsReported => throw _privateConstructorUsedError;
  @JsonKey(name: 'side_effects_description')
  String? get sideEffectsDescription =>
      throw _privateConstructorUsedError; // Next Due
  @JsonKey(name: 'next_dose_due_date')
  DateTime? get nextDoseDate => throw _privateConstructorUsedError; // Notes
  @JsonKey(name: 'notes')
  String? get notes => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_at')
  DateTime? get createdAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'updated_at')
  DateTime? get updatedAt => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $DewormingRecordCopyWith<DewormingRecord> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DewormingRecordCopyWith<$Res> {
  factory $DewormingRecordCopyWith(
          DewormingRecord value, $Res Function(DewormingRecord) then) =
      _$DewormingRecordCopyWithImpl<$Res, DewormingRecord>;
  @useResult
  $Res call(
      {@JsonKey(name: 'id') String? id,
      @JsonKey(name: 'child_profile_id') String childId,
      @JsonKey(name: 'date_given') DateTime dateGiven,
      @JsonKey(name: 'age_in_months') int ageInMonths,
      @JsonKey(name: 'dose_number') int? doseNumber,
      @JsonKey(name: 'drug_name') String drugName,
      @JsonKey(name: 'dosage') String dosage,
      @JsonKey(name: 'given_by') String? givenBy,
      @JsonKey(name: 'health_facility') String? healthFacilityName,
      @JsonKey(name: 'side_effects_reported') bool sideEffectsReported,
      @JsonKey(name: 'side_effects_description') String? sideEffectsDescription,
      @JsonKey(name: 'next_dose_due_date') DateTime? nextDoseDate,
      @JsonKey(name: 'notes') String? notes,
      @JsonKey(name: 'created_at') DateTime? createdAt,
      @JsonKey(name: 'updated_at') DateTime? updatedAt});
}

/// @nodoc
class _$DewormingRecordCopyWithImpl<$Res, $Val extends DewormingRecord>
    implements $DewormingRecordCopyWith<$Res> {
  _$DewormingRecordCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? childId = null,
    Object? dateGiven = null,
    Object? ageInMonths = null,
    Object? doseNumber = freezed,
    Object? drugName = null,
    Object? dosage = null,
    Object? givenBy = freezed,
    Object? healthFacilityName = freezed,
    Object? sideEffectsReported = null,
    Object? sideEffectsDescription = freezed,
    Object? nextDoseDate = freezed,
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
      dateGiven: null == dateGiven
          ? _value.dateGiven
          : dateGiven // ignore: cast_nullable_to_non_nullable
              as DateTime,
      ageInMonths: null == ageInMonths
          ? _value.ageInMonths
          : ageInMonths // ignore: cast_nullable_to_non_nullable
              as int,
      doseNumber: freezed == doseNumber
          ? _value.doseNumber
          : doseNumber // ignore: cast_nullable_to_non_nullable
              as int?,
      drugName: null == drugName
          ? _value.drugName
          : drugName // ignore: cast_nullable_to_non_nullable
              as String,
      dosage: null == dosage
          ? _value.dosage
          : dosage // ignore: cast_nullable_to_non_nullable
              as String,
      givenBy: freezed == givenBy
          ? _value.givenBy
          : givenBy // ignore: cast_nullable_to_non_nullable
              as String?,
      healthFacilityName: freezed == healthFacilityName
          ? _value.healthFacilityName
          : healthFacilityName // ignore: cast_nullable_to_non_nullable
              as String?,
      sideEffectsReported: null == sideEffectsReported
          ? _value.sideEffectsReported
          : sideEffectsReported // ignore: cast_nullable_to_non_nullable
              as bool,
      sideEffectsDescription: freezed == sideEffectsDescription
          ? _value.sideEffectsDescription
          : sideEffectsDescription // ignore: cast_nullable_to_non_nullable
              as String?,
      nextDoseDate: freezed == nextDoseDate
          ? _value.nextDoseDate
          : nextDoseDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
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
abstract class _$$DewormingRecordImplCopyWith<$Res>
    implements $DewormingRecordCopyWith<$Res> {
  factory _$$DewormingRecordImplCopyWith(_$DewormingRecordImpl value,
          $Res Function(_$DewormingRecordImpl) then) =
      __$$DewormingRecordImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'id') String? id,
      @JsonKey(name: 'child_profile_id') String childId,
      @JsonKey(name: 'date_given') DateTime dateGiven,
      @JsonKey(name: 'age_in_months') int ageInMonths,
      @JsonKey(name: 'dose_number') int? doseNumber,
      @JsonKey(name: 'drug_name') String drugName,
      @JsonKey(name: 'dosage') String dosage,
      @JsonKey(name: 'given_by') String? givenBy,
      @JsonKey(name: 'health_facility') String? healthFacilityName,
      @JsonKey(name: 'side_effects_reported') bool sideEffectsReported,
      @JsonKey(name: 'side_effects_description') String? sideEffectsDescription,
      @JsonKey(name: 'next_dose_due_date') DateTime? nextDoseDate,
      @JsonKey(name: 'notes') String? notes,
      @JsonKey(name: 'created_at') DateTime? createdAt,
      @JsonKey(name: 'updated_at') DateTime? updatedAt});
}

/// @nodoc
class __$$DewormingRecordImplCopyWithImpl<$Res>
    extends _$DewormingRecordCopyWithImpl<$Res, _$DewormingRecordImpl>
    implements _$$DewormingRecordImplCopyWith<$Res> {
  __$$DewormingRecordImplCopyWithImpl(
      _$DewormingRecordImpl _value, $Res Function(_$DewormingRecordImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? childId = null,
    Object? dateGiven = null,
    Object? ageInMonths = null,
    Object? doseNumber = freezed,
    Object? drugName = null,
    Object? dosage = null,
    Object? givenBy = freezed,
    Object? healthFacilityName = freezed,
    Object? sideEffectsReported = null,
    Object? sideEffectsDescription = freezed,
    Object? nextDoseDate = freezed,
    Object? notes = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(_$DewormingRecordImpl(
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String?,
      childId: null == childId
          ? _value.childId
          : childId // ignore: cast_nullable_to_non_nullable
              as String,
      dateGiven: null == dateGiven
          ? _value.dateGiven
          : dateGiven // ignore: cast_nullable_to_non_nullable
              as DateTime,
      ageInMonths: null == ageInMonths
          ? _value.ageInMonths
          : ageInMonths // ignore: cast_nullable_to_non_nullable
              as int,
      doseNumber: freezed == doseNumber
          ? _value.doseNumber
          : doseNumber // ignore: cast_nullable_to_non_nullable
              as int?,
      drugName: null == drugName
          ? _value.drugName
          : drugName // ignore: cast_nullable_to_non_nullable
              as String,
      dosage: null == dosage
          ? _value.dosage
          : dosage // ignore: cast_nullable_to_non_nullable
              as String,
      givenBy: freezed == givenBy
          ? _value.givenBy
          : givenBy // ignore: cast_nullable_to_non_nullable
              as String?,
      healthFacilityName: freezed == healthFacilityName
          ? _value.healthFacilityName
          : healthFacilityName // ignore: cast_nullable_to_non_nullable
              as String?,
      sideEffectsReported: null == sideEffectsReported
          ? _value.sideEffectsReported
          : sideEffectsReported // ignore: cast_nullable_to_non_nullable
              as bool,
      sideEffectsDescription: freezed == sideEffectsDescription
          ? _value.sideEffectsDescription
          : sideEffectsDescription // ignore: cast_nullable_to_non_nullable
              as String?,
      nextDoseDate: freezed == nextDoseDate
          ? _value.nextDoseDate
          : nextDoseDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
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
class _$DewormingRecordImpl implements _DewormingRecord {
  const _$DewormingRecordImpl(
      {@JsonKey(name: 'id') this.id,
      @JsonKey(name: 'child_profile_id') required this.childId,
      @JsonKey(name: 'date_given') required this.dateGiven,
      @JsonKey(name: 'age_in_months') required this.ageInMonths,
      @JsonKey(name: 'dose_number') this.doseNumber,
      @JsonKey(name: 'drug_name') required this.drugName,
      @JsonKey(name: 'dosage') required this.dosage,
      @JsonKey(name: 'given_by') this.givenBy,
      @JsonKey(name: 'health_facility') this.healthFacilityName,
      @JsonKey(name: 'side_effects_reported') this.sideEffectsReported = false,
      @JsonKey(name: 'side_effects_description') this.sideEffectsDescription,
      @JsonKey(name: 'next_dose_due_date') this.nextDoseDate,
      @JsonKey(name: 'notes') this.notes,
      @JsonKey(name: 'created_at') this.createdAt,
      @JsonKey(name: 'updated_at') this.updatedAt});

  factory _$DewormingRecordImpl.fromJson(Map<String, dynamic> json) =>
      _$$DewormingRecordImplFromJson(json);

  @override
  @JsonKey(name: 'id')
  final String? id;
  @override
  @JsonKey(name: 'child_profile_id')
  final String childId;
  @override
  @JsonKey(name: 'date_given')
  final DateTime dateGiven;
  @override
  @JsonKey(name: 'age_in_months')
  final int ageInMonths;
  @override
  @JsonKey(name: 'dose_number')
  final int? doseNumber;
// Drug Information
  @override
  @JsonKey(name: 'drug_name')
  final String drugName;
// Albendazole or Mebendazole
  @override
  @JsonKey(name: 'dosage')
  final String dosage;
// "400mg" or "500mg"
// Administration
  @override
  @JsonKey(name: 'given_by')
  final String? givenBy;
  @override
  @JsonKey(name: 'health_facility')
  final String? healthFacilityName;
// Side Effects
  @override
  @JsonKey(name: 'side_effects_reported')
  final bool sideEffectsReported;
  @override
  @JsonKey(name: 'side_effects_description')
  final String? sideEffectsDescription;
// Next Due
  @override
  @JsonKey(name: 'next_dose_due_date')
  final DateTime? nextDoseDate;
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
    return 'DewormingRecord(id: $id, childId: $childId, dateGiven: $dateGiven, ageInMonths: $ageInMonths, doseNumber: $doseNumber, drugName: $drugName, dosage: $dosage, givenBy: $givenBy, healthFacilityName: $healthFacilityName, sideEffectsReported: $sideEffectsReported, sideEffectsDescription: $sideEffectsDescription, nextDoseDate: $nextDoseDate, notes: $notes, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DewormingRecordImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.childId, childId) || other.childId == childId) &&
            (identical(other.dateGiven, dateGiven) ||
                other.dateGiven == dateGiven) &&
            (identical(other.ageInMonths, ageInMonths) ||
                other.ageInMonths == ageInMonths) &&
            (identical(other.doseNumber, doseNumber) ||
                other.doseNumber == doseNumber) &&
            (identical(other.drugName, drugName) ||
                other.drugName == drugName) &&
            (identical(other.dosage, dosage) || other.dosage == dosage) &&
            (identical(other.givenBy, givenBy) || other.givenBy == givenBy) &&
            (identical(other.healthFacilityName, healthFacilityName) ||
                other.healthFacilityName == healthFacilityName) &&
            (identical(other.sideEffectsReported, sideEffectsReported) ||
                other.sideEffectsReported == sideEffectsReported) &&
            (identical(other.sideEffectsDescription, sideEffectsDescription) ||
                other.sideEffectsDescription == sideEffectsDescription) &&
            (identical(other.nextDoseDate, nextDoseDate) ||
                other.nextDoseDate == nextDoseDate) &&
            (identical(other.notes, notes) || other.notes == notes) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      childId,
      dateGiven,
      ageInMonths,
      doseNumber,
      drugName,
      dosage,
      givenBy,
      healthFacilityName,
      sideEffectsReported,
      sideEffectsDescription,
      nextDoseDate,
      notes,
      createdAt,
      updatedAt);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$DewormingRecordImplCopyWith<_$DewormingRecordImpl> get copyWith =>
      __$$DewormingRecordImplCopyWithImpl<_$DewormingRecordImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$DewormingRecordImplToJson(
      this,
    );
  }
}

abstract class _DewormingRecord implements DewormingRecord {
  const factory _DewormingRecord(
      {@JsonKey(name: 'id') final String? id,
      @JsonKey(name: 'child_profile_id') required final String childId,
      @JsonKey(name: 'date_given') required final DateTime dateGiven,
      @JsonKey(name: 'age_in_months') required final int ageInMonths,
      @JsonKey(name: 'dose_number') final int? doseNumber,
      @JsonKey(name: 'drug_name') required final String drugName,
      @JsonKey(name: 'dosage') required final String dosage,
      @JsonKey(name: 'given_by') final String? givenBy,
      @JsonKey(name: 'health_facility') final String? healthFacilityName,
      @JsonKey(name: 'side_effects_reported') final bool sideEffectsReported,
      @JsonKey(name: 'side_effects_description')
      final String? sideEffectsDescription,
      @JsonKey(name: 'next_dose_due_date') final DateTime? nextDoseDate,
      @JsonKey(name: 'notes') final String? notes,
      @JsonKey(name: 'created_at') final DateTime? createdAt,
      @JsonKey(name: 'updated_at')
      final DateTime? updatedAt}) = _$DewormingRecordImpl;

  factory _DewormingRecord.fromJson(Map<String, dynamic> json) =
      _$DewormingRecordImpl.fromJson;

  @override
  @JsonKey(name: 'id')
  String? get id;
  @override
  @JsonKey(name: 'child_profile_id')
  String get childId;
  @override
  @JsonKey(name: 'date_given')
  DateTime get dateGiven;
  @override
  @JsonKey(name: 'age_in_months')
  int get ageInMonths;
  @override
  @JsonKey(name: 'dose_number')
  int? get doseNumber;
  @override // Drug Information
  @JsonKey(name: 'drug_name')
  String get drugName;
  @override // Albendazole or Mebendazole
  @JsonKey(name: 'dosage')
  String get dosage;
  @override // "400mg" or "500mg"
// Administration
  @JsonKey(name: 'given_by')
  String? get givenBy;
  @override
  @JsonKey(name: 'health_facility')
  String? get healthFacilityName;
  @override // Side Effects
  @JsonKey(name: 'side_effects_reported')
  bool get sideEffectsReported;
  @override
  @JsonKey(name: 'side_effects_description')
  String? get sideEffectsDescription;
  @override // Next Due
  @JsonKey(name: 'next_dose_due_date')
  DateTime? get nextDoseDate;
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
  _$$DewormingRecordImplCopyWith<_$DewormingRecordImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
