class ANCVisit {
  final String id;
  final String maternalProfileId; // Matches your recording screen
  final int contactNumber;
  final DateTime visitDate;
  final int gestationWeeks;

  // Vital Signs
  final double? weightKg;
  final String? bloodPressure;
  final double? muacCm;
  final double? haemoglobin;
  final bool? pallor;

  // Physical Examination
  final double? fundalHeight;
  final String? presentation;
  final String? lie;
  final int? foetalHeartRate;
  final bool? foetalMovement;

  // Urine Test
  final String? urineProtein;
  final String? urineGlucose;

  // Lab Tests
  final bool? hbTested;
  final bool? hivTested;
  final String? hivResult;
  final bool? syphilisTested;
  final String? syphilisResult;

  // Preventive Services
  final bool? tdInjectionGiven;
  final bool? iptpSpGiven;
  final int? ifasTabletsGiven;
  final bool? lllinGiven;
  final bool? dewormingGiven;

  // Clinical Notes
  final String? complaints;
  final String? diagnosis;
  final String? treatment;
  final String? notes;

  // Next Visit
  final DateTime? nextVisitDate;
  final String? healthWorkerName;

  // Risk & Timestamps
  final bool? isHighRisk; // ✅ ADDED THIS
  final DateTime createdAt;
  final DateTime updatedAt;

  ANCVisit({
    required this.id,
    required this.maternalProfileId,
    required this.contactNumber,
    required this.visitDate,
    required this.gestationWeeks,
    this.weightKg,
    this.bloodPressure,
    this.muacCm,
    this.haemoglobin,
    this.pallor,
    this.fundalHeight,
    this.presentation,
    this.lie,
    this.foetalHeartRate,
    this.foetalMovement,
    this.urineProtein,
    this.urineGlucose,
    this.hbTested,
    this.hivTested,
    this.hivResult,
    this.syphilisTested,
    this.syphilisResult,
    this.tdInjectionGiven,
    this.iptpSpGiven,
    this.ifasTabletsGiven,
    this.lllinGiven,
    this.dewormingGiven,
    this.complaints,
    this.diagnosis,
    this.treatment,
    this.notes,
    this.nextVisitDate,
    this.healthWorkerName,
    this.isHighRisk, // ✅ ADDED THIS
    required this.createdAt,
    required this.updatedAt,
  });

  factory ANCVisit.fromJson(Map<String, dynamic> json) {
    return ANCVisit(
      id: json['id'] as String,
      maternalProfileId: json['maternal_profile_id'] as String,
      contactNumber: json['contact_number'] as int,
      visitDate: DateTime.parse(json['visit_date'] as String),
      gestationWeeks: json['gestation_weeks'] as int,
      weightKg: (json['weight_kg'] as num?)?.toDouble(),
      bloodPressure: json['blood_pressure'] as String?,
      muacCm: (json['muac_cm'] as num?)?.toDouble(),
      haemoglobin: (json['haemoglobin'] as num?)?.toDouble(),
      pallor: json['pallor'] as bool?,
      fundalHeight: (json['fundal_height'] as num?)?.toDouble(),
      presentation: json['presentation'] as String?,
      lie: json['lie'] as String?,
      foetalHeartRate: json['foetal_heart_rate'] as int?,
      foetalMovement: json['foetal_movement'] as bool?,
      urineProtein: json['urine_protein'] as String?,
      urineGlucose: json['urine_glucose'] as String?,
      hbTested: json['hb_tested'] as bool?,
      hivTested: json['hiv_tested'] as bool?,
      hivResult: json['hiv_result'] as String?,
      syphilisTested: json['syphilis_tested'] as bool?,
      syphilisResult: json['syphilis_result'] as String?,
      tdInjectionGiven: json['td_injection_given'] as bool?,
      iptpSpGiven: json['iptp_sp_given'] as bool?,
      ifasTabletsGiven: json['ifas_tablets_given'] as int?,
      lllinGiven: json['lllin_given'] as bool?,
      dewormingGiven: json['deworming_given'] as bool?,
      complaints: json['complaints'] as String?,
      diagnosis: json['diagnosis'] as String?,
      treatment: json['treatment'] as String?,
      notes: json['notes'] as String?,
      nextVisitDate: json['next_visit_date'] != null
          ? DateTime.parse(json['next_visit_date'] as String)
          : null,
      healthWorkerName: json['health_worker_name'] as String?,
      isHighRisk: json['is_high_risk'] as bool?, // ✅ ADDED THIS
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'maternal_profile_id': maternalProfileId,
      'contact_number': contactNumber,
      'visit_date': visitDate.toIso8601String(),
      'gestation_weeks': gestationWeeks,
      'weight_kg': weightKg,
      'blood_pressure': bloodPressure,
      'muac_cm': muacCm,
      'haemoglobin': haemoglobin,
      'pallor': pallor,
      'fundal_height': fundalHeight,
      'presentation': presentation,
      'lie': lie,
      'foetal_heart_rate': foetalHeartRate,
      'foetal_movement': foetalMovement,
      'urine_protein': urineProtein,
      'urine_glucose': urineGlucose,
      'hb_tested': hbTested,
      'hiv_tested': hivTested,
      'hiv_result': hivResult,
      'syphilis_tested': syphilisTested,
      'syphilis_result': syphilisResult,
      'td_injection_given': tdInjectionGiven,
      'iptp_sp_given': iptpSpGiven,
      'ifas_tablets_given': ifasTabletsGiven,
      'lllin_given': lllinGiven,
      'deworming_given': dewormingGiven,
      'complaints': complaints,
      'diagnosis': diagnosis,
      'treatment': treatment,
      'notes': notes,
      'next_visit_date': nextVisitDate?.toIso8601String(),
      'health_worker_name': healthWorkerName,
      'is_high_risk': isHighRisk, // ✅ ADDED THIS
      // Supabase handles createdAt/updatedAt on its own
    };
  }
}