import 'dart:io';
import 'dart:ui';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz_data;
import 'package:shared_preferences/shared_preferences.dart';

import 'package:supabase_flutter/supabase_flutter.dart';

/// Notification Service for MCH Patient App
/// Handles local notifications for appointments, vaccinations, and reminders
class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FlutterLocalNotificationsPlugin _notifications =
      FlutterLocalNotificationsPlugin();
  bool _isInitialized = false;
  // Use a getter to access Supabase client safely
  // This prevents accessing Supabase.instance before it's initialized
  SupabaseClient get _supabase => Supabase.instance.client;

  /// Notification Channels
  static const String appointmentChannelId = 'mch_appointments';
  static const String appointmentChannelName = 'Appointment Reminders';
  static const String appointmentChannelDesc =
      'Reminders for upcoming appointments';

  static const String vaccinationChannelId = 'mch_vaccinations';
  static const String vaccinationChannelName = 'Vaccination Reminders';
  static const String vaccinationChannelDesc =
      'Reminders for child vaccinations';

  static const String healthTipsChannelId = 'mch_health_tips';
  static const String healthTipsChannelName = 'Health Tips';
  static const String healthTipsChannelDesc =
      'Weekly pregnancy and child health tips';

  /// Initialize the notification service
  Future<void> initialize() async {
    if (_isInitialized) return;

    // Skip notification setup on web (not supported)
    if (kIsWeb) {
      debugPrint('🔔 NotificationService: Skipping on web platform');
      _isInitialized = true;
      return;
    }

    // Initialize timezone
    tz_data.initializeTimeZones();
    tz.setLocalLocation(tz.getLocation('Africa/Nairobi'));

    // Android initialization settings
    const androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    // iOS initialization settings
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _notifications.initialize(
      initSettings,
      onDidReceiveNotificationResponse: _onNotificationTap,
    );

    // Create notification channels for Android
    if (!kIsWeb && Platform.isAndroid) {
      await _createNotificationChannels();
    }

    // Start Realtime Listener
    _listenForRealtimeNotifications();

    _isInitialized = true;
    debugPrint('🔔 NotificationService initialized');
  }

  /// Listen for realtime notifications from Supabase
  void _listenForRealtimeNotifications() {
    final userId = _supabase.auth.currentUser?.id;
    if (userId == null) return;

    _supabase
        .from('notifications')
        .stream(primaryKey: ['id'])
        .eq('user_id', userId)
        .limit(1)
        .listen((List<Map<String, dynamic>> data) {
          // Note: Stream returns the current state of proper rows.
          // However, for pure "new event" notification, .onPostgresChanges is better
          // But .stream is easier to set up for initial load + updates.
          // To capture *new* inserts specifically for alerting:
        });

    // Better approach for ALERTS: Postgres Changes
    _supabase
        .channel('public:notifications:$userId')
        .onPostgresChanges(
            event: PostgresChangeEvent.insert,
            schema: 'public',
            table: 'notifications',
            filter: PostgresChangeFilter(
                type: PostgresChangeFilterType.eq,
                column: 'user_id',
                value: userId),
            callback: (payload) {
              final newRecord = payload.newRecord;
              final title = newRecord['title'] ?? 'New Notification';
              final body = newRecord['body'] ?? 'You have a new update.';
              // Show local notification
              showNotification(
                  id: DateTime.now().millisecondsSinceEpoch ~/ 1000,
                  title: title,
                  body: body,
                  payload: newRecord['type']);
            })
        .subscribe();

    debugPrint('🔔 Listening for realtime notifications for user: $userId');
  }

  /// Create Android notification channels
  Future<void> _createNotificationChannels() async {
    final androidPlugin = _notifications.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();

    if (androidPlugin != null) {
      // Appointment channel
      await androidPlugin.createNotificationChannel(
        const AndroidNotificationChannel(
          appointmentChannelId,
          appointmentChannelName,
          description: appointmentChannelDesc,
          importance: Importance.high,
          playSound: true,
        ),
      );

      // Vaccination channel
      await androidPlugin.createNotificationChannel(
        const AndroidNotificationChannel(
          vaccinationChannelId,
          vaccinationChannelName,
          description: vaccinationChannelDesc,
          importance: Importance.high,
          playSound: true,
        ),
      );

      // Health tips channel
      await androidPlugin.createNotificationChannel(
        const AndroidNotificationChannel(
          healthTipsChannelId,
          healthTipsChannelName,
          description: healthTipsChannelDesc,
          importance: Importance.defaultImportance,
        ),
      );
    }
  }

  /// Callback for notification taps (set by UI layer)
  Function(String?)? onNotificationClick;

  /// Handle notification tap
  void _onNotificationTap(NotificationResponse response) {
    debugPrint('🔔 Notification tapped: ${response.payload}');
    onNotificationClick?.call(response.payload);
  }

  bool _isRequestingPermissions = false;

  /// Request notification permissions (iOS)
  Future<bool> requestPermissions() async {
    // Prevent multiple concurrent permission requests
    if (_isRequestingPermissions) {
      debugPrint('🔔 Permission request already in progress');
      return false;
    }

    _isRequestingPermissions = true;
    try {
      // Skip on web
      if (kIsWeb) return true;

      if (Platform.isIOS) {
        final iosPlugin = _notifications.resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin>();
        final granted = await iosPlugin?.requestPermissions(
          alert: true,
          badge: true,
          sound: true,
        );
        return granted ?? false;
      } else if (Platform.isAndroid) {
        final androidPlugin =
            _notifications.resolvePlatformSpecificImplementation<
                AndroidFlutterLocalNotificationsPlugin>();
        final granted = await androidPlugin?.requestNotificationsPermission();
        return granted ?? false;
      }
      return true;
    } catch (e) {
      debugPrint('🔔 Error requesting permissions: $e');
      return false;
    } finally {
      _isRequestingPermissions = false;
    }
  }

  /// Schedule an appointment reminder
  Future<void> scheduleAppointmentReminder({
    required int id,
    required String title,
    required String body,
    required DateTime appointmentDate,
    Duration reminderBefore = const Duration(hours: 24),
  }) async {
    final scheduledDate = appointmentDate.subtract(reminderBefore);

    if (scheduledDate.isBefore(DateTime.now())) {
      debugPrint('🔔 Skipping past appointment reminder');
      return;
    }

    await _notifications.zonedSchedule(
      id,
      title,
      body,
      tz.TZDateTime.from(scheduledDate, tz.local),
      const NotificationDetails(
        android: AndroidNotificationDetails(
          appointmentChannelId,
          appointmentChannelName,
          channelDescription: appointmentChannelDesc,
          importance: Importance.high,
          priority: Priority.high,
          icon: '@mipmap/ic_launcher',
          color: Color(0xFFE91E63),
        ),
        iOS: DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
        ),
      ),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      payload: 'appointment:$id',
    );

    debugPrint('🔔 Appointment reminder scheduled for $scheduledDate');
  }

  /// Schedule a vaccination reminder
  Future<void> scheduleVaccinationReminder({
    required int id,
    required String childName,
    required String vaccineName,
    required DateTime dueDate,
  }) async {
    // Remind 3 days before and on the day
    final reminderDate = dueDate.subtract(const Duration(days: 3));

    if (reminderDate.isBefore(DateTime.now())) {
      debugPrint('🔔 Skipping past vaccination reminder');
      return;
    }

    await _notifications.zonedSchedule(
      id,
      '💉 Vaccination Due Soon',
      '$childName\'s $vaccineName vaccine is due on ${_formatDate(dueDate)}',
      tz.TZDateTime.from(reminderDate, tz.local),
      const NotificationDetails(
        android: AndroidNotificationDetails(
          vaccinationChannelId,
          vaccinationChannelName,
          channelDescription: vaccinationChannelDesc,
          importance: Importance.high,
          priority: Priority.high,
          icon: '@mipmap/ic_launcher',
          color: Color(0xFF4CAF50),
        ),
        iOS: DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
        ),
      ),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      payload: 'vaccination:$id',
    );

    debugPrint('🔔 Vaccination reminder scheduled for $reminderDate');
  }

  /// Show immediate notification
  Future<void> showNotification({
    required int id,
    required String title,
    required String body,
    String? payload,
    String channelId = appointmentChannelId,
    String channelName = appointmentChannelName,
  }) async {
    await _notifications.show(
      id,
      title,
      body,
      NotificationDetails(
        android: AndroidNotificationDetails(
          channelId,
          channelName,
          importance: Importance.high,
          priority: Priority.high,
          icon: '@mipmap/ic_launcher',
          color: const Color(0xFFE91E63),
        ),
        iOS: const DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
        ),
      ),
      payload: payload,
    );
  }

  /// Schedule weekly pregnancy tip
  Future<void> scheduleWeeklyPregnancyTip({
    required int pregnancyWeek,
  }) async {
    final tips = _getPregnancyTips(pregnancyWeek);
    if (tips.isEmpty) return;

    // Schedule for next Monday at 9 AM
    final now = DateTime.now();
    var nextMonday = now.add(Duration(days: (8 - now.weekday) % 7));
    if (nextMonday.isBefore(now)) {
      nextMonday = nextMonday.add(const Duration(days: 7));
    }
    final scheduledDate =
        DateTime(nextMonday.year, nextMonday.month, nextMonday.day, 9, 0);

    await _notifications.zonedSchedule(
      9999, // Fixed ID for weekly tip
      '🤰 Week $pregnancyWeek Tip',
      tips,
      tz.TZDateTime.from(scheduledDate, tz.local),
      const NotificationDetails(
        android: AndroidNotificationDetails(
          healthTipsChannelId,
          healthTipsChannelName,
          channelDescription: healthTipsChannelDesc,
          importance: Importance.defaultImportance,
          priority: Priority.defaultPriority,
          icon: '@mipmap/ic_launcher',
          color: Color(0xFFE91E63),
        ),
        iOS: DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
        ),
      ),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.dayOfWeekAndTime,
      payload: 'pregnancy_tip',
    );

    debugPrint('🔔 Weekly pregnancy tip scheduled');
  }

  /// Cancel a specific notification
  Future<void> cancelNotification(int id) async {
    await _notifications.cancel(id);
  }

  /// Cancel all notifications
  Future<void> cancelAllNotifications() async {
    await _notifications.cancelAll();
    debugPrint('🔔 All notifications cancelled');
  }

  /// Get pending notifications
  Future<List<PendingNotificationRequest>> getPendingNotifications() async {
    return await _notifications.pendingNotificationRequests();
  }

  /// Format date for display
  String _formatDate(DateTime date) {
    final months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec'
    ];
    return '${date.day} ${months[date.month - 1]}';
  }

  /// Get pregnancy tips based on week
  String _getPregnancyTips(int week) {
    if (week <= 12) {
      return 'First trimester is crucial! Take your folic acid supplements daily and stay hydrated.';
    } else if (week <= 24) {
      return 'Second trimester energy boost! This is a great time for gentle exercise and healthy eating.';
    } else if (week <= 36) {
      return 'Third trimester is here! Start preparing your hospital bag and birth plan.';
    } else {
      return 'Baby is almost here! Rest well and watch for signs of labor. Call your healthcare provider if concerned.';
    }
  }
}

/// Riverpod provider for notification service
final notificationServiceProvider = Provider<NotificationService>((ref) {
  return NotificationService();
});

/// Provider to check if notifications are enabled
final notificationsEnabledProvider = FutureProvider<bool>((ref) async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getBool('notifications_enabled') ?? true;
});
