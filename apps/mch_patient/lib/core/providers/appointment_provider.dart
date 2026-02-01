import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:mch_core/mch_core.dart';
import 'maternal_profile_provider.dart';

// Note: AppointmentRepository is not exported from mch_core, so we define it here
// This should be moved to mch_core exports later

/// Repository class for appointments
class AppointmentRepository {
  final SupabaseClient _supabase;

  AppointmentRepository(this._supabase);

  /// Get appointments for a specific patient by maternal_profile_id
  Future<List<Appointment>> getAppointmentsByPatientId(String maternalProfileId) async {
    try {
      final response = await _supabase
          .from('appointments')
          .select()
          .eq('maternal_profile_id', maternalProfileId)
          .order('appointment_date', ascending: true);

      return (response as List)
          .map((json) => Appointment.fromJson(json))
          .toList();
    } catch (e) {
      print('Error fetching appointments: $e');
      throw Exception('Failed to fetch patient appointments: $e');
    }
  }

  /// Get upcoming appointments for a patient
  Future<List<Appointment>> getUpcomingAppointments(String maternalProfileId) async {
    try {
      final now = DateTime.now();
      // Use start of today to include appointments that might be slightly in the past today
      // This prevents "disappearing" appointments on the day of the visit
      final startOfToday = DateTime(now.year, now.month, now.day).toIso8601String();
      
      final response = await _supabase
          .from('appointments')
          .select()
          .eq('maternal_profile_id', maternalProfileId)
          .gte('appointment_date', startOfToday)
          .inFilter('appointment_status', ['scheduled', 'confirmed'])
          .order('appointment_date', ascending: true);

      return (response as List)
          .map((json) => Appointment.fromJson(json))
          .toList();
    } catch (e) {
      print('Error fetching upcoming appointments: $e');
      throw Exception('Failed to fetch upcoming appointments: $e');
    }
  }

  /// Get past appointments for a patient
  Future<List<Appointment>> getPastAppointments(String maternalProfileId) async {
    try {
      final now = DateTime.now().toIso8601String();
      final response = await _supabase
          .from('appointments')
          .select()
          .eq('maternal_profile_id', maternalProfileId)
          .lt('appointment_date', now)
          .order('appointment_date', ascending: false);

      return (response as List)
          .map((json) => Appointment.fromJson(json))
          .toList();
    } catch (e) {
      print('Error fetching past appointments: $e');
      throw Exception('Failed to fetch past appointments: $e');
    }
  }
}

/// Repository provider for appointments
final appointmentRepositoryProvider = Provider<AppointmentRepository>((ref) {
  return AppointmentRepository(Supabase.instance.client);
});

/// Provider to get the current patient's upcoming appointments
final upcomingAppointmentsProvider = FutureProvider<List<Appointment>>((ref) async {
  final maternalProfileAsync = ref.watch(currentMaternalProfileProvider);
  final repository = ref.read(appointmentRepositoryProvider);
  
  return maternalProfileAsync.when(
    data: (maternalProfile) async {
      if (maternalProfile == null || maternalProfile.id == null) {
        print('📅 No maternal profile found, returning empty appointments');
        return <Appointment>[];
      }
      
      print('📅 Fetching upcoming appointments for: ${maternalProfile.id}');
      try {
        final appointments = await repository.getUpcomingAppointments(maternalProfile.id!);
        print('📅 Found ${appointments.length} upcoming appointments');
        return appointments;
      } catch (e) {
        print('📅 Error: $e');
        return <Appointment>[];
      }
    },
    loading: () async => <Appointment>[],
    error: (_, __) async => <Appointment>[],
  );
});

/// Provider to get the current patient's past appointments
final pastAppointmentsProvider = FutureProvider<List<Appointment>>((ref) async {
  final maternalProfileAsync = ref.watch(currentMaternalProfileProvider);
  final repository = ref.read(appointmentRepositoryProvider);
  
  return maternalProfileAsync.when(
    data: (maternalProfile) async {
      if (maternalProfile == null || maternalProfile.id == null) {
        return <Appointment>[];
      }
      
      print('📅 Fetching past appointments for: ${maternalProfile.id}');
      try {
        final appointments = await repository.getPastAppointments(maternalProfile.id!);
        print('📅 Found ${appointments.length} past appointments');
        return appointments;
      } catch (e) {
        print('📅 Error: $e');
        return <Appointment>[];
      }
    },
    loading: () async => <Appointment>[],
    error: (_, __) async => <Appointment>[],
  );
});

/// Provider to get all appointments for the current patient
final allAppointmentsProvider = FutureProvider<List<Appointment>>((ref) async {
  final maternalProfileAsync = ref.watch(currentMaternalProfileProvider);
  final repository = ref.read(appointmentRepositoryProvider);
  
  return maternalProfileAsync.when(
    data: (maternalProfile) async {
      if (maternalProfile == null || maternalProfile.id == null) {
        return <Appointment>[];
      }
      
      try {
        return await repository.getAppointmentsByPatientId(maternalProfile.id!);
      } catch (e) {
        print('📅 Error: $e');
        return <Appointment>[];
      }
    },
    loading: () async => <Appointment>[],
    error: (_, __) async => <Appointment>[],
  );
});

/// Provider to get the next upcoming appointment (for dashboard)
final nextAppointmentProvider = FutureProvider<Appointment?>((ref) async {
  final appointments = await ref.watch(upcomingAppointmentsProvider.future);
  
  if (appointments.isEmpty) return null;
  
  // Return the first (soonest) upcoming appointment
  return appointments.first;
});
