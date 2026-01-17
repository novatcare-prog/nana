import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mch_core/mch_core.dart';
import 'supabase_providers.dart';
import '../services/hive_service.dart';
import '../services/connectivity_service.dart';

// Repository Provider
final immunizationRepositoryProvider = Provider<ImmunizationRepository>((ref) {
  final supabase = ref.watch(supabaseClientProvider);
  return ImmunizationRepository(supabase);
});

// ============================================
// DATA PROVIDERS (OFFLINE-FIRST)
// ============================================

/// Get all immunizations for a child (offline-first)
final childImmunizationsProvider = FutureProvider.family<List<ImmunizationRecord>, String>((ref, childId) async {
  final repository = ref.watch(immunizationRepositoryProvider);
  final connectivity = ref.watch(connectivityServiceProvider);
  
  try {
    if (connectivity.isOnline) {
      final results = await repository.getImmunizationsByChildId(childId);
      // Cache for offline use
      await HiveService.cacheChildProfile(childId, {'immunizations': results.map((r) => r.toJson()).toList()});
      return results;
    }
  } catch (e) {
    print('⚠️ Failed to fetch child immunizations online: $e');
  }
  
  // Fallback to cache
  final cached = HiveService.getCachedChildProfiles(childId);
  if (cached.isNotEmpty) {
    final data = cached.first['immunizations'];
    if (data != null) {
      return (data as List).map((json) => ImmunizationRecord.fromJson(Map<String, dynamic>.from(json))).toList();
    }
  }
  return [];
});

/// Get immunization by ID
final immunizationByIdProvider = FutureProvider.family<ImmunizationRecord?, String>((ref, immunizationId) async {
  final repository = ref.watch(immunizationRepositoryProvider);
  final connectivity = ref.watch(connectivityServiceProvider);
  
  if (connectivity.isOnline) {
    return repository.getImmunizationById(immunizationId);
  }
  return null;
});

/// Get immunizations by vaccine type (offline-first)
final immunizationsByVaccineTypeProvider = FutureProvider.family<List<ImmunizationRecord>, ({String childId, ImmunizationType vaccineType})>((ref, params) async {
  final allImmunizations = await ref.watch(childImmunizationsProvider(params.childId).future);
  return allImmunizations.where((i) => i.vaccineType == params.vaccineType).toList();
});

/// Get upcoming due vaccines (offline-first)
final upcomingDueVaccinesProvider = FutureProvider.family<List<ImmunizationRecord>, String>((ref, childId) async {
  final repository = ref.watch(immunizationRepositoryProvider);
  final connectivity = ref.watch(connectivityServiceProvider);
  
  if (connectivity.isOnline) {
    return repository.getUpcomingDueVaccines(childId);
  }
  return [];
});

/// Get immunizations with adverse reactions (offline-first)
final immunizationsWithReactionsProvider = FutureProvider.family<List<ImmunizationRecord>, String>((ref, childId) async {
  final allImmunizations = await ref.watch(childImmunizationsProvider(childId).future);
  return allImmunizations.where((i) => i.adverseEventReported == true).toList();
});

/// Get immunization coverage (offline-first)
final immunizationCoverageProvider = FutureProvider.family<Map<ImmunizationType, int>, String>((ref, childId) async {
  final allImmunizations = await ref.watch(childImmunizationsProvider(childId).future);
  final coverage = <ImmunizationType, int>{};
  for (final imm in allImmunizations) {
    coverage[imm.vaccineType] = (coverage[imm.vaccineType] ?? 0) + 1;
  }
  return coverage;
});

// ============================================
// MUTATION PROVIDERS (WITH OFFLINE SUPPORT)
// ============================================

/// Create immunization mutation (with offline queue)
final createImmunizationProvider = Provider<Future<ImmunizationRecord> Function(ImmunizationRecord)>((ref) {
  final connectivity = ref.watch(connectivityServiceProvider);
  
  return (immunization) async {
    if (connectivity.isOnline) {
      final repository = ref.read(immunizationRepositoryProvider);
      final result = await repository.createImmunization(immunization);
      
      // Invalidate related providers
      ref.invalidate(childImmunizationsProvider(immunization.childId));
      ref.invalidate(immunizationCoverageProvider(immunization.childId));
      ref.invalidate(upcomingDueVaccinesProvider(immunization.childId));
      
      return result;
    } else {
      // Offline: add to sync queue
      await HiveService.addToSyncQueue(
        operation: 'insert',
        table: 'immunization_records',
        data: immunization.toJson(),
      );
      
      ref.invalidate(childImmunizationsProvider(immunization.childId));
      ref.invalidate(immunizationCoverageProvider(immunization.childId));
      ref.invalidate(upcomingDueVaccinesProvider(immunization.childId));
      
      return immunization;
    }
  };
});

/// Update immunization mutation (with offline queue)
final updateImmunizationProvider = Provider<Future<ImmunizationRecord> Function(ImmunizationRecord)>((ref) {
  final connectivity = ref.watch(connectivityServiceProvider);
  
  return (immunization) async {
    if (connectivity.isOnline) {
      final repository = ref.read(immunizationRepositoryProvider);
      final result = await repository.updateImmunization(immunization);
      
      // Invalidate related providers
      ref.invalidate(childImmunizationsProvider(immunization.childId));
      ref.invalidate(immunizationCoverageProvider(immunization.childId));
      ref.invalidate(upcomingDueVaccinesProvider(immunization.childId));
      if (immunization.id != null) {
        ref.invalidate(immunizationByIdProvider(immunization.id!));
      }
      
      return result;
    } else {
      await HiveService.addToSyncQueue(
        operation: 'update',
        table: 'immunization_records',
        data: immunization.toJson(),
      );
      
      ref.invalidate(childImmunizationsProvider(immunization.childId));
      ref.invalidate(immunizationCoverageProvider(immunization.childId));
      
      return immunization;
    }
  };
});

/// Delete immunization mutation (with offline queue)
final deleteImmunizationProvider = Provider<Future<void> Function(String, String)>((ref) {
  final connectivity = ref.watch(connectivityServiceProvider);
  
  return (immunizationId, childId) async {
    if (connectivity.isOnline) {
      final repository = ref.read(immunizationRepositoryProvider);
      await repository.deleteImmunization(immunizationId);
    } else {
      await HiveService.addToSyncQueue(
        operation: 'delete',
        table: 'immunization_records',
        data: {'id': immunizationId},
      );
    }
    
    // Invalidate related providers
    ref.invalidate(childImmunizationsProvider(childId));
    ref.invalidate(immunizationCoverageProvider(childId));
    ref.invalidate(upcomingDueVaccinesProvider(childId));
    ref.invalidate(immunizationByIdProvider(immunizationId));
  };
});