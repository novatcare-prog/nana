import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../data/report_repository.dart';
import '../domain/report_models.dart';

/// Provider for the ReportRepository
final reportRepositoryProvider = Provider<ReportRepository>((ref) {
  return ReportRepository(Supabase.instance.client);
});

/// Provider for missed appointments
final missedAppointmentsProvider = FutureProvider((ref) async {
  final repository = ref.watch(reportRepositoryProvider);
  return repository.getMissedAppointments();
});

/// Provider for pending follow-up appointments (past due but still scheduled)
final pendingFollowupAppointmentsProvider = FutureProvider((ref) async {
  final repository = ref.watch(reportRepositoryProvider);
  return repository.getPendingFollowupAppointments();
});

/// Provider for ANC coverage statistics
final ancCoverageStatsProvider = FutureProvider<AncCoverageStats>((ref) async {
  final repository = ref.watch(reportRepositoryProvider);
  return repository.getAncCoverageStats();
});

/// Provider for immunization coverage statistics
final immunizationCoverageStatsProvider = FutureProvider<ImmunizationCoverageStats>((ref) async {
  final repository = ref.watch(reportRepositoryProvider);
  return repository.getImmunizationStats();
});

/// Provider for high-risk patients report (enriched with last visit, priority)
final highRiskPatientsReportProvider = FutureProvider<List<HighRiskPatientReport>>((ref) async {
  final repository = ref.watch(reportRepositoryProvider);
  return repository.getHighRiskPatientsReport();
});
