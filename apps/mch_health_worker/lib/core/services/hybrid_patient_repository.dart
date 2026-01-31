import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:mch_core/mch_core.dart';
import '../services/hive_service.dart';
import '../services/connectivity_service.dart';

/// Hybrid Patient Repository - Uses Supabase + Hive
/// Works offline and syncs when online
/// Enforces facility-based access control for offline mode
class HybridPatientRepository {
  final SupabaseClient _supabase;
  final ConnectivityService _connectivity;
  final String? _facilityId;

  HybridPatientRepository(this._supabase, this._connectivity, [this._facilityId]);

  /// Get all patients (hybrid: try online first, fallback to cache)
  /// Online: RLS enforces facility-based filtering
  /// Offline: Filters cached patients by facilityId
  Future<List<MaternalProfile>> getAllPatients() async {
    try {
      // Check if online
      final isOnline = await _connectivity.isConnected();
      
      if (isOnline) {
        // Fetch from Supabase (RLS automatically filters by facility)
        final response = await _supabase
            .from('maternal_profiles')
            .select()
            .order('created_at', ascending: false);

        final patients = (response as List)
            .map((json) => MaternalProfile.fromJson(json))
            .toList();

        // Cache the patients for offline use
        await HiveService.cachePatients(patients);
        await HiveService.setLastSyncTime(DateTime.now());

        return patients;
      } else {
        // Return cached patients filtered by facility ID
        if (_facilityId != null) {
          return HiveService.getCachedPatientsByFacility(_facilityId!);
        }
        // Fallback to all cached if no facility ID (shouldn't happen)
        return HiveService.getCachedPatients();
      }
    } catch (e) {
      // On error, return cached patients (filtered if possible)
      print('Error fetching patients, using cache: $e');
      if (_facilityId != null) {
        return HiveService.getCachedPatientsByFacility(_facilityId!);
      }
      return HiveService.getCachedPatients();
    }
  }

  /// Get patient by ID (hybrid)
  Future<MaternalProfile?> getPatientById(String id) async {
    try {
      final isOnline = await _connectivity.isConnected();
      
      if (isOnline) {
        final response = await _supabase
            .from('maternal_profiles')
            .select()
            .eq('id', id)
            .single();

        final patient = MaternalProfile.fromJson(response);
        
        // Cache it
        await HiveService.cachePatient(patient);
        
        return patient;
      } else {
        // Return from cache
        return HiveService.getCachedPatient(id);
      }
    } catch (e) {
      // Fallback to cache
      return HiveService.getCachedPatient(id);
    }
  }

  /// Create patient (hybrid: save locally if offline, sync later)
  Future<MaternalProfile> createPatient(MaternalProfile patient) async {
    try {
      final isOnline = await _connectivity.isConnected();
      
      if (isOnline) {
        // Create in Supabase
        final json = patient.toJson();
        json.remove('id');
        json.remove('created_at');
        json.remove('updated_at');

        final response = await _supabase
            .from('maternal_profiles')
            .insert(json)
            .select()
            .single();

        final createdPatient = MaternalProfile.fromJson(response);
        
        // Cache it
        await HiveService.cachePatient(createdPatient);
        
        return createdPatient;
      } else {
        // Save to sync queue for later
        await HiveService.addToSyncQueue(
          operation: 'create',
          table: 'maternal_profiles',
          data: patient.toJson(),
        );
        
        // Cache locally with temporary ID
        final tempPatient = patient.copyWith(
          id: 'temp_${DateTime.now().millisecondsSinceEpoch}',
        );
        await HiveService.cachePatient(tempPatient);
        
        return tempPatient;
      }
    } catch (e) {
      throw Exception('Failed to create patient: $e');
    }
  }

  /// Update patient (hybrid)
  Future<MaternalProfile> updatePatient(MaternalProfile patient) async {
    try {
      final isOnline = await _connectivity.isConnected();
      
      if (isOnline) {
        if (patient.id == null) {
          throw Exception('Patient ID is required for update');
        }

        final response = await _supabase
            .from('maternal_profiles')
            .update(patient.toJson())
            .eq('id', patient.id!)
            .select()
            .single();

        final updatedPatient = MaternalProfile.fromJson(response);
        
        // Update cache
        await HiveService.cachePatient(updatedPatient);
        
        return updatedPatient;
      } else {
        // Add to sync queue
        await HiveService.addToSyncQueue(
          operation: 'update',
          table: 'maternal_profiles',
          data: patient.toJson(),
        );
        
        // Update cache
        await HiveService.cachePatient(patient);
        
        return patient;
      }
    } catch (e) {
      throw Exception('Failed to update patient: $e');
    }
  }

  /// Sync offline changes to server
  Future<void> syncOfflineChanges() async {
    try {
      final isOnline = await _connectivity.isConnected();
      
      if (!isOnline) {
        print('Cannot sync: No internet connection');
        return;
      }

      final syncQueue = HiveService.getSyncQueue();
      
      for (final item in syncQueue) {
        try {
          final operation = item['operation'] as String;
          final table = item['table'] as String;
          final data = item['data'] as Map<String, dynamic>;
          final syncId = item['id'] as String;

          if (table == 'maternal_profiles') {
            if (operation == 'create') {
              data.remove('id'); // Remove temp ID
              await _supabase.from('maternal_profiles').insert(data);
            } else if (operation == 'update') {
              await _supabase
                  .from('maternal_profiles')
                  .update(data)
                  .eq('id', data['id']);
            } else if (operation == 'delete') {
              await _supabase
                  .from('maternal_profiles')
                  .delete()
                  .eq('id', data['id']);
            }
          }

          // Remove from sync queue after successful sync
          await HiveService.removeFromSyncQueue(syncId);
        } catch (e) {
          print('Error syncing item: $e');
          // Keep in queue to retry later
        }
      }

      // Refresh cache after sync
      await getAllPatients();
    } catch (e) {
      print('Error during sync: $e');
    }
  }

  /// Get sync status
  Future<Map<String, dynamic>> getSyncStatus() async {
    final syncQueue = HiveService.getSyncQueue();
    final lastSync = HiveService.getLastSyncTime();
    final cachedCount = HiveService.getCachedPatients().length;
    final isOnline = await _connectivity.isConnected();

    return {
      'is_online': isOnline,
      'pending_sync': syncQueue.length,
      'cached_patients': cachedCount,
      'last_sync': lastSync?.toIso8601String(),
    };
  }
}