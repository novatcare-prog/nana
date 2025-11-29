// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'vitamin_a_record.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

VitaminARecord _$VitaminARecordFromJson(Map<String, dynamic> json) {
  return _VitaminARecord.fromJson(json);
}

/// @nodoc
mixin _$VitaminARecord {
  @JsonKey(name: 'id')
  String? get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'child_profile_id')
  String get childId => throw _privateConstructorUsedError;
  @JsonKey(name: 'date_given')
  DateTime get dateGiven => throw _privateConstructorUsedError;
  @JsonKey(name: 'age_in_months')
  int get ageInMonths => throw _privateConstructorUsedError;
  @JsonKey(name: 'dose_number')
  int? get doseNumber => throw _privateConstructorUsedError; // Dosage
  @JsonKey(name: 'dosage_iu')
  int get dosageIU => throw _privateConstructorUsedError; // 100,000 or 200,000
// Administration
  @JsonKey(name: 'given_by')
  String? get givenBy => throw _privateConstructorUsedError;
  @JsonKey(name: 'health_facility')
  String? get healthFacilityName =>
      throw _privateConstructorUsedError; // Next Due
  @JsonKey(name: 'next_dose_due_date')
  DateTime? get nextDoseDate =>
      throw _privateConstructorUsedError; // 6 months later
// Notes
  @JsonKey(name: 'notes')
  String? get notes => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_at')
  DateTime? get createdAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'updated_at')
  DateTime? get updatedAt => throw _privateConstructorUsedError;

  /// Serializes this VitaminARecord to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of VitaminARecord
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $VitaminARecordCopyWith<VitaminARecord> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $VitaminARecordCopyWith<$Res> {
  factory $VitaminARecordCopyWith(
          VitaminARecord value, $Res Function(VitaminARecord) then) =
      _$VitaminARecordCopyWithImpl<$Res, VitaminARecord>;
  @useResult
  $Res call(
      {@JsonKey(name: 'id') String? id,
      @JsonKey(name: 'child_profile_id') String childId,
      @JsonKey(name: 'date_given') DateTime dateGiven,
      @JsonKey(name: 'age_in_months') int ageInMonths,
      @JsonKey(name: 'dose_number') int? doseNumber,
      @JsonKey(name: 'dosage_iu') int dosageIU,
      @JsonKey(name: 'given_by') String? givenBy,
      @JsonKey(name: 'health_facility') String? healthFacilityName,
      @JsonKey(name: 'next_dose_due_date') DateTime? nextDoseDate,
      @JsonKey(name: 'notes') String? notes,
      @JsonKey(name: 'created_at') DateTime? createdAt,
      @JsonKey(name: 'updated_at') DateTime? updatedAt});
}

/// @nodoc
class _$VitaminARecordCopyWithImpl<$Res, $Val extends VitaminARecord>
    implements $VitaminARecordCopyWith<$Res> {
  _$VitaminARecordCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of VitaminARecord
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? childId = null,
    Object? dateGiven = null,
    Object? ageInMonths = null,
    Object? doseNumber = freezed,
    Object? dosageIU = null,
    Object? givenBy = freezed,
    Object? healthFacilityName = freezed,
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
      dosageIU: null == dosageIU
          ? _value.dosageIU
          : dosageIU // ignore: cast_nullable_to_non_nullable
              as int,
      givenBy: freezed == givenBy
          ? _value.givenBy
          : givenBy // ignore: cast_nullable_to_non_nullable
              as String?,
      healthFacilityName: freezed == healthFacilityName
          ? _value.healthFacilityName
          : healthFacilityName // ignore: cast_nullable_to_non_nullable
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
abstract class _$$VitaminARecordImplCopyWith<$Res>
    implements $VitaminARecordCopyWith<$Res> {
  factory _$$VitaminARecordImplCopyWith(_$VitaminARecordImpl value,
          $Res Function(_$VitaminARecordImpl) then) =
      __$$VitaminARecordImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'id') String? id,
      @JsonKey(name: 'child_profile_id') String childId,
      @JsonKey(name: 'date_given') DateTime dateGiven,
      @JsonKey(name: 'age_in_months') int ageInMonths,
      @JsonKey(name: 'dose_number') int? doseNumber,
      @JsonKey(name: 'dosage_iu') int dosageIU,
      @JsonKey(name: 'given_by') String? givenBy,
      @JsonKey(name: 'health_facility') String? healthFacilityName,
      @JsonKey(name: 'next_dose_due_date') DateTime? nextDoseDate,
      @JsonKey(name: 'notes') String? notes,
      @JsonKey(name: 'created_at') DateTime? createdAt,
      @JsonKey(name: 'updated_at') DateTime? updatedAt});
}

/// @nodoc
class __$$VitaminARecordImplCopyWithImpl<$Res>
    extends _$VitaminARecordCopyWithImpl<$Res, _$VitaminARecordImpl>
    implements _$$VitaminARecordImplCopyWith<$Res> {
  __$$VitaminARecordImplCopyWithImpl(
      _$VitaminARecordImpl _value, $Res Function(_$VitaminARecordImpl) _then)
      : super(_value, _then);

  /// Create a copy of VitaminARecord
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? childId = null,
    Object? dateGiven = null,
    Object? ageInMonths = null,
    Object? doseNumber = freezed,
    Object? dosageIU = null,
    Object? givenBy = freezed,
    Object? healthFacilityName = freezed,
    Object? nextDoseDate = freezed,
    Object? notes = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(_$VitaminARecordImpl(
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
      dosageIU: null == dosageIU
          ? _value.dosageIU
          : dosageIU // ignore: cast_nullable_to_non_nullable
              as int,
      givenBy: freezed == givenBy
          ? _value.givenBy
          : givenBy // ignore: cast_nullable_to_non_nullable
              as String?,
      healthFacilityName: freezed == healthFacilityName
          ? _value.healthFacilityName
          : healthFacilityName // ignore: cast_nullable_to_non_nullable
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
class _$VitaminARecordImpl implements _VitaminARecord {
  const _$VitaminARecordImpl(
      {@JsonKey(name: 'id') this.id,
      @JsonKey(name: 'child_profile_id') required this.childId,
      @JsonKey(name: 'date_given') required this.dateGiven,
      @JsonKey(name: 'age_in_months') required this.ageInMonths,
      @JsonKey(name: 'dose_number') this.doseNumber,
      @JsonKey(name: 'dosage_iu') required this.dosageIU,
      @JsonKey(name: 'given_by') this.givenBy,
      @JsonKey(name: 'health_facility') this.healthFacilityName,
      @JsonKey(name: 'next_dose_due_date') this.nextDoseDate,
      @JsonKey(name: 'notes') this.notes,
      @JsonKey(name: 'created_at') this.createdAt,
      @JsonKey(name: 'updated_at') this.updatedAt});

  factory _$VitaminARecordImpl.fromJson(Map<String, dynamic> json) =>
      _$$VitaminARecordImplFromJson(json);

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
// Dosage
  @override
  @JsonKey(name: 'dosage_iu')
  final int dosageIU;
// 100,000 or 200,000
// Administration
  @override
  @JsonKey(name: 'given_by')
  final String? givenBy;
  @override
  @JsonKey(name: 'health_facility')
  final String? healthFacilityName;
// Next Due
  @override
  @JsonKey(name: 'next_dose_due_date')
  final DateTime? nextDoseDate;
// 6 months later
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
    return 'VitaminARecord(id: $id, childId: $childId, dateGiven: $dateGiven, ageInMonths: $ageInMonths, doseNumber: $doseNumber, dosageIU: $dosageIU, givenBy: $givenBy, healthFacilityName: $healthFacilityName, nextDoseDate: $nextDoseDate, notes: $notes, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$VitaminARecordImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.childId, childId) || other.childId == childId) &&
            (identical(other.dateGiven, dateGiven) ||
                other.dateGiven == dateGiven) &&
            (identical(other.ageInMonths, ageInMonths) ||
                other.ageInMonths == ageInMonths) &&
            (identical(other.doseNumber, doseNumber) ||
                other.doseNumber == doseNumber) &&
            (identical(other.dosageIU, dosageIU) ||
                other.dosageIU == dosageIU) &&
            (identical(other.givenBy, givenBy) || other.givenBy == givenBy) &&
            (identical(other.healthFacilityName, healthFacilityName) ||
                other.healthFacilityName == healthFacilityName) &&
            (identical(other.nextDoseDate, nextDoseDate) ||
                other.nextDoseDate == nextDoseDate) &&
            (identical(other.notes, notes) || other.notes == notes) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      childId,
      dateGiven,
      ageInMonths,
      doseNumber,
      dosageIU,
      givenBy,
      healthFacilityName,
      nextDoseDate,
      notes,
      createdAt,
      updatedAt);

  /// Create a copy of VitaminARecord
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$VitaminARecordImplCopyWith<_$VitaminARecordImpl> get copyWith =>
      __$$VitaminARecordImplCopyWithImpl<_$VitaminARecordImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$VitaminARecordImplToJson(
      this,
    );
  }
}

abstract class _VitaminARecord implements VitaminARecord {
  const factory _VitaminARecord(
          {@JsonKey(name: 'id') final String? id,
          @JsonKey(name: 'child_profile_id') required final String childId,
          @JsonKey(name: 'date_given') required final DateTime dateGiven,
          @JsonKey(name: 'age_in_months') required final int ageInMonths,
          @JsonKey(name: 'dose_number') final int? doseNumber,
          @JsonKey(name: 'dosage_iu') required final int dosageIU,
          @JsonKey(name: 'given_by') final String? givenBy,
          @JsonKey(name: 'health_facility') final String? healthFacilityName,
          @JsonKey(name: 'next_dose_due_date') final DateTime? nextDoseDate,
          @JsonKey(name: 'notes') final String? notes,
          @JsonKey(name: 'created_at') final DateTime? createdAt,
          @JsonKey(name: 'updated_at') final DateTime? updatedAt}) =
      _$VitaminARecordImpl;

  factory _VitaminARecord.fromJson(Map<String, dynamic> json) =
      _$VitaminARecordImpl.fromJson;

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
  int? get doseNumber; // Dosage
  @override
  @JsonKey(name: 'dosage_iu')
  int get dosageIU; // 100,000 or 200,000
// Administration
  @override
  @JsonKey(name: 'given_by')
  String? get givenBy;
  @override
  @JsonKey(name: 'health_facility')
  String? get healthFacilityName; // Next Due
  @override
  @JsonKey(name: 'next_dose_due_date')
  DateTime? get nextDoseDate; // 6 months later
// Notes
  @override
  @JsonKey(name: 'notes')
  String? get notes;
  @override
  @JsonKey(name: 'created_at')
  DateTime? get createdAt;
  @override
  @JsonKey(name: 'updated_at')
  DateTime? get updatedAt;

  /// Create a copy of VitaminARecord
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$VitaminARecordImplCopyWith<_$VitaminARecordImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
