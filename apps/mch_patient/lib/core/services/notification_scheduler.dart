import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mch_core/mch_core.dart';
import '../services/notification_service.dart';
import '../providers/appointment_provider.dart';
import '../providers/child_provider.dart';
import '../providers/immunization_provider.dart';
import '../providers/maternal_profile_provider.dart';
import '../providers/settings_provider.dart';

/// Notification Scheduler
/// Schedules notifications based on user's appointments, vaccinations, and pregnancy status
class NotificationScheduler {
  final Ref _ref;
  final NotificationService _notificationService;

  NotificationScheduler(this._ref, this._notificationService);

  /// Schedule all relevant notifications for the user
  Future<void> scheduleAllNotifications() async {
    debugPrint('📅 Scheduling notifications...');

    // Check if notifications are enabled
    final settings = _ref.read(notificationSettingsProvider);
    if (!settings.enabled) {
      debugPrint('🔕 Notifications are disabled');
      await _notificationService.cancelAllNotifications();
      return;
    }

    // Request permissions first
    final hasPermission = await _notificationService.requestPermissions();
    if (!hasPermission) {
      debugPrint('🔕 Notification permission denied');
      return;
    }

    // Cancel existing notifications before rescheduling
    await _notificationService.cancelAllNotifications();

    // Schedule appointment reminders
    if (settings.appointmentReminders) {
      await _scheduleAppointmentReminders();
    }

    // Schedule vaccination reminders
    if (settings.vaccinationAlerts) {
      await _scheduleVaccinationReminders();
    }

    // Schedule pregnancy tips
    if (settings.healthTips) {
      await _schedulePregnancyTips();
    }

    debugPrint('✅ Notifications scheduled successfully');
  }

  /// Schedule appointment reminders
  Future<void> _scheduleAppointmentReminders() async {
    try {
      final appointmentsAsync = await _ref.read(upcomingAppointmentsProvider.future);
      
      int notificationId = 1000;
      for (final appointment in appointmentsAsync) {
        // Schedule 24-hour reminder
        await _notificationService.scheduleAppointmentReminder(
          id: notificationId++,
          title: '📅 Appointment Tomorrow',
          body: '${_getAppointmentTypeLabel(appointment.appointmentType)} at ${_formatTime(appointment.appointmentDate)}',
          appointmentDate: appointment.appointmentDate,
          reminderBefore: const Duration(hours: 24),
        );

        // Schedule 2-hour reminder
        await _notificationService.scheduleAppointmentReminder(
          id: notificationId++,
          title: '⏰ Appointment in 2 hours',
          body: '${_getAppointmentTypeLabel(appointment.appointmentType)} - Don\'t forget to bring your MCH booklet!',
          appointmentDate: appointment.appointmentDate,
          reminderBefore: const Duration(hours: 2),
        );
      }
      
      debugPrint('📅 Scheduled ${appointmentsAsync.length * 2} appointment reminders');
    } catch (e) {
      debugPrint('❌ Error scheduling appointment reminders: $e');
    }
  }

  /// Schedule vaccination reminders
  Future<void> _scheduleVaccinationReminders() async {
    try {
      final childrenAsync = await _ref.read(patientChildrenProvider.future);
      
      int notificationId = 2000;
      for (final child in childrenAsync) {
        // Get immunization data for this child
        final immunizations = await _ref.read(childImmunizationsProvider(child.id!).future);
        // Note: We don't need getChildVaccinationStatus for scheduling
        // Just iterate through the schedule directly

        // Find overdue and upcoming vaccines
        for (final milestone in KenyaEPISchedule.schedule) {
          for (final vaccine in milestone.vaccines) {
            // Check if vaccine is already given
            final isGiven = immunizations.any(
              (r) => r.vaccineType == vaccine.type && r.doseNumber == vaccine.dose,
            );
            if (isGiven) continue;

            // Calculate due date
            final dueDate = child.dateOfBirth.add(
              Duration(days: (milestone.ageInWeeks * 7).round()),
            );

            // Only schedule for vaccines due in the future or within the last week
            if (dueDate.isAfter(DateTime.now().subtract(const Duration(days: 7)))) {
              await _notificationService.scheduleVaccinationReminder(
                id: notificationId++,
                childName: child.childName,
                vaccineName: vaccine.type.label,
                dueDate: dueDate,
              );
            }
          }
        }
      }
      
      debugPrint('💉 Vaccination reminders scheduled');
    } catch (e) {
      debugPrint('❌ Error scheduling vaccination reminders: $e');
    }
  }

  /// Schedule pregnancy tips
  Future<void> _schedulePregnancyTips() async {
    try {
      final pregnancyWeek = _ref.read(pregnancyWeekProvider);
      if (pregnancyWeek != null && pregnancyWeek > 0) {
        await _notificationService.scheduleWeeklyPregnancyTip(
          pregnancyWeek: pregnancyWeek,
        );
        debugPrint('🤰 Pregnancy tip scheduled for week $pregnancyWeek');
      }
    } catch (e) {
      debugPrint('❌ Error scheduling pregnancy tips: $e');
    }
  }

  /// Get appointment type label
  String _getAppointmentTypeLabel(AppointmentType type) {
    switch (type) {
      case AppointmentType.ancVisit:
        return 'ANC Visit';
      case AppointmentType.pncVisit:
        return 'PNC Visit';
      case AppointmentType.immunization:
        return 'Immunization';
      case AppointmentType.labTest:
        return 'Lab Test';
      case AppointmentType.ultrasound:
        return 'Ultrasound';
      case AppointmentType.consultation:
        return 'Consultation';
      case AppointmentType.followUp:
        return 'Follow-up Visit';
      case AppointmentType.delivery:
        return 'Delivery';
    }
  }

  /// Format time for display
  String _formatTime(DateTime date) {
    final hour = date.hour;
    final minute = date.minute.toString().padLeft(2, '0');
    final period = hour >= 12 ? 'PM' : 'AM';
    final displayHour = hour > 12 ? hour - 12 : (hour == 0 ? 12 : hour);
    return '$displayHour:$minute $period';
  }
}

/// Provider for notification scheduler
final notificationSchedulerProvider = Provider<NotificationScheduler>((ref) {
  final notificationService = ref.read(notificationServiceProvider);
  return NotificationScheduler(ref, notificationService);
});

/// Provider that triggers notification scheduling when called
final scheduleNotificationsProvider = FutureProvider<void>((ref) async {
  final scheduler = ref.read(notificationSchedulerProvider);
  await scheduler.scheduleAllNotifications();
});
