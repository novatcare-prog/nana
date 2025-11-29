import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mch_core/mch_core.dart';
import 'supabase_providers.dart';

/// Repository Provider
final growthRecordRepositoryProvider = Provider<GrowthRecordRepository>((ref) {
  final supabase = ref.watch(supabaseClientProvider);
  return GrowthRecordRepository(supabase);
});

/// Get all growth records for a child
final childGrowthRecordsProvider = FutureProvider.family<List<GrowthRecord>, String>((ref, childId) async {
  final repository = ref.watch(growthRecordRepositoryProvider);
  return repository.getRecordsByChildId(childId);
});

/// Get latest growth record for a child
final latestGrowthRecordProvider = FutureProvider.family<GrowthRecord?, String>((ref, childId) async {
  final repository = ref.watch(growthRecordRepositoryProvider);
  return repository.getLatestRecord(childId);
});

/// Get single growth record by ID
final growthRecordByIdProvider = FutureProvider.family<GrowthRecord?, String>((ref, recordId) async {
  final repository = ref.watch(growthRecordRepositoryProvider);
  return repository.getRecordById(recordId);
});

/// Get children needing growth monitoring follow-up
final childrenNeedingFollowUpProvider = FutureProvider<List<GrowthRecord>>((ref) async {
  final repository = ref.watch(growthRecordRepositoryProvider);
  return repository.getChildrenNeedingFollowUp();
});

/// Get malnutrition cases (for alerts)
final malnutritionCasesProvider = FutureProvider<List<GrowthRecord>>((ref) async {
  final repository = ref.watch(growthRecordRepositoryProvider);
  return repository.getMalnutritionCases();
});

/// Create growth record mutation
final createGrowthRecordProvider = Provider<Future<GrowthRecord> Function(GrowthRecord record)>((ref) {
  return (record) async {
    final repository = ref.read(growthRecordRepositoryProvider);
    final created = await repository.createRecord(record);
    
    // Invalidate related providers
    ref.invalidate(childGrowthRecordsProvider(record.childId));
    ref.invalidate(latestGrowthRecordProvider(record.childId));
    
    return created;
  };
});

/// Update growth record mutation
final updateGrowthRecordProvider = Provider<Future<GrowthRecord> Function(GrowthRecord record)>((ref) {
  return (record) async {
    final repository = ref.read(growthRecordRepositoryProvider);
    final updated = await repository.updateRecord(record);
    
    // Invalidate related providers
    ref.invalidate(childGrowthRecordsProvider(record.childId));
    ref.invalidate(latestGrowthRecordProvider(record.childId));
    if (record.id != null) {
      ref.invalidate(growthRecordByIdProvider(record.id!));
    }
    
    return updated;
  };
});

/// Delete growth record mutation
final deleteGrowthRecordProvider = Provider<Future<void> Function(String recordId, String childId)>((ref) {
  return (recordId, childId) async {
    final repository = ref.read(growthRecordRepositoryProvider);
    await repository.deleteRecord(recordId);
    
    // Invalidate related providers
    ref.invalidate(childGrowthRecordsProvider(childId));
    ref.invalidate(latestGrowthRecordProvider(childId));
    ref.invalidate(growthRecordByIdProvider(recordId));
  };
});