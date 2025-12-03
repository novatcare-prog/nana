import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mch_core/mch_core.dart';
import 'supabase_providers.dart';

// Repository Provider
final postnatalVisitRepositoryProvider = Provider<PostnatalVisitRepository>((ref) {
  final supabase = ref.watch(supabaseClientProvider);
  return PostnatalVisitRepository(supabase);
});

// Get all visits for a maternal profile
final postnatalVisitsByMaternalIdProvider = FutureProvider.family<List<PostnatalVisit>, String>((ref, maternalProfileId) async {
  final repository = ref.watch(postnatalVisitRepositoryProvider);
  return repository.getVisitsByMaternalId(maternalProfileId);
});

// Get all visits for a child
final postnatalVisitsByChildIdProvider = FutureProvider.family<List<PostnatalVisit>, String>((ref, childId) async {
  final repository = ref.watch(postnatalVisitRepositoryProvider);
  return repository.getVisitsByChildId(childId);
});

// Get single visit by ID
final postnatalVisitByIdProvider = FutureProvider.family<PostnatalVisit?, String>((ref, visitId) async {
  final repository = ref.watch(postnatalVisitRepositoryProvider);
  return repository.getVisitById(visitId);
});

// Get upcoming visits
final upcomingPostnatalVisitsProvider = FutureProvider.family<List<PostnatalVisit>, String>((ref, maternalProfileId) async {
  final repository = ref.watch(postnatalVisitRepositoryProvider);
  return repository.getUpcomingVisits(maternalProfileId);
});

// Get visits with danger signs
final postnatalVisitsWithDangerSignsProvider = FutureProvider.family<List<PostnatalVisit>, String>((ref, maternalProfileId) async {
  final repository = ref.watch(postnatalVisitRepositoryProvider);
  return repository.getVisitsWithDangerSigns(maternalProfileId);
});

// Get latest visit
final latestPostnatalVisitProvider = FutureProvider.family<PostnatalVisit?, String>((ref, maternalProfileId) async {
  final repository = ref.watch(postnatalVisitRepositoryProvider);
  return repository.getLatestVisit(maternalProfileId);
});

// Get visits by type
final postnatalVisitsByTypeProvider = FutureProvider.family<List<PostnatalVisit>, ({String maternalProfileId, String visitType})>((ref, params) async {
  final repository = ref.watch(postnatalVisitRepositoryProvider);
  return repository.getVisitsByType(params.maternalProfileId, params.visitType);
});

// Get total visits count
final totalPostnatalVisitsCountProvider = FutureProvider.family<int, String>((ref, maternalProfileId) async {
  final repository = ref.watch(postnatalVisitRepositoryProvider);
  return repository.getTotalVisitsCount(maternalProfileId);
});

// Create visit
final createPostnatalVisitProvider = Provider<Future<PostnatalVisit> Function(PostnatalVisit)>((ref) {
  return (visit) async {
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
  };
});

// Update visit
final updatePostnatalVisitProvider = Provider<Future<PostnatalVisit> Function(PostnatalVisit)>((ref) {
  return (visit) async {
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
  };
});

// Delete visit
final deletePostnatalVisitProvider = Provider<Future<void> Function(String, String)>((ref) {
  return (visitId, maternalProfileId) async {
    final repository = ref.read(postnatalVisitRepositoryProvider);
    await repository.deleteVisit(visitId);
    
    // Invalidate related providers
    ref.invalidate(postnatalVisitsByMaternalIdProvider(maternalProfileId));
    ref.invalidate(postnatalVisitByIdProvider(visitId));
    ref.invalidate(latestPostnatalVisitProvider(maternalProfileId));
    ref.invalidate(upcomingPostnatalVisitsProvider(maternalProfileId));
    ref.invalidate(totalPostnatalVisitsCountProvider(maternalProfileId));
  };
});