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
  String get id => throw _privateConstructorUsedError;
  String get childId => throw _privateConstructorUsedError;
  ImmunizationType get vaccineType => throw _privateConstructorUsedError;
  DateTime get dateGiven => throw _privateConstructorUsedError;
  int get ageInWeeks =>
      throw _privateConstructorUsedError; // Child's age when vaccine given
// Dose Information
  int? get doseNumber =>
      throw _privateConstructorUsedError; // 1st, 2nd, 3rd dose
  String? get dosage =>
      throw _privateConstructorUsedError; // e.g., "0.05ml", "0.5ml", "2 drops"
  String? get administrationRoute =>
      throw _privateConstructorUsedError; // Oral, IM, Intradermal, Subcutaneous
  String? get administrationSite =>
      throw _privateConstructorUsedError; // Left forearm, Right thigh, etc.
// Vaccine Details
  String? get batchNumber => throw _privateConstructorUsedError;
  String? get manufacturer => throw _privateConstructorUsedError;
  DateTime? get manufactureDate => throw _privateConstructorUsedError;
  DateTime? get expiryDate =>
      throw _privateConstructorUsedError; // BCG Specific
  bool? get bcgScarChecked => throw _privateConstructorUsedError;
  bool? get bcgScarPresent => throw _privateConstructorUsedError;
  DateTime? get bcgScarCheckDate =>
      throw _privateConstructorUsedError; // Administration
  String? get givenBy =>
      throw _privateConstructorUsedError; // Health worker name
  String? get healthFacilityName =>
      throw _privateConstructorUsedError; // AEFI (Adverse Events Following Immunization)
  bool? get adverseEventReported => throw _privateConstructorUsedError;
  String? get adverseEventDescription => throw _privateConstructorUsedError;
  DateTime? get adverseEventDate =>
      throw _privateConstructorUsedError; // Next Due
  DateTime? get nextDoseDate => throw _privateConstructorUsedError; // Notes
  String? get notes => throw _privateConstructorUsedError;
  DateTime? get createdAt => throw _privateConstructorUsedError;
  DateTime? get updatedAt => throw _privateConstructorUsedError;

  /// Serializes this ImmunizationRecord to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ImmunizationRecord
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
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
      {String id,
      String childId,
      ImmunizationType vaccineType,
      DateTime dateGiven,
      int ageInWeeks,
      int? doseNumber,
      String? dosage,
      String? administrationRoute,
      String? administrationSite,
      String? batchNumber,
      String? manufacturer,
      DateTime? manufactureDate,
      DateTime? expiryDate,
      bool? bcgScarChecked,
      bool? bcgScarPresent,
      DateTime? bcgScarCheckDate,
      String? givenBy,
      String? healthFacilityName,
      bool? adverseEventReported,
      String? adverseEventDescription,
      DateTime? adverseEventDate,
      DateTime? nextDoseDate,
      String? notes,
      DateTime? createdAt,
      DateTime? updatedAt});
}

/// @nodoc
class _$ImmunizationRecordCopyWithImpl<$Res, $Val extends ImmunizationRecord>
    implements $ImmunizationRecordCopyWith<$Res> {
  _$ImmunizationRecordCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ImmunizationRecord
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? childId = null,
    Object? vaccineType = null,
    Object? dateGiven = null,
    Object? ageInWeeks = null,
    Object? doseNumber = freezed,
    Object? dosage = freezed,
    Object? administrationRoute = freezed,
    Object? administrationSite = freezed,
    Object? batchNumber = freezed,
    Object? manufacturer = freezed,
    Object? manufactureDate = freezed,
    Object? expiryDate = freezed,
    Object? bcgScarChecked = freezed,
    Object? bcgScarPresent = freezed,
    Object? bcgScarCheckDate = freezed,
    Object? givenBy = freezed,
    Object? healthFacilityName = freezed,
    Object? adverseEventReported = freezed,
    Object? adverseEventDescription = freezed,
    Object? adverseEventDate = freezed,
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
      vaccineType: null == vaccineType
          ? _value.vaccineType
          : vaccineType // ignore: cast_nullable_to_non_nullable
              as ImmunizationType,
      dateGiven: null == dateGiven
          ? _value.dateGiven
          : dateGiven // ignore: cast_nullable_to_non_nullable
              as DateTime,
      ageInWeeks: null == ageInWeeks
          ? _value.ageInWeeks
          : ageInWeeks // ignore: cast_nullable_to_non_nullable
              as int,
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
      healthFacilityName: freezed == healthFacilityName
          ? _value.healthFacilityName
          : healthFacilityName // ignore: cast_nullable_to_non_nullable
              as String?,
      adverseEventReported: freezed == adverseEventReported
          ? _value.adverseEventReported
          : adverseEventReported // ignore: cast_nullable_to_non_nullable
              as bool?,
      adverseEventDescription: freezed == adverseEventDescription
          ? _value.adverseEventDescription
          : adverseEventDescription // ignore: cast_nullable_to_non_nullable
              as String?,
      adverseEventDate: freezed == adverseEventDate
          ? _value.adverseEventDate
          : adverseEventDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
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
abstract class _$$ImmunizationRecordImplCopyWith<$Res>
    implements $ImmunizationRecordCopyWith<$Res> {
  factory _$$ImmunizationRecordImplCopyWith(_$ImmunizationRecordImpl value,
          $Res Function(_$ImmunizationRecordImpl) then) =
      __$$ImmunizationRecordImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String childId,
      ImmunizationType vaccineType,
      DateTime dateGiven,
      int ageInWeeks,
      int? doseNumber,
      String? dosage,
      String? administrationRoute,
      String? administrationSite,
      String? batchNumber,
      String? manufacturer,
      DateTime? manufactureDate,
      DateTime? expiryDate,
      bool? bcgScarChecked,
      bool? bcgScarPresent,
      DateTime? bcgScarCheckDate,
      String? givenBy,
      String? healthFacilityName,
      bool? adverseEventReported,
      String? adverseEventDescription,
      DateTime? adverseEventDate,
      DateTime? nextDoseDate,
      String? notes,
      DateTime? createdAt,
      DateTime? updatedAt});
}

/// @nodoc
class __$$ImmunizationRecordImplCopyWithImpl<$Res>
    extends _$ImmunizationRecordCopyWithImpl<$Res, _$ImmunizationRecordImpl>
    implements _$$ImmunizationRecordImplCopyWith<$Res> {
  __$$ImmunizationRecordImplCopyWithImpl(_$ImmunizationRecordImpl _value,
      $Res Function(_$ImmunizationRecordImpl) _then)
      : super(_value, _then);

  /// Create a copy of ImmunizationRecord
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? childId = null,
    Object? vaccineType = null,
    Object? dateGiven = null,
    Object? ageInWeeks = null,
    Object? doseNumber = freezed,
    Object? dosage = freezed,
    Object? administrationRoute = freezed,
    Object? administrationSite = freezed,
    Object? batchNumber = freezed,
    Object? manufacturer = freezed,
    Object? manufactureDate = freezed,
    Object? expiryDate = freezed,
    Object? bcgScarChecked = freezed,
    Object? bcgScarPresent = freezed,
    Object? bcgScarCheckDate = freezed,
    Object? givenBy = freezed,
    Object? healthFacilityName = freezed,
    Object? adverseEventReported = freezed,
    Object? adverseEventDescription = freezed,
    Object? adverseEventDate = freezed,
    Object? nextDoseDate = freezed,
    Object? notes = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(_$ImmunizationRecordImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      childId: null == childId
          ? _value.childId
          : childId // ignore: cast_nullable_to_non_nullable
              as String,
      vaccineType: null == vaccineType
          ? _value.vaccineType
          : vaccineType // ignore: cast_nullable_to_non_nullable
              as ImmunizationType,
      dateGiven: null == dateGiven
          ? _value.dateGiven
          : dateGiven // ignore: cast_nullable_to_non_nullable
              as DateTime,
      ageInWeeks: null == ageInWeeks
          ? _value.ageInWeeks
          : ageInWeeks // ignore: cast_nullable_to_non_nullable
              as int,
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
      healthFacilityName: freezed == healthFacilityName
          ? _value.healthFacilityName
          : healthFacilityName // ignore: cast_nullable_to_non_nullable
              as String?,
      adverseEventReported: freezed == adverseEventReported
          ? _value.adverseEventReported
          : adverseEventReported // ignore: cast_nullable_to_non_nullable
              as bool?,
      adverseEventDescription: freezed == adverseEventDescription
          ? _value.adverseEventDescription
          : adverseEventDescription // ignore: cast_nullable_to_non_nullable
              as String?,
      adverseEventDate: freezed == adverseEventDate
          ? _value.adverseEventDate
          : adverseEventDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
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
class _$ImmunizationRecordImpl implements _ImmunizationRecord {
  const _$ImmunizationRecordImpl(
      {required this.id,
      required this.childId,
      required this.vaccineType,
      required this.dateGiven,
      required this.ageInWeeks,
      this.doseNumber,
      this.dosage,
      this.administrationRoute,
      this.administrationSite,
      this.batchNumber,
      this.manufacturer,
      this.manufactureDate,
      this.expiryDate,
      this.bcgScarChecked,
      this.bcgScarPresent,
      this.bcgScarCheckDate,
      this.givenBy,
      this.healthFacilityName,
      this.adverseEventReported,
      this.adverseEventDescription,
      this.adverseEventDate,
      this.nextDoseDate,
      this.notes,
      this.createdAt,
      this.updatedAt});

  factory _$ImmunizationRecordImpl.fromJson(Map<String, dynamic> json) =>
      _$$ImmunizationRecordImplFromJson(json);

  @override
  final String id;
  @override
  final String childId;
  @override
  final ImmunizationType vaccineType;
  @override
  final DateTime dateGiven;
  @override
  final int ageInWeeks;
// Child's age when vaccine given
// Dose Information
  @override
  final int? doseNumber;
// 1st, 2nd, 3rd dose
  @override
  final String? dosage;
// e.g., "0.05ml", "0.5ml", "2 drops"
  @override
  final String? administrationRoute;
// Oral, IM, Intradermal, Subcutaneous
  @override
  final String? administrationSite;
// Left forearm, Right thigh, etc.
// Vaccine Details
  @override
  final String? batchNumber;
  @override
  final String? manufacturer;
  @override
  final DateTime? manufactureDate;
  @override
  final DateTime? expiryDate;
// BCG Specific
  @override
  final bool? bcgScarChecked;
  @override
  final bool? bcgScarPresent;
  @override
  final DateTime? bcgScarCheckDate;
// Administration
  @override
  final String? givenBy;
// Health worker name
  @override
  final String? healthFacilityName;
// AEFI (Adverse Events Following Immunization)
  @override
  final bool? adverseEventReported;
  @override
  final String? adverseEventDescription;
  @override
  final DateTime? adverseEventDate;
// Next Due
  @override
  final DateTime? nextDoseDate;
// Notes
  @override
  final String? notes;
  @override
  final DateTime? createdAt;
  @override
  final DateTime? updatedAt;

  @override
  String toString() {
    return 'ImmunizationRecord(id: $id, childId: $childId, vaccineType: $vaccineType, dateGiven: $dateGiven, ageInWeeks: $ageInWeeks, doseNumber: $doseNumber, dosage: $dosage, administrationRoute: $administrationRoute, administrationSite: $administrationSite, batchNumber: $batchNumber, manufacturer: $manufacturer, manufactureDate: $manufactureDate, expiryDate: $expiryDate, bcgScarChecked: $bcgScarChecked, bcgScarPresent: $bcgScarPresent, bcgScarCheckDate: $bcgScarCheckDate, givenBy: $givenBy, healthFacilityName: $healthFacilityName, adverseEventReported: $adverseEventReported, adverseEventDescription: $adverseEventDescription, adverseEventDate: $adverseEventDate, nextDoseDate: $nextDoseDate, notes: $notes, createdAt: $createdAt, updatedAt: $updatedAt)';
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
            (identical(other.dateGiven, dateGiven) ||
                other.dateGiven == dateGiven) &&
            (identical(other.ageInWeeks, ageInWeeks) ||
                other.ageInWeeks == ageInWeeks) &&
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
            (identical(other.bcgScarChecked, bcgScarChecked) ||
                other.bcgScarChecked == bcgScarChecked) &&
            (identical(other.bcgScarPresent, bcgScarPresent) ||
                other.bcgScarPresent == bcgScarPresent) &&
            (identical(other.bcgScarCheckDate, bcgScarCheckDate) ||
                other.bcgScarCheckDate == bcgScarCheckDate) &&
            (identical(other.givenBy, givenBy) || other.givenBy == givenBy) &&
            (identical(other.healthFacilityName, healthFacilityName) ||
                other.healthFacilityName == healthFacilityName) &&
            (identical(other.adverseEventReported, adverseEventReported) ||
                other.adverseEventReported == adverseEventReported) &&
            (identical(
                    other.adverseEventDescription, adverseEventDescription) ||
                other.adverseEventDescription == adverseEventDescription) &&
            (identical(other.adverseEventDate, adverseEventDate) ||
                other.adverseEventDate == adverseEventDate) &&
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
  int get hashCode => Object.hashAll([
        runtimeType,
        id,
        childId,
        vaccineType,
        dateGiven,
        ageInWeeks,
        doseNumber,
        dosage,
        administrationRoute,
        administrationSite,
        batchNumber,
        manufacturer,
        manufactureDate,
        expiryDate,
        bcgScarChecked,
        bcgScarPresent,
        bcgScarCheckDate,
        givenBy,
        healthFacilityName,
        adverseEventReported,
        adverseEventDescription,
        adverseEventDate,
        nextDoseDate,
        notes,
        createdAt,
        updatedAt
      ]);

  /// Create a copy of ImmunizationRecord
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
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
      {required final String id,
      required final String childId,
      required final ImmunizationType vaccineType,
      required final DateTime dateGiven,
      required final int ageInWeeks,
      final int? doseNumber,
      final String? dosage,
      final String? administrationRoute,
      final String? administrationSite,
      final String? batchNumber,
      final String? manufacturer,
      final DateTime? manufactureDate,
      final DateTime? expiryDate,
      final bool? bcgScarChecked,
      final bool? bcgScarPresent,
      final DateTime? bcgScarCheckDate,
      final String? givenBy,
      final String? healthFacilityName,
      final bool? adverseEventReported,
      final String? adverseEventDescription,
      final DateTime? adverseEventDate,
      final DateTime? nextDoseDate,
      final String? notes,
      final DateTime? createdAt,
      final DateTime? updatedAt}) = _$ImmunizationRecordImpl;

  factory _ImmunizationRecord.fromJson(Map<String, dynamic> json) =
      _$ImmunizationRecordImpl.fromJson;

  @override
  String get id;
  @override
  String get childId;
  @override
  ImmunizationType get vaccineType;
  @override
  DateTime get dateGiven;
  @override
  int get ageInWeeks; // Child's age when vaccine given
// Dose Information
  @override
  int? get doseNumber; // 1st, 2nd, 3rd dose
  @override
  String? get dosage; // e.g., "0.05ml", "0.5ml", "2 drops"
  @override
  String? get administrationRoute; // Oral, IM, Intradermal, Subcutaneous
  @override
  String? get administrationSite; // Left forearm, Right thigh, etc.
// Vaccine Details
  @override
  String? get batchNumber;
  @override
  String? get manufacturer;
  @override
  DateTime? get manufactureDate;
  @override
  DateTime? get expiryDate; // BCG Specific
  @override
  bool? get bcgScarChecked;
  @override
  bool? get bcgScarPresent;
  @override
  DateTime? get bcgScarCheckDate; // Administration
  @override
  String? get givenBy; // Health worker name
  @override
  String?
      get healthFacilityName; // AEFI (Adverse Events Following Immunization)
  @override
  bool? get adverseEventReported;
  @override
  String? get adverseEventDescription;
  @override
  DateTime? get adverseEventDate; // Next Due
  @override
  DateTime? get nextDoseDate; // Notes
  @override
  String? get notes;
  @override
  DateTime? get createdAt;
  @override
  DateTime? get updatedAt;

  /// Create a copy of ImmunizationRecord
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ImmunizationRecordImplCopyWith<_$ImmunizationRecordImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
