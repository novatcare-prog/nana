import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mch_core/mch_core.dart';
import 'supabase_providers.dart';
import '../services/hive_service.dart';
import '../services/connectivity_service.dart';

// ============================================
// REPOSITORY PROVIDER
// ============================================

final labResultRepositoryProvider = Provider<LabResultRepository>((ref) {
  final supabase = ref.watch(supabaseClientProvider);
  return LabResultRepository(supabase);
});

// ============================================
// DATA PROVIDERS (WITH OFFLINE SUPPORT)
// ============================================

/// Get all lab results for a patient (offline-first)
final patientLabResultsProvider = 
    FutureProvider.family<List<LabResult>, String>((ref, patientId) async {
  final repository = ref.watch(labResultRepositoryProvider);
  final connectivity = ref.watch(connectivityServiceProvider);
  
  try {
    if (connectivity.isOnline) {
      // Fetch from Supabase
      final results = await repository.getLabResultsByPatientId(patientId);
      // Cache for offline use
      await HiveService.cacheLabResults(patientId, results);
      return results;
    }
  } catch (e) {
    print('⚠️ Failed to fetch lab results online: $e');
  }
  
  // Fallback to cache
  return HiveService.getCachedLabResults(patientId);
});

/// Get lab results by test type for a patient (offline-first)
final labResultsByTestTypeProvider = 
    FutureProvider.family<List<LabResult>, LabTestQuery>((ref, query) async {
  // Use the main provider which handles caching
  final allResults = await ref.watch(patientLabResultsProvider(query.patientId).future);
  return allResults.where((r) => r.testType == query.testType).toList();
});

/// Get abnormal lab results for a patient (offline-first)
final abnormalLabResultsProvider = 
    FutureProvider.family<List<LabResult>, String>((ref, patientId) async {
  // Use the main provider which handles caching
  final allResults = await ref.watch(patientLabResultsProvider(patientId).future);
  return allResults.where((r) => r.isAbnormal == true).toList();
});

/// Get lab results for an ANC visit (offline-first)
final visitLabResultsProvider = 
    FutureProvider.family<List<LabResult>, String>((ref, visitId) async {
  final repository = ref.watch(labResultRepositoryProvider);
  final connectivity = ref.watch(connectivityServiceProvider);
  
  try {
    if (connectivity.isOnline) {
      return await repository.getLabResultsByVisitId(visitId);
    }
  } catch (e) {
    print('⚠️ Failed to fetch visit lab results online: $e');
  }
  
  // For visit-specific results when offline, we'd need visit ID in cache
  // For now, return empty list - this is a read-only fallback
  return [];
});

/// Get recent lab results (last 30 days)
final recentLabResultsProvider = FutureProvider<List<LabResult>>((ref) async {
  final repository = ref.watch(labResultRepositoryProvider);
  final connectivity = ref.watch(connectivityServiceProvider);
  
  try {
    if (connectivity.isOnline) {
      return await repository.getRecentLabResults();
    }
  } catch (e) {
    print('⚠️ Failed to fetch recent lab results: $e');
  }
  
  // When offline, return empty - recent results require server query
  return [];
});

/// Get lab result statistics
final labResultStatisticsProvider = 
    FutureProvider<Map<String, int>>((ref) async {
  final repository = ref.watch(labResultRepositoryProvider);
  final connectivity = ref.watch(connectivityServiceProvider);
  
  try {
    if (connectivity.isOnline) {
      return await repository.getLabResultStatistics();
    }
  } catch (e) {
    print('⚠️ Failed to fetch lab result statistics: $e');
  }
  
  // Return empty stats when offline
  return {};
});

/// Check if patient has a specific test (offline-first)
final hasTestResultProvider = 
    FutureProvider.family<bool, LabTestQuery>((ref, query) async {
  final results = await ref.watch(labResultsByTestTypeProvider(query).future);
  return results.isNotEmpty;
});

/// Get latest result for a specific test type (offline-first)
final latestTestResultProvider = 
    FutureProvider.family<LabResult?, LabTestQuery>((ref, query) async {
  final results = await ref.watch(labResultsByTestTypeProvider(query).future);
  if (results.isEmpty) return null;
  
  // Sort by date and return the latest
  results.sort((a, b) => b.testDate.compareTo(a.testDate));
  return results.first;
});

// ============================================
// MUTATION PROVIDERS (WITH OFFLINE QUEUE)
// ============================================

/// Create lab result (with offline queue)
final createLabResultProvider = 
    Provider<Future<LabResult> Function(LabResult)>((ref) {
  final repository = ref.watch(labResultRepositoryProvider);
  final connectivity = ref.watch(connectivityServiceProvider);
  
  return (labResult) async {
    try {
      if (connectivity.isOnline) {
        final result = await repository.createLabResult(labResult);
        
        // Update cache
        final cached = HiveService.getCachedLabResults(labResult.maternalProfileId);
        cached.add(result);
        await HiveService.cacheLabResults(labResult.maternalProfileId, cached);
        
        // Invalidate related providers
        ref.invalidate(patientLabResultsProvider(labResult.maternalProfileId));
        ref.invalidate(recentLabResultsProvider);
        ref.invalidate(labResultStatisticsProvider);
        if (labResult.ancVisitId != null) {
          ref.invalidate(visitLabResultsProvider(labResult.ancVisitId!));
        }
        
        return result;
      } else {
        // Queue for sync
        await HiveService.addToSyncQueue(
          operation: 'create',
          table: 'lab_results',
          data: labResult.toJson(),
        );
        
        // Add to local cache with temp ID using copyWith
        final tempResult = labResult.copyWith(
          id: 'offline_${DateTime.now().millisecondsSinceEpoch}',
        );
        
        final cached = HiveService.getCachedLabResults(labResult.maternalProfileId);
        cached.add(tempResult);
        await HiveService.cacheLabResults(labResult.maternalProfileId, cached);
        
        ref.invalidate(patientLabResultsProvider(labResult.maternalProfileId));
        
        print('📴 Lab result queued for sync');
        return tempResult;
      }
    } catch (e) {
      throw Exception('Failed to create lab result: $e');
    }
  };
});

/// Update lab result (with offline queue)
final updateLabResultProvider = 
    Provider<Future<LabResult> Function(LabResult)>((ref) {
  final repository = ref.watch(labResultRepositoryProvider);
  final connectivity = ref.watch(connectivityServiceProvider);
  
  return (labResult) async {
    try {
      if (connectivity.isOnline) {
        final result = await repository.updateLabResult(labResult);
        
        // Invalidate related providers
        ref.invalidate(patientLabResultsProvider(labResult.maternalProfileId));
        ref.invalidate(recentLabResultsProvider);
        ref.invalidate(labResultStatisticsProvider);
        if (labResult.ancVisitId != null) {
          ref.invalidate(visitLabResultsProvider(labResult.ancVisitId!));
        }
        
        return result;
      } else {
        // Queue for sync
        await HiveService.addToSyncQueue(
          operation: 'update',
          table: 'lab_results',
          data: labResult.toJson(),
        );
        
        // Update local cache
        final cached = HiveService.getCachedLabResults(labResult.maternalProfileId);
        final index = cached.indexWhere((r) => r.id == labResult.id);
        if (index >= 0) {
          cached[index] = labResult;
          await HiveService.cacheLabResults(labResult.maternalProfileId, cached);
        }
        
        ref.invalidate(patientLabResultsProvider(labResult.maternalProfileId));
        
        print('📴 Lab result update queued for sync');
        return labResult;
      }
    } catch (e) {
      throw Exception('Failed to update lab result: $e');
    }
  };
});

/// Delete lab result
final deleteLabResultProvider = 
    Provider<Future<void> Function(String, String)>((ref) {
  final repository = ref.watch(labResultRepositoryProvider);
  final connectivity = ref.watch(connectivityServiceProvider);
  
  return (labResultId, patientId) async {
    try {
      if (connectivity.isOnline) {
        await repository.deleteLabResult(labResultId);
      } else {
        // Queue for sync
        await HiveService.addToSyncQueue(
          operation: 'delete',
          table: 'lab_results',
          data: {'id': labResultId},
        );
      }
      
      // Remove from local cache
      final cached = HiveService.getCachedLabResults(patientId);
      cached.removeWhere((r) => r.id == labResultId);
      await HiveService.cacheLabResults(patientId, cached);
      
      // Invalidate all lab result providers
      ref.invalidate(patientLabResultsProvider(patientId));
      ref.invalidate(recentLabResultsProvider);
      ref.invalidate(labResultStatisticsProvider);
    } catch (e) {
      throw Exception('Failed to delete lab result: $e');
    }
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