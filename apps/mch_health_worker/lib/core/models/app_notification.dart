import 'package:flutter/material.dart';

/// Notification type for in-app notifications
enum NotificationType {
  appointment, // Upcoming appointments
  dueSoon,     // Patients due soon
  highRisk,    // High risk patient alerts
  sync,        // Sync status notifications
  system,      // System messages
}

/// In-app notification model
class AppNotification {
  final String id;
  final String title;
  final String message;
  final NotificationType type;
  final DateTime createdAt;
  final bool isRead;
  final String? patientId;
  final String? actionRoute;

  const AppNotification({
    required this.id,
    required this.title,
    required this.message,
    required this.type,
    required this.createdAt,
    this.isRead = false,
    this.patientId,
    this.actionRoute,
  });

  AppNotification copyWith({
    String? id,
    String? title,
    String? message,
    NotificationType? type,
    DateTime? createdAt,
    bool? isRead,
    String? patientId,
    String? actionRoute,
  }) {
    return AppNotification(
      id: id ?? this.id,
      title: title ?? this.title,
      message: message ?? this.message,
      type: type ?? this.type,
      createdAt: createdAt ?? this.createdAt,
      isRead: isRead ?? this.isRead,
      patientId: patientId ?? this.patientId,
      actionRoute: actionRoute ?? this.actionRoute,
    );
  }

  IconData get icon {
    switch (type) {
      case NotificationType.appointment:
        return Icons.calendar_today;
      case NotificationType.dueSoon:
        return Icons.pregnant_woman;
      case NotificationType.highRisk:
        return Icons.warning;
      case NotificationType.sync:
        return Icons.sync;
      case NotificationType.system:
        return Icons.info;
    }
  }

  Color get iconColor {
    switch (type) {
      case NotificationType.appointment:
        return Colors.blue;
      case NotificationType.dueSoon:
        return Colors.orange;
      case NotificationType.highRisk:
        return Colors.red;
      case NotificationType.sync:
        return Colors.green;
      case NotificationType.system:
        return Colors.grey;
    }
  }
}
