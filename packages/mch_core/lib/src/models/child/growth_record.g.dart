// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'growth_record.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$GrowthRecordImpl _$$GrowthRecordImplFromJson(Map<String, dynamic> json) =>
    _$GrowthRecordImpl(
      id: json['id'] as String,
      childId: json['childId'] as String,
      measurementDate: DateTime.parse(json['measurementDate'] as String),
      ageInMonths: (json['ageInMonths'] as num).toInt(),
      weightKg: (json['weightKg'] as num).toDouble(),
      weightForAgeZScore: json['weightForAgeZScore'] as String?,
      weightInterpretation: json['weightInterpretation'] as String?,
      lengthHeightCm: (json['lengthHeightCm'] as num).toDouble(),
      measuredLying: json['measuredLying'] as bool?,
      heightForAgeZScore: json['heightForAgeZScore'] as String?,
      heightInterpretation: json['heightInterpretation'] as String?,
      muacCm: (json['muacCm'] as num?)?.toDouble(),
      muacInterpretation: json['muacInterpretation'] as String?,
      edemaPresent: json['edemaPresent'] as bool?,
      edemaGrade: json['edemaGrade'] as String?,
      nutritionalStatus: json['nutritionalStatus'] as String?,
      referredForNutrition: json['referredForNutrition'] as bool?,
      feedingCounselingGiven: json['feedingCounselingGiven'] as bool?,
      feedingRecommendations: json['feedingRecommendations'] as String?,
      notes: json['notes'] as String?,
      measuredBy: json['measuredBy'] as String?,
      nextVisitDate: json['nextVisitDate'] == null
          ? null
          : DateTime.parse(json['nextVisitDate'] as String),
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$$GrowthRecordImplToJson(_$GrowthRecordImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'childId': instance.childId,
      'measurementDate': instance.measurementDate.toIso8601String(),
      'ageInMonths': instance.ageInMonths,
      'weightKg': instance.weightKg,
      'weightForAgeZScore': instance.weightForAgeZScore,
      'weightInterpretation': instance.weightInterpretation,
      'lengthHeightCm': instance.lengthHeightCm,
      'measuredLying': instance.measuredLying,
      'heightForAgeZScore': instance.heightForAgeZScore,
      'heightInterpretation': instance.heightInterpretation,
      'muacCm': instance.muacCm,
      'muacInterpretation': instance.muacInterpretation,
      'edemaPresent': instance.edemaPresent,
      'edemaGrade': instance.edemaGrade,
      'nutritionalStatus': instance.nutritionalStatus,
      'referredForNutrition': instance.referredForNutrition,
      'feedingCounselingGiven': instance.feedingCounselingGiven,
      'feedingRecommendations': instance.feedingRecommendations,
      'notes': instance.notes,
      'measuredBy': instance.measuredBy,
      'nextVisitDate': instance.nextVisitDate?.toIso8601String(),
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
    };
