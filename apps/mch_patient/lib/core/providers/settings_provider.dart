import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Theme Mode Provider for Patient App
class ThemeModeNotifier extends StateNotifier<ThemeMode> {
  ThemeModeNotifier() : super(ThemeMode.system) {
    _loadThemeMode();
  }

  static const String _themeModeKey = 'patient_theme_mode';

  Future<void> _loadThemeMode() async {
    final prefs = await SharedPreferences.getInstance();
    final themeModeString = prefs.getString(_themeModeKey);
    
    if (themeModeString != null) {
      switch (themeModeString) {
        case 'light':
          state = ThemeMode.light;
          break;
        case 'dark':
          state = ThemeMode.dark;
          break;
        case 'system':
          state = ThemeMode.system;
          break;
      }
    }
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    state = mode;
    
    final prefs = await SharedPreferences.getInstance();
    String modeString;
    
    switch (mode) {
      case ThemeMode.light:
        modeString = 'light';
        break;
      case ThemeMode.dark:
        modeString = 'dark';
        break;
      case ThemeMode.system:
        modeString = 'system';
        break;
    }
    
    await prefs.setString(_themeModeKey, modeString);
  }
}

/// Theme Mode Provider
final themeModeProvider = StateNotifierProvider<ThemeModeNotifier, ThemeMode>(
  (ref) => ThemeModeNotifier(),
);

/// Notification Settings Provider
class NotificationSettingsNotifier extends StateNotifier<NotificationSettings> {
  NotificationSettingsNotifier() : super(const NotificationSettings()) {
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    state = NotificationSettings(
      enabled: prefs.getBool('notifications_enabled') ?? true,
      appointmentReminders: prefs.getBool('appointment_reminders') ?? true,
      vaccineReminders: prefs.getBool('vaccine_reminders') ?? true,
      visitReminders: prefs.getBool('visit_reminders') ?? true,
    );
  }

  Future<void> setEnabled(bool value) async {
    state = state.copyWith(enabled: value);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('notifications_enabled', value);
  }

  Future<void> setAppointmentReminders(bool value) async {
    state = state.copyWith(appointmentReminders: value);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('appointment_reminders', value);
  }

  Future<void> setVaccineReminders(bool value) async {
    state = state.copyWith(vaccineReminders: value);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('vaccine_reminders', value);
  }

  Future<void> setVisitReminders(bool value) async {
    state = state.copyWith(visitReminders: value);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('visit_reminders', value);
  }
}

/// Notification Settings Model
class NotificationSettings {
  final bool enabled;
  final bool appointmentReminders;
  final bool vaccineReminders;
  final bool visitReminders;
  final bool healthTips;

  const NotificationSettings({
    this.enabled = true,
    this.appointmentReminders = true,
    this.vaccineReminders = true,
    this.visitReminders = true,
    this.healthTips = true,
  });

  // Alias for scheduler
  bool get vaccinationAlerts => vaccineReminders;

  NotificationSettings copyWith({
    bool? enabled,
    bool? appointmentReminders,
    bool? vaccineReminders,
    bool? visitReminders,
    bool? healthTips,
  }) {
    return NotificationSettings(
      enabled: enabled ?? this.enabled,
      appointmentReminders: appointmentReminders ?? this.appointmentReminders,
      vaccineReminders: vaccineReminders ?? this.vaccineReminders,
      visitReminders: visitReminders ?? this.visitReminders,
      healthTips: healthTips ?? this.healthTips,
    );
  }
}

final notificationSettingsProvider = 
    StateNotifierProvider<NotificationSettingsNotifier, NotificationSettings>(
  (ref) => NotificationSettingsNotifier(),
);

/// App Theme Definitions for Patient App
class PatientAppTheme {
  // Primary color (Pink for maternal health)
  static const Color primaryColor = Color(0xFFE91E63);
  
  // Light Theme
  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    colorScheme: ColorScheme.fromSeed(
      seedColor: primaryColor,
      brightness: Brightness.light,
    ),
    appBarTheme: const AppBarTheme(
      centerTitle: false,
      elevation: 0,
    ),
    cardTheme: CardThemeData(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      filled: true,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    ),
  );
  
  // Dark Theme
  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    colorScheme: ColorScheme.fromSeed(
      seedColor: primaryColor,
      brightness: Brightness.dark,
    ),
    appBarTheme: const AppBarTheme(
      centerTitle: false,
      elevation: 0,
    ),
    cardTheme: CardThemeData(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      filled: true,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    ),
    scaffoldBackgroundColor: const Color(0xFF121212),
  );
}
