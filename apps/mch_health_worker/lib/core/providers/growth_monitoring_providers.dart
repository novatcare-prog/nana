import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mch_core/mch_core.dart';
import 'supabase_providers.dart';
import '../services/hive_service.dart';
import '../services/connectivity_service.dart';

/// Repository Provider
final growthRecordRepositoryProvider = Provider<GrowthRecordRepository>((ref) {
  final supabase = ref.watch(supabaseClientProvider);
  return GrowthRecordRepository(supabase);
});

// ============================================
// DATA PROVIDERS (OFFLINE-FIRST)
// ============================================

/// Get all growth records for a child (offline-first)
final childGrowthRecordsProvider = FutureProvider.family<List<GrowthRecord>, String>((ref, childId) async {
  final repository = ref.watch(growthRecordRepositoryProvider);
  final connectivity = ref.watch(connectivityServiceProvider);
  
  try {
    if (connectivity.isOnline) {
      final results = await repository.getRecordsByChildId(childId);
      // Cache for offline use
      await HiveService.cacheChildProfile(childId, {'growth_records': results.map((r) => r.toJson()).toList()});
      return results;
    }
  } catch (e) {
    print('⚠️ Failed to fetch growth records online: $e');
  }
  
  // Fallback to cache
  final cached = HiveService.getCachedChildProfiles(childId);
  if (cached.isNotEmpty) {
    final data = cached.first['growth_records'];
    if (data != null) {
      return (data as List).map((json) => GrowthRecord.fromJson(Map<String, dynamic>.from(json))).toList();
    }
  }
  return [];
});

/// Get latest growth record for a child (offline-first)
final latestGrowthRecordProvider = FutureProvider.family<GrowthRecord?, String>((ref, childId) async {
  final records = await ref.watch(childGrowthRecordsProvider(childId).future);
  if (records.isEmpty) return null;
  records.sort((a, b) => b.measurementDate.compareTo(a.measurementDate));
  return records.first;
});

/// Get single growth record by ID (offline-first)
final growthRecordByIdProvider = FutureProvider.family<GrowthRecord?, String>((ref, recordId) async {
  final repository = ref.watch(growthRecordRepositoryProvider);
  final connectivity = ref.watch(connectivityServiceProvider);
  
  if (connectivity.isOnline) {
    return repository.getRecordById(recordId);
  }
  return null;
});

/// Get children needing growth monitoring follow-up (online only)
final childrenNeedingFollowUpProvider = FutureProvider<List<GrowthRecord>>((ref) async {
  final repository = ref.watch(growthRecordRepositoryProvider);
  final connectivity = ref.watch(connectivityServiceProvider);
  
  if (!connectivity.isOnline) return [];
  return repository.getChildrenNeedingFollowUp();
});

/// Get malnutrition cases (online only - aggregate)
final malnutritionCasesProvider = FutureProvider<List<GrowthRecord>>((ref) async {
  final repository = ref.watch(growthRecordRepositoryProvider);
  final connectivity = ref.watch(connectivityServiceProvider);
  
  if (!connectivity.isOnline) return [];
  return repository.getMalnutritionCases();
});

// ============================================
// MUTATION PROVIDERS (WITH OFFLINE SUPPORT)
// ============================================

/// Create growth record mutation (with offline queue)
final createGrowthRecordProvider = Provider<Future<GrowthRecord> Function(GrowthRecord record)>((ref) {
  final connectivity = ref.watch(connectivityServiceProvider);
  
  return (record) async {
    if (connectivity.isOnline) {
      final repository = ref.read(growthRecordRepositoryProvider);
      final created = await repository.createRecord(record);
      
      // Invalidate related providers
      ref.invalidate(childGrowthRecordsProvider(record.childId));
      ref.invalidate(latestGrowthRecordProvider(record.childId));
      
      return created;
    } else {
      // Offline: add to sync queue
      await HiveService.addToSyncQueue(
        operation: 'insert',
        table: 'growth_records',
        data: record.toJson(),
      );
      
      ref.invalidate(childGrowthRecordsProvider(record.childId));
      ref.invalidate(latestGrowthRecordProvider(record.childId));
      
      return record;
    }
  };
});

/// Update growth record mutation (with offline queue)
final updateGrowthRecordProvider = Provider<Future<GrowthRecord> Function(GrowthRecord record)>((ref) {
  final connectivity = ref.watch(connectivityServiceProvider);
  
  return (record) async {
    if (connectivity.isOnline) {
      final repository = ref.read(growthRecordRepositoryProvider);
      final updated = await repository.updateRecord(record);
      
      // Invalidate related providers
      ref.invalidate(childGrowthRecordsProvider(record.childId));
      ref.invalidate(latestGrowthRecordProvider(record.childId));
      if (record.id != null) {
        ref.invalidate(growthRecordByIdProvider(record.id!));
      }
      
      return updated;
    } else {
      await HiveService.addToSyncQueue(
        operation: 'update',
        table: 'growth_records',
        data: record.toJson(),
      );
      
      ref.invalidate(childGrowthRecordsProvider(record.childId));
      ref.invalidate(latestGrowthRecordProvider(record.childId));
      
      return record;
    }
  };
});

/// Delete growth record mutation (with offline queue)
final deleteGrowthRecordProvider = Provider<Future<void> Function(String recordId, String childId)>((ref) {
  final connectivity = ref.watch(connectivityServiceProvider);
  
  return (recordId, childId) async {
    if (connectivity.isOnline) {
      final repository = ref.read(growthRecordRepositoryProvider);
      await repository.deleteRecord(recordId);
    } else {
      await HiveService.addToSyncQueue(
        operation: 'delete',
        table: 'growth_records',
        data: {'id': recordId},
      );
    }
    
    // Invalidate related providers
    ref.invalidate(childGrowthRecordsProvider(childId));
    ref.invalidate(latestGrowthRecordProvider(childId));
    ref.invalidate(growthRecordByIdProvider(recordId));
  };
});