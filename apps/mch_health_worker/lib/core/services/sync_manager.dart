import 'dart:async';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'hive_service.dart';
import 'connectivity_service.dart';

/// Enhanced Sync Manager - Handles syncing offline data to server
/// Now with automatic sync, retry logic, conflict resolution, and better error handling
class SyncManager {
  final SupabaseClient _supabase;
  final ConnectivityService _connectivity;

  bool _isSyncing = false;
  Timer? _periodicSyncTimer;
  StreamController<SyncResult>? _syncResultController;

  // Conflict tracking
  final List<ConflictRecord> _conflicts = [];
  List<ConflictRecord> get conflicts => List.unmodifiable(_conflicts);

  SyncManager(this._supabase, this._connectivity);

  /// Initialize sync manager with automatic sync
  Future<void> initialize() async {
    // Listen to connectivity changes
    _connectivity.connectionStatus.listen((isOnline) {
      if (isOnline && !_isSyncing) {
        // Auto-sync when coming online
        syncAll();
      }
    });

    // Start periodic sync (every 15 minutes when online - battery optimized)
    _periodicSyncTimer = Timer.periodic(
      const Duration(minutes: 15),
      (_) {
        if (_connectivity.isOnline && !_isSyncing) {
          syncAll();
        }
      },
    );

    print('✅ Sync manager initialized with auto-sync');
  }

  /// Stream of sync results
  Stream<SyncResult> get syncResults {
    _syncResultController ??= StreamController<SyncResult>.broadcast();
    return _syncResultController!.stream;
  }

  /// Check if sync is in progress
  bool get isSyncing => _isSyncing;

  /// Get pending sync count
  int getPendingCount() {
    return HiveService.getSyncQueueCount();
  }

  /// Get last sync time
  DateTime? getLastSyncTime() {
    return HiveService.getLastSyncTime();
  }

  /// Sync all pending changes (ENHANCED)
  Future<SyncResult> syncAll() async {
    if (_isSyncing) {
      return SyncResult(
        success: false,
        message: 'Sync already in progress',
        synced: 0,
        failed: 0,
      );
    }

    final isOnline = await _connectivity.isConnected();

    if (!isOnline) {
      return SyncResult(
        success: false,
        message: 'No internet connection',
        synced: 0,
        failed: 0,
      );
    }

    _isSyncing = true;
    HiveService.setMetadata('sync_in_progress', true);

    print('🔄 Starting sync...');

    int synced = 0;
    int failed = 0;
    final errors = <String>[];

    final syncQueue = HiveService.getSyncQueue();
    print('📝 Found ${syncQueue.length} items to sync');

    for (final item in syncQueue) {
      try {
        await _syncItem(item);
        await HiveService.removeFromSyncQueue(item['id']);
        synced++;
        print('✅ Synced: ${item['table']} (${item['operation']})');
      } catch (e) {
        failed++;
        errors.add('${item['table']}: $e');
        print('❌ Sync failed: ${item['table']} - $e');

        // Increment retry count - item will be removed if max retries exceeded
        final maxRetriesExceeded =
            await HiveService.incrementRetryCount(item['id']);
        if (maxRetriesExceeded) {
          errors.add('${item['table']}: removed after max retries');
        }
      }
    }

    // Update metadata
    _isSyncing = false;
    HiveService.setMetadata('sync_in_progress', false);

    if (synced > 0) {
      await HiveService.setLastSyncTime(DateTime.now());
    }

    final result = SyncResult(
      success: failed == 0,
      message: failed == 0
          ? synced > 0
              ? 'Synced $synced items successfully'
              : 'Nothing to sync'
          : 'Synced $synced items, $failed failed',
      synced: synced,
      failed: failed,
      errors: errors,
    );

    print('✅ Sync complete: ${result.message}');

    // Broadcast result
    _syncResultController?.add(result);

    return result;
  }

  /// Sync a single item (ENHANCED - now includes appointments)
  Future<void> _syncItem(Map<String, dynamic> item) async {
    final operation = item['operation'] as String;
    final table = item['table'] as String;
    final data = Map<String, dynamic>.from(item['data'] as Map);

    switch (table) {
      case 'maternal_profiles':
        await _syncMaternalProfile(operation, data);
        break;
      case 'lab_results':
        await _syncLabResult(operation, data);
        break;
      case 'maternal_immunizations':
        await _syncImmunization(operation, data);
        break;
      case 'malaria_prevention_records':
        await _syncMalariaRecord(operation, data);
        break;
      case 'nutrition_records':
        await _syncNutritionRecord(operation, data);
        break;
      case 'anc_visits':
        await _syncANCVisit(operation, data);
        break;
      case 'appointments':
        await _syncAppointment(operation, data);
        break;
      case 'child_profiles':
        await _syncChildProfile(operation, data);
        break;
      // NEW: Postnatal visits
      case 'postnatal_visits':
        await _syncGenericTable('postnatal_visits', operation, data);
        break;
      // NEW: Growth records
      case 'growth_records':
        await _syncGenericTable('growth_records', operation, data);
        break;
      // NEW: Developmental milestones
      case 'developmental_milestones':
        await _syncGenericTable('developmental_milestones', operation, data);
        break;
      // NEW: Child immunizations
      case 'immunization_records':
        await _syncGenericTable('immunization_records', operation, data);
        break;
      // NEW: Vitamin A records
      case 'vitamin_a_records':
        await _syncGenericTable('vitamin_a_records', operation, data);
        break;
      // NEW: Deworming records
      case 'deworming_records':
        await _syncGenericTable('deworming_records', operation, data);
        break;
      // NEW: MUAC measurements
      case 'muac_measurements':
        await _syncGenericTable('muac_measurements', operation, data);
        break;
      // NEW: Childbirth records
      case 'childbirth_records':
        await _syncGenericTable('childbirth_records', operation, data);
        break;
      default:
        print('⚠️ Unknown table: $table');
    }
  }

  /// Generic sync method for tables with standard CRUD operations
  /// Now includes timestamp-based conflict resolution for updates
  Future<void> _syncGenericTable(
      String tableName, String operation, Map<String, dynamic> data) async {
    if (operation == 'insert') {
      // Remove temporary IDs
      if (data['id'] != null && data['id'].toString().startsWith('temp_')) {
        data.remove('id');
      }
      await _supabase.from(tableName).insert(data);
    } else if (operation == 'update') {
      // Timestamp-based conflict resolution
      final recordId = data['id'];
      final localUpdatedAt = data['updated_at'] != null
          ? DateTime.parse(data['updated_at'].toString())
          : DateTime.now();

      // Fetch server version to check timestamp
      final serverResponse = await _supabase
          .from(tableName)
          .select('id, updated_at')
          .eq('id', recordId)
          .maybeSingle();

      if (serverResponse != null && serverResponse['updated_at'] != null) {
        final serverUpdatedAt =
            DateTime.parse(serverResponse['updated_at'].toString());

        // Only update if local version is newer than server
        if (localUpdatedAt.isAfter(serverUpdatedAt)) {
          await _supabase.from(tableName).update(data).eq('id', recordId);
          print('✅ Updated $tableName: $recordId (local was newer)');
        } else if (serverUpdatedAt.isAfter(localUpdatedAt)) {
          // Server is newer - record conflict and skip update
          _conflicts.add(ConflictRecord(
            id: recordId,
            table: tableName,
            localData: data,
            serverData: serverResponse,
            localUpdatedAt: localUpdatedAt,
            serverUpdatedAt: serverUpdatedAt,
          ));
          print(
              '⚠️ Conflict detected in $tableName: $recordId - server is newer, skipping update');
        } else {
          // Same timestamp - update anyway (no conflict)
          await _supabase.from(tableName).update(data).eq('id', recordId);
        }
      } else {
        // No server record or no timestamp - proceed with update
        await _supabase.from(tableName).update(data).eq('id', recordId);
      }
    } else if (operation == 'delete') {
      await _supabase.from(tableName).delete().eq('id', data['id']);
    }
  }

  // ==================== EXISTING SYNC METHODS ====================

  Future<void> _syncMaternalProfile(
      String operation, Map<String, dynamic> data) async {
    if (operation == 'create') {
      data.remove('id');
      await _supabase.from('maternal_profiles').insert(data);
    } else if (operation == 'update') {
      await _supabase
          .from('maternal_profiles')
          .update(data)
          .eq('id', data['id']);
    } else if (operation == 'delete') {
      await _supabase.from('maternal_profiles').delete().eq('id', data['id']);
    }
  }

  Future<void> _syncLabResult(
      String operation, Map<String, dynamic> data) async {
    if (operation == 'create') {
      // Remove offline-generated ID if present
      if (data['id'] != null && data['id'].toString().startsWith('offline_')) {
        data.remove('id');
      }
      await _supabase.from('lab_results').insert(data);
    } else if (operation == 'update') {
      await _supabase.from('lab_results').update(data).eq('id', data['id']);
    } else if (operation == 'delete') {
      await _supabase.from('lab_results').delete().eq('id', data['id']);
    }
  }

  Future<void> _syncImmunization(
      String operation, Map<String, dynamic> data) async {
    if (operation == 'create') {
      if (data['id'] != null && data['id'].toString().startsWith('offline_')) {
        data.remove('id');
      }
      await _supabase.from('maternal_immunizations').insert(data);
    } else if (operation == 'update') {
      await _supabase
          .from('maternal_immunizations')
          .update(data)
          .eq('id', data['id']);
    } else if (operation == 'delete') {
      await _supabase
          .from('maternal_immunizations')
          .delete()
          .eq('id', data['id']);
    }
  }

  Future<void> _syncMalariaRecord(
      String operation, Map<String, dynamic> data) async {
    if (operation == 'create') {
      if (data['id'] != null && data['id'].toString().startsWith('offline_')) {
        data.remove('id');
      }
      await _supabase.from('malaria_prevention_records').insert(data);
    } else if (operation == 'update') {
      await _supabase
          .from('malaria_prevention_records')
          .update(data)
          .eq('id', data['id']);
    } else if (operation == 'delete') {
      await _supabase
          .from('malaria_prevention_records')
          .delete()
          .eq('id', data['id']);
    }
  }

  Future<void> _syncNutritionRecord(
      String operation, Map<String, dynamic> data) async {
    if (operation == 'create') {
      data.remove('id');
      await _supabase.from('nutrition_records').insert(data);
    }
  }

  Future<void> _syncANCVisit(
      String operation, Map<String, dynamic> data) async {
    if (operation == 'create') {
      data.remove('id');
      await _supabase.from('anc_visits').insert(data);
    }
  }

  // ==================== NEW SYNC METHODS ====================

  /// Sync appointments (NEW)
  Future<void> _syncAppointment(
      String operation, Map<String, dynamic> data) async {
    if (operation == 'create') {
      // Remove offline-generated ID if it starts with 'offline_'
      if (data['id'] != null && data['id'].toString().startsWith('offline_')) {
        data.remove('id');
      }
      await _supabase.from('appointments').insert(data);
    } else if (operation == 'update') {
      await _supabase.from('appointments').update(data).eq('id', data['id']);
    } else if (operation == 'delete') {
      await _supabase.from('appointments').delete().eq('id', data['id']);
    }
  }

  /// Sync child profiles (NEW)
  Future<void> _syncChildProfile(
      String operation, Map<String, dynamic> data) async {
    if (operation == 'create') {
      if (data['id'] != null && data['id'].toString().startsWith('offline_')) {
        data.remove('id');
      }
      await _supabase.from('child_profiles').insert(data);
    } else if (operation == 'update') {
      await _supabase.from('child_profiles').update(data).eq('id', data['id']);
    } else if (operation == 'delete') {
      await _supabase.from('child_profiles').delete().eq('id', data['id']);
    }
  }

  // ==================== UTILITY METHODS ====================

  /// Clear sync queue (use with caution!)
  Future<void> clearQueue() async {
    final box = HiveService.getBox('sync_queue');
    await box.clear();
    print('⚠️ Sync queue cleared');
  }

  /// Force immediate sync (manual trigger)
  Future<SyncResult> forceSyncNow() async {
    print('🔄 Force sync triggered');
    return await syncAll();
  }

  /// Dispose sync manager
  void dispose() {
    _periodicSyncTimer?.cancel();
    _syncResultController?.close();
    print('✅ Sync manager disposed');
  }
}

/// Sync Result class (ENHANCED with more info)
class SyncResult {
  final bool success;
  final String message;
  final int synced;
  final int failed;
  final List<String> errors;
  final DateTime timestamp;

  SyncResult({
    required this.success,
    required this.message,
    required this.synced,
    required this.failed,
    this.errors = const [],
  }) : timestamp = DateTime.now();

  @override
  String toString() {
    return 'SyncResult(success: $success, synced: $synced, failed: $failed, message: $message)';
  }
}

// ==================== RIVERPOD PROVIDERS ====================

/// Provider for sync manager
final syncManagerProvider = Provider<SyncManager>((ref) {
  final supabase = Supabase.instance.client;
  final connectivity = ref.watch(connectivityServiceProvider);

  final manager = SyncManager(supabase, connectivity);
  manager.initialize();

  ref.onDispose(() {
    manager.dispose();
  });

  return manager;
});

/// Provider for pending sync count
final pendingSyncCountProvider = Provider<int>((ref) {
  final manager = ref.watch(syncManagerProvider);
  // This will update when sync completes
  ref.watch(syncManagerProvider);
  return manager.getPendingCount();
});

/// Provider for last sync time
final lastSyncTimeProvider = Provider<DateTime?>((ref) {
  final manager = ref.watch(syncManagerProvider);
  return manager.getLastSyncTime();
});

/// Stream provider for sync results
final syncResultsProvider = StreamProvider<SyncResult>((ref) {
  final manager = ref.watch(syncManagerProvider);
  return manager.syncResults;
});

/// Provider for conflict count
final conflictCountProvider = Provider<int>((ref) {
  final manager = ref.watch(syncManagerProvider);
  return manager.conflicts.length;
});

// ==================== CONFLICT RECORD ====================

/// Represents a conflict between local and server data
class ConflictRecord {
  final String id;
  final String table;
  final Map<String, dynamic> localData;
  final Map<String, dynamic> serverData;
  final DateTime localUpdatedAt;
  final DateTime serverUpdatedAt;
  final DateTime detectedAt;

  ConflictRecord({
    required this.id,
    required this.table,
    required this.localData,
    required this.serverData,
    required this.localUpdatedAt,
    required this.serverUpdatedAt,
  }) : detectedAt = DateTime.now();

  @override
  String toString() =>
      'ConflictRecord(table: $table, id: $id, local: $localUpdatedAt, server: $serverUpdatedAt)';
}
