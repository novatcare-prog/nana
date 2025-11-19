import 'package:freezed_annotation/freezed_annotation.dart';

part 'childbirth_record.freezed.dart';
part 'childbirth_record.g.dart';

/// Childbirth Record - MCH Handbook Page 15
@freezed
class ChildbirthRecord with _$ChildbirthRecord {
  const factory ChildbirthRecord({
    required String id,
    required String maternalProfileId,
    required DateTime deliveryDate,
    required String deliveryTime,
    required int durationOfPregnancyWeeks,
    
    // Place & Attendant
    required String placeOfDelivery, // Health facility, Home, Other
    String? healthFacilityName,
    String? attendant, // Nurse, Midwife, Clinical Officer, Doctor
    
    // Mode of Delivery
    required String modeOfDelivery, // SVD, Caesarean, Assisted (Vacuum/Forceps)
    
    // Mother's Condition
    bool? skinToSkinImmediate,
    String? apgarScore1Min,
    String? apgarScore5Min,
    String? apgarScore10Min,
    bool? resuscitationDone,
    double? bloodLossMl,
    
    // Complications
    bool? preEclampsia,
    bool? eclampsia,
    bool? pph, // Post-partum hemorrhage
    bool? obstructedLabour,
    String? meconiumGrade, // 0, 1, 2, 3
    
    // Mother's Condition Post-delivery
    String? motherCondition,
    
    // Drugs Administered to Mother
    bool? oxytocinGiven,
    bool? misoprostolGiven,
    bool? heatStableCarbetocin,
    bool? haartGiven, // If HIV positive
    String? haartRegimen,
    String? otherDrugs,
    
    // Baby Details
    required double birthWeightGrams,
    required double birthLengthCm,
    double? headCircumferenceCm,
    String? babyCondition,
    
    // Drugs Given to Baby
    bool? chxGiven, // Chlorhexidine 7.1%
    bool? vitaminKGiven,
    bool? teoGiven, // Tetracycline Eye Ointment
    
    // HIV Exposure
    bool? babyHivExposed,
    String? arvProphylaxisGiven, // AZT+NVP
    
    // Breastfeeding
    bool? earlyInitiationBreastfeeding, // Within 1 hour
    
    // Clinical Notes
    String? notes,
    String? conductedBy,
    
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _ChildbirthRecord;

  factory ChildbirthRecord.fromJson(Map<String, dynamic> json) =>
      _$ChildbirthRecordFromJson(json);
}