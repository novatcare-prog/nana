import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:mch_core/mch_core.dart';

/// Postnatal Visit Repository Provider
final postnatalVisitRepositoryProvider = Provider<PostnatalVisitRepository>((ref) {
  return PostnatalVisitRepository(Supabase.instance.client);
});

/// Get all postnatal visits for a child
final childVisitsProvider = FutureProvider.family<List<PostnatalVisit>, String>((ref, childId) async {
  final repository = ref.read(postnatalVisitRepositoryProvider);
  
  try {
    return await repository.getVisitsByChildId(childId);
  } catch (e) {
    print('Error fetching child visits: $e');
    return <PostnatalVisit>[];
  }
});

/// Get latest postnatal visit for a child
final latestChildVisitProvider = FutureProvider.family<PostnatalVisit?, String>((ref, childId) async {
  final visits = await ref.watch(childVisitsProvider(childId).future);
  
  if (visits.isEmpty) return null;
  return visits.first; // Already sorted by date descending
});

/// Get visit count for a child
final childVisitCountProvider = FutureProvider.family<int, String>((ref, childId) async {
  final visits = await ref.watch(childVisitsProvider(childId).future);
  return visits.length;
});
