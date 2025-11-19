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
  String get id => throw _privateConstructorUsedError;
  String get maternalProfileId => throw _privateConstructorUsedError;
  DateTime get deliveryDate => throw _privateConstructorUsedError;
  String get deliveryTime => throw _privateConstructorUsedError;
  int get durationOfPregnancyWeeks =>
      throw _privateConstructorUsedError; // Place & Attendant
  String get placeOfDelivery =>
      throw _privateConstructorUsedError; // Health facility, Home, Other
  String? get healthFacilityName => throw _privateConstructorUsedError;
  String? get attendant =>
      throw _privateConstructorUsedError; // Nurse, Midwife, Clinical Officer, Doctor
// Mode of Delivery
  String get modeOfDelivery =>
      throw _privateConstructorUsedError; // SVD, Caesarean, Assisted (Vacuum/Forceps)
// Mother's Condition
  bool? get skinToSkinImmediate => throw _privateConstructorUsedError;
  String? get apgarScore1Min => throw _privateConstructorUsedError;
  String? get apgarScore5Min => throw _privateConstructorUsedError;
  String? get apgarScore10Min => throw _privateConstructorUsedError;
  bool? get resuscitationDone => throw _privateConstructorUsedError;
  double? get bloodLossMl =>
      throw _privateConstructorUsedError; // Complications
  bool? get preEclampsia => throw _privateConstructorUsedError;
  bool? get eclampsia => throw _privateConstructorUsedError;
  bool? get pph => throw _privateConstructorUsedError; // Post-partum hemorrhage
  bool? get obstructedLabour => throw _privateConstructorUsedError;
  String? get meconiumGrade => throw _privateConstructorUsedError; // 0, 1, 2, 3
// Mother's Condition Post-delivery
  String? get motherCondition =>
      throw _privateConstructorUsedError; // Drugs Administered to Mother
  bool? get oxytocinGiven => throw _privateConstructorUsedError;
  bool? get misoprostolGiven => throw _privateConstructorUsedError;
  bool? get heatStableCarbetocin => throw _privateConstructorUsedError;
  bool? get haartGiven => throw _privateConstructorUsedError; // If HIV positive
  String? get haartRegimen => throw _privateConstructorUsedError;
  String? get otherDrugs => throw _privateConstructorUsedError; // Baby Details
  double get birthWeightGrams => throw _privateConstructorUsedError;
  double get birthLengthCm => throw _privateConstructorUsedError;
  double? get headCircumferenceCm => throw _privateConstructorUsedError;
  String? get babyCondition =>
      throw _privateConstructorUsedError; // Drugs Given to Baby
  bool? get chxGiven =>
      throw _privateConstructorUsedError; // Chlorhexidine 7.1%
  bool? get vitaminKGiven => throw _privateConstructorUsedError;
  bool? get teoGiven =>
      throw _privateConstructorUsedError; // Tetracycline Eye Ointment
// HIV Exposure
  bool? get babyHivExposed => throw _privateConstructorUsedError;
  String? get arvProphylaxisGiven =>
      throw _privateConstructorUsedError; // AZT+NVP
// Breastfeeding
  bool? get earlyInitiationBreastfeeding =>
      throw _privateConstructorUsedError; // Within 1 hour
// Clinical Notes
  String? get notes => throw _privateConstructorUsedError;
  String? get conductedBy => throw _privateConstructorUsedError;
  DateTime? get createdAt => throw _privateConstructorUsedError;
  DateTime? get updatedAt => throw _privateConstructorUsedError;

  /// Serializes this ChildbirthRecord to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ChildbirthRecord
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
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
      {String id,
      String maternalProfileId,
      DateTime deliveryDate,
      String deliveryTime,
      int durationOfPregnancyWeeks,
      String placeOfDelivery,
      String? healthFacilityName,
      String? attendant,
      String modeOfDelivery,
      bool? skinToSkinImmediate,
      String? apgarScore1Min,
      String? apgarScore5Min,
      String? apgarScore10Min,
      bool? resuscitationDone,
      double? bloodLossMl,
      bool? preEclampsia,
      bool? eclampsia,
      bool? pph,
      bool? obstructedLabour,
      String? meconiumGrade,
      String? motherCondition,
      bool? oxytocinGiven,
      bool? misoprostolGiven,
      bool? heatStableCarbetocin,
      bool? haartGiven,
      String? haartRegimen,
      String? otherDrugs,
      double birthWeightGrams,
      double birthLengthCm,
      double? headCircumferenceCm,
      String? babyCondition,
      bool? chxGiven,
      bool? vitaminKGiven,
      bool? teoGiven,
      bool? babyHivExposed,
      String? arvProphylaxisGiven,
      bool? earlyInitiationBreastfeeding,
      String? notes,
      String? conductedBy,
      DateTime? createdAt,
      DateTime? updatedAt});
}

/// @nodoc
class _$ChildbirthRecordCopyWithImpl<$Res, $Val extends ChildbirthRecord>
    implements $ChildbirthRecordCopyWith<$Res> {
  _$ChildbirthRecordCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ChildbirthRecord
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
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
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
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
      {String id,
      String maternalProfileId,
      DateTime deliveryDate,
      String deliveryTime,
      int durationOfPregnancyWeeks,
      String placeOfDelivery,
      String? healthFacilityName,
      String? attendant,
      String modeOfDelivery,
      bool? skinToSkinImmediate,
      String? apgarScore1Min,
      String? apgarScore5Min,
      String? apgarScore10Min,
      bool? resuscitationDone,
      double? bloodLossMl,
      bool? preEclampsia,
      bool? eclampsia,
      bool? pph,
      bool? obstructedLabour,
      String? meconiumGrade,
      String? motherCondition,
      bool? oxytocinGiven,
      bool? misoprostolGiven,
      bool? heatStableCarbetocin,
      bool? haartGiven,
      String? haartRegimen,
      String? otherDrugs,
      double birthWeightGrams,
      double birthLengthCm,
      double? headCircumferenceCm,
      String? babyCondition,
      bool? chxGiven,
      bool? vitaminKGiven,
      bool? teoGiven,
      bool? babyHivExposed,
      String? arvProphylaxisGiven,
      bool? earlyInitiationBreastfeeding,
      String? notes,
      String? conductedBy,
      DateTime? createdAt,
      DateTime? updatedAt});
}

/// @nodoc
class __$$ChildbirthRecordImplCopyWithImpl<$Res>
    extends _$ChildbirthRecordCopyWithImpl<$Res, _$ChildbirthRecordImpl>
    implements _$$ChildbirthRecordImplCopyWith<$Res> {
  __$$ChildbirthRecordImplCopyWithImpl(_$ChildbirthRecordImpl _value,
      $Res Function(_$ChildbirthRecordImpl) _then)
      : super(_value, _then);

  /// Create a copy of ChildbirthRecord
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
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
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
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
      {required this.id,
      required this.maternalProfileId,
      required this.deliveryDate,
      required this.deliveryTime,
      required this.durationOfPregnancyWeeks,
      required this.placeOfDelivery,
      this.healthFacilityName,
      this.attendant,
      required this.modeOfDelivery,
      this.skinToSkinImmediate,
      this.apgarScore1Min,
      this.apgarScore5Min,
      this.apgarScore10Min,
      this.resuscitationDone,
      this.bloodLossMl,
      this.preEclampsia,
      this.eclampsia,
      this.pph,
      this.obstructedLabour,
      this.meconiumGrade,
      this.motherCondition,
      this.oxytocinGiven,
      this.misoprostolGiven,
      this.heatStableCarbetocin,
      this.haartGiven,
      this.haartRegimen,
      this.otherDrugs,
      required this.birthWeightGrams,
      required this.birthLengthCm,
      this.headCircumferenceCm,
      this.babyCondition,
      this.chxGiven,
      this.vitaminKGiven,
      this.teoGiven,
      this.babyHivExposed,
      this.arvProphylaxisGiven,
      this.earlyInitiationBreastfeeding,
      this.notes,
      this.conductedBy,
      this.createdAt,
      this.updatedAt});

  factory _$ChildbirthRecordImpl.fromJson(Map<String, dynamic> json) =>
      _$$ChildbirthRecordImplFromJson(json);

  @override
  final String id;
  @override
  final String maternalProfileId;
  @override
  final DateTime deliveryDate;
  @override
  final String deliveryTime;
  @override
  final int durationOfPregnancyWeeks;
// Place & Attendant
  @override
  final String placeOfDelivery;
// Health facility, Home, Other
  @override
  final String? healthFacilityName;
  @override
  final String? attendant;
// Nurse, Midwife, Clinical Officer, Doctor
// Mode of Delivery
  @override
  final String modeOfDelivery;
// SVD, Caesarean, Assisted (Vacuum/Forceps)
// Mother's Condition
  @override
  final bool? skinToSkinImmediate;
  @override
  final String? apgarScore1Min;
  @override
  final String? apgarScore5Min;
  @override
  final String? apgarScore10Min;
  @override
  final bool? resuscitationDone;
  @override
  final double? bloodLossMl;
// Complications
  @override
  final bool? preEclampsia;
  @override
  final bool? eclampsia;
  @override
  final bool? pph;
// Post-partum hemorrhage
  @override
  final bool? obstructedLabour;
  @override
  final String? meconiumGrade;
// 0, 1, 2, 3
// Mother's Condition Post-delivery
  @override
  final String? motherCondition;
// Drugs Administered to Mother
  @override
  final bool? oxytocinGiven;
  @override
  final bool? misoprostolGiven;
  @override
  final bool? heatStableCarbetocin;
  @override
  final bool? haartGiven;
// If HIV positive
  @override
  final String? haartRegimen;
  @override
  final String? otherDrugs;
// Baby Details
  @override
  final double birthWeightGrams;
  @override
  final double birthLengthCm;
  @override
  final double? headCircumferenceCm;
  @override
  final String? babyCondition;
// Drugs Given to Baby
  @override
  final bool? chxGiven;
// Chlorhexidine 7.1%
  @override
  final bool? vitaminKGiven;
  @override
  final bool? teoGiven;
// Tetracycline Eye Ointment
// HIV Exposure
  @override
  final bool? babyHivExposed;
  @override
  final String? arvProphylaxisGiven;
// AZT+NVP
// Breastfeeding
  @override
  final bool? earlyInitiationBreastfeeding;
// Within 1 hour
// Clinical Notes
  @override
  final String? notes;
  @override
  final String? conductedBy;
  @override
  final DateTime? createdAt;
  @override
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

  @JsonKey(includeFromJson: false, includeToJson: false)
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

  /// Create a copy of ChildbirthRecord
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
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
      {required final String id,
      required final String maternalProfileId,
      required final DateTime deliveryDate,
      required final String deliveryTime,
      required final int durationOfPregnancyWeeks,
      required final String placeOfDelivery,
      final String? healthFacilityName,
      final String? attendant,
      required final String modeOfDelivery,
      final bool? skinToSkinImmediate,
      final String? apgarScore1Min,
      final String? apgarScore5Min,
      final String? apgarScore10Min,
      final bool? resuscitationDone,
      final double? bloodLossMl,
      final bool? preEclampsia,
      final bool? eclampsia,
      final bool? pph,
      final bool? obstructedLabour,
      final String? meconiumGrade,
      final String? motherCondition,
      final bool? oxytocinGiven,
      final bool? misoprostolGiven,
      final bool? heatStableCarbetocin,
      final bool? haartGiven,
      final String? haartRegimen,
      final String? otherDrugs,
      required final double birthWeightGrams,
      required final double birthLengthCm,
      final double? headCircumferenceCm,
      final String? babyCondition,
      final bool? chxGiven,
      final bool? vitaminKGiven,
      final bool? teoGiven,
      final bool? babyHivExposed,
      final String? arvProphylaxisGiven,
      final bool? earlyInitiationBreastfeeding,
      final String? notes,
      final String? conductedBy,
      final DateTime? createdAt,
      final DateTime? updatedAt}) = _$ChildbirthRecordImpl;

  factory _ChildbirthRecord.fromJson(Map<String, dynamic> json) =
      _$ChildbirthRecordImpl.fromJson;

  @override
  String get id;
  @override
  String get maternalProfileId;
  @override
  DateTime get deliveryDate;
  @override
  String get deliveryTime;
  @override
  int get durationOfPregnancyWeeks; // Place & Attendant
  @override
  String get placeOfDelivery; // Health facility, Home, Other
  @override
  String? get healthFacilityName;
  @override
  String? get attendant; // Nurse, Midwife, Clinical Officer, Doctor
// Mode of Delivery
  @override
  String get modeOfDelivery; // SVD, Caesarean, Assisted (Vacuum/Forceps)
// Mother's Condition
  @override
  bool? get skinToSkinImmediate;
  @override
  String? get apgarScore1Min;
  @override
  String? get apgarScore5Min;
  @override
  String? get apgarScore10Min;
  @override
  bool? get resuscitationDone;
  @override
  double? get bloodLossMl; // Complications
  @override
  bool? get preEclampsia;
  @override
  bool? get eclampsia;
  @override
  bool? get pph; // Post-partum hemorrhage
  @override
  bool? get obstructedLabour;
  @override
  String? get meconiumGrade; // 0, 1, 2, 3
// Mother's Condition Post-delivery
  @override
  String? get motherCondition; // Drugs Administered to Mother
  @override
  bool? get oxytocinGiven;
  @override
  bool? get misoprostolGiven;
  @override
  bool? get heatStableCarbetocin;
  @override
  bool? get haartGiven; // If HIV positive
  @override
  String? get haartRegimen;
  @override
  String? get otherDrugs; // Baby Details
  @override
  double get birthWeightGrams;
  @override
  double get birthLengthCm;
  @override
  double? get headCircumferenceCm;
  @override
  String? get babyCondition; // Drugs Given to Baby
  @override
  bool? get chxGiven; // Chlorhexidine 7.1%
  @override
  bool? get vitaminKGiven;
  @override
  bool? get teoGiven; // Tetracycline Eye Ointment
// HIV Exposure
  @override
  bool? get babyHivExposed;
  @override
  String? get arvProphylaxisGiven; // AZT+NVP
// Breastfeeding
  @override
  bool? get earlyInitiationBreastfeeding; // Within 1 hour
// Clinical Notes
  @override
  String? get notes;
  @override
  String? get conductedBy;
  @override
  DateTime? get createdAt;
  @override
  DateTime? get updatedAt;

  /// Create a copy of ChildbirthRecord
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ChildbirthRecordImplCopyWith<_$ChildbirthRecordImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
