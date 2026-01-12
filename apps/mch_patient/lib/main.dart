import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'app.dart';

/// Main entry point
/// Minimal setup - actual initialization happens in SplashScreen
void main() {
  WidgetsFlutterBinding.ensureInitialized();
  
  runApp(
    const ProviderScope(
      child: MCHPatientApp(),
    ),
  );
}
