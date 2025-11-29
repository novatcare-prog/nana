// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'growth_record.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$GrowthRecordImpl _$$GrowthRecordImplFromJson(Map<String, dynamic> json) =>
    _$GrowthRecordImpl(
      id: json['id'] as String?,
      childId: json['child_profile_id'] as String,
      measurementDate: DateTime.parse(json['visit_date'] as String),
      ageInMonths: (json['age_in_months'] as num).toInt(),
      weightKg: (json['weight_kg'] as num).toDouble(),
      weightForAgeZScore: (json['weight_for_age_z_score'] as num?)?.toDouble(),
      weightInterpretation: json['weight_interpretation'] as String?,
      lengthCm: (json['length_cm'] as num?)?.toDouble(),
      heightCm: (json['height_cm'] as num?)?.toDouble(),
      measuredLying: json['measured_lying'] as bool?,
      heightForAgeZScore: (json['height_for_age_z_score'] as num?)?.toDouble(),
      heightInterpretation: json['height_interpretation'] as String?,
      weightForHeightZScore:
          (json['weight_for_height_z_score'] as num?)?.toDouble(),
      bmiForAgeZScore: (json['bmi_for_age_z_score'] as num?)?.toDouble(),
      muacCm: (json['muac_cm'] as num?)?.toDouble(),
      muacInterpretation: json['muac_interpretation'] as String?,
      headCircumferenceCm: (json['head_circumference_cm'] as num?)?.toDouble(),
      edemaPresent: json['edema_present'] as bool? ?? false,
      edemaGrade: json['edema_grade'] as String?,
      nutritionalStatus: json['nutritional_status'] as String?,
      growthAssessment: json['growth_assessment'] as String?,
      referredForNutrition: json['referred_for_nutrition'] as bool?,
      feedingCounselingGiven: json['feeding_counseling_given'] as bool?,
      feedingRecommendations: json['feeding_recommendations'] as String?,
      concerns: json['concerns'] as String?,
      interventions: json['interventions'] as String?,
      nextVisitDate: json['next_visit_date'] == null
          ? null
          : DateTime.parse(json['next_visit_date'] as String),
      recordedBy: json['recorded_by'] as String?,
      healthFacility: json['health_facility'] as String?,
      notes: json['notes'] as String?,
      measuredBy: json['measured_by'] as String?,
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
      updatedAt: json['updated_at'] == null
          ? null
          : DateTime.parse(json['updated_at'] as String),
    );

Map<String, dynamic> _$$GrowthRecordImplToJson(_$GrowthRecordImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'child_profile_id': instance.childId,
      'visit_date': instance.measurementDate.toIso8601String(),
      'age_in_months': instance.ageInMonths,
      'weight_kg': instance.weightKg,
      'weight_for_age_z_score': instance.weightForAgeZScore,
      'weight_interpretation': instance.weightInterpretation,
      'length_cm': instance.lengthCm,
      'height_cm': instance.heightCm,
      'measured_lying': instance.measuredLying,
      'height_for_age_z_score': instance.heightForAgeZScore,
      'height_interpretation': instance.heightInterpretation,
      'weight_for_height_z_score': instance.weightForHeightZScore,
      'bmi_for_age_z_score': instance.bmiForAgeZScore,
      'muac_cm': instance.muacCm,
      'muac_interpretation': instance.muacInterpretation,
      'head_circumference_cm': instance.headCircumferenceCm,
      'edema_present': instance.edemaPresent,
      'edema_grade': instance.edemaGrade,
      'nutritional_status': instance.nutritionalStatus,
      'growth_assessment': instance.growthAssessment,
      'referred_for_nutrition': instance.referredForNutrition,
      'feeding_counseling_given': instance.feedingCounselingGiven,
      'feeding_recommendations': instance.feedingRecommendations,
      'concerns': instance.concerns,
      'interventions': instance.interventions,
      'next_visit_date': instance.nextVisitDate?.toIso8601String(),
      'recorded_by': instance.recordedBy,
      'health_facility': instance.healthFacility,
      'notes': instance.notes,
      'measured_by': instance.measuredBy,
      'created_at': instance.createdAt?.toIso8601String(),
      'updated_at': instance.updatedAt?.toIso8601String(),
    };
