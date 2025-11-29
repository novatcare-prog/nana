import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:mch_core/mch_core.dart';

// Import repositories
import 'package:mch_core/src/data/repositories/childbirth_repositories.dart';

// ============================================
// REPOSITORY PROVIDERS
// ============================================

final childbirthRecordRepositoryProvider = Provider<ChildbirthRecordRepository>((ref) {
  return ChildbirthRecordRepository(Supabase.instance.client);
});

final childProfileRepositoryProvider = Provider<ChildProfileRepository>((ref) {
  return ChildProfileRepository(Supabase.instance.client);
});

// ============================================
// DATA PROVIDERS
// ============================================

/// Get childbirth records for a patient
final patientChildbirthRecordsProvider = FutureProvider.family<List<ChildbirthRecord>, String>((ref, patientId) async {
  final repository = ref.watch(childbirthRecordRepositoryProvider);
  return repository.getRecordsByPatientId(patientId);
});

/// Get children for a mother
final motherChildrenProvider = FutureProvider.family<List<ChildProfile>, String>((ref, maternalProfileId) async {
  final repository = ref.watch(childProfileRepositoryProvider);
  return repository.getChildrenByMotherId(maternalProfileId);
});

/// Get single child profile
final childProfileByIdProvider = FutureProvider.family<ChildProfile?, String>((ref, childId) async {
  final repository = ref.watch(childProfileRepositoryProvider);
  return repository.getChildById(childId);
});

/// Get all active children (for statistics)
final allActiveChildrenProvider = FutureProvider<List<ChildProfile>>((ref) async {
  final repository = ref.watch(childProfileRepositoryProvider);
  return repository.getAllActiveChildren();
});

// ============================================
// MUTATION PROVIDERS
// ============================================

/// Create delivery record (creates both childbirth record and child profile)
final createDeliveryRecordProvider = Provider<Future<Map<String, dynamic>> Function({
  required ChildbirthRecord childbirthRecord,
  required ChildProfile childProfile,
})>((ref) {
  final repository = ref.watch(childbirthRecordRepositoryProvider);
  
  return ({
    required ChildbirthRecord childbirthRecord,
    required ChildProfile childProfile,
  }) async {
    final result = await repository.createDeliveryRecord(
      childbirthRecord: childbirthRecord,
      childProfile: childProfile,
    );
    
    // Invalidate related providers
    ref.invalidate(patientChildbirthRecordsProvider(childbirthRecord.maternalProfileId));
    ref.invalidate(motherChildrenProvider(childbirthRecord.maternalProfileId));
    ref.invalidate(allActiveChildrenProvider);
    
    return result;
  };
});

/// Update child profile
final updateChildProfileProvider = Provider<Future<ChildProfile> Function(ChildProfile)>((ref) {
  final repository = ref.watch(childProfileRepositoryProvider);
  
  return (child) async {
    final result = await repository.updateChild(child);
    
    // Invalidate related providers
    ref.invalidate(childProfileByIdProvider(child.id!));
    ref.invalidate(motherChildrenProvider(child.maternalProfileId));
    ref.invalidate(allActiveChildrenProvider);
    
    return result;
  };
});