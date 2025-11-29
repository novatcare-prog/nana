import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:mch_core/mch_core.dart';
import 'hive_service.dart';
import 'connectivity_service.dart';

/// Sync Manager - Handles syncing offline data to server
class SyncManager {
  final SupabaseClient _supabase;
  final ConnectivityService _connectivity;

  SyncManager(this._supabase, this._connectivity);

  /// Sync all pending changes
  Future<SyncResult> syncAll() async {
    final isOnline = await _connectivity.isConnected();
    
    if (!isOnline) {
      return SyncResult(
        success: false,
        message: 'No internet connection',
        synced: 0,
        failed: 0,
      );
    }

    int synced = 0;
    int failed = 0;
    final errors = <String>[];

    final syncQueue = HiveService.getSyncQueue();

    for (final item in syncQueue) {
      try {
        await _syncItem(item);
        await HiveService.removeFromSyncQueue(item['id']);
        synced++;
      } catch (e) {
        failed++;
        errors.add('${item['table']}: $e');
        print('Sync error: $e');
      }
    }

    return SyncResult(
      success: failed == 0,
      message: failed == 0 
          ? 'All changes synced successfully' 
          : '$synced synced, $failed failed',
      synced: synced,
      failed: failed,
      errors: errors,
    );
  }

  /// Sync a single item
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
    }
  }

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
      data.remove('id');
      await _supabase.from('lab_results').insert(data);
    }
  }

  Future<void> _syncImmunization(String operation, Map<String, dynamic> data) async {
    if (operation == 'create') {
      data.remove('id');
      await _supabase.from('maternal_immunizations').insert(data);
    }
  }

  Future<void> _syncMalariaRecord(String operation, Map<String, dynamic> data) async {
    if (operation == 'create') {
      data.remove('id');
      await _supabase.from('malaria_prevention_records').insert(data);
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
}

/// Sync Result class
class SyncResult {
  final bool success;
  final String message;
  final int synced;
  final int failed;
  final List<String> errors;

  SyncResult({
    required this.success,
    required this.message,
    required this.synced,
    required this.failed,
    this.errors = const [],
  });
}