// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'childbirth_record.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

ChildbirthRecord _$ChildbirthRecordFromJson(Map<String, dynamic> json) {
  return _ChildbirthRecord.fromJson(json);
}

/// @nodoc
mixin _$ChildbirthRecord {
  @JsonKey(name: 'id')
  String? get id => throw _privateConstructorUsedError; // ← Changed to nullable
  @JsonKey(name: 'maternal_profile_id')
  String get maternalProfileId => throw _privateConstructorUsedError;
  @JsonKey(name: 'delivery_date')
  DateTime get deliveryDate => throw _privateConstructorUsedError;
  @JsonKey(name: 'delivery_time')
  String get deliveryTime => throw _privateConstructorUsedError;
  @JsonKey(name: 'duration_of_pregnancy_weeks')
  int get durationOfPregnancyWeeks =>
      throw _privateConstructorUsedError; // Place & Attendant
  @JsonKey(name: 'place_of_delivery')
  String get placeOfDelivery => throw _privateConstructorUsedError;
  @JsonKey(name: 'health_facility_name')
  String? get healthFacilityName => throw _privateConstructorUsedError;
  @JsonKey(name: 'attendant')
  String? get attendant =>
      throw _privateConstructorUsedError; // Mode of Delivery
  @JsonKey(name: 'mode_of_delivery')
  String get modeOfDelivery =>
      throw _privateConstructorUsedError; // Mother's Condition
  @JsonKey(name: 'skin_to_skin_immediate')
  bool? get skinToSkinImmediate => throw _privateConstructorUsedError;
  @JsonKey(name: 'apgar_score_1_min')
  String? get apgarScore1Min => throw _privateConstructorUsedError;
  @JsonKey(name: 'apgar_score_5_min')
  String? get apgarScore5Min => throw _privateConstructorUsedError;
  @JsonKey(name: 'apgar_score_10_min')
  String? get apgarScore10Min => throw _privateConstructorUsedError;
  @JsonKey(name: 'resuscitation_done')
  bool? get resuscitationDone => throw _privateConstructorUsedError;
  @JsonKey(name: 'blood_loss_ml')
  double? get bloodLossMl =>
      throw _privateConstructorUsedError; // Complications
  @JsonKey(name: 'pre_eclampsia')
  bool? get preEclampsia => throw _privateConstructorUsedError;
  @JsonKey(name: 'eclampsia')
  bool? get eclampsia => throw _privateConstructorUsedError;
  @JsonKey(name: 'pph')
  bool? get pph => throw _privateConstructorUsedError;
  @JsonKey(name: 'obstructed_labour')
  bool? get obstructedLabour => throw _privateConstructorUsedError;
  @JsonKey(name: 'meconium_grade')
  String? get meconiumGrade =>
      throw _privateConstructorUsedError; // Mother's Condition Post-delivery
  @JsonKey(name: 'mother_condition')
  String? get motherCondition =>
      throw _privateConstructorUsedError; // Drugs Administered to Mother
  @JsonKey(name: 'oxytocin_given')
  bool? get oxytocinGiven => throw _privateConstructorUsedError;
  @JsonKey(name: 'misoprostol_given')
  bool? get misoprostolGiven => throw _privateConstructorUsedError;
  @JsonKey(name: 'heat_stable_carbetocin')
  bool? get heatStableCarbetocin => throw _privateConstructorUsedError;
  @JsonKey(name: 'haart_given')
  bool? get haartGiven => throw _privateConstructorUsedError;
  @JsonKey(name: 'haart_regimen')
  String? get haartRegimen => throw _privateConstructorUsedError;
  @JsonKey(name: 'other_drugs')
  String? get otherDrugs => throw _privateConstructorUsedError; // Baby Details
  @JsonKey(name: 'birth_weight_grams')
  double get birthWeightGrams => throw _privateConstructorUsedError;
  @JsonKey(name: 'birth_length_cm')
  double get birthLengthCm => throw _privateConstructorUsedError;
  @JsonKey(name: 'head_circumference_cm')
  double? get headCircumferenceCm => throw _privateConstructorUsedError;
  @JsonKey(name: 'baby_condition')
  String? get babyCondition =>
      throw _privateConstructorUsedError; // Drugs Given to Baby
  @JsonKey(name: 'chx_given')
  bool? get chxGiven => throw _privateConstructorUsedError;
  @JsonKey(name: 'vitamin_k_given')
  bool? get vitaminKGiven => throw _privateConstructorUsedError;
  @JsonKey(name: 'teo_given')
  bool? get teoGiven => throw _privateConstructorUsedError; // HIV Exposure
  @JsonKey(name: 'baby_hiv_exposed')
  bool? get babyHivExposed => throw _privateConstructorUsedError;
  @JsonKey(name: 'arv_prophylaxis_given')
  String? get arvProphylaxisGiven =>
      throw _privateConstructorUsedError; // Breastfeeding
  @JsonKey(name: 'early_initiation_breastfeeding')
  bool? get earlyInitiationBreastfeeding =>
      throw _privateConstructorUsedError; // Clinical Notes
  @JsonKey(name: 'notes')
  String? get notes => throw _privateConstructorUsedError;
  @JsonKey(name: 'conducted_by')
  String? get conductedBy => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_at')
  DateTime? get createdAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'updated_at')
  DateTime? get updatedAt => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ChildbirthRecordCopyWith<ChildbirthRecord> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ChildbirthRecordCopyWith<$Res> {
  factory $ChildbirthRecordCopyWith(
          ChildbirthRecord value, $Res Function(ChildbirthRecord) then) =
      _$ChildbirthRecordCopyWithImpl<$Res, ChildbirthRecord>;
  @useResult
  $Res call(
      {@JsonKey(name: 'id') String? id,
      @JsonKey(name: 'maternal_profile_id') String maternalProfileId,
      @JsonKey(name: 'delivery_date') DateTime deliveryDate,
      @JsonKey(name: 'delivery_time') String deliveryTime,
      @JsonKey(name: 'duration_of_pregnancy_weeks')
      int durationOfPregnancyWeeks,
      @JsonKey(name: 'place_of_delivery') String placeOfDelivery,
      @JsonKey(name: 'health_facility_name') String? healthFacilityName,
      @JsonKey(name: 'attendant') String? attendant,
      @JsonKey(name: 'mode_of_delivery') String modeOfDelivery,
      @JsonKey(name: 'skin_to_skin_immediate') bool? skinToSkinImmediate,
      @JsonKey(name: 'apgar_score_1_min') String? apgarScore1Min,
      @JsonKey(name: 'apgar_score_5_min') String? apgarScore5Min,
      @JsonKey(name: 'apgar_score_10_min') String? apgarScore10Min,
      @JsonKey(name: 'resuscitation_done') bool? resuscitationDone,
      @JsonKey(name: 'blood_loss_ml') double? bloodLossMl,
      @JsonKey(name: 'pre_eclampsia') bool? preEclampsia,
      @JsonKey(name: 'eclampsia') bool? eclampsia,
      @JsonKey(name: 'pph') bool? pph,
      @JsonKey(name: 'obstructed_labour') bool? obstructedLabour,
      @JsonKey(name: 'meconium_grade') String? meconiumGrade,
      @JsonKey(name: 'mother_condition') String? motherCondition,
      @JsonKey(name: 'oxytocin_given') bool? oxytocinGiven,
      @JsonKey(name: 'misoprostol_given') bool? misoprostolGiven,
      @JsonKey(name: 'heat_stable_carbetocin') bool? heatStableCarbetocin,
      @JsonKey(name: 'haart_given') bool? haartGiven,
      @JsonKey(name: 'haart_regimen') String? haartRegimen,
      @JsonKey(name: 'other_drugs') String? otherDrugs,
      @JsonKey(name: 'birth_weight_grams') double birthWeightGrams,
      @JsonKey(name: 'birth_length_cm') double birthLengthCm,
      @JsonKey(name: 'head_circumference_cm') double? headCircumferenceCm,
      @JsonKey(name: 'baby_condition') String? babyCondition,
      @JsonKey(name: 'chx_given') bool? chxGiven,
      @JsonKey(name: 'vitamin_k_given') bool? vitaminKGiven,
      @JsonKey(name: 'teo_given') bool? teoGiven,
      @JsonKey(name: 'baby_hiv_exposed') bool? babyHivExposed,
      @JsonKey(name: 'arv_prophylaxis_given') String? arvProphylaxisGiven,
      @JsonKey(name: 'early_initiation_breastfeeding')
      bool? earlyInitiationBreastfeeding,
      @JsonKey(name: 'notes') String? notes,
      @JsonKey(name: 'conducted_by') String? conductedBy,
      @JsonKey(name: 'created_at') DateTime? createdAt,
      @JsonKey(name: 'updated_at') DateTime? updatedAt});
}

/// @nodoc
class _$ChildbirthRecordCopyWithImpl<$Res, $Val extends ChildbirthRecord>
    implements $ChildbirthRecordCopyWith<$Res> {
  _$ChildbirthRecordCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? maternalProfileId = null,
    Object? deliveryDate = null,
    Object? deliveryTime = null,
    Object? durationOfPregnancyWeeks = null,
    Object? placeOfDelivery = null,
    Object? healthFacilityName = freezed,
    Object? attendant = freezed,
    Object? modeOfDelivery = null,
    Object? skinToSkinImmediate = freezed,
    Object? apgarScore1Min = freezed,
    Object? apgarScore5Min = freezed,
    Object? apgarScore10Min = freezed,
    Object? resuscitationDone = freezed,
    Object? bloodLossMl = freezed,
    Object? preEclampsia = freezed,
    Object? eclampsia = freezed,
    Object? pph = freezed,
    Object? obstructedLabour = freezed,
    Object? meconiumGrade = freezed,
    Object? motherCondition = freezed,
    Object? oxytocinGiven = freezed,
    Object? misoprostolGiven = freezed,
    Object? heatStableCarbetocin = freezed,
    Object? haartGiven = freezed,
    Object? haartRegimen = freezed,
    Object? otherDrugs = freezed,
    Object? birthWeightGrams = null,
    Object? birthLengthCm = null,
    Object? headCircumferenceCm = freezed,
    Object? babyCondition = freezed,
    Object? chxGiven = freezed,
    Object? vitaminKGiven = freezed,
    Object? teoGiven = freezed,
    Object? babyHivExposed = freezed,
    Object? arvProphylaxisGiven = freezed,
    Object? earlyInitiationBreastfeeding = freezed,
    Object? notes = freezed,
    Object? conductedBy = freezed,
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
      deliveryDate: null == deliveryDate
          ? _value.deliveryDate
          : deliveryDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      deliveryTime: null == deliveryTime
          ? _value.deliveryTime
          : deliveryTime // ignore: cast_nullable_to_non_nullable
              as String,
      durationOfPregnancyWeeks: null == durationOfPregnancyWeeks
          ? _value.durationOfPregnancyWeeks
          : durationOfPregnancyWeeks // ignore: cast_nullable_to_non_nullable
              as int,
      placeOfDelivery: null == placeOfDelivery
          ? _value.placeOfDelivery
          : placeOfDelivery // ignore: cast_nullable_to_non_nullable
              as String,
      healthFacilityName: freezed == healthFacilityName
          ? _value.healthFacilityName
          : healthFacilityName // ignore: cast_nullable_to_non_nullable
              as String?,
      attendant: freezed == attendant
          ? _value.attendant
          : attendant // ignore: cast_nullable_to_non_nullable
              as String?,
      modeOfDelivery: null == modeOfDelivery
          ? _value.modeOfDelivery
          : modeOfDelivery // ignore: cast_nullable_to_non_nullable
              as String,
      skinToSkinImmediate: freezed == skinToSkinImmediate
          ? _value.skinToSkinImmediate
          : skinToSkinImmediate // ignore: cast_nullable_to_non_nullable
              as bool?,
      apgarScore1Min: freezed == apgarScore1Min
          ? _value.apgarScore1Min
          : apgarScore1Min // ignore: cast_nullable_to_non_nullable
              as String?,
      apgarScore5Min: freezed == apgarScore5Min
          ? _value.apgarScore5Min
          : apgarScore5Min // ignore: cast_nullable_to_non_nullable
              as String?,
      apgarScore10Min: freezed == apgarScore10Min
          ? _value.apgarScore10Min
          : apgarScore10Min // ignore: cast_nullable_to_non_nullable
              as String?,
      resuscitationDone: freezed == resuscitationDone
          ? _value.resuscitationDone
          : resuscitationDone // ignore: cast_nullable_to_non_nullable
              as bool?,
      bloodLossMl: freezed == bloodLossMl
          ? _value.bloodLossMl
          : bloodLossMl // ignore: cast_nullable_to_non_nullable
              as double?,
      preEclampsia: freezed == preEclampsia
          ? _value.preEclampsia
          : preEclampsia // ignore: cast_nullable_to_non_nullable
              as bool?,
      eclampsia: freezed == eclampsia
          ? _value.eclampsia
          : eclampsia // ignore: cast_nullable_to_non_nullable
              as bool?,
      pph: freezed == pph
          ? _value.pph
          : pph // ignore: cast_nullable_to_non_nullable
              as bool?,
      obstructedLabour: freezed == obstructedLabour
          ? _value.obstructedLabour
          : obstructedLabour // ignore: cast_nullable_to_non_nullable
              as bool?,
      meconiumGrade: freezed == meconiumGrade
          ? _value.meconiumGrade
          : meconiumGrade // ignore: cast_nullable_to_non_nullable
              as String?,
      motherCondition: freezed == motherCondition
          ? _value.motherCondition
          : motherCondition // ignore: cast_nullable_to_non_nullable
              as String?,
      oxytocinGiven: freezed == oxytocinGiven
          ? _value.oxytocinGiven
          : oxytocinGiven // ignore: cast_nullable_to_non_nullable
              as bool?,
      misoprostolGiven: freezed == misoprostolGiven
          ? _value.misoprostolGiven
          : misoprostolGiven // ignore: cast_nullable_to_non_nullable
              as bool?,
      heatStableCarbetocin: freezed == heatStableCarbetocin
          ? _value.heatStableCarbetocin
          : heatStableCarbetocin // ignore: cast_nullable_to_non_nullable
              as bool?,
      haartGiven: freezed == haartGiven
          ? _value.haartGiven
          : haartGiven // ignore: cast_nullable_to_non_nullable
              as bool?,
      haartRegimen: freezed == haartRegimen
          ? _value.haartRegimen
          : haartRegimen // ignore: cast_nullable_to_non_nullable
              as String?,
      otherDrugs: freezed == otherDrugs
          ? _value.otherDrugs
          : otherDrugs // ignore: cast_nullable_to_non_nullable
              as String?,
      birthWeightGrams: null == birthWeightGrams
          ? _value.birthWeightGrams
          : birthWeightGrams // ignore: cast_nullable_to_non_nullable
              as double,
      birthLengthCm: null == birthLengthCm
          ? _value.birthLengthCm
          : birthLengthCm // ignore: cast_nullable_to_non_nullable
              as double,
      headCircumferenceCm: freezed == headCircumferenceCm
          ? _value.headCircumferenceCm
          : headCircumferenceCm // ignore: cast_nullable_to_non_nullable
              as double?,
      babyCondition: freezed == babyCondition
          ? _value.babyCondition
          : babyCondition // ignore: cast_nullable_to_non_nullable
              as String?,
      chxGiven: freezed == chxGiven
          ? _value.chxGiven
          : chxGiven // ignore: cast_nullable_to_non_nullable
              as bool?,
      vitaminKGiven: freezed == vitaminKGiven
          ? _value.vitaminKGiven
          : vitaminKGiven // ignore: cast_nullable_to_non_nullable
              as bool?,
      teoGiven: freezed == teoGiven
          ? _value.teoGiven
          : teoGiven // ignore: cast_nullable_to_non_nullable
              as bool?,
      babyHivExposed: freezed == babyHivExposed
          ? _value.babyHivExposed
          : babyHivExposed // ignore: cast_nullable_to_non_nullable
              as bool?,
      arvProphylaxisGiven: freezed == arvProphylaxisGiven
          ? _value.arvProphylaxisGiven
          : arvProphylaxisGiven // ignore: cast_nullable_to_non_nullable
              as String?,
      earlyInitiationBreastfeeding: freezed == earlyInitiationBreastfeeding
          ? _value.earlyInitiationBreastfeeding
          : earlyInitiationBreastfeeding // ignore: cast_nullable_to_non_nullable
              as bool?,
      notes: freezed == notes
          ? _value.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String?,
      conductedBy: freezed == conductedBy
          ? _value.conductedBy
          : conductedBy // ignore: cast_nullable_to_non_nullable
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
abstract class _$$ChildbirthRecordImplCopyWith<$Res>
    implements $ChildbirthRecordCopyWith<$Res> {
  factory _$$ChildbirthRecordImplCopyWith(_$ChildbirthRecordImpl value,
          $Res Function(_$ChildbirthRecordImpl) then) =
      __$$ChildbirthRecordImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'id') String? id,
      @JsonKey(name: 'maternal_profile_id') String maternalProfileId,
      @JsonKey(name: 'delivery_date') DateTime deliveryDate,
      @JsonKey(name: 'delivery_time') String deliveryTime,
      @JsonKey(name: 'duration_of_pregnancy_weeks')
      int durationOfPregnancyWeeks,
      @JsonKey(name: 'place_of_delivery') String placeOfDelivery,
      @JsonKey(name: 'health_facility_name') String? healthFacilityName,
      @JsonKey(name: 'attendant') String? attendant,
      @JsonKey(name: 'mode_of_delivery') String modeOfDelivery,
      @JsonKey(name: 'skin_to_skin_immediate') bool? skinToSkinImmediate,
      @JsonKey(name: 'apgar_score_1_min') String? apgarScore1Min,
      @JsonKey(name: 'apgar_score_5_min') String? apgarScore5Min,
      @JsonKey(name: 'apgar_score_10_min') String? apgarScore10Min,
      @JsonKey(name: 'resuscitation_done') bool? resuscitationDone,
      @JsonKey(name: 'blood_loss_ml') double? bloodLossMl,
      @JsonKey(name: 'pre_eclampsia') bool? preEclampsia,
      @JsonKey(name: 'eclampsia') bool? eclampsia,
      @JsonKey(name: 'pph') bool? pph,
      @JsonKey(name: 'obstructed_labour') bool? obstructedLabour,
      @JsonKey(name: 'meconium_grade') String? meconiumGrade,
      @JsonKey(name: 'mother_condition') String? motherCondition,
      @JsonKey(name: 'oxytocin_given') bool? oxytocinGiven,
      @JsonKey(name: 'misoprostol_given') bool? misoprostolGiven,
      @JsonKey(name: 'heat_stable_carbetocin') bool? heatStableCarbetocin,
      @JsonKey(name: 'haart_given') bool? haartGiven,
      @JsonKey(name: 'haart_regimen') String? haartRegimen,
      @JsonKey(name: 'other_drugs') String? otherDrugs,
      @JsonKey(name: 'birth_weight_grams') double birthWeightGrams,
      @JsonKey(name: 'birth_length_cm') double birthLengthCm,
      @JsonKey(name: 'head_circumference_cm') double? headCircumferenceCm,
      @JsonKey(name: 'baby_condition') String? babyCondition,
      @JsonKey(name: 'chx_given') bool? chxGiven,
      @JsonKey(name: 'vitamin_k_given') bool? vitaminKGiven,
      @JsonKey(name: 'teo_given') bool? teoGiven,
      @JsonKey(name: 'baby_hiv_exposed') bool? babyHivExposed,
      @JsonKey(name: 'arv_prophylaxis_given') String? arvProphylaxisGiven,
      @JsonKey(name: 'early_initiation_breastfeeding')
      bool? earlyInitiationBreastfeeding,
      @JsonKey(name: 'notes') String? notes,
      @JsonKey(name: 'conducted_by') String? conductedBy,
      @JsonKey(name: 'created_at') DateTime? createdAt,
      @JsonKey(name: 'updated_at') DateTime? updatedAt});
}

/// @nodoc
class __$$ChildbirthRecordImplCopyWithImpl<$Res>
    extends _$ChildbirthRecordCopyWithImpl<$Res, _$ChildbirthRecordImpl>
    implements _$$ChildbirthRecordImplCopyWith<$Res> {
  __$$ChildbirthRecordImplCopyWithImpl(_$ChildbirthRecordImpl _value,
      $Res Function(_$ChildbirthRecordImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? maternalProfileId = null,
    Object? deliveryDate = null,
    Object? deliveryTime = null,
    Object? durationOfPregnancyWeeks = null,
    Object? placeOfDelivery = null,
    Object? healthFacilityName = freezed,
    Object? attendant = freezed,
    Object? modeOfDelivery = null,
    Object? skinToSkinImmediate = freezed,
    Object? apgarScore1Min = freezed,
    Object? apgarScore5Min = freezed,
    Object? apgarScore10Min = freezed,
    Object? resuscitationDone = freezed,
    Object? bloodLossMl = freezed,
    Object? preEclampsia = freezed,
    Object? eclampsia = freezed,
    Object? pph = freezed,
    Object? obstructedLabour = freezed,
    Object? meconiumGrade = freezed,
    Object? motherCondition = freezed,
    Object? oxytocinGiven = freezed,
    Object? misoprostolGiven = freezed,
    Object? heatStableCarbetocin = freezed,
    Object? haartGiven = freezed,
    Object? haartRegimen = freezed,
    Object? otherDrugs = freezed,
    Object? birthWeightGrams = null,
    Object? birthLengthCm = null,
    Object? headCircumferenceCm = freezed,
    Object? babyCondition = freezed,
    Object? chxGiven = freezed,
    Object? vitaminKGiven = freezed,
    Object? teoGiven = freezed,
    Object? babyHivExposed = freezed,
    Object? arvProphylaxisGiven = freezed,
    Object? earlyInitiationBreastfeeding = freezed,
    Object? notes = freezed,
    Object? conductedBy = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(_$ChildbirthRecordImpl(
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String?,
      maternalProfileId: null == maternalProfileId
          ? _value.maternalProfileId
          : maternalProfileId // ignore: cast_nullable_to_non_nullable
              as String,
      deliveryDate: null == deliveryDate
          ? _value.deliveryDate
          : deliveryDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      deliveryTime: null == deliveryTime
          ? _value.deliveryTime
          : deliveryTime // ignore: cast_nullable_to_non_nullable
              as String,
      durationOfPregnancyWeeks: null == durationOfPregnancyWeeks
          ? _value.durationOfPregnancyWeeks
          : durationOfPregnancyWeeks // ignore: cast_nullable_to_non_nullable
              as int,
      placeOfDelivery: null == placeOfDelivery
          ? _value.placeOfDelivery
          : placeOfDelivery // ignore: cast_nullable_to_non_nullable
              as String,
      healthFacilityName: freezed == healthFacilityName
          ? _value.healthFacilityName
          : healthFacilityName // ignore: cast_nullable_to_non_nullable
              as String?,
      attendant: freezed == attendant
          ? _value.attendant
          : attendant // ignore: cast_nullable_to_non_nullable
              as String?,
      modeOfDelivery: null == modeOfDelivery
          ? _value.modeOfDelivery
          : modeOfDelivery // ignore: cast_nullable_to_non_nullable
              as String,
      skinToSkinImmediate: freezed == skinToSkinImmediate
          ? _value.skinToSkinImmediate
          : skinToSkinImmediate // ignore: cast_nullable_to_non_nullable
              as bool?,
      apgarScore1Min: freezed == apgarScore1Min
          ? _value.apgarScore1Min
          : apgarScore1Min // ignore: cast_nullable_to_non_nullable
              as String?,
      apgarScore5Min: freezed == apgarScore5Min
          ? _value.apgarScore5Min
          : apgarScore5Min // ignore: cast_nullable_to_non_nullable
              as String?,
      apgarScore10Min: freezed == apgarScore10Min
          ? _value.apgarScore10Min
          : apgarScore10Min // ignore: cast_nullable_to_non_nullable
              as String?,
      resuscitationDone: freezed == resuscitationDone
          ? _value.resuscitationDone
          : resuscitationDone // ignore: cast_nullable_to_non_nullable
              as bool?,
      bloodLossMl: freezed == bloodLossMl
          ? _value.bloodLossMl
          : bloodLossMl // ignore: cast_nullable_to_non_nullable
              as double?,
      preEclampsia: freezed == preEclampsia
          ? _value.preEclampsia
          : preEclampsia // ignore: cast_nullable_to_non_nullable
              as bool?,
      eclampsia: freezed == eclampsia
          ? _value.eclampsia
          : eclampsia // ignore: cast_nullable_to_non_nullable
              as bool?,
      pph: freezed == pph
          ? _value.pph
          : pph // ignore: cast_nullable_to_non_nullable
              as bool?,
      obstructedLabour: freezed == obstructedLabour
          ? _value.obstructedLabour
          : obstructedLabour // ignore: cast_nullable_to_non_nullable
              as bool?,
      meconiumGrade: freezed == meconiumGrade
          ? _value.meconiumGrade
          : meconiumGrade // ignore: cast_nullable_to_non_nullable
              as String?,
      motherCondition: freezed == motherCondition
          ? _value.motherCondition
          : motherCondition // ignore: cast_nullable_to_non_nullable
              as String?,
      oxytocinGiven: freezed == oxytocinGiven
          ? _value.oxytocinGiven
          : oxytocinGiven // ignore: cast_nullable_to_non_nullable
              as bool?,
      misoprostolGiven: freezed == misoprostolGiven
          ? _value.misoprostolGiven
          : misoprostolGiven // ignore: cast_nullable_to_non_nullable
              as bool?,
      heatStableCarbetocin: freezed == heatStableCarbetocin
          ? _value.heatStableCarbetocin
          : heatStableCarbetocin // ignore: cast_nullable_to_non_nullable
              as bool?,
      haartGiven: freezed == haartGiven
          ? _value.haartGiven
          : haartGiven // ignore: cast_nullable_to_non_nullable
              as bool?,
      haartRegimen: freezed == haartRegimen
          ? _value.haartRegimen
          : haartRegimen // ignore: cast_nullable_to_non_nullable
              as String?,
      otherDrugs: freezed == otherDrugs
          ? _value.otherDrugs
          : otherDrugs // ignore: cast_nullable_to_non_nullable
              as String?,
      birthWeightGrams: null == birthWeightGrams
          ? _value.birthWeightGrams
          : birthWeightGrams // ignore: cast_nullable_to_non_nullable
              as double,
      birthLengthCm: null == birthLengthCm
          ? _value.birthLengthCm
          : birthLengthCm // ignore: cast_nullable_to_non_nullable
              as double,
      headCircumferenceCm: freezed == headCircumferenceCm
          ? _value.headCircumferenceCm
          : headCircumferenceCm // ignore: cast_nullable_to_non_nullable
              as double?,
      babyCondition: freezed == babyCondition
          ? _value.babyCondition
          : babyCondition // ignore: cast_nullable_to_non_nullable
              as String?,
      chxGiven: freezed == chxGiven
          ? _value.chxGiven
          : chxGiven // ignore: cast_nullable_to_non_nullable
              as bool?,
      vitaminKGiven: freezed == vitaminKGiven
          ? _value.vitaminKGiven
          : vitaminKGiven // ignore: cast_nullable_to_non_nullable
              as bool?,
      teoGiven: freezed == teoGiven
          ? _value.teoGiven
          : teoGiven // ignore: cast_nullable_to_non_nullable
              as bool?,
      babyHivExposed: freezed == babyHivExposed
          ? _value.babyHivExposed
          : babyHivExposed // ignore: cast_nullable_to_non_nullable
              as bool?,
      arvProphylaxisGiven: freezed == arvProphylaxisGiven
          ? _value.arvProphylaxisGiven
          : arvProphylaxisGiven // ignore: cast_nullable_to_non_nullable
              as String?,
      earlyInitiationBreastfeeding: freezed == earlyInitiationBreastfeeding
          ? _value.earlyInitiationBreastfeeding
          : earlyInitiationBreastfeeding // ignore: cast_nullable_to_non_nullable
              as bool?,
      notes: freezed == notes
          ? _value.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String?,
      conductedBy: freezed == conductedBy
          ? _value.conductedBy
          : conductedBy // ignore: cast_nullable_to_non_nullable
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
class _$ChildbirthRecordImpl implements _ChildbirthRecord {
  const _$ChildbirthRecordImpl(
      {@JsonKey(name: 'id') this.id,
      @JsonKey(name: 'maternal_profile_id') required this.maternalProfileId,
      @JsonKey(name: 'delivery_date') required this.deliveryDate,
      @JsonKey(name: 'delivery_time') required this.deliveryTime,
      @JsonKey(name: 'duration_of_pregnancy_weeks')
      required this.durationOfPregnancyWeeks,
      @JsonKey(name: 'place_of_delivery') required this.placeOfDelivery,
      @JsonKey(name: 'health_facility_name') this.healthFacilityName,
      @JsonKey(name: 'attendant') this.attendant,
      @JsonKey(name: 'mode_of_delivery') required this.modeOfDelivery,
      @JsonKey(name: 'skin_to_skin_immediate') this.skinToSkinImmediate,
      @JsonKey(name: 'apgar_score_1_min') this.apgarScore1Min,
      @JsonKey(name: 'apgar_score_5_min') this.apgarScore5Min,
      @JsonKey(name: 'apgar_score_10_min') this.apgarScore10Min,
      @JsonKey(name: 'resuscitation_done') this.resuscitationDone,
      @JsonKey(name: 'blood_loss_ml') this.bloodLossMl,
      @JsonKey(name: 'pre_eclampsia') this.preEclampsia,
      @JsonKey(name: 'eclampsia') this.eclampsia,
      @JsonKey(name: 'pph') this.pph,
      @JsonKey(name: 'obstructed_labour') this.obstructedLabour,
      @JsonKey(name: 'meconium_grade') this.meconiumGrade,
      @JsonKey(name: 'mother_condition') this.motherCondition,
      @JsonKey(name: 'oxytocin_given') this.oxytocinGiven,
      @JsonKey(name: 'misoprostol_given') this.misoprostolGiven,
      @JsonKey(name: 'heat_stable_carbetocin') this.heatStableCarbetocin,
      @JsonKey(name: 'haart_given') this.haartGiven,
      @JsonKey(name: 'haart_regimen') this.haartRegimen,
      @JsonKey(name: 'other_drugs') this.otherDrugs,
      @JsonKey(name: 'birth_weight_grams') required this.birthWeightGrams,
      @JsonKey(name: 'birth_length_cm') required this.birthLengthCm,
      @JsonKey(name: 'head_circumference_cm') this.headCircumferenceCm,
      @JsonKey(name: 'baby_condition') this.babyCondition,
      @JsonKey(name: 'chx_given') this.chxGiven,
      @JsonKey(name: 'vitamin_k_given') this.vitaminKGiven,
      @JsonKey(name: 'teo_given') this.teoGiven,
      @JsonKey(name: 'baby_hiv_exposed') this.babyHivExposed,
      @JsonKey(name: 'arv_prophylaxis_given') this.arvProphylaxisGiven,
      @JsonKey(name: 'early_initiation_breastfeeding')
      this.earlyInitiationBreastfeeding,
      @JsonKey(name: 'notes') this.notes,
      @JsonKey(name: 'conducted_by') this.conductedBy,
      @JsonKey(name: 'created_at') this.createdAt,
      @JsonKey(name: 'updated_at') this.updatedAt});

  factory _$ChildbirthRecordImpl.fromJson(Map<String, dynamic> json) =>
      _$$ChildbirthRecordImplFromJson(json);

  @override
  @JsonKey(name: 'id')
  final String? id;
// ← Changed to nullable
  @override
  @JsonKey(name: 'maternal_profile_id')
  final String maternalProfileId;
  @override
  @JsonKey(name: 'delivery_date')
  final DateTime deliveryDate;
  @override
  @JsonKey(name: 'delivery_time')
  final String deliveryTime;
  @override
  @JsonKey(name: 'duration_of_pregnancy_weeks')
  final int durationOfPregnancyWeeks;
// Place & Attendant
  @override
  @JsonKey(name: 'place_of_delivery')
  final String placeOfDelivery;
  @override
  @JsonKey(name: 'health_facility_name')
  final String? healthFacilityName;
  @override
  @JsonKey(name: 'attendant')
  final String? attendant;
// Mode of Delivery
  @override
  @JsonKey(name: 'mode_of_delivery')
  final String modeOfDelivery;
// Mother's Condition
  @override
  @JsonKey(name: 'skin_to_skin_immediate')
  final bool? skinToSkinImmediate;
  @override
  @JsonKey(name: 'apgar_score_1_min')
  final String? apgarScore1Min;
  @override
  @JsonKey(name: 'apgar_score_5_min')
  final String? apgarScore5Min;
  @override
  @JsonKey(name: 'apgar_score_10_min')
  final String? apgarScore10Min;
  @override
  @JsonKey(name: 'resuscitation_done')
  final bool? resuscitationDone;
  @override
  @JsonKey(name: 'blood_loss_ml')
  final double? bloodLossMl;
// Complications
  @override
  @JsonKey(name: 'pre_eclampsia')
  final bool? preEclampsia;
  @override
  @JsonKey(name: 'eclampsia')
  final bool? eclampsia;
  @override
  @JsonKey(name: 'pph')
  final bool? pph;
  @override
  @JsonKey(name: 'obstructed_labour')
  final bool? obstructedLabour;
  @override
  @JsonKey(name: 'meconium_grade')
  final String? meconiumGrade;
// Mother's Condition Post-delivery
  @override
  @JsonKey(name: 'mother_condition')
  final String? motherCondition;
// Drugs Administered to Mother
  @override
  @JsonKey(name: 'oxytocin_given')
  final bool? oxytocinGiven;
  @override
  @JsonKey(name: 'misoprostol_given')
  final bool? misoprostolGiven;
  @override
  @JsonKey(name: 'heat_stable_carbetocin')
  final bool? heatStableCarbetocin;
  @override
  @JsonKey(name: 'haart_given')
  final bool? haartGiven;
  @override
  @JsonKey(name: 'haart_regimen')
  final String? haartRegimen;
  @override
  @JsonKey(name: 'other_drugs')
  final String? otherDrugs;
// Baby Details
  @override
  @JsonKey(name: 'birth_weight_grams')
  final double birthWeightGrams;
  @override
  @JsonKey(name: 'birth_length_cm')
  final double birthLengthCm;
  @override
  @JsonKey(name: 'head_circumference_cm')
  final double? headCircumferenceCm;
  @override
  @JsonKey(name: 'baby_condition')
  final String? babyCondition;
// Drugs Given to Baby
  @override
  @JsonKey(name: 'chx_given')
  final bool? chxGiven;
  @override
  @JsonKey(name: 'vitamin_k_given')
  final bool? vitaminKGiven;
  @override
  @JsonKey(name: 'teo_given')
  final bool? teoGiven;
// HIV Exposure
  @override
  @JsonKey(name: 'baby_hiv_exposed')
  final bool? babyHivExposed;
  @override
  @JsonKey(name: 'arv_prophylaxis_given')
  final String? arvProphylaxisGiven;
// Breastfeeding
  @override
  @JsonKey(name: 'early_initiation_breastfeeding')
  final bool? earlyInitiationBreastfeeding;
// Clinical Notes
  @override
  @JsonKey(name: 'notes')
  final String? notes;
  @override
  @JsonKey(name: 'conducted_by')
  final String? conductedBy;
  @override
  @JsonKey(name: 'created_at')
  final DateTime? createdAt;
  @override
  @JsonKey(name: 'updated_at')
  final DateTime? updatedAt;

  @override
  String toString() {
    return 'ChildbirthRecord(id: $id, maternalProfileId: $maternalProfileId, deliveryDate: $deliveryDate, deliveryTime: $deliveryTime, durationOfPregnancyWeeks: $durationOfPregnancyWeeks, placeOfDelivery: $placeOfDelivery, healthFacilityName: $healthFacilityName, attendant: $attendant, modeOfDelivery: $modeOfDelivery, skinToSkinImmediate: $skinToSkinImmediate, apgarScore1Min: $apgarScore1Min, apgarScore5Min: $apgarScore5Min, apgarScore10Min: $apgarScore10Min, resuscitationDone: $resuscitationDone, bloodLossMl: $bloodLossMl, preEclampsia: $preEclampsia, eclampsia: $eclampsia, pph: $pph, obstructedLabour: $obstructedLabour, meconiumGrade: $meconiumGrade, motherCondition: $motherCondition, oxytocinGiven: $oxytocinGiven, misoprostolGiven: $misoprostolGiven, heatStableCarbetocin: $heatStableCarbetocin, haartGiven: $haartGiven, haartRegimen: $haartRegimen, otherDrugs: $otherDrugs, birthWeightGrams: $birthWeightGrams, birthLengthCm: $birthLengthCm, headCircumferenceCm: $headCircumferenceCm, babyCondition: $babyCondition, chxGiven: $chxGiven, vitaminKGiven: $vitaminKGiven, teoGiven: $teoGiven, babyHivExposed: $babyHivExposed, arvProphylaxisGiven: $arvProphylaxisGiven, earlyInitiationBreastfeeding: $earlyInitiationBreastfeeding, notes: $notes, conductedBy: $conductedBy, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ChildbirthRecordImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.maternalProfileId, maternalProfileId) ||
                other.maternalProfileId == maternalProfileId) &&
            (identical(other.deliveryDate, deliveryDate) ||
                other.deliveryDate == deliveryDate) &&
            (identical(other.deliveryTime, deliveryTime) ||
                other.deliveryTime == deliveryTime) &&
            (identical(other.durationOfPregnancyWeeks, durationOfPregnancyWeeks) ||
                other.durationOfPregnancyWeeks == durationOfPregnancyWeeks) &&
            (identical(other.placeOfDelivery, placeOfDelivery) ||
                other.placeOfDelivery == placeOfDelivery) &&
            (identical(other.healthFacilityName, healthFacilityName) ||
                other.healthFacilityName == healthFacilityName) &&
            (identical(other.attendant, attendant) ||
                other.attendant == attendant) &&
            (identical(other.modeOfDelivery, modeOfDelivery) ||
                other.modeOfDelivery == modeOfDelivery) &&
            (identical(other.skinToSkinImmediate, skinToSkinImmediate) ||
                other.skinToSkinImmediate == skinToSkinImmediate) &&
            (identical(other.apgarScore1Min, apgarScore1Min) ||
                other.apgarScore1Min == apgarScore1Min) &&
            (identical(other.apgarScore5Min, apgarScore5Min) ||
                other.apgarScore5Min == apgarScore5Min) &&
            (identical(other.apgarScore10Min, apgarScore10Min) ||
                other.apgarScore10Min == apgarScore10Min) &&
            (identical(other.resuscitationDone, resuscitationDone) ||
                other.resuscitationDone == resuscitationDone) &&
            (identical(other.bloodLossMl, bloodLossMl) ||
                other.bloodLossMl == bloodLossMl) &&
            (identical(other.preEclampsia, preEclampsia) ||
                other.preEclampsia == preEclampsia) &&
            (identical(other.eclampsia, eclampsia) ||
                other.eclampsia == eclampsia) &&
            (identical(other.pph, pph) || other.pph == pph) &&
            (identical(other.obstructedLabour, obstructedLabour) ||
                other.obstructedLabour == obstructedLabour) &&
            (identical(other.meconiumGrade, meconiumGrade) ||
                other.meconiumGrade == meconiumGrade) &&
            (identical(other.motherCondition, motherCondition) ||
                other.motherCondition == motherCondition) &&
            (identical(other.oxytocinGiven, oxytocinGiven) ||
                other.oxytocinGiven == oxytocinGiven) &&
            (identical(other.misoprostolGiven, misoprostolGiven) ||
                other.misoprostolGiven == misoprostolGiven) &&
            (identical(other.heatStableCarbetocin, heatStableCarbetocin) ||
                other.heatStableCarbetocin == heatStableCarbetocin) &&
            (identical(other.haartGiven, haartGiven) ||
                other.haartGiven == haartGiven) &&
            (identical(other.haartRegimen, haartRegimen) ||
                other.haartRegimen == haartRegimen) &&
            (identical(other.otherDrugs, otherDrugs) ||
                other.otherDrugs == otherDrugs) &&
            (identical(other.birthWeightGrams, birthWeightGrams) ||
                other.birthWeightGrams == birthWeightGrams) &&
            (identical(other.birthLengthCm, birthLengthCm) ||
                other.birthLengthCm == birthLengthCm) &&
            (identical(other.headCircumferenceCm, headCircumferenceCm) ||
                other.headCircumferenceCm == headCircumferenceCm) &&
            (identical(other.babyCondition, babyCondition) ||
                other.babyCondition == babyCondition) &&
            (identical(other.chxGiven, chxGiven) ||
                other.chxGiven == chxGiven) &&
            (identical(other.vitaminKGiven, vitaminKGiven) ||
                other.vitaminKGiven == vitaminKGiven) &&
            (identical(other.teoGiven, teoGiven) ||
                other.teoGiven == teoGiven) &&
            (identical(other.babyHivExposed, babyHivExposed) ||
                other.babyHivExposed == babyHivExposed) &&
            (identical(other.arvProphylaxisGiven, arvProphylaxisGiven) || other.arvProphylaxisGiven == arvProphylaxisGiven) &&
            (identical(other.earlyInitiationBreastfeeding, earlyInitiationBreastfeeding) || other.earlyInitiationBreastfeeding == earlyInitiationBreastfeeding) &&
            (identical(other.notes, notes) || other.notes == notes) &&
            (identical(other.conductedBy, conductedBy) || other.conductedBy == conductedBy) &&
            (identical(other.createdAt, createdAt) || other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hashAll([
        runtimeType,
        id,
        maternalProfileId,
        deliveryDate,
        deliveryTime,
        durationOfPregnancyWeeks,
        placeOfDelivery,
        healthFacilityName,
        attendant,
        modeOfDelivery,
        skinToSkinImmediate,
        apgarScore1Min,
        apgarScore5Min,
        apgarScore10Min,
        resuscitationDone,
        bloodLossMl,
        preEclampsia,
        eclampsia,
        pph,
        obstructedLabour,
        meconiumGrade,
        motherCondition,
        oxytocinGiven,
        misoprostolGiven,
        heatStableCarbetocin,
        haartGiven,
        haartRegimen,
        otherDrugs,
        birthWeightGrams,
        birthLengthCm,
        headCircumferenceCm,
        babyCondition,
        chxGiven,
        vitaminKGiven,
        teoGiven,
        babyHivExposed,
        arvProphylaxisGiven,
        earlyInitiationBreastfeeding,
        notes,
        conductedBy,
        createdAt,
        updatedAt
      ]);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ChildbirthRecordImplCopyWith<_$ChildbirthRecordImpl> get copyWith =>
      __$$ChildbirthRecordImplCopyWithImpl<_$ChildbirthRecordImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ChildbirthRecordImplToJson(
      this,
    );
  }
}

abstract class _ChildbirthRecord implements ChildbirthRecord {
  const factory _ChildbirthRecord(
      {@JsonKey(name: 'id') final String? id,
      @JsonKey(name: 'maternal_profile_id')
      required final String maternalProfileId,
      @JsonKey(name: 'delivery_date') required final DateTime deliveryDate,
      @JsonKey(name: 'delivery_time') required final String deliveryTime,
      @JsonKey(name: 'duration_of_pregnancy_weeks')
      required final int durationOfPregnancyWeeks,
      @JsonKey(name: 'place_of_delivery') required final String placeOfDelivery,
      @JsonKey(name: 'health_facility_name') final String? healthFacilityName,
      @JsonKey(name: 'attendant') final String? attendant,
      @JsonKey(name: 'mode_of_delivery') required final String modeOfDelivery,
      @JsonKey(name: 'skin_to_skin_immediate') final bool? skinToSkinImmediate,
      @JsonKey(name: 'apgar_score_1_min') final String? apgarScore1Min,
      @JsonKey(name: 'apgar_score_5_min') final String? apgarScore5Min,
      @JsonKey(name: 'apgar_score_10_min') final String? apgarScore10Min,
      @JsonKey(name: 'resuscitation_done') final bool? resuscitationDone,
      @JsonKey(name: 'blood_loss_ml') final double? bloodLossMl,
      @JsonKey(name: 'pre_eclampsia') final bool? preEclampsia,
      @JsonKey(name: 'eclampsia') final bool? eclampsia,
      @JsonKey(name: 'pph') final bool? pph,
      @JsonKey(name: 'obstructed_labour') final bool? obstructedLabour,
      @JsonKey(name: 'meconium_grade') final String? meconiumGrade,
      @JsonKey(name: 'mother_condition') final String? motherCondition,
      @JsonKey(name: 'oxytocin_given') final bool? oxytocinGiven,
      @JsonKey(name: 'misoprostol_given') final bool? misoprostolGiven,
      @JsonKey(name: 'heat_stable_carbetocin') final bool? heatStableCarbetocin,
      @JsonKey(name: 'haart_given') final bool? haartGiven,
      @JsonKey(name: 'haart_regimen') final String? haartRegimen,
      @JsonKey(name: 'other_drugs') final String? otherDrugs,
      @JsonKey(name: 'birth_weight_grams')
      required final double birthWeightGrams,
      @JsonKey(name: 'birth_length_cm') required final double birthLengthCm,
      @JsonKey(name: 'head_circumference_cm') final double? headCircumferenceCm,
      @JsonKey(name: 'baby_condition') final String? babyCondition,
      @JsonKey(name: 'chx_given') final bool? chxGiven,
      @JsonKey(name: 'vitamin_k_given') final bool? vitaminKGiven,
      @JsonKey(name: 'teo_given') final bool? teoGiven,
      @JsonKey(name: 'baby_hiv_exposed') final bool? babyHivExposed,
      @JsonKey(name: 'arv_prophylaxis_given') final String? arvProphylaxisGiven,
      @JsonKey(name: 'early_initiation_breastfeeding')
      final bool? earlyInitiationBreastfeeding,
      @JsonKey(name: 'notes') final String? notes,
      @JsonKey(name: 'conducted_by') final String? conductedBy,
      @JsonKey(name: 'created_at') final DateTime? createdAt,
      @JsonKey(name: 'updated_at')
      final DateTime? updatedAt}) = _$ChildbirthRecordImpl;

  factory _ChildbirthRecord.fromJson(Map<String, dynamic> json) =
      _$ChildbirthRecordImpl.fromJson;

  @override
  @JsonKey(name: 'id')
  String? get id;
  @override // ← Changed to nullable
  @JsonKey(name: 'maternal_profile_id')
  String get maternalProfileId;
  @override
  @JsonKey(name: 'delivery_date')
  DateTime get deliveryDate;
  @override
  @JsonKey(name: 'delivery_time')
  String get deliveryTime;
  @override
  @JsonKey(name: 'duration_of_pregnancy_weeks')
  int get durationOfPregnancyWeeks;
  @override // Place & Attendant
  @JsonKey(name: 'place_of_delivery')
  String get placeOfDelivery;
  @override
  @JsonKey(name: 'health_facility_name')
  String? get healthFacilityName;
  @override
  @JsonKey(name: 'attendant')
  String? get attendant;
  @override // Mode of Delivery
  @JsonKey(name: 'mode_of_delivery')
  String get modeOfDelivery;
  @override // Mother's Condition
  @JsonKey(name: 'skin_to_skin_immediate')
  bool? get skinToSkinImmediate;
  @override
  @JsonKey(name: 'apgar_score_1_min')
  String? get apgarScore1Min;
  @override
  @JsonKey(name: 'apgar_score_5_min')
  String? get apgarScore5Min;
  @override
  @JsonKey(name: 'apgar_score_10_min')
  String? get apgarScore10Min;
  @override
  @JsonKey(name: 'resuscitation_done')
  bool? get resuscitationDone;
  @override
  @JsonKey(name: 'blood_loss_ml')
  double? get bloodLossMl;
  @override // Complications
  @JsonKey(name: 'pre_eclampsia')
  bool? get preEclampsia;
  @override
  @JsonKey(name: 'eclampsia')
  bool? get eclampsia;
  @override
  @JsonKey(name: 'pph')
  bool? get pph;
  @override
  @JsonKey(name: 'obstructed_labour')
  bool? get obstructedLabour;
  @override
  @JsonKey(name: 'meconium_grade')
  String? get meconiumGrade;
  @override // Mother's Condition Post-delivery
  @JsonKey(name: 'mother_condition')
  String? get motherCondition;
  @override // Drugs Administered to Mother
  @JsonKey(name: 'oxytocin_given')
  bool? get oxytocinGiven;
  @override
  @JsonKey(name: 'misoprostol_given')
  bool? get misoprostolGiven;
  @override
  @JsonKey(name: 'heat_stable_carbetocin')
  bool? get heatStableCarbetocin;
  @override
  @JsonKey(name: 'haart_given')
  bool? get haartGiven;
  @override
  @JsonKey(name: 'haart_regimen')
  String? get haartRegimen;
  @override
  @JsonKey(name: 'other_drugs')
  String? get otherDrugs;
  @override // Baby Details
  @JsonKey(name: 'birth_weight_grams')
  double get birthWeightGrams;
  @override
  @JsonKey(name: 'birth_length_cm')
  double get birthLengthCm;
  @override
  @JsonKey(name: 'head_circumference_cm')
  double? get headCircumferenceCm;
  @override
  @JsonKey(name: 'baby_condition')
  String? get babyCondition;
  @override // Drugs Given to Baby
  @JsonKey(name: 'chx_given')
  bool? get chxGiven;
  @override
  @JsonKey(name: 'vitamin_k_given')
  bool? get vitaminKGiven;
  @override
  @JsonKey(name: 'teo_given')
  bool? get teoGiven;
  @override // HIV Exposure
  @JsonKey(name: 'baby_hiv_exposed')
  bool? get babyHivExposed;
  @override
  @JsonKey(name: 'arv_prophylaxis_given')
  String? get arvProphylaxisGiven;
  @override // Breastfeeding
  @JsonKey(name: 'early_initiation_breastfeeding')
  bool? get earlyInitiationBreastfeeding;
  @override // Clinical Notes
  @JsonKey(name: 'notes')
  String? get notes;
  @override
  @JsonKey(name: 'conducted_by')
  String? get conductedBy;
  @override
  @JsonKey(name: 'created_at')
  DateTime? get createdAt;
  @override
  @JsonKey(name: 'updated_at')
  DateTime? get updatedAt;
  @override
  @JsonKey(ignore: true)
  _$$ChildbirthRecordImplCopyWith<_$ChildbirthRecordImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
