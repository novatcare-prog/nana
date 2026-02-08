import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:easy_localization/easy_localization.dart';
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
import '../../features/sharing/presentation/screens/share_records_screen.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../features/home/presentation/screens/splash_screen.dart';
import '../../features/auth/presentation/screens/forgot_password_screen.dart';
import '../../features/children/presentation/screens/add_child_screen.dart';
import '../../features/education/presentation/screens/handbook_screen.dart';
import '../../features/support/presentation/screens/help_support_screen.dart';
import '../../features/support/presentation/screens/privacy_policy_screen.dart';
import '../../features/education/presentation/screens/must_know_screen.dart';
import '../../features/education/presentation/screens/immunization_schedule_screen.dart';
import '../../features/education/presentation/screens/return_to_clinic_screen.dart';
import '../../features/education/presentation/screens/fluids_screen.dart';
import '../../features/education/presentation/screens/feeding_guide_screen.dart';
import '../../features/education/presentation/screens/developmental_milestones_screen.dart';
import '../../features/education/presentation/screens/healthy_foods_screen.dart';
import '../../features/clinics/presentation/screens/clinic_list_screen.dart';
import '../../features/clinics/presentation/screens/clinic_details_screen.dart';
import '../../features/clinics/presentation/screens/book_appointment_screen.dart';
import '../../features/clinics/domain/models/clinic.dart';
import '../../features/clinics/domain/models/health_worker.dart';
import '../../features/journal/presentation/screens/journal_list_screen.dart';
import '../../features/journal/presentation/screens/journal_entry_screen.dart';
import '../../features/journal/presentation/screens/journal_detail_screen.dart';
import '../../features/journal/domain/models/journal_entry.dart';
import '../../features/family_planning/presentation/screens/family_planning_screen.dart';
import '../../features/family_planning/presentation/screens/add_period_screen.dart';
import '../../features/family_planning/presentation/screens/family_planning_resources_screen.dart';
import '../../../../core/providers/auth_provider.dart';

// Router provider
final routerProvider = Provider<GoRouter>((ref) {
  final isInitialized = ref.watch(appInitializedProvider);

  if (!isInitialized) {
    return GoRouter(
      initialLocation: '/',
      routes: [
        GoRoute(
          path: '/',
          builder: (context, state) => const SplashScreen(),
        ),
      ],
    );
  }

  final authState = ref.watch(authStateProvider.stream);

  return GoRouter(
    refreshListenable: GoRouterRefreshStream(authState),
    initialLocation: '/', // Start at splash screen
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
            pageBuilder: (context, state) => const NoTransitionPage(
              child: HomeWrapper(),
            ),
          ),
          GoRoute(
            path: '/children',
            name: 'children',
            pageBuilder: (context, state) => const NoTransitionPage(
              child: ChildrenListScreen(),
            ),
          ),
          GoRoute(
            path: '/appointments',
            name: 'appointments',
            pageBuilder: (context, state) => const NoTransitionPage(
              child: AppointmentsScreen(),
            ),
          ),
          GoRoute(
            path: '/profile',
            name: 'profile',
            pageBuilder: (context, state) => const NoTransitionPage(
              child: ProfileScreen(),
            ),
          ),
        ],
      ),

      // Add Child Route
      GoRoute(
        path: '/children/add',
        name: 'add-child',
        builder: (context, state) => const AddChildScreen(),
      ),

      // Education & Support Routes
      GoRoute(
        path: '/handbook',
        name: 'handbook',
        builder: (context, state) => const HandbookScreen(),
      ),
      GoRoute(
        path: '/help',
        name: 'help',
        builder: (context, state) => const HelpSupportScreen(),
      ),
      GoRoute(
        path: '/privacy',
        name: 'privacy',
        builder: (context, state) => const PrivacyPolicyScreen(),
      ),

      // Must Know Routes
      GoRoute(
        path: '/must-know',
        name: 'must-know',
        builder: (context, state) => const MustKnowScreen(),
        routes: [
          GoRoute(
            path: 'immunization',
            name: 'must-know-immunization',
            builder: (context, state) => const ImmunizationScheduleScreen(),
          ),
          GoRoute(
            path: 'return-to-clinic',
            name: 'must-know-return',
            builder: (context, state) => const ReturnToClinicScreen(),
          ),
          GoRoute(
            path: 'fluids',
            name: 'must-know-fluids',
            builder: (context, state) => const FluidsScreen(),
          ),
          GoRoute(
            path: 'feeding',
            name: 'must-know-feeding',
            builder: (context, state) => const FeedingGuideScreen(),
          ),
          GoRoute(
            path: 'milestones',
            name: 'must-know-milestones',
            builder: (context, state) => const DevelopmentalMilestonesScreen(),
          ),
          GoRoute(
            path: 'healthy-foods',
            name: 'must-know-healthy-foods',
            builder: (context, state) => const HealthyFoodsScreen(),
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

      GoRoute(
        path: '/clinics',
        name: 'clinics',
        builder: (context, state) => const ClinicListScreen(),
        routes: [
          GoRoute(
            path: ':id',
            name: 'clinic-details',
            builder: (context, state) {
              final clinicId = state.pathParameters['id']!;
              final clinic = state.extra as Clinic?;
              return ClinicDetailsScreen(clinicId: clinicId, clinic: clinic);
            },
            routes: [
              GoRoute(
                path: 'book/:workerId',
                name: 'book-appointment',
                builder: (context, state) {
                  final clinicId = state.pathParameters['id']!;
                  final workerId = state.pathParameters['workerId']!;
                  final extra = state.extra as Map<String, dynamic>?;
                  final clinic = extra?['clinic'] as Clinic?;
                  final worker = extra?['worker'] as HealthWorker?;

                  return BookAppointmentScreen(
                    clinicId: clinicId,
                    workerId: workerId,
                    clinic: clinic,
                    worker: worker,
                  );
                },
              ),
            ],
          ),
        ],
      ),

      // Journal Routes
      GoRoute(
        path: '/journal',
        name: 'journal',
        builder: (context, state) => const JournalListScreen(),
        routes: [
          GoRoute(
            path: 'add',
            name: 'add-journal',
            builder: (context, state) => const JournalEntryScreen(),
          ),
          GoRoute(
            path: 'view/:id',
            name: 'view-journal',
            builder: (context, state) {
              final entryId = state.pathParameters['id']!;
              final entry = state.extra as JournalEntry?;
              return JournalDetailScreen(entryId: entryId, entry: entry);
            },
          ),
          GoRoute(
            path: 'edit/:id',
            name: 'edit-journal',
            builder: (context, state) {
              final entry = state.extra as JournalEntry?;
              return JournalEntryScreen(entry: entry);
            },
          ),
        ],
      ),

      // Settings Route
      GoRoute(
        path: '/settings',
        name: 'settings',
        builder: (context, state) => const SettingsScreen(),
      ),

      // Share Records Route
      GoRoute(
        path: '/share-records',
        name: 'share-records',
        builder: (context, state) => const ShareRecordsScreen(),
      ),

      // Family Planning Routes
      GoRoute(
        path: '/family-planning',
        name: 'family-planning',
        builder: (context, state) => const FamilyPlanningScreen(),
        routes: [
          GoRoute(
            path: 'add-period',
            name: 'add-period',
            builder: (context, state) => const AddPeriodScreen(),
          ),
          GoRoute(
            path: 'resources',
            name: 'family-planning-resources',
            builder: (context, state) => const FamilyPlanningResourcesScreen(),
          ),
        ],
      ),
    ],
  );
});

/// Convert a Stream to a Listenable for GoRouter refreshListenable
class GoRouterRefreshStream extends ChangeNotifier {
  GoRouterRefreshStream(Stream<dynamic> stream) {
    notifyListeners();
    _subscription = stream.asBroadcastStream().listen(
          (dynamic _) => notifyListeners(),
        );
  }

  late final StreamSubscription<dynamic> _subscription;

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}

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
      items: [
        BottomNavigationBarItem(
          icon: const Icon(Icons.home),
          label: 'nav.home'.tr(),
        ),
        BottomNavigationBarItem(
          icon: const Icon(Icons.child_care),
          label: 'nav.children'.tr(),
        ),
        BottomNavigationBarItem(
          icon: const Icon(Icons.calendar_today),
          label: 'nav.appointments'.tr(),
        ),
        BottomNavigationBarItem(
          icon: const Icon(Icons.person),
          label: 'nav.profile'.tr(),
        ),
      ],
    );
  }
}
