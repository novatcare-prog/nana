import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mch_core/mch_core.dart';
import 'supabase_providers.dart';
import '../services/hive_service.dart';
import '../services/connectivity_service.dart';

// ============================================
// REPOSITORY PROVIDERS
// ============================================

final nutritionRepositoryProvider = Provider<NutritionRepository>((ref) {
  final supabase = ref.watch(supabaseClientProvider);
  return NutritionRepository(supabase);
});

final muacRepositoryProvider = Provider<MuacRepository>((ref) {
  final supabase = ref.watch(supabaseClientProvider);
  return MuacRepository(supabase);
});

// ============================================
// NUTRITION DATA PROVIDERS (OFFLINE-FIRST)
// ============================================

/// Get all nutrition records for a patient (offline-first)
final patientNutritionRecordsProvider =
    FutureProvider.family<List<NutritionRecord>, String>((ref, patientId) async {
  final repository = ref.watch(nutritionRepositoryProvider);
  final connectivity = ref.watch(connectivityServiceProvider);
  
  try {
    if (connectivity.isOnline) {
      final results = await repository.getRecordsByPatientId(patientId);
      await HiveService.cacheNutritionRecords(patientId, results);
      return results;
    }
  } catch (e) {
    print('⚠️ Failed to fetch nutrition records online: $e');
  }
  
  return HiveService.getCachedNutritionRecords(patientId);
});

/// Get latest nutrition record for a patient (offline-first)
final latestNutritionRecordProvider =
    FutureProvider.family<NutritionRecord?, String>((ref, patientId) async {
  final records = await ref.watch(patientNutritionRecordsProvider(patientId).future);
  if (records.isEmpty) return null;
  records.sort((a, b) => (b.createdAt ?? DateTime(1970)).compareTo(a.createdAt ?? DateTime(1970)));
  return records.first;
});

/// Get malnourished patients (online only - aggregate query)
final malnourishedPatientsProvider =
    FutureProvider<List<NutritionRecord>>((ref) async {
  final repository = ref.watch(nutritionRepositoryProvider);
  final connectivity = ref.watch(connectivityServiceProvider);
  
  if (!connectivity.isOnline) return [];
  return repository.getMalnourishedPatients();
});

// ============================================
// MUAC DATA PROVIDERS (OFFLINE-FIRST)
// ============================================

/// Get all MUAC measurements for a patient (offline-first)
final patientMuacMeasurementsProvider =
    FutureProvider.family<List<MuacMeasurement>, String>((ref, patientId) async {
  final repository = ref.watch(muacRepositoryProvider);
  final connectivity = ref.watch(connectivityServiceProvider);
  
  try {
    if (connectivity.isOnline) {
      final results = await repository.getMeasurementsByPatientId(patientId);
      // Note: MUAC uses nutrition cache (same patient data)
      return results;
    }
  } catch (e) {
    print('⚠️ Failed to fetch MUAC measurements online: $e');
  }
  
  return [];
});

/// Get latest MUAC measurement for a patient (offline-first)
final latestMuacMeasurementProvider =
    FutureProvider.family<MuacMeasurement?, String>((ref, patientId) async {
  final measurements = await ref.watch(patientMuacMeasurementsProvider(patientId).future);
  if (measurements.isEmpty) return null;
  measurements.sort((a, b) => b.measurementDate.compareTo(a.measurementDate));
  return measurements.first;
});

/// Check if patient is malnourished (offline-first)
final isPatientMalnourishedProvider =
    FutureProvider.family<bool, String>((ref, patientId) async {
  final latest = await ref.watch(latestMuacMeasurementProvider(patientId).future);
  if (latest == null) return false;
  // MUAC < 11.5 cm indicates severe acute malnutrition
  return latest.muacCm < 11.5;
});

// ============================================
// MUTATION PROVIDERS (WITH OFFLINE SUPPORT)
// ============================================

/// Create nutrition record (with offline queue)
final createNutritionRecordProvider =
    Provider<Future<NutritionRecord> Function(NutritionRecord)>((ref) {
  final repository = ref.watch(nutritionRepositoryProvider);
  final connectivity = ref.watch(connectivityServiceProvider);
  
  return (record) async {
    if (connectivity.isOnline) {
      final result = await repository.createRecord(record);
      
      // Update cache
      final cached = HiveService.getCachedNutritionRecords(record.maternalProfileId);
      cached.add(result);
      await HiveService.cacheNutritionRecords(record.maternalProfileId, cached);
      
      ref.invalidate(patientNutritionRecordsProvider(record.maternalProfileId));
      ref.invalidate(latestNutritionRecordProvider(record.maternalProfileId));
      if (record.isMalnourished) {
        ref.invalidate(malnourishedPatientsProvider);
      }
      
      return result;
    } else {
      // Offline: add to sync queue
      await HiveService.addToSyncQueue(
        operation: 'insert',
        table: 'nutrition_records',
        data: record.toJson(),
      );
      
      // Update local cache optimistically
      final cached = HiveService.getCachedNutritionRecords(record.maternalProfileId);
      cached.add(record);
      await HiveService.cacheNutritionRecords(record.maternalProfileId, cached);
      
      ref.invalidate(patientNutritionRecordsProvider(record.maternalProfileId));
      ref.invalidate(latestNutritionRecordProvider(record.maternalProfileId));
      
      return record;
    }
  };
});

/// Create MUAC measurement (with offline queue)
final createMuacMeasurementProvider =
    Provider<Future<MuacMeasurement> Function(MuacMeasurement)>((ref) {
  final repository = ref.watch(muacRepositoryProvider);
  final connectivity = ref.watch(connectivityServiceProvider);
  
  return (measurement) async {
    if (connectivity.isOnline) {
      final result = await repository.createMeasurement(measurement);

      ref.invalidate(patientMuacMeasurementsProvider(measurement.maternalProfileId));
      ref.invalidate(latestMuacMeasurementProvider(measurement.maternalProfileId));
      ref.invalidate(isPatientMalnourishedProvider(measurement.maternalProfileId));

      return result;
    } else {
      // Offline: add to sync queue
      await HiveService.addToSyncQueue(
        operation: 'insert',
        table: 'muac_measurements',
        data: measurement.toJson(),
      );
      
      ref.invalidate(patientMuacMeasurementsProvider(measurement.maternalProfileId));
      ref.invalidate(latestMuacMeasurementProvider(measurement.maternalProfileId));
      ref.invalidate(isPatientMalnourishedProvider(measurement.maternalProfileId));
      
      return measurement;
    }
  };
});

/// Update nutrition record
final updateNutritionRecordProvider =
    Provider<Future<NutritionRecord> Function(NutritionRecord)>((ref) {
  final repository = ref.watch(nutritionRepositoryProvider);
  final connectivity = ref.watch(connectivityServiceProvider);
  
  return (record) async {
    if (connectivity.isOnline) {
      final result = await repository.updateRecord(record);
      
      ref.invalidate(patientNutritionRecordsProvider(record.maternalProfileId));
      ref.invalidate(latestNutritionRecordProvider(record.maternalProfileId));

      return result;
    } else {
      // Offline: add to sync queue
      await HiveService.addToSyncQueue(
        operation: 'update',
        table: 'nutrition_records',
        data: record.toJson(),
      );
      
      ref.invalidate(patientNutritionRecordsProvider(record.maternalProfileId));
      ref.invalidate(latestNutritionRecordProvider(record.maternalProfileId));
      
      return record;
    }
  };
});

/// Update MUAC measurement
final updateMuacMeasurementProvider =
    Provider<Future<MuacMeasurement> Function(MuacMeasurement)>((ref) {
  final repository = ref.watch(muacRepositoryProvider);
  final connectivity = ref.watch(connectivityServiceProvider);
  
  return (measurement) async {
    if (connectivity.isOnline) {
      final result = await repository.updateMeasurement(measurement);

      ref.invalidate(patientMuacMeasurementsProvider(measurement.maternalProfileId));
      ref.invalidate(latestMuacMeasurementProvider(measurement.maternalProfileId));

      return result;
    } else {
      await HiveService.addToSyncQueue(
        operation: 'update',
        table: 'muac_measurements',
        data: measurement.toJson(),
      );
      
      ref.invalidate(patientMuacMeasurementsProvider(measurement.maternalProfileId));
      ref.invalidate(latestMuacMeasurementProvider(measurement.maternalProfileId));
      
      return measurement;
    }
  };
});

/// Delete nutrition record
final deleteNutritionRecordProvider =
    Provider<Future<void> Function(String)>((ref) {
  final repository = ref.watch(nutritionRepositoryProvider);
  final connectivity = ref.watch(connectivityServiceProvider);
  
  return (id) async {
    if (connectivity.isOnline) {
      await repository.deleteRecord(id);
    } else {
      await HiveService.addToSyncQueue(
        operation: 'delete',
        table: 'nutrition_records',
        data: {'id': id},
      );
    }
    ref.invalidate(malnourishedPatientsProvider);
  };
});

/// Delete MUAC measurement
final deleteMuacMeasurementProvider =
    Provider<Future<void> Function(String)>((ref) {
  final repository = ref.watch(muacRepositoryProvider);
  final connectivity = ref.watch(connectivityServiceProvider);
  
  return (id) async {
    if (connectivity.isOnline) {
      await repository.deleteMeasurement(id);
    } else {
      await HiveService.addToSyncQueue(
        operation: 'delete',
        table: 'muac_measurements',
        data: {'id': id},
      );
    }
  };
});