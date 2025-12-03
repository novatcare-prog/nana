// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'postnatal_visit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

PostnatalVisit _$PostnatalVisitFromJson(Map<String, dynamic> json) {
  return _PostnatalVisit.fromJson(json);
}

/// @nodoc
mixin _$PostnatalVisit {
  @JsonKey(name: 'id')
  String? get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'maternal_profile_id')
  String get maternalProfileId => throw _privateConstructorUsedError;
  @JsonKey(name: 'child_profile_id')
  String? get childProfileId =>
      throw _privateConstructorUsedError; // Visit Details
  @JsonKey(name: 'visit_date')
  DateTime get visitDate => throw _privateConstructorUsedError;
  @JsonKey(name: 'visit_type')
  String get visitType =>
      throw _privateConstructorUsedError; // '48 hours', '6 days', '6 weeks', '6 months', 'Other'
  @JsonKey(name: 'days_postpartum')
  int get daysPostpartum => throw _privateConstructorUsedError;
  @JsonKey(name: 'health_facility')
  String? get healthFacility => throw _privateConstructorUsedError;
  @JsonKey(name: 'attended_by')
  String? get attendedBy =>
      throw _privateConstructorUsedError; // Mother's Health Assessment
  @JsonKey(name: 'mother_temperature')
  double? get motherTemperature => throw _privateConstructorUsedError;
  @JsonKey(name: 'mother_blood_pressure')
  String? get motherBloodPressure => throw _privateConstructorUsedError;
  @JsonKey(name: 'mother_pulse')
  int? get motherPulse => throw _privateConstructorUsedError;
  @JsonKey(name: 'mother_weight')
  double? get motherWeight =>
      throw _privateConstructorUsedError; // Postpartum Complications
  @JsonKey(name: 'excessive_bleeding')
  bool get excessiveBleeding => throw _privateConstructorUsedError;
  @JsonKey(name: 'foul_discharge')
  bool get foulDischarge => throw _privateConstructorUsedError;
  @JsonKey(name: 'breast_problems')
  bool get breastProblems => throw _privateConstructorUsedError;
  @JsonKey(name: 'breast_problems_description')
  String? get breastProblemsDescription => throw _privateConstructorUsedError;
  @JsonKey(name: 'perineal_wound_infection')
  bool get perinealWoundInfection => throw _privateConstructorUsedError;
  @JsonKey(name: 'c_section_wound_infection')
  bool get cSectionWoundInfection => throw _privateConstructorUsedError;
  @JsonKey(name: 'urinary_problems')
  bool get urinaryProblems => throw _privateConstructorUsedError;
  @JsonKey(name: 'maternal_danger_signs')
  String? get maternalDangerSigns =>
      throw _privateConstructorUsedError; // Mental Health
  @JsonKey(name: 'mood_assessment')
  String? get moodAssessment =>
      throw _privateConstructorUsedError; // 'Good', 'Anxious', 'Depressed', 'Other'
  @JsonKey(name: 'mental_health_notes')
  String? get mentalHealthNotes =>
      throw _privateConstructorUsedError; // Baby's Health Assessment
  @JsonKey(name: 'baby_weight')
  double? get babyWeight => throw _privateConstructorUsedError;
  @JsonKey(name: 'baby_temperature')
  double? get babyTemperature => throw _privateConstructorUsedError;
  @JsonKey(name: 'baby_feeding_well')
  bool get babyFeedingWell => throw _privateConstructorUsedError;
  @JsonKey(name: 'baby_feeding_notes')
  String? get babyFeedingNotes =>
      throw _privateConstructorUsedError; // Cord Care
  @JsonKey(name: 'cord_status')
  String? get cordStatus =>
      throw _privateConstructorUsedError; // 'Normal', 'Infected', 'Bleeding', 'Fallen off'
  @JsonKey(name: 'cord_care_advice_given')
  bool get cordCareAdviceGiven =>
      throw _privateConstructorUsedError; // Jaundice
  @JsonKey(name: 'jaundice_present')
  bool get jaundicePresent => throw _privateConstructorUsedError;
  @JsonKey(name: 'jaundice_severity')
  String? get jaundiceSeverity =>
      throw _privateConstructorUsedError; // 'Mild', 'Moderate', 'Severe'
// Baby Danger Signs
  @JsonKey(name: 'baby_danger_signs')
  String? get babyDangerSigns => throw _privateConstructorUsedError;
  @JsonKey(name: 'baby_danger_signs_notes')
  String? get babyDangerSignsNotes =>
      throw _privateConstructorUsedError; // Breastfeeding Support
  @JsonKey(name: 'breastfeeding_status')
  String? get breastfeedingStatus =>
      throw _privateConstructorUsedError; // 'Exclusive', 'Mixed', 'Formula only', 'Not feeding'
  @JsonKey(name: 'breastfeeding_frequency')
  String? get breastfeedingFrequency => throw _privateConstructorUsedError;
  @JsonKey(name: 'latch_quality')
  String? get latchQuality =>
      throw _privateConstructorUsedError; // 'Good', 'Poor', 'Needs support'
  @JsonKey(name: 'breastfeeding_challenges')
  String? get breastfeedingChallenges => throw _privateConstructorUsedError;
  @JsonKey(name: 'breastfeeding_support_given')
  bool get breastfeedingSupportGiven => throw _privateConstructorUsedError;
  @JsonKey(name: 'breastfeeding_support_details')
  String? get breastfeedingSupportDetails =>
      throw _privateConstructorUsedError; // Family Planning
  @JsonKey(name: 'family_planning_discussed')
  bool get familyPlanningDiscussed => throw _privateConstructorUsedError;
  @JsonKey(name: 'family_planning_method_chosen')
  String? get familyPlanningMethodChosen => throw _privateConstructorUsedError;
  @JsonKey(name: 'family_planning_method_provided')
  bool get familyPlanningMethodProvided => throw _privateConstructorUsedError;
  @JsonKey(name: 'family_planning_notes')
  String? get familyPlanningNotes =>
      throw _privateConstructorUsedError; // Immunizations Given
  @JsonKey(name: 'immunizations_given')
  String? get immunizationsGiven =>
      throw _privateConstructorUsedError; // Referrals
  @JsonKey(name: 'referral_made')
  bool get referralMade => throw _privateConstructorUsedError;
  @JsonKey(name: 'referral_to')
  String? get referralTo => throw _privateConstructorUsedError;
  @JsonKey(name: 'referral_reason')
  String? get referralReason => throw _privateConstructorUsedError; // Follow-up
  @JsonKey(name: 'next_visit_date')
  DateTime? get nextVisitDate => throw _privateConstructorUsedError;
  @JsonKey(name: 'follow_up_instructions')
  String? get followUpInstructions =>
      throw _privateConstructorUsedError; // General Notes
  @JsonKey(name: 'general_notes')
  String? get generalNotes => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_at')
  DateTime? get createdAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'updated_at')
  DateTime? get updatedAt => throw _privateConstructorUsedError;

  /// Serializes this PostnatalVisit to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of PostnatalVisit
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PostnatalVisitCopyWith<PostnatalVisit> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PostnatalVisitCopyWith<$Res> {
  factory $PostnatalVisitCopyWith(
          PostnatalVisit value, $Res Function(PostnatalVisit) then) =
      _$PostnatalVisitCopyWithImpl<$Res, PostnatalVisit>;
  @useResult
  $Res call(
      {@JsonKey(name: 'id') String? id,
      @JsonKey(name: 'maternal_profile_id') String maternalProfileId,
      @JsonKey(name: 'child_profile_id') String? childProfileId,
      @JsonKey(name: 'visit_date') DateTime visitDate,
      @JsonKey(name: 'visit_type') String visitType,
      @JsonKey(name: 'days_postpartum') int daysPostpartum,
      @JsonKey(name: 'health_facility') String? healthFacility,
      @JsonKey(name: 'attended_by') String? attendedBy,
      @JsonKey(name: 'mother_temperature') double? motherTemperature,
      @JsonKey(name: 'mother_blood_pressure') String? motherBloodPressure,
      @JsonKey(name: 'mother_pulse') int? motherPulse,
      @JsonKey(name: 'mother_weight') double? motherWeight,
      @JsonKey(name: 'excessive_bleeding') bool excessiveBleeding,
      @JsonKey(name: 'foul_discharge') bool foulDischarge,
      @JsonKey(name: 'breast_problems') bool breastProblems,
      @JsonKey(name: 'breast_problems_description')
      String? breastProblemsDescription,
      @JsonKey(name: 'perineal_wound_infection') bool perinealWoundInfection,
      @JsonKey(name: 'c_section_wound_infection') bool cSectionWoundInfection,
      @JsonKey(name: 'urinary_problems') bool urinaryProblems,
      @JsonKey(name: 'maternal_danger_signs') String? maternalDangerSigns,
      @JsonKey(name: 'mood_assessment') String? moodAssessment,
      @JsonKey(name: 'mental_health_notes') String? mentalHealthNotes,
      @JsonKey(name: 'baby_weight') double? babyWeight,
      @JsonKey(name: 'baby_temperature') double? babyTemperature,
      @JsonKey(name: 'baby_feeding_well') bool babyFeedingWell,
      @JsonKey(name: 'baby_feeding_notes') String? babyFeedingNotes,
      @JsonKey(name: 'cord_status') String? cordStatus,
      @JsonKey(name: 'cord_care_advice_given') bool cordCareAdviceGiven,
      @JsonKey(name: 'jaundice_present') bool jaundicePresent,
      @JsonKey(name: 'jaundice_severity') String? jaundiceSeverity,
      @JsonKey(name: 'baby_danger_signs') String? babyDangerSigns,
      @JsonKey(name: 'baby_danger_signs_notes') String? babyDangerSignsNotes,
      @JsonKey(name: 'breastfeeding_status') String? breastfeedingStatus,
      @JsonKey(name: 'breastfeeding_frequency') String? breastfeedingFrequency,
      @JsonKey(name: 'latch_quality') String? latchQuality,
      @JsonKey(name: 'breastfeeding_challenges')
      String? breastfeedingChallenges,
      @JsonKey(name: 'breastfeeding_support_given')
      bool breastfeedingSupportGiven,
      @JsonKey(name: 'breastfeeding_support_details')
      String? breastfeedingSupportDetails,
      @JsonKey(name: 'family_planning_discussed') bool familyPlanningDiscussed,
      @JsonKey(name: 'family_planning_method_chosen')
      String? familyPlanningMethodChosen,
      @JsonKey(name: 'family_planning_method_provided')
      bool familyPlanningMethodProvided,
      @JsonKey(name: 'family_planning_notes') String? familyPlanningNotes,
      @JsonKey(name: 'immunizations_given') String? immunizationsGiven,
      @JsonKey(name: 'referral_made') bool referralMade,
      @JsonKey(name: 'referral_to') String? referralTo,
      @JsonKey(name: 'referral_reason') String? referralReason,
      @JsonKey(name: 'next_visit_date') DateTime? nextVisitDate,
      @JsonKey(name: 'follow_up_instructions') String? followUpInstructions,
      @JsonKey(name: 'general_notes') String? generalNotes,
      @JsonKey(name: 'created_at') DateTime? createdAt,
      @JsonKey(name: 'updated_at') DateTime? updatedAt});
}

/// @nodoc
class _$PostnatalVisitCopyWithImpl<$Res, $Val extends PostnatalVisit>
    implements $PostnatalVisitCopyWith<$Res> {
  _$PostnatalVisitCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PostnatalVisit
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? maternalProfileId = null,
    Object? childProfileId = freezed,
    Object? visitDate = null,
    Object? visitType = null,
    Object? daysPostpartum = null,
    Object? healthFacility = freezed,
    Object? attendedBy = freezed,
    Object? motherTemperature = freezed,
    Object? motherBloodPressure = freezed,
    Object? motherPulse = freezed,
    Object? motherWeight = freezed,
    Object? excessiveBleeding = null,
    Object? foulDischarge = null,
    Object? breastProblems = null,
    Object? breastProblemsDescription = freezed,
    Object? perinealWoundInfection = null,
    Object? cSectionWoundInfection = null,
    Object? urinaryProblems = null,
    Object? maternalDangerSigns = freezed,
    Object? moodAssessment = freezed,
    Object? mentalHealthNotes = freezed,
    Object? babyWeight = freezed,
    Object? babyTemperature = freezed,
    Object? babyFeedingWell = null,
    Object? babyFeedingNotes = freezed,
    Object? cordStatus = freezed,
    Object? cordCareAdviceGiven = null,
    Object? jaundicePresent = null,
    Object? jaundiceSeverity = freezed,
    Object? babyDangerSigns = freezed,
    Object? babyDangerSignsNotes = freezed,
    Object? breastfeedingStatus = freezed,
    Object? breastfeedingFrequency = freezed,
    Object? latchQuality = freezed,
    Object? breastfeedingChallenges = freezed,
    Object? breastfeedingSupportGiven = null,
    Object? breastfeedingSupportDetails = freezed,
    Object? familyPlanningDiscussed = null,
    Object? familyPlanningMethodChosen = freezed,
    Object? familyPlanningMethodProvided = null,
    Object? familyPlanningNotes = freezed,
    Object? immunizationsGiven = freezed,
    Object? referralMade = null,
    Object? referralTo = freezed,
    Object? referralReason = freezed,
    Object? nextVisitDate = freezed,
    Object? followUpInstructions = freezed,
    Object? generalNotes = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(_value.copyWith(
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String?,
      maternalProfileId: null == maternalProfileId
          ? _value.maternalProfileId
          : maternalProfileId // ignore: cast_nullable_to_non_nullable
              as String,
      childProfileId: freezed == childProfileId
          ? _value.childProfileId
          : childProfileId // ignore: cast_nullable_to_non_nullable
              as String?,
      visitDate: null == visitDate
          ? _value.visitDate
          : visitDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      visitType: null == visitType
          ? _value.visitType
          : visitType // ignore: cast_nullable_to_non_nullable
              as String,
      daysPostpartum: null == daysPostpartum
          ? _value.daysPostpartum
          : daysPostpartum // ignore: cast_nullable_to_non_nullable
              as int,
      healthFacility: freezed == healthFacility
          ? _value.healthFacility
          : healthFacility // ignore: cast_nullable_to_non_nullable
              as String?,
      attendedBy: freezed == attendedBy
          ? _value.attendedBy
          : attendedBy // ignore: cast_nullable_to_non_nullable
              as String?,
      motherTemperature: freezed == motherTemperature
          ? _value.motherTemperature
          : motherTemperature // ignore: cast_nullable_to_non_nullable
              as double?,
      motherBloodPressure: freezed == motherBloodPressure
          ? _value.motherBloodPressure
          : motherBloodPressure // ignore: cast_nullable_to_non_nullable
              as String?,
      motherPulse: freezed == motherPulse
          ? _value.motherPulse
          : motherPulse // ignore: cast_nullable_to_non_nullable
              as int?,
      motherWeight: freezed == motherWeight
          ? _value.motherWeight
          : motherWeight // ignore: cast_nullable_to_non_nullable
              as double?,
      excessiveBleeding: null == excessiveBleeding
          ? _value.excessiveBleeding
          : excessiveBleeding // ignore: cast_nullable_to_non_nullable
              as bool,
      foulDischarge: null == foulDischarge
          ? _value.foulDischarge
          : foulDischarge // ignore: cast_nullable_to_non_nullable
              as bool,
      breastProblems: null == breastProblems
          ? _value.breastProblems
          : breastProblems // ignore: cast_nullable_to_non_nullable
              as bool,
      breastProblemsDescription: freezed == breastProblemsDescription
          ? _value.breastProblemsDescription
          : breastProblemsDescription // ignore: cast_nullable_to_non_nullable
              as String?,
      perinealWoundInfection: null == perinealWoundInfection
          ? _value.perinealWoundInfection
          : perinealWoundInfection // ignore: cast_nullable_to_non_nullable
              as bool,
      cSectionWoundInfection: null == cSectionWoundInfection
          ? _value.cSectionWoundInfection
          : cSectionWoundInfection // ignore: cast_nullable_to_non_nullable
              as bool,
      urinaryProblems: null == urinaryProblems
          ? _value.urinaryProblems
          : urinaryProblems // ignore: cast_nullable_to_non_nullable
              as bool,
      maternalDangerSigns: freezed == maternalDangerSigns
          ? _value.maternalDangerSigns
          : maternalDangerSigns // ignore: cast_nullable_to_non_nullable
              as String?,
      moodAssessment: freezed == moodAssessment
          ? _value.moodAssessment
          : moodAssessment // ignore: cast_nullable_to_non_nullable
              as String?,
      mentalHealthNotes: freezed == mentalHealthNotes
          ? _value.mentalHealthNotes
          : mentalHealthNotes // ignore: cast_nullable_to_non_nullable
              as String?,
      babyWeight: freezed == babyWeight
          ? _value.babyWeight
          : babyWeight // ignore: cast_nullable_to_non_nullable
              as double?,
      babyTemperature: freezed == babyTemperature
          ? _value.babyTemperature
          : babyTemperature // ignore: cast_nullable_to_non_nullable
              as double?,
      babyFeedingWell: null == babyFeedingWell
          ? _value.babyFeedingWell
          : babyFeedingWell // ignore: cast_nullable_to_non_nullable
              as bool,
      babyFeedingNotes: freezed == babyFeedingNotes
          ? _value.babyFeedingNotes
          : babyFeedingNotes // ignore: cast_nullable_to_non_nullable
              as String?,
      cordStatus: freezed == cordStatus
          ? _value.cordStatus
          : cordStatus // ignore: cast_nullable_to_non_nullable
              as String?,
      cordCareAdviceGiven: null == cordCareAdviceGiven
          ? _value.cordCareAdviceGiven
          : cordCareAdviceGiven // ignore: cast_nullable_to_non_nullable
              as bool,
      jaundicePresent: null == jaundicePresent
          ? _value.jaundicePresent
          : jaundicePresent // ignore: cast_nullable_to_non_nullable
              as bool,
      jaundiceSeverity: freezed == jaundiceSeverity
          ? _value.jaundiceSeverity
          : jaundiceSeverity // ignore: cast_nullable_to_non_nullable
              as String?,
      babyDangerSigns: freezed == babyDangerSigns
          ? _value.babyDangerSigns
          : babyDangerSigns // ignore: cast_nullable_to_non_nullable
              as String?,
      babyDangerSignsNotes: freezed == babyDangerSignsNotes
          ? _value.babyDangerSignsNotes
          : babyDangerSignsNotes // ignore: cast_nullable_to_non_nullable
              as String?,
      breastfeedingStatus: freezed == breastfeedingStatus
          ? _value.breastfeedingStatus
          : breastfeedingStatus // ignore: cast_nullable_to_non_nullable
              as String?,
      breastfeedingFrequency: freezed == breastfeedingFrequency
          ? _value.breastfeedingFrequency
          : breastfeedingFrequency // ignore: cast_nullable_to_non_nullable
              as String?,
      latchQuality: freezed == latchQuality
          ? _value.latchQuality
          : latchQuality // ignore: cast_nullable_to_non_nullable
              as String?,
      breastfeedingChallenges: freezed == breastfeedingChallenges
          ? _value.breastfeedingChallenges
          : breastfeedingChallenges // ignore: cast_nullable_to_non_nullable
              as String?,
      breastfeedingSupportGiven: null == breastfeedingSupportGiven
          ? _value.breastfeedingSupportGiven
          : breastfeedingSupportGiven // ignore: cast_nullable_to_non_nullable
              as bool,
      breastfeedingSupportDetails: freezed == breastfeedingSupportDetails
          ? _value.breastfeedingSupportDetails
          : breastfeedingSupportDetails // ignore: cast_nullable_to_non_nullable
              as String?,
      familyPlanningDiscussed: null == familyPlanningDiscussed
          ? _value.familyPlanningDiscussed
          : familyPlanningDiscussed // ignore: cast_nullable_to_non_nullable
              as bool,
      familyPlanningMethodChosen: freezed == familyPlanningMethodChosen
          ? _value.familyPlanningMethodChosen
          : familyPlanningMethodChosen // ignore: cast_nullable_to_non_nullable
              as String?,
      familyPlanningMethodProvided: null == familyPlanningMethodProvided
          ? _value.familyPlanningMethodProvided
          : familyPlanningMethodProvided // ignore: cast_nullable_to_non_nullable
              as bool,
      familyPlanningNotes: freezed == familyPlanningNotes
          ? _value.familyPlanningNotes
          : familyPlanningNotes // ignore: cast_nullable_to_non_nullable
              as String?,
      immunizationsGiven: freezed == immunizationsGiven
          ? _value.immunizationsGiven
          : immunizationsGiven // ignore: cast_nullable_to_non_nullable
              as String?,
      referralMade: null == referralMade
          ? _value.referralMade
          : referralMade // ignore: cast_nullable_to_non_nullable
              as bool,
      referralTo: freezed == referralTo
          ? _value.referralTo
          : referralTo // ignore: cast_nullable_to_non_nullable
              as String?,
      referralReason: freezed == referralReason
          ? _value.referralReason
          : referralReason // ignore: cast_nullable_to_non_nullable
              as String?,
      nextVisitDate: freezed == nextVisitDate
          ? _value.nextVisitDate
          : nextVisitDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      followUpInstructions: freezed == followUpInstructions
          ? _value.followUpInstructions
          : followUpInstructions // ignore: cast_nullable_to_non_nullable
              as String?,
      generalNotes: freezed == generalNotes
          ? _value.generalNotes
          : generalNotes // ignore: cast_nullable_to_non_nullable
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
abstract class _$$PostnatalVisitImplCopyWith<$Res>
    implements $PostnatalVisitCopyWith<$Res> {
  factory _$$PostnatalVisitImplCopyWith(_$PostnatalVisitImpl value,
          $Res Function(_$PostnatalVisitImpl) then) =
      __$$PostnatalVisitImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'id') String? id,
      @JsonKey(name: 'maternal_profile_id') String maternalProfileId,
      @JsonKey(name: 'child_profile_id') String? childProfileId,
      @JsonKey(name: 'visit_date') DateTime visitDate,
      @JsonKey(name: 'visit_type') String visitType,
      @JsonKey(name: 'days_postpartum') int daysPostpartum,
      @JsonKey(name: 'health_facility') String? healthFacility,
      @JsonKey(name: 'attended_by') String? attendedBy,
      @JsonKey(name: 'mother_temperature') double? motherTemperature,
      @JsonKey(name: 'mother_blood_pressure') String? motherBloodPressure,
      @JsonKey(name: 'mother_pulse') int? motherPulse,
      @JsonKey(name: 'mother_weight') double? motherWeight,
      @JsonKey(name: 'excessive_bleeding') bool excessiveBleeding,
      @JsonKey(name: 'foul_discharge') bool foulDischarge,
      @JsonKey(name: 'breast_problems') bool breastProblems,
      @JsonKey(name: 'breast_problems_description')
      String? breastProblemsDescription,
      @JsonKey(name: 'perineal_wound_infection') bool perinealWoundInfection,
      @JsonKey(name: 'c_section_wound_infection') bool cSectionWoundInfection,
      @JsonKey(name: 'urinary_problems') bool urinaryProblems,
      @JsonKey(name: 'maternal_danger_signs') String? maternalDangerSigns,
      @JsonKey(name: 'mood_assessment') String? moodAssessment,
      @JsonKey(name: 'mental_health_notes') String? mentalHealthNotes,
      @JsonKey(name: 'baby_weight') double? babyWeight,
      @JsonKey(name: 'baby_temperature') double? babyTemperature,
      @JsonKey(name: 'baby_feeding_well') bool babyFeedingWell,
      @JsonKey(name: 'baby_feeding_notes') String? babyFeedingNotes,
      @JsonKey(name: 'cord_status') String? cordStatus,
      @JsonKey(name: 'cord_care_advice_given') bool cordCareAdviceGiven,
      @JsonKey(name: 'jaundice_present') bool jaundicePresent,
      @JsonKey(name: 'jaundice_severity') String? jaundiceSeverity,
      @JsonKey(name: 'baby_danger_signs') String? babyDangerSigns,
      @JsonKey(name: 'baby_danger_signs_notes') String? babyDangerSignsNotes,
      @JsonKey(name: 'breastfeeding_status') String? breastfeedingStatus,
      @JsonKey(name: 'breastfeeding_frequency') String? breastfeedingFrequency,
      @JsonKey(name: 'latch_quality') String? latchQuality,
      @JsonKey(name: 'breastfeeding_challenges')
      String? breastfeedingChallenges,
      @JsonKey(name: 'breastfeeding_support_given')
      bool breastfeedingSupportGiven,
      @JsonKey(name: 'breastfeeding_support_details')
      String? breastfeedingSupportDetails,
      @JsonKey(name: 'family_planning_discussed') bool familyPlanningDiscussed,
      @JsonKey(name: 'family_planning_method_chosen')
      String? familyPlanningMethodChosen,
      @JsonKey(name: 'family_planning_method_provided')
      bool familyPlanningMethodProvided,
      @JsonKey(name: 'family_planning_notes') String? familyPlanningNotes,
      @JsonKey(name: 'immunizations_given') String? immunizationsGiven,
      @JsonKey(name: 'referral_made') bool referralMade,
      @JsonKey(name: 'referral_to') String? referralTo,
      @JsonKey(name: 'referral_reason') String? referralReason,
      @JsonKey(name: 'next_visit_date') DateTime? nextVisitDate,
      @JsonKey(name: 'follow_up_instructions') String? followUpInstructions,
      @JsonKey(name: 'general_notes') String? generalNotes,
      @JsonKey(name: 'created_at') DateTime? createdAt,
      @JsonKey(name: 'updated_at') DateTime? updatedAt});
}

/// @nodoc
class __$$PostnatalVisitImplCopyWithImpl<$Res>
    extends _$PostnatalVisitCopyWithImpl<$Res, _$PostnatalVisitImpl>
    implements _$$PostnatalVisitImplCopyWith<$Res> {
  __$$PostnatalVisitImplCopyWithImpl(
      _$PostnatalVisitImpl _value, $Res Function(_$PostnatalVisitImpl) _then)
      : super(_value, _then);

  /// Create a copy of PostnatalVisit
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? maternalProfileId = null,
    Object? childProfileId = freezed,
    Object? visitDate = null,
    Object? visitType = null,
    Object? daysPostpartum = null,
    Object? healthFacility = freezed,
    Object? attendedBy = freezed,
    Object? motherTemperature = freezed,
    Object? motherBloodPressure = freezed,
    Object? motherPulse = freezed,
    Object? motherWeight = freezed,
    Object? excessiveBleeding = null,
    Object? foulDischarge = null,
    Object? breastProblems = null,
    Object? breastProblemsDescription = freezed,
    Object? perinealWoundInfection = null,
    Object? cSectionWoundInfection = null,
    Object? urinaryProblems = null,
    Object? maternalDangerSigns = freezed,
    Object? moodAssessment = freezed,
    Object? mentalHealthNotes = freezed,
    Object? babyWeight = freezed,
    Object? babyTemperature = freezed,
    Object? babyFeedingWell = null,
    Object? babyFeedingNotes = freezed,
    Object? cordStatus = freezed,
    Object? cordCareAdviceGiven = null,
    Object? jaundicePresent = null,
    Object? jaundiceSeverity = freezed,
    Object? babyDangerSigns = freezed,
    Object? babyDangerSignsNotes = freezed,
    Object? breastfeedingStatus = freezed,
    Object? breastfeedingFrequency = freezed,
    Object? latchQuality = freezed,
    Object? breastfeedingChallenges = freezed,
    Object? breastfeedingSupportGiven = null,
    Object? breastfeedingSupportDetails = freezed,
    Object? familyPlanningDiscussed = null,
    Object? familyPlanningMethodChosen = freezed,
    Object? familyPlanningMethodProvided = null,
    Object? familyPlanningNotes = freezed,
    Object? immunizationsGiven = freezed,
    Object? referralMade = null,
    Object? referralTo = freezed,
    Object? referralReason = freezed,
    Object? nextVisitDate = freezed,
    Object? followUpInstructions = freezed,
    Object? generalNotes = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(_$PostnatalVisitImpl(
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String?,
      maternalProfileId: null == maternalProfileId
          ? _value.maternalProfileId
          : maternalProfileId // ignore: cast_nullable_to_non_nullable
              as String,
      childProfileId: freezed == childProfileId
          ? _value.childProfileId
          : childProfileId // ignore: cast_nullable_to_non_nullable
              as String?,
      visitDate: null == visitDate
          ? _value.visitDate
          : visitDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      visitType: null == visitType
          ? _value.visitType
          : visitType // ignore: cast_nullable_to_non_nullable
              as String,
      daysPostpartum: null == daysPostpartum
          ? _value.daysPostpartum
          : daysPostpartum // ignore: cast_nullable_to_non_nullable
              as int,
      healthFacility: freezed == healthFacility
          ? _value.healthFacility
          : healthFacility // ignore: cast_nullable_to_non_nullable
              as String?,
      attendedBy: freezed == attendedBy
          ? _value.attendedBy
          : attendedBy // ignore: cast_nullable_to_non_nullable
              as String?,
      motherTemperature: freezed == motherTemperature
          ? _value.motherTemperature
          : motherTemperature // ignore: cast_nullable_to_non_nullable
              as double?,
      motherBloodPressure: freezed == motherBloodPressure
          ? _value.motherBloodPressure
          : motherBloodPressure // ignore: cast_nullable_to_non_nullable
              as String?,
      motherPulse: freezed == motherPulse
          ? _value.motherPulse
          : motherPulse // ignore: cast_nullable_to_non_nullable
              as int?,
      motherWeight: freezed == motherWeight
          ? _value.motherWeight
          : motherWeight // ignore: cast_nullable_to_non_nullable
              as double?,
      excessiveBleeding: null == excessiveBleeding
          ? _value.excessiveBleeding
          : excessiveBleeding // ignore: cast_nullable_to_non_nullable
              as bool,
      foulDischarge: null == foulDischarge
          ? _value.foulDischarge
          : foulDischarge // ignore: cast_nullable_to_non_nullable
              as bool,
      breastProblems: null == breastProblems
          ? _value.breastProblems
          : breastProblems // ignore: cast_nullable_to_non_nullable
              as bool,
      breastProblemsDescription: freezed == breastProblemsDescription
          ? _value.breastProblemsDescription
          : breastProblemsDescription // ignore: cast_nullable_to_non_nullable
              as String?,
      perinealWoundInfection: null == perinealWoundInfection
          ? _value.perinealWoundInfection
          : perinealWoundInfection // ignore: cast_nullable_to_non_nullable
              as bool,
      cSectionWoundInfection: null == cSectionWoundInfection
          ? _value.cSectionWoundInfection
          : cSectionWoundInfection // ignore: cast_nullable_to_non_nullable
              as bool,
      urinaryProblems: null == urinaryProblems
          ? _value.urinaryProblems
          : urinaryProblems // ignore: cast_nullable_to_non_nullable
              as bool,
      maternalDangerSigns: freezed == maternalDangerSigns
          ? _value.maternalDangerSigns
          : maternalDangerSigns // ignore: cast_nullable_to_non_nullable
              as String?,
      moodAssessment: freezed == moodAssessment
          ? _value.moodAssessment
          : moodAssessment // ignore: cast_nullable_to_non_nullable
              as String?,
      mentalHealthNotes: freezed == mentalHealthNotes
          ? _value.mentalHealthNotes
          : mentalHealthNotes // ignore: cast_nullable_to_non_nullable
              as String?,
      babyWeight: freezed == babyWeight
          ? _value.babyWeight
          : babyWeight // ignore: cast_nullable_to_non_nullable
              as double?,
      babyTemperature: freezed == babyTemperature
          ? _value.babyTemperature
          : babyTemperature // ignore: cast_nullable_to_non_nullable
              as double?,
      babyFeedingWell: null == babyFeedingWell
          ? _value.babyFeedingWell
          : babyFeedingWell // ignore: cast_nullable_to_non_nullable
              as bool,
      babyFeedingNotes: freezed == babyFeedingNotes
          ? _value.babyFeedingNotes
          : babyFeedingNotes // ignore: cast_nullable_to_non_nullable
              as String?,
      cordStatus: freezed == cordStatus
          ? _value.cordStatus
          : cordStatus // ignore: cast_nullable_to_non_nullable
              as String?,
      cordCareAdviceGiven: null == cordCareAdviceGiven
          ? _value.cordCareAdviceGiven
          : cordCareAdviceGiven // ignore: cast_nullable_to_non_nullable
              as bool,
      jaundicePresent: null == jaundicePresent
          ? _value.jaundicePresent
          : jaundicePresent // ignore: cast_nullable_to_non_nullable
              as bool,
      jaundiceSeverity: freezed == jaundiceSeverity
          ? _value.jaundiceSeverity
          : jaundiceSeverity // ignore: cast_nullable_to_non_nullable
              as String?,
      babyDangerSigns: freezed == babyDangerSigns
          ? _value.babyDangerSigns
          : babyDangerSigns // ignore: cast_nullable_to_non_nullable
              as String?,
      babyDangerSignsNotes: freezed == babyDangerSignsNotes
          ? _value.babyDangerSignsNotes
          : babyDangerSignsNotes // ignore: cast_nullable_to_non_nullable
              as String?,
      breastfeedingStatus: freezed == breastfeedingStatus
          ? _value.breastfeedingStatus
          : breastfeedingStatus // ignore: cast_nullable_to_non_nullable
              as String?,
      breastfeedingFrequency: freezed == breastfeedingFrequency
          ? _value.breastfeedingFrequency
          : breastfeedingFrequency // ignore: cast_nullable_to_non_nullable
              as String?,
      latchQuality: freezed == latchQuality
          ? _value.latchQuality
          : latchQuality // ignore: cast_nullable_to_non_nullable
              as String?,
      breastfeedingChallenges: freezed == breastfeedingChallenges
          ? _value.breastfeedingChallenges
          : breastfeedingChallenges // ignore: cast_nullable_to_non_nullable
              as String?,
      breastfeedingSupportGiven: null == breastfeedingSupportGiven
          ? _value.breastfeedingSupportGiven
          : breastfeedingSupportGiven // ignore: cast_nullable_to_non_nullable
              as bool,
      breastfeedingSupportDetails: freezed == breastfeedingSupportDetails
          ? _value.breastfeedingSupportDetails
          : breastfeedingSupportDetails // ignore: cast_nullable_to_non_nullable
              as String?,
      familyPlanningDiscussed: null == familyPlanningDiscussed
          ? _value.familyPlanningDiscussed
          : familyPlanningDiscussed // ignore: cast_nullable_to_non_nullable
              as bool,
      familyPlanningMethodChosen: freezed == familyPlanningMethodChosen
          ? _value.familyPlanningMethodChosen
          : familyPlanningMethodChosen // ignore: cast_nullable_to_non_nullable
              as String?,
      familyPlanningMethodProvided: null == familyPlanningMethodProvided
          ? _value.familyPlanningMethodProvided
          : familyPlanningMethodProvided // ignore: cast_nullable_to_non_nullable
              as bool,
      familyPlanningNotes: freezed == familyPlanningNotes
          ? _value.familyPlanningNotes
          : familyPlanningNotes // ignore: cast_nullable_to_non_nullable
              as String?,
      immunizationsGiven: freezed == immunizationsGiven
          ? _value.immunizationsGiven
          : immunizationsGiven // ignore: cast_nullable_to_non_nullable
              as String?,
      referralMade: null == referralMade
          ? _value.referralMade
          : referralMade // ignore: cast_nullable_to_non_nullable
              as bool,
      referralTo: freezed == referralTo
          ? _value.referralTo
          : referralTo // ignore: cast_nullable_to_non_nullable
              as String?,
      referralReason: freezed == referralReason
          ? _value.referralReason
          : referralReason // ignore: cast_nullable_to_non_nullable
              as String?,
      nextVisitDate: freezed == nextVisitDate
          ? _value.nextVisitDate
          : nextVisitDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      followUpInstructions: freezed == followUpInstructions
          ? _value.followUpInstructions
          : followUpInstructions // ignore: cast_nullable_to_non_nullable
              as String?,
      generalNotes: freezed == generalNotes
          ? _value.generalNotes
          : generalNotes // ignore: cast_nullable_to_non_nullable
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
class _$PostnatalVisitImpl implements _PostnatalVisit {
  const _$PostnatalVisitImpl(
      {@JsonKey(name: 'id') this.id,
      @JsonKey(name: 'maternal_profile_id') required this.maternalProfileId,
      @JsonKey(name: 'child_profile_id') this.childProfileId,
      @JsonKey(name: 'visit_date') required this.visitDate,
      @JsonKey(name: 'visit_type') required this.visitType,
      @JsonKey(name: 'days_postpartum') required this.daysPostpartum,
      @JsonKey(name: 'health_facility') this.healthFacility,
      @JsonKey(name: 'attended_by') this.attendedBy,
      @JsonKey(name: 'mother_temperature') this.motherTemperature,
      @JsonKey(name: 'mother_blood_pressure') this.motherBloodPressure,
      @JsonKey(name: 'mother_pulse') this.motherPulse,
      @JsonKey(name: 'mother_weight') this.motherWeight,
      @JsonKey(name: 'excessive_bleeding') this.excessiveBleeding = false,
      @JsonKey(name: 'foul_discharge') this.foulDischarge = false,
      @JsonKey(name: 'breast_problems') this.breastProblems = false,
      @JsonKey(name: 'breast_problems_description')
      this.breastProblemsDescription,
      @JsonKey(name: 'perineal_wound_infection')
      this.perinealWoundInfection = false,
      @JsonKey(name: 'c_section_wound_infection')
      this.cSectionWoundInfection = false,
      @JsonKey(name: 'urinary_problems') this.urinaryProblems = false,
      @JsonKey(name: 'maternal_danger_signs') this.maternalDangerSigns,
      @JsonKey(name: 'mood_assessment') this.moodAssessment,
      @JsonKey(name: 'mental_health_notes') this.mentalHealthNotes,
      @JsonKey(name: 'baby_weight') this.babyWeight,
      @JsonKey(name: 'baby_temperature') this.babyTemperature,
      @JsonKey(name: 'baby_feeding_well') this.babyFeedingWell = true,
      @JsonKey(name: 'baby_feeding_notes') this.babyFeedingNotes,
      @JsonKey(name: 'cord_status') this.cordStatus,
      @JsonKey(name: 'cord_care_advice_given') this.cordCareAdviceGiven = true,
      @JsonKey(name: 'jaundice_present') this.jaundicePresent = false,
      @JsonKey(name: 'jaundice_severity') this.jaundiceSeverity,
      @JsonKey(name: 'baby_danger_signs') this.babyDangerSigns,
      @JsonKey(name: 'baby_danger_signs_notes') this.babyDangerSignsNotes,
      @JsonKey(name: 'breastfeeding_status') this.breastfeedingStatus,
      @JsonKey(name: 'breastfeeding_frequency') this.breastfeedingFrequency,
      @JsonKey(name: 'latch_quality') this.latchQuality,
      @JsonKey(name: 'breastfeeding_challenges') this.breastfeedingChallenges,
      @JsonKey(name: 'breastfeeding_support_given')
      this.breastfeedingSupportGiven = false,
      @JsonKey(name: 'breastfeeding_support_details')
      this.breastfeedingSupportDetails,
      @JsonKey(name: 'family_planning_discussed')
      this.familyPlanningDiscussed = false,
      @JsonKey(name: 'family_planning_method_chosen')
      this.familyPlanningMethodChosen,
      @JsonKey(name: 'family_planning_method_provided')
      this.familyPlanningMethodProvided = false,
      @JsonKey(name: 'family_planning_notes') this.familyPlanningNotes,
      @JsonKey(name: 'immunizations_given') this.immunizationsGiven,
      @JsonKey(name: 'referral_made') this.referralMade = false,
      @JsonKey(name: 'referral_to') this.referralTo,
      @JsonKey(name: 'referral_reason') this.referralReason,
      @JsonKey(name: 'next_visit_date') this.nextVisitDate,
      @JsonKey(name: 'follow_up_instructions') this.followUpInstructions,
      @JsonKey(name: 'general_notes') this.generalNotes,
      @JsonKey(name: 'created_at') this.createdAt,
      @JsonKey(name: 'updated_at') this.updatedAt});

  factory _$PostnatalVisitImpl.fromJson(Map<String, dynamic> json) =>
      _$$PostnatalVisitImplFromJson(json);

  @override
  @JsonKey(name: 'id')
  final String? id;
  @override
  @JsonKey(name: 'maternal_profile_id')
  final String maternalProfileId;
  @override
  @JsonKey(name: 'child_profile_id')
  final String? childProfileId;
// Visit Details
  @override
  @JsonKey(name: 'visit_date')
  final DateTime visitDate;
  @override
  @JsonKey(name: 'visit_type')
  final String visitType;
// '48 hours', '6 days', '6 weeks', '6 months', 'Other'
  @override
  @JsonKey(name: 'days_postpartum')
  final int daysPostpartum;
  @override
  @JsonKey(name: 'health_facility')
  final String? healthFacility;
  @override
  @JsonKey(name: 'attended_by')
  final String? attendedBy;
// Mother's Health Assessment
  @override
  @JsonKey(name: 'mother_temperature')
  final double? motherTemperature;
  @override
  @JsonKey(name: 'mother_blood_pressure')
  final String? motherBloodPressure;
  @override
  @JsonKey(name: 'mother_pulse')
  final int? motherPulse;
  @override
  @JsonKey(name: 'mother_weight')
  final double? motherWeight;
// Postpartum Complications
  @override
  @JsonKey(name: 'excessive_bleeding')
  final bool excessiveBleeding;
  @override
  @JsonKey(name: 'foul_discharge')
  final bool foulDischarge;
  @override
  @JsonKey(name: 'breast_problems')
  final bool breastProblems;
  @override
  @JsonKey(name: 'breast_problems_description')
  final String? breastProblemsDescription;
  @override
  @JsonKey(name: 'perineal_wound_infection')
  final bool perinealWoundInfection;
  @override
  @JsonKey(name: 'c_section_wound_infection')
  final bool cSectionWoundInfection;
  @override
  @JsonKey(name: 'urinary_problems')
  final bool urinaryProblems;
  @override
  @JsonKey(name: 'maternal_danger_signs')
  final String? maternalDangerSigns;
// Mental Health
  @override
  @JsonKey(name: 'mood_assessment')
  final String? moodAssessment;
// 'Good', 'Anxious', 'Depressed', 'Other'
  @override
  @JsonKey(name: 'mental_health_notes')
  final String? mentalHealthNotes;
// Baby's Health Assessment
  @override
  @JsonKey(name: 'baby_weight')
  final double? babyWeight;
  @override
  @JsonKey(name: 'baby_temperature')
  final double? babyTemperature;
  @override
  @JsonKey(name: 'baby_feeding_well')
  final bool babyFeedingWell;
  @override
  @JsonKey(name: 'baby_feeding_notes')
  final String? babyFeedingNotes;
// Cord Care
  @override
  @JsonKey(name: 'cord_status')
  final String? cordStatus;
// 'Normal', 'Infected', 'Bleeding', 'Fallen off'
  @override
  @JsonKey(name: 'cord_care_advice_given')
  final bool cordCareAdviceGiven;
// Jaundice
  @override
  @JsonKey(name: 'jaundice_present')
  final bool jaundicePresent;
  @override
  @JsonKey(name: 'jaundice_severity')
  final String? jaundiceSeverity;
// 'Mild', 'Moderate', 'Severe'
// Baby Danger Signs
  @override
  @JsonKey(name: 'baby_danger_signs')
  final String? babyDangerSigns;
  @override
  @JsonKey(name: 'baby_danger_signs_notes')
  final String? babyDangerSignsNotes;
// Breastfeeding Support
  @override
  @JsonKey(name: 'breastfeeding_status')
  final String? breastfeedingStatus;
// 'Exclusive', 'Mixed', 'Formula only', 'Not feeding'
  @override
  @JsonKey(name: 'breastfeeding_frequency')
  final String? breastfeedingFrequency;
  @override
  @JsonKey(name: 'latch_quality')
  final String? latchQuality;
// 'Good', 'Poor', 'Needs support'
  @override
  @JsonKey(name: 'breastfeeding_challenges')
  final String? breastfeedingChallenges;
  @override
  @JsonKey(name: 'breastfeeding_support_given')
  final bool breastfeedingSupportGiven;
  @override
  @JsonKey(name: 'breastfeeding_support_details')
  final String? breastfeedingSupportDetails;
// Family Planning
  @override
  @JsonKey(name: 'family_planning_discussed')
  final bool familyPlanningDiscussed;
  @override
  @JsonKey(name: 'family_planning_method_chosen')
  final String? familyPlanningMethodChosen;
  @override
  @JsonKey(name: 'family_planning_method_provided')
  final bool familyPlanningMethodProvided;
  @override
  @JsonKey(name: 'family_planning_notes')
  final String? familyPlanningNotes;
// Immunizations Given
  @override
  @JsonKey(name: 'immunizations_given')
  final String? immunizationsGiven;
// Referrals
  @override
  @JsonKey(name: 'referral_made')
  final bool referralMade;
  @override
  @JsonKey(name: 'referral_to')
  final String? referralTo;
  @override
  @JsonKey(name: 'referral_reason')
  final String? referralReason;
// Follow-up
  @override
  @JsonKey(name: 'next_visit_date')
  final DateTime? nextVisitDate;
  @override
  @JsonKey(name: 'follow_up_instructions')
  final String? followUpInstructions;
// General Notes
  @override
  @JsonKey(name: 'general_notes')
  final String? generalNotes;
  @override
  @JsonKey(name: 'created_at')
  final DateTime? createdAt;
  @override
  @JsonKey(name: 'updated_at')
  final DateTime? updatedAt;

  @override
  String toString() {
    return 'PostnatalVisit(id: $id, maternalProfileId: $maternalProfileId, childProfileId: $childProfileId, visitDate: $visitDate, visitType: $visitType, daysPostpartum: $daysPostpartum, healthFacility: $healthFacility, attendedBy: $attendedBy, motherTemperature: $motherTemperature, motherBloodPressure: $motherBloodPressure, motherPulse: $motherPulse, motherWeight: $motherWeight, excessiveBleeding: $excessiveBleeding, foulDischarge: $foulDischarge, breastProblems: $breastProblems, breastProblemsDescription: $breastProblemsDescription, perinealWoundInfection: $perinealWoundInfection, cSectionWoundInfection: $cSectionWoundInfection, urinaryProblems: $urinaryProblems, maternalDangerSigns: $maternalDangerSigns, moodAssessment: $moodAssessment, mentalHealthNotes: $mentalHealthNotes, babyWeight: $babyWeight, babyTemperature: $babyTemperature, babyFeedingWell: $babyFeedingWell, babyFeedingNotes: $babyFeedingNotes, cordStatus: $cordStatus, cordCareAdviceGiven: $cordCareAdviceGiven, jaundicePresent: $jaundicePresent, jaundiceSeverity: $jaundiceSeverity, babyDangerSigns: $babyDangerSigns, babyDangerSignsNotes: $babyDangerSignsNotes, breastfeedingStatus: $breastfeedingStatus, breastfeedingFrequency: $breastfeedingFrequency, latchQuality: $latchQuality, breastfeedingChallenges: $breastfeedingChallenges, breastfeedingSupportGiven: $breastfeedingSupportGiven, breastfeedingSupportDetails: $breastfeedingSupportDetails, familyPlanningDiscussed: $familyPlanningDiscussed, familyPlanningMethodChosen: $familyPlanningMethodChosen, familyPlanningMethodProvided: $familyPlanningMethodProvided, familyPlanningNotes: $familyPlanningNotes, immunizationsGiven: $immunizationsGiven, referralMade: $referralMade, referralTo: $referralTo, referralReason: $referralReason, nextVisitDate: $nextVisitDate, followUpInstructions: $followUpInstructions, generalNotes: $generalNotes, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PostnatalVisitImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.maternalProfileId, maternalProfileId) ||
                other.maternalProfileId == maternalProfileId) &&
            (identical(other.childProfileId, childProfileId) ||
                other.childProfileId == childProfileId) &&
            (identical(other.visitDate, visitDate) ||
                other.visitDate == visitDate) &&
            (identical(other.visitType, visitType) ||
                other.visitType == visitType) &&
            (identical(other.daysPostpartum, daysPostpartum) ||
                other.daysPostpartum == daysPostpartum) &&
            (identical(other.healthFacility, healthFacility) ||
                other.healthFacility == healthFacility) &&
            (identical(other.attendedBy, attendedBy) ||
                other.attendedBy == attendedBy) &&
            (identical(other.motherTemperature, motherTemperature) ||
                other.motherTemperature == motherTemperature) &&
            (identical(other.motherBloodPressure, motherBloodPressure) ||
                other.motherBloodPressure == motherBloodPressure) &&
            (identical(other.motherPulse, motherPulse) ||
                other.motherPulse == motherPulse) &&
            (identical(other.motherWeight, motherWeight) ||
                other.motherWeight == motherWeight) &&
            (identical(other.excessiveBleeding, excessiveBleeding) ||
                other.excessiveBleeding == excessiveBleeding) &&
            (identical(other.foulDischarge, foulDischarge) ||
                other.foulDischarge == foulDischarge) &&
            (identical(other.breastProblems, breastProblems) ||
                other.breastProblems == breastProblems) &&
            (identical(other.breastProblemsDescription, breastProblemsDescription) ||
                other.breastProblemsDescription == breastProblemsDescription) &&
            (identical(other.perinealWoundInfection, perinealWoundInfection) ||
                other.perinealWoundInfection == perinealWoundInfection) &&
            (identical(other.cSectionWoundInfection, cSectionWoundInfection) ||
                other.cSectionWoundInfection == cSectionWoundInfection) &&
            (identical(other.urinaryProblems, urinaryProblems) ||
                other.urinaryProblems == urinaryProblems) &&
            (identical(other.maternalDangerSigns, maternalDangerSigns) ||
                other.maternalDangerSigns == maternalDangerSigns) &&
            (identical(other.moodAssessment, moodAssessment) ||
                other.moodAssessment == moodAssessment) &&
            (identical(other.mentalHealthNotes, mentalHealthNotes) ||
                other.mentalHealthNotes == mentalHealthNotes) &&
            (identical(other.babyWeight, babyWeight) ||
                other.babyWeight == babyWeight) &&
            (identical(other.babyTemperature, babyTemperature) ||
                other.babyTemperature == babyTemperature) &&
            (identical(other.babyFeedingWell, babyFeedingWell) ||
                other.babyFeedingWell == babyFeedingWell) &&
            (identical(other.babyFeedingNotes, babyFeedingNotes) ||
                other.babyFeedingNotes == babyFeedingNotes) &&
            (identical(other.cordStatus, cordStatus) ||
                other.cordStatus == cordStatus) &&
            (identical(other.cordCareAdviceGiven, cordCareAdviceGiven) ||
                other.cordCareAdviceGiven == cordCareAdviceGiven) &&
            (identical(other.jaundicePresent, jaundicePresent) ||
                other.jaundicePresent == jaundicePresent) &&
            (identical(other.jaundiceSeverity, jaundiceSeverity) ||
                other.jaundiceSeverity == jaundiceSeverity) &&
            (identical(other.babyDangerSigns, babyDangerSigns) ||
                other.babyDangerSigns == babyDangerSigns) &&
            (identical(other.babyDangerSignsNotes, babyDangerSignsNotes) ||
                other.babyDangerSignsNotes == babyDangerSignsNotes) &&
            (identical(other.breastfeedingStatus, breastfeedingStatus) ||
                other.breastfeedingStatus == breastfeedingStatus) &&
            (identical(other.breastfeedingFrequency, breastfeedingFrequency) ||
                other.breastfeedingFrequency == breastfeedingFrequency) &&
            (identical(other.latchQuality, latchQuality) ||
                other.latchQuality == latchQuality) &&
            (identical(other.breastfeedingChallenges, breastfeedingChallenges) ||
                other.breastfeedingChallenges == breastfeedingChallenges) &&
            (identical(other.breastfeedingSupportGiven, breastfeedingSupportGiven) ||
                other.breastfeedingSupportGiven == breastfeedingSupportGiven) &&
            (identical(other.breastfeedingSupportDetails, breastfeedingSupportDetails) ||
                other.breastfeedingSupportDetails == breastfeedingSupportDetails) &&
            (identical(other.familyPlanningDiscussed, familyPlanningDiscussed) || other.familyPlanningDiscussed == familyPlanningDiscussed) &&
            (identical(other.familyPlanningMethodChosen, familyPlanningMethodChosen) || other.familyPlanningMethodChosen == familyPlanningMethodChosen) &&
            (identical(other.familyPlanningMethodProvided, familyPlanningMethodProvided) || other.familyPlanningMethodProvided == familyPlanningMethodProvided) &&
            (identical(other.familyPlanningNotes, familyPlanningNotes) || other.familyPlanningNotes == familyPlanningNotes) &&
            (identical(other.immunizationsGiven, immunizationsGiven) || other.immunizationsGiven == immunizationsGiven) &&
            (identical(other.referralMade, referralMade) || other.referralMade == referralMade) &&
            (identical(other.referralTo, referralTo) || other.referralTo == referralTo) &&
            (identical(other.referralReason, referralReason) || other.referralReason == referralReason) &&
            (identical(other.nextVisitDate, nextVisitDate) || other.nextVisitDate == nextVisitDate) &&
            (identical(other.followUpInstructions, followUpInstructions) || other.followUpInstructions == followUpInstructions) &&
            (identical(other.generalNotes, generalNotes) || other.generalNotes == generalNotes) &&
            (identical(other.createdAt, createdAt) || other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hashAll([
        runtimeType,
        id,
        maternalProfileId,
        childProfileId,
        visitDate,
        visitType,
        daysPostpartum,
        healthFacility,
        attendedBy,
        motherTemperature,
        motherBloodPressure,
        motherPulse,
        motherWeight,
        excessiveBleeding,
        foulDischarge,
        breastProblems,
        breastProblemsDescription,
        perinealWoundInfection,
        cSectionWoundInfection,
        urinaryProblems,
        maternalDangerSigns,
        moodAssessment,
        mentalHealthNotes,
        babyWeight,
        babyTemperature,
        babyFeedingWell,
        babyFeedingNotes,
        cordStatus,
        cordCareAdviceGiven,
        jaundicePresent,
        jaundiceSeverity,
        babyDangerSigns,
        babyDangerSignsNotes,
        breastfeedingStatus,
        breastfeedingFrequency,
        latchQuality,
        breastfeedingChallenges,
        breastfeedingSupportGiven,
        breastfeedingSupportDetails,
        familyPlanningDiscussed,
        familyPlanningMethodChosen,
        familyPlanningMethodProvided,
        familyPlanningNotes,
        immunizationsGiven,
        referralMade,
        referralTo,
        referralReason,
        nextVisitDate,
        followUpInstructions,
        generalNotes,
        createdAt,
        updatedAt
      ]);

  /// Create a copy of PostnatalVisit
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PostnatalVisitImplCopyWith<_$PostnatalVisitImpl> get copyWith =>
      __$$PostnatalVisitImplCopyWithImpl<_$PostnatalVisitImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PostnatalVisitImplToJson(
      this,
    );
  }
}

abstract class _PostnatalVisit implements PostnatalVisit {
  const factory _PostnatalVisit(
      {@JsonKey(name: 'id') final String? id,
      @JsonKey(name: 'maternal_profile_id')
      required final String maternalProfileId,
      @JsonKey(name: 'child_profile_id') final String? childProfileId,
      @JsonKey(name: 'visit_date') required final DateTime visitDate,
      @JsonKey(name: 'visit_type') required final String visitType,
      @JsonKey(name: 'days_postpartum') required final int daysPostpartum,
      @JsonKey(name: 'health_facility') final String? healthFacility,
      @JsonKey(name: 'attended_by') final String? attendedBy,
      @JsonKey(name: 'mother_temperature') final double? motherTemperature,
      @JsonKey(name: 'mother_blood_pressure') final String? motherBloodPressure,
      @JsonKey(name: 'mother_pulse') final int? motherPulse,
      @JsonKey(name: 'mother_weight') final double? motherWeight,
      @JsonKey(name: 'excessive_bleeding') final bool excessiveBleeding,
      @JsonKey(name: 'foul_discharge') final bool foulDischarge,
      @JsonKey(name: 'breast_problems') final bool breastProblems,
      @JsonKey(name: 'breast_problems_description')
      final String? breastProblemsDescription,
      @JsonKey(name: 'perineal_wound_infection')
      final bool perinealWoundInfection,
      @JsonKey(name: 'c_section_wound_infection')
      final bool cSectionWoundInfection,
      @JsonKey(name: 'urinary_problems') final bool urinaryProblems,
      @JsonKey(name: 'maternal_danger_signs') final String? maternalDangerSigns,
      @JsonKey(name: 'mood_assessment') final String? moodAssessment,
      @JsonKey(name: 'mental_health_notes') final String? mentalHealthNotes,
      @JsonKey(name: 'baby_weight') final double? babyWeight,
      @JsonKey(name: 'baby_temperature') final double? babyTemperature,
      @JsonKey(name: 'baby_feeding_well') final bool babyFeedingWell,
      @JsonKey(name: 'baby_feeding_notes') final String? babyFeedingNotes,
      @JsonKey(name: 'cord_status') final String? cordStatus,
      @JsonKey(name: 'cord_care_advice_given') final bool cordCareAdviceGiven,
      @JsonKey(name: 'jaundice_present') final bool jaundicePresent,
      @JsonKey(name: 'jaundice_severity') final String? jaundiceSeverity,
      @JsonKey(name: 'baby_danger_signs') final String? babyDangerSigns,
      @JsonKey(name: 'baby_danger_signs_notes')
      final String? babyDangerSignsNotes,
      @JsonKey(name: 'breastfeeding_status') final String? breastfeedingStatus,
      @JsonKey(name: 'breastfeeding_frequency')
      final String? breastfeedingFrequency,
      @JsonKey(name: 'latch_quality') final String? latchQuality,
      @JsonKey(name: 'breastfeeding_challenges')
      final String? breastfeedingChallenges,
      @JsonKey(name: 'breastfeeding_support_given')
      final bool breastfeedingSupportGiven,
      @JsonKey(name: 'breastfeeding_support_details')
      final String? breastfeedingSupportDetails,
      @JsonKey(name: 'family_planning_discussed')
      final bool familyPlanningDiscussed,
      @JsonKey(name: 'family_planning_method_chosen')
      final String? familyPlanningMethodChosen,
      @JsonKey(name: 'family_planning_method_provided')
      final bool familyPlanningMethodProvided,
      @JsonKey(name: 'family_planning_notes') final String? familyPlanningNotes,
      @JsonKey(name: 'immunizations_given') final String? immunizationsGiven,
      @JsonKey(name: 'referral_made') final bool referralMade,
      @JsonKey(name: 'referral_to') final String? referralTo,
      @JsonKey(name: 'referral_reason') final String? referralReason,
      @JsonKey(name: 'next_visit_date') final DateTime? nextVisitDate,
      @JsonKey(name: 'follow_up_instructions')
      final String? followUpInstructions,
      @JsonKey(name: 'general_notes') final String? generalNotes,
      @JsonKey(name: 'created_at') final DateTime? createdAt,
      @JsonKey(name: 'updated_at')
      final DateTime? updatedAt}) = _$PostnatalVisitImpl;

  factory _PostnatalVisit.fromJson(Map<String, dynamic> json) =
      _$PostnatalVisitImpl.fromJson;

  @override
  @JsonKey(name: 'id')
  String? get id;
  @override
  @JsonKey(name: 'maternal_profile_id')
  String get maternalProfileId;
  @override
  @JsonKey(name: 'child_profile_id')
  String? get childProfileId; // Visit Details
  @override
  @JsonKey(name: 'visit_date')
  DateTime get visitDate;
  @override
  @JsonKey(name: 'visit_type')
  String get visitType; // '48 hours', '6 days', '6 weeks', '6 months', 'Other'
  @override
  @JsonKey(name: 'days_postpartum')
  int get daysPostpartum;
  @override
  @JsonKey(name: 'health_facility')
  String? get healthFacility;
  @override
  @JsonKey(name: 'attended_by')
  String? get attendedBy; // Mother's Health Assessment
  @override
  @JsonKey(name: 'mother_temperature')
  double? get motherTemperature;
  @override
  @JsonKey(name: 'mother_blood_pressure')
  String? get motherBloodPressure;
  @override
  @JsonKey(name: 'mother_pulse')
  int? get motherPulse;
  @override
  @JsonKey(name: 'mother_weight')
  double? get motherWeight; // Postpartum Complications
  @override
  @JsonKey(name: 'excessive_bleeding')
  bool get excessiveBleeding;
  @override
  @JsonKey(name: 'foul_discharge')
  bool get foulDischarge;
  @override
  @JsonKey(name: 'breast_problems')
  bool get breastProblems;
  @override
  @JsonKey(name: 'breast_problems_description')
  String? get breastProblemsDescription;
  @override
  @JsonKey(name: 'perineal_wound_infection')
  bool get perinealWoundInfection;
  @override
  @JsonKey(name: 'c_section_wound_infection')
  bool get cSectionWoundInfection;
  @override
  @JsonKey(name: 'urinary_problems')
  bool get urinaryProblems;
  @override
  @JsonKey(name: 'maternal_danger_signs')
  String? get maternalDangerSigns; // Mental Health
  @override
  @JsonKey(name: 'mood_assessment')
  String? get moodAssessment; // 'Good', 'Anxious', 'Depressed', 'Other'
  @override
  @JsonKey(name: 'mental_health_notes')
  String? get mentalHealthNotes; // Baby's Health Assessment
  @override
  @JsonKey(name: 'baby_weight')
  double? get babyWeight;
  @override
  @JsonKey(name: 'baby_temperature')
  double? get babyTemperature;
  @override
  @JsonKey(name: 'baby_feeding_well')
  bool get babyFeedingWell;
  @override
  @JsonKey(name: 'baby_feeding_notes')
  String? get babyFeedingNotes; // Cord Care
  @override
  @JsonKey(name: 'cord_status')
  String? get cordStatus; // 'Normal', 'Infected', 'Bleeding', 'Fallen off'
  @override
  @JsonKey(name: 'cord_care_advice_given')
  bool get cordCareAdviceGiven; // Jaundice
  @override
  @JsonKey(name: 'jaundice_present')
  bool get jaundicePresent;
  @override
  @JsonKey(name: 'jaundice_severity')
  String? get jaundiceSeverity; // 'Mild', 'Moderate', 'Severe'
// Baby Danger Signs
  @override
  @JsonKey(name: 'baby_danger_signs')
  String? get babyDangerSigns;
  @override
  @JsonKey(name: 'baby_danger_signs_notes')
  String? get babyDangerSignsNotes; // Breastfeeding Support
  @override
  @JsonKey(name: 'breastfeeding_status')
  String?
      get breastfeedingStatus; // 'Exclusive', 'Mixed', 'Formula only', 'Not feeding'
  @override
  @JsonKey(name: 'breastfeeding_frequency')
  String? get breastfeedingFrequency;
  @override
  @JsonKey(name: 'latch_quality')
  String? get latchQuality; // 'Good', 'Poor', 'Needs support'
  @override
  @JsonKey(name: 'breastfeeding_challenges')
  String? get breastfeedingChallenges;
  @override
  @JsonKey(name: 'breastfeeding_support_given')
  bool get breastfeedingSupportGiven;
  @override
  @JsonKey(name: 'breastfeeding_support_details')
  String? get breastfeedingSupportDetails; // Family Planning
  @override
  @JsonKey(name: 'family_planning_discussed')
  bool get familyPlanningDiscussed;
  @override
  @JsonKey(name: 'family_planning_method_chosen')
  String? get familyPlanningMethodChosen;
  @override
  @JsonKey(name: 'family_planning_method_provided')
  bool get familyPlanningMethodProvided;
  @override
  @JsonKey(name: 'family_planning_notes')
  String? get familyPlanningNotes; // Immunizations Given
  @override
  @JsonKey(name: 'immunizations_given')
  String? get immunizationsGiven; // Referrals
  @override
  @JsonKey(name: 'referral_made')
  bool get referralMade;
  @override
  @JsonKey(name: 'referral_to')
  String? get referralTo;
  @override
  @JsonKey(name: 'referral_reason')
  String? get referralReason; // Follow-up
  @override
  @JsonKey(name: 'next_visit_date')
  DateTime? get nextVisitDate;
  @override
  @JsonKey(name: 'follow_up_instructions')
  String? get followUpInstructions; // General Notes
  @override
  @JsonKey(name: 'general_notes')
  String? get generalNotes;
  @override
  @JsonKey(name: 'created_at')
  DateTime? get createdAt;
  @override
  @JsonKey(name: 'updated_at')
  DateTime? get updatedAt;

  /// Create a copy of PostnatalVisit
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PostnatalVisitImplCopyWith<_$PostnatalVisitImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
