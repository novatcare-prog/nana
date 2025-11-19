// This is your UPDATED test/widget_test.dart file

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

// 1. Import your main.dart file
import 'package:mch_health_worker/main.dart'; 

void main() {
  testWidgets('Counter increments smoke test', (WidgetTester tester) async {
    // 2. Build our app (using the correct name) and trigger a frame.
    await tester.pumpWidget(const MCH Kenya - Health Worker()); 

    // Verify that our app starts with the title 'MCH Clinician'.
    // (We'll check for the home page text)
    expect(find.text('MCH Health Worker Portal'), findsOneWidget);

    // You can add more tests here if you want
  });
}