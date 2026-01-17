import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mch_core/mch_core.dart';
import 'supabase_providers.dart';
import '../services/hive_service.dart';
import '../services/connectivity_service.dart';

// ============================================================================
// VITAMIN A PROVIDERS (OFFLINE-FIRST)
// ============================================================================

// Repository Provider
final vitaminARepositoryProvider = Provider<VitaminARepository>((ref) {
  final supabase = ref.watch(supabaseClientProvider);
  return VitaminARepository(supabase);
});

/// Get all Vitamin A records for a child (offline-first)
final vitaminARecordsByChildProvider = FutureProvider.family<List<VitaminARecord>, String>((ref, childId) async {
  final repository = ref.watch(vitaminARepositoryProvider);
  final connectivity = ref.watch(connectivityServiceProvider);
  
  try {
    if (connectivity.isOnline) {
      final results = await repository.getVitaminAByChildId(childId);
      return results;
    }
  } catch (e) {
    print('⚠️ Failed to fetch Vitamin A records online: $e');
  }
  
  return [];
});

/// Get single Vitamin A record by ID
final vitaminARecordByIdProvider = FutureProvider.family<VitaminARecord?, String>((ref, recordId) async {
  final repository = ref.watch(vitaminARepositoryProvider);
  final connectivity = ref.watch(connectivityServiceProvider);
  
  if (connectivity.isOnline) {
    return repository.getVitaminAById(recordId);
  }
  return null;
});

/// Get upcoming due doses (online only)
final upcomingVitaminADosesProvider = FutureProvider.family<List<VitaminARecord>, String>((ref, childId) async {
  final repository = ref.watch(vitaminARepositoryProvider);
  final connectivity = ref.watch(connectivityServiceProvider);
  
  if (!connectivity.isOnline) return [];
  return repository.getUpcomingDueDoses(childId);
});

/// Get total doses count (offline-first)
final vitaminATotalDosesProvider = FutureProvider.family<int, String>((ref, childId) async {
  final records = await ref.watch(vitaminARecordsByChildProvider(childId).future);
  return records.length;
});

/// Get last dose (offline-first)
final vitaminALastDoseProvider = FutureProvider.family<VitaminARecord?, String>((ref, childId) async {
  final records = await ref.watch(vitaminARecordsByChildProvider(childId).future);
  if (records.isEmpty) return null;
  records.sort((a, b) => b.dateGiven.compareTo(a.dateGiven));
  return records.first;
});

/// Create Vitamin A record (with offline queue)
final createVitaminAProvider = Provider<Future<VitaminARecord> Function(VitaminARecord)>((ref) {
  final connectivity = ref.watch(connectivityServiceProvider);
  
  return (record) async {
    if (connectivity.isOnline) {
      final repository = ref.read(vitaminARepositoryProvider);
      final result = await repository.createVitaminA(record);
      
      // Invalidate related providers
      ref.invalidate(vitaminARecordsByChildProvider(record.childId));
      ref.invalidate(vitaminATotalDosesProvider(record.childId));
      ref.invalidate(vitaminALastDoseProvider(record.childId));
      ref.invalidate(upcomingVitaminADosesProvider(record.childId));
      
      return result;
    } else {
      // Offline: add to sync queue
      await HiveService.addToSyncQueue(
        operation: 'insert',
        table: 'vitamin_a_records',
        data: record.toJson(),
      );
      
      ref.invalidate(vitaminARecordsByChildProvider(record.childId));
      ref.invalidate(vitaminATotalDosesProvider(record.childId));
      ref.invalidate(vitaminALastDoseProvider(record.childId));
      
      return record;
    }
  };
});

/// Update Vitamin A record (with offline queue)
final updateVitaminAProvider = Provider<Future<VitaminARecord> Function(VitaminARecord)>((ref) {
  final connectivity = ref.watch(connectivityServiceProvider);
  
  return (record) async {
    if (connectivity.isOnline) {
      final repository = ref.read(vitaminARepositoryProvider);
      final result = await repository.updateVitaminA(record);
      
      // Invalidate related providers
      ref.invalidate(vitaminARecordsByChildProvider(record.childId));
      ref.invalidate(vitaminARecordByIdProvider(record.id!));
      ref.invalidate(vitaminATotalDosesProvider(record.childId));
      ref.invalidate(vitaminALastDoseProvider(record.childId));
      ref.invalidate(upcomingVitaminADosesProvider(record.childId));
      
      return result;
    } else {
      await HiveService.addToSyncQueue(
        operation: 'update',
        table: 'vitamin_a_records',
        data: record.toJson(),
      );
      
      ref.invalidate(vitaminARecordsByChildProvider(record.childId));
      ref.invalidate(vitaminATotalDosesProvider(record.childId));
      ref.invalidate(vitaminALastDoseProvider(record.childId));
      
      return record;
    }
  };
});

/// Delete Vitamin A record (with offline queue)
final deleteVitaminAProvider = Provider<Future<void> Function(String, String)>((ref) {
  final connectivity = ref.watch(connectivityServiceProvider);
  
  return (recordId, childId) async {
    if (connectivity.isOnline) {
      final repository = ref.read(vitaminARepositoryProvider);
      await repository.deleteVitaminA(recordId);
    } else {
      await HiveService.addToSyncQueue(
        operation: 'delete',
        table: 'vitamin_a_records',
        data: {'id': recordId},
      );
    }
    
    // Invalidate related providers
    ref.invalidate(vitaminARecordsByChildProvider(childId));
    ref.invalidate(vitaminARecordByIdProvider(recordId));
    ref.invalidate(vitaminATotalDosesProvider(childId));
    ref.invalidate(vitaminALastDoseProvider(childId));
    ref.invalidate(upcomingVitaminADosesProvider(childId));
  };
});

// ============================================================================
// DEWORMING PROVIDERS (OFFLINE-FIRST)
// ============================================================================

// Repository Provider
final dewormingRepositoryProvider = Provider<DewormingRepository>((ref) {
  final supabase = ref.watch(supabaseClientProvider);
  return DewormingRepository(supabase);
});

/// Get all deworming records for a child (offline-first)
final dewormingRecordsByChildProvider = FutureProvider.family<List<DewormingRecord>, String>((ref, childId) async {
  final repository = ref.watch(dewormingRepositoryProvider);
  final connectivity = ref.watch(connectivityServiceProvider);
  
  try {
    if (connectivity.isOnline) {
      final results = await repository.getDewormingByChildId(childId);
      return results;
    }
  } catch (e) {
    print('⚠️ Failed to fetch deworming records online: $e');
  }
  
  return [];
});

/// Get single deworming record by ID
final dewormingRecordByIdProvider = FutureProvider.family<DewormingRecord?, String>((ref, recordId) async {
  final repository = ref.watch(dewormingRepositoryProvider);
  final connectivity = ref.watch(connectivityServiceProvider);
  
  if (connectivity.isOnline) {
    return repository.getDewormingById(recordId);
  }
  return null;
});

/// Get upcoming due doses (online only)
final upcomingDewormingDosesProvider = FutureProvider.family<List<DewormingRecord>, String>((ref, childId) async {
  final repository = ref.watch(dewormingRepositoryProvider);
  final connectivity = ref.watch(connectivityServiceProvider);
  
  if (!connectivity.isOnline) return [];
  return repository.getUpcomingDueDoses(childId);
});

/// Get records with side effects (offline-first)
final dewormingWithSideEffectsProvider = FutureProvider.family<List<DewormingRecord>, String>((ref, childId) async {
  final records = await ref.watch(dewormingRecordsByChildProvider(childId).future);
  return records.where((r) => r.sideEffectsReported == true).toList();
});

/// Get total doses count (offline-first)
final dewormingTotalDosesProvider = FutureProvider.family<int, String>((ref, childId) async {
  final records = await ref.watch(dewormingRecordsByChildProvider(childId).future);
  return records.length;
});

/// Get last dose (offline-first)
final dewormingLastDoseProvider = FutureProvider.family<DewormingRecord?, String>((ref, childId) async {
  final records = await ref.watch(dewormingRecordsByChildProvider(childId).future);
  if (records.isEmpty) return null;
  records.sort((a, b) => b.dateGiven.compareTo(a.dateGiven));
  return records.first;
});

/// Create deworming record (with offline queue)
final createDewormingProvider = Provider<Future<DewormingRecord> Function(DewormingRecord)>((ref) {
  final connectivity = ref.watch(connectivityServiceProvider);
  
  return (record) async {
    if (connectivity.isOnline) {
      final repository = ref.read(dewormingRepositoryProvider);
      final result = await repository.createDeworming(record);
      
      // Invalidate related providers
      ref.invalidate(dewormingRecordsByChildProvider(record.childId));
      ref.invalidate(dewormingTotalDosesProvider(record.childId));
      ref.invalidate(dewormingLastDoseProvider(record.childId));
      ref.invalidate(upcomingDewormingDosesProvider(record.childId));
      
      return result;
    } else {
      // Offline: add to sync queue
      await HiveService.addToSyncQueue(
        operation: 'insert',
        table: 'deworming_records',
        data: record.toJson(),
      );
      
      ref.invalidate(dewormingRecordsByChildProvider(record.childId));
      ref.invalidate(dewormingTotalDosesProvider(record.childId));
      ref.invalidate(dewormingLastDoseProvider(record.childId));
      
      return record;
    }
  };
});

/// Update deworming record (with offline queue)
final updateDewormingProvider = Provider<Future<DewormingRecord> Function(DewormingRecord)>((ref) {
  final connectivity = ref.watch(connectivityServiceProvider);
  
  return (record) async {
    if (connectivity.isOnline) {
      final repository = ref.read(dewormingRepositoryProvider);
      final result = await repository.updateDeworming(record);
      
      // Invalidate related providers
      ref.invalidate(dewormingRecordsByChildProvider(record.childId));
      ref.invalidate(dewormingRecordByIdProvider(record.id!));
      ref.invalidate(dewormingTotalDosesProvider(record.childId));
      ref.invalidate(dewormingLastDoseProvider(record.childId));
      ref.invalidate(upcomingDewormingDosesProvider(record.childId));
      
      return result;
    } else {
      await HiveService.addToSyncQueue(
        operation: 'update',
        table: 'deworming_records',
        data: record.toJson(),
      );
      
      ref.invalidate(dewormingRecordsByChildProvider(record.childId));
      ref.invalidate(dewormingTotalDosesProvider(record.childId));
      ref.invalidate(dewormingLastDoseProvider(record.childId));
      
      return record;
    }
  };
});

/// Delete deworming record (with offline queue)
final deleteDewormingProvider = Provider<Future<void> Function(String, String)>((ref) {
  final connectivity = ref.watch(connectivityServiceProvider);
  
  return (recordId, childId) async {
    if (connectivity.isOnline) {
      final repository = ref.read(dewormingRepositoryProvider);
      await repository.deleteDeworming(recordId);
    } else {
      await HiveService.addToSyncQueue(
        operation: 'delete',
        table: 'deworming_records',
        data: {'id': recordId},
      );
    }
    
    // Invalidate related providers
    ref.invalidate(dewormingRecordsByChildProvider(childId));
    ref.invalidate(dewormingRecordByIdProvider(recordId));
    ref.invalidate(dewormingTotalDosesProvider(childId));
    ref.invalidate(dewormingLastDoseProvider(childId));
    ref.invalidate(upcomingDewormingDosesProvider(childId));
  };
});