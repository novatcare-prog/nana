import 'package:freezed_annotation/freezed_annotation.dart';

part 'child_profile.freezed.dart';
part 'child_profile.g.dart';

/// Child Profile - MCH Handbook Page 23 (Section 2)
@freezed
class ChildProfile with _$ChildProfile {
  const factory ChildProfile({
    @JsonKey(name: 'id') required String id,
    @JsonKey(name: 'maternal_profile_id') required String maternalProfileId,
    
    // A. Particulars of the Child
    @JsonKey(name: 'child_name') required String childName,
    @JsonKey(name: 'sex') required String sex,
    @JsonKey(name: 'date_of_birth') required DateTime dateOfBirth,
    @JsonKey(name: 'date_first_seen') required DateTime dateFirstSeen,
    
    // Birth Details
    @JsonKey(name: 'gestation_at_birth_weeks') required int gestationAtBirthWeeks,
    @JsonKey(name: 'birth_weight_grams') required double birthWeightGrams,
    @JsonKey(name: 'birth_length_cm') required double birthLengthCm,
    @JsonKey(name: 'head_circumference_at_birth_cm') double? headCircumferenceCm, // ← FIXED!
    @JsonKey(name: 'other_birth_characteristics') String? otherBirthCharacteristics,
    @JsonKey(name: 'birth_order') int? birthOrder,
    
    // B. Health Record
    @JsonKey(name: 'place_of_birth') required String placeOfBirth,
    @JsonKey(name: 'health_facility_name') String? healthFacilityName,
    @JsonKey(name: 'birth_notification_number') String? birthNotificationNumber,
    @JsonKey(name: 'birth_notification_date') DateTime? birthNotificationDate,
    
    // Registration Numbers
    @JsonKey(name: 'immunization_reg_number') String? immunizationRegNumber,
    @JsonKey(name: 'cwc_number') String? cwcNumber,
    @JsonKey(name: 'kmhfl_code') String? kmhflCode,
    
    // C. Civil Registration
    @JsonKey(name: 'birth_certificate_number') String? birthCertificateNumber,
    @JsonKey(name: 'birth_registration_date') DateTime? birthRegistrationDate,
    @JsonKey(name: 'birth_registration_place') String? birthRegistrationPlace,
    
    // D. Family Details
    @JsonKey(name: 'father_name') String? fatherName,
    @JsonKey(name: 'father_phone') String? fatherPhone,
    @JsonKey(name: 'mother_name') String? motherName,
    @JsonKey(name: 'mother_phone') String? motherPhone,
    @JsonKey(name: 'guardian_name') String? guardianName,
    @JsonKey(name: 'guardian_phone') String? guardianPhone,
    
    // Address
    @JsonKey(name: 'county') String? county,
    @JsonKey(name: 'sub_county') String? subCounty,
    @JsonKey(name: 'ward') String? ward,
    @JsonKey(name: 'village') String? village,
    @JsonKey(name: 'physical_address') String? physicalAddress,
    
    // E. Broad Clinical Review at First Contact
    @JsonKey(name: 'weight_at_first_contact') double? weightAtFirstContact,
    @JsonKey(name: 'length_at_first_contact') double? lengthAtFirstContact,
    @JsonKey(name: 'z_score') String? zScore,
    
    // HIV Status
    @JsonKey(name: 'hiv_exposed') bool? hivExposed,
    @JsonKey(name: 'hiv_status') String? hivStatus,
    @JsonKey(name: 'hiv_test_date') DateTime? hivTestDate,
    
    @JsonKey(name: 'haemoglobin') double? haemoglobin,
    
    // Physical Features
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
    
    // TB Screening
    @JsonKey(name: 'tb_screened') bool? tbScreened,
    @JsonKey(name: 'tb_screening_result') String? tbScreeningResult,
    
    // F. Feeding Information
    @JsonKey(name: 'breastfeeding_well') bool? breastfeedingWell,
    @JsonKey(name: 'breastfeeding_poorly') bool? breastfeedingPoorly,
    @JsonKey(name: 'unable_to_breastfeed') bool? unableToBreastfeed,
    @JsonKey(name: 'other_foods_introduced_below_6_months') bool? otherFoodsIntroducedBelow6Months,
    @JsonKey(name: 'age_other_foods_introduced') int? ageOtherFoodsIntroduced,
    @JsonKey(name: 'complementary_food_from_6_months') bool? complementaryFoodFrom6Months,
    
    // G. Other Problems Reported
    @JsonKey(name: 'sleep_problems') String? sleepProblems,
    @JsonKey(name: 'irritability') bool? irritability,
    @JsonKey(name: 'other_problems') String? otherProblems,
    
    // Reason for Special Care
    @JsonKey(name: 'birth_weight_less_than_2500g') bool? birthWeightLessThan2500g,
    @JsonKey(name: 'birth_less_than_2_years_after_last') bool? birthLessThan2YearsAfterLast,
    @JsonKey(name: 'fifth_child_or_more') bool? fifthChildOrMore,
    @JsonKey(name: 'born_of_teenage_mother') bool? bornOfTeenageMother,
    @JsonKey(name: 'born_of_mentally_ill_mother') bool? bornOfMentallyIllMother,
    @JsonKey(name: 'developmental_delays') bool? developmentalDelays,
    @JsonKey(name: 'sibling_undernourished') bool? siblingUndernourished,
    @JsonKey(name: 'multiple_birth') bool? multipleBirth,
    @JsonKey(name: 'child_with_special_needs') bool? childWithSpecialNeeds,
    @JsonKey(name: 'orphan_vulnerable_child') bool? orphanVulnerableChild,
    @JsonKey(name: 'child_with_disability') bool? childWithDisability,
    @JsonKey(name: 'history_of_child_abuse') bool? historyOfChildAbuse,
    @JsonKey(name: 'cleft_lip_palate') bool? cleftLipPalate,
    @JsonKey(name: 'other_special_care_reason') String? otherSpecialCareReason,
    
    @JsonKey(name: 'created_at') DateTime? createdAt,
    @JsonKey(name: 'updated_at') DateTime? updatedAt,
  }) = _ChildProfile;

  factory ChildProfile.fromJson(Map<String, dynamic> json) =>
      _$ChildProfileFromJson(json);
}