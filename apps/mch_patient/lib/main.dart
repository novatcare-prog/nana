import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:easy_localization/easy_localization.dart';
import 'app.dart';

/// Main entry point
/// Show UI immediately — initialization happens in the SplashScreen
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();

  // Launch the app immediately — SplashScreen handles service initialization
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
