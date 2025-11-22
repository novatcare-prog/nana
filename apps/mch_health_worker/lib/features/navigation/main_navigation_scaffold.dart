import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mch_core/mch_core.dart';
import '../../core/providers/auth_providers.dart';
import '../../core/providers/facility_providers.dart';
import '../patient_management/presentation/screens/patient_list_screen.dart';
import '../patient_management/presentation/screens/dashboard_screen.dart';
import '../patient_management/presentation/screens/schedule_screen.dart';

/// Main Navigation Scaffold with Adaptive Layout
/// - Phone: Bottom Navigation Bar
/// - Tablet/Desktop: Navigation Rail
class MainNavigationScaffold extends ConsumerStatefulWidget {
  const MainNavigationScaffold({super.key});

  @override
  ConsumerState<MainNavigationScaffold> createState() =>
      _MainNavigationScaffoldState();
}

class _MainNavigationScaffoldState
    extends ConsumerState<MainNavigationScaffold> {
  int _selectedIndex = 0;

  // Navigation destinations
  final List<NavigationDestination> _destinations = const [
    NavigationDestination(
      icon: Icon(Icons.dashboard_outlined),
      selectedIcon: Icon(Icons.dashboard),
      label: 'Dashboard',
    ),
    NavigationDestination(
      icon: Icon(Icons.people_outline),
      selectedIcon: Icon(Icons.people),
      label: 'Patients',
    ),
    NavigationDestination(
      icon: Icon(Icons.calendar_today_outlined),
      selectedIcon: Icon(Icons.calendar_today),
      label: 'Schedule',
    ),
  ];

  void _onDestinationSelected(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  // Get the page based on selected index
  Widget _getPage(int index) {
    switch (index) {
      case 0:
        return DashboardScreen(drawer: _buildDrawer());
      case 1:
        return PatientListScreen(drawer: _buildDrawer());
      case 2:
        return ScheduleScreen(drawer: _buildDrawer());
      default:
        return DashboardScreen(drawer: _buildDrawer());
    }
  }

  @override
  Widget build(BuildContext context) {
    // Check screen width for adaptive layout
    final screenWidth = MediaQuery.of(context).size.width;
    final useNavigationRail = screenWidth >= 600;

    if (useNavigationRail) {
      // Desktop/Tablet: Use NavigationRail
      return Scaffold(
        drawer: _buildDrawer(),
        body: Row(
          children: [
            // Navigation Rail (Left Side)
            NavigationRail(
              extended: screenWidth >= 800,
              selectedIndex: _selectedIndex,
              onDestinationSelected: _onDestinationSelected,
              labelType: screenWidth >= 800
                  ? NavigationRailLabelType.none
                  : NavigationRailLabelType.all,
              destinations: _destinations.map((destination) {
                return NavigationRailDestination(
                  icon: destination.icon,
                  selectedIcon: destination.selectedIcon,
                  label: Text(destination.label),
                );
              }).toList(),
            ),
            
            const VerticalDivider(thickness: 1, width: 1),
            
            // Main Content Area
            Expanded(
              child: _getPage(_selectedIndex),
            ),
          ],
        ),
      );
    } else {
      // Mobile: Use Bottom Navigation Bar
      return Scaffold(
        body: _getPage(_selectedIndex),
        bottomNavigationBar: NavigationBar(
          selectedIndex: _selectedIndex,
          onDestinationSelected: _onDestinationSelected,
          destinations: _destinations,
        ),
      );
    }
  }

  // ========== DRAWER WIDGET ==========
  Widget _buildDrawer() {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          // Drawer Header with REAL User Info
          _UserProfileHeader(),
          
          // My Facility
          ListTile(
            leading: const Icon(Icons.local_hospital),
            title: const Text('My Facility'),
            onTap: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('My Facility - Coming soon')),
              );
            },
          ),
          
          // Staff Management
          ListTile(
            leading: const Icon(Icons.group),
            title: const Text('Staff Management'),
            onTap: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Staff Management - Coming soon')),
              );
            },
          ),
          
          // Stock/Inventory
          ListTile(
            leading: const Icon(Icons.inventory),
            title: const Text('Stock & Inventory'),
            onTap: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Stock & Inventory - Coming soon')),
              );
            },
          ),
          
          const Divider(),
          
          // Reports & Analytics
          ListTile(
            leading: const Icon(Icons.analytics),
            title: const Text('Reports & Analytics'),
            onTap: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Reports & Analytics - Coming soon')),
              );
            },
          ),
          
          // MOH Guidelines
          ListTile(
            leading: const Icon(Icons.book),
            title: const Text('MOH Guidelines'),
            onTap: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('MOH Guidelines - Coming soon')),
              );
            },
          ),
          
          const Divider(),
          
          // Notifications
          ListTile(
            leading: const Icon(Icons.notifications),
            title: const Text('Notifications'),
            trailing: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Text(
                '3',
                style: TextStyle(color: Colors.white, fontSize: 12),
              ),
            ),
            onTap: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Notifications - Coming soon')),
              );
            },
          ),
          
          // Settings
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text('Settings'),
            onTap: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Settings - Coming soon')),
              );
            },
          ),
          
          // Help & Support
          ListTile(
            leading: const Icon(Icons.help),
            title: const Text('Help & Support'),
            onTap: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Help & Support - Coming soon')),
              );
            },
          ),
          
          // About
          ListTile(
            leading: const Icon(Icons.info),
            title: const Text('About'),
            onTap: () {
              Navigator.pop(context);
              showAboutDialog(
                context: context,
                applicationName: 'MCH Kenya',
                applicationVersion: '1.0.0',
                applicationIcon: const Icon(Icons.local_hospital, size: 48, color: Color(0xFF0D9488)),
                children: [
                  const Text('Mother & Child Health Management System'),
                  const SizedBox(height: 8),
                  const Text('Based on Kenya MOH MCH Handbook 2020'),
                ],
              );
            },
          ),
          
          const Divider(),
          
          // Logout with REAL functionality
          _LogoutTile(),
        ],
      ),
    );
  }
}

// ========== USER PROFILE HEADER WIDGET ==========
class _UserProfileHeader extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileAsync = ref.watch(currentUserProfileProvider);
    final facilityAsync = ref.watch(userFacilityProvider);

    return profileAsync.when(
      data: (profile) {
        if (profile == null) {
          return const UserAccountsDrawerHeader(
            decoration: BoxDecoration(color: Color(0xFF0D9488)),
            currentAccountPicture: CircleAvatar(
              backgroundColor: Colors.white,
              child: Icon(Icons.person, size: 40, color: Color(0xFF0D9488)),
            ),
            accountName: Text('Loading...'),
            accountEmail: Text(''),
          );
        }

        return UserAccountsDrawerHeader(
          decoration: const BoxDecoration(color: Color(0xFF0D9488)),
          currentAccountPicture: CircleAvatar(
            backgroundColor: Colors.white,
            child: Text(
              profile.fullName.substring(0, 1).toUpperCase(),
              style: const TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Color(0xFF0D9488),
              ),
            ),
          ),
          accountName: Text(
            profile.fullName,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          accountEmail: facilityAsync.when(
            data: (facility) => Text(facility?.name ?? 'No facility assigned'),
            loading: () => const Text('Loading facility...'),
            error: (_, __) => const Text('Error loading facility'),
          ),
          otherAccountsPictures: [
            IconButton(
              icon: const Icon(Icons.edit, color: Colors.white, size: 20),
              onPressed: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Edit Profile - Coming soon')),
                );
              },
            ),
          ],
        );
      },
      loading: () => const UserAccountsDrawerHeader(
        decoration: BoxDecoration(color: Color(0xFF0D9488)),
        currentAccountPicture: CircleAvatar(
          backgroundColor: Colors.white,
          child: CircularProgressIndicator(),
        ),
        accountName: Text('Loading...'),
        accountEmail: Text(''),
      ),
      error: (error, stack) => UserAccountsDrawerHeader(
        decoration: const BoxDecoration(color: Color(0xFF0D9488)),
        currentAccountPicture: const CircleAvatar(
          backgroundColor: Colors.white,
          child: Icon(Icons.error, size: 40, color: Colors.red),
        ),
        accountName: const Text('Error'),
        accountEmail: Text('$error'),
      ),
    );
  }
}

// ========== USER FACILITY PROVIDER ==========
final userFacilityProvider = FutureProvider<Facility?>((ref) async {
  final profile = await ref.watch(currentUserProfileProvider.future);
  if (profile?.facilityId == null) return null;

  final facilities = await ref.watch(facilitiesProvider.future);
  return facilities.firstWhere(
    (f) => f.id == profile!.facilityId,
    orElse: () => Facility(
      id: '',
      kmhflCode: '',
      name: 'Unknown Facility',
      county: '',
    ),
  );
});

// ========== LOGOUT TILE WIDGET ==========
class _LogoutTile extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListTile(
      leading: const Icon(Icons.logout, color: Colors.red),
      title: const Text('Logout', style: TextStyle(color: Colors.red)),
      onTap: () {
        Navigator.pop(context);
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Logout'),
            content: const Text('Are you sure you want to logout?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () async {
                  // Perform logout
                  final authActions = ref.read(authActionsProvider);
                  await authActions.signOut();
                  
                  if (context.mounted) {
                    Navigator.pop(context); // Close dialog
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('✓ Logged out successfully'),
                        backgroundColor: Colors.green,
                      ),
                    );
                  }
                },
                child: const Text('Logout', style: TextStyle(color: Colors.red)),
              ),
            ],
          ),
        );
      },
    );
  }
}

// ========== PLACEHOLDER PAGES ==========

class SchedulePage extends StatelessWidget {
  final Widget? drawer;
  
  const SchedulePage({super.key, this.drawer});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: drawer,
      appBar: AppBar(
        title: const Text('Schedule'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.calendar_today, size: 100, color: Colors.orange[200]),
            const SizedBox(height: 16),
            const Text(
              'Schedule Page',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text('Appointments calendar will appear here'),
          ],
        ),
      ),
    );
  }
}