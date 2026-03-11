import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mch_core/mch_core.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/ai_risk_assessment.dart';
import '../services/risk_assessment_service.dart';
import '../services/clinical_support_service.dart';
import '../services/dropout_prediction_service.dart';

// ── GeminiService provider ───────────────────────────────────────────────────
// GeminiService is initialized in main.dart and stored here for app-wide access.
final geminiServiceProvider = Provider<GeminiService>((ref) {
  throw UnimplementedError(
    'geminiServiceProvider must be overridden in main.dart with ProviderScope overrides.',
  );
});

// ── RiskAssessmentService provider ──────────────────────────────────────────
final riskAssessmentServiceProvider = Provider<RiskAssessmentService>((ref) {
  return RiskAssessmentService(ref.watch(geminiServiceProvider));
});

// ── Per-patient risk assessment ──────────────────────────────────────────────
// Cache key: patient id. Results are cached for 24 hours to avoid redundant API calls.
final _riskAssessmentCache = <String, ({AiRiskAssessment result, DateTime fetchedAt})>{};

final patientRiskAssessmentProvider =
    AsyncNotifierProviderFamily<PatientRiskAssessmentNotifier, AiRiskAssessment, String>(
  PatientRiskAssessmentNotifier.new,
);

class PatientRiskAssessmentNotifier
    extends FamilyAsyncNotifier<AiRiskAssessment, String> {
  // arg = patient id

  @override
  Future<AiRiskAssessment> build(String patientId) async {
    return _fetchOrCached(patientId);
  }

  Future<AiRiskAssessment> _fetchOrCached(String patientId) async {
    // Check cache (24-hour TTL)
    final cached = _riskAssessmentCache[patientId];
    if (cached != null &&
        DateTime.now().difference(cached.fetchedAt).inHours < 24) {
      return cached.result.copyWith(isFromCache: true);
    }

    final service = ref.read(riskAssessmentServiceProvider);
    final supabase = ref.read(supabaseClientProvider);

    // Fetch required data in parallel
    final profileFuture = supabase
        .from('maternal_profiles')
        .select()
        .eq('id', patientId)
        .single()
        .then((data) => MaternalProfile.fromJson(data));

    final visitsFuture = supabase
        .from('anc_visits')
        .select()
        .eq('maternal_profile_id', patientId)
        .order('visit_date', ascending: false)
        .limit(10)
        .then((data) => (data as List).map((e) => ANCVisit.fromJson(e)).toList());

    final labsFuture = supabase
        .from('lab_results')
        .select()
        .eq('maternal_profile_id', patientId)
        .order('test_date', ascending: false)
        .limit(10)
        .then((data) => (data as List).map((e) => LabResult.fromJson(e)).toList());

    final appointmentsFuture = supabase
        .from('appointments')
        .select()
        .eq('maternal_profile_id', patientId)
        .order('appointment_date', ascending: false)
        .limit(20)
        .then((data) => (data as List).map((e) => Appointment.fromJson(e)).toList());

    final results = await Future.wait([
      profileFuture,
      visitsFuture,
      labsFuture,
      appointmentsFuture,
    ]);

    final profile = results[0] as MaternalProfile;
    final visits = results[1] as List<ANCVisit>;
    final labs = results[2] as List<LabResult>;
    final appointments = results[3] as List<Appointment>;

    final assessment = await service.assessPatientRisk(
      profile: profile,
      ancVisits: visits,
      labResults: labs,
      appointments: appointments,
    );

    // Cache result
    _riskAssessmentCache[patientId] = (result: assessment, fetchedAt: DateTime.now());
    return assessment;
  }

  /// Force refresh (ignores cache).
  Future<void> refresh(String patientId) async {
    _riskAssessmentCache.remove(patientId);
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => _fetchOrCached(patientId));
  }
}

// ── Supabase client provider (convenience) ──────────────────────────────────
final supabaseClientProvider = Provider((ref) => Supabase.instance.client);

// ── Phase 4: ClinicalSupportService provider ─────────────────────────────────
final clinicalSupportServiceProvider = Provider<ClinicalSupportService>((ref) {
  return ClinicalSupportService(ref.watch(geminiServiceProvider));
});

/// Per-patient clinical briefing provider.
/// arg: patientId
final patientClinicalBriefingProvider =
    AsyncNotifierProviderFamily<PatientClinicalBriefingNotifier, ClinicalBriefing, String>(
  PatientClinicalBriefingNotifier.new,
);

class PatientClinicalBriefingNotifier
    extends FamilyAsyncNotifier<ClinicalBriefing, String> {
  @override
  Future<ClinicalBriefing> build(String patientId) async {
    return _fetch(patientId);
  }

  Future<ClinicalBriefing> _fetch(String patientId) async {
    final service = ref.read(clinicalSupportServiceProvider);
    final supabase = ref.read(supabaseClientProvider);

    final profile = await supabase
        .from('maternal_profiles')
        .select()
        .eq('id', patientId)
        .single()
        .then((d) => MaternalProfile.fromJson(d));

    final visits = await supabase
        .from('anc_visits')
        .select()
        .eq('maternal_profile_id', patientId)
        .order('visit_date', ascending: false)
        .limit(5)
        .then((d) => (d as List).map((e) => ANCVisit.fromJson(e)).toList());

    final labs = await supabase
        .from('lab_results')
        .select()
        .eq('maternal_profile_id', patientId)
        .order('test_date', ascending: false)
        .limit(5)
        .then((d) => (d as List).map((e) => LabResult.fromJson(e)).toList());

    return service.generateVisitBriefing(
      profile: profile,
      previousVisits: visits,
      labResults: labs,
      expectedVisitNumber: visits.length + 1,
    );
  }
}

// ── Phase 5: DropoutPredictionService provider ──────────────────────────────
final dropoutPredictionServiceProvider =
    Provider<DropoutPredictionService>((ref) {
  return DropoutPredictionService(ref.watch(geminiServiceProvider));
});

/// Per-patient dropout prediction provider.
final patientDropoutPredictionProvider =
    AsyncNotifierProviderFamily<PatientDropoutNotifier, DropoutPrediction, String>(
  PatientDropoutNotifier.new,
);

class PatientDropoutNotifier
    extends FamilyAsyncNotifier<DropoutPrediction, String> {
  @override
  Future<DropoutPrediction> build(String patientId) async {
    final service = ref.read(dropoutPredictionServiceProvider);
    final supabase = ref.read(supabaseClientProvider);

    final profile = await supabase
        .from('maternal_profiles')
        .select()
        .eq('id', patientId)
        .single()
        .then((d) => MaternalProfile.fromJson(d));

    final visits = await supabase
        .from('anc_visits')
        .select()
        .eq('maternal_profile_id', patientId)
        .order('visit_date', ascending: false)
        .limit(10)
        .then((d) => (d as List).map((e) => ANCVisit.fromJson(e)).toList());

    final appointments = await supabase
        .from('appointments')
        .select()
        .eq('maternal_profile_id', patientId)
        .order('appointment_date', ascending: false)
        .limit(20)
        .then((d) => (d as List).map((e) => Appointment.fromJson(e)).toList());

    return service.predictDropout(
      profile: profile,
      appointmentHistory: appointments,
      visitHistory: visits,
    );
  }
}
