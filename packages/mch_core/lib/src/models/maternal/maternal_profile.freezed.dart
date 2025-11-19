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
// ✅ FIX: 'required' has been REMOVED from all fields with @Default
  String get id => throw _privateConstructorUsedError;
  String get facilityId => throw _privateConstructorUsedError;
  String get kmhflCode => throw _privateConstructorUsedError;
  String get facilityName => throw _privateConstructorUsedError;
  String get ancNumber => throw _privateConstructorUsedError;
  String? get pncNumber => throw _privateConstructorUsedError;
  String get clientName => throw _privateConstructorUsedError;
  String? get idNumber => throw _privateConstructorUsedError;
  int get age => throw _privateConstructorUsedError;
  String? get telephone => throw _privateConstructorUsedError;
  String? get county => throw _privateConstructorUsedError;
  String? get subCounty => throw _privateConstructorUsedError;
  String? get ward => throw _privateConstructorUsedError;
  String? get village => throw _privateConstructorUsedError;
  int get gravida => throw _privateConstructorUsedError;
  int get parity => throw _privateConstructorUsedError;
  double get heightCm => throw _privateConstructorUsedError;
  double get weightKg =>
      throw _privateConstructorUsedError; // ✅ FIX: Made dates nullable to prevent the 'Null' crash
  DateTime? get lmp => throw _privateConstructorUsedError;
  DateTime? get edd => throw _privateConstructorUsedError;
  int? get gestationAtFirstVisit => throw _privateConstructorUsedError;
  BloodGroup? get bloodGroup => throw _privateConstructorUsedError;
  bool? get diabetes => throw _privateConstructorUsedError;
  bool? get hypertension => throw _privateConstructorUsedError;
  bool? get tuberculosis => throw _privateConstructorUsedError;
  bool? get bloodTransfusion => throw _privateConstructorUsedError;
  bool? get drugAllergy => throw _privateConstructorUsedError;
  String? get allergyDetails => throw _privateConstructorUsedError;
  bool? get previousCs => throw _privateConstructorUsedError;
  int? get previousCsCount => throw _privateConstructorUsedError;
  bool? get bleedingHistory => throw _privateConstructorUsedError;
  int? get stillbirths => throw _privateConstructorUsedError;
  int? get neonatalDeaths => throw _privateConstructorUsedError;
  bool? get fgmDone => throw _privateConstructorUsedError;
  HivTestResult? get hivResult => throw _privateConstructorUsedError;
  bool? get testedForSyphilis => throw _privateConstructorUsedError;
  HivTestResult? get syphilisResult => throw _privateConstructorUsedError;
  bool? get testedForHepatitisB => throw _privateConstructorUsedError;
  HivTestResult? get hepatitisBResult => throw _privateConstructorUsedError;
  bool? get partnerTestedForHiv => throw _privateConstructorUsedError;
  HivTestResult? get partnerHivStatus => throw _privateConstructorUsedError;
  String? get nextOfKinName => throw _privateConstructorUsedError;
  String? get nextOfKinRelationship => throw _privateConstructorUsedError;
  String? get nextOfKinPhone => throw _privateConstructorUsedError;
  DateTime? get createdAt => throw _privateConstructorUsedError;
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
      {String id,
      String facilityId,
      String kmhflCode,
      String facilityName,
      String ancNumber,
      String? pncNumber,
      String clientName,
      String? idNumber,
      int age,
      String? telephone,
      String? county,
      String? subCounty,
      String? ward,
      String? village,
      int gravida,
      int parity,
      double heightCm,
      double weightKg,
      DateTime? lmp,
      DateTime? edd,
      int? gestationAtFirstVisit,
      BloodGroup? bloodGroup,
      bool? diabetes,
      bool? hypertension,
      bool? tuberculosis,
      bool? bloodTransfusion,
      bool? drugAllergy,
      String? allergyDetails,
      bool? previousCs,
      int? previousCsCount,
      bool? bleedingHistory,
      int? stillbirths,
      int? neonatalDeaths,
      bool? fgmDone,
      HivTestResult? hivResult,
      bool? testedForSyphilis,
      HivTestResult? syphilisResult,
      bool? testedForHepatitisB,
      HivTestResult? hepatitisBResult,
      bool? partnerTestedForHiv,
      HivTestResult? partnerHivStatus,
      String? nextOfKinName,
      String? nextOfKinRelationship,
      String? nextOfKinPhone,
      DateTime? createdAt,
      DateTime? updatedAt});
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
    Object? id = null,
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
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
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
      {String id,
      String facilityId,
      String kmhflCode,
      String facilityName,
      String ancNumber,
      String? pncNumber,
      String clientName,
      String? idNumber,
      int age,
      String? telephone,
      String? county,
      String? subCounty,
      String? ward,
      String? village,
      int gravida,
      int parity,
      double heightCm,
      double weightKg,
      DateTime? lmp,
      DateTime? edd,
      int? gestationAtFirstVisit,
      BloodGroup? bloodGroup,
      bool? diabetes,
      bool? hypertension,
      bool? tuberculosis,
      bool? bloodTransfusion,
      bool? drugAllergy,
      String? allergyDetails,
      bool? previousCs,
      int? previousCsCount,
      bool? bleedingHistory,
      int? stillbirths,
      int? neonatalDeaths,
      bool? fgmDone,
      HivTestResult? hivResult,
      bool? testedForSyphilis,
      HivTestResult? syphilisResult,
      bool? testedForHepatitisB,
      HivTestResult? hepatitisBResult,
      bool? partnerTestedForHiv,
      HivTestResult? partnerHivStatus,
      String? nextOfKinName,
      String? nextOfKinRelationship,
      String? nextOfKinPhone,
      DateTime? createdAt,
      DateTime? updatedAt});
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
    Object? id = null,
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
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
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
      this.facilityId = '',
      this.kmhflCode = '',
      this.facilityName = '',
      this.ancNumber = '',
      this.pncNumber,
      this.clientName = '',
      this.idNumber,
      this.age = 0,
      this.telephone,
      this.county,
      this.subCounty,
      this.ward,
      this.village,
      this.gravida = 0,
      this.parity = 0,
      this.heightCm = 0.0,
      this.weightKg = 0.0,
      this.lmp,
      this.edd,
      this.gestationAtFirstVisit,
      this.bloodGroup,
      this.diabetes,
      this.hypertension,
      this.tuberculosis,
      this.bloodTransfusion,
      this.drugAllergy,
      this.allergyDetails,
      this.previousCs,
      this.previousCsCount,
      this.bleedingHistory,
      this.stillbirths,
      this.neonatalDeaths,
      this.fgmDone,
      this.hivResult,
      this.testedForSyphilis,
      this.syphilisResult,
      this.testedForHepatitisB,
      this.hepatitisBResult,
      this.partnerTestedForHiv,
      this.partnerHivStatus,
      this.nextOfKinName,
      this.nextOfKinRelationship,
      this.nextOfKinPhone,
      this.createdAt,
      this.updatedAt});

  factory _$MaternalProfileImpl.fromJson(Map<String, dynamic> json) =>
      _$$MaternalProfileImplFromJson(json);

// ✅ FIX: 'required' has been REMOVED from all fields with @Default
  @override
  @JsonKey()
  final String id;
  @override
  @JsonKey()
  final String facilityId;
  @override
  @JsonKey()
  final String kmhflCode;
  @override
  @JsonKey()
  final String facilityName;
  @override
  @JsonKey()
  final String ancNumber;
  @override
  final String? pncNumber;
  @override
  @JsonKey()
  final String clientName;
  @override
  final String? idNumber;
  @override
  @JsonKey()
  final int age;
  @override
  final String? telephone;
  @override
  final String? county;
  @override
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
  @JsonKey()
  final double heightCm;
  @override
  @JsonKey()
  final double weightKg;
// ✅ FIX: Made dates nullable to prevent the 'Null' crash
  @override
  final DateTime? lmp;
  @override
  final DateTime? edd;
  @override
  final int? gestationAtFirstVisit;
  @override
  final BloodGroup? bloodGroup;
  @override
  final bool? diabetes;
  @override
  final bool? hypertension;
  @override
  final bool? tuberculosis;
  @override
  final bool? bloodTransfusion;
  @override
  final bool? drugAllergy;
  @override
  final String? allergyDetails;
  @override
  final bool? previousCs;
  @override
  final int? previousCsCount;
  @override
  final bool? bleedingHistory;
  @override
  final int? stillbirths;
  @override
  final int? neonatalDeaths;
  @override
  final bool? fgmDone;
  @override
  final HivTestResult? hivResult;
  @override
  final bool? testedForSyphilis;
  @override
  final HivTestResult? syphilisResult;
  @override
  final bool? testedForHepatitisB;
  @override
  final HivTestResult? hepatitisBResult;
  @override
  final bool? partnerTestedForHiv;
  @override
  final HivTestResult? partnerHivStatus;
  @override
  final String? nextOfKinName;
  @override
  final String? nextOfKinRelationship;
  @override
  final String? nextOfKinPhone;
  @override
  final DateTime? createdAt;
  @override
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
      {final String id,
      final String facilityId,
      final String kmhflCode,
      final String facilityName,
      final String ancNumber,
      final String? pncNumber,
      final String clientName,
      final String? idNumber,
      final int age,
      final String? telephone,
      final String? county,
      final String? subCounty,
      final String? ward,
      final String? village,
      final int gravida,
      final int parity,
      final double heightCm,
      final double weightKg,
      final DateTime? lmp,
      final DateTime? edd,
      final int? gestationAtFirstVisit,
      final BloodGroup? bloodGroup,
      final bool? diabetes,
      final bool? hypertension,
      final bool? tuberculosis,
      final bool? bloodTransfusion,
      final bool? drugAllergy,
      final String? allergyDetails,
      final bool? previousCs,
      final int? previousCsCount,
      final bool? bleedingHistory,
      final int? stillbirths,
      final int? neonatalDeaths,
      final bool? fgmDone,
      final HivTestResult? hivResult,
      final bool? testedForSyphilis,
      final HivTestResult? syphilisResult,
      final bool? testedForHepatitisB,
      final HivTestResult? hepatitisBResult,
      final bool? partnerTestedForHiv,
      final HivTestResult? partnerHivStatus,
      final String? nextOfKinName,
      final String? nextOfKinRelationship,
      final String? nextOfKinPhone,
      final DateTime? createdAt,
      final DateTime? updatedAt}) = _$MaternalProfileImpl;

  factory _MaternalProfile.fromJson(Map<String, dynamic> json) =
      _$MaternalProfileImpl.fromJson;

// ✅ FIX: 'required' has been REMOVED from all fields with @Default
  @override
  String get id;
  @override
  String get facilityId;
  @override
  String get kmhflCode;
  @override
  String get facilityName;
  @override
  String get ancNumber;
  @override
  String? get pncNumber;
  @override
  String get clientName;
  @override
  String? get idNumber;
  @override
  int get age;
  @override
  String? get telephone;
  @override
  String? get county;
  @override
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
  double get heightCm;
  @override
  double get weightKg; // ✅ FIX: Made dates nullable to prevent the 'Null' crash
  @override
  DateTime? get lmp;
  @override
  DateTime? get edd;
  @override
  int? get gestationAtFirstVisit;
  @override
  BloodGroup? get bloodGroup;
  @override
  bool? get diabetes;
  @override
  bool? get hypertension;
  @override
  bool? get tuberculosis;
  @override
  bool? get bloodTransfusion;
  @override
  bool? get drugAllergy;
  @override
  String? get allergyDetails;
  @override
  bool? get previousCs;
  @override
  int? get previousCsCount;
  @override
  bool? get bleedingHistory;
  @override
  int? get stillbirths;
  @override
  int? get neonatalDeaths;
  @override
  bool? get fgmDone;
  @override
  HivTestResult? get hivResult;
  @override
  bool? get testedForSyphilis;
  @override
  HivTestResult? get syphilisResult;
  @override
  bool? get testedForHepatitisB;
  @override
  HivTestResult? get hepatitisBResult;
  @override
  bool? get partnerTestedForHiv;
  @override
  HivTestResult? get partnerHivStatus;
  @override
  String? get nextOfKinName;
  @override
  String? get nextOfKinRelationship;
  @override
  String? get nextOfKinPhone;
  @override
  DateTime? get createdAt;
  @override
  DateTime? get updatedAt;

  /// Create a copy of MaternalProfile
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$MaternalProfileImplCopyWith<_$MaternalProfileImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
