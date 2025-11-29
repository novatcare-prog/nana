import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mch_core/mch_core.dart';
import 'supabase_providers.dart';

// ============================================================================
// VITAMIN A PROVIDERS
// ============================================================================

// Repository Provider
final vitaminARepositoryProvider = Provider<VitaminARepository>((ref) {
  final supabase = ref.watch(supabaseClientProvider);
  return VitaminARepository(supabase);
});

// Get all Vitamin A records for a child
final vitaminARecordsByChildProvider = FutureProvider.family<List<VitaminARecord>, String>((ref, childId) async {
  final repository = ref.watch(vitaminARepositoryProvider);
  return repository.getVitaminAByChildId(childId);
});

// Get single Vitamin A record by ID
final vitaminARecordByIdProvider = FutureProvider.family<VitaminARecord?, String>((ref, recordId) async {
  final repository = ref.watch(vitaminARepositoryProvider);
  return repository.getVitaminAById(recordId);
});

// Get upcoming due doses
final upcomingVitaminADosesProvider = FutureProvider.family<List<VitaminARecord>, String>((ref, childId) async {
  final repository = ref.watch(vitaminARepositoryProvider);
  return repository.getUpcomingDueDoses(childId);
});

// Get total doses count
final vitaminATotalDosesProvider = FutureProvider.family<int, String>((ref, childId) async {
  final repository = ref.watch(vitaminARepositoryProvider);
  return repository.getTotalDosesCount(childId);
});

// Get last dose
final vitaminALastDoseProvider = FutureProvider.family<VitaminARecord?, String>((ref, childId) async {
  final repository = ref.watch(vitaminARepositoryProvider);
  return repository.getLastDose(childId);
});

// Create Vitamin A record
final createVitaminAProvider = Provider<Future<VitaminARecord> Function(VitaminARecord)>((ref) {
  return (record) async {
    final repository = ref.read(vitaminARepositoryProvider);
    final result = await repository.createVitaminA(record);
    
    // Invalidate related providers
    ref.invalidate(vitaminARecordsByChildProvider(record.childId));
    ref.invalidate(vitaminATotalDosesProvider(record.childId));
    ref.invalidate(vitaminALastDoseProvider(record.childId));
    ref.invalidate(upcomingVitaminADosesProvider(record.childId));
    
    return result;
  };
});

// Update Vitamin A record
final updateVitaminAProvider = Provider<Future<VitaminARecord> Function(VitaminARecord)>((ref) {
  return (record) async {
    final repository = ref.read(vitaminARepositoryProvider);
    final result = await repository.updateVitaminA(record);
    
    // Invalidate related providers
    ref.invalidate(vitaminARecordsByChildProvider(record.childId));
    ref.invalidate(vitaminARecordByIdProvider(record.id!));
    ref.invalidate(vitaminATotalDosesProvider(record.childId));
    ref.invalidate(vitaminALastDoseProvider(record.childId));
    ref.invalidate(upcomingVitaminADosesProvider(record.childId));
    
    return result;
  };
});

// Delete Vitamin A record
final deleteVitaminAProvider = Provider<Future<void> Function(String, String)>((ref) {
  return (recordId, childId) async {
    final repository = ref.read(vitaminARepositoryProvider);
    await repository.deleteVitaminA(recordId);
    
    // Invalidate related providers
    ref.invalidate(vitaminARecordsByChildProvider(childId));
    ref.invalidate(vitaminARecordByIdProvider(recordId));
    ref.invalidate(vitaminATotalDosesProvider(childId));
    ref.invalidate(vitaminALastDoseProvider(childId));
    ref.invalidate(upcomingVitaminADosesProvider(childId));
  };
});

// ============================================================================
// DEWORMING PROVIDERS
// ============================================================================

// Repository Provider
final dewormingRepositoryProvider = Provider<DewormingRepository>((ref) {
  final supabase = ref.watch(supabaseClientProvider);
  return DewormingRepository(supabase);
});

// Get all deworming records for a child
final dewormingRecordsByChildProvider = FutureProvider.family<List<DewormingRecord>, String>((ref, childId) async {
  final repository = ref.watch(dewormingRepositoryProvider);
  return repository.getDewormingByChildId(childId);
});

// Get single deworming record by ID
final dewormingRecordByIdProvider = FutureProvider.family<DewormingRecord?, String>((ref, recordId) async {
  final repository = ref.watch(dewormingRepositoryProvider);
  return repository.getDewormingById(recordId);
});

// Get upcoming due doses
final upcomingDewormingDosesProvider = FutureProvider.family<List<DewormingRecord>, String>((ref, childId) async {
  final repository = ref.watch(dewormingRepositoryProvider);
  return repository.getUpcomingDueDoses(childId);
});

// Get records with side effects
final dewormingWithSideEffectsProvider = FutureProvider.family<List<DewormingRecord>, String>((ref, childId) async {
  final repository = ref.watch(dewormingRepositoryProvider);
  return repository.getRecordsWithSideEffects(childId);
});

// Get total doses count
final dewormingTotalDosesProvider = FutureProvider.family<int, String>((ref, childId) async {
  final repository = ref.watch(dewormingRepositoryProvider);
  return repository.getTotalDosesCount(childId);
});

// Get last dose
final dewormingLastDoseProvider = FutureProvider.family<DewormingRecord?, String>((ref, childId) async {
  final repository = ref.watch(dewormingRepositoryProvider);
  return repository.getLastDose(childId);
});

// Create deworming record
final createDewormingProvider = Provider<Future<DewormingRecord> Function(DewormingRecord)>((ref) {
  return (record) async {
    final repository = ref.read(dewormingRepositoryProvider);
    final result = await repository.createDeworming(record);
    
    // Invalidate related providers
    ref.invalidate(dewormingRecordsByChildProvider(record.childId));
    ref.invalidate(dewormingTotalDosesProvider(record.childId));
    ref.invalidate(dewormingLastDoseProvider(record.childId));
    ref.invalidate(upcomingDewormingDosesProvider(record.childId));
    
    return result;
  };
});

// Update deworming record
final updateDewormingProvider = Provider<Future<DewormingRecord> Function(DewormingRecord)>((ref) {
  return (record) async {
    final repository = ref.read(dewormingRepositoryProvider);
    final result = await repository.updateDeworming(record);
    
    // Invalidate related providers
    ref.invalidate(dewormingRecordsByChildProvider(record.childId));
    ref.invalidate(dewormingRecordByIdProvider(record.id!));
    ref.invalidate(dewormingTotalDosesProvider(record.childId));
    ref.invalidate(dewormingLastDoseProvider(record.childId));
    ref.invalidate(upcomingDewormingDosesProvider(record.childId));
    
    return result;
  };
});

// Delete deworming record
final deleteDewormingProvider = Provider<Future<void> Function(String, String)>((ref) {
  return (recordId, childId) async {
    final repository = ref.read(dewormingRepositoryProvider);
    await repository.deleteDeworming(recordId);
    
    // Invalidate related providers
    ref.invalidate(dewormingRecordsByChildProvider(childId));
    ref.invalidate(dewormingRecordByIdProvider(recordId));
    ref.invalidate(dewormingTotalDosesProvider(childId));
    ref.invalidate(dewormingLastDoseProvider(childId));
    ref.invalidate(upcomingDewormingDosesProvider(childId));
  };
});