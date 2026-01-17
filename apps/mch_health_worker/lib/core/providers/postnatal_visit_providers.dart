import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mch_core/mch_core.dart';
import 'supabase_providers.dart';
import '../services/hive_service.dart';
import '../services/connectivity_service.dart';

// Repository Provider
final postnatalVisitRepositoryProvider = Provider<PostnatalVisitRepository>((ref) {
  final supabase = ref.watch(supabaseClientProvider);
  return PostnatalVisitRepository(supabase);
});

// ============================================
// DATA PROVIDERS (OFFLINE-FIRST)
// ============================================

/// Get all visits for a maternal profile (offline-first)
final postnatalVisitsByMaternalIdProvider = FutureProvider.family<List<PostnatalVisit>, String>((ref, maternalProfileId) async {
  final repository = ref.watch(postnatalVisitRepositoryProvider);
  final connectivity = ref.watch(connectivityServiceProvider);
  
  try {
    if (connectivity.isOnline) {
      final results = await repository.getVisitsByMaternalId(maternalProfileId);
      // Cache could be added here if HiveService supports it
      return results;
    }
  } catch (e) {
    print('⚠️ Failed to fetch postnatal visits online: $e');
  }
  
  return [];
});

/// Get all visits for a child (offline-first)
final postnatalVisitsByChildIdProvider = FutureProvider.family<List<PostnatalVisit>, String>((ref, childId) async {
  final repository = ref.watch(postnatalVisitRepositoryProvider);
  final connectivity = ref.watch(connectivityServiceProvider);
  
  if (connectivity.isOnline) {
    return repository.getVisitsByChildId(childId);
  }
  return [];
});

/// Get single visit by ID
final postnatalVisitByIdProvider = FutureProvider.family<PostnatalVisit?, String>((ref, visitId) async {
  final repository = ref.watch(postnatalVisitRepositoryProvider);
  final connectivity = ref.watch(connectivityServiceProvider);
  
  if (connectivity.isOnline) {
    return repository.getVisitById(visitId);
  }
  return null;
});

/// Get upcoming visits (online only)
final upcomingPostnatalVisitsProvider = FutureProvider.family<List<PostnatalVisit>, String>((ref, maternalProfileId) async {
  final repository = ref.watch(postnatalVisitRepositoryProvider);
  final connectivity = ref.watch(connectivityServiceProvider);
  
  if (!connectivity.isOnline) return [];
  return repository.getUpcomingVisits(maternalProfileId);
});

/// Get visits with danger signs (online only)
final postnatalVisitsWithDangerSignsProvider = FutureProvider.family<List<PostnatalVisit>, String>((ref, maternalProfileId) async {
  final repository = ref.watch(postnatalVisitRepositoryProvider);
  final connectivity = ref.watch(connectivityServiceProvider);
  
  if (!connectivity.isOnline) return [];
  return repository.getVisitsWithDangerSigns(maternalProfileId);
});

/// Get latest visit (offline-first)
final latestPostnatalVisitProvider = FutureProvider.family<PostnatalVisit?, String>((ref, maternalProfileId) async {
  final visits = await ref.watch(postnatalVisitsByMaternalIdProvider(maternalProfileId).future);
  if (visits.isEmpty) return null;
  visits.sort((a, b) => b.visitDate.compareTo(a.visitDate));
  return visits.first;
});

/// Get visits by type (offline-first)
final postnatalVisitsByTypeProvider = FutureProvider.family<List<PostnatalVisit>, ({String maternalProfileId, String visitType})>((ref, params) async {
  final visits = await ref.watch(postnatalVisitsByMaternalIdProvider(params.maternalProfileId).future);
  return visits.where((v) => v.visitType == params.visitType).toList();
});

/// Get total visits count (offline-first)
final totalPostnatalVisitsCountProvider = FutureProvider.family<int, String>((ref, maternalProfileId) async {
  final visits = await ref.watch(postnatalVisitsByMaternalIdProvider(maternalProfileId).future);
  return visits.length;
});

// ============================================
// MUTATION PROVIDERS (WITH OFFLINE SUPPORT)
// ============================================

/// Create visit (with offline queue)
final createPostnatalVisitProvider = Provider<Future<PostnatalVisit> Function(PostnatalVisit)>((ref) {
  final connectivity = ref.watch(connectivityServiceProvider);
  
  return (visit) async {
    if (connectivity.isOnline) {
      final repository = ref.read(postnatalVisitRepositoryProvider);
      final result = await repository.createVisit(visit);
      
      // Invalidate related providers
      ref.invalidate(postnatalVisitsByMaternalIdProvider(visit.maternalProfileId));
      ref.invalidate(latestPostnatalVisitProvider(visit.maternalProfileId));
      ref.invalidate(upcomingPostnatalVisitsProvider(visit.maternalProfileId));
      ref.invalidate(totalPostnatalVisitsCountProvider(visit.maternalProfileId));
      
      if (visit.childProfileId != null) {
        ref.invalidate(postnatalVisitsByChildIdProvider(visit.childProfileId!));
      }
      
      return result;
    } else {
      // Offline: add to sync queue
      await HiveService.addToSyncQueue(
        operation: 'insert',
        table: 'postnatal_visits',
        data: visit.toJson(),
      );
      
      ref.invalidate(postnatalVisitsByMaternalIdProvider(visit.maternalProfileId));
      ref.invalidate(latestPostnatalVisitProvider(visit.maternalProfileId));
      ref.invalidate(totalPostnatalVisitsCountProvider(visit.maternalProfileId));
      
      return visit;
    }
  };
});

/// Update visit (with offline queue)
final updatePostnatalVisitProvider = Provider<Future<PostnatalVisit> Function(PostnatalVisit)>((ref) {
  final connectivity = ref.watch(connectivityServiceProvider);
  
  return (visit) async {
    if (connectivity.isOnline) {
      final repository = ref.read(postnatalVisitRepositoryProvider);
      final result = await repository.updateVisit(visit);
      
      // Invalidate related providers
      ref.invalidate(postnatalVisitsByMaternalIdProvider(visit.maternalProfileId));
      ref.invalidate(postnatalVisitByIdProvider(visit.id!));
      ref.invalidate(latestPostnatalVisitProvider(visit.maternalProfileId));
      ref.invalidate(upcomingPostnatalVisitsProvider(visit.maternalProfileId));
      
      if (visit.childProfileId != null) {
        ref.invalidate(postnatalVisitsByChildIdProvider(visit.childProfileId!));
      }
      
      return result;
    } else {
      await HiveService.addToSyncQueue(
        operation: 'update',
        table: 'postnatal_visits',
        data: visit.toJson(),
      );
      
      ref.invalidate(postnatalVisitsByMaternalIdProvider(visit.maternalProfileId));
      ref.invalidate(latestPostnatalVisitProvider(visit.maternalProfileId));
      
      return visit;
    }
  };
});

/// Delete visit (with offline queue)
final deletePostnatalVisitProvider = Provider<Future<void> Function(String, String)>((ref) {
  final connectivity = ref.watch(connectivityServiceProvider);
  
  return (visitId, maternalProfileId) async {
    if (connectivity.isOnline) {
      final repository = ref.read(postnatalVisitRepositoryProvider);
      await repository.deleteVisit(visitId);
    } else {
      await HiveService.addToSyncQueue(
        operation: 'delete',
        table: 'postnatal_visits',
        data: {'id': visitId},
      );
    }
    
    // Invalidate related providers
    ref.invalidate(postnatalVisitsByMaternalIdProvider(maternalProfileId));
    ref.invalidate(postnatalVisitByIdProvider(visitId));
    ref.invalidate(latestPostnatalVisitProvider(maternalProfileId));
    ref.invalidate(upcomingPostnatalVisitsProvider(maternalProfileId));
    ref.invalidate(totalPostnatalVisitsCountProvider(maternalProfileId));
  };
});