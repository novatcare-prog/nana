import 'package:freezed_annotation/freezed_annotation.dart';

part 'child_profile.freezed.dart';
part 'child_profile.g.dart';

/// Child Profile - MCH Handbook Page 23 (Section 2)
@freezed
class ChildProfile with _$ChildProfile {
  const factory ChildProfile({
    required String id,
    required String maternalProfileId, // Link to mother
    
    // A. Particulars of the Child
    required String childName,
    required String sex, // Male, Female
    required DateTime dateOfBirth,
    required DateTime dateFirstSeen,
    
    // Birth Details
    required int gestationAtBirthWeeks,
    required double birthWeightGrams,
    required double birthLengthCm,
    double? headCircumferenceCm,
    String? otherBirthCharacteristics, // Twin/triplet, C-section, congenital features
    int? birthOrder, // 1st, 2nd, 3rd born
    
    // B. Health Record
    required String placeOfBirth, // Health facility, Home, Other
    String? healthFacilityName,
    String? birthNotificationNumber,
    DateTime? birthNotificationDate,
    
    // Registration Numbers
    String? immunizationRegNumber,
    String? cwcNumber, // Child Welfare Clinic Number
    String? kmhflCode, // Health facility code
    
    // C. Civil Registration
    String? birthCertificateNumber,
    DateTime? birthRegistrationDate,
    String? birthRegistrationPlace,
    
    // D. Family Details
    String? fatherName,
    String? fatherPhone,
    String? motherName,
    String? motherPhone,
    String? guardianName, // If applicable
    String? guardianPhone,
    
    // Address
    String? county,
    String? subCounty,
    String? ward,
    String? village,
    String? physicalAddress,
    
    // E. Broad Clinical Review at First Contact (below 6 months)
    double? weightAtFirstContact,
    double? lengthAtFirstContact,
    String? zScore,
    
    // HIV Status
    bool? hivExposed,
    String? hivStatus, // Exposed, Reactive, Non-reactive, Unknown
    DateTime? hivTestDate,
    
    double? haemoglobin,
    
    // Physical Features
    String? colouration, // Cyanosis, Jaundice, Macules, Hypopigmentation
    String? eyes,
    String? ears,
    String? mouth,
    String? chest,
    String? heart,
    String? abdomen,
    String? umbilicalCord,
    String? spine,
    String? armsHands,
    String? legsFeet,
    String? genitalia, // Normal, Abnormal (specify)
    String? anus, // Perforate (Normal), Imperforate (Abnormal)
    
    // TB Screening
    bool? tbScreened,
    String? tbScreeningResult,
    
    // F. Feeding Information
    bool? breastfeedingWell,
    bool? breastfeedingPoorly,
    bool? unableToBreastfeed,
    bool? otherFoodsIntroducedBelow6Months,
    int? ageOtherFoodsIntroduced,
    bool? complementaryFoodFrom6Months,
    
    // G. Other Problems Reported
    String? sleepProblems,
    bool? irritability,
    String? otherProblems,
    
    // Reason for Special Care (Page 26)
    bool? birthWeightLessThan2500g,
    bool? birthLessThan2YearsAfterLast,
    bool? fifthChildOrMore,
    bool? bornOfTeenageMother,
    bool? bornOfMentallyIllMother,
    bool? developmentalDelays,
    bool? siblingUndernourished,
    bool? multipleBirth,
    bool? childWithSpecialNeeds,
    bool? orphanVulnerableChild,
    bool? childWithDisability,
    bool? historyOfChildAbuse,
    bool? cleftLipPalate,
    String? otherSpecialCareReason,
    
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _ChildProfile;

  factory ChildProfile.fromJson(Map<String, dynamic> json) =>
      _$ChildProfileFromJson(json);
}