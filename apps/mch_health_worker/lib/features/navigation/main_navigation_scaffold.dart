import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../patient_management/presentation/screens/patient_list_screen.dart';
import '../patient_management/presentation/screens/dashboard_screen.dart';

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
        return DashboardScreen(drawer: _buildDrawer());  // ← Change this
      case 1:
        return PatientListScreen(drawer: _buildDrawer());
      case 2:
        return SchedulePage(drawer: _buildDrawer());
      default:
        return DashboardScreen(drawer: _buildDrawer());  // ← And this
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
              extended: screenWidth >= 800, // Extend labels on larger screens
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

  // Helper method to wrap pages with drawer for mobile
  Widget _wrapWithDrawer(Widget page) {
    return Scaffold(
      drawer: _buildDrawer(),
      body: page,
    );
  }

  // ========== DRAWER WIDGET ==========
  Widget _buildDrawer() {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          // Drawer Header with User Info
          const UserAccountsDrawerHeader(
            decoration: BoxDecoration(
              color: Color(0xFF0D9488),
            ),
            currentAccountPicture: CircleAvatar(
              backgroundColor: Colors.white,
              child: Icon(Icons.person, size: 40, color: Color(0xFF0D9488)),
            ),
            accountName: Text(
              'Dr. Jane Kamau',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            accountEmail: Text('Kiambu County Hospital'),
          ),
          
          // My Facility
          ListTile(
            leading: const Icon(Icons.local_hospital),
            title: const Text('My Facility'),
            onTap: () {
              Navigator.pop(context);
              // TODO: Navigate to facility details
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('My Facility')),
              );
            },
          ),
          
          // Staff Management
          ListTile(
            leading: const Icon(Icons.group),
            title: const Text('Staff Management'),
            onTap: () {
              Navigator.pop(context);
              // TODO: Navigate to staff management
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Staff Management')),
              );
            },
          ),
          
          // Stock/Inventory
          ListTile(
            leading: const Icon(Icons.inventory),
            title: const Text('Stock & Inventory'),
            onTap: () {
              Navigator.pop(context);
              // TODO: Navigate to stock management
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Stock & Inventory')),
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
              // TODO: Navigate to reports
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Reports & Analytics')),
              );
            },
          ),
          
          // MOH Guidelines
          ListTile(
            leading: const Icon(Icons.book),
            title: const Text('MOH Guidelines'),
            onTap: () {
              Navigator.pop(context);
              // TODO: Navigate to guidelines
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('MOH Guidelines')),
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
              // TODO: Navigate to notifications
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Notifications')),
              );
            },
          ),
          
          // Settings
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text('Settings'),
            onTap: () {
              Navigator.pop(context);
              // TODO: Navigate to settings
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Settings')),
              );
            },
          ),
          
          // Help & Support
          ListTile(
            leading: const Icon(Icons.help),
            title: const Text('Help & Support'),
            onTap: () {
              Navigator.pop(context);
              // TODO: Navigate to help
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Help & Support')),
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
          
          // Logout
          ListTile(
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
                      onPressed: () {
                        // TODO: Implement logout logic
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Logged out successfully')),
                        );
                      },
                      child: const Text('Logout', style: TextStyle(color: Colors.red)),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

// ========== PLACEHOLDER PAGES ==========
// TODO: Replace these with actual page implementations

class DashboardPage extends StatelessWidget {
  final Widget? drawer;
  
  const DashboardPage({super.key, this.drawer});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: drawer,
      appBar: AppBar(
        title: const Text('Dashboard'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.dashboard, size: 100, color: Colors.blue[200]),
            const SizedBox(height: 16),
            const Text(
              'Dashboard Page',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text('Coming soon...'),
          ],
        ),
      ),
    );
  }
}

class PatientsPage extends StatelessWidget {
  final Widget? drawer;
  
  const PatientsPage({super.key, this.drawer});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: drawer,
      appBar: AppBar(
        title: const Text('Patients'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              // TODO: Implement search
            },
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.people, size: 100, color: Colors.green[200]),
            const SizedBox(height: 16),
            const Text(
              'Patients Page',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text('Patient list will appear here'),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          // TODO: Navigate to patient registration
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Navigate to Register New Patient')),
          );
        },
        icon: const Icon(Icons.person_add),
        label: const Text('New Patient'),
      ),
    );
  }
}

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

class MorePage extends StatelessWidget {
  const MorePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('More'),
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
          ),
        ),
      ),
      body: ListView(
        children: [
          ListTile(
            leading: const Icon(Icons.assessment),
            title: const Text('Reports'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              // TODO: Navigate to reports
            },
          ),
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text('Settings'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              // TODO: Navigate to settings
            },
          ),
          ListTile(
            leading: const Icon(Icons.help),
            title: const Text('Help & Support'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              // TODO: Navigate to help
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.info_outline),
            title: const Text('About'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              // TODO: Show about dialog
            },
          ),
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.red),
            title: const Text('Logout', style: TextStyle(color: Colors.red)),
            onTap: () {
              // TODO: Implement logout
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
                      onPressed: () {
                        // TODO: Implement logout logic
                        Navigator.pop(context);
                      },
                      child: const Text('Logout'),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}