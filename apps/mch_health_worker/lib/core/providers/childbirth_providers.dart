import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:mch_core/mch_core.dart';

// Import repositories
import '../services/hive_service.dart';
import '../services/connectivity_service.dart';

// ============================================
// REPOSITORY PROVIDERS
// ============================================

final childbirthRecordRepositoryProvider =
    Provider<ChildbirthRecordRepository>((ref) {
  return ChildbirthRecordRepository(Supabase.instance.client);
});

final childProfileRepositoryProvider = Provider<ChildProfileRepository>((ref) {
  return ChildProfileRepository(Supabase.instance.client);
});

// ============================================
// DATA PROVIDERS (OFFLINE-FIRST)
// ============================================

/// Get childbirth records for a patient (offline-first)
final patientChildbirthRecordsProvider =
    FutureProvider.family<List<ChildbirthRecord>, String>(
        (ref, patientId) async {
  final repository = ref.watch(childbirthRecordRepositoryProvider);
  final connectivity = ref.watch(connectivityServiceProvider);

  try {
    if (connectivity.isOnline) {
      final results = await repository.getRecordsByPatientId(patientId);
      return results;
    }
  } catch (e) {
    print('⚠️ Failed to fetch childbirth records online: $e');
  }

  return [];
});

/// Get children for a mother (offline-first)
final motherChildrenProvider =
    FutureProvider.family<List<ChildProfile>, String>(
        (ref, maternalProfileId) async {
  final repository = ref.watch(childProfileRepositoryProvider);
  final connectivity = ref.watch(connectivityServiceProvider);

  try {
    if (connectivity.isOnline) {
      final results = await repository.getChildrenByMotherId(maternalProfileId);
      // Cache child profiles
      for (final child in results) {
        await HiveService.cacheChildProfile(child.id, child.toJson());
      }
      return results;
    }
  } catch (e) {
    print('⚠️ Failed to fetch children online: $e');
  }

  // Fallback to cache
  final cached = HiveService.getCachedChildProfiles(maternalProfileId);
  return cached.map((json) => ChildProfile.fromJson(json)).toList();
});

/// Get single child profile (offline-first)
final childProfileByIdProvider =
    FutureProvider.family<ChildProfile?, String>((ref, childId) async {
  final repository = ref.watch(childProfileRepositoryProvider);
  final connectivity = ref.watch(connectivityServiceProvider);

  try {
    if (connectivity.isOnline) {
      final result = await repository.getChildById(childId);
      if (result != null) {
        await HiveService.cacheChildProfile(childId, result.toJson());
      }
      return result;
    }
  } catch (e) {
    print('⚠️ Failed to fetch child profile online: $e');
  }

  // Fallback to cache
  final cached = HiveService.getCachedChildProfiles(childId);
  if (cached.isNotEmpty) {
    return ChildProfile.fromJson(cached.first);
  }
  return null;
});

/// Get all active children (online only - aggregate)
final allActiveChildrenProvider =
    FutureProvider<List<ChildProfile>>((ref) async {
  final repository = ref.watch(childProfileRepositoryProvider);
  final connectivity = ref.watch(connectivityServiceProvider);

  if (!connectivity.isOnline) return [];
  return repository.getAllActiveChildren();
});

// ============================================
// MUTATION PROVIDERS (WITH OFFLINE SUPPORT)
// ============================================

/// Create delivery record (with offline queue)
final createDeliveryRecordProvider = Provider<
    Future<Map<String, dynamic>> Function({
      required ChildbirthRecord childbirthRecord,
      required ChildProfile childProfile,
    })>((ref) {
  final connectivity = ref.watch(connectivityServiceProvider);

  return ({
    required ChildbirthRecord childbirthRecord,
    required ChildProfile childProfile,
  }) async {
    if (connectivity.isOnline) {
      final repository = ref.read(childbirthRecordRepositoryProvider);
      final result = await repository.createDeliveryRecord(
        childbirthRecord: childbirthRecord,
        childProfile: childProfile,
      );

      // Cache the new child profile
      if (result['child_profile'] != null) {
        final child = result['child_profile'] as ChildProfile;
        await HiveService.cacheChildProfile(child.id, child.toJson());
      }

      // Invalidate related providers
      ref.invalidate(
          patientChildbirthRecordsProvider(childbirthRecord.maternalProfileId));
      ref.invalidate(
          motherChildrenProvider(childbirthRecord.maternalProfileId));
      ref.invalidate(allActiveChildrenProvider);

      return result;
    } else {
      // Offline: add both to sync queue
      await HiveService.addToSyncQueue(
        operation: 'insert',
        table: 'childbirth_records',
        data: childbirthRecord.toJson(),
      );

      await HiveService.addToSyncQueue(
        operation: 'insert',
        table: 'child_profiles',
        data: childProfile.toJson(),
      );

      // Cache child profile locally
      await HiveService.cacheChildProfile(
          childProfile.id ?? 'temp_${DateTime.now().millisecondsSinceEpoch}',
          childProfile.toJson());

      ref.invalidate(
          patientChildbirthRecordsProvider(childbirthRecord.maternalProfileId));
      ref.invalidate(
          motherChildrenProvider(childbirthRecord.maternalProfileId));

      return {
        'childbirth_record': childbirthRecord,
        'child_profile': childProfile,
      };
    }
  };
});

/// Update child profile (with offline queue)
final updateChildProfileProvider =
    Provider<Future<ChildProfile> Function(ChildProfile)>((ref) {
  final connectivity = ref.watch(connectivityServiceProvider);

  return (child) async {
    if (connectivity.isOnline) {
      final repository = ref.read(childProfileRepositoryProvider);
      final result = await repository.updateChild(child);

      // Update cache
      await HiveService.cacheChildProfile(child.id, result.toJson());

      // Invalidate related providers
      ref.invalidate(childProfileByIdProvider(child.id));
      ref.invalidate(motherChildrenProvider(child.maternalProfileId));
      ref.invalidate(allActiveChildrenProvider);

      return result;
    } else {
      await HiveService.addToSyncQueue(
        operation: 'update',
        table: 'child_profiles',
        data: child.toJson(),
      );

      // Update cache
      await HiveService.cacheChildProfile(child.id, child.toJson());

      ref.invalidate(childProfileByIdProvider(child.id));
      ref.invalidate(motherChildrenProvider(child.maternalProfileId));

      return child;
    }
  };
});
