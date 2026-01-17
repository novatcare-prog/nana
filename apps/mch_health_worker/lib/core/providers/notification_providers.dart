import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mch_core/mch_core.dart';
import '../models/app_notification.dart';
import 'supabase_providers.dart';

/// Provider for in-app notifications
/// Generates notifications based on patient data
final notificationsProvider = FutureProvider<List<AppNotification>>((ref) async {
  final profilesAsync = await ref.watch(maternalProfilesProvider.future);
  final notifications = <AppNotification>[];
  final now = DateTime.now();
  
  // Generate notifications based on patient data
  for (final patient in profilesAsync) {
    // High Risk Alert
    if (_isHighRisk(patient)) {
      notifications.add(AppNotification(
        id: 'hr_${patient.id}',
        title: 'High Risk Patient',
        message: '${patient.clientName} requires close monitoring',
        type: NotificationType.highRisk,
        createdAt: now,
        patientId: patient.id,
      ));
    }
    
    // Due Soon Alert (within 7 days)
    if (patient.edd != null) {
      final daysUntilDue = patient.edd!.difference(now).inDays;
      if (daysUntilDue >= 0 && daysUntilDue <= 7) {
        notifications.add(AppNotification(
          id: 'due_${patient.id}',
          title: 'Delivery Due Soon',
          message: '${patient.clientName} is due in $daysUntilDue day${daysUntilDue == 1 ? '' : 's'}',
          type: NotificationType.dueSoon,
          createdAt: now,
          patientId: patient.id,
        ));
      }
    }
  }
  
  // Sort by creation time (newest first)
  notifications.sort((a, b) => b.createdAt.compareTo(a.createdAt));
  
  return notifications;
});

/// Provider for unread notification count
final unreadNotificationCountProvider = Provider<int>((ref) {
  final notificationsAsync = ref.watch(notificationsProvider);
  return notificationsAsync.when(
    data: (notifications) => notifications.where((n) => !n.isRead).length,
    loading: () => 0,
    error: (_, __) => 0,
  );
});

/// Check if patient is high risk
bool _isHighRisk(MaternalProfile patient) {
  return patient.diabetes == true ||
      patient.hypertension == true ||
      patient.previousCs == true ||
      patient.age > 35 ||
      patient.age < 18;
}
