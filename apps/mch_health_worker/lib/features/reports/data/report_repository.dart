import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:mch_core/mch_core.dart';

import '../domain/report_models.dart';

/// Report Repository for fetching report-specific data
/// 
/// Note: Uses existing SupabaseMaternalProfileRepository for:
/// - getHighRiskProfiles()
/// - getProfilesDueSoon()
/// - getStatistics()
/// 
/// This repository adds additional report-specific queries.
class ReportRepository {
  final SupabaseClient _supabase;

  ReportRepository(this._supabase);

  /// Get missed appointments (past scheduled appointments not marked completed)
  Future<List<Appointment>> getMissedAppointments() async {
    try {
      final response = await _supabase
          .from('appointments')
          .select()
          .eq('appointment_status', 'missed')
          .order('appointment_date', ascending: false);

      return (response as List)
          .map((json) => Appointment.fromJson(json))
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch missed appointments: $e');
    }
  }

  /// Get appointments that are past due but still marked as scheduled
  /// These are likely no-shows that need follow-up
  Future<List<Appointment>> getPendingFollowupAppointments() async {
    try {
      final now = DateTime.now();
      final response = await _supabase
          .from('appointments')
          .select()
          .eq('appointment_status', 'scheduled')
          .lt('appointment_date', now.toIso8601String())
          .order('appointment_date', ascending: false);

      return (response as List)
          .map((json) => Appointment.fromJson(json))
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch pending follow-up appointments: $e');
    }
  }

  /// Get ANC coverage statistics
  /// Returns visit counts grouped by visit number (1st, 2nd, 3rd, 4th+)
  Future<AncCoverageStats> getAncCoverageStats() async {
    try {
      // Get total active patients (with EDD in future)
      final patientsResult = await _supabase
          .from('maternal_profiles')
          .select('id')
          .gte('edd', DateTime.now().toIso8601String())
          .count(CountOption.exact);

      final totalActivePatients = patientsResult.count;

      // Get visit counts by visit number
      final visitsResponse = await _supabase
          .from('anc_visits')
          .select('maternal_profile_id, visit_number');

      final visits = visitsResponse as List;
      
      // Count unique patients per visit number
      final visitsByNumber = <int, Set<String>>{};
      for (final visit in visits) {
        final visitNumber = visit['visit_number'] as int? ?? 1;
        final profileId = visit['maternal_profile_id'] as String;
        visitsByNumber.putIfAbsent(visitNumber, () => <String>{});
        visitsByNumber[visitNumber]!.add(profileId);
      }

      return AncCoverageStats(
        totalActivePatients: totalActivePatients,
        firstVisitCount: visitsByNumber[1]?.length ?? 0,
        secondVisitCount: visitsByNumber[2]?.length ?? 0,
        thirdVisitCount: visitsByNumber[3]?.length ?? 0,
        fourthPlusVisitCount: visitsByNumber.entries
            .where((e) => e.key >= 4)
            .fold<int>(0, (sum, e) => sum + e.value.length),
      );
    } catch (e) {
      throw Exception('Failed to fetch ANC coverage stats: $e');
    }
  }

  /// Get immunization coverage statistics  
  Future<ImmunizationCoverageStats> getImmunizationStats() async {
    try {
      // Get total active patients
      final patientsResult = await _supabase
          .from('maternal_profiles')
          .select('id')
          .gte('edd', DateTime.now().toIso8601String())
          .count(CountOption.exact);

      final totalActivePatients = patientsResult.count;

      // Count patients with each vaccine type
      final immunizationsResponse = await _supabase
          .from('maternal_immunizations')
          .select('maternal_profile_id, vaccine_type');

      final immunizations = immunizationsResponse as List;

      // Count unique patients per vaccine type
      final vaccinesByType = <String, Set<String>>{};
      for (final imm in immunizations) {
        final vaccineType = imm['vaccine_type'] as String? ?? 'unknown';
        final profileId = imm['maternal_profile_id'] as String;
        vaccinesByType.putIfAbsent(vaccineType, () => <String>{});
        vaccinesByType[vaccineType]!.add(profileId);
      }

      return ImmunizationCoverageStats(
        totalActivePatients: totalActivePatients,
        ttVaccinated: vaccinesByType['tt']?.length ?? 0,
        tdVaccinated: vaccinesByType['td']?.length ?? 0,
        otherVaccines: vaccinesByType.entries
            .where((e) => e.key != 'tt' && e.key != 'td')
            .map((e) => VaccineCount(type: e.key, count: e.value.length))
            .toList(),
      );
    } catch (e) {
      throw Exception('Failed to fetch immunization stats: $e');
    }
  }

  /// Get high risk patients with their risk factors for the report
  /// Enriches the base query with additional context
  Future<List<HighRiskPatientReport>> getHighRiskPatientsReport() async {
    try {
      // Get high risk profiles
      final response = await _supabase
          .from('maternal_profiles')
          .select()
          .or('diabetes.eq.true,hypertension.eq.true,hiv_result.eq.positive,tuberculosis.eq.true,previous_cs.eq.true,age.gt.35,age.lt.18')
          .order('edd', ascending: true);

      final profiles = (response as List)
          .map((json) => MaternalProfile.fromJson(json))
          .toList();

      if (profiles.isEmpty) {
        return [];
      }

      // OPTIMIZED: Get all last visits in a single query using RPC or aggregation
      // Instead of N+1 queries, we fetch all visits and group client-side
      final profileIds = profiles.map((p) => p.id!).toList();
      
      final visitsResponse = await _supabase
          .from('anc_visits')
          .select('maternal_profile_id, visit_date')
          .inFilter('maternal_profile_id', profileIds)
          .order('visit_date', ascending: false);

      // Build a map of profile_id -> last visit date
      final lastVisitMap = <String, DateTime>{};
      for (final visit in visitsResponse as List) {
        final profileId = visit['maternal_profile_id'] as String;
        if (!lastVisitMap.containsKey(profileId)) {
          // First occurrence is the latest due to ordering
          final visitDate = DateTime.tryParse(visit['visit_date'] as String);
          if (visitDate != null) {
            lastVisitMap[profileId] = visitDate;
          }
        }
      }

      // Build enriched patient list
      final enrichedPatients = profiles.map((profile) {
        return HighRiskPatientReport(
          profile: profile,
          riskFactors: _getRiskFactors(profile),
          lastVisitDate: lastVisitMap[profile.id],
          daysUntilEdd: profile.edd != null 
              ? profile.edd!.difference(DateTime.now()).inDays 
              : null,
        );
      }).toList();

      return enrichedPatients;
    } catch (e) {
      throw Exception('Failed to fetch high risk patients report: $e');
    }
  }

  List<String> _getRiskFactors(MaternalProfile profile) {
    final factors = <String>[];
    if (profile.diabetes == true) factors.add('Diabetes');
    if (profile.hypertension == true) factors.add('Hypertension');
    if (profile.hivResult == HivTestResult.reactive) factors.add('HIV+');
    if (profile.tuberculosis == true) factors.add('Tuberculosis');
    if (profile.previousCs == true) factors.add('Previous C-Section');
    if (profile.age > 35) factors.add('Age >35');
    if (profile.age > 0 && profile.age < 18) factors.add('Age <18');
    return factors;
  }
}
