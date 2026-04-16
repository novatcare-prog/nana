import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/providers/maternal_profile_provider.dart';
import 'home_screen.dart';
import 'pregnancy_dashboard.dart';

/// Home Wrapper - Decides which dashboard to show based on pregnancy status
/// - If user has active pregnancy → PregnancyDashboard
/// - Otherwise → Regular HomeScreen
class HomeWrapper extends ConsumerWidget {
  const HomeWrapper({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final maternalProfileAsync = ref.watch(currentMaternalProfileProvider);
    final isPregnant = ref.watch(hasActivePregnancyProvider);

    return maternalProfileAsync.when(
      data: (profile) {
        if (isPregnant) {
          return const PregnancyDashboard();
        }
        return const HomeScreen();
      },
      loading: () => const Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(
                color: Color(0xFFE91E63),
              ),
              SizedBox(height: 16),
              Text(
                'Loading your dashboard...',
                style: TextStyle(color: Colors.grey),
              ),
            ],
          ),
        ),
      ),
      error: (error, stack) {
        if (kDebugMode) {
          debugPrint('HomeWrapper error: $error');
        }
        // On error, fall back to regular home screen
        return const HomeScreen();
      },
    );
  }
}
