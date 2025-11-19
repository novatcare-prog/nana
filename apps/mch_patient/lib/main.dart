import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/theme/app_theme.dart';

void main() {
  runApp(
    const ProviderScope(
      child: MchPatientApp(),
    ),
  );
}

class MchPatientApp extends StatelessWidget {
  const MchPatientApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MCH Care Kenya',
      theme: AppTheme.lightTheme,
      debugShowCheckedModeBanner: false,
      home: const PatientHomePage(),
    );
  }
}

class PatientHomePage extends StatelessWidget {
  const PatientHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('MCH Care Kenya'),
        leading: const Icon(Icons.health_and_safety),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.pregnant_woman,
              size: 100,
              color: AppTheme.primaryPurple,
            ),
            const SizedBox(height: 24),
            const Text(
              'Welcome to MCH Care',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Mother & Child Health',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 32),
            const Text('Based on Kenya MCH Handbook 2020'),
          ],
        ),
      ),
    );
  }
}