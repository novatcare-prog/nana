import 'package:freezed_annotation/freezed_annotation.dart';

part 'postnatal_visit.freezed.dart';
part 'postnatal_visit.g.dart';

/// Postnatal Visit - MCH Handbook Page 20
/// Schedule: 4 contacts - Within 48hrs, 1-2 weeks, 4-6 weeks, 4-6 months
@freezed
class PostnatalVisit with _$PostnatalVisit {
  const factory PostnatalVisit({
    required String id,
    required String maternalProfileId,
    String? childId, // Link to child if already registered
    required int contactNumber, // 1-4
    required DateTime visitDate,
    
    // Timing
    String? timingLabel, // "Within 48hrs", "1-2 weeks", "4-6 weeks", "4-6 months"
    
    // MOTHER Assessment
    String? bloodPressure,
    double? temperature,
    int? pulseRate,
    int? respiratoryRate,
    String? generalCondition,
    
    // Breast Examination
    String? breastCondition,
    bool? breastEngorgement,
    bool? crackedNipples,
    bool? mastitis,
    
    // C-Section Scar (if applicable)
    String? csScarCondition,
    
    // Uterus Involution
    String? uterusInvolution, // Well involuted, Not well involuted
    
    // Pelvic Examination
    String? pelvicExam,
    String? episiotomyCondition,
    
    // Lochia (discharge)
    String? lochiaSmell,
    String? lochiaAmount,
    String? lochiaColor,
    
    // Lab Tests
    double? haemoglobin,
    
    // HIV Status
    bool? motherHivTested,
    String? motherHivResult,
    bool? motherOnHaart,
    String? haartRegimen,
    
    // Family Planning
    bool? fpCounselingDone,
    String? fpMethodChosen,
    bool? fpMethodProvided,
    
    // Maternal Mental Health
    bool? maternalMentalHealthScreened,
    String? mentalHealthStatus,
    
    // BABY Assessment (if present)
    String? babyGeneralCondition,
    double? babyTemperature,
    int? babyBreathsPerMinute,
    
    // Feeding
    bool? exclusiveBreastfeeding,
    String? breastfeedingPositioning, // Correct, Not correct
    String? breastfeedingAttachment, // Good, Poor
    
    // Umbilical Cord
    String? umbilicalCordStatus, // Clean, Dry, Bleeding, Infected
    
    // Baby Immunization
    bool? babyImmunizationStarted,
    
    // HEI (HIV Exposed Infant)
    bool? babyHivExposed,
    bool? babyOnArvProphylaxis,
    bool? babyOnCtxProphylaxis,
    
    // Other Baby Issues
    bool? babyIrritable,
    String? otherBabyProblems,
    
    // Clinical Notes
    String? motherNotes,
    String? babyNotes,
    String? diagnosis,
    String? treatment,
    
    // Next Visit
    DateTime? nextVisitDate,
    String? healthWorkerName,
    
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _PostnatalVisit;

  factory PostnatalVisit.fromJson(Map<String, dynamic> json) =>
      _$PostnatalVisitFromJson(json);
}