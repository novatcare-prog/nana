// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'childbirth_record.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ChildbirthRecordImpl _$$ChildbirthRecordImplFromJson(
        Map<String, dynamic> json) =>
    _$ChildbirthRecordImpl(
      id: json['id'] as String,
      maternalProfileId: json['maternalProfileId'] as String,
      deliveryDate: DateTime.parse(json['deliveryDate'] as String),
      deliveryTime: json['deliveryTime'] as String,
      durationOfPregnancyWeeks:
          (json['durationOfPregnancyWeeks'] as num).toInt(),
      placeOfDelivery: json['placeOfDelivery'] as String,
      healthFacilityName: json['healthFacilityName'] as String?,
      attendant: json['attendant'] as String?,
      modeOfDelivery: json['modeOfDelivery'] as String,
      skinToSkinImmediate: json['skinToSkinImmediate'] as bool?,
      apgarScore1Min: json['apgarScore1Min'] as String?,
      apgarScore5Min: json['apgarScore5Min'] as String?,
      apgarScore10Min: json['apgarScore10Min'] as String?,
      resuscitationDone: json['resuscitationDone'] as bool?,
      bloodLossMl: (json['bloodLossMl'] as num?)?.toDouble(),
      preEclampsia: json['preEclampsia'] as bool?,
      eclampsia: json['eclampsia'] as bool?,
      pph: json['pph'] as bool?,
      obstructedLabour: json['obstructedLabour'] as bool?,
      meconiumGrade: json['meconiumGrade'] as String?,
      motherCondition: json['motherCondition'] as String?,
      oxytocinGiven: json['oxytocinGiven'] as bool?,
      misoprostolGiven: json['misoprostolGiven'] as bool?,
      heatStableCarbetocin: json['heatStableCarbetocin'] as bool?,
      haartGiven: json['haartGiven'] as bool?,
      haartRegimen: json['haartRegimen'] as String?,
      otherDrugs: json['otherDrugs'] as String?,
      birthWeightGrams: (json['birthWeightGrams'] as num).toDouble(),
      birthLengthCm: (json['birthLengthCm'] as num).toDouble(),
      headCircumferenceCm: (json['headCircumferenceCm'] as num?)?.toDouble(),
      babyCondition: json['babyCondition'] as String?,
      chxGiven: json['chxGiven'] as bool?,
      vitaminKGiven: json['vitaminKGiven'] as bool?,
      teoGiven: json['teoGiven'] as bool?,
      babyHivExposed: json['babyHivExposed'] as bool?,
      arvProphylaxisGiven: json['arvProphylaxisGiven'] as String?,
      earlyInitiationBreastfeeding:
          json['earlyInitiationBreastfeeding'] as bool?,
      notes: json['notes'] as String?,
      conductedBy: json['conductedBy'] as String?,
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$$ChildbirthRecordImplToJson(
        _$ChildbirthRecordImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'maternalProfileId': instance.maternalProfileId,
      'deliveryDate': instance.deliveryDate.toIso8601String(),
      'deliveryTime': instance.deliveryTime,
      'durationOfPregnancyWeeks': instance.durationOfPregnancyWeeks,
      'placeOfDelivery': instance.placeOfDelivery,
      'healthFacilityName': instance.healthFacilityName,
      'attendant': instance.attendant,
      'modeOfDelivery': instance.modeOfDelivery,
      'skinToSkinImmediate': instance.skinToSkinImmediate,
      'apgarScore1Min': instance.apgarScore1Min,
      'apgarScore5Min': instance.apgarScore5Min,
      'apgarScore10Min': instance.apgarScore10Min,
      'resuscitationDone': instance.resuscitationDone,
      'bloodLossMl': instance.bloodLossMl,
      'preEclampsia': instance.preEclampsia,
      'eclampsia': instance.eclampsia,
      'pph': instance.pph,
      'obstructedLabour': instance.obstructedLabour,
      'meconiumGrade': instance.meconiumGrade,
      'motherCondition': instance.motherCondition,
      'oxytocinGiven': instance.oxytocinGiven,
      'misoprostolGiven': instance.misoprostolGiven,
      'heatStableCarbetocin': instance.heatStableCarbetocin,
      'haartGiven': instance.haartGiven,
      'haartRegimen': instance.haartRegimen,
      'otherDrugs': instance.otherDrugs,
      'birthWeightGrams': instance.birthWeightGrams,
      'birthLengthCm': instance.birthLengthCm,
      'headCircumferenceCm': instance.headCircumferenceCm,
      'babyCondition': instance.babyCondition,
      'chxGiven': instance.chxGiven,
      'vitaminKGiven': instance.vitaminKGiven,
      'teoGiven': instance.teoGiven,
      'babyHivExposed': instance.babyHivExposed,
      'arvProphylaxisGiven': instance.arvProphylaxisGiven,
      'earlyInitiationBreastfeeding': instance.earlyInitiationBreastfeeding,
      'notes': instance.notes,
      'conductedBy': instance.conductedBy,
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
    };
