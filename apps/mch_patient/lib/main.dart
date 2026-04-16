import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:mch_core/mch_core.dart';
import 'app.dart';
import 'core/services/app_initializer.dart';
import 'features/ai/providers/chatbot_provider.dart';

final _geminiService = GeminiService();

/// Main entry point
/// Initializes ALL services (Supabase, Hive, Notifications) BEFORE runApp()
/// so that Riverpod providers can access Supabase.instance.client safely.
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();

  // ── Step 1: Initialize Supabase, Hive & Notifications ──────────────────
  // CRITICAL: Must happen before runApp() because the router's authStateProvider
  // calls Supabase.instance.client at startup.
  final initializer = AppInitializer();
  await initializer.initialize();
  if (initializer.hasError) {
    debugPrint('⚠️ App initializer failed: ${initializer.error}');
  }

  // ── Step 2: Initialize Gemini AI (non-fatal if key missing) ────────────────────
  const geminiKey = String.fromEnvironment('GEMINI_API_KEY');
  if (geminiKey.isNotEmpty) {
    _geminiService.initialize(geminiKey);
    debugPrint('✅ Gemini AI initialized');
  } else {
    debugPrint(
        'ℹ️ GEMINI_API_KEY not set — AI features will show offline state');
  }

  runApp(
    EasyLocalization(
      supportedLocales: const [Locale('en'), Locale('sw')],
      path: 'assets/translations',
      fallbackLocale: const Locale('en'),
      child: ProviderScope(
        overrides: [
          patientGeminiServiceProvider.overrideWithValue(_geminiService),
        ],
        child: const MCHPatientApp(),
      ),
    ),
  );
}
