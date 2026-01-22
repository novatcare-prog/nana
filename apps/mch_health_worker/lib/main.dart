import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:mch_core/mch_core.dart';

// --- Core Imports ---
import 'core/providers/auth_providers.dart';
import 'core/providers/theme_provider.dart' hide AppTheme; // Hiding to avoid naming conflict
import 'core/theme/app_theme.dart'; 
import 'core/services/hive_service.dart';
import 'core/services/connectivity_service.dart';

// --- Feature Imports ---
import 'features/navigation/main_navigation_scaffold.dart';
import 'features/patient_management/presentation/screens/login_screen.dart';
import 'features/patient_management/presentation/screens/reset_password_screen.dart';
import 'features/patient_management/presentation/screens/splash_screen.dart';
import 'core/widgets/offline_indicator.dart'; 

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

/// Supabase configuration from compile-time environment variables
/// Set via --dart-define during build for better security
const String _supabaseUrl = String.fromEnvironment('SUPABASE_URL');
const String _supabaseAnonKey = String.fromEnvironment('SUPABASE_ANON_KEY');

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 1. Validate Supabase configuration
  if (_supabaseUrl.isEmpty || _supabaseAnonKey.isEmpty) {
    throw Exception(
      'Missing Supabase configuration. '
      'Build with: flutter run --dart-define=SUPABASE_URL=xxx --dart-define=SUPABASE_ANON_KEY=xxx'
    );
  }
  
  // 2. Initialize Supabase (using compile-time env vars)
  await Supabase.initialize(
    url: _supabaseUrl,
    anonKey: _supabaseAnonKey,
    authOptions: const FlutterAuthClientOptions(
      authFlowType: AuthFlowType.pkce,
    ),
  );
  
  // 3. Listen for Auth State Changes (Password Recovery, Sign Out)
  Supabase.instance.client.auth.onAuthStateChange.listen((data) {
    if (data.event == AuthChangeEvent.passwordRecovery) {
      navigatorKey.currentState?.pushAndRemoveUntil(
        MaterialPageRoute(
          builder: (context) => const ResetPasswordScreen(),
        ),
        (route) => false,
      );
    } else if (data.event == AuthChangeEvent.signedOut) {
      // Show logging out animation, then navigate to login
      navigatorKey.currentState?.pushAndRemoveUntil(
        PageRouteBuilder(
          pageBuilder: (_, __, ___) => const _LoggingOutScreen(),
          transitionDuration: const Duration(milliseconds: 300),
          transitionsBuilder: (_, animation, __, child) => 
            FadeTransition(opacity: animation, child: child),
        ),
        (route) => false,
      );
    }
  });
  
  // 4. Initialize Hive (Offline Storage)
  print('🔄 Initializing Hive...');
  await HiveService.initAll();
  print('✅ Hive initialized successfully');
  
  // Debug: Show storage stats
  final stats = HiveService.getStorageStats();
  print('📊 Storage stats: ${stats.length} boxes, ${HiveService.getTotalCachedItems()} total items');

  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);
    
    // Initialize connectivity monitoring
    ref.watch(connectivityServiceProvider);
    
    return MaterialApp(
      navigatorKey: navigatorKey,
      title: 'MCH Kenya - Health Worker',
      debugShowCheckedModeBanner: false,
      
      // Theme Configuration (Uses your updated AppTheme with darker blue)
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themeMode,
      
      // ✅ Start with the Splash Screen, wrapped with sync error listener
      home: const SyncErrorListener(
        child: SplashScreen(),
      ), 
    );
  }
}

/// Auth Gate - Decides whether to show login or dashboard
/// (Accessed by SplashScreen after animation finishes)
class AuthGate extends ConsumerWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authStateProvider);

    return authState.when(
      data: (user) {
        if (user == null) {
          // Not logged in -> Login Screen
          return const LoginScreen();
        }

        // User logged in -> Check Role/Profile
        return const RoleChecker();
      },
      loading: () => const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      ),
      error: (error, stack) => Scaffold(
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline, size: 64, color: Colors.red),
                const SizedBox(height: 16),
                Text('Authentication Error: $error', textAlign: TextAlign.center),
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

        // Check Role
        final role = UserRole.fromString(profile.role);
        if (role != UserRole.healthWorker && role != UserRole.admin) {
          return _buildError(
            context,
            ref,
            'Access Denied',
            'This app is for health workers only.\nYour role: ${profile.role}',
          );
        }

        // Check Facility
        if (profile.facilityId == null) {
          return _buildError(
            context,
            ref,
            'No Facility Assigned',
            'Please contact your administrator to assign you to a facility.',
          );
        }

        // ✅ Checks Passed -> Main App
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

/// Animated Logging Out Screen
class _LoggingOutScreen extends StatefulWidget {
  const _LoggingOutScreen();

  @override
  State<_LoggingOutScreen> createState() => _LoggingOutScreenState();
}

class _LoggingOutScreenState extends State<_LoggingOutScreen> 
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.8).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    _fadeAnimation = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _controller, 
        curve: const Interval(0.5, 1.0, curve: Curves.easeOut),
      ),
    );

    _controller.forward();

    // Navigate to login after animation
    Future.delayed(const Duration(milliseconds: 1800), () {
      if (mounted) {
        Navigator.of(context).pushAndRemoveUntil(
          PageRouteBuilder(
            pageBuilder: (_, __, ___) => const LoginScreen(),
            transitionDuration: const Duration(milliseconds: 500),
            transitionsBuilder: (_, animation, __, child) => 
              FadeTransition(opacity: animation, child: child),
          ),
          (route) => false,
        );
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: Center(
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return Opacity(
              opacity: _fadeAnimation.value.clamp(0.3, 1.0),
              child: Transform.scale(
                scale: _scaleAnimation.value,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Animated icon
                    Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.waving_hand,
                        size: 50,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                    const SizedBox(height: 32),
                    
                    // Text
                    Text(
                      'Goodbye!',
                      style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Logging you out...',
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: Colors.grey[600],
                      ),
                    ),
                    const SizedBox(height: 32),
                    
                    // Spinner
                    SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.5,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}