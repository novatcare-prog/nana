// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'child_profile.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

ChildProfile _$ChildProfileFromJson(Map<String, dynamic> json) {
  return _ChildProfile.fromJson(json);
}

/// @nodoc
mixin _$ChildProfile {
  @JsonKey(name: 'id')
  String get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'maternal_profile_id')
  String get maternalProfileId =>
      throw _privateConstructorUsedError; // A. Particulars of the Child
  @JsonKey(name: 'child_name')
  String get childName => throw _privateConstructorUsedError;
  @JsonKey(name: 'sex')
  String get sex => throw _privateConstructorUsedError;
  @JsonKey(name: 'date_of_birth')
  DateTime get dateOfBirth => throw _privateConstructorUsedError;
  @JsonKey(name: 'date_first_seen')
  DateTime get dateFirstSeen =>
      throw _privateConstructorUsedError; // Birth Details
  @JsonKey(name: 'gestation_at_birth_weeks')
  int get gestationAtBirthWeeks => throw _privateConstructorUsedError;
  @JsonKey(name: 'birth_weight_grams')
  double get birthWeightGrams => throw _privateConstructorUsedError;
  @JsonKey(name: 'birth_length_cm')
  double get birthLengthCm => throw _privateConstructorUsedError;
  @JsonKey(name: 'head_circumference_at_birth_cm')
  double? get headCircumferenceCm =>
      throw _privateConstructorUsedError; // ← FIXED!
  @JsonKey(name: 'other_birth_characteristics')
  String? get otherBirthCharacteristics => throw _privateConstructorUsedError;
  @JsonKey(name: 'birth_order')
  int? get birthOrder => throw _privateConstructorUsedError; // B. Health Record
  @JsonKey(name: 'place_of_birth')
  String get placeOfBirth => throw _privateConstructorUsedError;
  @JsonKey(name: 'health_facility_name')
  String? get healthFacilityName => throw _privateConstructorUsedError;
  @JsonKey(name: 'birth_notification_number')
  String? get birthNotificationNumber => throw _privateConstructorUsedError;
  @JsonKey(name: 'birth_notification_date')
  DateTime? get birthNotificationDate =>
      throw _privateConstructorUsedError; // Registration Numbers
  @JsonKey(name: 'immunization_reg_number')
  String? get immunizationRegNumber => throw _privateConstructorUsedError;
  @JsonKey(name: 'cwc_number')
  String? get cwcNumber => throw _privateConstructorUsedError;
  @JsonKey(name: 'kmhfl_code')
  String? get kmhflCode =>
      throw _privateConstructorUsedError; // C. Civil Registration
  @JsonKey(name: 'birth_certificate_number')
  String? get birthCertificateNumber => throw _privateConstructorUsedError;
  @JsonKey(name: 'birth_registration_date')
  DateTime? get birthRegistrationDate => throw _privateConstructorUsedError;
  @JsonKey(name: 'birth_registration_place')
  String? get birthRegistrationPlace =>
      throw _privateConstructorUsedError; // D. Family Details
  @JsonKey(name: 'father_name')
  String? get fatherName => throw _privateConstructorUsedError;
  @JsonKey(name: 'father_phone')
  String? get fatherPhone => throw _privateConstructorUsedError;
  @JsonKey(name: 'mother_name')
  String? get motherName => throw _privateConstructorUsedError;
  @JsonKey(name: 'mother_phone')
  String? get motherPhone => throw _privateConstructorUsedError;
  @JsonKey(name: 'guardian_name')
  String? get guardianName => throw _privateConstructorUsedError;
  @JsonKey(name: 'guardian_phone')
  String? get guardianPhone => throw _privateConstructorUsedError; // Address
  @JsonKey(name: 'county')
  String? get county => throw _privateConstructorUsedError;
  @JsonKey(name: 'sub_county')
  String? get subCounty => throw _privateConstructorUsedError;
  @JsonKey(name: 'ward')
  String? get ward => throw _privateConstructorUsedError;
  @JsonKey(name: 'village')
  String? get village => throw _privateConstructorUsedError;
  @JsonKey(name: 'physical_address')
  String? get physicalAddress =>
      throw _privateConstructorUsedError; // E. Broad Clinical Review at First Contact
  @JsonKey(name: 'weight_at_first_contact')
  double? get weightAtFirstContact => throw _privateConstructorUsedError;
  @JsonKey(name: 'length_at_first_contact')
  double? get lengthAtFirstContact => throw _privateConstructorUsedError;
  @JsonKey(name: 'z_score')
  String? get zScore => throw _privateConstructorUsedError; // HIV Status
  @JsonKey(name: 'hiv_exposed')
  bool? get hivExposed => throw _privateConstructorUsedError;
  @JsonKey(name: 'hiv_status')
  String? get hivStatus => throw _privateConstructorUsedError;
  @JsonKey(name: 'hiv_test_date')
  DateTime? get hivTestDate => throw _privateConstructorUsedError;
  @JsonKey(name: 'haemoglobin')
  double? get haemoglobin =>
      throw _privateConstructorUsedError; // Physical Features
  @JsonKey(name: 'colouration')
  String? get colouration => throw _privateConstructorUsedError;
  @JsonKey(name: 'eyes')
  String? get eyes => throw _privateConstructorUsedError;
  @JsonKey(name: 'ears')
  String? get ears => throw _privateConstructorUsedError;
  @JsonKey(name: 'mouth')
  String? get mouth => throw _privateConstructorUsedError;
  @JsonKey(name: 'chest')
  String? get chest => throw _privateConstructorUsedError;
  @JsonKey(name: 'heart')
  String? get heart => throw _privateConstructorUsedError;
  @JsonKey(name: 'abdomen')
  String? get abdomen => throw _privateConstructorUsedError;
  @JsonKey(name: 'umbilical_cord')
  String? get umbilicalCord => throw _privateConstructorUsedError;
  @JsonKey(name: 'spine')
  String? get spine => throw _privateConstructorUsedError;
  @JsonKey(name: 'arms_hands')
  String? get armsHands => throw _privateConstructorUsedError;
  @JsonKey(name: 'legs_feet')
  String? get legsFeet => throw _privateConstructorUsedError;
  @JsonKey(name: 'genitalia')
  String? get genitalia => throw _privateConstructorUsedError;
  @JsonKey(name: 'anus')
  String? get anus => throw _privateConstructorUsedError; // TB Screening
  @JsonKey(name: 'tb_screened')
  bool? get tbScreened => throw _privateConstructorUsedError;
  @JsonKey(name: 'tb_screening_result')
  String? get tbScreeningResult =>
      throw _privateConstructorUsedError; // F. Feeding Information
  @JsonKey(name: 'breastfeeding_well')
  bool? get breastfeedingWell => throw _privateConstructorUsedError;
  @JsonKey(name: 'breastfeeding_poorly')
  bool? get breastfeedingPoorly => throw _privateConstructorUsedError;
  @JsonKey(name: 'unable_to_breastfeed')
  bool? get unableToBreastfeed => throw _privateConstructorUsedError;
  @JsonKey(name: 'other_foods_introduced_below_6_months')
  bool? get otherFoodsIntroducedBelow6Months =>
      throw _privateConstructorUsedError;
  @JsonKey(name: 'age_other_foods_introduced')
  int? get ageOtherFoodsIntroduced => throw _privateConstructorUsedError;
  @JsonKey(name: 'complementary_food_from_6_months')
  bool? get complementaryFoodFrom6Months =>
      throw _privateConstructorUsedError; // G. Other Problems Reported
  @JsonKey(name: 'sleep_problems')
  String? get sleepProblems => throw _privateConstructorUsedError;
  @JsonKey(name: 'irritability')
  bool? get irritability => throw _privateConstructorUsedError;
  @JsonKey(name: 'other_problems')
  String? get otherProblems =>
      throw _privateConstructorUsedError; // Reason for Special Care
  @JsonKey(name: 'birth_weight_less_than_2500g')
  bool? get birthWeightLessThan2500g => throw _privateConstructorUsedError;
  @JsonKey(name: 'birth_less_than_2_years_after_last')
  bool? get birthLessThan2YearsAfterLast => throw _privateConstructorUsedError;
  @JsonKey(name: 'fifth_child_or_more')
  bool? get fifthChildOrMore => throw _privateConstructorUsedError;
  @JsonKey(name: 'born_of_teenage_mother')
  bool? get bornOfTeenageMother => throw _privateConstructorUsedError;
  @JsonKey(name: 'born_of_mentally_ill_mother')
  bool? get bornOfMentallyIllMother => throw _privateConstructorUsedError;
  @JsonKey(name: 'developmental_delays')
  bool? get developmentalDelays => throw _privateConstructorUsedError;
  @JsonKey(name: 'sibling_undernourished')
  bool? get siblingUndernourished => throw _privateConstructorUsedError;
  @JsonKey(name: 'multiple_birth')
  bool? get multipleBirth => throw _privateConstructorUsedError;
  @JsonKey(name: 'child_with_special_needs')
  bool? get childWithSpecialNeeds => throw _privateConstructorUsedError;
  @JsonKey(name: 'orphan_vulnerable_child')
  bool? get orphanVulnerableChild => throw _privateConstructorUsedError;
  @JsonKey(name: 'child_with_disability')
  bool? get childWithDisability => throw _privateConstructorUsedError;
  @JsonKey(name: 'history_of_child_abuse')
  bool? get historyOfChildAbuse => throw _privateConstructorUsedError;
  @JsonKey(name: 'cleft_lip_palate')
  bool? get cleftLipPalate => throw _privateConstructorUsedError;
  @JsonKey(name: 'other_special_care_reason')
  String? get otherSpecialCareReason => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_at')
  DateTime? get createdAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'updated_at')
  DateTime? get updatedAt => throw _privateConstructorUsedError;

  /// Serializes this ChildProfile to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ChildProfile
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ChildProfileCopyWith<ChildProfile> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ChildProfileCopyWith<$Res> {
  factory $ChildProfileCopyWith(
          ChildProfile value, $Res Function(ChildProfile) then) =
      _$ChildProfileCopyWithImpl<$Res, ChildProfile>;
  @useResult
  $Res call(
      {@JsonKey(name: 'id') String id,
      @JsonKey(name: 'maternal_profile_id') String maternalProfileId,
      @JsonKey(name: 'child_name') String childName,
      @JsonKey(name: 'sex') String sex,
      @JsonKey(name: 'date_of_birth') DateTime dateOfBirth,
      @JsonKey(name: 'date_first_seen') DateTime dateFirstSeen,
      @JsonKey(name: 'gestation_at_birth_weeks') int gestationAtBirthWeeks,
      @JsonKey(name: 'birth_weight_grams') double birthWeightGrams,
      @JsonKey(name: 'birth_length_cm') double birthLengthCm,
      @JsonKey(name: 'head_circumference_at_birth_cm')
      double? headCircumferenceCm,
      @JsonKey(name: 'other_birth_characteristics')
      String? otherBirthCharacteristics,
      @JsonKey(name: 'birth_order') int? birthOrder,
      @JsonKey(name: 'place_of_birth') String placeOfBirth,
      @JsonKey(name: 'health_facility_name') String? healthFacilityName,
      @JsonKey(name: 'birth_notification_number')
      String? birthNotificationNumber,
      @JsonKey(name: 'birth_notification_date') DateTime? birthNotificationDate,
      @JsonKey(name: 'immunization_reg_number') String? immunizationRegNumber,
      @JsonKey(name: 'cwc_number') String? cwcNumber,
      @JsonKey(name: 'kmhfl_code') String? kmhflCode,
      @JsonKey(name: 'birth_certificate_number') String? birthCertificateNumber,
      @JsonKey(name: 'birth_registration_date') DateTime? birthRegistrationDate,
      @JsonKey(name: 'birth_registration_place') String? birthRegistrationPlace,
      @JsonKey(name: 'father_name') String? fatherName,
      @JsonKey(name: 'father_phone') String? fatherPhone,
      @JsonKey(name: 'mother_name') String? motherName,
      @JsonKey(name: 'mother_phone') String? motherPhone,
      @JsonKey(name: 'guardian_name') String? guardianName,
      @JsonKey(name: 'guardian_phone') String? guardianPhone,
      @JsonKey(name: 'county') String? county,
      @JsonKey(name: 'sub_county') String? subCounty,
      @JsonKey(name: 'ward') String? ward,
      @JsonKey(name: 'village') String? village,
      @JsonKey(name: 'physical_address') String? physicalAddress,
      @JsonKey(name: 'weight_at_first_contact') double? weightAtFirstContact,
      @JsonKey(name: 'length_at_first_contact') double? lengthAtFirstContact,
      @JsonKey(name: 'z_score') String? zScore,
      @JsonKey(name: 'hiv_exposed') bool? hivExposed,
      @JsonKey(name: 'hiv_status') String? hivStatus,
      @JsonKey(name: 'hiv_test_date') DateTime? hivTestDate,
      @JsonKey(name: 'haemoglobin') double? haemoglobin,
      @JsonKey(name: 'colouration') String? colouration,
      @JsonKey(name: 'eyes') String? eyes,
      @JsonKey(name: 'ears') String? ears,
      @JsonKey(name: 'mouth') String? mouth,
      @JsonKey(name: 'chest') String? chest,
      @JsonKey(name: 'heart') String? heart,
      @JsonKey(name: 'abdomen') String? abdomen,
      @JsonKey(name: 'umbilical_cord') String? umbilicalCord,
      @JsonKey(name: 'spine') String? spine,
      @JsonKey(name: 'arms_hands') String? armsHands,
      @JsonKey(name: 'legs_feet') String? legsFeet,
      @JsonKey(name: 'genitalia') String? genitalia,
      @JsonKey(name: 'anus') String? anus,
      @JsonKey(name: 'tb_screened') bool? tbScreened,
      @JsonKey(name: 'tb_screening_result') String? tbScreeningResult,
      @JsonKey(name: 'breastfeeding_well') bool? breastfeedingWell,
      @JsonKey(name: 'breastfeeding_poorly') bool? breastfeedingPoorly,
      @JsonKey(name: 'unable_to_breastfeed') bool? unableToBreastfeed,
      @JsonKey(name: 'other_foods_introduced_below_6_months')
      bool? otherFoodsIntroducedBelow6Months,
      @JsonKey(name: 'age_other_foods_introduced') int? ageOtherFoodsIntroduced,
      @JsonKey(name: 'complementary_food_from_6_months')
      bool? complementaryFoodFrom6Months,
      @JsonKey(name: 'sleep_problems') String? sleepProblems,
      @JsonKey(name: 'irritability') bool? irritability,
      @JsonKey(name: 'other_problems') String? otherProblems,
      @JsonKey(name: 'birth_weight_less_than_2500g')
      bool? birthWeightLessThan2500g,
      @JsonKey(name: 'birth_less_than_2_years_after_last')
      bool? birthLessThan2YearsAfterLast,
      @JsonKey(name: 'fifth_child_or_more') bool? fifthChildOrMore,
      @JsonKey(name: 'born_of_teenage_mother') bool? bornOfTeenageMother,
      @JsonKey(name: 'born_of_mentally_ill_mother')
      bool? bornOfMentallyIllMother,
      @JsonKey(name: 'developmental_delays') bool? developmentalDelays,
      @JsonKey(name: 'sibling_undernourished') bool? siblingUndernourished,
      @JsonKey(name: 'multiple_birth') bool? multipleBirth,
      @JsonKey(name: 'child_with_special_needs') bool? childWithSpecialNeeds,
      @JsonKey(name: 'orphan_vulnerable_child') bool? orphanVulnerableChild,
      @JsonKey(name: 'child_with_disability') bool? childWithDisability,
      @JsonKey(name: 'history_of_child_abuse') bool? historyOfChildAbuse,
      @JsonKey(name: 'cleft_lip_palate') bool? cleftLipPalate,
      @JsonKey(name: 'other_special_care_reason')
      String? otherSpecialCareReason,
      @JsonKey(name: 'created_at') DateTime? createdAt,
      @JsonKey(name: 'updated_at') DateTime? updatedAt});
}

/// @nodoc
class _$ChildProfileCopyWithImpl<$Res, $Val extends ChildProfile>
    implements $ChildProfileCopyWith<$Res> {
  _$ChildProfileCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ChildProfile
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? maternalProfileId = null,
    Object? childName = null,
    Object? sex = null,
    Object? dateOfBirth = null,
    Object? dateFirstSeen = null,
    Object? gestationAtBirthWeeks = null,
    Object? birthWeightGrams = null,
    Object? birthLengthCm = null,
    Object? headCircumferenceCm = freezed,
    Object? otherBirthCharacteristics = freezed,
    Object? birthOrder = freezed,
    Object? placeOfBirth = null,
    Object? healthFacilityName = freezed,
    Object? birthNotificationNumber = freezed,
    Object? birthNotificationDate = freezed,
    Object? immunizationRegNumber = freezed,
    Object? cwcNumber = freezed,
    Object? kmhflCode = freezed,
    Object? birthCertificateNumber = freezed,
    Object? birthRegistrationDate = freezed,
    Object? birthRegistrationPlace = freezed,
    Object? fatherName = freezed,
    Object? fatherPhone = freezed,
    Object? motherName = freezed,
    Object? motherPhone = freezed,
    Object? guardianName = freezed,
    Object? guardianPhone = freezed,
    Object? county = freezed,
    Object? subCounty = freezed,
    Object? ward = freezed,
    Object? village = freezed,
    Object? physicalAddress = freezed,
    Object? weightAtFirstContact = freezed,
    Object? lengthAtFirstContact = freezed,
    Object? zScore = freezed,
    Object? hivExposed = freezed,
    Object? hivStatus = freezed,
    Object? hivTestDate = freezed,
    Object? haemoglobin = freezed,
    Object? colouration = freezed,
    Object? eyes = freezed,
    Object? ears = freezed,
    Object? mouth = freezed,
    Object? chest = freezed,
    Object? heart = freezed,
    Object? abdomen = freezed,
    Object? umbilicalCord = freezed,
    Object? spine = freezed,
    Object? armsHands = freezed,
    Object? legsFeet = freezed,
    Object? genitalia = freezed,
    Object? anus = freezed,
    Object? tbScreened = freezed,
    Object? tbScreeningResult = freezed,
    Object? breastfeedingWell = freezed,
    Object? breastfeedingPoorly = freezed,
    Object? unableToBreastfeed = freezed,
    Object? otherFoodsIntroducedBelow6Months = freezed,
    Object? ageOtherFoodsIntroduced = freezed,
    Object? complementaryFoodFrom6Months = freezed,
    Object? sleepProblems = freezed,
    Object? irritability = freezed,
    Object? otherProblems = freezed,
    Object? birthWeightLessThan2500g = freezed,
    Object? birthLessThan2YearsAfterLast = freezed,
    Object? fifthChildOrMore = freezed,
    Object? bornOfTeenageMother = freezed,
    Object? bornOfMentallyIllMother = freezed,
    Object? developmentalDelays = freezed,
    Object? siblingUndernourished = freezed,
    Object? multipleBirth = freezed,
    Object? childWithSpecialNeeds = freezed,
    Object? orphanVulnerableChild = freezed,
    Object? childWithDisability = freezed,
    Object? historyOfChildAbuse = freezed,
    Object? cleftLipPalate = freezed,
    Object? otherSpecialCareReason = freezed,
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
      childName: null == childName
          ? _value.childName
          : childName // ignore: cast_nullable_to_non_nullable
              as String,
      sex: null == sex
          ? _value.sex
          : sex // ignore: cast_nullable_to_non_nullable
              as String,
      dateOfBirth: null == dateOfBirth
          ? _value.dateOfBirth
          : dateOfBirth // ignore: cast_nullable_to_non_nullable
              as DateTime,
      dateFirstSeen: null == dateFirstSeen
          ? _value.dateFirstSeen
          : dateFirstSeen // ignore: cast_nullable_to_non_nullable
              as DateTime,
      gestationAtBirthWeeks: null == gestationAtBirthWeeks
          ? _value.gestationAtBirthWeeks
          : gestationAtBirthWeeks // ignore: cast_nullable_to_non_nullable
              as int,
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
      otherBirthCharacteristics: freezed == otherBirthCharacteristics
          ? _value.otherBirthCharacteristics
          : otherBirthCharacteristics // ignore: cast_nullable_to_non_nullable
              as String?,
      birthOrder: freezed == birthOrder
          ? _value.birthOrder
          : birthOrder // ignore: cast_nullable_to_non_nullable
              as int?,
      placeOfBirth: null == placeOfBirth
          ? _value.placeOfBirth
          : placeOfBirth // ignore: cast_nullable_to_non_nullable
              as String,
      healthFacilityName: freezed == healthFacilityName
          ? _value.healthFacilityName
          : healthFacilityName // ignore: cast_nullable_to_non_nullable
              as String?,
      birthNotificationNumber: freezed == birthNotificationNumber
          ? _value.birthNotificationNumber
          : birthNotificationNumber // ignore: cast_nullable_to_non_nullable
              as String?,
      birthNotificationDate: freezed == birthNotificationDate
          ? _value.birthNotificationDate
          : birthNotificationDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      immunizationRegNumber: freezed == immunizationRegNumber
          ? _value.immunizationRegNumber
          : immunizationRegNumber // ignore: cast_nullable_to_non_nullable
              as String?,
      cwcNumber: freezed == cwcNumber
          ? _value.cwcNumber
          : cwcNumber // ignore: cast_nullable_to_non_nullable
              as String?,
      kmhflCode: freezed == kmhflCode
          ? _value.kmhflCode
          : kmhflCode // ignore: cast_nullable_to_non_nullable
              as String?,
      birthCertificateNumber: freezed == birthCertificateNumber
          ? _value.birthCertificateNumber
          : birthCertificateNumber // ignore: cast_nullable_to_non_nullable
              as String?,
      birthRegistrationDate: freezed == birthRegistrationDate
          ? _value.birthRegistrationDate
          : birthRegistrationDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      birthRegistrationPlace: freezed == birthRegistrationPlace
          ? _value.birthRegistrationPlace
          : birthRegistrationPlace // ignore: cast_nullable_to_non_nullable
              as String?,
      fatherName: freezed == fatherName
          ? _value.fatherName
          : fatherName // ignore: cast_nullable_to_non_nullable
              as String?,
      fatherPhone: freezed == fatherPhone
          ? _value.fatherPhone
          : fatherPhone // ignore: cast_nullable_to_non_nullable
              as String?,
      motherName: freezed == motherName
          ? _value.motherName
          : motherName // ignore: cast_nullable_to_non_nullable
              as String?,
      motherPhone: freezed == motherPhone
          ? _value.motherPhone
          : motherPhone // ignore: cast_nullable_to_non_nullable
              as String?,
      guardianName: freezed == guardianName
          ? _value.guardianName
          : guardianName // ignore: cast_nullable_to_non_nullable
              as String?,
      guardianPhone: freezed == guardianPhone
          ? _value.guardianPhone
          : guardianPhone // ignore: cast_nullable_to_non_nullable
              as String?,
      county: freezed == county
          ? _value.county
          : county // ignore: cast_nullable_to_non_nullable
              as String?,
      subCounty: freezed == subCounty
          ? _value.subCounty
          : subCounty // ignore: cast_nullable_to_non_nullable
              as String?,
      ward: freezed == ward
          ? _value.ward
          : ward // ignore: cast_nullable_to_non_nullable
              as String?,
      village: freezed == village
          ? _value.village
          : village // ignore: cast_nullable_to_non_nullable
              as String?,
      physicalAddress: freezed == physicalAddress
          ? _value.physicalAddress
          : physicalAddress // ignore: cast_nullable_to_non_nullable
              as String?,
      weightAtFirstContact: freezed == weightAtFirstContact
          ? _value.weightAtFirstContact
          : weightAtFirstContact // ignore: cast_nullable_to_non_nullable
              as double?,
      lengthAtFirstContact: freezed == lengthAtFirstContact
          ? _value.lengthAtFirstContact
          : lengthAtFirstContact // ignore: cast_nullable_to_non_nullable
              as double?,
      zScore: freezed == zScore
          ? _value.zScore
          : zScore // ignore: cast_nullable_to_non_nullable
              as String?,
      hivExposed: freezed == hivExposed
          ? _value.hivExposed
          : hivExposed // ignore: cast_nullable_to_non_nullable
              as bool?,
      hivStatus: freezed == hivStatus
          ? _value.hivStatus
          : hivStatus // ignore: cast_nullable_to_non_nullable
              as String?,
      hivTestDate: freezed == hivTestDate
          ? _value.hivTestDate
          : hivTestDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      haemoglobin: freezed == haemoglobin
          ? _value.haemoglobin
          : haemoglobin // ignore: cast_nullable_to_non_nullable
              as double?,
      colouration: freezed == colouration
          ? _value.colouration
          : colouration // ignore: cast_nullable_to_non_nullable
              as String?,
      eyes: freezed == eyes
          ? _value.eyes
          : eyes // ignore: cast_nullable_to_non_nullable
              as String?,
      ears: freezed == ears
          ? _value.ears
          : ears // ignore: cast_nullable_to_non_nullable
              as String?,
      mouth: freezed == mouth
          ? _value.mouth
          : mouth // ignore: cast_nullable_to_non_nullable
              as String?,
      chest: freezed == chest
          ? _value.chest
          : chest // ignore: cast_nullable_to_non_nullable
              as String?,
      heart: freezed == heart
          ? _value.heart
          : heart // ignore: cast_nullable_to_non_nullable
              as String?,
      abdomen: freezed == abdomen
          ? _value.abdomen
          : abdomen // ignore: cast_nullable_to_non_nullable
              as String?,
      umbilicalCord: freezed == umbilicalCord
          ? _value.umbilicalCord
          : umbilicalCord // ignore: cast_nullable_to_non_nullable
              as String?,
      spine: freezed == spine
          ? _value.spine
          : spine // ignore: cast_nullable_to_non_nullable
              as String?,
      armsHands: freezed == armsHands
          ? _value.armsHands
          : armsHands // ignore: cast_nullable_to_non_nullable
              as String?,
      legsFeet: freezed == legsFeet
          ? _value.legsFeet
          : legsFeet // ignore: cast_nullable_to_non_nullable
              as String?,
      genitalia: freezed == genitalia
          ? _value.genitalia
          : genitalia // ignore: cast_nullable_to_non_nullable
              as String?,
      anus: freezed == anus
          ? _value.anus
          : anus // ignore: cast_nullable_to_non_nullable
              as String?,
      tbScreened: freezed == tbScreened
          ? _value.tbScreened
          : tbScreened // ignore: cast_nullable_to_non_nullable
              as bool?,
      tbScreeningResult: freezed == tbScreeningResult
          ? _value.tbScreeningResult
          : tbScreeningResult // ignore: cast_nullable_to_non_nullable
              as String?,
      breastfeedingWell: freezed == breastfeedingWell
          ? _value.breastfeedingWell
          : breastfeedingWell // ignore: cast_nullable_to_non_nullable
              as bool?,
      breastfeedingPoorly: freezed == breastfeedingPoorly
          ? _value.breastfeedingPoorly
          : breastfeedingPoorly // ignore: cast_nullable_to_non_nullable
              as bool?,
      unableToBreastfeed: freezed == unableToBreastfeed
          ? _value.unableToBreastfeed
          : unableToBreastfeed // ignore: cast_nullable_to_non_nullable
              as bool?,
      otherFoodsIntroducedBelow6Months: freezed ==
              otherFoodsIntroducedBelow6Months
          ? _value.otherFoodsIntroducedBelow6Months
          : otherFoodsIntroducedBelow6Months // ignore: cast_nullable_to_non_nullable
              as bool?,
      ageOtherFoodsIntroduced: freezed == ageOtherFoodsIntroduced
          ? _value.ageOtherFoodsIntroduced
          : ageOtherFoodsIntroduced // ignore: cast_nullable_to_non_nullable
              as int?,
      complementaryFoodFrom6Months: freezed == complementaryFoodFrom6Months
          ? _value.complementaryFoodFrom6Months
          : complementaryFoodFrom6Months // ignore: cast_nullable_to_non_nullable
              as bool?,
      sleepProblems: freezed == sleepProblems
          ? _value.sleepProblems
          : sleepProblems // ignore: cast_nullable_to_non_nullable
              as String?,
      irritability: freezed == irritability
          ? _value.irritability
          : irritability // ignore: cast_nullable_to_non_nullable
              as bool?,
      otherProblems: freezed == otherProblems
          ? _value.otherProblems
          : otherProblems // ignore: cast_nullable_to_non_nullable
              as String?,
      birthWeightLessThan2500g: freezed == birthWeightLessThan2500g
          ? _value.birthWeightLessThan2500g
          : birthWeightLessThan2500g // ignore: cast_nullable_to_non_nullable
              as bool?,
      birthLessThan2YearsAfterLast: freezed == birthLessThan2YearsAfterLast
          ? _value.birthLessThan2YearsAfterLast
          : birthLessThan2YearsAfterLast // ignore: cast_nullable_to_non_nullable
              as bool?,
      fifthChildOrMore: freezed == fifthChildOrMore
          ? _value.fifthChildOrMore
          : fifthChildOrMore // ignore: cast_nullable_to_non_nullable
              as bool?,
      bornOfTeenageMother: freezed == bornOfTeenageMother
          ? _value.bornOfTeenageMother
          : bornOfTeenageMother // ignore: cast_nullable_to_non_nullable
              as bool?,
      bornOfMentallyIllMother: freezed == bornOfMentallyIllMother
          ? _value.bornOfMentallyIllMother
          : bornOfMentallyIllMother // ignore: cast_nullable_to_non_nullable
              as bool?,
      developmentalDelays: freezed == developmentalDelays
          ? _value.developmentalDelays
          : developmentalDelays // ignore: cast_nullable_to_non_nullable
              as bool?,
      siblingUndernourished: freezed == siblingUndernourished
          ? _value.siblingUndernourished
          : siblingUndernourished // ignore: cast_nullable_to_non_nullable
              as bool?,
      multipleBirth: freezed == multipleBirth
          ? _value.multipleBirth
          : multipleBirth // ignore: cast_nullable_to_non_nullable
              as bool?,
      childWithSpecialNeeds: freezed == childWithSpecialNeeds
          ? _value.childWithSpecialNeeds
          : childWithSpecialNeeds // ignore: cast_nullable_to_non_nullable
              as bool?,
      orphanVulnerableChild: freezed == orphanVulnerableChild
          ? _value.orphanVulnerableChild
          : orphanVulnerableChild // ignore: cast_nullable_to_non_nullable
              as bool?,
      childWithDisability: freezed == childWithDisability
          ? _value.childWithDisability
          : childWithDisability // ignore: cast_nullable_to_non_nullable
              as bool?,
      historyOfChildAbuse: freezed == historyOfChildAbuse
          ? _value.historyOfChildAbuse
          : historyOfChildAbuse // ignore: cast_nullable_to_non_nullable
              as bool?,
      cleftLipPalate: freezed == cleftLipPalate
          ? _value.cleftLipPalate
          : cleftLipPalate // ignore: cast_nullable_to_non_nullable
              as bool?,
      otherSpecialCareReason: freezed == otherSpecialCareReason
          ? _value.otherSpecialCareReason
          : otherSpecialCareReason // ignore: cast_nullable_to_non_nullable
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
abstract class _$$ChildProfileImplCopyWith<$Res>
    implements $ChildProfileCopyWith<$Res> {
  factory _$$ChildProfileImplCopyWith(
          _$ChildProfileImpl value, $Res Function(_$ChildProfileImpl) then) =
      __$$ChildProfileImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'id') String id,
      @JsonKey(name: 'maternal_profile_id') String maternalProfileId,
      @JsonKey(name: 'child_name') String childName,
      @JsonKey(name: 'sex') String sex,
      @JsonKey(name: 'date_of_birth') DateTime dateOfBirth,
      @JsonKey(name: 'date_first_seen') DateTime dateFirstSeen,
      @JsonKey(name: 'gestation_at_birth_weeks') int gestationAtBirthWeeks,
      @JsonKey(name: 'birth_weight_grams') double birthWeightGrams,
      @JsonKey(name: 'birth_length_cm') double birthLengthCm,
      @JsonKey(name: 'head_circumference_at_birth_cm')
      double? headCircumferenceCm,
      @JsonKey(name: 'other_birth_characteristics')
      String? otherBirthCharacteristics,
      @JsonKey(name: 'birth_order') int? birthOrder,
      @JsonKey(name: 'place_of_birth') String placeOfBirth,
      @JsonKey(name: 'health_facility_name') String? healthFacilityName,
      @JsonKey(name: 'birth_notification_number')
      String? birthNotificationNumber,
      @JsonKey(name: 'birth_notification_date') DateTime? birthNotificationDate,
      @JsonKey(name: 'immunization_reg_number') String? immunizationRegNumber,
      @JsonKey(name: 'cwc_number') String? cwcNumber,
      @JsonKey(name: 'kmhfl_code') String? kmhflCode,
      @JsonKey(name: 'birth_certificate_number') String? birthCertificateNumber,
      @JsonKey(name: 'birth_registration_date') DateTime? birthRegistrationDate,
      @JsonKey(name: 'birth_registration_place') String? birthRegistrationPlace,
      @JsonKey(name: 'father_name') String? fatherName,
      @JsonKey(name: 'father_phone') String? fatherPhone,
      @JsonKey(name: 'mother_name') String? motherName,
      @JsonKey(name: 'mother_phone') String? motherPhone,
      @JsonKey(name: 'guardian_name') String? guardianName,
      @JsonKey(name: 'guardian_phone') String? guardianPhone,
      @JsonKey(name: 'county') String? county,
      @JsonKey(name: 'sub_county') String? subCounty,
      @JsonKey(name: 'ward') String? ward,
      @JsonKey(name: 'village') String? village,
      @JsonKey(name: 'physical_address') String? physicalAddress,
      @JsonKey(name: 'weight_at_first_contact') double? weightAtFirstContact,
      @JsonKey(name: 'length_at_first_contact') double? lengthAtFirstContact,
      @JsonKey(name: 'z_score') String? zScore,
      @JsonKey(name: 'hiv_exposed') bool? hivExposed,
      @JsonKey(name: 'hiv_status') String? hivStatus,
      @JsonKey(name: 'hiv_test_date') DateTime? hivTestDate,
      @JsonKey(name: 'haemoglobin') double? haemoglobin,
      @JsonKey(name: 'colouration') String? colouration,
      @JsonKey(name: 'eyes') String? eyes,
      @JsonKey(name: 'ears') String? ears,
      @JsonKey(name: 'mouth') String? mouth,
      @JsonKey(name: 'chest') String? chest,
      @JsonKey(name: 'heart') String? heart,
      @JsonKey(name: 'abdomen') String? abdomen,
      @JsonKey(name: 'umbilical_cord') String? umbilicalCord,
      @JsonKey(name: 'spine') String? spine,
      @JsonKey(name: 'arms_hands') String? armsHands,
      @JsonKey(name: 'legs_feet') String? legsFeet,
      @JsonKey(name: 'genitalia') String? genitalia,
      @JsonKey(name: 'anus') String? anus,
      @JsonKey(name: 'tb_screened') bool? tbScreened,
      @JsonKey(name: 'tb_screening_result') String? tbScreeningResult,
      @JsonKey(name: 'breastfeeding_well') bool? breastfeedingWell,
      @JsonKey(name: 'breastfeeding_poorly') bool? breastfeedingPoorly,
      @JsonKey(name: 'unable_to_breastfeed') bool? unableToBreastfeed,
      @JsonKey(name: 'other_foods_introduced_below_6_months')
      bool? otherFoodsIntroducedBelow6Months,
      @JsonKey(name: 'age_other_foods_introduced') int? ageOtherFoodsIntroduced,
      @JsonKey(name: 'complementary_food_from_6_months')
      bool? complementaryFoodFrom6Months,
      @JsonKey(name: 'sleep_problems') String? sleepProblems,
      @JsonKey(name: 'irritability') bool? irritability,
      @JsonKey(name: 'other_problems') String? otherProblems,
      @JsonKey(name: 'birth_weight_less_than_2500g')
      bool? birthWeightLessThan2500g,
      @JsonKey(name: 'birth_less_than_2_years_after_last')
      bool? birthLessThan2YearsAfterLast,
      @JsonKey(name: 'fifth_child_or_more') bool? fifthChildOrMore,
      @JsonKey(name: 'born_of_teenage_mother') bool? bornOfTeenageMother,
      @JsonKey(name: 'born_of_mentally_ill_mother')
      bool? bornOfMentallyIllMother,
      @JsonKey(name: 'developmental_delays') bool? developmentalDelays,
      @JsonKey(name: 'sibling_undernourished') bool? siblingUndernourished,
      @JsonKey(name: 'multiple_birth') bool? multipleBirth,
      @JsonKey(name: 'child_with_special_needs') bool? childWithSpecialNeeds,
      @JsonKey(name: 'orphan_vulnerable_child') bool? orphanVulnerableChild,
      @JsonKey(name: 'child_with_disability') bool? childWithDisability,
      @JsonKey(name: 'history_of_child_abuse') bool? historyOfChildAbuse,
      @JsonKey(name: 'cleft_lip_palate') bool? cleftLipPalate,
      @JsonKey(name: 'other_special_care_reason')
      String? otherSpecialCareReason,
      @JsonKey(name: 'created_at') DateTime? createdAt,
      @JsonKey(name: 'updated_at') DateTime? updatedAt});
}

/// @nodoc
class __$$ChildProfileImplCopyWithImpl<$Res>
    extends _$ChildProfileCopyWithImpl<$Res, _$ChildProfileImpl>
    implements _$$ChildProfileImplCopyWith<$Res> {
  __$$ChildProfileImplCopyWithImpl(
      _$ChildProfileImpl _value, $Res Function(_$ChildProfileImpl) _then)
      : super(_value, _then);

  /// Create a copy of ChildProfile
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? maternalProfileId = null,
    Object? childName = null,
    Object? sex = null,
    Object? dateOfBirth = null,
    Object? dateFirstSeen = null,
    Object? gestationAtBirthWeeks = null,
    Object? birthWeightGrams = null,
    Object? birthLengthCm = null,
    Object? headCircumferenceCm = freezed,
    Object? otherBirthCharacteristics = freezed,
    Object? birthOrder = freezed,
    Object? placeOfBirth = null,
    Object? healthFacilityName = freezed,
    Object? birthNotificationNumber = freezed,
    Object? birthNotificationDate = freezed,
    Object? immunizationRegNumber = freezed,
    Object? cwcNumber = freezed,
    Object? kmhflCode = freezed,
    Object? birthCertificateNumber = freezed,
    Object? birthRegistrationDate = freezed,
    Object? birthRegistrationPlace = freezed,
    Object? fatherName = freezed,
    Object? fatherPhone = freezed,
    Object? motherName = freezed,
    Object? motherPhone = freezed,
    Object? guardianName = freezed,
    Object? guardianPhone = freezed,
    Object? county = freezed,
    Object? subCounty = freezed,
    Object? ward = freezed,
    Object? village = freezed,
    Object? physicalAddress = freezed,
    Object? weightAtFirstContact = freezed,
    Object? lengthAtFirstContact = freezed,
    Object? zScore = freezed,
    Object? hivExposed = freezed,
    Object? hivStatus = freezed,
    Object? hivTestDate = freezed,
    Object? haemoglobin = freezed,
    Object? colouration = freezed,
    Object? eyes = freezed,
    Object? ears = freezed,
    Object? mouth = freezed,
    Object? chest = freezed,
    Object? heart = freezed,
    Object? abdomen = freezed,
    Object? umbilicalCord = freezed,
    Object? spine = freezed,
    Object? armsHands = freezed,
    Object? legsFeet = freezed,
    Object? genitalia = freezed,
    Object? anus = freezed,
    Object? tbScreened = freezed,
    Object? tbScreeningResult = freezed,
    Object? breastfeedingWell = freezed,
    Object? breastfeedingPoorly = freezed,
    Object? unableToBreastfeed = freezed,
    Object? otherFoodsIntroducedBelow6Months = freezed,
    Object? ageOtherFoodsIntroduced = freezed,
    Object? complementaryFoodFrom6Months = freezed,
    Object? sleepProblems = freezed,
    Object? irritability = freezed,
    Object? otherProblems = freezed,
    Object? birthWeightLessThan2500g = freezed,
    Object? birthLessThan2YearsAfterLast = freezed,
    Object? fifthChildOrMore = freezed,
    Object? bornOfTeenageMother = freezed,
    Object? bornOfMentallyIllMother = freezed,
    Object? developmentalDelays = freezed,
    Object? siblingUndernourished = freezed,
    Object? multipleBirth = freezed,
    Object? childWithSpecialNeeds = freezed,
    Object? orphanVulnerableChild = freezed,
    Object? childWithDisability = freezed,
    Object? historyOfChildAbuse = freezed,
    Object? cleftLipPalate = freezed,
    Object? otherSpecialCareReason = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(_$ChildProfileImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      maternalProfileId: null == maternalProfileId
          ? _value.maternalProfileId
          : maternalProfileId // ignore: cast_nullable_to_non_nullable
              as String,
      childName: null == childName
          ? _value.childName
          : childName // ignore: cast_nullable_to_non_nullable
              as String,
      sex: null == sex
          ? _value.sex
          : sex // ignore: cast_nullable_to_non_nullable
              as String,
      dateOfBirth: null == dateOfBirth
          ? _value.dateOfBirth
          : dateOfBirth // ignore: cast_nullable_to_non_nullable
              as DateTime,
      dateFirstSeen: null == dateFirstSeen
          ? _value.dateFirstSeen
          : dateFirstSeen // ignore: cast_nullable_to_non_nullable
              as DateTime,
      gestationAtBirthWeeks: null == gestationAtBirthWeeks
          ? _value.gestationAtBirthWeeks
          : gestationAtBirthWeeks // ignore: cast_nullable_to_non_nullable
              as int,
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
      otherBirthCharacteristics: freezed == otherBirthCharacteristics
          ? _value.otherBirthCharacteristics
          : otherBirthCharacteristics // ignore: cast_nullable_to_non_nullable
              as String?,
      birthOrder: freezed == birthOrder
          ? _value.birthOrder
          : birthOrder // ignore: cast_nullable_to_non_nullable
              as int?,
      placeOfBirth: null == placeOfBirth
          ? _value.placeOfBirth
          : placeOfBirth // ignore: cast_nullable_to_non_nullable
              as String,
      healthFacilityName: freezed == healthFacilityName
          ? _value.healthFacilityName
          : healthFacilityName // ignore: cast_nullable_to_non_nullable
              as String?,
      birthNotificationNumber: freezed == birthNotificationNumber
          ? _value.birthNotificationNumber
          : birthNotificationNumber // ignore: cast_nullable_to_non_nullable
              as String?,
      birthNotificationDate: freezed == birthNotificationDate
          ? _value.birthNotificationDate
          : birthNotificationDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      immunizationRegNumber: freezed == immunizationRegNumber
          ? _value.immunizationRegNumber
          : immunizationRegNumber // ignore: cast_nullable_to_non_nullable
              as String?,
      cwcNumber: freezed == cwcNumber
          ? _value.cwcNumber
          : cwcNumber // ignore: cast_nullable_to_non_nullable
              as String?,
      kmhflCode: freezed == kmhflCode
          ? _value.kmhflCode
          : kmhflCode // ignore: cast_nullable_to_non_nullable
              as String?,
      birthCertificateNumber: freezed == birthCertificateNumber
          ? _value.birthCertificateNumber
          : birthCertificateNumber // ignore: cast_nullable_to_non_nullable
              as String?,
      birthRegistrationDate: freezed == birthRegistrationDate
          ? _value.birthRegistrationDate
          : birthRegistrationDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      birthRegistrationPlace: freezed == birthRegistrationPlace
          ? _value.birthRegistrationPlace
          : birthRegistrationPlace // ignore: cast_nullable_to_non_nullable
              as String?,
      fatherName: freezed == fatherName
          ? _value.fatherName
          : fatherName // ignore: cast_nullable_to_non_nullable
              as String?,
      fatherPhone: freezed == fatherPhone
          ? _value.fatherPhone
          : fatherPhone // ignore: cast_nullable_to_non_nullable
              as String?,
      motherName: freezed == motherName
          ? _value.motherName
          : motherName // ignore: cast_nullable_to_non_nullable
              as String?,
      motherPhone: freezed == motherPhone
          ? _value.motherPhone
          : motherPhone // ignore: cast_nullable_to_non_nullable
              as String?,
      guardianName: freezed == guardianName
          ? _value.guardianName
          : guardianName // ignore: cast_nullable_to_non_nullable
              as String?,
      guardianPhone: freezed == guardianPhone
          ? _value.guardianPhone
          : guardianPhone // ignore: cast_nullable_to_non_nullable
              as String?,
      county: freezed == county
          ? _value.county
          : county // ignore: cast_nullable_to_non_nullable
              as String?,
      subCounty: freezed == subCounty
          ? _value.subCounty
          : subCounty // ignore: cast_nullable_to_non_nullable
              as String?,
      ward: freezed == ward
          ? _value.ward
          : ward // ignore: cast_nullable_to_non_nullable
              as String?,
      village: freezed == village
          ? _value.village
          : village // ignore: cast_nullable_to_non_nullable
              as String?,
      physicalAddress: freezed == physicalAddress
          ? _value.physicalAddress
          : physicalAddress // ignore: cast_nullable_to_non_nullable
              as String?,
      weightAtFirstContact: freezed == weightAtFirstContact
          ? _value.weightAtFirstContact
          : weightAtFirstContact // ignore: cast_nullable_to_non_nullable
              as double?,
      lengthAtFirstContact: freezed == lengthAtFirstContact
          ? _value.lengthAtFirstContact
          : lengthAtFirstContact // ignore: cast_nullable_to_non_nullable
              as double?,
      zScore: freezed == zScore
          ? _value.zScore
          : zScore // ignore: cast_nullable_to_non_nullable
              as String?,
      hivExposed: freezed == hivExposed
          ? _value.hivExposed
          : hivExposed // ignore: cast_nullable_to_non_nullable
              as bool?,
      hivStatus: freezed == hivStatus
          ? _value.hivStatus
          : hivStatus // ignore: cast_nullable_to_non_nullable
              as String?,
      hivTestDate: freezed == hivTestDate
          ? _value.hivTestDate
          : hivTestDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      haemoglobin: freezed == haemoglobin
          ? _value.haemoglobin
          : haemoglobin // ignore: cast_nullable_to_non_nullable
              as double?,
      colouration: freezed == colouration
          ? _value.colouration
          : colouration // ignore: cast_nullable_to_non_nullable
              as String?,
      eyes: freezed == eyes
          ? _value.eyes
          : eyes // ignore: cast_nullable_to_non_nullable
              as String?,
      ears: freezed == ears
          ? _value.ears
          : ears // ignore: cast_nullable_to_non_nullable
              as String?,
      mouth: freezed == mouth
          ? _value.mouth
          : mouth // ignore: cast_nullable_to_non_nullable
              as String?,
      chest: freezed == chest
          ? _value.chest
          : chest // ignore: cast_nullable_to_non_nullable
              as String?,
      heart: freezed == heart
          ? _value.heart
          : heart // ignore: cast_nullable_to_non_nullable
              as String?,
      abdomen: freezed == abdomen
          ? _value.abdomen
          : abdomen // ignore: cast_nullable_to_non_nullable
              as String?,
      umbilicalCord: freezed == umbilicalCord
          ? _value.umbilicalCord
          : umbilicalCord // ignore: cast_nullable_to_non_nullable
              as String?,
      spine: freezed == spine
          ? _value.spine
          : spine // ignore: cast_nullable_to_non_nullable
              as String?,
      armsHands: freezed == armsHands
          ? _value.armsHands
          : armsHands // ignore: cast_nullable_to_non_nullable
              as String?,
      legsFeet: freezed == legsFeet
          ? _value.legsFeet
          : legsFeet // ignore: cast_nullable_to_non_nullable
              as String?,
      genitalia: freezed == genitalia
          ? _value.genitalia
          : genitalia // ignore: cast_nullable_to_non_nullable
              as String?,
      anus: freezed == anus
          ? _value.anus
          : anus // ignore: cast_nullable_to_non_nullable
              as String?,
      tbScreened: freezed == tbScreened
          ? _value.tbScreened
          : tbScreened // ignore: cast_nullable_to_non_nullable
              as bool?,
      tbScreeningResult: freezed == tbScreeningResult
          ? _value.tbScreeningResult
          : tbScreeningResult // ignore: cast_nullable_to_non_nullable
              as String?,
      breastfeedingWell: freezed == breastfeedingWell
          ? _value.breastfeedingWell
          : breastfeedingWell // ignore: cast_nullable_to_non_nullable
              as bool?,
      breastfeedingPoorly: freezed == breastfeedingPoorly
          ? _value.breastfeedingPoorly
          : breastfeedingPoorly // ignore: cast_nullable_to_non_nullable
              as bool?,
      unableToBreastfeed: freezed == unableToBreastfeed
          ? _value.unableToBreastfeed
          : unableToBreastfeed // ignore: cast_nullable_to_non_nullable
              as bool?,
      otherFoodsIntroducedBelow6Months: freezed ==
              otherFoodsIntroducedBelow6Months
          ? _value.otherFoodsIntroducedBelow6Months
          : otherFoodsIntroducedBelow6Months // ignore: cast_nullable_to_non_nullable
              as bool?,
      ageOtherFoodsIntroduced: freezed == ageOtherFoodsIntroduced
          ? _value.ageOtherFoodsIntroduced
          : ageOtherFoodsIntroduced // ignore: cast_nullable_to_non_nullable
              as int?,
      complementaryFoodFrom6Months: freezed == complementaryFoodFrom6Months
          ? _value.complementaryFoodFrom6Months
          : complementaryFoodFrom6Months // ignore: cast_nullable_to_non_nullable
              as bool?,
      sleepProblems: freezed == sleepProblems
          ? _value.sleepProblems
          : sleepProblems // ignore: cast_nullable_to_non_nullable
              as String?,
      irritability: freezed == irritability
          ? _value.irritability
          : irritability // ignore: cast_nullable_to_non_nullable
              as bool?,
      otherProblems: freezed == otherProblems
          ? _value.otherProblems
          : otherProblems // ignore: cast_nullable_to_non_nullable
              as String?,
      birthWeightLessThan2500g: freezed == birthWeightLessThan2500g
          ? _value.birthWeightLessThan2500g
          : birthWeightLessThan2500g // ignore: cast_nullable_to_non_nullable
              as bool?,
      birthLessThan2YearsAfterLast: freezed == birthLessThan2YearsAfterLast
          ? _value.birthLessThan2YearsAfterLast
          : birthLessThan2YearsAfterLast // ignore: cast_nullable_to_non_nullable
              as bool?,
      fifthChildOrMore: freezed == fifthChildOrMore
          ? _value.fifthChildOrMore
          : fifthChildOrMore // ignore: cast_nullable_to_non_nullable
              as bool?,
      bornOfTeenageMother: freezed == bornOfTeenageMother
          ? _value.bornOfTeenageMother
          : bornOfTeenageMother // ignore: cast_nullable_to_non_nullable
              as bool?,
      bornOfMentallyIllMother: freezed == bornOfMentallyIllMother
          ? _value.bornOfMentallyIllMother
          : bornOfMentallyIllMother // ignore: cast_nullable_to_non_nullable
              as bool?,
      developmentalDelays: freezed == developmentalDelays
          ? _value.developmentalDelays
          : developmentalDelays // ignore: cast_nullable_to_non_nullable
              as bool?,
      siblingUndernourished: freezed == siblingUndernourished
          ? _value.siblingUndernourished
          : siblingUndernourished // ignore: cast_nullable_to_non_nullable
              as bool?,
      multipleBirth: freezed == multipleBirth
          ? _value.multipleBirth
          : multipleBirth // ignore: cast_nullable_to_non_nullable
              as bool?,
      childWithSpecialNeeds: freezed == childWithSpecialNeeds
          ? _value.childWithSpecialNeeds
          : childWithSpecialNeeds // ignore: cast_nullable_to_non_nullable
              as bool?,
      orphanVulnerableChild: freezed == orphanVulnerableChild
          ? _value.orphanVulnerableChild
          : orphanVulnerableChild // ignore: cast_nullable_to_non_nullable
              as bool?,
      childWithDisability: freezed == childWithDisability
          ? _value.childWithDisability
          : childWithDisability // ignore: cast_nullable_to_non_nullable
              as bool?,
      historyOfChildAbuse: freezed == historyOfChildAbuse
          ? _value.historyOfChildAbuse
          : historyOfChildAbuse // ignore: cast_nullable_to_non_nullable
              as bool?,
      cleftLipPalate: freezed == cleftLipPalate
          ? _value.cleftLipPalate
          : cleftLipPalate // ignore: cast_nullable_to_non_nullable
              as bool?,
      otherSpecialCareReason: freezed == otherSpecialCareReason
          ? _value.otherSpecialCareReason
          : otherSpecialCareReason // ignore: cast_nullable_to_non_nullable
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
class _$ChildProfileImpl implements _ChildProfile {
  const _$ChildProfileImpl(
      {@JsonKey(name: 'id') required this.id,
      @JsonKey(name: 'maternal_profile_id') required this.maternalProfileId,
      @JsonKey(name: 'child_name') required this.childName,
      @JsonKey(name: 'sex') required this.sex,
      @JsonKey(name: 'date_of_birth') required this.dateOfBirth,
      @JsonKey(name: 'date_first_seen') required this.dateFirstSeen,
      @JsonKey(name: 'gestation_at_birth_weeks')
      required this.gestationAtBirthWeeks,
      @JsonKey(name: 'birth_weight_grams') required this.birthWeightGrams,
      @JsonKey(name: 'birth_length_cm') required this.birthLengthCm,
      @JsonKey(name: 'head_circumference_at_birth_cm') this.headCircumferenceCm,
      @JsonKey(name: 'other_birth_characteristics')
      this.otherBirthCharacteristics,
      @JsonKey(name: 'birth_order') this.birthOrder,
      @JsonKey(name: 'place_of_birth') required this.placeOfBirth,
      @JsonKey(name: 'health_facility_name') this.healthFacilityName,
      @JsonKey(name: 'birth_notification_number') this.birthNotificationNumber,
      @JsonKey(name: 'birth_notification_date') this.birthNotificationDate,
      @JsonKey(name: 'immunization_reg_number') this.immunizationRegNumber,
      @JsonKey(name: 'cwc_number') this.cwcNumber,
      @JsonKey(name: 'kmhfl_code') this.kmhflCode,
      @JsonKey(name: 'birth_certificate_number') this.birthCertificateNumber,
      @JsonKey(name: 'birth_registration_date') this.birthRegistrationDate,
      @JsonKey(name: 'birth_registration_place') this.birthRegistrationPlace,
      @JsonKey(name: 'father_name') this.fatherName,
      @JsonKey(name: 'father_phone') this.fatherPhone,
      @JsonKey(name: 'mother_name') this.motherName,
      @JsonKey(name: 'mother_phone') this.motherPhone,
      @JsonKey(name: 'guardian_name') this.guardianName,
      @JsonKey(name: 'guardian_phone') this.guardianPhone,
      @JsonKey(name: 'county') this.county,
      @JsonKey(name: 'sub_county') this.subCounty,
      @JsonKey(name: 'ward') this.ward,
      @JsonKey(name: 'village') this.village,
      @JsonKey(name: 'physical_address') this.physicalAddress,
      @JsonKey(name: 'weight_at_first_contact') this.weightAtFirstContact,
      @JsonKey(name: 'length_at_first_contact') this.lengthAtFirstContact,
      @JsonKey(name: 'z_score') this.zScore,
      @JsonKey(name: 'hiv_exposed') this.hivExposed,
      @JsonKey(name: 'hiv_status') this.hivStatus,
      @JsonKey(name: 'hiv_test_date') this.hivTestDate,
      @JsonKey(name: 'haemoglobin') this.haemoglobin,
      @JsonKey(name: 'colouration') this.colouration,
      @JsonKey(name: 'eyes') this.eyes,
      @JsonKey(name: 'ears') this.ears,
      @JsonKey(name: 'mouth') this.mouth,
      @JsonKey(name: 'chest') this.chest,
      @JsonKey(name: 'heart') this.heart,
      @JsonKey(name: 'abdomen') this.abdomen,
      @JsonKey(name: 'umbilical_cord') this.umbilicalCord,
      @JsonKey(name: 'spine') this.spine,
      @JsonKey(name: 'arms_hands') this.armsHands,
      @JsonKey(name: 'legs_feet') this.legsFeet,
      @JsonKey(name: 'genitalia') this.genitalia,
      @JsonKey(name: 'anus') this.anus,
      @JsonKey(name: 'tb_screened') this.tbScreened,
      @JsonKey(name: 'tb_screening_result') this.tbScreeningResult,
      @JsonKey(name: 'breastfeeding_well') this.breastfeedingWell,
      @JsonKey(name: 'breastfeeding_poorly') this.breastfeedingPoorly,
      @JsonKey(name: 'unable_to_breastfeed') this.unableToBreastfeed,
      @JsonKey(name: 'other_foods_introduced_below_6_months')
      this.otherFoodsIntroducedBelow6Months,
      @JsonKey(name: 'age_other_foods_introduced') this.ageOtherFoodsIntroduced,
      @JsonKey(name: 'complementary_food_from_6_months')
      this.complementaryFoodFrom6Months,
      @JsonKey(name: 'sleep_problems') this.sleepProblems,
      @JsonKey(name: 'irritability') this.irritability,
      @JsonKey(name: 'other_problems') this.otherProblems,
      @JsonKey(name: 'birth_weight_less_than_2500g')
      this.birthWeightLessThan2500g,
      @JsonKey(name: 'birth_less_than_2_years_after_last')
      this.birthLessThan2YearsAfterLast,
      @JsonKey(name: 'fifth_child_or_more') this.fifthChildOrMore,
      @JsonKey(name: 'born_of_teenage_mother') this.bornOfTeenageMother,
      @JsonKey(name: 'born_of_mentally_ill_mother')
      this.bornOfMentallyIllMother,
      @JsonKey(name: 'developmental_delays') this.developmentalDelays,
      @JsonKey(name: 'sibling_undernourished') this.siblingUndernourished,
      @JsonKey(name: 'multiple_birth') this.multipleBirth,
      @JsonKey(name: 'child_with_special_needs') this.childWithSpecialNeeds,
      @JsonKey(name: 'orphan_vulnerable_child') this.orphanVulnerableChild,
      @JsonKey(name: 'child_with_disability') this.childWithDisability,
      @JsonKey(name: 'history_of_child_abuse') this.historyOfChildAbuse,
      @JsonKey(name: 'cleft_lip_palate') this.cleftLipPalate,
      @JsonKey(name: 'other_special_care_reason') this.otherSpecialCareReason,
      @JsonKey(name: 'created_at') this.createdAt,
      @JsonKey(name: 'updated_at') this.updatedAt});

  factory _$ChildProfileImpl.fromJson(Map<String, dynamic> json) =>
      _$$ChildProfileImplFromJson(json);

  @override
  @JsonKey(name: 'id')
  final String id;
  @override
  @JsonKey(name: 'maternal_profile_id')
  final String maternalProfileId;
// A. Particulars of the Child
  @override
  @JsonKey(name: 'child_name')
  final String childName;
  @override
  @JsonKey(name: 'sex')
  final String sex;
  @override
  @JsonKey(name: 'date_of_birth')
  final DateTime dateOfBirth;
  @override
  @JsonKey(name: 'date_first_seen')
  final DateTime dateFirstSeen;
// Birth Details
  @override
  @JsonKey(name: 'gestation_at_birth_weeks')
  final int gestationAtBirthWeeks;
  @override
  @JsonKey(name: 'birth_weight_grams')
  final double birthWeightGrams;
  @override
  @JsonKey(name: 'birth_length_cm')
  final double birthLengthCm;
  @override
  @JsonKey(name: 'head_circumference_at_birth_cm')
  final double? headCircumferenceCm;
// ← FIXED!
  @override
  @JsonKey(name: 'other_birth_characteristics')
  final String? otherBirthCharacteristics;
  @override
  @JsonKey(name: 'birth_order')
  final int? birthOrder;
// B. Health Record
  @override
  @JsonKey(name: 'place_of_birth')
  final String placeOfBirth;
  @override
  @JsonKey(name: 'health_facility_name')
  final String? healthFacilityName;
  @override
  @JsonKey(name: 'birth_notification_number')
  final String? birthNotificationNumber;
  @override
  @JsonKey(name: 'birth_notification_date')
  final DateTime? birthNotificationDate;
// Registration Numbers
  @override
  @JsonKey(name: 'immunization_reg_number')
  final String? immunizationRegNumber;
  @override
  @JsonKey(name: 'cwc_number')
  final String? cwcNumber;
  @override
  @JsonKey(name: 'kmhfl_code')
  final String? kmhflCode;
// C. Civil Registration
  @override
  @JsonKey(name: 'birth_certificate_number')
  final String? birthCertificateNumber;
  @override
  @JsonKey(name: 'birth_registration_date')
  final DateTime? birthRegistrationDate;
  @override
  @JsonKey(name: 'birth_registration_place')
  final String? birthRegistrationPlace;
// D. Family Details
  @override
  @JsonKey(name: 'father_name')
  final String? fatherName;
  @override
  @JsonKey(name: 'father_phone')
  final String? fatherPhone;
  @override
  @JsonKey(name: 'mother_name')
  final String? motherName;
  @override
  @JsonKey(name: 'mother_phone')
  final String? motherPhone;
  @override
  @JsonKey(name: 'guardian_name')
  final String? guardianName;
  @override
  @JsonKey(name: 'guardian_phone')
  final String? guardianPhone;
// Address
  @override
  @JsonKey(name: 'county')
  final String? county;
  @override
  @JsonKey(name: 'sub_county')
  final String? subCounty;
  @override
  @JsonKey(name: 'ward')
  final String? ward;
  @override
  @JsonKey(name: 'village')
  final String? village;
  @override
  @JsonKey(name: 'physical_address')
  final String? physicalAddress;
// E. Broad Clinical Review at First Contact
  @override
  @JsonKey(name: 'weight_at_first_contact')
  final double? weightAtFirstContact;
  @override
  @JsonKey(name: 'length_at_first_contact')
  final double? lengthAtFirstContact;
  @override
  @JsonKey(name: 'z_score')
  final String? zScore;
// HIV Status
  @override
  @JsonKey(name: 'hiv_exposed')
  final bool? hivExposed;
  @override
  @JsonKey(name: 'hiv_status')
  final String? hivStatus;
  @override
  @JsonKey(name: 'hiv_test_date')
  final DateTime? hivTestDate;
  @override
  @JsonKey(name: 'haemoglobin')
  final double? haemoglobin;
// Physical Features
  @override
  @JsonKey(name: 'colouration')
  final String? colouration;
  @override
  @JsonKey(name: 'eyes')
  final String? eyes;
  @override
  @JsonKey(name: 'ears')
  final String? ears;
  @override
  @JsonKey(name: 'mouth')
  final String? mouth;
  @override
  @JsonKey(name: 'chest')
  final String? chest;
  @override
  @JsonKey(name: 'heart')
  final String? heart;
  @override
  @JsonKey(name: 'abdomen')
  final String? abdomen;
  @override
  @JsonKey(name: 'umbilical_cord')
  final String? umbilicalCord;
  @override
  @JsonKey(name: 'spine')
  final String? spine;
  @override
  @JsonKey(name: 'arms_hands')
  final String? armsHands;
  @override
  @JsonKey(name: 'legs_feet')
  final String? legsFeet;
  @override
  @JsonKey(name: 'genitalia')
  final String? genitalia;
  @override
  @JsonKey(name: 'anus')
  final String? anus;
// TB Screening
  @override
  @JsonKey(name: 'tb_screened')
  final bool? tbScreened;
  @override
  @JsonKey(name: 'tb_screening_result')
  final String? tbScreeningResult;
// F. Feeding Information
  @override
  @JsonKey(name: 'breastfeeding_well')
  final bool? breastfeedingWell;
  @override
  @JsonKey(name: 'breastfeeding_poorly')
  final bool? breastfeedingPoorly;
  @override
  @JsonKey(name: 'unable_to_breastfeed')
  final bool? unableToBreastfeed;
  @override
  @JsonKey(name: 'other_foods_introduced_below_6_months')
  final bool? otherFoodsIntroducedBelow6Months;
  @override
  @JsonKey(name: 'age_other_foods_introduced')
  final int? ageOtherFoodsIntroduced;
  @override
  @JsonKey(name: 'complementary_food_from_6_months')
  final bool? complementaryFoodFrom6Months;
// G. Other Problems Reported
  @override
  @JsonKey(name: 'sleep_problems')
  final String? sleepProblems;
  @override
  @JsonKey(name: 'irritability')
  final bool? irritability;
  @override
  @JsonKey(name: 'other_problems')
  final String? otherProblems;
// Reason for Special Care
  @override
  @JsonKey(name: 'birth_weight_less_than_2500g')
  final bool? birthWeightLessThan2500g;
  @override
  @JsonKey(name: 'birth_less_than_2_years_after_last')
  final bool? birthLessThan2YearsAfterLast;
  @override
  @JsonKey(name: 'fifth_child_or_more')
  final bool? fifthChildOrMore;
  @override
  @JsonKey(name: 'born_of_teenage_mother')
  final bool? bornOfTeenageMother;
  @override
  @JsonKey(name: 'born_of_mentally_ill_mother')
  final bool? bornOfMentallyIllMother;
  @override
  @JsonKey(name: 'developmental_delays')
  final bool? developmentalDelays;
  @override
  @JsonKey(name: 'sibling_undernourished')
  final bool? siblingUndernourished;
  @override
  @JsonKey(name: 'multiple_birth')
  final bool? multipleBirth;
  @override
  @JsonKey(name: 'child_with_special_needs')
  final bool? childWithSpecialNeeds;
  @override
  @JsonKey(name: 'orphan_vulnerable_child')
  final bool? orphanVulnerableChild;
  @override
  @JsonKey(name: 'child_with_disability')
  final bool? childWithDisability;
  @override
  @JsonKey(name: 'history_of_child_abuse')
  final bool? historyOfChildAbuse;
  @override
  @JsonKey(name: 'cleft_lip_palate')
  final bool? cleftLipPalate;
  @override
  @JsonKey(name: 'other_special_care_reason')
  final String? otherSpecialCareReason;
  @override
  @JsonKey(name: 'created_at')
  final DateTime? createdAt;
  @override
  @JsonKey(name: 'updated_at')
  final DateTime? updatedAt;

  @override
  String toString() {
    return 'ChildProfile(id: $id, maternalProfileId: $maternalProfileId, childName: $childName, sex: $sex, dateOfBirth: $dateOfBirth, dateFirstSeen: $dateFirstSeen, gestationAtBirthWeeks: $gestationAtBirthWeeks, birthWeightGrams: $birthWeightGrams, birthLengthCm: $birthLengthCm, headCircumferenceCm: $headCircumferenceCm, otherBirthCharacteristics: $otherBirthCharacteristics, birthOrder: $birthOrder, placeOfBirth: $placeOfBirth, healthFacilityName: $healthFacilityName, birthNotificationNumber: $birthNotificationNumber, birthNotificationDate: $birthNotificationDate, immunizationRegNumber: $immunizationRegNumber, cwcNumber: $cwcNumber, kmhflCode: $kmhflCode, birthCertificateNumber: $birthCertificateNumber, birthRegistrationDate: $birthRegistrationDate, birthRegistrationPlace: $birthRegistrationPlace, fatherName: $fatherName, fatherPhone: $fatherPhone, motherName: $motherName, motherPhone: $motherPhone, guardianName: $guardianName, guardianPhone: $guardianPhone, county: $county, subCounty: $subCounty, ward: $ward, village: $village, physicalAddress: $physicalAddress, weightAtFirstContact: $weightAtFirstContact, lengthAtFirstContact: $lengthAtFirstContact, zScore: $zScore, hivExposed: $hivExposed, hivStatus: $hivStatus, hivTestDate: $hivTestDate, haemoglobin: $haemoglobin, colouration: $colouration, eyes: $eyes, ears: $ears, mouth: $mouth, chest: $chest, heart: $heart, abdomen: $abdomen, umbilicalCord: $umbilicalCord, spine: $spine, armsHands: $armsHands, legsFeet: $legsFeet, genitalia: $genitalia, anus: $anus, tbScreened: $tbScreened, tbScreeningResult: $tbScreeningResult, breastfeedingWell: $breastfeedingWell, breastfeedingPoorly: $breastfeedingPoorly, unableToBreastfeed: $unableToBreastfeed, otherFoodsIntroducedBelow6Months: $otherFoodsIntroducedBelow6Months, ageOtherFoodsIntroduced: $ageOtherFoodsIntroduced, complementaryFoodFrom6Months: $complementaryFoodFrom6Months, sleepProblems: $sleepProblems, irritability: $irritability, otherProblems: $otherProblems, birthWeightLessThan2500g: $birthWeightLessThan2500g, birthLessThan2YearsAfterLast: $birthLessThan2YearsAfterLast, fifthChildOrMore: $fifthChildOrMore, bornOfTeenageMother: $bornOfTeenageMother, bornOfMentallyIllMother: $bornOfMentallyIllMother, developmentalDelays: $developmentalDelays, siblingUndernourished: $siblingUndernourished, multipleBirth: $multipleBirth, childWithSpecialNeeds: $childWithSpecialNeeds, orphanVulnerableChild: $orphanVulnerableChild, childWithDisability: $childWithDisability, historyOfChildAbuse: $historyOfChildAbuse, cleftLipPalate: $cleftLipPalate, otherSpecialCareReason: $otherSpecialCareReason, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ChildProfileImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.maternalProfileId, maternalProfileId) ||
                other.maternalProfileId == maternalProfileId) &&
            (identical(other.childName, childName) ||
                other.childName == childName) &&
            (identical(other.sex, sex) || other.sex == sex) &&
            (identical(other.dateOfBirth, dateOfBirth) ||
                other.dateOfBirth == dateOfBirth) &&
            (identical(other.dateFirstSeen, dateFirstSeen) ||
                other.dateFirstSeen == dateFirstSeen) &&
            (identical(other.gestationAtBirthWeeks, gestationAtBirthWeeks) ||
                other.gestationAtBirthWeeks == gestationAtBirthWeeks) &&
            (identical(other.birthWeightGrams, birthWeightGrams) ||
                other.birthWeightGrams == birthWeightGrams) &&
            (identical(other.birthLengthCm, birthLengthCm) ||
                other.birthLengthCm == birthLengthCm) &&
            (identical(other.headCircumferenceCm, headCircumferenceCm) ||
                other.headCircumferenceCm == headCircumferenceCm) &&
            (identical(other.otherBirthCharacteristics, otherBirthCharacteristics) ||
                other.otherBirthCharacteristics == otherBirthCharacteristics) &&
            (identical(other.birthOrder, birthOrder) ||
                other.birthOrder == birthOrder) &&
            (identical(other.placeOfBirth, placeOfBirth) ||
                other.placeOfBirth == placeOfBirth) &&
            (identical(other.healthFacilityName, healthFacilityName) ||
                other.healthFacilityName == healthFacilityName) &&
            (identical(other.birthNotificationNumber, birthNotificationNumber) ||
                other.birthNotificationNumber == birthNotificationNumber) &&
            (identical(other.birthNotificationDate, birthNotificationDate) ||
                other.birthNotificationDate == birthNotificationDate) &&
            (identical(other.immunizationRegNumber, immunizationRegNumber) ||
                other.immunizationRegNumber == immunizationRegNumber) &&
            (identical(other.cwcNumber, cwcNumber) ||
                other.cwcNumber == cwcNumber) &&
            (identical(other.kmhflCode, kmhflCode) ||
                other.kmhflCode == kmhflCode) &&
            (identical(other.birthCertificateNumber, birthCertificateNumber) ||
                other.birthCertificateNumber == birthCertificateNumber) &&
            (identical(other.birthRegistrationDate, birthRegistrationDate) ||
                other.birthRegistrationDate == birthRegistrationDate) &&
            (identical(other.birthRegistrationPlace, birthRegistrationPlace) ||
                other.birthRegistrationPlace == birthRegistrationPlace) &&
            (identical(other.fatherName, fatherName) ||
                other.fatherName == fatherName) &&
            (identical(other.fatherPhone, fatherPhone) ||
                other.fatherPhone == fatherPhone) &&
            (identical(other.motherName, motherName) ||
                other.motherName == motherName) &&
            (identical(other.motherPhone, motherPhone) ||
                other.motherPhone == motherPhone) &&
            (identical(other.guardianName, guardianName) ||
                other.guardianName == guardianName) &&
            (identical(other.guardianPhone, guardianPhone) ||
                other.guardianPhone == guardianPhone) &&
            (identical(other.county, county) || other.county == county) &&
            (identical(other.subCounty, subCounty) ||
                other.subCounty == subCounty) &&
            (identical(other.ward, ward) || other.ward == ward) &&
            (identical(other.village, village) || other.village == village) &&
            (identical(other.physicalAddress, physicalAddress) ||
                other.physicalAddress == physicalAddress) &&
            (identical(other.weightAtFirstContact, weightAtFirstContact) ||
                other.weightAtFirstContact == weightAtFirstContact) &&
            (identical(other.lengthAtFirstContact, lengthAtFirstContact) ||
                other.lengthAtFirstContact == lengthAtFirstContact) &&
            (identical(other.zScore, zScore) || other.zScore == zScore) &&
            (identical(other.hivExposed, hivExposed) ||
                other.hivExposed == hivExposed) &&
            (identical(other.hivStatus, hivStatus) || other.hivStatus == hivStatus) &&
            (identical(other.hivTestDate, hivTestDate) || other.hivTestDate == hivTestDate) &&
            (identical(other.haemoglobin, haemoglobin) || other.haemoglobin == haemoglobin) &&
            (identical(other.colouration, colouration) || other.colouration == colouration) &&
            (identical(other.eyes, eyes) || other.eyes == eyes) &&
            (identical(other.ears, ears) || other.ears == ears) &&
            (identical(other.mouth, mouth) || other.mouth == mouth) &&
            (identical(other.chest, chest) || other.chest == chest) &&
            (identical(other.heart, heart) || other.heart == heart) &&
            (identical(other.abdomen, abdomen) || other.abdomen == abdomen) &&
            (identical(other.umbilicalCord, umbilicalCord) || other.umbilicalCord == umbilicalCord) &&
            (identical(other.spine, spine) || other.spine == spine) &&
            (identical(other.armsHands, armsHands) || other.armsHands == armsHands) &&
            (identical(other.legsFeet, legsFeet) || other.legsFeet == legsFeet) &&
            (identical(other.genitalia, genitalia) || other.genitalia == genitalia) &&
            (identical(other.anus, anus) || other.anus == anus) &&
            (identical(other.tbScreened, tbScreened) || other.tbScreened == tbScreened) &&
            (identical(other.tbScreeningResult, tbScreeningResult) || other.tbScreeningResult == tbScreeningResult) &&
            (identical(other.breastfeedingWell, breastfeedingWell) || other.breastfeedingWell == breastfeedingWell) &&
            (identical(other.breastfeedingPoorly, breastfeedingPoorly) || other.breastfeedingPoorly == breastfeedingPoorly) &&
            (identical(other.unableToBreastfeed, unableToBreastfeed) || other.unableToBreastfeed == unableToBreastfeed) &&
            (identical(other.otherFoodsIntroducedBelow6Months, otherFoodsIntroducedBelow6Months) || other.otherFoodsIntroducedBelow6Months == otherFoodsIntroducedBelow6Months) &&
            (identical(other.ageOtherFoodsIntroduced, ageOtherFoodsIntroduced) || other.ageOtherFoodsIntroduced == ageOtherFoodsIntroduced) &&
            (identical(other.complementaryFoodFrom6Months, complementaryFoodFrom6Months) || other.complementaryFoodFrom6Months == complementaryFoodFrom6Months) &&
            (identical(other.sleepProblems, sleepProblems) || other.sleepProblems == sleepProblems) &&
            (identical(other.irritability, irritability) || other.irritability == irritability) &&
            (identical(other.otherProblems, otherProblems) || other.otherProblems == otherProblems) &&
            (identical(other.birthWeightLessThan2500g, birthWeightLessThan2500g) || other.birthWeightLessThan2500g == birthWeightLessThan2500g) &&
            (identical(other.birthLessThan2YearsAfterLast, birthLessThan2YearsAfterLast) || other.birthLessThan2YearsAfterLast == birthLessThan2YearsAfterLast) &&
            (identical(other.fifthChildOrMore, fifthChildOrMore) || other.fifthChildOrMore == fifthChildOrMore) &&
            (identical(other.bornOfTeenageMother, bornOfTeenageMother) || other.bornOfTeenageMother == bornOfTeenageMother) &&
            (identical(other.bornOfMentallyIllMother, bornOfMentallyIllMother) || other.bornOfMentallyIllMother == bornOfMentallyIllMother) &&
            (identical(other.developmentalDelays, developmentalDelays) || other.developmentalDelays == developmentalDelays) &&
            (identical(other.siblingUndernourished, siblingUndernourished) || other.siblingUndernourished == siblingUndernourished) &&
            (identical(other.multipleBirth, multipleBirth) || other.multipleBirth == multipleBirth) &&
            (identical(other.childWithSpecialNeeds, childWithSpecialNeeds) || other.childWithSpecialNeeds == childWithSpecialNeeds) &&
            (identical(other.orphanVulnerableChild, orphanVulnerableChild) || other.orphanVulnerableChild == orphanVulnerableChild) &&
            (identical(other.childWithDisability, childWithDisability) || other.childWithDisability == childWithDisability) &&
            (identical(other.historyOfChildAbuse, historyOfChildAbuse) || other.historyOfChildAbuse == historyOfChildAbuse) &&
            (identical(other.cleftLipPalate, cleftLipPalate) || other.cleftLipPalate == cleftLipPalate) &&
            (identical(other.otherSpecialCareReason, otherSpecialCareReason) || other.otherSpecialCareReason == otherSpecialCareReason) &&
            (identical(other.createdAt, createdAt) || other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hashAll([
        runtimeType,
        id,
        maternalProfileId,
        childName,
        sex,
        dateOfBirth,
        dateFirstSeen,
        gestationAtBirthWeeks,
        birthWeightGrams,
        birthLengthCm,
        headCircumferenceCm,
        otherBirthCharacteristics,
        birthOrder,
        placeOfBirth,
        healthFacilityName,
        birthNotificationNumber,
        birthNotificationDate,
        immunizationRegNumber,
        cwcNumber,
        kmhflCode,
        birthCertificateNumber,
        birthRegistrationDate,
        birthRegistrationPlace,
        fatherName,
        fatherPhone,
        motherName,
        motherPhone,
        guardianName,
        guardianPhone,
        county,
        subCounty,
        ward,
        village,
        physicalAddress,
        weightAtFirstContact,
        lengthAtFirstContact,
        zScore,
        hivExposed,
        hivStatus,
        hivTestDate,
        haemoglobin,
        colouration,
        eyes,
        ears,
        mouth,
        chest,
        heart,
        abdomen,
        umbilicalCord,
        spine,
        armsHands,
        legsFeet,
        genitalia,
        anus,
        tbScreened,
        tbScreeningResult,
        breastfeedingWell,
        breastfeedingPoorly,
        unableToBreastfeed,
        otherFoodsIntroducedBelow6Months,
        ageOtherFoodsIntroduced,
        complementaryFoodFrom6Months,
        sleepProblems,
        irritability,
        otherProblems,
        birthWeightLessThan2500g,
        birthLessThan2YearsAfterLast,
        fifthChildOrMore,
        bornOfTeenageMother,
        bornOfMentallyIllMother,
        developmentalDelays,
        siblingUndernourished,
        multipleBirth,
        childWithSpecialNeeds,
        orphanVulnerableChild,
        childWithDisability,
        historyOfChildAbuse,
        cleftLipPalate,
        otherSpecialCareReason,
        createdAt,
        updatedAt
      ]);

  /// Create a copy of ChildProfile
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ChildProfileImplCopyWith<_$ChildProfileImpl> get copyWith =>
      __$$ChildProfileImplCopyWithImpl<_$ChildProfileImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ChildProfileImplToJson(
      this,
    );
  }
}

abstract class _ChildProfile implements ChildProfile {
  const factory _ChildProfile(
      {@JsonKey(name: 'id') required final String id,
      @JsonKey(name: 'maternal_profile_id')
      required final String maternalProfileId,
      @JsonKey(name: 'child_name') required final String childName,
      @JsonKey(name: 'sex') required final String sex,
      @JsonKey(name: 'date_of_birth') required final DateTime dateOfBirth,
      @JsonKey(name: 'date_first_seen') required final DateTime dateFirstSeen,
      @JsonKey(name: 'gestation_at_birth_weeks')
      required final int gestationAtBirthWeeks,
      @JsonKey(name: 'birth_weight_grams')
      required final double birthWeightGrams,
      @JsonKey(name: 'birth_length_cm') required final double birthLengthCm,
      @JsonKey(name: 'head_circumference_at_birth_cm')
      final double? headCircumferenceCm,
      @JsonKey(name: 'other_birth_characteristics')
      final String? otherBirthCharacteristics,
      @JsonKey(name: 'birth_order') final int? birthOrder,
      @JsonKey(name: 'place_of_birth') required final String placeOfBirth,
      @JsonKey(name: 'health_facility_name') final String? healthFacilityName,
      @JsonKey(name: 'birth_notification_number')
      final String? birthNotificationNumber,
      @JsonKey(name: 'birth_notification_date')
      final DateTime? birthNotificationDate,
      @JsonKey(name: 'immunization_reg_number')
      final String? immunizationRegNumber,
      @JsonKey(name: 'cwc_number') final String? cwcNumber,
      @JsonKey(name: 'kmhfl_code') final String? kmhflCode,
      @JsonKey(name: 'birth_certificate_number')
      final String? birthCertificateNumber,
      @JsonKey(name: 'birth_registration_date')
      final DateTime? birthRegistrationDate,
      @JsonKey(name: 'birth_registration_place')
      final String? birthRegistrationPlace,
      @JsonKey(name: 'father_name') final String? fatherName,
      @JsonKey(name: 'father_phone') final String? fatherPhone,
      @JsonKey(name: 'mother_name') final String? motherName,
      @JsonKey(name: 'mother_phone') final String? motherPhone,
      @JsonKey(name: 'guardian_name') final String? guardianName,
      @JsonKey(name: 'guardian_phone') final String? guardianPhone,
      @JsonKey(name: 'county') final String? county,
      @JsonKey(name: 'sub_county') final String? subCounty,
      @JsonKey(name: 'ward') final String? ward,
      @JsonKey(name: 'village') final String? village,
      @JsonKey(name: 'physical_address') final String? physicalAddress,
      @JsonKey(name: 'weight_at_first_contact')
      final double? weightAtFirstContact,
      @JsonKey(name: 'length_at_first_contact')
      final double? lengthAtFirstContact,
      @JsonKey(name: 'z_score') final String? zScore,
      @JsonKey(name: 'hiv_exposed') final bool? hivExposed,
      @JsonKey(name: 'hiv_status') final String? hivStatus,
      @JsonKey(name: 'hiv_test_date') final DateTime? hivTestDate,
      @JsonKey(name: 'haemoglobin') final double? haemoglobin,
      @JsonKey(name: 'colouration') final String? colouration,
      @JsonKey(name: 'eyes') final String? eyes,
      @JsonKey(name: 'ears') final String? ears,
      @JsonKey(name: 'mouth') final String? mouth,
      @JsonKey(name: 'chest') final String? chest,
      @JsonKey(name: 'heart') final String? heart,
      @JsonKey(name: 'abdomen') final String? abdomen,
      @JsonKey(name: 'umbilical_cord') final String? umbilicalCord,
      @JsonKey(name: 'spine') final String? spine,
      @JsonKey(name: 'arms_hands') final String? armsHands,
      @JsonKey(name: 'legs_feet') final String? legsFeet,
      @JsonKey(name: 'genitalia') final String? genitalia,
      @JsonKey(name: 'anus') final String? anus,
      @JsonKey(name: 'tb_screened') final bool? tbScreened,
      @JsonKey(name: 'tb_screening_result') final String? tbScreeningResult,
      @JsonKey(name: 'breastfeeding_well') final bool? breastfeedingWell,
      @JsonKey(name: 'breastfeeding_poorly') final bool? breastfeedingPoorly,
      @JsonKey(name: 'unable_to_breastfeed') final bool? unableToBreastfeed,
      @JsonKey(name: 'other_foods_introduced_below_6_months')
      final bool? otherFoodsIntroducedBelow6Months,
      @JsonKey(name: 'age_other_foods_introduced')
      final int? ageOtherFoodsIntroduced,
      @JsonKey(name: 'complementary_food_from_6_months')
      final bool? complementaryFoodFrom6Months,
      @JsonKey(name: 'sleep_problems') final String? sleepProblems,
      @JsonKey(name: 'irritability') final bool? irritability,
      @JsonKey(name: 'other_problems') final String? otherProblems,
      @JsonKey(name: 'birth_weight_less_than_2500g')
      final bool? birthWeightLessThan2500g,
      @JsonKey(name: 'birth_less_than_2_years_after_last')
      final bool? birthLessThan2YearsAfterLast,
      @JsonKey(name: 'fifth_child_or_more') final bool? fifthChildOrMore,
      @JsonKey(name: 'born_of_teenage_mother') final bool? bornOfTeenageMother,
      @JsonKey(name: 'born_of_mentally_ill_mother')
      final bool? bornOfMentallyIllMother,
      @JsonKey(name: 'developmental_delays') final bool? developmentalDelays,
      @JsonKey(name: 'sibling_undernourished')
      final bool? siblingUndernourished,
      @JsonKey(name: 'multiple_birth') final bool? multipleBirth,
      @JsonKey(name: 'child_with_special_needs')
      final bool? childWithSpecialNeeds,
      @JsonKey(name: 'orphan_vulnerable_child')
      final bool? orphanVulnerableChild,
      @JsonKey(name: 'child_with_disability') final bool? childWithDisability,
      @JsonKey(name: 'history_of_child_abuse') final bool? historyOfChildAbuse,
      @JsonKey(name: 'cleft_lip_palate') final bool? cleftLipPalate,
      @JsonKey(name: 'other_special_care_reason')
      final String? otherSpecialCareReason,
      @JsonKey(name: 'created_at') final DateTime? createdAt,
      @JsonKey(name: 'updated_at')
      final DateTime? updatedAt}) = _$ChildProfileImpl;

  factory _ChildProfile.fromJson(Map<String, dynamic> json) =
      _$ChildProfileImpl.fromJson;

  @override
  @JsonKey(name: 'id')
  String get id;
  @override
  @JsonKey(name: 'maternal_profile_id')
  String get maternalProfileId; // A. Particulars of the Child
  @override
  @JsonKey(name: 'child_name')
  String get childName;
  @override
  @JsonKey(name: 'sex')
  String get sex;
  @override
  @JsonKey(name: 'date_of_birth')
  DateTime get dateOfBirth;
  @override
  @JsonKey(name: 'date_first_seen')
  DateTime get dateFirstSeen; // Birth Details
  @override
  @JsonKey(name: 'gestation_at_birth_weeks')
  int get gestationAtBirthWeeks;
  @override
  @JsonKey(name: 'birth_weight_grams')
  double get birthWeightGrams;
  @override
  @JsonKey(name: 'birth_length_cm')
  double get birthLengthCm;
  @override
  @JsonKey(name: 'head_circumference_at_birth_cm')
  double? get headCircumferenceCm; // ← FIXED!
  @override
  @JsonKey(name: 'other_birth_characteristics')
  String? get otherBirthCharacteristics;
  @override
  @JsonKey(name: 'birth_order')
  int? get birthOrder; // B. Health Record
  @override
  @JsonKey(name: 'place_of_birth')
  String get placeOfBirth;
  @override
  @JsonKey(name: 'health_facility_name')
  String? get healthFacilityName;
  @override
  @JsonKey(name: 'birth_notification_number')
  String? get birthNotificationNumber;
  @override
  @JsonKey(name: 'birth_notification_date')
  DateTime? get birthNotificationDate; // Registration Numbers
  @override
  @JsonKey(name: 'immunization_reg_number')
  String? get immunizationRegNumber;
  @override
  @JsonKey(name: 'cwc_number')
  String? get cwcNumber;
  @override
  @JsonKey(name: 'kmhfl_code')
  String? get kmhflCode; // C. Civil Registration
  @override
  @JsonKey(name: 'birth_certificate_number')
  String? get birthCertificateNumber;
  @override
  @JsonKey(name: 'birth_registration_date')
  DateTime? get birthRegistrationDate;
  @override
  @JsonKey(name: 'birth_registration_place')
  String? get birthRegistrationPlace; // D. Family Details
  @override
  @JsonKey(name: 'father_name')
  String? get fatherName;
  @override
  @JsonKey(name: 'father_phone')
  String? get fatherPhone;
  @override
  @JsonKey(name: 'mother_name')
  String? get motherName;
  @override
  @JsonKey(name: 'mother_phone')
  String? get motherPhone;
  @override
  @JsonKey(name: 'guardian_name')
  String? get guardianName;
  @override
  @JsonKey(name: 'guardian_phone')
  String? get guardianPhone; // Address
  @override
  @JsonKey(name: 'county')
  String? get county;
  @override
  @JsonKey(name: 'sub_county')
  String? get subCounty;
  @override
  @JsonKey(name: 'ward')
  String? get ward;
  @override
  @JsonKey(name: 'village')
  String? get village;
  @override
  @JsonKey(name: 'physical_address')
  String? get physicalAddress; // E. Broad Clinical Review at First Contact
  @override
  @JsonKey(name: 'weight_at_first_contact')
  double? get weightAtFirstContact;
  @override
  @JsonKey(name: 'length_at_first_contact')
  double? get lengthAtFirstContact;
  @override
  @JsonKey(name: 'z_score')
  String? get zScore; // HIV Status
  @override
  @JsonKey(name: 'hiv_exposed')
  bool? get hivExposed;
  @override
  @JsonKey(name: 'hiv_status')
  String? get hivStatus;
  @override
  @JsonKey(name: 'hiv_test_date')
  DateTime? get hivTestDate;
  @override
  @JsonKey(name: 'haemoglobin')
  double? get haemoglobin; // Physical Features
  @override
  @JsonKey(name: 'colouration')
  String? get colouration;
  @override
  @JsonKey(name: 'eyes')
  String? get eyes;
  @override
  @JsonKey(name: 'ears')
  String? get ears;
  @override
  @JsonKey(name: 'mouth')
  String? get mouth;
  @override
  @JsonKey(name: 'chest')
  String? get chest;
  @override
  @JsonKey(name: 'heart')
  String? get heart;
  @override
  @JsonKey(name: 'abdomen')
  String? get abdomen;
  @override
  @JsonKey(name: 'umbilical_cord')
  String? get umbilicalCord;
  @override
  @JsonKey(name: 'spine')
  String? get spine;
  @override
  @JsonKey(name: 'arms_hands')
  String? get armsHands;
  @override
  @JsonKey(name: 'legs_feet')
  String? get legsFeet;
  @override
  @JsonKey(name: 'genitalia')
  String? get genitalia;
  @override
  @JsonKey(name: 'anus')
  String? get anus; // TB Screening
  @override
  @JsonKey(name: 'tb_screened')
  bool? get tbScreened;
  @override
  @JsonKey(name: 'tb_screening_result')
  String? get tbScreeningResult; // F. Feeding Information
  @override
  @JsonKey(name: 'breastfeeding_well')
  bool? get breastfeedingWell;
  @override
  @JsonKey(name: 'breastfeeding_poorly')
  bool? get breastfeedingPoorly;
  @override
  @JsonKey(name: 'unable_to_breastfeed')
  bool? get unableToBreastfeed;
  @override
  @JsonKey(name: 'other_foods_introduced_below_6_months')
  bool? get otherFoodsIntroducedBelow6Months;
  @override
  @JsonKey(name: 'age_other_foods_introduced')
  int? get ageOtherFoodsIntroduced;
  @override
  @JsonKey(name: 'complementary_food_from_6_months')
  bool? get complementaryFoodFrom6Months; // G. Other Problems Reported
  @override
  @JsonKey(name: 'sleep_problems')
  String? get sleepProblems;
  @override
  @JsonKey(name: 'irritability')
  bool? get irritability;
  @override
  @JsonKey(name: 'other_problems')
  String? get otherProblems; // Reason for Special Care
  @override
  @JsonKey(name: 'birth_weight_less_than_2500g')
  bool? get birthWeightLessThan2500g;
  @override
  @JsonKey(name: 'birth_less_than_2_years_after_last')
  bool? get birthLessThan2YearsAfterLast;
  @override
  @JsonKey(name: 'fifth_child_or_more')
  bool? get fifthChildOrMore;
  @override
  @JsonKey(name: 'born_of_teenage_mother')
  bool? get bornOfTeenageMother;
  @override
  @JsonKey(name: 'born_of_mentally_ill_mother')
  bool? get bornOfMentallyIllMother;
  @override
  @JsonKey(name: 'developmental_delays')
  bool? get developmentalDelays;
  @override
  @JsonKey(name: 'sibling_undernourished')
  bool? get siblingUndernourished;
  @override
  @JsonKey(name: 'multiple_birth')
  bool? get multipleBirth;
  @override
  @JsonKey(name: 'child_with_special_needs')
  bool? get childWithSpecialNeeds;
  @override
  @JsonKey(name: 'orphan_vulnerable_child')
  bool? get orphanVulnerableChild;
  @override
  @JsonKey(name: 'child_with_disability')
  bool? get childWithDisability;
  @override
  @JsonKey(name: 'history_of_child_abuse')
  bool? get historyOfChildAbuse;
  @override
  @JsonKey(name: 'cleft_lip_palate')
  bool? get cleftLipPalate;
  @override
  @JsonKey(name: 'other_special_care_reason')
  String? get otherSpecialCareReason;
  @override
  @JsonKey(name: 'created_at')
  DateTime? get createdAt;
  @override
  @JsonKey(name: 'updated_at')
  DateTime? get updatedAt;

  /// Create a copy of ChildProfile
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ChildProfileImplCopyWith<_$ChildProfileImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
