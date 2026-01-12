import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mch_core/mch_core.dart';
import 'supabase_providers.dart';
import '../services/hive_service.dart';
import '../services/connectivity_service.dart';

// ============================================
// REPOSITORY PROVIDERS
// ============================================

final maternalImmunizationRepositoryProvider =
    Provider<MaternalImmunizationRepository>((ref) {
  final supabase = ref.watch(supabaseClientProvider);
  return MaternalImmunizationRepository(supabase);
});

final malariaPreventionRepositoryProvider =
    Provider<MalariaPreventionRepository>((ref) {
  final supabase = ref.watch(supabaseClientProvider);
  return MalariaPreventionRepository(supabase);
});

// ============================================
// MATERNAL IMMUNIZATION DATA PROVIDERS (OFFLINE-FIRST)
// ============================================

/// Get all TT immunizations for a patient (offline-first)
final patientImmunizationsProvider =
    FutureProvider.family<List<MaternalImmunization>, String>(
        (ref, patientId) async {
  final repository = ref.watch(maternalImmunizationRepositoryProvider);
  final connectivity = ref.watch(connectivityServiceProvider);
  
  try {
    if (connectivity.isOnline) {
      final results = await repository.getImmunizationsByPatientId(patientId);
      // Cache for offline use
      await HiveService.cacheImmunizations(patientId, results);
      return results;
    }
  } catch (e) {
    print('⚠️ Failed to fetch immunizations online: $e');
  }
  
  // Fallback to cache
  return HiveService.getCachedImmunizations(patientId);
});

/// Get latest TT dose for a patient (offline-first)
final latestTTDoseProvider =
    FutureProvider.family<MaternalImmunization?, String>((ref, patientId) async {
  final immunizations = await ref.watch(patientImmunizationsProvider(patientId).future);
  if (immunizations.isEmpty) return null;
  
  // Sort by TT dose number and return the latest
  immunizations.sort((a, b) => b.ttDose.compareTo(a.ttDose));
  return immunizations.first;
});

/// Check if patient has specific TT dose (offline-first)
final hasTTDoseProvider = FutureProvider.family<bool, DoseQuery>(
    (ref, query) async {
  final immunizations = await ref.watch(patientImmunizationsProvider(query.patientId).future);
  return immunizations.any((i) => i.ttDose == query.doseNumber);
});

// ============================================
// MALARIA PREVENTION DATA PROVIDERS (OFFLINE-FIRST)
// ============================================

/// Get all IPTp records for a patient (offline-first)
final patientMalariaRecordsProvider =
    FutureProvider.family<List<MalariaPreventionRecord>, String>(
        (ref, patientId) async {
  final repository = ref.watch(malariaPreventionRepositoryProvider);
  final connectivity = ref.watch(connectivityServiceProvider);
  
  try {
    if (connectivity.isOnline) {
      final results = await repository.getRecordsByPatientId(patientId);
      // Cache for offline use
      await HiveService.cacheMalariaRecords(patientId, results);
      return results;
    }
  } catch (e) {
    print('⚠️ Failed to fetch malaria records online: $e');
  }
  
  // Fallback to cache
  return HiveService.getCachedMalariaRecords(patientId);
});

/// Get latest SP dose for a patient (offline-first)
final latestSPDoseProvider =
    FutureProvider.family<MalariaPreventionRecord?, String>(
        (ref, patientId) async {
  final records = await ref.watch(patientMalariaRecordsProvider(patientId).future);
  if (records.isEmpty) return null;
  
  // Sort by SP dose number and return the latest
  records.sort((a, b) => b.spDose.compareTo(a.spDose));
  return records.first;
});

/// Check if patient has ITN (offline-first)
final hasITNProvider = FutureProvider.family<bool, String>(
    (ref, patientId) async {
  final records = await ref.watch(patientMalariaRecordsProvider(patientId).future);
  return records.any((r) => r.itnGiven);
});

// ============================================
// MUTATION PROVIDERS (WITH OFFLINE QUEUE)
// ============================================

/// Create TT immunization (with offline queue)
final createImmunizationProvider =
    Provider<Future<MaternalImmunization> Function(MaternalImmunization)>(
        (ref) {
  final repository = ref.watch(maternalImmunizationRepositoryProvider);
  final connectivity = ref.watch(connectivityServiceProvider);
  
  return (immunization) async {
    try {
      if (connectivity.isOnline) {
        final result = await repository.createImmunization(immunization);
        
        // Update cache
        final cached = HiveService.getCachedImmunizations(immunization.maternalProfileId);
        cached.add(result);
        await HiveService.cacheImmunizations(immunization.maternalProfileId, cached);
        
        ref.invalidate(patientImmunizationsProvider(immunization.maternalProfileId));
        ref.invalidate(latestTTDoseProvider(immunization.maternalProfileId));
        
        return result;
      } else {
        // Queue for sync
        await HiveService.addToSyncQueue(
          operation: 'create',
          table: 'maternal_immunizations',
          data: immunization.toJson(),
        );
        
        // Add to local cache with temp ID using copyWith
        final tempResult = immunization.copyWith(
          id: 'offline_${DateTime.now().millisecondsSinceEpoch}',
        );
        
        final cached = HiveService.getCachedImmunizations(immunization.maternalProfileId);
        cached.add(tempResult);
        await HiveService.cacheImmunizations(immunization.maternalProfileId, cached);
        
        ref.invalidate(patientImmunizationsProvider(immunization.maternalProfileId));
        ref.invalidate(latestTTDoseProvider(immunization.maternalProfileId));
        
        print('📴 Immunization queued for sync');
        return tempResult;
      }
    } catch (e) {
      throw Exception('Failed to create immunization: $e');
    }
  };
});

/// Create malaria prevention record (with offline queue)
final createMalariaRecordProvider = Provider<
    Future<MalariaPreventionRecord> Function(MalariaPreventionRecord)>((ref) {
  final repository = ref.watch(malariaPreventionRepositoryProvider);
  final connectivity = ref.watch(connectivityServiceProvider);
  
  return (record) async {
    try {
      if (connectivity.isOnline) {
        final result = await repository.createRecord(record);
        
        // Update cache
        final cached = HiveService.getCachedMalariaRecords(record.maternalProfileId);
        cached.add(result);
        await HiveService.cacheMalariaRecords(record.maternalProfileId, cached);
        
        ref.invalidate(patientMalariaRecordsProvider(record.maternalProfileId));
        ref.invalidate(latestSPDoseProvider(record.maternalProfileId));
        if (record.itnGiven) {
          ref.invalidate(hasITNProvider(record.maternalProfileId));
        }
        
        return result;
      } else {
        // Queue for sync
        await HiveService.addToSyncQueue(
          operation: 'create',
          table: 'malaria_prevention_records',
          data: record.toJson(),
        );
        
        // Add to local cache with temp ID using copyWith
        final tempResult = record.copyWith(
          id: 'offline_${DateTime.now().millisecondsSinceEpoch}',
        );
        
        final cached = HiveService.getCachedMalariaRecords(record.maternalProfileId);
        cached.add(tempResult);
        await HiveService.cacheMalariaRecords(record.maternalProfileId, cached);
        
        ref.invalidate(patientMalariaRecordsProvider(record.maternalProfileId));
        ref.invalidate(latestSPDoseProvider(record.maternalProfileId));
        
        print('📴 Malaria record queued for sync');
        return tempResult;
      }
    } catch (e) {
      throw Exception('Failed to create malaria record: $e');
    }
  };
});

/// Update TT immunization
final updateImmunizationProvider =
    Provider<Future<MaternalImmunization> Function(MaternalImmunization)>(
        (ref) {
  final repository = ref.watch(maternalImmunizationRepositoryProvider);
  final connectivity = ref.watch(connectivityServiceProvider);
  
  return (immunization) async {
    try {
      if (connectivity.isOnline) {
        final result = await repository.updateImmunization(immunization);
        ref.invalidate(patientImmunizationsProvider(immunization.maternalProfileId));
        ref.invalidate(latestTTDoseProvider(immunization.maternalProfileId));
        return result;
      } else {
        await HiveService.addToSyncQueue(
          operation: 'update',
          table: 'maternal_immunizations',
          data: immunization.toJson(),
        );
        
        // Update local cache
        final cached = HiveService.getCachedImmunizations(immunization.maternalProfileId);
        final index = cached.indexWhere((i) => i.id == immunization.id);
        if (index >= 0) {
          cached[index] = immunization;
          await HiveService.cacheImmunizations(immunization.maternalProfileId, cached);
        }
        
        ref.invalidate(patientImmunizationsProvider(immunization.maternalProfileId));
        print('📴 Immunization update queued for sync');
        return immunization;
      }
    } catch (e) {
      throw Exception('Failed to update immunization: $e');
    }
  };
});

/// Update malaria prevention record
final updateMalariaRecordProvider = Provider<
    Future<MalariaPreventionRecord> Function(MalariaPreventionRecord)>((ref) {
  final repository = ref.watch(malariaPreventionRepositoryProvider);
  final connectivity = ref.watch(connectivityServiceProvider);
  
  return (record) async {
    try {
      if (connectivity.isOnline) {
        final result = await repository.updateRecord(record);
        ref.invalidate(patientMalariaRecordsProvider(record.maternalProfileId));
        ref.invalidate(latestSPDoseProvider(record.maternalProfileId));
        return result;
      } else {
        await HiveService.addToSyncQueue(
          operation: 'update',
          table: 'malaria_prevention_records',
          data: record.toJson(),
        );
        
        // Update local cache
        final cached = HiveService.getCachedMalariaRecords(record.maternalProfileId);
        final index = cached.indexWhere((r) => r.id == record.id);
        if (index >= 0) {
          cached[index] = record;
          await HiveService.cacheMalariaRecords(record.maternalProfileId, cached);
        }
        
        ref.invalidate(patientMalariaRecordsProvider(record.maternalProfileId));
        print('📴 Malaria record update queued for sync');
        return record;
      }
    } catch (e) {
      throw Exception('Failed to update malaria record: $e');
    }
  };
});

/// Delete TT immunization
final deleteImmunizationProvider =
    Provider<Future<void> Function(String, String)>((ref) {
  final repository = ref.watch(maternalImmunizationRepositoryProvider);
  final connectivity = ref.watch(connectivityServiceProvider);
  
  return (id, patientId) async {
    try {
      if (connectivity.isOnline) {
        await repository.deleteImmunization(id);
      } else {
        await HiveService.addToSyncQueue(
          operation: 'delete',
          table: 'maternal_immunizations',
          data: {'id': id},
        );
      }
      
      // Remove from local cache
      final cached = HiveService.getCachedImmunizations(patientId);
      cached.removeWhere((i) => i.id == id);
      await HiveService.cacheImmunizations(patientId, cached);
      
      ref.invalidate(patientImmunizationsProvider(patientId));
      ref.invalidate(latestTTDoseProvider(patientId));
    } catch (e) {
      throw Exception('Failed to delete immunization: $e');
    }
  };
});

/// Delete malaria prevention record
final deleteMalariaRecordProvider =
    Provider<Future<void> Function(String, String)>((ref) {
  final repository = ref.watch(malariaPreventionRepositoryProvider);
  final connectivity = ref.watch(connectivityServiceProvider);
  
  return (id, patientId) async {
    try {
      if (connectivity.isOnline) {
        await repository.deleteRecord(id);
      } else {
        await HiveService.addToSyncQueue(
          operation: 'delete',
          table: 'malaria_prevention_records',
          data: {'id': id},
        );
      }
      
      // Remove from local cache
      final cached = HiveService.getCachedMalariaRecords(patientId);
      cached.removeWhere((r) => r.id == id);
      await HiveService.cacheMalariaRecords(patientId, cached);
      
      ref.invalidate(patientMalariaRecordsProvider(patientId));
      ref.invalidate(latestSPDoseProvider(patientId));
    } catch (e) {
      throw Exception('Failed to delete malaria record: $e');
    }
  };
});

// ============================================
// HELPER CLASSES
// ============================================

class DoseQuery {
  final String patientId;
  final int doseNumber;

  DoseQuery({
    required this.patientId,
    required this.doseNumber,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DoseQuery &&
          runtimeType == other.runtimeType &&
          patientId == other.patientId &&
          doseNumber == other.doseNumber;

  @override
  int get hashCode => patientId.hashCode ^ doseNumber.hashCode;
}