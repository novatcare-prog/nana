import 'package:freezed_annotation/freezed_annotation.dart';

part 'postnatal_visit.freezed.dart';
part 'postnatal_visit.g.dart';

/// Postnatal Care Visit - MCH Handbook Pages 20-22
/// Track mother and baby health after delivery
@freezed
class PostnatalVisit with _$PostnatalVisit {
  const factory PostnatalVisit({
    @JsonKey(name: 'id') String? id,
    @JsonKey(name: 'maternal_profile_id') required String maternalProfileId,
    @JsonKey(name: 'child_profile_id') String? childProfileId,
    
    // Visit Details
    @JsonKey(name: 'visit_date') required DateTime visitDate,
    @JsonKey(name: 'visit_type') required String visitType, // '48 hours', '6 days', '6 weeks', '6 months', 'Other'
    @JsonKey(name: 'days_postpartum') required int daysPostpartum,
    @JsonKey(name: 'health_facility') String? healthFacility,
    @JsonKey(name: 'attended_by') String? attendedBy,
    
    // Mother's Health Assessment
    @JsonKey(name: 'mother_temperature') double? motherTemperature,
    @JsonKey(name: 'mother_blood_pressure') String? motherBloodPressure,
    @JsonKey(name: 'mother_pulse') int? motherPulse,
    @JsonKey(name: 'mother_weight') double? motherWeight,
    
    // Postpartum Complications
    @JsonKey(name: 'excessive_bleeding') @Default(false) bool excessiveBleeding,
    @JsonKey(name: 'foul_discharge') @Default(false) bool foulDischarge,
    @JsonKey(name: 'breast_problems') @Default(false) bool breastProblems,
    @JsonKey(name: 'breast_problems_description') String? breastProblemsDescription,
    @JsonKey(name: 'perineal_wound_infection') @Default(false) bool perinealWoundInfection,
    @JsonKey(name: 'c_section_wound_infection') @Default(false) bool cSectionWoundInfection,
    @JsonKey(name: 'urinary_problems') @Default(false) bool urinaryProblems,
    @JsonKey(name: 'maternal_danger_signs') String? maternalDangerSigns,
    
    // Mental Health
    @JsonKey(name: 'mood_assessment') String? moodAssessment, // 'Good', 'Anxious', 'Depressed', 'Other'
    @JsonKey(name: 'mental_health_notes') String? mentalHealthNotes,
    
    // Baby's Health Assessment
    @JsonKey(name: 'baby_weight') double? babyWeight,
    @JsonKey(name: 'baby_temperature') double? babyTemperature,
    @JsonKey(name: 'baby_feeding_well') @Default(true) bool babyFeedingWell,
    @JsonKey(name: 'baby_feeding_notes') String? babyFeedingNotes,
    
    // Cord Care
    @JsonKey(name: 'cord_status') String? cordStatus, // 'Normal', 'Infected', 'Bleeding', 'Fallen off'
    @JsonKey(name: 'cord_care_advice_given') @Default(true) bool cordCareAdviceGiven,
    
    // Jaundice
    @JsonKey(name: 'jaundice_present') @Default(false) bool jaundicePresent,
    @JsonKey(name: 'jaundice_severity') String? jaundiceSeverity, // 'Mild', 'Moderate', 'Severe'
    
    // Baby Danger Signs
    @JsonKey(name: 'baby_danger_signs') String? babyDangerSigns,
    @JsonKey(name: 'baby_danger_signs_notes') String? babyDangerSignsNotes,
    
    // Breastfeeding Support
    @JsonKey(name: 'breastfeeding_status') String? breastfeedingStatus, // 'Exclusive', 'Mixed', 'Formula only', 'Not feeding'
    @JsonKey(name: 'breastfeeding_frequency') String? breastfeedingFrequency,
    @JsonKey(name: 'latch_quality') String? latchQuality, // 'Good', 'Poor', 'Needs support'
    @JsonKey(name: 'breastfeeding_challenges') String? breastfeedingChallenges,
    @JsonKey(name: 'breastfeeding_support_given') @Default(false) bool breastfeedingSupportGiven,
    @JsonKey(name: 'breastfeeding_support_details') String? breastfeedingSupportDetails,
    
    // Family Planning
    @JsonKey(name: 'family_planning_discussed') @Default(false) bool familyPlanningDiscussed,
    @JsonKey(name: 'family_planning_method_chosen') String? familyPlanningMethodChosen,
    @JsonKey(name: 'family_planning_method_provided') @Default(false) bool familyPlanningMethodProvided,
    @JsonKey(name: 'family_planning_notes') String? familyPlanningNotes,
    
    // Immunizations Given
    @JsonKey(name: 'immunizations_given') String? immunizationsGiven,
    
    // Referrals
    @JsonKey(name: 'referral_made') @Default(false) bool referralMade,
    @JsonKey(name: 'referral_to') String? referralTo,
    @JsonKey(name: 'referral_reason') String? referralReason,
    
    // Follow-up
    @JsonKey(name: 'next_visit_date') DateTime? nextVisitDate,
    @JsonKey(name: 'follow_up_instructions') String? followUpInstructions,
    
    // General Notes
    @JsonKey(name: 'general_notes') String? generalNotes,
    
    @JsonKey(name: 'created_at') DateTime? createdAt,
    @JsonKey(name: 'updated_at') DateTime? updatedAt,
  }) = _PostnatalVisit;

  factory PostnatalVisit.fromJson(Map<String, dynamic> json) =>
      _$PostnatalVisitFromJson(json);
}