import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:mch_core/mch_core.dart';

/// Appointment Repository using Supabase
class AppointmentRepository {
  final SupabaseClient _supabase;

  AppointmentRepository(this._supabase);

  /// Create a new appointment
  Future<Appointment> createAppointment(Appointment appointment) async {
  try {
    final json = appointment.toJson();
    json.remove('id'); // Let database generate the ID
    
    final response = await _supabase
        .from('appointments')
        .insert(json)
        .select()
        .single();

    return Appointment.fromJson(response);
  } catch (e) {
    throw Exception('Failed to create appointment: $e');
  }
}

  /// Get all appointments
  Future<List<Appointment>> getAllAppointments() async {
    try {
      final response = await _supabase
          .from('appointments')
          .select()
          .order('appointment_date', ascending: true);

      return (response as List)
          .map((json) => Appointment.fromJson(json))
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch appointments: $e');
    }
  }

  /// Get appointments for a specific patient
  Future<List<Appointment>> getAppointmentsByPatientId(String patientId) async {
    try {
      final response = await _supabase
          .from('appointments')
          .select()
          .eq('maternal_profile_id', patientId)
          .order('appointment_date', ascending: true);

      return (response as List)
          .map((json) => Appointment.fromJson(json))
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch patient appointments: $e');
    }
  }

  /// Get upcoming appointments (future dates only)
  Future<List<Appointment>> getUpcomingAppointments() async {
    try {
      final now = DateTime.now();
      final startOfToday = DateTime(now.year, now.month, now.day).toIso8601String();
      
      final response = await _supabase
          .from('appointments')
          .select()
          .gte('appointment_date', startOfToday)
          .inFilter('appointment_status', ['scheduled', 'confirmed'])
          .order('appointment_date', ascending: true);

      return (response as List)
          .map((json) => Appointment.fromJson(json))
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch upcoming appointments: $e');
    }
  }

  /// Get appointments for today
  Future<List<Appointment>> getTodayAppointments() async {
    try {
      final today = DateTime.now();
      final startOfDay = DateTime(today.year, today.month, today.day);
      final endOfDay = startOfDay.add(const Duration(days: 1));

      final response = await _supabase
          .from('appointments')
          .select()
          .gte('appointment_date', startOfDay.toIso8601String())
          .lt('appointment_date', endOfDay.toIso8601String())
          .order('appointment_date', ascending: true);

      return (response as List)
          .map((json) => Appointment.fromJson(json))
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch today appointments: $e');
    }
  }

  /// Get appointments for a specific date range
  Future<List<Appointment>> getAppointmentsByDateRange(
    DateTime startDate,
    DateTime endDate,
  ) async {
    try {
      final response = await _supabase
          .from('appointments')
          .select()
          .gte('appointment_date', startDate.toIso8601String())
          .lte('appointment_date', endDate.toIso8601String())
          .order('appointment_date', ascending: true);

      return (response as List)
          .map((json) => Appointment.fromJson(json))
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch appointments by date range: $e');
    }
  }

  /// Get appointments for current week
  Future<List<Appointment>> getWeekAppointments() async {
    try {
      final now = DateTime.now();
      final startOfWeek = now.subtract(Duration(days: now.weekday - 1));
      final startOfWeekMidnight = DateTime(
        startOfWeek.year,
        startOfWeek.month,
        startOfWeek.day,
      );
      final endOfWeek = startOfWeekMidnight.add(const Duration(days: 7));

      return getAppointmentsByDateRange(startOfWeekMidnight, endOfWeek);
    } catch (e) {
      throw Exception('Failed to fetch week appointments: $e');
    }
  }

  /// Get appointments for current month
  Future<List<Appointment>> getMonthAppointments([DateTime? date]) async {
    try {
      final targetDate = date ?? DateTime.now();
      final startOfMonth = DateTime(targetDate.year, targetDate.month, 1);
      final endOfMonth = DateTime(targetDate.year, targetDate.month + 1, 0, 23, 59, 59);

      return getAppointmentsByDateRange(startOfMonth, endOfMonth);
    } catch (e) {
      throw Exception('Failed to fetch month appointments: $e');
    }
  }

  /// Update an appointment
  Future<Appointment> updateAppointment(Appointment appointment) async {
  try {
    if (appointment.id == null) {
      throw Exception('Appointment ID is required for update');
    }
    
    final response = await _supabase
        .from('appointments')
        .update(appointment.toJson())
        .eq('id', appointment.id!)
        .select()
        .single();

    return Appointment.fromJson(response);
  } catch (e) {
    throw Exception('Failed to update appointment: $e');
  }
}

  /// Update appointment status
  Future<void> updateAppointmentStatus(
    String appointmentId,
    AppointmentStatus status,
  ) async {
    try {
      await _supabase
          .from('appointments')
          .update({'appointment_status': status.name})
          .eq('id', appointmentId);
    } catch (e) {
      throw Exception('Failed to update appointment status: $e');
    }
  }

  /// Mark appointment as completed
  Future<void> markAsCompleted(String appointmentId) async {
    await updateAppointmentStatus(appointmentId, AppointmentStatus.completed);
  }

  /// Cancel an appointment
  Future<void> cancelAppointment(String appointmentId) async {
    await updateAppointmentStatus(appointmentId, AppointmentStatus.cancelled);
  }

  /// Delete an appointment
  Future<void> deleteAppointment(String id) async {
    try {
      await _supabase.from('appointments').delete().eq('id', id);
    } catch (e) {
      throw Exception('Failed to delete appointment: $e');
    }
  }

  /// Get appointment statistics
  Future<Map<String, int>> getAppointmentStatistics() async {
    try {
      final allAppointments = await getAllAppointments();
      final now = DateTime.now();
      
      final today = allAppointments.where((a) {
        final appointmentDate = a.appointmentDate;
        return appointmentDate.year == now.year &&
            appointmentDate.month == now.month &&
            appointmentDate.day == now.day;
      }).length;

      final upcoming = allAppointments.where((a) {
        return a.appointmentDate.isAfter(now) &&
            (a.appointmentStatus == AppointmentStatus.scheduled ||
                a.appointmentStatus == AppointmentStatus.confirmed);
      }).length;

      final missed = allAppointments.where((a) {
        return a.appointmentStatus == AppointmentStatus.missed;
      }).length;

      return {
        'total': allAppointments.length,
        'today': today,
        'upcoming': upcoming,
        'missed': missed,
      };
    } catch (e) {
      throw Exception('Failed to fetch appointment statistics: $e');
    }
  }
}