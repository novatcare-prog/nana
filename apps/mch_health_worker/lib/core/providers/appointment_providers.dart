import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mch_core/mch_core.dart';
import 'package:mch_core/src/data/repositories/appointment_repository.dart';
import 'supabase_providers.dart';

// ============================================
// REPOSITORY PROVIDER
// ============================================

final appointmentRepositoryProvider = Provider<AppointmentRepository>((ref) {
  final supabase = ref.watch(supabaseClientProvider);
  return AppointmentRepository(supabase);
});

// ============================================
// DATA PROVIDERS
// ============================================

/// Get all appointments
final allAppointmentsProvider = FutureProvider<List<Appointment>>((ref) async {
  final repository = ref.watch(appointmentRepositoryProvider);
  return repository.getAllAppointments();
});

/// Get appointments for a specific patient
final patientAppointmentsProvider = 
    FutureProvider.family<List<Appointment>, String>((ref, patientId) async {
  final repository = ref.watch(appointmentRepositoryProvider);
  return repository.getAppointmentsByPatientId(patientId);
});

/// Get upcoming appointments
final upcomingAppointmentsProvider = FutureProvider<List<Appointment>>((ref) async {
  final repository = ref.watch(appointmentRepositoryProvider);
  return repository.getUpcomingAppointments();
});

/// Get today's appointments
final todayAppointmentsProvider = FutureProvider<List<Appointment>>((ref) async {
  final repository = ref.watch(appointmentRepositoryProvider);
  return repository.getTodayAppointments();
});

/// Get this week's appointments
final weekAppointmentsProvider = FutureProvider<List<Appointment>>((ref) async {
  final repository = ref.watch(appointmentRepositoryProvider);
  return repository.getWeekAppointments();
});

/// Get this month's appointments
final monthAppointmentsProvider = 
    FutureProvider.family<List<Appointment>, DateTime?>((ref, date) async {
  final repository = ref.watch(appointmentRepositoryProvider);
  return repository.getMonthAppointments(date);
});

/// Get appointments by date range
final appointmentsByDateRangeProvider = 
    FutureProvider.family<List<Appointment>, DateRange>((ref, dateRange) async {
  final repository = ref.watch(appointmentRepositoryProvider);
  return repository.getAppointmentsByDateRange(
    dateRange.startDate,
    dateRange.endDate,
  );
});

/// Get appointment statistics
final appointmentStatisticsProvider = 
    FutureProvider<Map<String, int>>((ref) async {
  final repository = ref.watch(appointmentRepositoryProvider);
  return repository.getAppointmentStatistics();
});

// ============================================
// MUTATION PROVIDERS
// ============================================

/// Create appointment
final createAppointmentProvider = 
    Provider<Future<Appointment> Function(Appointment)>((ref) {
  final repository = ref.watch(appointmentRepositoryProvider);
  return (appointment) async {
    final result = await repository.createAppointment(appointment);
    
    // Invalidate all appointment lists
    ref.invalidate(allAppointmentsProvider);
    ref.invalidate(upcomingAppointmentsProvider);
    ref.invalidate(todayAppointmentsProvider);
    ref.invalidate(weekAppointmentsProvider);
    ref.invalidate(monthAppointmentsProvider);
    ref.invalidate(appointmentStatisticsProvider);
    ref.invalidate(patientAppointmentsProvider(appointment.maternalProfileId));
    
    return result;
  };
});

/// Update appointment
final updateAppointmentProvider = 
    Provider<Future<Appointment> Function(Appointment)>((ref) {
  final repository = ref.watch(appointmentRepositoryProvider);
  return (appointment) async {
    final result = await repository.updateAppointment(appointment);
    
    // Invalidate all appointment lists
    ref.invalidate(allAppointmentsProvider);
    ref.invalidate(upcomingAppointmentsProvider);
    ref.invalidate(todayAppointmentsProvider);
    ref.invalidate(weekAppointmentsProvider);
    ref.invalidate(monthAppointmentsProvider);
    ref.invalidate(appointmentStatisticsProvider);
    ref.invalidate(patientAppointmentsProvider(appointment.maternalProfileId));
    
    return result;
  };
});

/// Update appointment status
final updateAppointmentStatusProvider = 
    Provider<Future<void> Function(String, AppointmentStatus)>((ref) {
  final repository = ref.watch(appointmentRepositoryProvider);
  return (appointmentId, status) async {
    await repository.updateAppointmentStatus(appointmentId, status);
    
    // Invalidate all appointment lists
    ref.invalidate(allAppointmentsProvider);
    ref.invalidate(upcomingAppointmentsProvider);
    ref.invalidate(todayAppointmentsProvider);
    ref.invalidate(weekAppointmentsProvider);
    ref.invalidate(monthAppointmentsProvider);
    ref.invalidate(appointmentStatisticsProvider);
  };
});

/// Cancel appointment
final cancelAppointmentProvider = 
    Provider<Future<void> Function(String)>((ref) {
  final repository = ref.watch(appointmentRepositoryProvider);
  return (appointmentId) async {
    await repository.cancelAppointment(appointmentId);
    
    // Invalidate all appointment lists
    ref.invalidate(allAppointmentsProvider);
    ref.invalidate(upcomingAppointmentsProvider);
    ref.invalidate(todayAppointmentsProvider);
    ref.invalidate(weekAppointmentsProvider);
    ref.invalidate(monthAppointmentsProvider);
    ref.invalidate(appointmentStatisticsProvider);
  };
});

/// Delete appointment
final deleteAppointmentProvider = 
    Provider<Future<void> Function(String)>((ref) {
  final repository = ref.watch(appointmentRepositoryProvider);
  return (appointmentId) async {
    await repository.deleteAppointment(appointmentId);
    
    // Invalidate all appointment lists
    ref.invalidate(allAppointmentsProvider);
    ref.invalidate(upcomingAppointmentsProvider);
    ref.invalidate(todayAppointmentsProvider);
    ref.invalidate(weekAppointmentsProvider);
    ref.invalidate(monthAppointmentsProvider);
    ref.invalidate(appointmentStatisticsProvider);
  };
});

// ============================================
// HELPER CLASSES
// ============================================

/// Date range helper class
class DateRange {
  final DateTime startDate;
  final DateTime endDate;

  DateRange({
    required this.startDate,
    required this.endDate,
  });
}