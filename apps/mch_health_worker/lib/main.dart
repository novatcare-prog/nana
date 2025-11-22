import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:mch_core/mch_core.dart';
import 'core/providers/auth_providers.dart';
import 'features/patient_management/presentation/screens/login_screen.dart';
import 'features/patient_management/presentation/screens/dashboard_screen.dart';
import 'features/navigation/main_navigation_scaffold.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Supabase - CORRECTED
  await Supabase.initialize(
    url: 'https://fhdscavlgrgbotfxoxxw.supabase.co',
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImZoZHNjYXZsZ3JnYm90ZnhveHh3Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjMyMTAzMzYsImV4cCI6MjA3ODc4NjMzNn0.V-_3cJMQ_iA7bmETwxr-7p2RImhqQ3pJ7Xw5H7O2mi4',
  );

  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MCH Kenya - Health Worker',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const AuthGate(),
    );
  }
}

/// Auth Gate - Decides whether to show login or dashboard
class AuthGate extends ConsumerWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authStateProvider);

    return authState.when(
      data: (user) {
        if (user == null) {
          // Not logged in - show login screen
          return const LoginScreen();
        }

        // User is logged in - check their profile and role
        return const RoleChecker();
      },
      loading: () => const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      ),
      error: (error, stack) => Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 64, color: Colors.red),
              const SizedBox(height: 16),
              Text('Error: $error'),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  ref.invalidate(authStateProvider);
                },
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Role Checker - Ensures user is a health worker
class RoleChecker extends ConsumerWidget {
  const RoleChecker({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileAsync = ref.watch(currentUserProfileProvider);

    return profileAsync.when(
      data: (profile) {
        if (profile == null) {
          return _buildError(
            context,
            ref,
            'Profile not found',
            'Your user profile could not be loaded.',
          );
        }

        // Check if user is health worker or admin
        final role = UserRole.fromString(profile.role);
        if (role != UserRole.healthWorker && role != UserRole.admin) {
          return _buildError(
            context,
            ref,
            'Access Denied',
            'This app is for health workers only.\nYour role: ${profile.role}',
          );
        }

        // Check if health worker has a facility assigned
        if (profile.facilityId == null) {
          return _buildError(
            context,
            ref,
            'No Facility Assigned',
            'Please contact your administrator to assign you to a facility.',
          );
        }

        // All checks passed - show dashboard
        return const MainNavigationScaffold();
      },
      loading: () => const Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 16),
              Text('Loading profile...'),
            ],
          ),
        ),
      ),
      error: (error, stack) => _buildError(
        context,
        ref,
        'Error Loading Profile',
        error.toString(),
      ),
    );
  }

  Widget _buildError(BuildContext context, WidgetRef ref, String title, String message) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.error_outline,
                size: 64,
                color: Theme.of(context).colorScheme.error,
              ),
              const SizedBox(height: 24),
              Text(
                title,
                style: Theme.of(context).textTheme.headlineSmall,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              Text(
                message,
                style: Theme.of(context).textTheme.bodyLarge,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              FilledButton.icon(
                onPressed: () async {
                  final authActions = ref.read(authActionsProvider);
                  await authActions.signOut();
                },
                icon: const Icon(Icons.logout),
                label: const Text('Logout'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Supabase client accessor
SupabaseClient get supabase => Supabase.instance.client;