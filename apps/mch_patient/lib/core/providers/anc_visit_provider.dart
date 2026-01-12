import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:mch_core/mch_core.dart';

/// ANC Visit Repository Provider
final ancVisitRepositoryProvider = Provider<ANCVisitRepository>((ref) {
  return ANCVisitRepository(Supabase.instance.client);
});

/// Get all ANC visits for the current patient's maternal profile
final ancVisitsProvider = FutureProvider.family<List<ANCVisit>, String>((ref, maternalProfileId) async {
  final repository = ref.read(ancVisitRepositoryProvider);
  
  try {
    return await repository.getVisitsByPatientId(maternalProfileId);
  } catch (e) {
    print('Error fetching ANC visits: $e');
    return <ANCVisit>[];
  }
});

/// Get latest ANC visit
final latestAncVisitProvider = FutureProvider.family<ANCVisit?, String>((ref, maternalProfileId) async {
  final repository = ref.read(ancVisitRepositoryProvider);
  
  try {
    return await repository.getLatestVisit(maternalProfileId);
  } catch (e) {
    print('Error fetching latest ANC visit: $e');
    return null;
  }
});

/// Get ANC visit count
final ancVisitCountProvider = FutureProvider.family<int, String>((ref, maternalProfileId) async {
  final repository = ref.read(ancVisitRepositoryProvider);
  
  try {
    return await repository.getVisitCount(maternalProfileId);
  } catch (e) {
    print('Error fetching ANC visit count: $e');
    return 0;
  }
});
