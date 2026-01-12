import 'dart:async';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mch_core/mch_core.dart';
import 'hive_service.dart';
import 'connectivity_service.dart';

/// Enhanced Sync Manager - Handles syncing offline data to server
/// Now with automatic sync, retry logic, and better error handling
class SyncManager {
  final SupabaseClient _supabase;
  final ConnectivityService _connectivity;
  
  bool _isSyncing = false;
  Timer? _periodicSyncTimer;
  StreamController<SyncResult>? _syncResultController;

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

    // Start periodic sync (every 5 minutes when online)
    _periodicSyncTimer = Timer.periodic(
      const Duration(minutes: 5),
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
      // NEW: Appointments
      case 'appointments':
        await _syncAppointment(operation, data);
        break;
      // NEW: Child profiles
      case 'child_profiles':
        await _syncChildProfile(operation, data);
        break;
      default:
        print('⚠️ Unknown table: $table');
    }
  }

  // ==================== EXISTING SYNC METHODS ====================

  Future<void> _syncMaternalProfile(String operation, Map<String, dynamic> data) async {
    if (operation == 'create') {
      data.remove('id');
      await _supabase.from('maternal_profiles').insert(data);
    } else if (operation == 'update') {
      await _supabase.from('maternal_profiles').update(data).eq('id', data['id']);
    } else if (operation == 'delete') {
      await _supabase.from('maternal_profiles').delete().eq('id', data['id']);
    }
  }

  Future<void> _syncLabResult(String operation, Map<String, dynamic> data) async {
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

  Future<void> _syncImmunization(String operation, Map<String, dynamic> data) async {
    if (operation == 'create') {
      if (data['id'] != null && data['id'].toString().startsWith('offline_')) {
        data.remove('id');
      }
      await _supabase.from('maternal_immunizations').insert(data);
    } else if (operation == 'update') {
      await _supabase.from('maternal_immunizations').update(data).eq('id', data['id']);
    } else if (operation == 'delete') {
      await _supabase.from('maternal_immunizations').delete().eq('id', data['id']);
    }
  }

  Future<void> _syncMalariaRecord(String operation, Map<String, dynamic> data) async {
    if (operation == 'create') {
      if (data['id'] != null && data['id'].toString().startsWith('offline_')) {
        data.remove('id');
      }
      await _supabase.from('malaria_prevention_records').insert(data);
    } else if (operation == 'update') {
      await _supabase.from('malaria_prevention_records').update(data).eq('id', data['id']);
    } else if (operation == 'delete') {
      await _supabase.from('malaria_prevention_records').delete().eq('id', data['id']);
    }
  }

  Future<void> _syncNutritionRecord(String operation, Map<String, dynamic> data) async {
    if (operation == 'create') {
      data.remove('id');
      await _supabase.from('nutrition_records').insert(data);
    }
  }

  Future<void> _syncANCVisit(String operation, Map<String, dynamic> data) async {
    if (operation == 'create') {
      data.remove('id');
      await _supabase.from('anc_visits').insert(data);
    }
  }

  // ==================== NEW SYNC METHODS ====================

  /// Sync appointments (NEW)
  Future<void> _syncAppointment(String operation, Map<String, dynamic> data) async {
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
  Future<void> _syncChildProfile(String operation, Map<String, dynamic> data) async {
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