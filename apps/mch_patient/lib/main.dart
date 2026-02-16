import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'app.dart';
import 'core/services/notification_service.dart';

/// Main entry point
/// Initialize all services before showing UI
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();

  // Initialize app services silently
  await _initializeServices();

  runApp(
    EasyLocalization(
      supportedLocales: const [Locale('en'), Locale('sw')],
      path: 'assets/translations',
      fallbackLocale: const Locale('en'),
      child: const ProviderScope(
        child: MCHPatientApp(),
      ),
    ),
  );
}

/// Initialize all app services
Future<void> _initializeServices() async {
  try {
    // Load environment variables
    String url = const String.fromEnvironment('SUPABASE_URL');
    String key = const String.fromEnvironment('SUPABASE_ANON_KEY');

    if (url.isEmpty || key.isEmpty) {
      try {
        await dotenv.load(fileName: ".env");
        url = dotenv.env['SUPABASE_URL'] ?? '';
        key = dotenv.env['SUPABASE_ANON_KEY'] ?? '';
      } catch (e) {
        debugPrint('Failed to load .env: $e');
      }
    }

    // Initialize Hive for offline storage
    await Hive.initFlutter();

    // Initialize Supabase (skip if offline - will retry later)
    if (url.isNotEmpty && key.isNotEmpty) {
      try {
        await Supabase.initialize(
          url: url,
          anonKey: key,
        );
        debugPrint('✅ Supabase initialized');
      } catch (e) {
        debugPrint('⚠️  Supabase initialization failed (offline): $e');
        // Continue anyway - app will work offline
      }
    }

    // Initialize Notifications
    try {
      await NotificationService().initialize();
      debugPrint('✅ Notifications initialized');
    } catch (e) {
      debugPrint('⚠️  Notifications initialization failed: $e');
    }

    debugPrint('✅ App initialization complete');
  } catch (e) {
    debugPrint('❌ App initialization error: $e');
    // Continue anyway - app should still launch
  }
}
