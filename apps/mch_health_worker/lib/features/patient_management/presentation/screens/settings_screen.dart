import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/providers/auth_providers.dart';
import '../../../../core/providers/theme_provider.dart';
import '../../../../core/services/hive_service.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'edit_profile_screen.dart';
import '../../../../core/providers/facility_providers.dart';
import 'package:mch_core/mch_core.dart';
import 'availability_screen.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  // Notification preferences (will be persisted later)
  bool _notificationsEnabled = true;
  bool _appointmentReminders = true;
  bool _immunizationReminders = true;
  bool _visitReminders = true;

  // Language preference
  String _language = 'English';

  String _appVersion = '';

  @override
  void initState() {
    super.initState();
    _loadAppVersion();
  }

  Future<void> _loadAppVersion() async {
    final packageInfo = await PackageInfo.fromPlatform();
    setState(() {
      _appVersion = '${packageInfo.version} (${packageInfo.buildNumber})';
    });
  }

  @override
  Widget build(BuildContext context) {
    final userProfileAsync = ref.watch(currentUserProfileProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        elevation: 0,
      ),
      body: userProfileAsync.when(
        data: (profile) {
          // Handle null profile (e.g., after logout)
          if (profile == null) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text('Loading profile...'),
                ],
              ),
            );
          }

          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Profile Card
                _ProfileCard(profile: profile),
                const SizedBox(height: 8),

                // Notification Settings
                _buildSectionHeader('Notifications'),
                _buildNotificationSettings(),
                const Divider(height: 32),

                // App Preferences
                _buildSectionHeader('App Preferences'),
                _buildAppPreferences(),
                const Divider(height: 32),

                // About
                _buildSectionHeader('About'),
                _buildAboutSection(),
                const Divider(height: 32),

                // Account Section
                _buildSectionHeader('Account', color: Colors.blueGrey),
                _buildAccountSection(context),
                const Divider(height: 32),

                // Danger Zone
                _buildSectionHeader('Danger Zone', color: Colors.red),
                _buildDangerZone(context),

                const Divider(height: 32),

                // Debug Section
                _buildSectionHeader('Debug', color: Colors.orange),
                _buildDebugSection(context),

                const SizedBox(height: 32),
              ],
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
          child: Text('Error loading profile: $error'),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title, {Color? color}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: color ?? Colors.grey[700],
        ),
      ),
    );
  }

  Widget _buildNotificationSettings() {
    return Column(
      children: [
        SwitchListTile(
          title: const Text('Enable Notifications'),
          subtitle: const Text('Receive reminders and alerts'),
          value: _notificationsEnabled,
          onChanged: (value) {
            setState(() => _notificationsEnabled = value);
          },
          secondary: const Icon(Icons.notifications),
        ),
        if (_notificationsEnabled) ...[
          SwitchListTile(
            title: const Text('Appointment Reminders'),
            subtitle: const Text('Get notified about upcoming appointments'),
            value: _appointmentReminders,
            onChanged: (value) {
              setState(() => _appointmentReminders = value);
            },
            secondary: const Icon(Icons.calendar_today),
            contentPadding: const EdgeInsets.only(left: 72, right: 16),
          ),
          SwitchListTile(
            title: const Text('Immunization Reminders'),
            subtitle: const Text('Alerts for due immunizations'),
            value: _immunizationReminders,
            onChanged: (value) {
              setState(() => _immunizationReminders = value);
            },
            secondary: const Icon(Icons.vaccines),
            contentPadding: const EdgeInsets.only(left: 72, right: 16),
          ),
          SwitchListTile(
            title: const Text('Visit Reminders'),
            subtitle: const Text('ANC and postnatal visit notifications'),
            value: _visitReminders,
            onChanged: (value) {
              setState(() => _visitReminders = value);
            },
            secondary: const Icon(Icons.event_available),
            contentPadding: const EdgeInsets.only(left: 72, right: 16),
          ),
        ],
      ],
    );
  }

  Widget _buildAppPreferences() {
    final themeMode = ref.watch(themeModeProvider);

    return Column(
      children: [
        ListTile(
          leading: const Icon(Icons.brightness_6),
          title: const Text('Theme'),
          subtitle: Text(_getThemeName(themeMode)),
          trailing: const Icon(Icons.chevron_right),
          onTap: () => _showThemeDialog(themeMode),
        ),
        ListTile(
          leading: const Icon(Icons.language),
          title: const Text('Language'),
          subtitle: Text(_language),
          trailing: const Icon(Icons.chevron_right),
          onTap: () => _showLanguageDialog(),
        ),
        ListTile(
          leading: const Icon(Icons.sync),
          title: const Text('Data Sync'),
          subtitle: const Text('Automatic sync when online'),
          trailing: Switch(
            value: true,
            onChanged: (value) {
              // TODO: Implement sync preference
            },
          ),
        ),
      ],
    );
  }

  Widget _buildAboutSection() {
    return Column(
      children: [
        ListTile(
          leading: const Icon(Icons.info),
          title: const Text('App Version'),
          subtitle: Text(_appVersion.isNotEmpty ? _appVersion : 'Loading...'),
        ),
        const ListTile(
          leading: Icon(Icons.book),
          title: Text('MCH Handbook'),
          subtitle: Text('Kenya MCH Handbook 2020'),
        ),
        ListTile(
          leading: const Icon(Icons.privacy_tip),
          title: const Text('Privacy Policy'),
          trailing: const Icon(Icons.chevron_right),
          onTap: () {
            // TODO: Show privacy policy
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Privacy policy coming soon')),
            );
          },
        ),
        ListTile(
          leading: const Icon(Icons.description),
          title: const Text('Terms of Service'),
          trailing: const Icon(Icons.chevron_right),
          onTap: () {
            // TODO: Show terms
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Terms of service coming soon')),
            );
          },
        ),
        ListTile(
          leading: const Icon(Icons.help),
          title: const Text('Help & Support'),
          trailing: const Icon(Icons.chevron_right),
          onTap: () {
            // TODO: Show help
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Help & support coming soon')),
            );
          },
        ),
      ],
    );
  }

  Widget _buildAccountSection(BuildContext context) {
    return Column(
      children: [
        ListTile(
          leading: const Icon(Icons.calendar_month, color: Colors.blue),
          title: const Text('My Availability'),
          subtitle: const Text('Set your working days and hours'),
          trailing: const Icon(Icons.chevron_right),
          onTap: () {
            // Navigate to Availability Screen
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const AvailabilityScreen()),
            );
          },
        ),
      ],
    );
  }

  Widget _buildDangerZone(BuildContext context) {
    return Column(
      children: [
        ListTile(
          leading: const Icon(Icons.lock_reset, color: Colors.orange),
          title: const Text('Change Password'),
          trailing: const Icon(Icons.chevron_right),
          onTap: () {
            // Navigate to forgot password screen
            Navigator.pushNamed(context, '/reset-password');
          },
        ),
        ListTile(
          leading: const Icon(Icons.logout, color: Colors.red),
          title: const Text(
            'Logout',
            style: TextStyle(color: Colors.red),
          ),
          onTap: () => _showLogoutDialog(context),
        ),
      ],
    );
  }

  String _getThemeName(ThemeMode mode) {
    switch (mode) {
      case ThemeMode.light:
        return 'Light';
      case ThemeMode.dark:
        return 'Dark';
      case ThemeMode.system:
        return 'System default';
    }
  }

  void _showThemeDialog(ThemeMode currentMode) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Choose Theme'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            RadioListTile<ThemeMode>(
              title: const Text('Light'),
              value: ThemeMode.light,
              groupValue: currentMode,
              onChanged: (value) {
                ref.read(themeModeProvider.notifier).setThemeMode(value!);
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('✓ Light theme activated'),
                    backgroundColor: Colors.green,
                  ),
                );
              },
            ),
            RadioListTile<ThemeMode>(
              title: const Text('Dark'),
              value: ThemeMode.dark,
              groupValue: currentMode,
              onChanged: (value) {
                ref.read(themeModeProvider.notifier).setThemeMode(value!);
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('✓ Dark theme activated'),
                    backgroundColor: Colors.green,
                  ),
                );
              },
            ),
            RadioListTile<ThemeMode>(
              title: const Text('System default'),
              value: ThemeMode.system,
              groupValue: currentMode,
              onChanged: (value) {
                ref.read(themeModeProvider.notifier).setThemeMode(value!);
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('✓ Using system theme'),
                    backgroundColor: Colors.green,
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showLanguageDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Choose Language'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            RadioListTile<String>(
              title: const Text('English'),
              value: 'English',
              groupValue: _language,
              onChanged: (value) {
                setState(() => _language = value!);
                Navigator.pop(context);
              },
            ),
            RadioListTile<String>(
              title: const Text('Kiswahili'),
              value: 'Kiswahili',
              groupValue: _language,
              onChanged: (value) {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Swahili language coming soon')),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
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
          FilledButton(
            onPressed: () async {
              Navigator.pop(context);

              // Show loading
              showDialog(
                context: context,
                barrierDismissible: false,
                builder: (context) => const Center(
                  child: CircularProgressIndicator(),
                ),
              );

              try {
                final authActions = ref.read(authActionsProvider);
                await authActions.signOut();

                if (mounted) {
                  Navigator.pop(context); // Close loading dialog

                  // Navigate to login and clear all routes
                  Navigator.of(context).pushNamedAndRemoveUntil(
                    '/login',
                    (route) => false,
                  );

                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('✓ Logged out successfully'),
                      backgroundColor: Colors.green,
                    ),
                  );
                }
              } catch (e) {
                if (mounted) {
                  Navigator.pop(context); // Close loading
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Error logging out: $e'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              }
            },
            style: FilledButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            child: const Text('Logout'),
          ),
        ],
      ),
    );
  }

  Widget _buildDebugSection(BuildContext context) {
    final syncQueueCount = HiveService.getSyncQueueCount();

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          ListTile(
            leading: const Icon(Icons.sync, color: Colors.orange),
            title: const Text('Pending Sync Items'),
            subtitle: Text('$syncQueueCount items waiting to sync'),
            trailing: TextButton(
              onPressed: syncQueueCount > 0
                  ? () async {
                      final confirm = await showDialog<bool>(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text('Clear Sync Queue?'),
                          content: Text(
                              'This will delete $syncQueueCount pending items that failed to sync. '
                              'This data will be lost. Are you sure?'),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context, false),
                              child: const Text('Cancel'),
                            ),
                            TextButton(
                              onPressed: () => Navigator.pop(context, true),
                              style: TextButton.styleFrom(
                                  foregroundColor: Colors.red),
                              child: const Text('Clear'),
                            ),
                          ],
                        ),
                      );

                      if (confirm == true) {
                        await HiveService.getBox('sync_queue').clear();
                        if (mounted) {
                          setState(() {}); // Refresh UI
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('✓ Sync queue cleared'),
                              backgroundColor: Colors.green,
                            ),
                          );
                        }
                      }
                    }
                  : null,
              child: const Text('Clear'),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.storage, color: Colors.orange),
            title: const Text('Clear All Cached Data'),
            subtitle: const Text('Remove all offline data'),
            trailing: TextButton(
              onPressed: () async {
                final confirm = await showDialog<bool>(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('Clear All Cache?'),
                    content: const Text(
                        'This will delete all cached data including patients, appointments, etc. '
                        'Data on the server will not be affected. Are you sure?'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context, false),
                        child: const Text('Cancel'),
                      ),
                      TextButton(
                        onPressed: () => Navigator.pop(context, true),
                        style:
                            TextButton.styleFrom(foregroundColor: Colors.red),
                        child: const Text('Clear All'),
                      ),
                    ],
                  ),
                );

                if (confirm == true) {
                  await HiveService.clearAllCache();
                  if (mounted) {
                    setState(() {});
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('✓ All cached data cleared'),
                        backgroundColor: Colors.green,
                      ),
                    );
                  }
                }
              },
              child: const Text('Clear All'),
            ),
          ),
        ],
      ),
    );
  }
}

class _ProfileCard extends ConsumerWidget {
  final dynamic profile;

  const _ProfileCard({required this.profile});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final facilityAsync = profile.facilityId != null
        ? ref.watch(facilityByIdProvider(profile.facilityId!))
        : const AsyncValue.data(null);

    return Card(
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            // Avatar
            CircleAvatar(
              radius: 40,
              backgroundColor: Theme.of(context).colorScheme.primary,
              child: Text(
                profile.fullName.isNotEmpty
                    ? profile.fullName[0].toUpperCase()
                    : 'U',
                style: const TextStyle(
                  fontSize: 32,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(width: 16),

            // Profile Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    profile.fullName,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    profile.email,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.blue[50],
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          profile.role.toUpperCase(),
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.blue[700],
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),

                      // Facility Badge
                      if (facilityAsync is AsyncData<Facility?> &&
                          facilityAsync.value != null) ...[
                        const SizedBox(width: 8),
                        Flexible(
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.orange[50],
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: Colors.orange[200]!),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.local_hospital,
                                    size: 12, color: Colors.orange[800]),
                                const SizedBox(width: 4),
                                Flexible(
                                  child: Text(
                                    facilityAsync.value!.name,
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.orange[900],
                                      fontWeight: FontWeight.w500,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),

            // Edit Button
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () async {
                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const EditProfileScreen(),
                  ),
                );

                // Refresh if profile was updated
                if (result == true) {
                  ref.invalidate(currentUserProfileProvider);
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
