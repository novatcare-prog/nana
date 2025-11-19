// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'growth_record.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

GrowthRecord _$GrowthRecordFromJson(Map<String, dynamic> json) {
  return _GrowthRecord.fromJson(json);
}

/// @nodoc
mixin _$GrowthRecord {
  String get id => throw _privateConstructorUsedError;
  String get childId => throw _privateConstructorUsedError;
  DateTime get measurementDate => throw _privateConstructorUsedError;
  int get ageInMonths =>
      throw _privateConstructorUsedError; // Weight Measurement
  double get weightKg => throw _privateConstructorUsedError;
  String? get weightForAgeZScore =>
      throw _privateConstructorUsedError; // +3, +2, +1, -1, -2, -3
  String? get weightInterpretation =>
      throw _privateConstructorUsedError; // Good, Danger, Very Dangerous
// Length/Height Measurement
  double get lengthHeightCm => throw _privateConstructorUsedError;
  bool? get measuredLying =>
      throw _privateConstructorUsedError; // True = length (lying), False = height (standing)
  String? get heightForAgeZScore =>
      throw _privateConstructorUsedError; // +3, +2, +1, -1, -2, -3
  String? get heightInterpretation =>
      throw _privateConstructorUsedError; // Good, Dangerous
// MUAC (Mid-Upper Arm Circumference) - for children 6-59 months
  double? get muacCm => throw _privateConstructorUsedError;
  String? get muacInterpretation =>
      throw _privateConstructorUsedError; // Edema (for malnutrition screening)
  bool? get edemaPresent => throw _privateConstructorUsedError;
  String? get edemaGrade => throw _privateConstructorUsedError; // +, ++, +++
// Nutritional Status
  String? get nutritionalStatus =>
      throw _privateConstructorUsedError; // Well-nourished, Moderate malnutrition, Severe malnutrition
  bool? get referredForNutrition =>
      throw _privateConstructorUsedError; // Counseling Given
  bool? get feedingCounselingGiven => throw _privateConstructorUsedError;
  String? get feedingRecommendations =>
      throw _privateConstructorUsedError; // Clinical Notes
  String? get notes => throw _privateConstructorUsedError;
  String? get measuredBy => throw _privateConstructorUsedError; // Next Visit
  DateTime? get nextVisitDate => throw _privateConstructorUsedError;
  DateTime? get createdAt => throw _privateConstructorUsedError;
  DateTime? get updatedAt => throw _privateConstructorUsedError;

  /// Serializes this GrowthRecord to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of GrowthRecord
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $GrowthRecordCopyWith<GrowthRecord> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $GrowthRecordCopyWith<$Res> {
  factory $GrowthRecordCopyWith(
          GrowthRecord value, $Res Function(GrowthRecord) then) =
      _$GrowthRecordCopyWithImpl<$Res, GrowthRecord>;
  @useResult
  $Res call(
      {String id,
      String childId,
      DateTime measurementDate,
      int ageInMonths,
      double weightKg,
      String? weightForAgeZScore,
      String? weightInterpretation,
      double lengthHeightCm,
      bool? measuredLying,
      String? heightForAgeZScore,
      String? heightInterpretation,
      double? muacCm,
      String? muacInterpretation,
      bool? edemaPresent,
      String? edemaGrade,
      String? nutritionalStatus,
      bool? referredForNutrition,
      bool? feedingCounselingGiven,
      String? feedingRecommendations,
      String? notes,
      String? measuredBy,
      DateTime? nextVisitDate,
      DateTime? createdAt,
      DateTime? updatedAt});
}

/// @nodoc
class _$GrowthRecordCopyWithImpl<$Res, $Val extends GrowthRecord>
    implements $GrowthRecordCopyWith<$Res> {
  _$GrowthRecordCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of GrowthRecord
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? childId = null,
    Object? measurementDate = null,
    Object? ageInMonths = null,
    Object? weightKg = null,
    Object? weightForAgeZScore = freezed,
    Object? weightInterpretation = freezed,
    Object? lengthHeightCm = null,
    Object? measuredLying = freezed,
    Object? heightForAgeZScore = freezed,
    Object? heightInterpretation = freezed,
    Object? muacCm = freezed,
    Object? muacInterpretation = freezed,
    Object? edemaPresent = freezed,
    Object? edemaGrade = freezed,
    Object? nutritionalStatus = freezed,
    Object? referredForNutrition = freezed,
    Object? feedingCounselingGiven = freezed,
    Object? feedingRecommendations = freezed,
    Object? notes = freezed,
    Object? measuredBy = freezed,
    Object? nextVisitDate = freezed,
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
      measurementDate: null == measurementDate
          ? _value.measurementDate
          : measurementDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      ageInMonths: null == ageInMonths
          ? _value.ageInMonths
          : ageInMonths // ignore: cast_nullable_to_non_nullable
              as int,
      weightKg: null == weightKg
          ? _value.weightKg
          : weightKg // ignore: cast_nullable_to_non_nullable
              as double,
      weightForAgeZScore: freezed == weightForAgeZScore
          ? _value.weightForAgeZScore
          : weightForAgeZScore // ignore: cast_nullable_to_non_nullable
              as String?,
      weightInterpretation: freezed == weightInterpretation
          ? _value.weightInterpretation
          : weightInterpretation // ignore: cast_nullable_to_non_nullable
              as String?,
      lengthHeightCm: null == lengthHeightCm
          ? _value.lengthHeightCm
          : lengthHeightCm // ignore: cast_nullable_to_non_nullable
              as double,
      measuredLying: freezed == measuredLying
          ? _value.measuredLying
          : measuredLying // ignore: cast_nullable_to_non_nullable
              as bool?,
      heightForAgeZScore: freezed == heightForAgeZScore
          ? _value.heightForAgeZScore
          : heightForAgeZScore // ignore: cast_nullable_to_non_nullable
              as String?,
      heightInterpretation: freezed == heightInterpretation
          ? _value.heightInterpretation
          : heightInterpretation // ignore: cast_nullable_to_non_nullable
              as String?,
      muacCm: freezed == muacCm
          ? _value.muacCm
          : muacCm // ignore: cast_nullable_to_non_nullable
              as double?,
      muacInterpretation: freezed == muacInterpretation
          ? _value.muacInterpretation
          : muacInterpretation // ignore: cast_nullable_to_non_nullable
              as String?,
      edemaPresent: freezed == edemaPresent
          ? _value.edemaPresent
          : edemaPresent // ignore: cast_nullable_to_non_nullable
              as bool?,
      edemaGrade: freezed == edemaGrade
          ? _value.edemaGrade
          : edemaGrade // ignore: cast_nullable_to_non_nullable
              as String?,
      nutritionalStatus: freezed == nutritionalStatus
          ? _value.nutritionalStatus
          : nutritionalStatus // ignore: cast_nullable_to_non_nullable
              as String?,
      referredForNutrition: freezed == referredForNutrition
          ? _value.referredForNutrition
          : referredForNutrition // ignore: cast_nullable_to_non_nullable
              as bool?,
      feedingCounselingGiven: freezed == feedingCounselingGiven
          ? _value.feedingCounselingGiven
          : feedingCounselingGiven // ignore: cast_nullable_to_non_nullable
              as bool?,
      feedingRecommendations: freezed == feedingRecommendations
          ? _value.feedingRecommendations
          : feedingRecommendations // ignore: cast_nullable_to_non_nullable
              as String?,
      notes: freezed == notes
          ? _value.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String?,
      measuredBy: freezed == measuredBy
          ? _value.measuredBy
          : measuredBy // ignore: cast_nullable_to_non_nullable
              as String?,
      nextVisitDate: freezed == nextVisitDate
          ? _value.nextVisitDate
          : nextVisitDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
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
abstract class _$$GrowthRecordImplCopyWith<$Res>
    implements $GrowthRecordCopyWith<$Res> {
  factory _$$GrowthRecordImplCopyWith(
          _$GrowthRecordImpl value, $Res Function(_$GrowthRecordImpl) then) =
      __$$GrowthRecordImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String childId,
      DateTime measurementDate,
      int ageInMonths,
      double weightKg,
      String? weightForAgeZScore,
      String? weightInterpretation,
      double lengthHeightCm,
      bool? measuredLying,
      String? heightForAgeZScore,
      String? heightInterpretation,
      double? muacCm,
      String? muacInterpretation,
      bool? edemaPresent,
      String? edemaGrade,
      String? nutritionalStatus,
      bool? referredForNutrition,
      bool? feedingCounselingGiven,
      String? feedingRecommendations,
      String? notes,
      String? measuredBy,
      DateTime? nextVisitDate,
      DateTime? createdAt,
      DateTime? updatedAt});
}

/// @nodoc
class __$$GrowthRecordImplCopyWithImpl<$Res>
    extends _$GrowthRecordCopyWithImpl<$Res, _$GrowthRecordImpl>
    implements _$$GrowthRecordImplCopyWith<$Res> {
  __$$GrowthRecordImplCopyWithImpl(
      _$GrowthRecordImpl _value, $Res Function(_$GrowthRecordImpl) _then)
      : super(_value, _then);

  /// Create a copy of GrowthRecord
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? childId = null,
    Object? measurementDate = null,
    Object? ageInMonths = null,
    Object? weightKg = null,
    Object? weightForAgeZScore = freezed,
    Object? weightInterpretation = freezed,
    Object? lengthHeightCm = null,
    Object? measuredLying = freezed,
    Object? heightForAgeZScore = freezed,
    Object? heightInterpretation = freezed,
    Object? muacCm = freezed,
    Object? muacInterpretation = freezed,
    Object? edemaPresent = freezed,
    Object? edemaGrade = freezed,
    Object? nutritionalStatus = freezed,
    Object? referredForNutrition = freezed,
    Object? feedingCounselingGiven = freezed,
    Object? feedingRecommendations = freezed,
    Object? notes = freezed,
    Object? measuredBy = freezed,
    Object? nextVisitDate = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(_$GrowthRecordImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      childId: null == childId
          ? _value.childId
          : childId // ignore: cast_nullable_to_non_nullable
              as String,
      measurementDate: null == measurementDate
          ? _value.measurementDate
          : measurementDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      ageInMonths: null == ageInMonths
          ? _value.ageInMonths
          : ageInMonths // ignore: cast_nullable_to_non_nullable
              as int,
      weightKg: null == weightKg
          ? _value.weightKg
          : weightKg // ignore: cast_nullable_to_non_nullable
              as double,
      weightForAgeZScore: freezed == weightForAgeZScore
          ? _value.weightForAgeZScore
          : weightForAgeZScore // ignore: cast_nullable_to_non_nullable
              as String?,
      weightInterpretation: freezed == weightInterpretation
          ? _value.weightInterpretation
          : weightInterpretation // ignore: cast_nullable_to_non_nullable
              as String?,
      lengthHeightCm: null == lengthHeightCm
          ? _value.lengthHeightCm
          : lengthHeightCm // ignore: cast_nullable_to_non_nullable
              as double,
      measuredLying: freezed == measuredLying
          ? _value.measuredLying
          : measuredLying // ignore: cast_nullable_to_non_nullable
              as bool?,
      heightForAgeZScore: freezed == heightForAgeZScore
          ? _value.heightForAgeZScore
          : heightForAgeZScore // ignore: cast_nullable_to_non_nullable
              as String?,
      heightInterpretation: freezed == heightInterpretation
          ? _value.heightInterpretation
          : heightInterpretation // ignore: cast_nullable_to_non_nullable
              as String?,
      muacCm: freezed == muacCm
          ? _value.muacCm
          : muacCm // ignore: cast_nullable_to_non_nullable
              as double?,
      muacInterpretation: freezed == muacInterpretation
          ? _value.muacInterpretation
          : muacInterpretation // ignore: cast_nullable_to_non_nullable
              as String?,
      edemaPresent: freezed == edemaPresent
          ? _value.edemaPresent
          : edemaPresent // ignore: cast_nullable_to_non_nullable
              as bool?,
      edemaGrade: freezed == edemaGrade
          ? _value.edemaGrade
          : edemaGrade // ignore: cast_nullable_to_non_nullable
              as String?,
      nutritionalStatus: freezed == nutritionalStatus
          ? _value.nutritionalStatus
          : nutritionalStatus // ignore: cast_nullable_to_non_nullable
              as String?,
      referredForNutrition: freezed == referredForNutrition
          ? _value.referredForNutrition
          : referredForNutrition // ignore: cast_nullable_to_non_nullable
              as bool?,
      feedingCounselingGiven: freezed == feedingCounselingGiven
          ? _value.feedingCounselingGiven
          : feedingCounselingGiven // ignore: cast_nullable_to_non_nullable
              as bool?,
      feedingRecommendations: freezed == feedingRecommendations
          ? _value.feedingRecommendations
          : feedingRecommendations // ignore: cast_nullable_to_non_nullable
              as String?,
      notes: freezed == notes
          ? _value.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String?,
      measuredBy: freezed == measuredBy
          ? _value.measuredBy
          : measuredBy // ignore: cast_nullable_to_non_nullable
              as String?,
      nextVisitDate: freezed == nextVisitDate
          ? _value.nextVisitDate
          : nextVisitDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
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
class _$GrowthRecordImpl implements _GrowthRecord {
  const _$GrowthRecordImpl(
      {required this.id,
      required this.childId,
      required this.measurementDate,
      required this.ageInMonths,
      required this.weightKg,
      this.weightForAgeZScore,
      this.weightInterpretation,
      required this.lengthHeightCm,
      this.measuredLying,
      this.heightForAgeZScore,
      this.heightInterpretation,
      this.muacCm,
      this.muacInterpretation,
      this.edemaPresent,
      this.edemaGrade,
      this.nutritionalStatus,
      this.referredForNutrition,
      this.feedingCounselingGiven,
      this.feedingRecommendations,
      this.notes,
      this.measuredBy,
      this.nextVisitDate,
      this.createdAt,
      this.updatedAt});

  factory _$GrowthRecordImpl.fromJson(Map<String, dynamic> json) =>
      _$$GrowthRecordImplFromJson(json);

  @override
  final String id;
  @override
  final String childId;
  @override
  final DateTime measurementDate;
  @override
  final int ageInMonths;
// Weight Measurement
  @override
  final double weightKg;
  @override
  final String? weightForAgeZScore;
// +3, +2, +1, -1, -2, -3
  @override
  final String? weightInterpretation;
// Good, Danger, Very Dangerous
// Length/Height Measurement
  @override
  final double lengthHeightCm;
  @override
  final bool? measuredLying;
// True = length (lying), False = height (standing)
  @override
  final String? heightForAgeZScore;
// +3, +2, +1, -1, -2, -3
  @override
  final String? heightInterpretation;
// Good, Dangerous
// MUAC (Mid-Upper Arm Circumference) - for children 6-59 months
  @override
  final double? muacCm;
  @override
  final String? muacInterpretation;
// Edema (for malnutrition screening)
  @override
  final bool? edemaPresent;
  @override
  final String? edemaGrade;
// +, ++, +++
// Nutritional Status
  @override
  final String? nutritionalStatus;
// Well-nourished, Moderate malnutrition, Severe malnutrition
  @override
  final bool? referredForNutrition;
// Counseling Given
  @override
  final bool? feedingCounselingGiven;
  @override
  final String? feedingRecommendations;
// Clinical Notes
  @override
  final String? notes;
  @override
  final String? measuredBy;
// Next Visit
  @override
  final DateTime? nextVisitDate;
  @override
  final DateTime? createdAt;
  @override
  final DateTime? updatedAt;

  @override
  String toString() {
    return 'GrowthRecord(id: $id, childId: $childId, measurementDate: $measurementDate, ageInMonths: $ageInMonths, weightKg: $weightKg, weightForAgeZScore: $weightForAgeZScore, weightInterpretation: $weightInterpretation, lengthHeightCm: $lengthHeightCm, measuredLying: $measuredLying, heightForAgeZScore: $heightForAgeZScore, heightInterpretation: $heightInterpretation, muacCm: $muacCm, muacInterpretation: $muacInterpretation, edemaPresent: $edemaPresent, edemaGrade: $edemaGrade, nutritionalStatus: $nutritionalStatus, referredForNutrition: $referredForNutrition, feedingCounselingGiven: $feedingCounselingGiven, feedingRecommendations: $feedingRecommendations, notes: $notes, measuredBy: $measuredBy, nextVisitDate: $nextVisitDate, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$GrowthRecordImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.childId, childId) || other.childId == childId) &&
            (identical(other.measurementDate, measurementDate) ||
                other.measurementDate == measurementDate) &&
            (identical(other.ageInMonths, ageInMonths) ||
                other.ageInMonths == ageInMonths) &&
            (identical(other.weightKg, weightKg) ||
                other.weightKg == weightKg) &&
            (identical(other.weightForAgeZScore, weightForAgeZScore) ||
                other.weightForAgeZScore == weightForAgeZScore) &&
            (identical(other.weightInterpretation, weightInterpretation) ||
                other.weightInterpretation == weightInterpretation) &&
            (identical(other.lengthHeightCm, lengthHeightCm) ||
                other.lengthHeightCm == lengthHeightCm) &&
            (identical(other.measuredLying, measuredLying) ||
                other.measuredLying == measuredLying) &&
            (identical(other.heightForAgeZScore, heightForAgeZScore) ||
                other.heightForAgeZScore == heightForAgeZScore) &&
            (identical(other.heightInterpretation, heightInterpretation) ||
                other.heightInterpretation == heightInterpretation) &&
            (identical(other.muacCm, muacCm) || other.muacCm == muacCm) &&
            (identical(other.muacInterpretation, muacInterpretation) ||
                other.muacInterpretation == muacInterpretation) &&
            (identical(other.edemaPresent, edemaPresent) ||
                other.edemaPresent == edemaPresent) &&
            (identical(other.edemaGrade, edemaGrade) ||
                other.edemaGrade == edemaGrade) &&
            (identical(other.nutritionalStatus, nutritionalStatus) ||
                other.nutritionalStatus == nutritionalStatus) &&
            (identical(other.referredForNutrition, referredForNutrition) ||
                other.referredForNutrition == referredForNutrition) &&
            (identical(other.feedingCounselingGiven, feedingCounselingGiven) ||
                other.feedingCounselingGiven == feedingCounselingGiven) &&
            (identical(other.feedingRecommendations, feedingRecommendations) ||
                other.feedingRecommendations == feedingRecommendations) &&
            (identical(other.notes, notes) || other.notes == notes) &&
            (identical(other.measuredBy, measuredBy) ||
                other.measuredBy == measuredBy) &&
            (identical(other.nextVisitDate, nextVisitDate) ||
                other.nextVisitDate == nextVisitDate) &&
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
        measurementDate,
        ageInMonths,
        weightKg,
        weightForAgeZScore,
        weightInterpretation,
        lengthHeightCm,
        measuredLying,
        heightForAgeZScore,
        heightInterpretation,
        muacCm,
        muacInterpretation,
        edemaPresent,
        edemaGrade,
        nutritionalStatus,
        referredForNutrition,
        feedingCounselingGiven,
        feedingRecommendations,
        notes,
        measuredBy,
        nextVisitDate,
        createdAt,
        updatedAt
      ]);

  /// Create a copy of GrowthRecord
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$GrowthRecordImplCopyWith<_$GrowthRecordImpl> get copyWith =>
      __$$GrowthRecordImplCopyWithImpl<_$GrowthRecordImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$GrowthRecordImplToJson(
      this,
    );
  }
}

abstract class _GrowthRecord implements GrowthRecord {
  const factory _GrowthRecord(
      {required final String id,
      required final String childId,
      required final DateTime measurementDate,
      required final int ageInMonths,
      required final double weightKg,
      final String? weightForAgeZScore,
      final String? weightInterpretation,
      required final double lengthHeightCm,
      final bool? measuredLying,
      final String? heightForAgeZScore,
      final String? heightInterpretation,
      final double? muacCm,
      final String? muacInterpretation,
      final bool? edemaPresent,
      final String? edemaGrade,
      final String? nutritionalStatus,
      final bool? referredForNutrition,
      final bool? feedingCounselingGiven,
      final String? feedingRecommendations,
      final String? notes,
      final String? measuredBy,
      final DateTime? nextVisitDate,
      final DateTime? createdAt,
      final DateTime? updatedAt}) = _$GrowthRecordImpl;

  factory _GrowthRecord.fromJson(Map<String, dynamic> json) =
      _$GrowthRecordImpl.fromJson;

  @override
  String get id;
  @override
  String get childId;
  @override
  DateTime get measurementDate;
  @override
  int get ageInMonths; // Weight Measurement
  @override
  double get weightKg;
  @override
  String? get weightForAgeZScore; // +3, +2, +1, -1, -2, -3
  @override
  String? get weightInterpretation; // Good, Danger, Very Dangerous
// Length/Height Measurement
  @override
  double get lengthHeightCm;
  @override
  bool? get measuredLying; // True = length (lying), False = height (standing)
  @override
  String? get heightForAgeZScore; // +3, +2, +1, -1, -2, -3
  @override
  String? get heightInterpretation; // Good, Dangerous
// MUAC (Mid-Upper Arm Circumference) - for children 6-59 months
  @override
  double? get muacCm;
  @override
  String? get muacInterpretation; // Edema (for malnutrition screening)
  @override
  bool? get edemaPresent;
  @override
  String? get edemaGrade; // +, ++, +++
// Nutritional Status
  @override
  String?
      get nutritionalStatus; // Well-nourished, Moderate malnutrition, Severe malnutrition
  @override
  bool? get referredForNutrition; // Counseling Given
  @override
  bool? get feedingCounselingGiven;
  @override
  String? get feedingRecommendations; // Clinical Notes
  @override
  String? get notes;
  @override
  String? get measuredBy; // Next Visit
  @override
  DateTime? get nextVisitDate;
  @override
  DateTime? get createdAt;
  @override
  DateTime? get updatedAt;

  /// Create a copy of GrowthRecord
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$GrowthRecordImplCopyWith<_$GrowthRecordImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
