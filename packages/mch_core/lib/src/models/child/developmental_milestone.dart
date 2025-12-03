import 'package:freezed_annotation/freezed_annotation.dart';

part 'developmental_milestone.freezed.dart';
part 'developmental_milestone.g.dart';

/// Developmental Milestone Assessment - MCH Handbook Pages 35-36
/// Track child development across multiple domains at key age points
@freezed
class DevelopmentalMilestone with _$DevelopmentalMilestone {
  const factory DevelopmentalMilestone({
    @JsonKey(name: 'id') String? id,
    @JsonKey(name: 'child_profile_id') required String childProfileId,
    
    // Assessment Details
    @JsonKey(name: 'assessment_date') required DateTime assessmentDate,
    @JsonKey(name: 'age_at_assessment_weeks') int? ageAtAssessmentWeeks,
    @JsonKey(name: 'age_at_assessment_months') int? ageAtAssessmentMonths,
    @JsonKey(name: 'assessed_by') String? assessedBy,
    
    // Motor Skills
    @JsonKey(name: 'motor_gross_appropriate') @Default(true) bool motorGrossAppropriate,
    @JsonKey(name: 'motor_gross_notes') String? motorGrossNotes,
    @JsonKey(name: 'motor_fine_appropriate') @Default(true) bool motorFineAppropriate,
    @JsonKey(name: 'motor_fine_notes') String? motorFineNotes,
    
    // Language & Communication
    @JsonKey(name: 'language_appropriate') @Default(true) bool languageAppropriate,
    @JsonKey(name: 'language_notes') String? languageNotes,
    
    // Social & Emotional
    @JsonKey(name: 'social_appropriate') @Default(true) bool socialAppropriate,
    @JsonKey(name: 'social_notes') String? socialNotes,
    
    // Cognitive Development
    @JsonKey(name: 'cognitive_appropriate') @Default(true) bool cognitiveAppropriate,
    @JsonKey(name: 'cognitive_notes') String? cognitiveNotes,
    
    // Red Flags (Concerns)
    @JsonKey(name: 'red_flags_present') @Default(false) bool redFlagsPresent,
    @JsonKey(name: 'red_flags_description') String? redFlagsDescription,
    
    // Intervention
    @JsonKey(name: 'intervention_needed') @Default(false) bool interventionNeeded,
    @JsonKey(name: 'intervention_plan') String? interventionPlan,
    @JsonKey(name: 'referral_made') @Default(false) bool referralMade,
    @JsonKey(name: 'referral_to') String? referralTo,
    
    // Follow-up
    @JsonKey(name: 'next_assessment_date') DateTime? nextAssessmentDate,
    
    // Overall Assessment
    @JsonKey(name: 'overall_status') String? overallStatus, // 'On Track', 'Needs Monitoring', 'Needs Intervention'
    @JsonKey(name: 'general_notes') String? generalNotes,
    
    @JsonKey(name: 'created_at') DateTime? createdAt,
    @JsonKey(name: 'updated_at') DateTime? updatedAt,
  }) = _DevelopmentalMilestone;

  factory DevelopmentalMilestone.fromJson(Map<String, dynamic> json) =>
      _$DevelopmentalMilestoneFromJson(json);
}