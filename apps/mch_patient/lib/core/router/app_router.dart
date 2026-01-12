import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../features/auth/presentation/screens/login_screen.dart';
import '../../features/auth/presentation/screens/sign_up_screen.dart';
import '../../features/home/presentation/screens/home_wrapper.dart';
import '../../features/children/presentation/screens/children_list_screen.dart';
import '../../features/children/presentation/screens/child_detail_screen.dart';
import '../../features/children/presentation/screens/vaccination_schedule_screen.dart';
import '../../features/children/presentation/screens/growth_charts_screen.dart';
import '../../features/children/presentation/screens/visit_history_screen.dart';
import '../../features/maternal/presentation/screens/anc_visit_history_screen.dart';
import '../../features/appointments/presentation/screens/appointments_screen.dart';
import '../../features/profile/presentation/screens/profile_screen.dart';
import '../../features/settings/presentation/screens/settings_screen.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../features/home/presentation/screens/splash_screen.dart';
import '../../features/auth/presentation/screens/forgot_password_screen.dart';
import '../../../../core/providers/auth_provider.dart';

// Router provider
final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/',  // Start at splash screen
    redirect: (context, state) {
      // Don't redirect if on splash - it handles initialization
      if (state.matchedLocation == '/') {
        return null;
      }

      // Check auth state (with error handling for uninitialized state)
      bool isAuthenticated = false;
      try {
        isAuthenticated = Supabase.instance.client.auth.currentUser != null;
      } catch (e) {
        // Supabase not initialized yet, redirect to splash
        return '/';
      }

      final isOnAuth = state.matchedLocation == '/login' || 
                       state.matchedLocation == '/signup' ||
                       state.matchedLocation == '/forgot-password';

      // If not authenticated and trying to access protected route, redirect to login
      if (!isAuthenticated && !isOnAuth) {
        return '/login';
      }
      
      // If authenticated and trying to access auth screens, redirect to home
      if (isAuthenticated && isOnAuth) {
        return '/home';
      }

      return null;
    },
    routes: [
      // Splash Screen Route (OUTSIDE ShellRoute)
      GoRoute(
        path: '/',
        name: 'splash',
        builder: (context, state) => const SplashScreen(),
      ),

      // Auth Routes
      GoRoute(
        path: '/login',
        name: 'login',
        builder: (context, state) => const FlexibleLoginScreen(),
      ),
      GoRoute(
        path: '/signup',
        name: 'signup',
        builder: (context, state) => const SignupScreen(),
      ),
      GoRoute(
        path: '/forgot-password',
        name: 'forgot-password',
        builder: (context, state) => const ForgotPasswordScreen(),
      ),

      // Main App Shell with Bottom Navigation
      ShellRoute(
        builder: (context, state, child) {
          return MainShell(child: child);
        },
        routes: [
          GoRoute(
            path: '/',
            builder: (context, state) => const SplashScreen(),
          ),
          GoRoute(
            path: '/home',
            name: 'home',
            pageBuilder: (context, state) => NoTransitionPage(
              child: const HomeWrapper(),
            ),
          ),
          GoRoute(
            path: '/children',
            name: 'children',
            pageBuilder: (context, state) => NoTransitionPage(
              child: const ChildrenListScreen(),
            ),
          ),
          GoRoute(
            path: '/appointments',
            name: 'appointments',
            pageBuilder: (context, state) => NoTransitionPage(
              child: const AppointmentsScreen(),
            ),
          ),
          GoRoute(
            path: '/profile',
            name: 'profile',
            pageBuilder: (context, state) => NoTransitionPage(
              child: const ProfileScreen(),
            ),
          ),
        ],
      ),

      // Child Detail Route (outside shell for full screen)
      GoRoute(
        path: '/child/:id',
        name: 'childDetail',
        builder: (context, state) {
          final childId = state.pathParameters['id']!;
          return ChildDetailScreen(childId: childId);
        },
      ),
      
      // Vaccination Schedule Route
      GoRoute(
        path: '/child/:id/vaccinations',
        name: 'vaccinations',
        builder: (context, state) {
          final childId = state.pathParameters['id']!;
          return VaccinationScheduleScreen(childId: childId);
        },
      ),
      
      // Growth Charts Route
      GoRoute(
        path: '/child/:id/growth',
        name: 'growth',
        builder: (context, state) {
          final childId = state.pathParameters['id']!;
          return GrowthChartsScreen(childId: childId);
        },
      ),
      
      // Visit History Route
      GoRoute(
        path: '/child/:id/visits',
        name: 'visits',
        builder: (context, state) {
          final childId = state.pathParameters['id']!;
          return VisitHistoryScreen(childId: childId);
        },
      ),
      
      // ANC Visit History Route
      GoRoute(
        path: '/anc-visits',
        name: 'ancVisits',
        builder: (context, state) => const AncVisitHistoryScreen(),
      ),
      
      // Settings Route
      GoRoute(
        path: '/settings',
        name: 'settings',
        builder: (context, state) => const SettingsScreen(),
      ),
    ],
  );
});

// Main Shell with Bottom Navigation
class MainShell extends StatelessWidget {
  final Widget child;

  const MainShell({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: child,
      bottomNavigationBar: const BottomNavBar(),
    );
  }
}

// Bottom Navigation Bar
class BottomNavBar extends StatelessWidget {
  const BottomNavBar({super.key});

  int _calculateSelectedIndex(BuildContext context) {
    final String location = GoRouterState.of(context).matchedLocation;
    if (location.startsWith('/home')) return 0;
    if (location.startsWith('/children')) return 1;
    if (location.startsWith('/appointments')) return 2;
    if (location.startsWith('/profile')) return 3;
    return 0;
  }

  void _onItemTapped(BuildContext context, int index) {
    switch (index) {
      case 0:
        context.go('/home');
        break;
      case 1:
        context.go('/children');
        break;
      case 2:
        context.go('/appointments');
        break;
      case 3:
        context.go('/profile');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final selectedIndex = _calculateSelectedIndex(context);

    return BottomNavigationBar(
      currentIndex: selectedIndex,
      onTap: (index) => _onItemTapped(context, index),
      type: BottomNavigationBarType.fixed,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.child_care),
          label: 'Children',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.calendar_today),
          label: 'Visits',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person),
          label: 'Me',
        ),
      ],
    );
  }
}