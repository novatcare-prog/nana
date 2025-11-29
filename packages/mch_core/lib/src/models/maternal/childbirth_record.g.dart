// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'childbirth_record.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ChildbirthRecordImpl _$$ChildbirthRecordImplFromJson(
        Map<String, dynamic> json) =>
    _$ChildbirthRecordImpl(
      id: json['id'] as String?,
      maternalProfileId: json['maternal_profile_id'] as String,
      deliveryDate: DateTime.parse(json['delivery_date'] as String),
      deliveryTime: json['delivery_time'] as String,
      durationOfPregnancyWeeks:
          (json['duration_of_pregnancy_weeks'] as num).toInt(),
      placeOfDelivery: json['place_of_delivery'] as String,
      healthFacilityName: json['health_facility_name'] as String?,
      attendant: json['attendant'] as String?,
      modeOfDelivery: json['mode_of_delivery'] as String,
      skinToSkinImmediate: json['skin_to_skin_immediate'] as bool?,
      apgarScore1Min: json['apgar_score_1_min'] as String?,
      apgarScore5Min: json['apgar_score_5_min'] as String?,
      apgarScore10Min: json['apgar_score_10_min'] as String?,
      resuscitationDone: json['resuscitation_done'] as bool?,
      bloodLossMl: (json['blood_loss_ml'] as num?)?.toDouble(),
      preEclampsia: json['pre_eclampsia'] as bool?,
      eclampsia: json['eclampsia'] as bool?,
      pph: json['pph'] as bool?,
      obstructedLabour: json['obstructed_labour'] as bool?,
      meconiumGrade: json['meconium_grade'] as String?,
      motherCondition: json['mother_condition'] as String?,
      oxytocinGiven: json['oxytocin_given'] as bool?,
      misoprostolGiven: json['misoprostol_given'] as bool?,
      heatStableCarbetocin: json['heat_stable_carbetocin'] as bool?,
      haartGiven: json['haart_given'] as bool?,
      haartRegimen: json['haart_regimen'] as String?,
      otherDrugs: json['other_drugs'] as String?,
      birthWeightGrams: (json['birth_weight_grams'] as num).toDouble(),
      birthLengthCm: (json['birth_length_cm'] as num).toDouble(),
      headCircumferenceCm: (json['head_circumference_cm'] as num?)?.toDouble(),
      babyCondition: json['baby_condition'] as String?,
      chxGiven: json['chx_given'] as bool?,
      vitaminKGiven: json['vitamin_k_given'] as bool?,
      teoGiven: json['teo_given'] as bool?,
      babyHivExposed: json['baby_hiv_exposed'] as bool?,
      arvProphylaxisGiven: json['arv_prophylaxis_given'] as String?,
      earlyInitiationBreastfeeding:
          json['early_initiation_breastfeeding'] as bool?,
      notes: json['notes'] as String?,
      conductedBy: json['conducted_by'] as String?,
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
      updatedAt: json['updated_at'] == null
          ? null
          : DateTime.parse(json['updated_at'] as String),
    );

Map<String, dynamic> _$$ChildbirthRecordImplToJson(
        _$ChildbirthRecordImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'maternal_profile_id': instance.maternalProfileId,
      'delivery_date': instance.deliveryDate.toIso8601String(),
      'delivery_time': instance.deliveryTime,
      'duration_of_pregnancy_weeks': instance.durationOfPregnancyWeeks,
      'place_of_delivery': instance.placeOfDelivery,
      'health_facility_name': instance.healthFacilityName,
      'attendant': instance.attendant,
      'mode_of_delivery': instance.modeOfDelivery,
      'skin_to_skin_immediate': instance.skinToSkinImmediate,
      'apgar_score_1_min': instance.apgarScore1Min,
      'apgar_score_5_min': instance.apgarScore5Min,
      'apgar_score_10_min': instance.apgarScore10Min,
      'resuscitation_done': instance.resuscitationDone,
      'blood_loss_ml': instance.bloodLossMl,
      'pre_eclampsia': instance.preEclampsia,
      'eclampsia': instance.eclampsia,
      'pph': instance.pph,
      'obstructed_labour': instance.obstructedLabour,
      'meconium_grade': instance.meconiumGrade,
      'mother_condition': instance.motherCondition,
      'oxytocin_given': instance.oxytocinGiven,
      'misoprostol_given': instance.misoprostolGiven,
      'heat_stable_carbetocin': instance.heatStableCarbetocin,
      'haart_given': instance.haartGiven,
      'haart_regimen': instance.haartRegimen,
      'other_drugs': instance.otherDrugs,
      'birth_weight_grams': instance.birthWeightGrams,
      'birth_length_cm': instance.birthLengthCm,
      'head_circumference_cm': instance.headCircumferenceCm,
      'baby_condition': instance.babyCondition,
      'chx_given': instance.chxGiven,
      'vitamin_k_given': instance.vitaminKGiven,
      'teo_given': instance.teoGiven,
      'baby_hiv_exposed': instance.babyHivExposed,
      'arv_prophylaxis_given': instance.arvProphylaxisGiven,
      'early_initiation_breastfeeding': instance.earlyInitiationBreastfeeding,
      'notes': instance.notes,
      'conducted_by': instance.conductedBy,
      'created_at': instance.createdAt?.toIso8601String(),
      'updated_at': instance.updatedAt?.toIso8601String(),
    };
