import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:mch_core/mch_core.dart';

/// Growth Record Repository Provider
final growthRecordRepositoryProvider = Provider<GrowthRecordRepository>((ref) {
  return GrowthRecordRepository(Supabase.instance.client);
});

/// Get all growth records for a child
final childGrowthRecordsProvider = FutureProvider.family<List<GrowthRecord>, String>((ref, childId) async {
  final repository = ref.read(growthRecordRepositoryProvider);
  
  try {
    return await repository.getRecordsByChildId(childId);
  } catch (e) {
    print('Error fetching growth records: $e');
    return <GrowthRecord>[];
  }
});

/// Get latest growth record for a child
final latestGrowthRecordProvider = FutureProvider.family<GrowthRecord?, String>((ref, childId) async {
  final repository = ref.read(growthRecordRepositoryProvider);
  
  try {
    return await repository.getLatestRecord(childId);
  } catch (e) {
    print('Error fetching latest growth record: $e');
    return null;
  }
});
