import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mch_core/mch_core.dart';
import '../../core/providers/auth_providers.dart';
import '../../core/providers/facility_providers.dart';
import '../patient_management/presentation/screens/patient_list_screen.dart';
import '../patient_management/presentation/screens/dashboard_screen.dart';
import '../patient_management/presentation/screens/schedule_screen.dart';
import '../patient_management/presentation/screens/settings_screen.dart';
import '../patient_management/presentation/screens/edit_profile_screen.dart';
import '../reports/presentation/screens/reports_screen.dart';
import '../patient_management/presentation/screens/notifications_screen.dart';
import '../../core/widgets/offline_indicator.dart';
import '../../core/providers/notification_providers.dart';

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
      // Desktop/Tablet: Use Custom Sidebar
      return Scaffold(
        body: Column(
          children: [
            // Offline status banner at the top
            const OfflineBanner(),
            
            // Main content with sidebar
            Expanded(
              child: Row(
                children: [
                  // Custom Sidebar (Left Side)
                  _buildDesktopSidebar(context, screenWidth >= 800),
                  
                  const VerticalDivider(thickness: 1, width: 1),
                  
                  // Main Content Area
                  Expanded(
                    child: _getPage(_selectedIndex),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    } else {
      // Mobile: Use Bottom Navigation Bar
      return Scaffold(
        body: Column(
          children: [
            // Offline status banner at the top
            const OfflineBanner(),
            
            // Main content
            Expanded(
              child: _getPage(_selectedIndex),
            ),
          ],
        ),
        bottomNavigationBar: NavigationBar(
          selectedIndex: _selectedIndex,
          onDestinationSelected: _onDestinationSelected,
          destinations: _destinations,
        ),
      );
    }
  }

  // ========== DESKTOP SIDEBAR WIDGET ==========
  Widget _buildDesktopSidebar(BuildContext context, bool extended) {
    final theme = Theme.of(context);
    final sidebarWidth = extended ? 220.0 : 72.0;
    
    return Container(
      width: sidebarWidth,
      color: theme.colorScheme.surface,
      child: Column(
        children: [
          // App Logo/Header
          Container(
            height: 64,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Image.asset(
                  'assets/images/BLUE_app_launcher_ICON-01.png',
                  width: 32,
                  height: 32,
                ),
                if (extended) ...[
                  const SizedBox(width: 12),
                  Text(
                    'MCH Kenya',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: theme.primaryColor,
                    ),
                  ),
                ],
              ],
            ),
          ),
          
          const Divider(height: 1),
          
          // Main Navigation Items
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(vertical: 8),
              children: [
                // Dashboard
                _buildSidebarItem(
                  context: context,
                  icon: Icons.dashboard_outlined,
                  selectedIcon: Icons.dashboard,
                  label: 'Dashboard',
                  isSelected: _selectedIndex == 0,
                  extended: extended,
                  onTap: () => _onDestinationSelected(0),
                ),
                // Patients
                _buildSidebarItem(
                  context: context,
                  icon: Icons.people_outline,
                  selectedIcon: Icons.people,
                  label: 'Patients',
                  isSelected: _selectedIndex == 1,
                  extended: extended,
                  onTap: () => _onDestinationSelected(1),
                ),
                // Schedule
                _buildSidebarItem(
                  context: context,
                  icon: Icons.calendar_today_outlined,
                  selectedIcon: Icons.calendar_today,
                  label: 'Schedule',
                  isSelected: _selectedIndex == 2,
                  extended: extended,
                  onTap: () => _onDestinationSelected(2),
                ),
                
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  child: Divider(),
                ),
                
                // Reports
                _buildSidebarItem(
                  context: context,
                  icon: Icons.analytics_outlined,
                  selectedIcon: Icons.analytics,
                  label: 'Reports',
                  isSelected: false,
                  extended: extended,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ReportsScreen(),
                      ),
                    );
                  },
                ),
                // Notifications (with badge)
                Consumer(
                  builder: (context, ref, _) {
                    final count = ref.watch(unreadNotificationCountProvider);
                    return _buildSidebarItem(
                      context: context,
                      icon: Icons.notifications_outlined,
                      selectedIcon: Icons.notifications,
                      label: 'Notifications',
                      isSelected: false,
                      extended: extended,
                      badge: count > 0 ? count : null,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const NotificationsScreen(),
                          ),
                        );
                      },
                    );
                  },
                ),
                
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  child: Divider(),
                ),
                
                // Settings
                _buildSidebarItem(
                  context: context,
                  icon: Icons.settings_outlined,
                  selectedIcon: Icons.settings,
                  label: 'Settings',
                  isSelected: false,
                  extended: extended,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const SettingsScreen(),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
          
          // User Profile Footer
          const Divider(height: 1),
          _UserProfileHeader(),
        ],
      ),
    );
  }

  // Helper method to build a sidebar item
  Widget _buildSidebarItem({
    required BuildContext context,
    required IconData icon,
    required IconData selectedIcon,
    required String label,
    required bool isSelected,
    required bool extended,
    required VoidCallback onTap,
    int? badge,
  }) {
    final theme = Theme.of(context);
    final color = isSelected ? theme.primaryColor : theme.iconTheme.color;
    final bgColor = isSelected ? theme.primaryColor.withOpacity(0.1) : Colors.transparent;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      child: Material(
        color: bgColor,
        borderRadius: BorderRadius.circular(8),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(8),
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: extended ? 12 : 0,
              vertical: 12,
            ),
            child: Row(
              mainAxisAlignment: extended ? MainAxisAlignment.start : MainAxisAlignment.center,
              children: [
                Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Icon(isSelected ? selectedIcon : icon, color: color),
                    if (badge != null)
                      Positioned(
                        right: -8,
                        top: -4,
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: const BoxDecoration(
                            color: Colors.red,
                            shape: BoxShape.circle,
                          ),
                          child: Text(
                            badge > 9 ? '9+' : '$badge',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
                if (extended) ...[
                  const SizedBox(width: 12),
                  Text(
                    label,
                    style: TextStyle(
                      color: color,
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
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
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const ReportsScreen()),
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
          
          // Notifications (with real badge count)
          Consumer(
            builder: (context, ref, _) {
              final count = ref.watch(unreadNotificationCountProvider);
              return ListTile(
                leading: const Icon(Icons.notifications),
                title: const Text('Notifications'),
                trailing: count > 0
                    ? Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          count > 99 ? '99+' : '$count',
                          style: const TextStyle(color: Colors.white, fontSize: 12),
                        ),
                      )
                    : null,
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const NotificationsScreen(),
                    ),
                  );
                },
              );
            },
          ),
          
          // Settings - UPDATED!
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text('Settings'),
            onTap: () {
              Navigator.pop(context); // Close drawer
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const SettingsScreen(),
                ),
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
                // Only pop if we're in a drawer (not sidebar)
                final scaffold = Scaffold.maybeOf(context);
                if (scaffold?.isDrawerOpen ?? false) {
                  Navigator.pop(context); // Close drawer
                }
                // Use root navigator to ensure proper back navigation
                Navigator.of(context, rootNavigator: true).push(
                  MaterialPageRoute(
                    builder: (context) => const EditProfileScreen(),
                  ),
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