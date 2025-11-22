import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mch_core/mch_core.dart';
import 'package:mch_core/mch_core.dart';
import 'supabase_providers.dart';

// ============================================
// REPOSITORY PROVIDER
// ============================================

final labResultRepositoryProvider = Provider<LabResultRepository>((ref) {
  final supabase = ref.watch(supabaseClientProvider);
  return LabResultRepository(supabase);
});

// ============================================
// DATA PROVIDERS
// ============================================

/// Get all lab results for a patient
final patientLabResultsProvider = 
    FutureProvider.family<List<LabResult>, String>((ref, patientId) async {
  final repository = ref.watch(labResultRepositoryProvider);
  return repository.getLabResultsByPatientId(patientId);
});

/// Get lab results by test type for a patient
final labResultsByTestTypeProvider = 
    FutureProvider.family<List<LabResult>, LabTestQuery>((ref, query) async {
  final repository = ref.watch(labResultRepositoryProvider);
  return repository.getLabResultsByTestType(query.patientId, query.testType);
});

/// Get abnormal lab results for a patient
final abnormalLabResultsProvider = 
    FutureProvider.family<List<LabResult>, String>((ref, patientId) async {
  final repository = ref.watch(labResultRepositoryProvider);
  return repository.getAbnormalLabResults(patientId);
});

/// Get lab results for an ANC visit
final visitLabResultsProvider = 
    FutureProvider.family<List<LabResult>, String>((ref, visitId) async {
  final repository = ref.watch(labResultRepositoryProvider);
  return repository.getLabResultsByVisitId(visitId);
});

/// Get recent lab results (last 30 days)
final recentLabResultsProvider = FutureProvider<List<LabResult>>((ref) async {
  final repository = ref.watch(labResultRepositoryProvider);
  return repository.getRecentLabResults();
});

/// Get lab result statistics
final labResultStatisticsProvider = 
    FutureProvider<Map<String, int>>((ref) async {
  final repository = ref.watch(labResultRepositoryProvider);
  return repository.getLabResultStatistics();
});

/// Check if patient has a specific test
final hasTestResultProvider = 
    FutureProvider.family<bool, LabTestQuery>((ref, query) async {
  final repository = ref.watch(labResultRepositoryProvider);
  return repository.hasTestResult(query.patientId, query.testType);
});

/// Get latest result for a specific test type
final latestTestResultProvider = 
    FutureProvider.family<LabResult?, LabTestQuery>((ref, query) async {
  final repository = ref.watch(labResultRepositoryProvider);
  return repository.getLatestTestResult(query.patientId, query.testType);
});

// ============================================
// MUTATION PROVIDERS
// ============================================

/// Create lab result
final createLabResultProvider = 
    Provider<Future<LabResult> Function(LabResult)>((ref) {
  final repository = ref.watch(labResultRepositoryProvider);
  return (labResult) async {
    final result = await repository.createLabResult(labResult);
    
    // Invalidate related providers
    ref.invalidate(patientLabResultsProvider(labResult.maternalProfileId));
    ref.invalidate(recentLabResultsProvider);
    ref.invalidate(labResultStatisticsProvider);
    if (labResult.ancVisitId != null) {
      ref.invalidate(visitLabResultsProvider(labResult.ancVisitId!));
    }
    
    return result;
  };
});

/// Update lab result
final updateLabResultProvider = 
    Provider<Future<LabResult> Function(LabResult)>((ref) {
  final repository = ref.watch(labResultRepositoryProvider);
  return (labResult) async {
    final result = await repository.updateLabResult(labResult);
    
    // Invalidate related providers
    ref.invalidate(patientLabResultsProvider(labResult.maternalProfileId));
    ref.invalidate(recentLabResultsProvider);
    ref.invalidate(labResultStatisticsProvider);
    if (labResult.ancVisitId != null) {
      ref.invalidate(visitLabResultsProvider(labResult.ancVisitId!));
    }
    
    return result;
  };
});

/// Delete lab result
final deleteLabResultProvider = 
    Provider<Future<void> Function(String)>((ref) {
  final repository = ref.watch(labResultRepositoryProvider);
  return (labResultId) async {
    await repository.deleteLabResult(labResultId);
    
    // Invalidate all lab result providers
    ref.invalidate(recentLabResultsProvider);
    ref.invalidate(labResultStatisticsProvider);
  };
});

// ============================================
// HELPER CLASSES
// ============================================

/// Query helper for lab test providers
class LabTestQuery {
  final String patientId;
  final LabTestType testType;

  LabTestQuery({
    required this.patientId,
    required this.testType,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LabTestQuery &&
          runtimeType == other.runtimeType &&
          patientId == other.patientId &&
          testType == other.testType;

  @override
  int get hashCode => patientId.hashCode ^ testType.hashCode;
}