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
  String get id => throw _privateConstructorUsedError;
  String get maternalProfileId => throw _privateConstructorUsedError;
  String? get childId =>
      throw _privateConstructorUsedError; // Link to child if already registered
  int get contactNumber => throw _privateConstructorUsedError; // 1-4
  DateTime get visitDate => throw _privateConstructorUsedError; // Timing
  String? get timingLabel =>
      throw _privateConstructorUsedError; // "Within 48hrs", "1-2 weeks", "4-6 weeks", "4-6 months"
// MOTHER Assessment
  String? get bloodPressure => throw _privateConstructorUsedError;
  double? get temperature => throw _privateConstructorUsedError;
  int? get pulseRate => throw _privateConstructorUsedError;
  int? get respiratoryRate => throw _privateConstructorUsedError;
  String? get generalCondition =>
      throw _privateConstructorUsedError; // Breast Examination
  String? get breastCondition => throw _privateConstructorUsedError;
  bool? get breastEngorgement => throw _privateConstructorUsedError;
  bool? get crackedNipples => throw _privateConstructorUsedError;
  bool? get mastitis =>
      throw _privateConstructorUsedError; // C-Section Scar (if applicable)
  String? get csScarCondition =>
      throw _privateConstructorUsedError; // Uterus Involution
  String? get uterusInvolution =>
      throw _privateConstructorUsedError; // Well involuted, Not well involuted
// Pelvic Examination
  String? get pelvicExam => throw _privateConstructorUsedError;
  String? get episiotomyCondition =>
      throw _privateConstructorUsedError; // Lochia (discharge)
  String? get lochiaSmell => throw _privateConstructorUsedError;
  String? get lochiaAmount => throw _privateConstructorUsedError;
  String? get lochiaColor => throw _privateConstructorUsedError; // Lab Tests
  double? get haemoglobin => throw _privateConstructorUsedError; // HIV Status
  bool? get motherHivTested => throw _privateConstructorUsedError;
  String? get motherHivResult => throw _privateConstructorUsedError;
  bool? get motherOnHaart => throw _privateConstructorUsedError;
  String? get haartRegimen =>
      throw _privateConstructorUsedError; // Family Planning
  bool? get fpCounselingDone => throw _privateConstructorUsedError;
  String? get fpMethodChosen => throw _privateConstructorUsedError;
  bool? get fpMethodProvided =>
      throw _privateConstructorUsedError; // Maternal Mental Health
  bool? get maternalMentalHealthScreened => throw _privateConstructorUsedError;
  String? get mentalHealthStatus =>
      throw _privateConstructorUsedError; // BABY Assessment (if present)
  String? get babyGeneralCondition => throw _privateConstructorUsedError;
  double? get babyTemperature => throw _privateConstructorUsedError;
  int? get babyBreathsPerMinute =>
      throw _privateConstructorUsedError; // Feeding
  bool? get exclusiveBreastfeeding => throw _privateConstructorUsedError;
  String? get breastfeedingPositioning =>
      throw _privateConstructorUsedError; // Correct, Not correct
  String? get breastfeedingAttachment =>
      throw _privateConstructorUsedError; // Good, Poor
// Umbilical Cord
  String? get umbilicalCordStatus =>
      throw _privateConstructorUsedError; // Clean, Dry, Bleeding, Infected
// Baby Immunization
  bool? get babyImmunizationStarted =>
      throw _privateConstructorUsedError; // HEI (HIV Exposed Infant)
  bool? get babyHivExposed => throw _privateConstructorUsedError;
  bool? get babyOnArvProphylaxis => throw _privateConstructorUsedError;
  bool? get babyOnCtxProphylaxis =>
      throw _privateConstructorUsedError; // Other Baby Issues
  bool? get babyIrritable => throw _privateConstructorUsedError;
  String? get otherBabyProblems =>
      throw _privateConstructorUsedError; // Clinical Notes
  String? get motherNotes => throw _privateConstructorUsedError;
  String? get babyNotes => throw _privateConstructorUsedError;
  String? get diagnosis => throw _privateConstructorUsedError;
  String? get treatment => throw _privateConstructorUsedError; // Next Visit
  DateTime? get nextVisitDate => throw _privateConstructorUsedError;
  String? get healthWorkerName => throw _privateConstructorUsedError;
  DateTime? get createdAt => throw _privateConstructorUsedError;
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
      {String id,
      String maternalProfileId,
      String? childId,
      int contactNumber,
      DateTime visitDate,
      String? timingLabel,
      String? bloodPressure,
      double? temperature,
      int? pulseRate,
      int? respiratoryRate,
      String? generalCondition,
      String? breastCondition,
      bool? breastEngorgement,
      bool? crackedNipples,
      bool? mastitis,
      String? csScarCondition,
      String? uterusInvolution,
      String? pelvicExam,
      String? episiotomyCondition,
      String? lochiaSmell,
      String? lochiaAmount,
      String? lochiaColor,
      double? haemoglobin,
      bool? motherHivTested,
      String? motherHivResult,
      bool? motherOnHaart,
      String? haartRegimen,
      bool? fpCounselingDone,
      String? fpMethodChosen,
      bool? fpMethodProvided,
      bool? maternalMentalHealthScreened,
      String? mentalHealthStatus,
      String? babyGeneralCondition,
      double? babyTemperature,
      int? babyBreathsPerMinute,
      bool? exclusiveBreastfeeding,
      String? breastfeedingPositioning,
      String? breastfeedingAttachment,
      String? umbilicalCordStatus,
      bool? babyImmunizationStarted,
      bool? babyHivExposed,
      bool? babyOnArvProphylaxis,
      bool? babyOnCtxProphylaxis,
      bool? babyIrritable,
      String? otherBabyProblems,
      String? motherNotes,
      String? babyNotes,
      String? diagnosis,
      String? treatment,
      DateTime? nextVisitDate,
      String? healthWorkerName,
      DateTime? createdAt,
      DateTime? updatedAt});
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
    Object? id = null,
    Object? maternalProfileId = null,
    Object? childId = freezed,
    Object? contactNumber = null,
    Object? visitDate = null,
    Object? timingLabel = freezed,
    Object? bloodPressure = freezed,
    Object? temperature = freezed,
    Object? pulseRate = freezed,
    Object? respiratoryRate = freezed,
    Object? generalCondition = freezed,
    Object? breastCondition = freezed,
    Object? breastEngorgement = freezed,
    Object? crackedNipples = freezed,
    Object? mastitis = freezed,
    Object? csScarCondition = freezed,
    Object? uterusInvolution = freezed,
    Object? pelvicExam = freezed,
    Object? episiotomyCondition = freezed,
    Object? lochiaSmell = freezed,
    Object? lochiaAmount = freezed,
    Object? lochiaColor = freezed,
    Object? haemoglobin = freezed,
    Object? motherHivTested = freezed,
    Object? motherHivResult = freezed,
    Object? motherOnHaart = freezed,
    Object? haartRegimen = freezed,
    Object? fpCounselingDone = freezed,
    Object? fpMethodChosen = freezed,
    Object? fpMethodProvided = freezed,
    Object? maternalMentalHealthScreened = freezed,
    Object? mentalHealthStatus = freezed,
    Object? babyGeneralCondition = freezed,
    Object? babyTemperature = freezed,
    Object? babyBreathsPerMinute = freezed,
    Object? exclusiveBreastfeeding = freezed,
    Object? breastfeedingPositioning = freezed,
    Object? breastfeedingAttachment = freezed,
    Object? umbilicalCordStatus = freezed,
    Object? babyImmunizationStarted = freezed,
    Object? babyHivExposed = freezed,
    Object? babyOnArvProphylaxis = freezed,
    Object? babyOnCtxProphylaxis = freezed,
    Object? babyIrritable = freezed,
    Object? otherBabyProblems = freezed,
    Object? motherNotes = freezed,
    Object? babyNotes = freezed,
    Object? diagnosis = freezed,
    Object? treatment = freezed,
    Object? nextVisitDate = freezed,
    Object? healthWorkerName = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      maternalProfileId: null == maternalProfileId
          ? _value.maternalProfileId
          : maternalProfileId // ignore: cast_nullable_to_non_nullable
              as String,
      childId: freezed == childId
          ? _value.childId
          : childId // ignore: cast_nullable_to_non_nullable
              as String?,
      contactNumber: null == contactNumber
          ? _value.contactNumber
          : contactNumber // ignore: cast_nullable_to_non_nullable
              as int,
      visitDate: null == visitDate
          ? _value.visitDate
          : visitDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      timingLabel: freezed == timingLabel
          ? _value.timingLabel
          : timingLabel // ignore: cast_nullable_to_non_nullable
              as String?,
      bloodPressure: freezed == bloodPressure
          ? _value.bloodPressure
          : bloodPressure // ignore: cast_nullable_to_non_nullable
              as String?,
      temperature: freezed == temperature
          ? _value.temperature
          : temperature // ignore: cast_nullable_to_non_nullable
              as double?,
      pulseRate: freezed == pulseRate
          ? _value.pulseRate
          : pulseRate // ignore: cast_nullable_to_non_nullable
              as int?,
      respiratoryRate: freezed == respiratoryRate
          ? _value.respiratoryRate
          : respiratoryRate // ignore: cast_nullable_to_non_nullable
              as int?,
      generalCondition: freezed == generalCondition
          ? _value.generalCondition
          : generalCondition // ignore: cast_nullable_to_non_nullable
              as String?,
      breastCondition: freezed == breastCondition
          ? _value.breastCondition
          : breastCondition // ignore: cast_nullable_to_non_nullable
              as String?,
      breastEngorgement: freezed == breastEngorgement
          ? _value.breastEngorgement
          : breastEngorgement // ignore: cast_nullable_to_non_nullable
              as bool?,
      crackedNipples: freezed == crackedNipples
          ? _value.crackedNipples
          : crackedNipples // ignore: cast_nullable_to_non_nullable
              as bool?,
      mastitis: freezed == mastitis
          ? _value.mastitis
          : mastitis // ignore: cast_nullable_to_non_nullable
              as bool?,
      csScarCondition: freezed == csScarCondition
          ? _value.csScarCondition
          : csScarCondition // ignore: cast_nullable_to_non_nullable
              as String?,
      uterusInvolution: freezed == uterusInvolution
          ? _value.uterusInvolution
          : uterusInvolution // ignore: cast_nullable_to_non_nullable
              as String?,
      pelvicExam: freezed == pelvicExam
          ? _value.pelvicExam
          : pelvicExam // ignore: cast_nullable_to_non_nullable
              as String?,
      episiotomyCondition: freezed == episiotomyCondition
          ? _value.episiotomyCondition
          : episiotomyCondition // ignore: cast_nullable_to_non_nullable
              as String?,
      lochiaSmell: freezed == lochiaSmell
          ? _value.lochiaSmell
          : lochiaSmell // ignore: cast_nullable_to_non_nullable
              as String?,
      lochiaAmount: freezed == lochiaAmount
          ? _value.lochiaAmount
          : lochiaAmount // ignore: cast_nullable_to_non_nullable
              as String?,
      lochiaColor: freezed == lochiaColor
          ? _value.lochiaColor
          : lochiaColor // ignore: cast_nullable_to_non_nullable
              as String?,
      haemoglobin: freezed == haemoglobin
          ? _value.haemoglobin
          : haemoglobin // ignore: cast_nullable_to_non_nullable
              as double?,
      motherHivTested: freezed == motherHivTested
          ? _value.motherHivTested
          : motherHivTested // ignore: cast_nullable_to_non_nullable
              as bool?,
      motherHivResult: freezed == motherHivResult
          ? _value.motherHivResult
          : motherHivResult // ignore: cast_nullable_to_non_nullable
              as String?,
      motherOnHaart: freezed == motherOnHaart
          ? _value.motherOnHaart
          : motherOnHaart // ignore: cast_nullable_to_non_nullable
              as bool?,
      haartRegimen: freezed == haartRegimen
          ? _value.haartRegimen
          : haartRegimen // ignore: cast_nullable_to_non_nullable
              as String?,
      fpCounselingDone: freezed == fpCounselingDone
          ? _value.fpCounselingDone
          : fpCounselingDone // ignore: cast_nullable_to_non_nullable
              as bool?,
      fpMethodChosen: freezed == fpMethodChosen
          ? _value.fpMethodChosen
          : fpMethodChosen // ignore: cast_nullable_to_non_nullable
              as String?,
      fpMethodProvided: freezed == fpMethodProvided
          ? _value.fpMethodProvided
          : fpMethodProvided // ignore: cast_nullable_to_non_nullable
              as bool?,
      maternalMentalHealthScreened: freezed == maternalMentalHealthScreened
          ? _value.maternalMentalHealthScreened
          : maternalMentalHealthScreened // ignore: cast_nullable_to_non_nullable
              as bool?,
      mentalHealthStatus: freezed == mentalHealthStatus
          ? _value.mentalHealthStatus
          : mentalHealthStatus // ignore: cast_nullable_to_non_nullable
              as String?,
      babyGeneralCondition: freezed == babyGeneralCondition
          ? _value.babyGeneralCondition
          : babyGeneralCondition // ignore: cast_nullable_to_non_nullable
              as String?,
      babyTemperature: freezed == babyTemperature
          ? _value.babyTemperature
          : babyTemperature // ignore: cast_nullable_to_non_nullable
              as double?,
      babyBreathsPerMinute: freezed == babyBreathsPerMinute
          ? _value.babyBreathsPerMinute
          : babyBreathsPerMinute // ignore: cast_nullable_to_non_nullable
              as int?,
      exclusiveBreastfeeding: freezed == exclusiveBreastfeeding
          ? _value.exclusiveBreastfeeding
          : exclusiveBreastfeeding // ignore: cast_nullable_to_non_nullable
              as bool?,
      breastfeedingPositioning: freezed == breastfeedingPositioning
          ? _value.breastfeedingPositioning
          : breastfeedingPositioning // ignore: cast_nullable_to_non_nullable
              as String?,
      breastfeedingAttachment: freezed == breastfeedingAttachment
          ? _value.breastfeedingAttachment
          : breastfeedingAttachment // ignore: cast_nullable_to_non_nullable
              as String?,
      umbilicalCordStatus: freezed == umbilicalCordStatus
          ? _value.umbilicalCordStatus
          : umbilicalCordStatus // ignore: cast_nullable_to_non_nullable
              as String?,
      babyImmunizationStarted: freezed == babyImmunizationStarted
          ? _value.babyImmunizationStarted
          : babyImmunizationStarted // ignore: cast_nullable_to_non_nullable
              as bool?,
      babyHivExposed: freezed == babyHivExposed
          ? _value.babyHivExposed
          : babyHivExposed // ignore: cast_nullable_to_non_nullable
              as bool?,
      babyOnArvProphylaxis: freezed == babyOnArvProphylaxis
          ? _value.babyOnArvProphylaxis
          : babyOnArvProphylaxis // ignore: cast_nullable_to_non_nullable
              as bool?,
      babyOnCtxProphylaxis: freezed == babyOnCtxProphylaxis
          ? _value.babyOnCtxProphylaxis
          : babyOnCtxProphylaxis // ignore: cast_nullable_to_non_nullable
              as bool?,
      babyIrritable: freezed == babyIrritable
          ? _value.babyIrritable
          : babyIrritable // ignore: cast_nullable_to_non_nullable
              as bool?,
      otherBabyProblems: freezed == otherBabyProblems
          ? _value.otherBabyProblems
          : otherBabyProblems // ignore: cast_nullable_to_non_nullable
              as String?,
      motherNotes: freezed == motherNotes
          ? _value.motherNotes
          : motherNotes // ignore: cast_nullable_to_non_nullable
              as String?,
      babyNotes: freezed == babyNotes
          ? _value.babyNotes
          : babyNotes // ignore: cast_nullable_to_non_nullable
              as String?,
      diagnosis: freezed == diagnosis
          ? _value.diagnosis
          : diagnosis // ignore: cast_nullable_to_non_nullable
              as String?,
      treatment: freezed == treatment
          ? _value.treatment
          : treatment // ignore: cast_nullable_to_non_nullable
              as String?,
      nextVisitDate: freezed == nextVisitDate
          ? _value.nextVisitDate
          : nextVisitDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      healthWorkerName: freezed == healthWorkerName
          ? _value.healthWorkerName
          : healthWorkerName // ignore: cast_nullable_to_non_nullable
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
      {String id,
      String maternalProfileId,
      String? childId,
      int contactNumber,
      DateTime visitDate,
      String? timingLabel,
      String? bloodPressure,
      double? temperature,
      int? pulseRate,
      int? respiratoryRate,
      String? generalCondition,
      String? breastCondition,
      bool? breastEngorgement,
      bool? crackedNipples,
      bool? mastitis,
      String? csScarCondition,
      String? uterusInvolution,
      String? pelvicExam,
      String? episiotomyCondition,
      String? lochiaSmell,
      String? lochiaAmount,
      String? lochiaColor,
      double? haemoglobin,
      bool? motherHivTested,
      String? motherHivResult,
      bool? motherOnHaart,
      String? haartRegimen,
      bool? fpCounselingDone,
      String? fpMethodChosen,
      bool? fpMethodProvided,
      bool? maternalMentalHealthScreened,
      String? mentalHealthStatus,
      String? babyGeneralCondition,
      double? babyTemperature,
      int? babyBreathsPerMinute,
      bool? exclusiveBreastfeeding,
      String? breastfeedingPositioning,
      String? breastfeedingAttachment,
      String? umbilicalCordStatus,
      bool? babyImmunizationStarted,
      bool? babyHivExposed,
      bool? babyOnArvProphylaxis,
      bool? babyOnCtxProphylaxis,
      bool? babyIrritable,
      String? otherBabyProblems,
      String? motherNotes,
      String? babyNotes,
      String? diagnosis,
      String? treatment,
      DateTime? nextVisitDate,
      String? healthWorkerName,
      DateTime? createdAt,
      DateTime? updatedAt});
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
    Object? id = null,
    Object? maternalProfileId = null,
    Object? childId = freezed,
    Object? contactNumber = null,
    Object? visitDate = null,
    Object? timingLabel = freezed,
    Object? bloodPressure = freezed,
    Object? temperature = freezed,
    Object? pulseRate = freezed,
    Object? respiratoryRate = freezed,
    Object? generalCondition = freezed,
    Object? breastCondition = freezed,
    Object? breastEngorgement = freezed,
    Object? crackedNipples = freezed,
    Object? mastitis = freezed,
    Object? csScarCondition = freezed,
    Object? uterusInvolution = freezed,
    Object? pelvicExam = freezed,
    Object? episiotomyCondition = freezed,
    Object? lochiaSmell = freezed,
    Object? lochiaAmount = freezed,
    Object? lochiaColor = freezed,
    Object? haemoglobin = freezed,
    Object? motherHivTested = freezed,
    Object? motherHivResult = freezed,
    Object? motherOnHaart = freezed,
    Object? haartRegimen = freezed,
    Object? fpCounselingDone = freezed,
    Object? fpMethodChosen = freezed,
    Object? fpMethodProvided = freezed,
    Object? maternalMentalHealthScreened = freezed,
    Object? mentalHealthStatus = freezed,
    Object? babyGeneralCondition = freezed,
    Object? babyTemperature = freezed,
    Object? babyBreathsPerMinute = freezed,
    Object? exclusiveBreastfeeding = freezed,
    Object? breastfeedingPositioning = freezed,
    Object? breastfeedingAttachment = freezed,
    Object? umbilicalCordStatus = freezed,
    Object? babyImmunizationStarted = freezed,
    Object? babyHivExposed = freezed,
    Object? babyOnArvProphylaxis = freezed,
    Object? babyOnCtxProphylaxis = freezed,
    Object? babyIrritable = freezed,
    Object? otherBabyProblems = freezed,
    Object? motherNotes = freezed,
    Object? babyNotes = freezed,
    Object? diagnosis = freezed,
    Object? treatment = freezed,
    Object? nextVisitDate = freezed,
    Object? healthWorkerName = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(_$PostnatalVisitImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      maternalProfileId: null == maternalProfileId
          ? _value.maternalProfileId
          : maternalProfileId // ignore: cast_nullable_to_non_nullable
              as String,
      childId: freezed == childId
          ? _value.childId
          : childId // ignore: cast_nullable_to_non_nullable
              as String?,
      contactNumber: null == contactNumber
          ? _value.contactNumber
          : contactNumber // ignore: cast_nullable_to_non_nullable
              as int,
      visitDate: null == visitDate
          ? _value.visitDate
          : visitDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      timingLabel: freezed == timingLabel
          ? _value.timingLabel
          : timingLabel // ignore: cast_nullable_to_non_nullable
              as String?,
      bloodPressure: freezed == bloodPressure
          ? _value.bloodPressure
          : bloodPressure // ignore: cast_nullable_to_non_nullable
              as String?,
      temperature: freezed == temperature
          ? _value.temperature
          : temperature // ignore: cast_nullable_to_non_nullable
              as double?,
      pulseRate: freezed == pulseRate
          ? _value.pulseRate
          : pulseRate // ignore: cast_nullable_to_non_nullable
              as int?,
      respiratoryRate: freezed == respiratoryRate
          ? _value.respiratoryRate
          : respiratoryRate // ignore: cast_nullable_to_non_nullable
              as int?,
      generalCondition: freezed == generalCondition
          ? _value.generalCondition
          : generalCondition // ignore: cast_nullable_to_non_nullable
              as String?,
      breastCondition: freezed == breastCondition
          ? _value.breastCondition
          : breastCondition // ignore: cast_nullable_to_non_nullable
              as String?,
      breastEngorgement: freezed == breastEngorgement
          ? _value.breastEngorgement
          : breastEngorgement // ignore: cast_nullable_to_non_nullable
              as bool?,
      crackedNipples: freezed == crackedNipples
          ? _value.crackedNipples
          : crackedNipples // ignore: cast_nullable_to_non_nullable
              as bool?,
      mastitis: freezed == mastitis
          ? _value.mastitis
          : mastitis // ignore: cast_nullable_to_non_nullable
              as bool?,
      csScarCondition: freezed == csScarCondition
          ? _value.csScarCondition
          : csScarCondition // ignore: cast_nullable_to_non_nullable
              as String?,
      uterusInvolution: freezed == uterusInvolution
          ? _value.uterusInvolution
          : uterusInvolution // ignore: cast_nullable_to_non_nullable
              as String?,
      pelvicExam: freezed == pelvicExam
          ? _value.pelvicExam
          : pelvicExam // ignore: cast_nullable_to_non_nullable
              as String?,
      episiotomyCondition: freezed == episiotomyCondition
          ? _value.episiotomyCondition
          : episiotomyCondition // ignore: cast_nullable_to_non_nullable
              as String?,
      lochiaSmell: freezed == lochiaSmell
          ? _value.lochiaSmell
          : lochiaSmell // ignore: cast_nullable_to_non_nullable
              as String?,
      lochiaAmount: freezed == lochiaAmount
          ? _value.lochiaAmount
          : lochiaAmount // ignore: cast_nullable_to_non_nullable
              as String?,
      lochiaColor: freezed == lochiaColor
          ? _value.lochiaColor
          : lochiaColor // ignore: cast_nullable_to_non_nullable
              as String?,
      haemoglobin: freezed == haemoglobin
          ? _value.haemoglobin
          : haemoglobin // ignore: cast_nullable_to_non_nullable
              as double?,
      motherHivTested: freezed == motherHivTested
          ? _value.motherHivTested
          : motherHivTested // ignore: cast_nullable_to_non_nullable
              as bool?,
      motherHivResult: freezed == motherHivResult
          ? _value.motherHivResult
          : motherHivResult // ignore: cast_nullable_to_non_nullable
              as String?,
      motherOnHaart: freezed == motherOnHaart
          ? _value.motherOnHaart
          : motherOnHaart // ignore: cast_nullable_to_non_nullable
              as bool?,
      haartRegimen: freezed == haartRegimen
          ? _value.haartRegimen
          : haartRegimen // ignore: cast_nullable_to_non_nullable
              as String?,
      fpCounselingDone: freezed == fpCounselingDone
          ? _value.fpCounselingDone
          : fpCounselingDone // ignore: cast_nullable_to_non_nullable
              as bool?,
      fpMethodChosen: freezed == fpMethodChosen
          ? _value.fpMethodChosen
          : fpMethodChosen // ignore: cast_nullable_to_non_nullable
              as String?,
      fpMethodProvided: freezed == fpMethodProvided
          ? _value.fpMethodProvided
          : fpMethodProvided // ignore: cast_nullable_to_non_nullable
              as bool?,
      maternalMentalHealthScreened: freezed == maternalMentalHealthScreened
          ? _value.maternalMentalHealthScreened
          : maternalMentalHealthScreened // ignore: cast_nullable_to_non_nullable
              as bool?,
      mentalHealthStatus: freezed == mentalHealthStatus
          ? _value.mentalHealthStatus
          : mentalHealthStatus // ignore: cast_nullable_to_non_nullable
              as String?,
      babyGeneralCondition: freezed == babyGeneralCondition
          ? _value.babyGeneralCondition
          : babyGeneralCondition // ignore: cast_nullable_to_non_nullable
              as String?,
      babyTemperature: freezed == babyTemperature
          ? _value.babyTemperature
          : babyTemperature // ignore: cast_nullable_to_non_nullable
              as double?,
      babyBreathsPerMinute: freezed == babyBreathsPerMinute
          ? _value.babyBreathsPerMinute
          : babyBreathsPerMinute // ignore: cast_nullable_to_non_nullable
              as int?,
      exclusiveBreastfeeding: freezed == exclusiveBreastfeeding
          ? _value.exclusiveBreastfeeding
          : exclusiveBreastfeeding // ignore: cast_nullable_to_non_nullable
              as bool?,
      breastfeedingPositioning: freezed == breastfeedingPositioning
          ? _value.breastfeedingPositioning
          : breastfeedingPositioning // ignore: cast_nullable_to_non_nullable
              as String?,
      breastfeedingAttachment: freezed == breastfeedingAttachment
          ? _value.breastfeedingAttachment
          : breastfeedingAttachment // ignore: cast_nullable_to_non_nullable
              as String?,
      umbilicalCordStatus: freezed == umbilicalCordStatus
          ? _value.umbilicalCordStatus
          : umbilicalCordStatus // ignore: cast_nullable_to_non_nullable
              as String?,
      babyImmunizationStarted: freezed == babyImmunizationStarted
          ? _value.babyImmunizationStarted
          : babyImmunizationStarted // ignore: cast_nullable_to_non_nullable
              as bool?,
      babyHivExposed: freezed == babyHivExposed
          ? _value.babyHivExposed
          : babyHivExposed // ignore: cast_nullable_to_non_nullable
              as bool?,
      babyOnArvProphylaxis: freezed == babyOnArvProphylaxis
          ? _value.babyOnArvProphylaxis
          : babyOnArvProphylaxis // ignore: cast_nullable_to_non_nullable
              as bool?,
      babyOnCtxProphylaxis: freezed == babyOnCtxProphylaxis
          ? _value.babyOnCtxProphylaxis
          : babyOnCtxProphylaxis // ignore: cast_nullable_to_non_nullable
              as bool?,
      babyIrritable: freezed == babyIrritable
          ? _value.babyIrritable
          : babyIrritable // ignore: cast_nullable_to_non_nullable
              as bool?,
      otherBabyProblems: freezed == otherBabyProblems
          ? _value.otherBabyProblems
          : otherBabyProblems // ignore: cast_nullable_to_non_nullable
              as String?,
      motherNotes: freezed == motherNotes
          ? _value.motherNotes
          : motherNotes // ignore: cast_nullable_to_non_nullable
              as String?,
      babyNotes: freezed == babyNotes
          ? _value.babyNotes
          : babyNotes // ignore: cast_nullable_to_non_nullable
              as String?,
      diagnosis: freezed == diagnosis
          ? _value.diagnosis
          : diagnosis // ignore: cast_nullable_to_non_nullable
              as String?,
      treatment: freezed == treatment
          ? _value.treatment
          : treatment // ignore: cast_nullable_to_non_nullable
              as String?,
      nextVisitDate: freezed == nextVisitDate
          ? _value.nextVisitDate
          : nextVisitDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      healthWorkerName: freezed == healthWorkerName
          ? _value.healthWorkerName
          : healthWorkerName // ignore: cast_nullable_to_non_nullable
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
      {required this.id,
      required this.maternalProfileId,
      this.childId,
      required this.contactNumber,
      required this.visitDate,
      this.timingLabel,
      this.bloodPressure,
      this.temperature,
      this.pulseRate,
      this.respiratoryRate,
      this.generalCondition,
      this.breastCondition,
      this.breastEngorgement,
      this.crackedNipples,
      this.mastitis,
      this.csScarCondition,
      this.uterusInvolution,
      this.pelvicExam,
      this.episiotomyCondition,
      this.lochiaSmell,
      this.lochiaAmount,
      this.lochiaColor,
      this.haemoglobin,
      this.motherHivTested,
      this.motherHivResult,
      this.motherOnHaart,
      this.haartRegimen,
      this.fpCounselingDone,
      this.fpMethodChosen,
      this.fpMethodProvided,
      this.maternalMentalHealthScreened,
      this.mentalHealthStatus,
      this.babyGeneralCondition,
      this.babyTemperature,
      this.babyBreathsPerMinute,
      this.exclusiveBreastfeeding,
      this.breastfeedingPositioning,
      this.breastfeedingAttachment,
      this.umbilicalCordStatus,
      this.babyImmunizationStarted,
      this.babyHivExposed,
      this.babyOnArvProphylaxis,
      this.babyOnCtxProphylaxis,
      this.babyIrritable,
      this.otherBabyProblems,
      this.motherNotes,
      this.babyNotes,
      this.diagnosis,
      this.treatment,
      this.nextVisitDate,
      this.healthWorkerName,
      this.createdAt,
      this.updatedAt});

  factory _$PostnatalVisitImpl.fromJson(Map<String, dynamic> json) =>
      _$$PostnatalVisitImplFromJson(json);

  @override
  final String id;
  @override
  final String maternalProfileId;
  @override
  final String? childId;
// Link to child if already registered
  @override
  final int contactNumber;
// 1-4
  @override
  final DateTime visitDate;
// Timing
  @override
  final String? timingLabel;
// "Within 48hrs", "1-2 weeks", "4-6 weeks", "4-6 months"
// MOTHER Assessment
  @override
  final String? bloodPressure;
  @override
  final double? temperature;
  @override
  final int? pulseRate;
  @override
  final int? respiratoryRate;
  @override
  final String? generalCondition;
// Breast Examination
  @override
  final String? breastCondition;
  @override
  final bool? breastEngorgement;
  @override
  final bool? crackedNipples;
  @override
  final bool? mastitis;
// C-Section Scar (if applicable)
  @override
  final String? csScarCondition;
// Uterus Involution
  @override
  final String? uterusInvolution;
// Well involuted, Not well involuted
// Pelvic Examination
  @override
  final String? pelvicExam;
  @override
  final String? episiotomyCondition;
// Lochia (discharge)
  @override
  final String? lochiaSmell;
  @override
  final String? lochiaAmount;
  @override
  final String? lochiaColor;
// Lab Tests
  @override
  final double? haemoglobin;
// HIV Status
  @override
  final bool? motherHivTested;
  @override
  final String? motherHivResult;
  @override
  final bool? motherOnHaart;
  @override
  final String? haartRegimen;
// Family Planning
  @override
  final bool? fpCounselingDone;
  @override
  final String? fpMethodChosen;
  @override
  final bool? fpMethodProvided;
// Maternal Mental Health
  @override
  final bool? maternalMentalHealthScreened;
  @override
  final String? mentalHealthStatus;
// BABY Assessment (if present)
  @override
  final String? babyGeneralCondition;
  @override
  final double? babyTemperature;
  @override
  final int? babyBreathsPerMinute;
// Feeding
  @override
  final bool? exclusiveBreastfeeding;
  @override
  final String? breastfeedingPositioning;
// Correct, Not correct
  @override
  final String? breastfeedingAttachment;
// Good, Poor
// Umbilical Cord
  @override
  final String? umbilicalCordStatus;
// Clean, Dry, Bleeding, Infected
// Baby Immunization
  @override
  final bool? babyImmunizationStarted;
// HEI (HIV Exposed Infant)
  @override
  final bool? babyHivExposed;
  @override
  final bool? babyOnArvProphylaxis;
  @override
  final bool? babyOnCtxProphylaxis;
// Other Baby Issues
  @override
  final bool? babyIrritable;
  @override
  final String? otherBabyProblems;
// Clinical Notes
  @override
  final String? motherNotes;
  @override
  final String? babyNotes;
  @override
  final String? diagnosis;
  @override
  final String? treatment;
// Next Visit
  @override
  final DateTime? nextVisitDate;
  @override
  final String? healthWorkerName;
  @override
  final DateTime? createdAt;
  @override
  final DateTime? updatedAt;

  @override
  String toString() {
    return 'PostnatalVisit(id: $id, maternalProfileId: $maternalProfileId, childId: $childId, contactNumber: $contactNumber, visitDate: $visitDate, timingLabel: $timingLabel, bloodPressure: $bloodPressure, temperature: $temperature, pulseRate: $pulseRate, respiratoryRate: $respiratoryRate, generalCondition: $generalCondition, breastCondition: $breastCondition, breastEngorgement: $breastEngorgement, crackedNipples: $crackedNipples, mastitis: $mastitis, csScarCondition: $csScarCondition, uterusInvolution: $uterusInvolution, pelvicExam: $pelvicExam, episiotomyCondition: $episiotomyCondition, lochiaSmell: $lochiaSmell, lochiaAmount: $lochiaAmount, lochiaColor: $lochiaColor, haemoglobin: $haemoglobin, motherHivTested: $motherHivTested, motherHivResult: $motherHivResult, motherOnHaart: $motherOnHaart, haartRegimen: $haartRegimen, fpCounselingDone: $fpCounselingDone, fpMethodChosen: $fpMethodChosen, fpMethodProvided: $fpMethodProvided, maternalMentalHealthScreened: $maternalMentalHealthScreened, mentalHealthStatus: $mentalHealthStatus, babyGeneralCondition: $babyGeneralCondition, babyTemperature: $babyTemperature, babyBreathsPerMinute: $babyBreathsPerMinute, exclusiveBreastfeeding: $exclusiveBreastfeeding, breastfeedingPositioning: $breastfeedingPositioning, breastfeedingAttachment: $breastfeedingAttachment, umbilicalCordStatus: $umbilicalCordStatus, babyImmunizationStarted: $babyImmunizationStarted, babyHivExposed: $babyHivExposed, babyOnArvProphylaxis: $babyOnArvProphylaxis, babyOnCtxProphylaxis: $babyOnCtxProphylaxis, babyIrritable: $babyIrritable, otherBabyProblems: $otherBabyProblems, motherNotes: $motherNotes, babyNotes: $babyNotes, diagnosis: $diagnosis, treatment: $treatment, nextVisitDate: $nextVisitDate, healthWorkerName: $healthWorkerName, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PostnatalVisitImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.maternalProfileId, maternalProfileId) ||
                other.maternalProfileId == maternalProfileId) &&
            (identical(other.childId, childId) || other.childId == childId) &&
            (identical(other.contactNumber, contactNumber) ||
                other.contactNumber == contactNumber) &&
            (identical(other.visitDate, visitDate) ||
                other.visitDate == visitDate) &&
            (identical(other.timingLabel, timingLabel) ||
                other.timingLabel == timingLabel) &&
            (identical(other.bloodPressure, bloodPressure) ||
                other.bloodPressure == bloodPressure) &&
            (identical(other.temperature, temperature) ||
                other.temperature == temperature) &&
            (identical(other.pulseRate, pulseRate) ||
                other.pulseRate == pulseRate) &&
            (identical(other.respiratoryRate, respiratoryRate) ||
                other.respiratoryRate == respiratoryRate) &&
            (identical(other.generalCondition, generalCondition) ||
                other.generalCondition == generalCondition) &&
            (identical(other.breastCondition, breastCondition) ||
                other.breastCondition == breastCondition) &&
            (identical(other.breastEngorgement, breastEngorgement) ||
                other.breastEngorgement == breastEngorgement) &&
            (identical(other.crackedNipples, crackedNipples) ||
                other.crackedNipples == crackedNipples) &&
            (identical(other.mastitis, mastitis) ||
                other.mastitis == mastitis) &&
            (identical(other.csScarCondition, csScarCondition) ||
                other.csScarCondition == csScarCondition) &&
            (identical(other.uterusInvolution, uterusInvolution) ||
                other.uterusInvolution == uterusInvolution) &&
            (identical(other.pelvicExam, pelvicExam) ||
                other.pelvicExam == pelvicExam) &&
            (identical(other.episiotomyCondition, episiotomyCondition) ||
                other.episiotomyCondition == episiotomyCondition) &&
            (identical(other.lochiaSmell, lochiaSmell) ||
                other.lochiaSmell == lochiaSmell) &&
            (identical(other.lochiaAmount, lochiaAmount) ||
                other.lochiaAmount == lochiaAmount) &&
            (identical(other.lochiaColor, lochiaColor) ||
                other.lochiaColor == lochiaColor) &&
            (identical(other.haemoglobin, haemoglobin) ||
                other.haemoglobin == haemoglobin) &&
            (identical(other.motherHivTested, motherHivTested) ||
                other.motherHivTested == motherHivTested) &&
            (identical(other.motherHivResult, motherHivResult) ||
                other.motherHivResult == motherHivResult) &&
            (identical(other.motherOnHaart, motherOnHaart) ||
                other.motherOnHaart == motherOnHaart) &&
            (identical(other.haartRegimen, haartRegimen) ||
                other.haartRegimen == haartRegimen) &&
            (identical(other.fpCounselingDone, fpCounselingDone) ||
                other.fpCounselingDone == fpCounselingDone) &&
            (identical(other.fpMethodChosen, fpMethodChosen) ||
                other.fpMethodChosen == fpMethodChosen) &&
            (identical(other.fpMethodProvided, fpMethodProvided) ||
                other.fpMethodProvided == fpMethodProvided) &&
            (identical(other.maternalMentalHealthScreened, maternalMentalHealthScreened) ||
                other.maternalMentalHealthScreened ==
                    maternalMentalHealthScreened) &&
            (identical(other.mentalHealthStatus, mentalHealthStatus) ||
                other.mentalHealthStatus == mentalHealthStatus) &&
            (identical(other.babyGeneralCondition, babyGeneralCondition) ||
                other.babyGeneralCondition == babyGeneralCondition) &&
            (identical(other.babyTemperature, babyTemperature) ||
                other.babyTemperature == babyTemperature) &&
            (identical(other.babyBreathsPerMinute, babyBreathsPerMinute) ||
                other.babyBreathsPerMinute == babyBreathsPerMinute) &&
            (identical(other.exclusiveBreastfeeding, exclusiveBreastfeeding) ||
                other.exclusiveBreastfeeding == exclusiveBreastfeeding) &&
            (identical(other.breastfeedingPositioning, breastfeedingPositioning) ||
                other.breastfeedingPositioning == breastfeedingPositioning) &&
            (identical(other.breastfeedingAttachment, breastfeedingAttachment) ||
                other.breastfeedingAttachment == breastfeedingAttachment) &&
            (identical(other.umbilicalCordStatus, umbilicalCordStatus) ||
                other.umbilicalCordStatus == umbilicalCordStatus) &&
            (identical(other.babyImmunizationStarted, babyImmunizationStarted) ||
                other.babyImmunizationStarted == babyImmunizationStarted) &&
            (identical(other.babyHivExposed, babyHivExposed) ||
                other.babyHivExposed == babyHivExposed) &&
            (identical(other.babyOnArvProphylaxis, babyOnArvProphylaxis) ||
                other.babyOnArvProphylaxis == babyOnArvProphylaxis) &&
            (identical(other.babyOnCtxProphylaxis, babyOnCtxProphylaxis) ||
                other.babyOnCtxProphylaxis == babyOnCtxProphylaxis) &&
            (identical(other.babyIrritable, babyIrritable) || other.babyIrritable == babyIrritable) &&
            (identical(other.otherBabyProblems, otherBabyProblems) || other.otherBabyProblems == otherBabyProblems) &&
            (identical(other.motherNotes, motherNotes) || other.motherNotes == motherNotes) &&
            (identical(other.babyNotes, babyNotes) || other.babyNotes == babyNotes) &&
            (identical(other.diagnosis, diagnosis) || other.diagnosis == diagnosis) &&
            (identical(other.treatment, treatment) || other.treatment == treatment) &&
            (identical(other.nextVisitDate, nextVisitDate) || other.nextVisitDate == nextVisitDate) &&
            (identical(other.healthWorkerName, healthWorkerName) || other.healthWorkerName == healthWorkerName) &&
            (identical(other.createdAt, createdAt) || other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hashAll([
        runtimeType,
        id,
        maternalProfileId,
        childId,
        contactNumber,
        visitDate,
        timingLabel,
        bloodPressure,
        temperature,
        pulseRate,
        respiratoryRate,
        generalCondition,
        breastCondition,
        breastEngorgement,
        crackedNipples,
        mastitis,
        csScarCondition,
        uterusInvolution,
        pelvicExam,
        episiotomyCondition,
        lochiaSmell,
        lochiaAmount,
        lochiaColor,
        haemoglobin,
        motherHivTested,
        motherHivResult,
        motherOnHaart,
        haartRegimen,
        fpCounselingDone,
        fpMethodChosen,
        fpMethodProvided,
        maternalMentalHealthScreened,
        mentalHealthStatus,
        babyGeneralCondition,
        babyTemperature,
        babyBreathsPerMinute,
        exclusiveBreastfeeding,
        breastfeedingPositioning,
        breastfeedingAttachment,
        umbilicalCordStatus,
        babyImmunizationStarted,
        babyHivExposed,
        babyOnArvProphylaxis,
        babyOnCtxProphylaxis,
        babyIrritable,
        otherBabyProblems,
        motherNotes,
        babyNotes,
        diagnosis,
        treatment,
        nextVisitDate,
        healthWorkerName,
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
      {required final String id,
      required final String maternalProfileId,
      final String? childId,
      required final int contactNumber,
      required final DateTime visitDate,
      final String? timingLabel,
      final String? bloodPressure,
      final double? temperature,
      final int? pulseRate,
      final int? respiratoryRate,
      final String? generalCondition,
      final String? breastCondition,
      final bool? breastEngorgement,
      final bool? crackedNipples,
      final bool? mastitis,
      final String? csScarCondition,
      final String? uterusInvolution,
      final String? pelvicExam,
      final String? episiotomyCondition,
      final String? lochiaSmell,
      final String? lochiaAmount,
      final String? lochiaColor,
      final double? haemoglobin,
      final bool? motherHivTested,
      final String? motherHivResult,
      final bool? motherOnHaart,
      final String? haartRegimen,
      final bool? fpCounselingDone,
      final String? fpMethodChosen,
      final bool? fpMethodProvided,
      final bool? maternalMentalHealthScreened,
      final String? mentalHealthStatus,
      final String? babyGeneralCondition,
      final double? babyTemperature,
      final int? babyBreathsPerMinute,
      final bool? exclusiveBreastfeeding,
      final String? breastfeedingPositioning,
      final String? breastfeedingAttachment,
      final String? umbilicalCordStatus,
      final bool? babyImmunizationStarted,
      final bool? babyHivExposed,
      final bool? babyOnArvProphylaxis,
      final bool? babyOnCtxProphylaxis,
      final bool? babyIrritable,
      final String? otherBabyProblems,
      final String? motherNotes,
      final String? babyNotes,
      final String? diagnosis,
      final String? treatment,
      final DateTime? nextVisitDate,
      final String? healthWorkerName,
      final DateTime? createdAt,
      final DateTime? updatedAt}) = _$PostnatalVisitImpl;

  factory _PostnatalVisit.fromJson(Map<String, dynamic> json) =
      _$PostnatalVisitImpl.fromJson;

  @override
  String get id;
  @override
  String get maternalProfileId;
  @override
  String? get childId; // Link to child if already registered
  @override
  int get contactNumber; // 1-4
  @override
  DateTime get visitDate; // Timing
  @override
  String?
      get timingLabel; // "Within 48hrs", "1-2 weeks", "4-6 weeks", "4-6 months"
// MOTHER Assessment
  @override
  String? get bloodPressure;
  @override
  double? get temperature;
  @override
  int? get pulseRate;
  @override
  int? get respiratoryRate;
  @override
  String? get generalCondition; // Breast Examination
  @override
  String? get breastCondition;
  @override
  bool? get breastEngorgement;
  @override
  bool? get crackedNipples;
  @override
  bool? get mastitis; // C-Section Scar (if applicable)
  @override
  String? get csScarCondition; // Uterus Involution
  @override
  String? get uterusInvolution; // Well involuted, Not well involuted
// Pelvic Examination
  @override
  String? get pelvicExam;
  @override
  String? get episiotomyCondition; // Lochia (discharge)
  @override
  String? get lochiaSmell;
  @override
  String? get lochiaAmount;
  @override
  String? get lochiaColor; // Lab Tests
  @override
  double? get haemoglobin; // HIV Status
  @override
  bool? get motherHivTested;
  @override
  String? get motherHivResult;
  @override
  bool? get motherOnHaart;
  @override
  String? get haartRegimen; // Family Planning
  @override
  bool? get fpCounselingDone;
  @override
  String? get fpMethodChosen;
  @override
  bool? get fpMethodProvided; // Maternal Mental Health
  @override
  bool? get maternalMentalHealthScreened;
  @override
  String? get mentalHealthStatus; // BABY Assessment (if present)
  @override
  String? get babyGeneralCondition;
  @override
  double? get babyTemperature;
  @override
  int? get babyBreathsPerMinute; // Feeding
  @override
  bool? get exclusiveBreastfeeding;
  @override
  String? get breastfeedingPositioning; // Correct, Not correct
  @override
  String? get breastfeedingAttachment; // Good, Poor
// Umbilical Cord
  @override
  String? get umbilicalCordStatus; // Clean, Dry, Bleeding, Infected
// Baby Immunization
  @override
  bool? get babyImmunizationStarted; // HEI (HIV Exposed Infant)
  @override
  bool? get babyHivExposed;
  @override
  bool? get babyOnArvProphylaxis;
  @override
  bool? get babyOnCtxProphylaxis; // Other Baby Issues
  @override
  bool? get babyIrritable;
  @override
  String? get otherBabyProblems; // Clinical Notes
  @override
  String? get motherNotes;
  @override
  String? get babyNotes;
  @override
  String? get diagnosis;
  @override
  String? get treatment; // Next Visit
  @override
  DateTime? get nextVisitDate;
  @override
  String? get healthWorkerName;
  @override
  DateTime? get createdAt;
  @override
  DateTime? get updatedAt;

  /// Create a copy of PostnatalVisit
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PostnatalVisitImplCopyWith<_$PostnatalVisitImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
