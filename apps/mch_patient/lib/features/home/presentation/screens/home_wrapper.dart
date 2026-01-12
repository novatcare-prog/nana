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

    // DEBUG: Print status to console
    print('🔍 HomeWrapper Debug:');
    print('   - isPregnant: $isPregnant');
    print('   - maternalProfileAsync: $maternalProfileAsync');

    return maternalProfileAsync.when(
      data: (profile) {
        // DEBUG: Print profile details
        print('   - profile: $profile');
        print('   - profile?.edd: ${profile?.edd}');
        
        // Show pregnancy dashboard if user has active pregnancy
        if (isPregnant) {
          print('   ✅ Showing PregnancyDashboard');
          return const PregnancyDashboard();
        }
        // Otherwise show regular home screen
        print('   ℹ️ Showing HomeScreen (not pregnant)');
        return const HomeScreen();
      },
      loading: () {
        print('   ⏳ Loading...');
        return const Scaffold(
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
        );
      },
      error: (error, stack) {
        // On error, fall back to regular home screen
        print('   ❌ Error: $error');
        print('   Stack: $stack');
        return const HomeScreen();
      },
    );
  }
}
