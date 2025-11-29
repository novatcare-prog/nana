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
  @JsonKey(name: 'id')
  String? get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'child_profile_id')
  String get childId => throw _privateConstructorUsedError;
  @JsonKey(name: 'visit_date')
  DateTime get measurementDate => throw _privateConstructorUsedError;
  @JsonKey(name: 'age_in_months')
  int get ageInMonths =>
      throw _privateConstructorUsedError; // Weight Measurement
  @JsonKey(name: 'weight_kg')
  double get weightKg => throw _privateConstructorUsedError;
  @JsonKey(name: 'weight_for_age_z_score')
  double? get weightForAgeZScore => throw _privateConstructorUsedError;
  @JsonKey(name: 'weight_interpretation')
  String? get weightInterpretation =>
      throw _privateConstructorUsedError; // Length/Height Measurement
  @JsonKey(name: 'length_cm')
  double? get lengthCm =>
      throw _privateConstructorUsedError; // For < 2 years (lying)
  @JsonKey(name: 'height_cm')
  double? get heightCm =>
      throw _privateConstructorUsedError; // For >= 2 years (standing)
  @JsonKey(name: 'measured_lying')
  bool? get measuredLying => throw _privateConstructorUsedError;
  @JsonKey(name: 'height_for_age_z_score')
  double? get heightForAgeZScore => throw _privateConstructorUsedError;
  @JsonKey(name: 'height_interpretation')
  String? get heightInterpretation =>
      throw _privateConstructorUsedError; // Additional Z-scores
  @JsonKey(name: 'weight_for_height_z_score')
  double? get weightForHeightZScore => throw _privateConstructorUsedError;
  @JsonKey(name: 'bmi_for_age_z_score')
  double? get bmiForAgeZScore =>
      throw _privateConstructorUsedError; // MUAC (Mid-Upper Arm Circumference)
  @JsonKey(name: 'muac_cm')
  double? get muacCm => throw _privateConstructorUsedError;
  @JsonKey(name: 'muac_interpretation')
  String? get muacInterpretation =>
      throw _privateConstructorUsedError; // Head Circumference
  @JsonKey(name: 'head_circumference_cm')
  double? get headCircumferenceCm =>
      throw _privateConstructorUsedError; // Edema (for malnutrition screening)
  @JsonKey(name: 'edema_present')
  bool get edemaPresent => throw _privateConstructorUsedError;
  @JsonKey(name: 'edema_grade')
  String? get edemaGrade =>
      throw _privateConstructorUsedError; // Nutritional Status
  @JsonKey(name: 'nutritional_status')
  String? get nutritionalStatus => throw _privateConstructorUsedError;
  @JsonKey(name: 'growth_assessment')
  String? get growthAssessment => throw _privateConstructorUsedError;
  @JsonKey(name: 'referred_for_nutrition')
  bool? get referredForNutrition =>
      throw _privateConstructorUsedError; // Counseling Given
  @JsonKey(name: 'feeding_counseling_given')
  bool? get feedingCounselingGiven => throw _privateConstructorUsedError;
  @JsonKey(name: 'feeding_recommendations')
  String? get feedingRecommendations =>
      throw _privateConstructorUsedError; // Clinical Notes
  @JsonKey(name: 'concerns')
  String? get concerns => throw _privateConstructorUsedError;
  @JsonKey(name: 'interventions')
  String? get interventions => throw _privateConstructorUsedError;
  @JsonKey(name: 'next_visit_date')
  DateTime? get nextVisitDate =>
      throw _privateConstructorUsedError; // Health Worker Info
  @JsonKey(name: 'recorded_by')
  String? get recordedBy => throw _privateConstructorUsedError;
  @JsonKey(name: 'health_facility')
  String? get healthFacility =>
      throw _privateConstructorUsedError; // Legacy/Additional fields
  @JsonKey(name: 'notes')
  String? get notes => throw _privateConstructorUsedError;
  @JsonKey(name: 'measured_by')
  String? get measuredBy => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_at')
  DateTime? get createdAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'updated_at')
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
      {@JsonKey(name: 'id') String? id,
      @JsonKey(name: 'child_profile_id') String childId,
      @JsonKey(name: 'visit_date') DateTime measurementDate,
      @JsonKey(name: 'age_in_months') int ageInMonths,
      @JsonKey(name: 'weight_kg') double weightKg,
      @JsonKey(name: 'weight_for_age_z_score') double? weightForAgeZScore,
      @JsonKey(name: 'weight_interpretation') String? weightInterpretation,
      @JsonKey(name: 'length_cm') double? lengthCm,
      @JsonKey(name: 'height_cm') double? heightCm,
      @JsonKey(name: 'measured_lying') bool? measuredLying,
      @JsonKey(name: 'height_for_age_z_score') double? heightForAgeZScore,
      @JsonKey(name: 'height_interpretation') String? heightInterpretation,
      @JsonKey(name: 'weight_for_height_z_score') double? weightForHeightZScore,
      @JsonKey(name: 'bmi_for_age_z_score') double? bmiForAgeZScore,
      @JsonKey(name: 'muac_cm') double? muacCm,
      @JsonKey(name: 'muac_interpretation') String? muacInterpretation,
      @JsonKey(name: 'head_circumference_cm') double? headCircumferenceCm,
      @JsonKey(name: 'edema_present') bool edemaPresent,
      @JsonKey(name: 'edema_grade') String? edemaGrade,
      @JsonKey(name: 'nutritional_status') String? nutritionalStatus,
      @JsonKey(name: 'growth_assessment') String? growthAssessment,
      @JsonKey(name: 'referred_for_nutrition') bool? referredForNutrition,
      @JsonKey(name: 'feeding_counseling_given') bool? feedingCounselingGiven,
      @JsonKey(name: 'feeding_recommendations') String? feedingRecommendations,
      @JsonKey(name: 'concerns') String? concerns,
      @JsonKey(name: 'interventions') String? interventions,
      @JsonKey(name: 'next_visit_date') DateTime? nextVisitDate,
      @JsonKey(name: 'recorded_by') String? recordedBy,
      @JsonKey(name: 'health_facility') String? healthFacility,
      @JsonKey(name: 'notes') String? notes,
      @JsonKey(name: 'measured_by') String? measuredBy,
      @JsonKey(name: 'created_at') DateTime? createdAt,
      @JsonKey(name: 'updated_at') DateTime? updatedAt});
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
    Object? id = freezed,
    Object? childId = null,
    Object? measurementDate = null,
    Object? ageInMonths = null,
    Object? weightKg = null,
    Object? weightForAgeZScore = freezed,
    Object? weightInterpretation = freezed,
    Object? lengthCm = freezed,
    Object? heightCm = freezed,
    Object? measuredLying = freezed,
    Object? heightForAgeZScore = freezed,
    Object? heightInterpretation = freezed,
    Object? weightForHeightZScore = freezed,
    Object? bmiForAgeZScore = freezed,
    Object? muacCm = freezed,
    Object? muacInterpretation = freezed,
    Object? headCircumferenceCm = freezed,
    Object? edemaPresent = null,
    Object? edemaGrade = freezed,
    Object? nutritionalStatus = freezed,
    Object? growthAssessment = freezed,
    Object? referredForNutrition = freezed,
    Object? feedingCounselingGiven = freezed,
    Object? feedingRecommendations = freezed,
    Object? concerns = freezed,
    Object? interventions = freezed,
    Object? nextVisitDate = freezed,
    Object? recordedBy = freezed,
    Object? healthFacility = freezed,
    Object? notes = freezed,
    Object? measuredBy = freezed,
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
              as double?,
      weightInterpretation: freezed == weightInterpretation
          ? _value.weightInterpretation
          : weightInterpretation // ignore: cast_nullable_to_non_nullable
              as String?,
      lengthCm: freezed == lengthCm
          ? _value.lengthCm
          : lengthCm // ignore: cast_nullable_to_non_nullable
              as double?,
      heightCm: freezed == heightCm
          ? _value.heightCm
          : heightCm // ignore: cast_nullable_to_non_nullable
              as double?,
      measuredLying: freezed == measuredLying
          ? _value.measuredLying
          : measuredLying // ignore: cast_nullable_to_non_nullable
              as bool?,
      heightForAgeZScore: freezed == heightForAgeZScore
          ? _value.heightForAgeZScore
          : heightForAgeZScore // ignore: cast_nullable_to_non_nullable
              as double?,
      heightInterpretation: freezed == heightInterpretation
          ? _value.heightInterpretation
          : heightInterpretation // ignore: cast_nullable_to_non_nullable
              as String?,
      weightForHeightZScore: freezed == weightForHeightZScore
          ? _value.weightForHeightZScore
          : weightForHeightZScore // ignore: cast_nullable_to_non_nullable
              as double?,
      bmiForAgeZScore: freezed == bmiForAgeZScore
          ? _value.bmiForAgeZScore
          : bmiForAgeZScore // ignore: cast_nullable_to_non_nullable
              as double?,
      muacCm: freezed == muacCm
          ? _value.muacCm
          : muacCm // ignore: cast_nullable_to_non_nullable
              as double?,
      muacInterpretation: freezed == muacInterpretation
          ? _value.muacInterpretation
          : muacInterpretation // ignore: cast_nullable_to_non_nullable
              as String?,
      headCircumferenceCm: freezed == headCircumferenceCm
          ? _value.headCircumferenceCm
          : headCircumferenceCm // ignore: cast_nullable_to_non_nullable
              as double?,
      edemaPresent: null == edemaPresent
          ? _value.edemaPresent
          : edemaPresent // ignore: cast_nullable_to_non_nullable
              as bool,
      edemaGrade: freezed == edemaGrade
          ? _value.edemaGrade
          : edemaGrade // ignore: cast_nullable_to_non_nullable
              as String?,
      nutritionalStatus: freezed == nutritionalStatus
          ? _value.nutritionalStatus
          : nutritionalStatus // ignore: cast_nullable_to_non_nullable
              as String?,
      growthAssessment: freezed == growthAssessment
          ? _value.growthAssessment
          : growthAssessment // ignore: cast_nullable_to_non_nullable
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
      concerns: freezed == concerns
          ? _value.concerns
          : concerns // ignore: cast_nullable_to_non_nullable
              as String?,
      interventions: freezed == interventions
          ? _value.interventions
          : interventions // ignore: cast_nullable_to_non_nullable
              as String?,
      nextVisitDate: freezed == nextVisitDate
          ? _value.nextVisitDate
          : nextVisitDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      recordedBy: freezed == recordedBy
          ? _value.recordedBy
          : recordedBy // ignore: cast_nullable_to_non_nullable
              as String?,
      healthFacility: freezed == healthFacility
          ? _value.healthFacility
          : healthFacility // ignore: cast_nullable_to_non_nullable
              as String?,
      notes: freezed == notes
          ? _value.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String?,
      measuredBy: freezed == measuredBy
          ? _value.measuredBy
          : measuredBy // ignore: cast_nullable_to_non_nullable
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
abstract class _$$GrowthRecordImplCopyWith<$Res>
    implements $GrowthRecordCopyWith<$Res> {
  factory _$$GrowthRecordImplCopyWith(
          _$GrowthRecordImpl value, $Res Function(_$GrowthRecordImpl) then) =
      __$$GrowthRecordImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'id') String? id,
      @JsonKey(name: 'child_profile_id') String childId,
      @JsonKey(name: 'visit_date') DateTime measurementDate,
      @JsonKey(name: 'age_in_months') int ageInMonths,
      @JsonKey(name: 'weight_kg') double weightKg,
      @JsonKey(name: 'weight_for_age_z_score') double? weightForAgeZScore,
      @JsonKey(name: 'weight_interpretation') String? weightInterpretation,
      @JsonKey(name: 'length_cm') double? lengthCm,
      @JsonKey(name: 'height_cm') double? heightCm,
      @JsonKey(name: 'measured_lying') bool? measuredLying,
      @JsonKey(name: 'height_for_age_z_score') double? heightForAgeZScore,
      @JsonKey(name: 'height_interpretation') String? heightInterpretation,
      @JsonKey(name: 'weight_for_height_z_score') double? weightForHeightZScore,
      @JsonKey(name: 'bmi_for_age_z_score') double? bmiForAgeZScore,
      @JsonKey(name: 'muac_cm') double? muacCm,
      @JsonKey(name: 'muac_interpretation') String? muacInterpretation,
      @JsonKey(name: 'head_circumference_cm') double? headCircumferenceCm,
      @JsonKey(name: 'edema_present') bool edemaPresent,
      @JsonKey(name: 'edema_grade') String? edemaGrade,
      @JsonKey(name: 'nutritional_status') String? nutritionalStatus,
      @JsonKey(name: 'growth_assessment') String? growthAssessment,
      @JsonKey(name: 'referred_for_nutrition') bool? referredForNutrition,
      @JsonKey(name: 'feeding_counseling_given') bool? feedingCounselingGiven,
      @JsonKey(name: 'feeding_recommendations') String? feedingRecommendations,
      @JsonKey(name: 'concerns') String? concerns,
      @JsonKey(name: 'interventions') String? interventions,
      @JsonKey(name: 'next_visit_date') DateTime? nextVisitDate,
      @JsonKey(name: 'recorded_by') String? recordedBy,
      @JsonKey(name: 'health_facility') String? healthFacility,
      @JsonKey(name: 'notes') String? notes,
      @JsonKey(name: 'measured_by') String? measuredBy,
      @JsonKey(name: 'created_at') DateTime? createdAt,
      @JsonKey(name: 'updated_at') DateTime? updatedAt});
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
    Object? id = freezed,
    Object? childId = null,
    Object? measurementDate = null,
    Object? ageInMonths = null,
    Object? weightKg = null,
    Object? weightForAgeZScore = freezed,
    Object? weightInterpretation = freezed,
    Object? lengthCm = freezed,
    Object? heightCm = freezed,
    Object? measuredLying = freezed,
    Object? heightForAgeZScore = freezed,
    Object? heightInterpretation = freezed,
    Object? weightForHeightZScore = freezed,
    Object? bmiForAgeZScore = freezed,
    Object? muacCm = freezed,
    Object? muacInterpretation = freezed,
    Object? headCircumferenceCm = freezed,
    Object? edemaPresent = null,
    Object? edemaGrade = freezed,
    Object? nutritionalStatus = freezed,
    Object? growthAssessment = freezed,
    Object? referredForNutrition = freezed,
    Object? feedingCounselingGiven = freezed,
    Object? feedingRecommendations = freezed,
    Object? concerns = freezed,
    Object? interventions = freezed,
    Object? nextVisitDate = freezed,
    Object? recordedBy = freezed,
    Object? healthFacility = freezed,
    Object? notes = freezed,
    Object? measuredBy = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(_$GrowthRecordImpl(
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String?,
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
              as double?,
      weightInterpretation: freezed == weightInterpretation
          ? _value.weightInterpretation
          : weightInterpretation // ignore: cast_nullable_to_non_nullable
              as String?,
      lengthCm: freezed == lengthCm
          ? _value.lengthCm
          : lengthCm // ignore: cast_nullable_to_non_nullable
              as double?,
      heightCm: freezed == heightCm
          ? _value.heightCm
          : heightCm // ignore: cast_nullable_to_non_nullable
              as double?,
      measuredLying: freezed == measuredLying
          ? _value.measuredLying
          : measuredLying // ignore: cast_nullable_to_non_nullable
              as bool?,
      heightForAgeZScore: freezed == heightForAgeZScore
          ? _value.heightForAgeZScore
          : heightForAgeZScore // ignore: cast_nullable_to_non_nullable
              as double?,
      heightInterpretation: freezed == heightInterpretation
          ? _value.heightInterpretation
          : heightInterpretation // ignore: cast_nullable_to_non_nullable
              as String?,
      weightForHeightZScore: freezed == weightForHeightZScore
          ? _value.weightForHeightZScore
          : weightForHeightZScore // ignore: cast_nullable_to_non_nullable
              as double?,
      bmiForAgeZScore: freezed == bmiForAgeZScore
          ? _value.bmiForAgeZScore
          : bmiForAgeZScore // ignore: cast_nullable_to_non_nullable
              as double?,
      muacCm: freezed == muacCm
          ? _value.muacCm
          : muacCm // ignore: cast_nullable_to_non_nullable
              as double?,
      muacInterpretation: freezed == muacInterpretation
          ? _value.muacInterpretation
          : muacInterpretation // ignore: cast_nullable_to_non_nullable
              as String?,
      headCircumferenceCm: freezed == headCircumferenceCm
          ? _value.headCircumferenceCm
          : headCircumferenceCm // ignore: cast_nullable_to_non_nullable
              as double?,
      edemaPresent: null == edemaPresent
          ? _value.edemaPresent
          : edemaPresent // ignore: cast_nullable_to_non_nullable
              as bool,
      edemaGrade: freezed == edemaGrade
          ? _value.edemaGrade
          : edemaGrade // ignore: cast_nullable_to_non_nullable
              as String?,
      nutritionalStatus: freezed == nutritionalStatus
          ? _value.nutritionalStatus
          : nutritionalStatus // ignore: cast_nullable_to_non_nullable
              as String?,
      growthAssessment: freezed == growthAssessment
          ? _value.growthAssessment
          : growthAssessment // ignore: cast_nullable_to_non_nullable
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
      concerns: freezed == concerns
          ? _value.concerns
          : concerns // ignore: cast_nullable_to_non_nullable
              as String?,
      interventions: freezed == interventions
          ? _value.interventions
          : interventions // ignore: cast_nullable_to_non_nullable
              as String?,
      nextVisitDate: freezed == nextVisitDate
          ? _value.nextVisitDate
          : nextVisitDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      recordedBy: freezed == recordedBy
          ? _value.recordedBy
          : recordedBy // ignore: cast_nullable_to_non_nullable
              as String?,
      healthFacility: freezed == healthFacility
          ? _value.healthFacility
          : healthFacility // ignore: cast_nullable_to_non_nullable
              as String?,
      notes: freezed == notes
          ? _value.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String?,
      measuredBy: freezed == measuredBy
          ? _value.measuredBy
          : measuredBy // ignore: cast_nullable_to_non_nullable
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
class _$GrowthRecordImpl implements _GrowthRecord {
  const _$GrowthRecordImpl(
      {@JsonKey(name: 'id') this.id,
      @JsonKey(name: 'child_profile_id') required this.childId,
      @JsonKey(name: 'visit_date') required this.measurementDate,
      @JsonKey(name: 'age_in_months') required this.ageInMonths,
      @JsonKey(name: 'weight_kg') required this.weightKg,
      @JsonKey(name: 'weight_for_age_z_score') this.weightForAgeZScore,
      @JsonKey(name: 'weight_interpretation') this.weightInterpretation,
      @JsonKey(name: 'length_cm') this.lengthCm,
      @JsonKey(name: 'height_cm') this.heightCm,
      @JsonKey(name: 'measured_lying') this.measuredLying,
      @JsonKey(name: 'height_for_age_z_score') this.heightForAgeZScore,
      @JsonKey(name: 'height_interpretation') this.heightInterpretation,
      @JsonKey(name: 'weight_for_height_z_score') this.weightForHeightZScore,
      @JsonKey(name: 'bmi_for_age_z_score') this.bmiForAgeZScore,
      @JsonKey(name: 'muac_cm') this.muacCm,
      @JsonKey(name: 'muac_interpretation') this.muacInterpretation,
      @JsonKey(name: 'head_circumference_cm') this.headCircumferenceCm,
      @JsonKey(name: 'edema_present') this.edemaPresent = false,
      @JsonKey(name: 'edema_grade') this.edemaGrade,
      @JsonKey(name: 'nutritional_status') this.nutritionalStatus,
      @JsonKey(name: 'growth_assessment') this.growthAssessment,
      @JsonKey(name: 'referred_for_nutrition') this.referredForNutrition,
      @JsonKey(name: 'feeding_counseling_given') this.feedingCounselingGiven,
      @JsonKey(name: 'feeding_recommendations') this.feedingRecommendations,
      @JsonKey(name: 'concerns') this.concerns,
      @JsonKey(name: 'interventions') this.interventions,
      @JsonKey(name: 'next_visit_date') this.nextVisitDate,
      @JsonKey(name: 'recorded_by') this.recordedBy,
      @JsonKey(name: 'health_facility') this.healthFacility,
      @JsonKey(name: 'notes') this.notes,
      @JsonKey(name: 'measured_by') this.measuredBy,
      @JsonKey(name: 'created_at') this.createdAt,
      @JsonKey(name: 'updated_at') this.updatedAt});

  factory _$GrowthRecordImpl.fromJson(Map<String, dynamic> json) =>
      _$$GrowthRecordImplFromJson(json);

  @override
  @JsonKey(name: 'id')
  final String? id;
  @override
  @JsonKey(name: 'child_profile_id')
  final String childId;
  @override
  @JsonKey(name: 'visit_date')
  final DateTime measurementDate;
  @override
  @JsonKey(name: 'age_in_months')
  final int ageInMonths;
// Weight Measurement
  @override
  @JsonKey(name: 'weight_kg')
  final double weightKg;
  @override
  @JsonKey(name: 'weight_for_age_z_score')
  final double? weightForAgeZScore;
  @override
  @JsonKey(name: 'weight_interpretation')
  final String? weightInterpretation;
// Length/Height Measurement
  @override
  @JsonKey(name: 'length_cm')
  final double? lengthCm;
// For < 2 years (lying)
  @override
  @JsonKey(name: 'height_cm')
  final double? heightCm;
// For >= 2 years (standing)
  @override
  @JsonKey(name: 'measured_lying')
  final bool? measuredLying;
  @override
  @JsonKey(name: 'height_for_age_z_score')
  final double? heightForAgeZScore;
  @override
  @JsonKey(name: 'height_interpretation')
  final String? heightInterpretation;
// Additional Z-scores
  @override
  @JsonKey(name: 'weight_for_height_z_score')
  final double? weightForHeightZScore;
  @override
  @JsonKey(name: 'bmi_for_age_z_score')
  final double? bmiForAgeZScore;
// MUAC (Mid-Upper Arm Circumference)
  @override
  @JsonKey(name: 'muac_cm')
  final double? muacCm;
  @override
  @JsonKey(name: 'muac_interpretation')
  final String? muacInterpretation;
// Head Circumference
  @override
  @JsonKey(name: 'head_circumference_cm')
  final double? headCircumferenceCm;
// Edema (for malnutrition screening)
  @override
  @JsonKey(name: 'edema_present')
  final bool edemaPresent;
  @override
  @JsonKey(name: 'edema_grade')
  final String? edemaGrade;
// Nutritional Status
  @override
  @JsonKey(name: 'nutritional_status')
  final String? nutritionalStatus;
  @override
  @JsonKey(name: 'growth_assessment')
  final String? growthAssessment;
  @override
  @JsonKey(name: 'referred_for_nutrition')
  final bool? referredForNutrition;
// Counseling Given
  @override
  @JsonKey(name: 'feeding_counseling_given')
  final bool? feedingCounselingGiven;
  @override
  @JsonKey(name: 'feeding_recommendations')
  final String? feedingRecommendations;
// Clinical Notes
  @override
  @JsonKey(name: 'concerns')
  final String? concerns;
  @override
  @JsonKey(name: 'interventions')
  final String? interventions;
  @override
  @JsonKey(name: 'next_visit_date')
  final DateTime? nextVisitDate;
// Health Worker Info
  @override
  @JsonKey(name: 'recorded_by')
  final String? recordedBy;
  @override
  @JsonKey(name: 'health_facility')
  final String? healthFacility;
// Legacy/Additional fields
  @override
  @JsonKey(name: 'notes')
  final String? notes;
  @override
  @JsonKey(name: 'measured_by')
  final String? measuredBy;
  @override
  @JsonKey(name: 'created_at')
  final DateTime? createdAt;
  @override
  @JsonKey(name: 'updated_at')
  final DateTime? updatedAt;

  @override
  String toString() {
    return 'GrowthRecord(id: $id, childId: $childId, measurementDate: $measurementDate, ageInMonths: $ageInMonths, weightKg: $weightKg, weightForAgeZScore: $weightForAgeZScore, weightInterpretation: $weightInterpretation, lengthCm: $lengthCm, heightCm: $heightCm, measuredLying: $measuredLying, heightForAgeZScore: $heightForAgeZScore, heightInterpretation: $heightInterpretation, weightForHeightZScore: $weightForHeightZScore, bmiForAgeZScore: $bmiForAgeZScore, muacCm: $muacCm, muacInterpretation: $muacInterpretation, headCircumferenceCm: $headCircumferenceCm, edemaPresent: $edemaPresent, edemaGrade: $edemaGrade, nutritionalStatus: $nutritionalStatus, growthAssessment: $growthAssessment, referredForNutrition: $referredForNutrition, feedingCounselingGiven: $feedingCounselingGiven, feedingRecommendations: $feedingRecommendations, concerns: $concerns, interventions: $interventions, nextVisitDate: $nextVisitDate, recordedBy: $recordedBy, healthFacility: $healthFacility, notes: $notes, measuredBy: $measuredBy, createdAt: $createdAt, updatedAt: $updatedAt)';
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
            (identical(other.lengthCm, lengthCm) ||
                other.lengthCm == lengthCm) &&
            (identical(other.heightCm, heightCm) ||
                other.heightCm == heightCm) &&
            (identical(other.measuredLying, measuredLying) ||
                other.measuredLying == measuredLying) &&
            (identical(other.heightForAgeZScore, heightForAgeZScore) ||
                other.heightForAgeZScore == heightForAgeZScore) &&
            (identical(other.heightInterpretation, heightInterpretation) ||
                other.heightInterpretation == heightInterpretation) &&
            (identical(other.weightForHeightZScore, weightForHeightZScore) ||
                other.weightForHeightZScore == weightForHeightZScore) &&
            (identical(other.bmiForAgeZScore, bmiForAgeZScore) ||
                other.bmiForAgeZScore == bmiForAgeZScore) &&
            (identical(other.muacCm, muacCm) || other.muacCm == muacCm) &&
            (identical(other.muacInterpretation, muacInterpretation) ||
                other.muacInterpretation == muacInterpretation) &&
            (identical(other.headCircumferenceCm, headCircumferenceCm) ||
                other.headCircumferenceCm == headCircumferenceCm) &&
            (identical(other.edemaPresent, edemaPresent) ||
                other.edemaPresent == edemaPresent) &&
            (identical(other.edemaGrade, edemaGrade) ||
                other.edemaGrade == edemaGrade) &&
            (identical(other.nutritionalStatus, nutritionalStatus) ||
                other.nutritionalStatus == nutritionalStatus) &&
            (identical(other.growthAssessment, growthAssessment) ||
                other.growthAssessment == growthAssessment) &&
            (identical(other.referredForNutrition, referredForNutrition) ||
                other.referredForNutrition == referredForNutrition) &&
            (identical(other.feedingCounselingGiven, feedingCounselingGiven) ||
                other.feedingCounselingGiven == feedingCounselingGiven) &&
            (identical(other.feedingRecommendations, feedingRecommendations) ||
                other.feedingRecommendations == feedingRecommendations) &&
            (identical(other.concerns, concerns) ||
                other.concerns == concerns) &&
            (identical(other.interventions, interventions) ||
                other.interventions == interventions) &&
            (identical(other.nextVisitDate, nextVisitDate) ||
                other.nextVisitDate == nextVisitDate) &&
            (identical(other.recordedBy, recordedBy) ||
                other.recordedBy == recordedBy) &&
            (identical(other.healthFacility, healthFacility) ||
                other.healthFacility == healthFacility) &&
            (identical(other.notes, notes) || other.notes == notes) &&
            (identical(other.measuredBy, measuredBy) ||
                other.measuredBy == measuredBy) &&
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
        lengthCm,
        heightCm,
        measuredLying,
        heightForAgeZScore,
        heightInterpretation,
        weightForHeightZScore,
        bmiForAgeZScore,
        muacCm,
        muacInterpretation,
        headCircumferenceCm,
        edemaPresent,
        edemaGrade,
        nutritionalStatus,
        growthAssessment,
        referredForNutrition,
        feedingCounselingGiven,
        feedingRecommendations,
        concerns,
        interventions,
        nextVisitDate,
        recordedBy,
        healthFacility,
        notes,
        measuredBy,
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
      {@JsonKey(name: 'id') final String? id,
      @JsonKey(name: 'child_profile_id') required final String childId,
      @JsonKey(name: 'visit_date') required final DateTime measurementDate,
      @JsonKey(name: 'age_in_months') required final int ageInMonths,
      @JsonKey(name: 'weight_kg') required final double weightKg,
      @JsonKey(name: 'weight_for_age_z_score') final double? weightForAgeZScore,
      @JsonKey(name: 'weight_interpretation')
      final String? weightInterpretation,
      @JsonKey(name: 'length_cm') final double? lengthCm,
      @JsonKey(name: 'height_cm') final double? heightCm,
      @JsonKey(name: 'measured_lying') final bool? measuredLying,
      @JsonKey(name: 'height_for_age_z_score') final double? heightForAgeZScore,
      @JsonKey(name: 'height_interpretation')
      final String? heightInterpretation,
      @JsonKey(name: 'weight_for_height_z_score')
      final double? weightForHeightZScore,
      @JsonKey(name: 'bmi_for_age_z_score') final double? bmiForAgeZScore,
      @JsonKey(name: 'muac_cm') final double? muacCm,
      @JsonKey(name: 'muac_interpretation') final String? muacInterpretation,
      @JsonKey(name: 'head_circumference_cm') final double? headCircumferenceCm,
      @JsonKey(name: 'edema_present') final bool edemaPresent,
      @JsonKey(name: 'edema_grade') final String? edemaGrade,
      @JsonKey(name: 'nutritional_status') final String? nutritionalStatus,
      @JsonKey(name: 'growth_assessment') final String? growthAssessment,
      @JsonKey(name: 'referred_for_nutrition') final bool? referredForNutrition,
      @JsonKey(name: 'feeding_counseling_given')
      final bool? feedingCounselingGiven,
      @JsonKey(name: 'feeding_recommendations')
      final String? feedingRecommendations,
      @JsonKey(name: 'concerns') final String? concerns,
      @JsonKey(name: 'interventions') final String? interventions,
      @JsonKey(name: 'next_visit_date') final DateTime? nextVisitDate,
      @JsonKey(name: 'recorded_by') final String? recordedBy,
      @JsonKey(name: 'health_facility') final String? healthFacility,
      @JsonKey(name: 'notes') final String? notes,
      @JsonKey(name: 'measured_by') final String? measuredBy,
      @JsonKey(name: 'created_at') final DateTime? createdAt,
      @JsonKey(name: 'updated_at')
      final DateTime? updatedAt}) = _$GrowthRecordImpl;

  factory _GrowthRecord.fromJson(Map<String, dynamic> json) =
      _$GrowthRecordImpl.fromJson;

  @override
  @JsonKey(name: 'id')
  String? get id;
  @override
  @JsonKey(name: 'child_profile_id')
  String get childId;
  @override
  @JsonKey(name: 'visit_date')
  DateTime get measurementDate;
  @override
  @JsonKey(name: 'age_in_months')
  int get ageInMonths; // Weight Measurement
  @override
  @JsonKey(name: 'weight_kg')
  double get weightKg;
  @override
  @JsonKey(name: 'weight_for_age_z_score')
  double? get weightForAgeZScore;
  @override
  @JsonKey(name: 'weight_interpretation')
  String? get weightInterpretation; // Length/Height Measurement
  @override
  @JsonKey(name: 'length_cm')
  double? get lengthCm; // For < 2 years (lying)
  @override
  @JsonKey(name: 'height_cm')
  double? get heightCm; // For >= 2 years (standing)
  @override
  @JsonKey(name: 'measured_lying')
  bool? get measuredLying;
  @override
  @JsonKey(name: 'height_for_age_z_score')
  double? get heightForAgeZScore;
  @override
  @JsonKey(name: 'height_interpretation')
  String? get heightInterpretation; // Additional Z-scores
  @override
  @JsonKey(name: 'weight_for_height_z_score')
  double? get weightForHeightZScore;
  @override
  @JsonKey(name: 'bmi_for_age_z_score')
  double? get bmiForAgeZScore; // MUAC (Mid-Upper Arm Circumference)
  @override
  @JsonKey(name: 'muac_cm')
  double? get muacCm;
  @override
  @JsonKey(name: 'muac_interpretation')
  String? get muacInterpretation; // Head Circumference
  @override
  @JsonKey(name: 'head_circumference_cm')
  double? get headCircumferenceCm; // Edema (for malnutrition screening)
  @override
  @JsonKey(name: 'edema_present')
  bool get edemaPresent;
  @override
  @JsonKey(name: 'edema_grade')
  String? get edemaGrade; // Nutritional Status
  @override
  @JsonKey(name: 'nutritional_status')
  String? get nutritionalStatus;
  @override
  @JsonKey(name: 'growth_assessment')
  String? get growthAssessment;
  @override
  @JsonKey(name: 'referred_for_nutrition')
  bool? get referredForNutrition; // Counseling Given
  @override
  @JsonKey(name: 'feeding_counseling_given')
  bool? get feedingCounselingGiven;
  @override
  @JsonKey(name: 'feeding_recommendations')
  String? get feedingRecommendations; // Clinical Notes
  @override
  @JsonKey(name: 'concerns')
  String? get concerns;
  @override
  @JsonKey(name: 'interventions')
  String? get interventions;
  @override
  @JsonKey(name: 'next_visit_date')
  DateTime? get nextVisitDate; // Health Worker Info
  @override
  @JsonKey(name: 'recorded_by')
  String? get recordedBy;
  @override
  @JsonKey(name: 'health_facility')
  String? get healthFacility; // Legacy/Additional fields
  @override
  @JsonKey(name: 'notes')
  String? get notes;
  @override
  @JsonKey(name: 'measured_by')
  String? get measuredBy;
  @override
  @JsonKey(name: 'created_at')
  DateTime? get createdAt;
  @override
  @JsonKey(name: 'updated_at')
  DateTime? get updatedAt;

  /// Create a copy of GrowthRecord
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$GrowthRecordImplCopyWith<_$GrowthRecordImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
