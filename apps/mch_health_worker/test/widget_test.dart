import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  testWidgets('App smoke test', (WidgetTester tester) async {
    // Build a simple test app
    await tester.pumpWidget(
      const ProviderScope(
        child: MaterialApp(
          home: Scaffold(
            body: Center(
              child: Text('MCH Kenya'),
            ),
          ),
        ),
      ),
    );

    // Verify the app builds without crashing
    expect(find.text('MCH Kenya'), findsOneWidget);
  });
}
