import 'package:freezed_annotation/freezed_annotation.dart';

part 'childbirth_record.freezed.dart';
part 'childbirth_record.g.dart';

/// Childbirth Record - MCH Handbook Page 15
@freezed
class ChildbirthRecord with _$ChildbirthRecord {
  const factory ChildbirthRecord({
    @JsonKey(name: 'id') String? id,  // ← Changed to nullable
    @JsonKey(name: 'maternal_profile_id') required String maternalProfileId,
    @JsonKey(name: 'delivery_date') required DateTime deliveryDate,
    @JsonKey(name: 'delivery_time') required String deliveryTime,
    @JsonKey(name: 'duration_of_pregnancy_weeks') required int durationOfPregnancyWeeks,
    
    // Place & Attendant
    @JsonKey(name: 'place_of_delivery') required String placeOfDelivery,
    @JsonKey(name: 'health_facility_name') String? healthFacilityName,
    @JsonKey(name: 'attendant') String? attendant,
    
    // Mode of Delivery
    @JsonKey(name: 'mode_of_delivery') required String modeOfDelivery,
    
    // Mother's Condition
    @JsonKey(name: 'skin_to_skin_immediate') bool? skinToSkinImmediate,
    @JsonKey(name: 'apgar_score_1_min') String? apgarScore1Min,
    @JsonKey(name: 'apgar_score_5_min') String? apgarScore5Min,
    @JsonKey(name: 'apgar_score_10_min') String? apgarScore10Min,
    @JsonKey(name: 'resuscitation_done') bool? resuscitationDone,
    @JsonKey(name: 'blood_loss_ml') double? bloodLossMl,
    
    // Complications
    @JsonKey(name: 'pre_eclampsia') bool? preEclampsia,
    @JsonKey(name: 'eclampsia') bool? eclampsia,
    @JsonKey(name: 'pph') bool? pph,
    @JsonKey(name: 'obstructed_labour') bool? obstructedLabour,
    @JsonKey(name: 'meconium_grade') String? meconiumGrade,
    
    // Mother's Condition Post-delivery
    @JsonKey(name: 'mother_condition') String? motherCondition,
    
    // Drugs Administered to Mother
    @JsonKey(name: 'oxytocin_given') bool? oxytocinGiven,
    @JsonKey(name: 'misoprostol_given') bool? misoprostolGiven,
    @JsonKey(name: 'heat_stable_carbetocin') bool? heatStableCarbetocin,
    @JsonKey(name: 'haart_given') bool? haartGiven,
    @JsonKey(name: 'haart_regimen') String? haartRegimen,
    @JsonKey(name: 'other_drugs') String? otherDrugs,
    
    // Baby Details
    @JsonKey(name: 'birth_weight_grams') required double birthWeightGrams,
    @JsonKey(name: 'birth_length_cm') required double birthLengthCm,
    @JsonKey(name: 'head_circumference_cm') double? headCircumferenceCm,
    @JsonKey(name: 'baby_condition') String? babyCondition,
    
    // Drugs Given to Baby
    @JsonKey(name: 'chx_given') bool? chxGiven,
    @JsonKey(name: 'vitamin_k_given') bool? vitaminKGiven,
    @JsonKey(name: 'teo_given') bool? teoGiven,
    
    // HIV Exposure
    @JsonKey(name: 'baby_hiv_exposed') bool? babyHivExposed,
    @JsonKey(name: 'arv_prophylaxis_given') String? arvProphylaxisGiven,
    
    // Breastfeeding
    @JsonKey(name: 'early_initiation_breastfeeding') bool? earlyInitiationBreastfeeding,
    
    // Clinical Notes
    @JsonKey(name: 'notes') String? notes,
    @JsonKey(name: 'conducted_by') String? conductedBy,
    
    @JsonKey(name: 'created_at') DateTime? createdAt,
    @JsonKey(name: 'updated_at') DateTime? updatedAt,
  }) = _ChildbirthRecord;

  factory ChildbirthRecord.fromJson(Map<String, dynamic> json) =>
      _$ChildbirthRecordFromJson(json);
}