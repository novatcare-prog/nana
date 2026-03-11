import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:mch_core/mch_core.dart';
import 'app.dart';
import 'features/ai/providers/chatbot_provider.dart';

final _geminiService = GeminiService();

/// Main entry point
/// Show UI immediately — initialization happens in the SplashScreen
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();

  // Initialize Gemini AI from .env (non-fatal if key missing)
  try {
    await dotenv.load(fileName: '.env');
    final geminiKey = dotenv.maybeGet('GEMINI_API_KEY') ?? '';
    if (geminiKey.isNotEmpty && geminiKey != 'YOUR_GEMINI_API_KEY_HERE') {
      _geminiService.initialize(geminiKey);
      debugPrint('✅ Gemini AI initialized');
    } else {
      debugPrint('ℹ️ GEMINI_API_KEY not set — AI features will show offline state');
    }
  } catch (e) {
    debugPrint('ℹ️ Could not load .env for Gemini: $e');
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
