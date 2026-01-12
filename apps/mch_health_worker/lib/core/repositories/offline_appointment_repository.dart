import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:mch_core/mch_core.dart';
import '../services/hive_service.dart';
import '../services/connectivity_service.dart';

/// Offline-first repository for appointments
/// Automatically handles caching and syncing
class OfflineAppointmentRepository {
  final SupabaseClient _supabase;
  final ConnectivityService _connectivity;

  OfflineAppointmentRepository(
    this._supabase,
    this._connectivity,
  );

  /// Get all appointments (offline-first)
  Future<List<Appointment>> getAll() async {
    try {
      // Try to fetch from Supabase if online
      if (_connectivity.isOnline) {
        final response = await _supabase
            .from('appointments')
            .select()
            .order('appointment_date', ascending: false);
        
        final appointments = (response as List)
            .map((json) => Appointment.fromJson(json))
            .toList();
        
        // Cache in Hive
        await _cacheAppointments(appointments);
        
        return appointments;
      }
    } catch (e) {
      print('⚠️ Failed to fetch from Supabase: $e');
    }
    
    // Fallback to Hive cache
    return _getFromCache();
  }

  /// Get appointments for a specific month (offline-first)
  Future<List<Appointment>> getForMonth(DateTime month) async {
    final startDate = DateTime(month.year, month.month, 1);
    final endDate = DateTime(month.year, month.month + 1, 0, 23, 59, 59);
    
    try {
      if (_connectivity.isOnline) {
        final response = await _supabase
            .from('appointments')
            .select()
            .gte('appointment_date', startDate.toIso8601String())
            .lte('appointment_date', endDate.toIso8601String())
            .order('appointment_date', ascending: true);
        
        final appointments = (response as List)
            .map((json) => Appointment.fromJson(json))
            .toList();
        
        // Update cache for these appointments
        await _updateCachePartial(appointments);
        
        return appointments;
      }
    } catch (e) {
      print('⚠️ Failed to fetch month appointments: $e');
    }
    
    // Fallback to filtered cache
    final cached = _getFromCache();
    return cached.where((apt) {
      return apt.appointmentDate.isAfter(startDate) &&
          apt.appointmentDate.isBefore(endDate);
    }).toList();
  }

  /// Create new appointment (offline-capable)
  Future<Appointment> create(Appointment appointment) async {
    // Generate ID if not present
    final apt = appointment.id == null
        ? appointment.copyWith(id: _generateId())
        : appointment;
    
    // Save to cache immediately
    await _addToCache(apt);
    
    // Add to sync queue
    await HiveService.addToSyncQueue(
      operation: 'create',
      table: 'appointments',
      data: apt.toJson(),
    );
    
    // Try immediate sync if online
    if (_connectivity.isOnline) {
      try {
        final data = apt.toJson();
        // Remove offline-generated ID before insert
        if (data['id'] != null && data['id'].toString().startsWith('offline_')) {
          data.remove('id');
        }
        await _supabase.from('appointments').insert(data);
        print('✅ Appointment created online: ${apt.id}');
      } catch (e) {
        print('⚠️ Will sync later: $e');
      }
    } else {
      print('📴 Offline: appointment queued for sync');
    }
    
    return apt;
  }

  /// Update appointment (offline-capable)
  Future<Appointment> update(Appointment appointment) async {
    // Update cache immediately
    await _updateInCache(appointment);
    
    // Add to sync queue
    await HiveService.addToSyncQueue(
      operation: 'update',
      table: 'appointments',
      data: appointment.toJson(),
    );
    
    // Try immediate sync if online
    if (_connectivity.isOnline) {
      try {
        await _supabase
            .from('appointments')
            .update(appointment.toJson())
            .eq('id', appointment.id!);
        print('✅ Appointment updated online: ${appointment.id}');
      } catch (e) {
        print('⚠️ Will sync later: $e');
      }
    } else {
      print('📴 Offline: update queued for sync');
    }
    
    return appointment;
  }

  /// Update appointment status (common operation)
  Future<void> updateStatus(String id, AppointmentStatus status) async {
    final appointments = _getFromCache();
    final appointment = appointments.firstWhere((a) => a.id == id);
    final updated = appointment.copyWith(appointmentStatus: status);
    await update(updated);
  }

  /// Delete appointment (offline-capable)
  Future<void> delete(String id) async {
    // Remove from cache immediately
    await _deleteFromCache(id);
    
    // Add to sync queue
    await HiveService.addToSyncQueue(
      operation: 'delete',
      table: 'appointments',
      data: {'id': id},
    );
    
    // Try immediate sync if online
    if (_connectivity.isOnline) {
      try {
        await _supabase.from('appointments').delete().eq('id', id);
        print('✅ Appointment deleted online: $id');
      } catch (e) {
        print('⚠️ Will sync later: $e');
      }
    } else {
      print('📴 Offline: delete queued for sync');
    }
  }

  // ========== CACHE MANAGEMENT ==========

  /// Cache appointments in Hive
  Future<void> _cacheAppointments(List<Appointment> appointments) async {
    await HiveService.cacheAppointments(
      appointments.map((a) => a.toJson()).toList(),
    );
    print('💾 Cached ${appointments.length} appointments');
  }

  /// Update cache partially (merge with existing)
  Future<void> _updateCachePartial(List<Appointment> appointments) async {
    for (final apt in appointments) {
      await HiveService.cacheAppointment(apt.id!, apt.toJson());
    }
  }

  /// Add single appointment to cache
  Future<void> _addToCache(Appointment appointment) async {
    await HiveService.cacheAppointment(appointment.id!, appointment.toJson());
  }

  /// Update single appointment in cache
  Future<void> _updateInCache(Appointment appointment) async {
    await _addToCache(appointment);
  }

  /// Delete from cache
  Future<void> _deleteFromCache(String id) async {
    await HiveService.deleteAppointment(id);
  }

  /// Get appointments from cache
  List<Appointment> _getFromCache() {
    final cached = HiveService.getCachedAppointments();
    return cached
        .map((json) => Appointment.fromJson(json))
        .toList();
  }

  /// Generate unique ID for offline creation
  String _generateId() {
    return 'offline_${DateTime.now().millisecondsSinceEpoch}';
  }

  /// Clear cache (use with caution!)
  Future<void> clearCache() async {
    await HiveService.clearAppointmentCache();
    print('⚠️ Appointments cache cleared');
  }
}

/// Riverpod provider for offline appointment repository
final offlineAppointmentRepositoryProvider = Provider<OfflineAppointmentRepository>((ref) {
  final supabase = Supabase.instance.client;
  final connectivity = ref.watch(connectivityServiceProvider);
  
  return OfflineAppointmentRepository(supabase, connectivity);
});