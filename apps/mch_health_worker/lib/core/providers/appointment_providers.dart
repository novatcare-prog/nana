import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mch_core/mch_core.dart';
import 'package:mch_core/src/data/repositories/appointment_repository.dart';
import '../repositories/offline_appointment_repository.dart';
import 'supabase_providers.dart';

// ============================================
// REPOSITORY PROVIDERS
// ============================================

/// Original Supabase repository (for reference)
final appointmentRepositoryProvider = Provider<AppointmentRepository>((ref) {
  final supabase = ref.watch(supabaseClientProvider);
  return AppointmentRepository(supabase);
});

/// ✅ NEW: Offline-first repository (use this one!)
/// This is already defined in offline_appointment_repository.dart
/// We're just re-exporting it here for convenience
// final offlineAppointmentRepositoryProvider is in offline_appointment_repository.dart

// ============================================
// DATA PROVIDERS (UPDATED for offline support)
// ============================================

/// Get all appointments (offline-first)
final allAppointmentsProvider = FutureProvider<List<Appointment>>((ref) async {
  final repository = ref.watch(offlineAppointmentRepositoryProvider);
  return repository.getAll();
});

/// Get appointments for a specific patient
final patientAppointmentsProvider = 
    FutureProvider.family<List<Appointment>, String>((ref, patientId) async {
  final repository = ref.watch(offlineAppointmentRepositoryProvider);
  final allAppointments = await repository.getAll();
  return allAppointments.where((a) => a.maternalProfileId == patientId).toList();
});

/// Get upcoming appointments
final upcomingAppointmentsProvider = FutureProvider<List<Appointment>>((ref) async {
  final repository = ref.watch(offlineAppointmentRepositoryProvider);
  final allAppointments = await repository.getAll();
  final now = DateTime.now();
  return allAppointments
      .where((a) => a.appointmentDate.isAfter(now))
      .toList()
    ..sort((a, b) => a.appointmentDate.compareTo(b.appointmentDate));
});

/// Get today's appointments
final todayAppointmentsProvider = FutureProvider<List<Appointment>>((ref) async {
  final repository = ref.watch(offlineAppointmentRepositoryProvider);
  final today = DateTime.now();
  return repository.getForMonth(today);
});

/// Get this week's appointments
final weekAppointmentsProvider = FutureProvider<List<Appointment>>((ref) async {
  final repository = ref.watch(offlineAppointmentRepositoryProvider);
  final now = DateTime.now();
  final startOfWeek = now.subtract(Duration(days: now.weekday - 1));
  final endOfWeek = startOfWeek.add(const Duration(days: 6));
  
  final allAppointments = await repository.getAll();
  return allAppointments.where((a) {
    return a.appointmentDate.isAfter(startOfWeek) &&
        a.appointmentDate.isBefore(endOfWeek.add(const Duration(days: 1)));
  }).toList();
});

/// Get this month's appointments (offline-first)
final monthAppointmentsProvider = 
    FutureProvider.family<List<Appointment>, DateTime?>((ref, date) async {
  final repository = ref.watch(offlineAppointmentRepositoryProvider);
  final targetDate = date ?? DateTime.now();
  return repository.getForMonth(targetDate);
});

/// Get appointments by date range
final appointmentsByDateRangeProvider = 
    FutureProvider.family<List<Appointment>, DateRange>((ref, dateRange) async {
  final repository = ref.watch(offlineAppointmentRepositoryProvider);
  final allAppointments = await repository.getAll();
  return allAppointments.where((a) {
    return a.appointmentDate.isAfter(dateRange.startDate) &&
        a.appointmentDate.isBefore(dateRange.endDate);
  }).toList();
});

/// Get appointment statistics
final appointmentStatisticsProvider = 
    FutureProvider<Map<String, int>>((ref) async {
  final repository = ref.watch(offlineAppointmentRepositoryProvider);
  final allAppointments = await repository.getAll();
  
  final stats = <String, int>{
    'total': allAppointments.length,
    'scheduled': allAppointments.where((a) => a.appointmentStatus == AppointmentStatus.scheduled).length,
    'completed': allAppointments.where((a) => a.appointmentStatus == AppointmentStatus.completed).length,
    'cancelled': allAppointments.where((a) => a.appointmentStatus == AppointmentStatus.cancelled).length,
    'missed': allAppointments.where((a) => a.appointmentStatus == AppointmentStatus.missed).length,
  };
  
  return stats;
});

// ============================================
// MUTATION PROVIDERS (UPDATED for offline support)
// ============================================

/// Create appointment (offline-capable)
final createAppointmentProvider = 
    Provider<Future<Appointment> Function(Appointment)>((ref) {
  final repository = ref.watch(offlineAppointmentRepositoryProvider);
  return (appointment) async {
    final result = await repository.create(appointment);
    
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

/// Update appointment (offline-capable)
final updateAppointmentProvider = 
    Provider<Future<Appointment> Function(Appointment)>((ref) {
  final repository = ref.watch(offlineAppointmentRepositoryProvider);
  return (appointment) async {
    final result = await repository.update(appointment);
    
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

/// Update appointment status (offline-capable)
final updateAppointmentStatusProvider = 
    Provider<Future<void> Function(String, AppointmentStatus)>((ref) {
  final repository = ref.watch(offlineAppointmentRepositoryProvider);
  return (appointmentId, status) async {
    await repository.updateStatus(appointmentId, status);
    
    // Invalidate all appointment lists
    ref.invalidate(allAppointmentsProvider);
    ref.invalidate(upcomingAppointmentsProvider);
    ref.invalidate(todayAppointmentsProvider);
    ref.invalidate(weekAppointmentsProvider);
    ref.invalidate(monthAppointmentsProvider);
    ref.invalidate(appointmentStatisticsProvider);
  };
});

/// Cancel appointment (offline-capable)
final cancelAppointmentProvider = 
    Provider<Future<void> Function(String)>((ref) {
  final repository = ref.watch(offlineAppointmentRepositoryProvider);
  return (appointmentId) async {
    await repository.updateStatus(appointmentId, AppointmentStatus.cancelled);
    
    // Invalidate all appointment lists
    ref.invalidate(allAppointmentsProvider);
    ref.invalidate(upcomingAppointmentsProvider);
    ref.invalidate(todayAppointmentsProvider);
    ref.invalidate(weekAppointmentsProvider);
    ref.invalidate(monthAppointmentsProvider);
    ref.invalidate(appointmentStatisticsProvider);
  };
});

/// Delete appointment (offline-capable)
final deleteAppointmentProvider = 
    Provider<Future<void> Function(String)>((ref) {
  final repository = ref.watch(offlineAppointmentRepositoryProvider);
  return (appointmentId) async {
    await repository.delete(appointmentId);
    
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