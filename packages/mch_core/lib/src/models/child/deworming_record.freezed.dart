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
  String get id => throw _privateConstructorUsedError;
  String get childId => throw _privateConstructorUsedError;
  DateTime get dateGiven => throw _privateConstructorUsedError;
  int get ageInMonths => throw _privateConstructorUsedError; // Dosage
  String get dosage => throw _privateConstructorUsedError; // "200mg" or "400mg"
  String get tabletCount =>
      throw _privateConstructorUsedError; // "Half tablet" or "One tablet"
// Administration
  String? get givenBy => throw _privateConstructorUsedError;
  String? get healthFacilityName =>
      throw _privateConstructorUsedError; // Next Due
  DateTime? get nextDoseDate =>
      throw _privateConstructorUsedError; // 6 months later
// Notes
  String? get notes => throw _privateConstructorUsedError;
  DateTime? get createdAt => throw _privateConstructorUsedError;
  DateTime? get updatedAt => throw _privateConstructorUsedError;

  /// Serializes this DewormingRecord to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of DewormingRecord
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
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
      {String id,
      String childId,
      DateTime dateGiven,
      int ageInMonths,
      String dosage,
      String tabletCount,
      String? givenBy,
      String? healthFacilityName,
      DateTime? nextDoseDate,
      String? notes,
      DateTime? createdAt,
      DateTime? updatedAt});
}

/// @nodoc
class _$DewormingRecordCopyWithImpl<$Res, $Val extends DewormingRecord>
    implements $DewormingRecordCopyWith<$Res> {
  _$DewormingRecordCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of DewormingRecord
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? childId = null,
    Object? dateGiven = null,
    Object? ageInMonths = null,
    Object? dosage = null,
    Object? tabletCount = null,
    Object? givenBy = freezed,
    Object? healthFacilityName = freezed,
    Object? nextDoseDate = freezed,
    Object? notes = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
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
      dosage: null == dosage
          ? _value.dosage
          : dosage // ignore: cast_nullable_to_non_nullable
              as String,
      tabletCount: null == tabletCount
          ? _value.tabletCount
          : tabletCount // ignore: cast_nullable_to_non_nullable
              as String,
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
abstract class _$$DewormingRecordImplCopyWith<$Res>
    implements $DewormingRecordCopyWith<$Res> {
  factory _$$DewormingRecordImplCopyWith(_$DewormingRecordImpl value,
          $Res Function(_$DewormingRecordImpl) then) =
      __$$DewormingRecordImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String childId,
      DateTime dateGiven,
      int ageInMonths,
      String dosage,
      String tabletCount,
      String? givenBy,
      String? healthFacilityName,
      DateTime? nextDoseDate,
      String? notes,
      DateTime? createdAt,
      DateTime? updatedAt});
}

/// @nodoc
class __$$DewormingRecordImplCopyWithImpl<$Res>
    extends _$DewormingRecordCopyWithImpl<$Res, _$DewormingRecordImpl>
    implements _$$DewormingRecordImplCopyWith<$Res> {
  __$$DewormingRecordImplCopyWithImpl(
      _$DewormingRecordImpl _value, $Res Function(_$DewormingRecordImpl) _then)
      : super(_value, _then);

  /// Create a copy of DewormingRecord
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? childId = null,
    Object? dateGiven = null,
    Object? ageInMonths = null,
    Object? dosage = null,
    Object? tabletCount = null,
    Object? givenBy = freezed,
    Object? healthFacilityName = freezed,
    Object? nextDoseDate = freezed,
    Object? notes = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(_$DewormingRecordImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
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
      dosage: null == dosage
          ? _value.dosage
          : dosage // ignore: cast_nullable_to_non_nullable
              as String,
      tabletCount: null == tabletCount
          ? _value.tabletCount
          : tabletCount // ignore: cast_nullable_to_non_nullable
              as String,
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
class _$DewormingRecordImpl implements _DewormingRecord {
  const _$DewormingRecordImpl(
      {required this.id,
      required this.childId,
      required this.dateGiven,
      required this.ageInMonths,
      required this.dosage,
      required this.tabletCount,
      this.givenBy,
      this.healthFacilityName,
      this.nextDoseDate,
      this.notes,
      this.createdAt,
      this.updatedAt});

  factory _$DewormingRecordImpl.fromJson(Map<String, dynamic> json) =>
      _$$DewormingRecordImplFromJson(json);

  @override
  final String id;
  @override
  final String childId;
  @override
  final DateTime dateGiven;
  @override
  final int ageInMonths;
// Dosage
  @override
  final String dosage;
// "200mg" or "400mg"
  @override
  final String tabletCount;
// "Half tablet" or "One tablet"
// Administration
  @override
  final String? givenBy;
  @override
  final String? healthFacilityName;
// Next Due
  @override
  final DateTime? nextDoseDate;
// 6 months later
// Notes
  @override
  final String? notes;
  @override
  final DateTime? createdAt;
  @override
  final DateTime? updatedAt;

  @override
  String toString() {
    return 'DewormingRecord(id: $id, childId: $childId, dateGiven: $dateGiven, ageInMonths: $ageInMonths, dosage: $dosage, tabletCount: $tabletCount, givenBy: $givenBy, healthFacilityName: $healthFacilityName, nextDoseDate: $nextDoseDate, notes: $notes, createdAt: $createdAt, updatedAt: $updatedAt)';
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
            (identical(other.dosage, dosage) || other.dosage == dosage) &&
            (identical(other.tabletCount, tabletCount) ||
                other.tabletCount == tabletCount) &&
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
      dosage,
      tabletCount,
      givenBy,
      healthFacilityName,
      nextDoseDate,
      notes,
      createdAt,
      updatedAt);

  /// Create a copy of DewormingRecord
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
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
      {required final String id,
      required final String childId,
      required final DateTime dateGiven,
      required final int ageInMonths,
      required final String dosage,
      required final String tabletCount,
      final String? givenBy,
      final String? healthFacilityName,
      final DateTime? nextDoseDate,
      final String? notes,
      final DateTime? createdAt,
      final DateTime? updatedAt}) = _$DewormingRecordImpl;

  factory _DewormingRecord.fromJson(Map<String, dynamic> json) =
      _$DewormingRecordImpl.fromJson;

  @override
  String get id;
  @override
  String get childId;
  @override
  DateTime get dateGiven;
  @override
  int get ageInMonths; // Dosage
  @override
  String get dosage; // "200mg" or "400mg"
  @override
  String get tabletCount; // "Half tablet" or "One tablet"
// Administration
  @override
  String? get givenBy;
  @override
  String? get healthFacilityName; // Next Due
  @override
  DateTime? get nextDoseDate; // 6 months later
// Notes
  @override
  String? get notes;
  @override
  DateTime? get createdAt;
  @override
  DateTime? get updatedAt;

  /// Create a copy of DewormingRecord
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$DewormingRecordImplCopyWith<_$DewormingRecordImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
