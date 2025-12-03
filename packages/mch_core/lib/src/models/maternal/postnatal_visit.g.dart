// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'postnatal_visit.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PostnatalVisitImpl _$$PostnatalVisitImplFromJson(Map<String, dynamic> json) =>
    _$PostnatalVisitImpl(
      id: json['id'] as String?,
      maternalProfileId: json['maternal_profile_id'] as String,
      childProfileId: json['child_profile_id'] as String?,
      visitDate: DateTime.parse(json['visit_date'] as String),
      visitType: json['visit_type'] as String,
      daysPostpartum: (json['days_postpartum'] as num).toInt(),
      healthFacility: json['health_facility'] as String?,
      attendedBy: json['attended_by'] as String?,
      motherTemperature: (json['mother_temperature'] as num?)?.toDouble(),
      motherBloodPressure: json['mother_blood_pressure'] as String?,
      motherPulse: (json['mother_pulse'] as num?)?.toInt(),
      motherWeight: (json['mother_weight'] as num?)?.toDouble(),
      excessiveBleeding: json['excessive_bleeding'] as bool? ?? false,
      foulDischarge: json['foul_discharge'] as bool? ?? false,
      breastProblems: json['breast_problems'] as bool? ?? false,
      breastProblemsDescription: json['breast_problems_description'] as String?,
      perinealWoundInfection:
          json['perineal_wound_infection'] as bool? ?? false,
      cSectionWoundInfection:
          json['c_section_wound_infection'] as bool? ?? false,
      urinaryProblems: json['urinary_problems'] as bool? ?? false,
      maternalDangerSigns: json['maternal_danger_signs'] as String?,
      moodAssessment: json['mood_assessment'] as String?,
      mentalHealthNotes: json['mental_health_notes'] as String?,
      babyWeight: (json['baby_weight'] as num?)?.toDouble(),
      babyTemperature: (json['baby_temperature'] as num?)?.toDouble(),
      babyFeedingWell: json['baby_feeding_well'] as bool? ?? true,
      babyFeedingNotes: json['baby_feeding_notes'] as String?,
      cordStatus: json['cord_status'] as String?,
      cordCareAdviceGiven: json['cord_care_advice_given'] as bool? ?? true,
      jaundicePresent: json['jaundice_present'] as bool? ?? false,
      jaundiceSeverity: json['jaundice_severity'] as String?,
      babyDangerSigns: json['baby_danger_signs'] as String?,
      babyDangerSignsNotes: json['baby_danger_signs_notes'] as String?,
      breastfeedingStatus: json['breastfeeding_status'] as String?,
      breastfeedingFrequency: json['breastfeeding_frequency'] as String?,
      latchQuality: json['latch_quality'] as String?,
      breastfeedingChallenges: json['breastfeeding_challenges'] as String?,
      breastfeedingSupportGiven:
          json['breastfeeding_support_given'] as bool? ?? false,
      breastfeedingSupportDetails:
          json['breastfeeding_support_details'] as String?,
      familyPlanningDiscussed:
          json['family_planning_discussed'] as bool? ?? false,
      familyPlanningMethodChosen:
          json['family_planning_method_chosen'] as String?,
      familyPlanningMethodProvided:
          json['family_planning_method_provided'] as bool? ?? false,
      familyPlanningNotes: json['family_planning_notes'] as String?,
      immunizationsGiven: json['immunizations_given'] as String?,
      referralMade: json['referral_made'] as bool? ?? false,
      referralTo: json['referral_to'] as String?,
      referralReason: json['referral_reason'] as String?,
      nextVisitDate: json['next_visit_date'] == null
          ? null
          : DateTime.parse(json['next_visit_date'] as String),
      followUpInstructions: json['follow_up_instructions'] as String?,
      generalNotes: json['general_notes'] as String?,
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
      updatedAt: json['updated_at'] == null
          ? null
          : DateTime.parse(json['updated_at'] as String),
    );

Map<String, dynamic> _$$PostnatalVisitImplToJson(
        _$PostnatalVisitImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'maternal_profile_id': instance.maternalProfileId,
      'child_profile_id': instance.childProfileId,
      'visit_date': instance.visitDate.toIso8601String(),
      'visit_type': instance.visitType,
      'days_postpartum': instance.daysPostpartum,
      'health_facility': instance.healthFacility,
      'attended_by': instance.attendedBy,
      'mother_temperature': instance.motherTemperature,
      'mother_blood_pressure': instance.motherBloodPressure,
      'mother_pulse': instance.motherPulse,
      'mother_weight': instance.motherWeight,
      'excessive_bleeding': instance.excessiveBleeding,
      'foul_discharge': instance.foulDischarge,
      'breast_problems': instance.breastProblems,
      'breast_problems_description': instance.breastProblemsDescription,
      'perineal_wound_infection': instance.perinealWoundInfection,
      'c_section_wound_infection': instance.cSectionWoundInfection,
      'urinary_problems': instance.urinaryProblems,
      'maternal_danger_signs': instance.maternalDangerSigns,
      'mood_assessment': instance.moodAssessment,
      'mental_health_notes': instance.mentalHealthNotes,
      'baby_weight': instance.babyWeight,
      'baby_temperature': instance.babyTemperature,
      'baby_feeding_well': instance.babyFeedingWell,
      'baby_feeding_notes': instance.babyFeedingNotes,
      'cord_status': instance.cordStatus,
      'cord_care_advice_given': instance.cordCareAdviceGiven,
      'jaundice_present': instance.jaundicePresent,
      'jaundice_severity': instance.jaundiceSeverity,
      'baby_danger_signs': instance.babyDangerSigns,
      'baby_danger_signs_notes': instance.babyDangerSignsNotes,
      'breastfeeding_status': instance.breastfeedingStatus,
      'breastfeeding_frequency': instance.breastfeedingFrequency,
      'latch_quality': instance.latchQuality,
      'breastfeeding_challenges': instance.breastfeedingChallenges,
      'breastfeeding_support_given': instance.breastfeedingSupportGiven,
      'breastfeeding_support_details': instance.breastfeedingSupportDetails,
      'family_planning_discussed': instance.familyPlanningDiscussed,
      'family_planning_method_chosen': instance.familyPlanningMethodChosen,
      'family_planning_method_provided': instance.familyPlanningMethodProvided,
      'family_planning_notes': instance.familyPlanningNotes,
      'immunizations_given': instance.immunizationsGiven,
      'referral_made': instance.referralMade,
      'referral_to': instance.referralTo,
      'referral_reason': instance.referralReason,
      'next_visit_date': instance.nextVisitDate?.toIso8601String(),
      'follow_up_instructions': instance.followUpInstructions,
      'general_notes': instance.generalNotes,
      'created_at': instance.createdAt?.toIso8601String(),
      'updated_at': instance.updatedAt?.toIso8601String(),
    };
