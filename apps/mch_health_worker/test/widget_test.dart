import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

// 1. Import your main.dart file
import 'package:mch_health_worker/main.dart'; 

void main() {
  testWidgets('App initialization smoke test', (WidgetTester tester) async {
    // 2. Build our app and trigger a frame.
    // FIX: This must be the exact Class Name defined in lib/main.dart.
    // Standard naming convention forbids spaces or dashes.
    // If your main class is named something other than 'MyApp', change it here.
    await tester.pumpWidget(const MCHHealthWorkerApp()); 

    // Verify that our app starts with the title 'MCH Health Worker Portal'.
    // Note: This test will fail if this exact text is not found on the
    // very first screen (e.g., if there is a loading spinner first).
    expect(find.text('MCH Health Worker Portal'), findsOneWidget);
  });
}