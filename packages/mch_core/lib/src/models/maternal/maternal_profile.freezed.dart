// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'maternal_profile.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

MaternalProfile _$MaternalProfileFromJson(Map<String, dynamic> json) {
  return _MaternalProfile.fromJson(json);
}

/// @nodoc
mixin _$MaternalProfile {
  String? get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'facility_id')
  String get facilityId => throw _privateConstructorUsedError;
  @JsonKey(name: 'kmhfl_code')
  String get kmhflCode => throw _privateConstructorUsedError;
  @JsonKey(name: 'facility_name')
  String get facilityName => throw _privateConstructorUsedError;
  @JsonKey(name: 'anc_number')
  String get ancNumber => throw _privateConstructorUsedError;
  @JsonKey(name: 'pnc_number')
  String? get pncNumber => throw _privateConstructorUsedError;
  @JsonKey(name: 'client_name')
  String get clientName => throw _privateConstructorUsedError;
  @JsonKey(name: 'id_number')
  String? get idNumber => throw _privateConstructorUsedError;
  int get age => throw _privateConstructorUsedError;
  String? get telephone => throw _privateConstructorUsedError;
  String? get county => throw _privateConstructorUsedError;
  @JsonKey(name: 'sub_county')
  String? get subCounty => throw _privateConstructorUsedError;
  String? get ward => throw _privateConstructorUsedError;
  String? get village => throw _privateConstructorUsedError;
  int get gravida => throw _privateConstructorUsedError;
  int get parity => throw _privateConstructorUsedError;
  @JsonKey(name: 'height_cm')
  double get heightCm => throw _privateConstructorUsedError;
  @JsonKey(name: 'weight_kg')
  double get weightKg => throw _privateConstructorUsedError;
  DateTime? get lmp => throw _privateConstructorUsedError;
  DateTime? get edd => throw _privateConstructorUsedError;
  @JsonKey(name: 'gestation_at_first_visit')
  int? get gestationAtFirstVisit => throw _privateConstructorUsedError;
  @JsonKey(name: 'blood_group')
  BloodGroup? get bloodGroup => throw _privateConstructorUsedError;
  bool? get diabetes => throw _privateConstructorUsedError;
  bool? get hypertension => throw _privateConstructorUsedError;
  bool? get tuberculosis => throw _privateConstructorUsedError;
  @JsonKey(name: 'blood_transfusion')
  bool? get bloodTransfusion => throw _privateConstructorUsedError;
  @JsonKey(name: 'drug_allergy')
  bool? get drugAllergy => throw _privateConstructorUsedError;
  @JsonKey(name: 'allergy_details')
  String? get allergyDetails => throw _privateConstructorUsedError;
  @JsonKey(name: 'previous_cs')
  bool? get previousCs => throw _privateConstructorUsedError;
  @JsonKey(name: 'previous_cs_count')
  int? get previousCsCount => throw _privateConstructorUsedError;
  @JsonKey(name: 'bleeding_history')
  bool? get bleedingHistory => throw _privateConstructorUsedError;
  int? get stillbirths => throw _privateConstructorUsedError;
  @JsonKey(name: 'neonatal_deaths')
  int? get neonatalDeaths => throw _privateConstructorUsedError;
  @JsonKey(name: 'fgm_done')
  bool? get fgmDone => throw _privateConstructorUsedError;
  @JsonKey(name: 'hiv_result')
  HivTestResult? get hivResult => throw _privateConstructorUsedError;
  @JsonKey(name: 'tested_for_syphilis')
  bool? get testedForSyphilis => throw _privateConstructorUsedError;
  @JsonKey(name: 'syphilis_result')
  HivTestResult? get syphilisResult => throw _privateConstructorUsedError;
  @JsonKey(name: 'tested_for_hepatitis_b')
  bool? get testedForHepatitisB => throw _privateConstructorUsedError;
  @JsonKey(name: 'hepatitis_b_result')
  HivTestResult? get hepatitisBResult => throw _privateConstructorUsedError;
  @JsonKey(name: 'partner_tested_for_hiv')
  bool? get partnerTestedForHiv => throw _privateConstructorUsedError;
  @JsonKey(name: 'partner_hiv_status')
  HivTestResult? get partnerHivStatus => throw _privateConstructorUsedError;
  @JsonKey(name: 'next_of_kin_name')
  String? get nextOfKinName => throw _privateConstructorUsedError;
  @JsonKey(name: 'next_of_kin_relationship')
  String? get nextOfKinRelationship => throw _privateConstructorUsedError;
  @JsonKey(name: 'next_of_kin_phone')
  String? get nextOfKinPhone => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_at')
  DateTime? get createdAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'updated_at')
  DateTime? get updatedAt => throw _privateConstructorUsedError;

  /// Serializes this MaternalProfile to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of MaternalProfile
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $MaternalProfileCopyWith<MaternalProfile> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MaternalProfileCopyWith<$Res> {
  factory $MaternalProfileCopyWith(
          MaternalProfile value, $Res Function(MaternalProfile) then) =
      _$MaternalProfileCopyWithImpl<$Res, MaternalProfile>;
  @useResult
  $Res call(
      {String? id,
      @JsonKey(name: 'facility_id') String facilityId,
      @JsonKey(name: 'kmhfl_code') String kmhflCode,
      @JsonKey(name: 'facility_name') String facilityName,
      @JsonKey(name: 'anc_number') String ancNumber,
      @JsonKey(name: 'pnc_number') String? pncNumber,
      @JsonKey(name: 'client_name') String clientName,
      @JsonKey(name: 'id_number') String? idNumber,
      int age,
      String? telephone,
      String? county,
      @JsonKey(name: 'sub_county') String? subCounty,
      String? ward,
      String? village,
      int gravida,
      int parity,
      @JsonKey(name: 'height_cm') double heightCm,
      @JsonKey(name: 'weight_kg') double weightKg,
      DateTime? lmp,
      DateTime? edd,
      @JsonKey(name: 'gestation_at_first_visit') int? gestationAtFirstVisit,
      @JsonKey(name: 'blood_group') BloodGroup? bloodGroup,
      bool? diabetes,
      bool? hypertension,
      bool? tuberculosis,
      @JsonKey(name: 'blood_transfusion') bool? bloodTransfusion,
      @JsonKey(name: 'drug_allergy') bool? drugAllergy,
      @JsonKey(name: 'allergy_details') String? allergyDetails,
      @JsonKey(name: 'previous_cs') bool? previousCs,
      @JsonKey(name: 'previous_cs_count') int? previousCsCount,
      @JsonKey(name: 'bleeding_history') bool? bleedingHistory,
      int? stillbirths,
      @JsonKey(name: 'neonatal_deaths') int? neonatalDeaths,
      @JsonKey(name: 'fgm_done') bool? fgmDone,
      @JsonKey(name: 'hiv_result') HivTestResult? hivResult,
      @JsonKey(name: 'tested_for_syphilis') bool? testedForSyphilis,
      @JsonKey(name: 'syphilis_result') HivTestResult? syphilisResult,
      @JsonKey(name: 'tested_for_hepatitis_b') bool? testedForHepatitisB,
      @JsonKey(name: 'hepatitis_b_result') HivTestResult? hepatitisBResult,
      @JsonKey(name: 'partner_tested_for_hiv') bool? partnerTestedForHiv,
      @JsonKey(name: 'partner_hiv_status') HivTestResult? partnerHivStatus,
      @JsonKey(name: 'next_of_kin_name') String? nextOfKinName,
      @JsonKey(name: 'next_of_kin_relationship') String? nextOfKinRelationship,
      @JsonKey(name: 'next_of_kin_phone') String? nextOfKinPhone,
      @JsonKey(name: 'created_at') DateTime? createdAt,
      @JsonKey(name: 'updated_at') DateTime? updatedAt});
}

/// @nodoc
class _$MaternalProfileCopyWithImpl<$Res, $Val extends MaternalProfile>
    implements $MaternalProfileCopyWith<$Res> {
  _$MaternalProfileCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of MaternalProfile
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? facilityId = null,
    Object? kmhflCode = null,
    Object? facilityName = null,
    Object? ancNumber = null,
    Object? pncNumber = freezed,
    Object? clientName = null,
    Object? idNumber = freezed,
    Object? age = null,
    Object? telephone = freezed,
    Object? county = freezed,
    Object? subCounty = freezed,
    Object? ward = freezed,
    Object? village = freezed,
    Object? gravida = null,
    Object? parity = null,
    Object? heightCm = null,
    Object? weightKg = null,
    Object? lmp = freezed,
    Object? edd = freezed,
    Object? gestationAtFirstVisit = freezed,
    Object? bloodGroup = freezed,
    Object? diabetes = freezed,
    Object? hypertension = freezed,
    Object? tuberculosis = freezed,
    Object? bloodTransfusion = freezed,
    Object? drugAllergy = freezed,
    Object? allergyDetails = freezed,
    Object? previousCs = freezed,
    Object? previousCsCount = freezed,
    Object? bleedingHistory = freezed,
    Object? stillbirths = freezed,
    Object? neonatalDeaths = freezed,
    Object? fgmDone = freezed,
    Object? hivResult = freezed,
    Object? testedForSyphilis = freezed,
    Object? syphilisResult = freezed,
    Object? testedForHepatitisB = freezed,
    Object? hepatitisBResult = freezed,
    Object? partnerTestedForHiv = freezed,
    Object? partnerHivStatus = freezed,
    Object? nextOfKinName = freezed,
    Object? nextOfKinRelationship = freezed,
    Object? nextOfKinPhone = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(_value.copyWith(
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String?,
      facilityId: null == facilityId
          ? _value.facilityId
          : facilityId // ignore: cast_nullable_to_non_nullable
              as String,
      kmhflCode: null == kmhflCode
          ? _value.kmhflCode
          : kmhflCode // ignore: cast_nullable_to_non_nullable
              as String,
      facilityName: null == facilityName
          ? _value.facilityName
          : facilityName // ignore: cast_nullable_to_non_nullable
              as String,
      ancNumber: null == ancNumber
          ? _value.ancNumber
          : ancNumber // ignore: cast_nullable_to_non_nullable
              as String,
      pncNumber: freezed == pncNumber
          ? _value.pncNumber
          : pncNumber // ignore: cast_nullable_to_non_nullable
              as String?,
      clientName: null == clientName
          ? _value.clientName
          : clientName // ignore: cast_nullable_to_non_nullable
              as String,
      idNumber: freezed == idNumber
          ? _value.idNumber
          : idNumber // ignore: cast_nullable_to_non_nullable
              as String?,
      age: null == age
          ? _value.age
          : age // ignore: cast_nullable_to_non_nullable
              as int,
      telephone: freezed == telephone
          ? _value.telephone
          : telephone // ignore: cast_nullable_to_non_nullable
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
      gravida: null == gravida
          ? _value.gravida
          : gravida // ignore: cast_nullable_to_non_nullable
              as int,
      parity: null == parity
          ? _value.parity
          : parity // ignore: cast_nullable_to_non_nullable
              as int,
      heightCm: null == heightCm
          ? _value.heightCm
          : heightCm // ignore: cast_nullable_to_non_nullable
              as double,
      weightKg: null == weightKg
          ? _value.weightKg
          : weightKg // ignore: cast_nullable_to_non_nullable
              as double,
      lmp: freezed == lmp
          ? _value.lmp
          : lmp // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      edd: freezed == edd
          ? _value.edd
          : edd // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      gestationAtFirstVisit: freezed == gestationAtFirstVisit
          ? _value.gestationAtFirstVisit
          : gestationAtFirstVisit // ignore: cast_nullable_to_non_nullable
              as int?,
      bloodGroup: freezed == bloodGroup
          ? _value.bloodGroup
          : bloodGroup // ignore: cast_nullable_to_non_nullable
              as BloodGroup?,
      diabetes: freezed == diabetes
          ? _value.diabetes
          : diabetes // ignore: cast_nullable_to_non_nullable
              as bool?,
      hypertension: freezed == hypertension
          ? _value.hypertension
          : hypertension // ignore: cast_nullable_to_non_nullable
              as bool?,
      tuberculosis: freezed == tuberculosis
          ? _value.tuberculosis
          : tuberculosis // ignore: cast_nullable_to_non_nullable
              as bool?,
      bloodTransfusion: freezed == bloodTransfusion
          ? _value.bloodTransfusion
          : bloodTransfusion // ignore: cast_nullable_to_non_nullable
              as bool?,
      drugAllergy: freezed == drugAllergy
          ? _value.drugAllergy
          : drugAllergy // ignore: cast_nullable_to_non_nullable
              as bool?,
      allergyDetails: freezed == allergyDetails
          ? _value.allergyDetails
          : allergyDetails // ignore: cast_nullable_to_non_nullable
              as String?,
      previousCs: freezed == previousCs
          ? _value.previousCs
          : previousCs // ignore: cast_nullable_to_non_nullable
              as bool?,
      previousCsCount: freezed == previousCsCount
          ? _value.previousCsCount
          : previousCsCount // ignore: cast_nullable_to_non_nullable
              as int?,
      bleedingHistory: freezed == bleedingHistory
          ? _value.bleedingHistory
          : bleedingHistory // ignore: cast_nullable_to_non_nullable
              as bool?,
      stillbirths: freezed == stillbirths
          ? _value.stillbirths
          : stillbirths // ignore: cast_nullable_to_non_nullable
              as int?,
      neonatalDeaths: freezed == neonatalDeaths
          ? _value.neonatalDeaths
          : neonatalDeaths // ignore: cast_nullable_to_non_nullable
              as int?,
      fgmDone: freezed == fgmDone
          ? _value.fgmDone
          : fgmDone // ignore: cast_nullable_to_non_nullable
              as bool?,
      hivResult: freezed == hivResult
          ? _value.hivResult
          : hivResult // ignore: cast_nullable_to_non_nullable
              as HivTestResult?,
      testedForSyphilis: freezed == testedForSyphilis
          ? _value.testedForSyphilis
          : testedForSyphilis // ignore: cast_nullable_to_non_nullable
              as bool?,
      syphilisResult: freezed == syphilisResult
          ? _value.syphilisResult
          : syphilisResult // ignore: cast_nullable_to_non_nullable
              as HivTestResult?,
      testedForHepatitisB: freezed == testedForHepatitisB
          ? _value.testedForHepatitisB
          : testedForHepatitisB // ignore: cast_nullable_to_non_nullable
              as bool?,
      hepatitisBResult: freezed == hepatitisBResult
          ? _value.hepatitisBResult
          : hepatitisBResult // ignore: cast_nullable_to_non_nullable
              as HivTestResult?,
      partnerTestedForHiv: freezed == partnerTestedForHiv
          ? _value.partnerTestedForHiv
          : partnerTestedForHiv // ignore: cast_nullable_to_non_nullable
              as bool?,
      partnerHivStatus: freezed == partnerHivStatus
          ? _value.partnerHivStatus
          : partnerHivStatus // ignore: cast_nullable_to_non_nullable
              as HivTestResult?,
      nextOfKinName: freezed == nextOfKinName
          ? _value.nextOfKinName
          : nextOfKinName // ignore: cast_nullable_to_non_nullable
              as String?,
      nextOfKinRelationship: freezed == nextOfKinRelationship
          ? _value.nextOfKinRelationship
          : nextOfKinRelationship // ignore: cast_nullable_to_non_nullable
              as String?,
      nextOfKinPhone: freezed == nextOfKinPhone
          ? _value.nextOfKinPhone
          : nextOfKinPhone // ignore: cast_nullable_to_non_nullable
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
abstract class _$$MaternalProfileImplCopyWith<$Res>
    implements $MaternalProfileCopyWith<$Res> {
  factory _$$MaternalProfileImplCopyWith(_$MaternalProfileImpl value,
          $Res Function(_$MaternalProfileImpl) then) =
      __$$MaternalProfileImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String? id,
      @JsonKey(name: 'facility_id') String facilityId,
      @JsonKey(name: 'kmhfl_code') String kmhflCode,
      @JsonKey(name: 'facility_name') String facilityName,
      @JsonKey(name: 'anc_number') String ancNumber,
      @JsonKey(name: 'pnc_number') String? pncNumber,
      @JsonKey(name: 'client_name') String clientName,
      @JsonKey(name: 'id_number') String? idNumber,
      int age,
      String? telephone,
      String? county,
      @JsonKey(name: 'sub_county') String? subCounty,
      String? ward,
      String? village,
      int gravida,
      int parity,
      @JsonKey(name: 'height_cm') double heightCm,
      @JsonKey(name: 'weight_kg') double weightKg,
      DateTime? lmp,
      DateTime? edd,
      @JsonKey(name: 'gestation_at_first_visit') int? gestationAtFirstVisit,
      @JsonKey(name: 'blood_group') BloodGroup? bloodGroup,
      bool? diabetes,
      bool? hypertension,
      bool? tuberculosis,
      @JsonKey(name: 'blood_transfusion') bool? bloodTransfusion,
      @JsonKey(name: 'drug_allergy') bool? drugAllergy,
      @JsonKey(name: 'allergy_details') String? allergyDetails,
      @JsonKey(name: 'previous_cs') bool? previousCs,
      @JsonKey(name: 'previous_cs_count') int? previousCsCount,
      @JsonKey(name: 'bleeding_history') bool? bleedingHistory,
      int? stillbirths,
      @JsonKey(name: 'neonatal_deaths') int? neonatalDeaths,
      @JsonKey(name: 'fgm_done') bool? fgmDone,
      @JsonKey(name: 'hiv_result') HivTestResult? hivResult,
      @JsonKey(name: 'tested_for_syphilis') bool? testedForSyphilis,
      @JsonKey(name: 'syphilis_result') HivTestResult? syphilisResult,
      @JsonKey(name: 'tested_for_hepatitis_b') bool? testedForHepatitisB,
      @JsonKey(name: 'hepatitis_b_result') HivTestResult? hepatitisBResult,
      @JsonKey(name: 'partner_tested_for_hiv') bool? partnerTestedForHiv,
      @JsonKey(name: 'partner_hiv_status') HivTestResult? partnerHivStatus,
      @JsonKey(name: 'next_of_kin_name') String? nextOfKinName,
      @JsonKey(name: 'next_of_kin_relationship') String? nextOfKinRelationship,
      @JsonKey(name: 'next_of_kin_phone') String? nextOfKinPhone,
      @JsonKey(name: 'created_at') DateTime? createdAt,
      @JsonKey(name: 'updated_at') DateTime? updatedAt});
}

/// @nodoc
class __$$MaternalProfileImplCopyWithImpl<$Res>
    extends _$MaternalProfileCopyWithImpl<$Res, _$MaternalProfileImpl>
    implements _$$MaternalProfileImplCopyWith<$Res> {
  __$$MaternalProfileImplCopyWithImpl(
      _$MaternalProfileImpl _value, $Res Function(_$MaternalProfileImpl) _then)
      : super(_value, _then);

  /// Create a copy of MaternalProfile
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? facilityId = null,
    Object? kmhflCode = null,
    Object? facilityName = null,
    Object? ancNumber = null,
    Object? pncNumber = freezed,
    Object? clientName = null,
    Object? idNumber = freezed,
    Object? age = null,
    Object? telephone = freezed,
    Object? county = freezed,
    Object? subCounty = freezed,
    Object? ward = freezed,
    Object? village = freezed,
    Object? gravida = null,
    Object? parity = null,
    Object? heightCm = null,
    Object? weightKg = null,
    Object? lmp = freezed,
    Object? edd = freezed,
    Object? gestationAtFirstVisit = freezed,
    Object? bloodGroup = freezed,
    Object? diabetes = freezed,
    Object? hypertension = freezed,
    Object? tuberculosis = freezed,
    Object? bloodTransfusion = freezed,
    Object? drugAllergy = freezed,
    Object? allergyDetails = freezed,
    Object? previousCs = freezed,
    Object? previousCsCount = freezed,
    Object? bleedingHistory = freezed,
    Object? stillbirths = freezed,
    Object? neonatalDeaths = freezed,
    Object? fgmDone = freezed,
    Object? hivResult = freezed,
    Object? testedForSyphilis = freezed,
    Object? syphilisResult = freezed,
    Object? testedForHepatitisB = freezed,
    Object? hepatitisBResult = freezed,
    Object? partnerTestedForHiv = freezed,
    Object? partnerHivStatus = freezed,
    Object? nextOfKinName = freezed,
    Object? nextOfKinRelationship = freezed,
    Object? nextOfKinPhone = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(_$MaternalProfileImpl(
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String?,
      facilityId: null == facilityId
          ? _value.facilityId
          : facilityId // ignore: cast_nullable_to_non_nullable
              as String,
      kmhflCode: null == kmhflCode
          ? _value.kmhflCode
          : kmhflCode // ignore: cast_nullable_to_non_nullable
              as String,
      facilityName: null == facilityName
          ? _value.facilityName
          : facilityName // ignore: cast_nullable_to_non_nullable
              as String,
      ancNumber: null == ancNumber
          ? _value.ancNumber
          : ancNumber // ignore: cast_nullable_to_non_nullable
              as String,
      pncNumber: freezed == pncNumber
          ? _value.pncNumber
          : pncNumber // ignore: cast_nullable_to_non_nullable
              as String?,
      clientName: null == clientName
          ? _value.clientName
          : clientName // ignore: cast_nullable_to_non_nullable
              as String,
      idNumber: freezed == idNumber
          ? _value.idNumber
          : idNumber // ignore: cast_nullable_to_non_nullable
              as String?,
      age: null == age
          ? _value.age
          : age // ignore: cast_nullable_to_non_nullable
              as int,
      telephone: freezed == telephone
          ? _value.telephone
          : telephone // ignore: cast_nullable_to_non_nullable
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
      gravida: null == gravida
          ? _value.gravida
          : gravida // ignore: cast_nullable_to_non_nullable
              as int,
      parity: null == parity
          ? _value.parity
          : parity // ignore: cast_nullable_to_non_nullable
              as int,
      heightCm: null == heightCm
          ? _value.heightCm
          : heightCm // ignore: cast_nullable_to_non_nullable
              as double,
      weightKg: null == weightKg
          ? _value.weightKg
          : weightKg // ignore: cast_nullable_to_non_nullable
              as double,
      lmp: freezed == lmp
          ? _value.lmp
          : lmp // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      edd: freezed == edd
          ? _value.edd
          : edd // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      gestationAtFirstVisit: freezed == gestationAtFirstVisit
          ? _value.gestationAtFirstVisit
          : gestationAtFirstVisit // ignore: cast_nullable_to_non_nullable
              as int?,
      bloodGroup: freezed == bloodGroup
          ? _value.bloodGroup
          : bloodGroup // ignore: cast_nullable_to_non_nullable
              as BloodGroup?,
      diabetes: freezed == diabetes
          ? _value.diabetes
          : diabetes // ignore: cast_nullable_to_non_nullable
              as bool?,
      hypertension: freezed == hypertension
          ? _value.hypertension
          : hypertension // ignore: cast_nullable_to_non_nullable
              as bool?,
      tuberculosis: freezed == tuberculosis
          ? _value.tuberculosis
          : tuberculosis // ignore: cast_nullable_to_non_nullable
              as bool?,
      bloodTransfusion: freezed == bloodTransfusion
          ? _value.bloodTransfusion
          : bloodTransfusion // ignore: cast_nullable_to_non_nullable
              as bool?,
      drugAllergy: freezed == drugAllergy
          ? _value.drugAllergy
          : drugAllergy // ignore: cast_nullable_to_non_nullable
              as bool?,
      allergyDetails: freezed == allergyDetails
          ? _value.allergyDetails
          : allergyDetails // ignore: cast_nullable_to_non_nullable
              as String?,
      previousCs: freezed == previousCs
          ? _value.previousCs
          : previousCs // ignore: cast_nullable_to_non_nullable
              as bool?,
      previousCsCount: freezed == previousCsCount
          ? _value.previousCsCount
          : previousCsCount // ignore: cast_nullable_to_non_nullable
              as int?,
      bleedingHistory: freezed == bleedingHistory
          ? _value.bleedingHistory
          : bleedingHistory // ignore: cast_nullable_to_non_nullable
              as bool?,
      stillbirths: freezed == stillbirths
          ? _value.stillbirths
          : stillbirths // ignore: cast_nullable_to_non_nullable
              as int?,
      neonatalDeaths: freezed == neonatalDeaths
          ? _value.neonatalDeaths
          : neonatalDeaths // ignore: cast_nullable_to_non_nullable
              as int?,
      fgmDone: freezed == fgmDone
          ? _value.fgmDone
          : fgmDone // ignore: cast_nullable_to_non_nullable
              as bool?,
      hivResult: freezed == hivResult
          ? _value.hivResult
          : hivResult // ignore: cast_nullable_to_non_nullable
              as HivTestResult?,
      testedForSyphilis: freezed == testedForSyphilis
          ? _value.testedForSyphilis
          : testedForSyphilis // ignore: cast_nullable_to_non_nullable
              as bool?,
      syphilisResult: freezed == syphilisResult
          ? _value.syphilisResult
          : syphilisResult // ignore: cast_nullable_to_non_nullable
              as HivTestResult?,
      testedForHepatitisB: freezed == testedForHepatitisB
          ? _value.testedForHepatitisB
          : testedForHepatitisB // ignore: cast_nullable_to_non_nullable
              as bool?,
      hepatitisBResult: freezed == hepatitisBResult
          ? _value.hepatitisBResult
          : hepatitisBResult // ignore: cast_nullable_to_non_nullable
              as HivTestResult?,
      partnerTestedForHiv: freezed == partnerTestedForHiv
          ? _value.partnerTestedForHiv
          : partnerTestedForHiv // ignore: cast_nullable_to_non_nullable
              as bool?,
      partnerHivStatus: freezed == partnerHivStatus
          ? _value.partnerHivStatus
          : partnerHivStatus // ignore: cast_nullable_to_non_nullable
              as HivTestResult?,
      nextOfKinName: freezed == nextOfKinName
          ? _value.nextOfKinName
          : nextOfKinName // ignore: cast_nullable_to_non_nullable
              as String?,
      nextOfKinRelationship: freezed == nextOfKinRelationship
          ? _value.nextOfKinRelationship
          : nextOfKinRelationship // ignore: cast_nullable_to_non_nullable
              as String?,
      nextOfKinPhone: freezed == nextOfKinPhone
          ? _value.nextOfKinPhone
          : nextOfKinPhone // ignore: cast_nullable_to_non_nullable
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
class _$MaternalProfileImpl implements _MaternalProfile {
  const _$MaternalProfileImpl(
      {this.id = '',
      @JsonKey(name: 'facility_id') required this.facilityId,
      @JsonKey(name: 'kmhfl_code') this.kmhflCode = '',
      @JsonKey(name: 'facility_name') this.facilityName = '',
      @JsonKey(name: 'anc_number') this.ancNumber = '',
      @JsonKey(name: 'pnc_number') this.pncNumber,
      @JsonKey(name: 'client_name') this.clientName = '',
      @JsonKey(name: 'id_number') this.idNumber,
      this.age = 0,
      this.telephone,
      this.county,
      @JsonKey(name: 'sub_county') this.subCounty,
      this.ward,
      this.village,
      this.gravida = 0,
      this.parity = 0,
      @JsonKey(name: 'height_cm') this.heightCm = 0.0,
      @JsonKey(name: 'weight_kg') this.weightKg = 0.0,
      this.lmp,
      this.edd,
      @JsonKey(name: 'gestation_at_first_visit') this.gestationAtFirstVisit,
      @JsonKey(name: 'blood_group') this.bloodGroup,
      this.diabetes,
      this.hypertension,
      this.tuberculosis,
      @JsonKey(name: 'blood_transfusion') this.bloodTransfusion,
      @JsonKey(name: 'drug_allergy') this.drugAllergy,
      @JsonKey(name: 'allergy_details') this.allergyDetails,
      @JsonKey(name: 'previous_cs') this.previousCs,
      @JsonKey(name: 'previous_cs_count') this.previousCsCount,
      @JsonKey(name: 'bleeding_history') this.bleedingHistory,
      this.stillbirths,
      @JsonKey(name: 'neonatal_deaths') this.neonatalDeaths,
      @JsonKey(name: 'fgm_done') this.fgmDone,
      @JsonKey(name: 'hiv_result') this.hivResult,
      @JsonKey(name: 'tested_for_syphilis') this.testedForSyphilis,
      @JsonKey(name: 'syphilis_result') this.syphilisResult,
      @JsonKey(name: 'tested_for_hepatitis_b') this.testedForHepatitisB,
      @JsonKey(name: 'hepatitis_b_result') this.hepatitisBResult,
      @JsonKey(name: 'partner_tested_for_hiv') this.partnerTestedForHiv,
      @JsonKey(name: 'partner_hiv_status') this.partnerHivStatus,
      @JsonKey(name: 'next_of_kin_name') this.nextOfKinName,
      @JsonKey(name: 'next_of_kin_relationship') this.nextOfKinRelationship,
      @JsonKey(name: 'next_of_kin_phone') this.nextOfKinPhone,
      @JsonKey(name: 'created_at') this.createdAt,
      @JsonKey(name: 'updated_at') this.updatedAt});

  factory _$MaternalProfileImpl.fromJson(Map<String, dynamic> json) =>
      _$$MaternalProfileImplFromJson(json);

  @override
  @JsonKey()
  final String? id;
  @override
  @JsonKey(name: 'facility_id')
  final String facilityId;
  @override
  @JsonKey(name: 'kmhfl_code')
  final String kmhflCode;
  @override
  @JsonKey(name: 'facility_name')
  final String facilityName;
  @override
  @JsonKey(name: 'anc_number')
  final String ancNumber;
  @override
  @JsonKey(name: 'pnc_number')
  final String? pncNumber;
  @override
  @JsonKey(name: 'client_name')
  final String clientName;
  @override
  @JsonKey(name: 'id_number')
  final String? idNumber;
  @override
  @JsonKey()
  final int age;
  @override
  final String? telephone;
  @override
  final String? county;
  @override
  @JsonKey(name: 'sub_county')
  final String? subCounty;
  @override
  final String? ward;
  @override
  final String? village;
  @override
  @JsonKey()
  final int gravida;
  @override
  @JsonKey()
  final int parity;
  @override
  @JsonKey(name: 'height_cm')
  final double heightCm;
  @override
  @JsonKey(name: 'weight_kg')
  final double weightKg;
  @override
  final DateTime? lmp;
  @override
  final DateTime? edd;
  @override
  @JsonKey(name: 'gestation_at_first_visit')
  final int? gestationAtFirstVisit;
  @override
  @JsonKey(name: 'blood_group')
  final BloodGroup? bloodGroup;
  @override
  final bool? diabetes;
  @override
  final bool? hypertension;
  @override
  final bool? tuberculosis;
  @override
  @JsonKey(name: 'blood_transfusion')
  final bool? bloodTransfusion;
  @override
  @JsonKey(name: 'drug_allergy')
  final bool? drugAllergy;
  @override
  @JsonKey(name: 'allergy_details')
  final String? allergyDetails;
  @override
  @JsonKey(name: 'previous_cs')
  final bool? previousCs;
  @override
  @JsonKey(name: 'previous_cs_count')
  final int? previousCsCount;
  @override
  @JsonKey(name: 'bleeding_history')
  final bool? bleedingHistory;
  @override
  final int? stillbirths;
  @override
  @JsonKey(name: 'neonatal_deaths')
  final int? neonatalDeaths;
  @override
  @JsonKey(name: 'fgm_done')
  final bool? fgmDone;
  @override
  @JsonKey(name: 'hiv_result')
  final HivTestResult? hivResult;
  @override
  @JsonKey(name: 'tested_for_syphilis')
  final bool? testedForSyphilis;
  @override
  @JsonKey(name: 'syphilis_result')
  final HivTestResult? syphilisResult;
  @override
  @JsonKey(name: 'tested_for_hepatitis_b')
  final bool? testedForHepatitisB;
  @override
  @JsonKey(name: 'hepatitis_b_result')
  final HivTestResult? hepatitisBResult;
  @override
  @JsonKey(name: 'partner_tested_for_hiv')
  final bool? partnerTestedForHiv;
  @override
  @JsonKey(name: 'partner_hiv_status')
  final HivTestResult? partnerHivStatus;
  @override
  @JsonKey(name: 'next_of_kin_name')
  final String? nextOfKinName;
  @override
  @JsonKey(name: 'next_of_kin_relationship')
  final String? nextOfKinRelationship;
  @override
  @JsonKey(name: 'next_of_kin_phone')
  final String? nextOfKinPhone;
  @override
  @JsonKey(name: 'created_at')
  final DateTime? createdAt;
  @override
  @JsonKey(name: 'updated_at')
  final DateTime? updatedAt;

  @override
  String toString() {
    return 'MaternalProfile(id: $id, facilityId: $facilityId, kmhflCode: $kmhflCode, facilityName: $facilityName, ancNumber: $ancNumber, pncNumber: $pncNumber, clientName: $clientName, idNumber: $idNumber, age: $age, telephone: $telephone, county: $county, subCounty: $subCounty, ward: $ward, village: $village, gravida: $gravida, parity: $parity, heightCm: $heightCm, weightKg: $weightKg, lmp: $lmp, edd: $edd, gestationAtFirstVisit: $gestationAtFirstVisit, bloodGroup: $bloodGroup, diabetes: $diabetes, hypertension: $hypertension, tuberculosis: $tuberculosis, bloodTransfusion: $bloodTransfusion, drugAllergy: $drugAllergy, allergyDetails: $allergyDetails, previousCs: $previousCs, previousCsCount: $previousCsCount, bleedingHistory: $bleedingHistory, stillbirths: $stillbirths, neonatalDeaths: $neonatalDeaths, fgmDone: $fgmDone, hivResult: $hivResult, testedForSyphilis: $testedForSyphilis, syphilisResult: $syphilisResult, testedForHepatitisB: $testedForHepatitisB, hepatitisBResult: $hepatitisBResult, partnerTestedForHiv: $partnerTestedForHiv, partnerHivStatus: $partnerHivStatus, nextOfKinName: $nextOfKinName, nextOfKinRelationship: $nextOfKinRelationship, nextOfKinPhone: $nextOfKinPhone, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MaternalProfileImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.facilityId, facilityId) ||
                other.facilityId == facilityId) &&
            (identical(other.kmhflCode, kmhflCode) ||
                other.kmhflCode == kmhflCode) &&
            (identical(other.facilityName, facilityName) ||
                other.facilityName == facilityName) &&
            (identical(other.ancNumber, ancNumber) ||
                other.ancNumber == ancNumber) &&
            (identical(other.pncNumber, pncNumber) ||
                other.pncNumber == pncNumber) &&
            (identical(other.clientName, clientName) ||
                other.clientName == clientName) &&
            (identical(other.idNumber, idNumber) ||
                other.idNumber == idNumber) &&
            (identical(other.age, age) || other.age == age) &&
            (identical(other.telephone, telephone) ||
                other.telephone == telephone) &&
            (identical(other.county, county) || other.county == county) &&
            (identical(other.subCounty, subCounty) ||
                other.subCounty == subCounty) &&
            (identical(other.ward, ward) || other.ward == ward) &&
            (identical(other.village, village) || other.village == village) &&
            (identical(other.gravida, gravida) || other.gravida == gravida) &&
            (identical(other.parity, parity) || other.parity == parity) &&
            (identical(other.heightCm, heightCm) ||
                other.heightCm == heightCm) &&
            (identical(other.weightKg, weightKg) ||
                other.weightKg == weightKg) &&
            (identical(other.lmp, lmp) || other.lmp == lmp) &&
            (identical(other.edd, edd) || other.edd == edd) &&
            (identical(other.gestationAtFirstVisit, gestationAtFirstVisit) ||
                other.gestationAtFirstVisit == gestationAtFirstVisit) &&
            (identical(other.bloodGroup, bloodGroup) ||
                other.bloodGroup == bloodGroup) &&
            (identical(other.diabetes, diabetes) ||
                other.diabetes == diabetes) &&
            (identical(other.hypertension, hypertension) ||
                other.hypertension == hypertension) &&
            (identical(other.tuberculosis, tuberculosis) ||
                other.tuberculosis == tuberculosis) &&
            (identical(other.bloodTransfusion, bloodTransfusion) ||
                other.bloodTransfusion == bloodTransfusion) &&
            (identical(other.drugAllergy, drugAllergy) ||
                other.drugAllergy == drugAllergy) &&
            (identical(other.allergyDetails, allergyDetails) ||
                other.allergyDetails == allergyDetails) &&
            (identical(other.previousCs, previousCs) ||
                other.previousCs == previousCs) &&
            (identical(other.previousCsCount, previousCsCount) ||
                other.previousCsCount == previousCsCount) &&
            (identical(other.bleedingHistory, bleedingHistory) ||
                other.bleedingHistory == bleedingHistory) &&
            (identical(other.stillbirths, stillbirths) ||
                other.stillbirths == stillbirths) &&
            (identical(other.neonatalDeaths, neonatalDeaths) ||
                other.neonatalDeaths == neonatalDeaths) &&
            (identical(other.fgmDone, fgmDone) || other.fgmDone == fgmDone) &&
            (identical(other.hivResult, hivResult) ||
                other.hivResult == hivResult) &&
            (identical(other.testedForSyphilis, testedForSyphilis) ||
                other.testedForSyphilis == testedForSyphilis) &&
            (identical(other.syphilisResult, syphilisResult) ||
                other.syphilisResult == syphilisResult) &&
            (identical(other.testedForHepatitisB, testedForHepatitisB) ||
                other.testedForHepatitisB == testedForHepatitisB) &&
            (identical(other.hepatitisBResult, hepatitisBResult) ||
                other.hepatitisBResult == hepatitisBResult) &&
            (identical(other.partnerTestedForHiv, partnerTestedForHiv) ||
                other.partnerTestedForHiv == partnerTestedForHiv) &&
            (identical(other.partnerHivStatus, partnerHivStatus) ||
                other.partnerHivStatus == partnerHivStatus) &&
            (identical(other.nextOfKinName, nextOfKinName) ||
                other.nextOfKinName == nextOfKinName) &&
            (identical(other.nextOfKinRelationship, nextOfKinRelationship) ||
                other.nextOfKinRelationship == nextOfKinRelationship) &&
            (identical(other.nextOfKinPhone, nextOfKinPhone) ||
                other.nextOfKinPhone == nextOfKinPhone) &&
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
        facilityId,
        kmhflCode,
        facilityName,
        ancNumber,
        pncNumber,
        clientName,
        idNumber,
        age,
        telephone,
        county,
        subCounty,
        ward,
        village,
        gravida,
        parity,
        heightCm,
        weightKg,
        lmp,
        edd,
        gestationAtFirstVisit,
        bloodGroup,
        diabetes,
        hypertension,
        tuberculosis,
        bloodTransfusion,
        drugAllergy,
        allergyDetails,
        previousCs,
        previousCsCount,
        bleedingHistory,
        stillbirths,
        neonatalDeaths,
        fgmDone,
        hivResult,
        testedForSyphilis,
        syphilisResult,
        testedForHepatitisB,
        hepatitisBResult,
        partnerTestedForHiv,
        partnerHivStatus,
        nextOfKinName,
        nextOfKinRelationship,
        nextOfKinPhone,
        createdAt,
        updatedAt
      ]);

  /// Create a copy of MaternalProfile
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$MaternalProfileImplCopyWith<_$MaternalProfileImpl> get copyWith =>
      __$$MaternalProfileImplCopyWithImpl<_$MaternalProfileImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$MaternalProfileImplToJson(
      this,
    );
  }
}

abstract class _MaternalProfile implements MaternalProfile {
  const factory _MaternalProfile(
      {final String? id,
      @JsonKey(name: 'facility_id') required final String facilityId,
      @JsonKey(name: 'kmhfl_code') final String kmhflCode,
      @JsonKey(name: 'facility_name') final String facilityName,
      @JsonKey(name: 'anc_number') final String ancNumber,
      @JsonKey(name: 'pnc_number') final String? pncNumber,
      @JsonKey(name: 'client_name') final String clientName,
      @JsonKey(name: 'id_number') final String? idNumber,
      final int age,
      final String? telephone,
      final String? county,
      @JsonKey(name: 'sub_county') final String? subCounty,
      final String? ward,
      final String? village,
      final int gravida,
      final int parity,
      @JsonKey(name: 'height_cm') final double heightCm,
      @JsonKey(name: 'weight_kg') final double weightKg,
      final DateTime? lmp,
      final DateTime? edd,
      @JsonKey(name: 'gestation_at_first_visit')
      final int? gestationAtFirstVisit,
      @JsonKey(name: 'blood_group') final BloodGroup? bloodGroup,
      final bool? diabetes,
      final bool? hypertension,
      final bool? tuberculosis,
      @JsonKey(name: 'blood_transfusion') final bool? bloodTransfusion,
      @JsonKey(name: 'drug_allergy') final bool? drugAllergy,
      @JsonKey(name: 'allergy_details') final String? allergyDetails,
      @JsonKey(name: 'previous_cs') final bool? previousCs,
      @JsonKey(name: 'previous_cs_count') final int? previousCsCount,
      @JsonKey(name: 'bleeding_history') final bool? bleedingHistory,
      final int? stillbirths,
      @JsonKey(name: 'neonatal_deaths') final int? neonatalDeaths,
      @JsonKey(name: 'fgm_done') final bool? fgmDone,
      @JsonKey(name: 'hiv_result') final HivTestResult? hivResult,
      @JsonKey(name: 'tested_for_syphilis') final bool? testedForSyphilis,
      @JsonKey(name: 'syphilis_result') final HivTestResult? syphilisResult,
      @JsonKey(name: 'tested_for_hepatitis_b') final bool? testedForHepatitisB,
      @JsonKey(name: 'hepatitis_b_result')
      final HivTestResult? hepatitisBResult,
      @JsonKey(name: 'partner_tested_for_hiv') final bool? partnerTestedForHiv,
      @JsonKey(name: 'partner_hiv_status')
      final HivTestResult? partnerHivStatus,
      @JsonKey(name: 'next_of_kin_name') final String? nextOfKinName,
      @JsonKey(name: 'next_of_kin_relationship')
      final String? nextOfKinRelationship,
      @JsonKey(name: 'next_of_kin_phone') final String? nextOfKinPhone,
      @JsonKey(name: 'created_at') final DateTime? createdAt,
      @JsonKey(name: 'updated_at')
      final DateTime? updatedAt}) = _$MaternalProfileImpl;

  factory _MaternalProfile.fromJson(Map<String, dynamic> json) =
      _$MaternalProfileImpl.fromJson;

  @override
  String? get id;
  @override
  @JsonKey(name: 'facility_id')
  String get facilityId;
  @override
  @JsonKey(name: 'kmhfl_code')
  String get kmhflCode;
  @override
  @JsonKey(name: 'facility_name')
  String get facilityName;
  @override
  @JsonKey(name: 'anc_number')
  String get ancNumber;
  @override
  @JsonKey(name: 'pnc_number')
  String? get pncNumber;
  @override
  @JsonKey(name: 'client_name')
  String get clientName;
  @override
  @JsonKey(name: 'id_number')
  String? get idNumber;
  @override
  int get age;
  @override
  String? get telephone;
  @override
  String? get county;
  @override
  @JsonKey(name: 'sub_county')
  String? get subCounty;
  @override
  String? get ward;
  @override
  String? get village;
  @override
  int get gravida;
  @override
  int get parity;
  @override
  @JsonKey(name: 'height_cm')
  double get heightCm;
  @override
  @JsonKey(name: 'weight_kg')
  double get weightKg;
  @override
  DateTime? get lmp;
  @override
  DateTime? get edd;
  @override
  @JsonKey(name: 'gestation_at_first_visit')
  int? get gestationAtFirstVisit;
  @override
  @JsonKey(name: 'blood_group')
  BloodGroup? get bloodGroup;
  @override
  bool? get diabetes;
  @override
  bool? get hypertension;
  @override
  bool? get tuberculosis;
  @override
  @JsonKey(name: 'blood_transfusion')
  bool? get bloodTransfusion;
  @override
  @JsonKey(name: 'drug_allergy')
  bool? get drugAllergy;
  @override
  @JsonKey(name: 'allergy_details')
  String? get allergyDetails;
  @override
  @JsonKey(name: 'previous_cs')
  bool? get previousCs;
  @override
  @JsonKey(name: 'previous_cs_count')
  int? get previousCsCount;
  @override
  @JsonKey(name: 'bleeding_history')
  bool? get bleedingHistory;
  @override
  int? get stillbirths;
  @override
  @JsonKey(name: 'neonatal_deaths')
  int? get neonatalDeaths;
  @override
  @JsonKey(name: 'fgm_done')
  bool? get fgmDone;
  @override
  @JsonKey(name: 'hiv_result')
  HivTestResult? get hivResult;
  @override
  @JsonKey(name: 'tested_for_syphilis')
  bool? get testedForSyphilis;
  @override
  @JsonKey(name: 'syphilis_result')
  HivTestResult? get syphilisResult;
  @override
  @JsonKey(name: 'tested_for_hepatitis_b')
  bool? get testedForHepatitisB;
  @override
  @JsonKey(name: 'hepatitis_b_result')
  HivTestResult? get hepatitisBResult;
  @override
  @JsonKey(name: 'partner_tested_for_hiv')
  bool? get partnerTestedForHiv;
  @override
  @JsonKey(name: 'partner_hiv_status')
  HivTestResult? get partnerHivStatus;
  @override
  @JsonKey(name: 'next_of_kin_name')
  String? get nextOfKinName;
  @override
  @JsonKey(name: 'next_of_kin_relationship')
  String? get nextOfKinRelationship;
  @override
  @JsonKey(name: 'next_of_kin_phone')
  String? get nextOfKinPhone;
  @override
  @JsonKey(name: 'created_at')
  DateTime? get createdAt;
  @override
  @JsonKey(name: 'updated_at')
  DateTime? get updatedAt;

  /// Create a copy of MaternalProfile
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$MaternalProfileImplCopyWith<_$MaternalProfileImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
