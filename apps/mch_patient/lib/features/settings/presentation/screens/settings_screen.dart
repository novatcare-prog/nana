import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/providers/settings_provider.dart';
import '../../../../core/providers/auth_provider.dart';
import '../../../../core/providers/maternal_profile_provider.dart';
import '../../../../core/services/notification_scheduler.dart';
import '../../../../core/utils/error_helper.dart';

/// Settings Screen
class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);
    final notificationSettings = ref.watch(notificationSettingsProvider);
    final profileAsync = ref.watch(currentMaternalProfileProvider);

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Profile Quick View
            profileAsync.when(
              data: (profile) => _buildProfileCard(context, profile),
              loading: () => const SizedBox.shrink(),
              error: (_, __) => const SizedBox.shrink(),
            ),

            const SizedBox(height: 8),

            // Notifications Section
            _buildSectionHeader('NOTIFICATIONS'),
            _buildNotificationSettings(context, ref, notificationSettings),


            // Theme Section
            _buildSectionHeader('APPEARANCE'),
            _buildThemeSettings(context, ref, themeMode),


            // Language Section
            _buildSectionHeader('LANGUAGE'),
            _buildLanguageSettings(context),


            // About Section
            _buildSectionHeader('ABOUT'),
            _buildAboutSection(context),


            // Account Section
            _buildSectionHeader('ACCOUNT'),
            _buildAccountSection(context, ref),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileCard(BuildContext context, dynamic profile) {
    if (profile == null) return const SizedBox.shrink();

    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFE91E63), Color(0xFFC2185B)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.pink.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 30,
            backgroundColor: Colors.white,
            child: Text(
              profile.clientName.isNotEmpty 
                  ? profile.clientName[0].toUpperCase() 
                  : 'M',
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFFE91E63),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  profile.clientName ?? 'User',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                Text(
                  'ANC: ${profile.ancNumber ?? "N/A"}',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.white.withOpacity(0.1),
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.chevron_right, color: Colors.white),
            onPressed: () => context.push('/profile'),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: Colors.grey[600],
          letterSpacing: 1.2,
        ),
      ),
    );
  }

  Widget _buildNotificationSettings(
    BuildContext context,
    WidgetRef ref,
    NotificationSettings settings,
  ) {
    final textColor = Theme.of(context).textTheme.bodyLarge?.color ?? Colors.black87;
    final subtitleColor = Theme.of(context).textTheme.bodySmall?.color ?? Colors.black54;
    
    return _SettingsCard(
      children: [
        SwitchListTile(
          title: Text(
            'Enable Notifications',
            style: TextStyle(color: textColor, fontWeight: FontWeight.w500),
          ),
          subtitle: Text(
            'Receive reminders and alerts',
            style: TextStyle(color: subtitleColor, fontSize: 12),
          ),
          value: settings.enabled,
          onChanged: (value) async {
            await ref.read(notificationSettingsProvider.notifier).setEnabled(value);
            // Reschedule notifications
            ref.read(notificationSchedulerProvider).scheduleAllNotifications();
          },
          secondary: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.pink.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(Icons.notifications, color: Color(0xFFE91E63)),
          ),
        ),
        const Divider(indent: 72),
        SwitchListTile(
          title: Text(
            'Appointment Reminders',
            style: TextStyle(
              color: settings.enabled ? textColor : Colors.grey,
              fontWeight: FontWeight.w500,
            ),
          ),
          subtitle: Text(
            'Upcoming clinic visits',
            style: TextStyle(
              color: settings.enabled ? subtitleColor : Colors.grey.shade400,
              fontSize: 12,
            ),
          ),
          value: settings.appointmentReminders && settings.enabled,
          onChanged: settings.enabled 
            ? (value) {
                ref.read(notificationSettingsProvider.notifier)
                    .setAppointmentReminders(value);
              }
            : null,
          contentPadding: const EdgeInsets.only(left: 72, right: 16),
        ),
        const Divider(indent: 72),
        SwitchListTile(
          title: Text(
            'Vaccine Reminders',
            style: TextStyle(
              color: settings.enabled ? textColor : Colors.grey,
              fontWeight: FontWeight.w500,
            ),
          ),
          subtitle: Text(
            'Due immunizations',
            style: TextStyle(
              color: settings.enabled ? subtitleColor : Colors.grey.shade400,
              fontSize: 12,
            ),
          ),
          value: settings.vaccineReminders && settings.enabled,
          onChanged: settings.enabled
            ? (value) {
                ref.read(notificationSettingsProvider.notifier)
                    .setVaccineReminders(value);
              }
            : null,
          contentPadding: const EdgeInsets.only(left: 72, right: 16),
        ),
        const Divider(indent: 72),
        SwitchListTile(
          title: Text(
            'Visit Reminders',
            style: TextStyle(
              color: settings.enabled ? textColor : Colors.grey,
              fontWeight: FontWeight.w500,
            ),
          ),
          subtitle: Text(
            'ANC and postnatal visits',
            style: TextStyle(
              color: settings.enabled ? subtitleColor : Colors.grey.shade400,
              fontSize: 12,
            ),
          ),
          value: settings.visitReminders && settings.enabled,
          onChanged: settings.enabled
            ? (value) {
                ref.read(notificationSettingsProvider.notifier)
                    .setVisitReminders(value);
              }
            : null,
          contentPadding: const EdgeInsets.only(left: 72, right: 16),
        ),
      ],
    );
  }

  Widget _buildThemeSettings(
    BuildContext context,
    WidgetRef ref,
    ThemeMode currentMode,
  ) {
    final textColor = Theme.of(context).textTheme.bodyLarge?.color;
    final subtitleColor = Theme.of(context).textTheme.bodySmall?.color;
    
    return _SettingsCard(
      children: [
        ListTile(
          leading: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.purple.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(Icons.brightness_6, color: Colors.purple),
          ),
          title: Text(
            'Theme',
            style: TextStyle(color: textColor, fontWeight: FontWeight.w500),
          ),
          subtitle: Text(
            _getThemeName(currentMode),
            style: TextStyle(color: subtitleColor, fontSize: 12),
          ),
          trailing: const Icon(Icons.chevron_right, color: Colors.grey),
          onTap: () => _showThemeDialog(context, ref, currentMode),
        ),
      ],
    );
  }

  Widget _buildLanguageSettings(BuildContext context) {
    final textColor = Theme.of(context).textTheme.bodyLarge?.color;
    final subtitleColor = Theme.of(context).textTheme.bodySmall?.color;
    
    return _SettingsCard(
      children: [
        ListTile(
          leading: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.blue.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(Icons.language, color: Colors.blue),
          ),
          title: Text(
            'Language / Lugha',
            style: TextStyle(color: textColor, fontWeight: FontWeight.w500),
          ),
          subtitle: Text(
            'English',
            style: TextStyle(color: subtitleColor, fontSize: 12),
          ),
          trailing: const Icon(Icons.chevron_right, color: Colors.grey),
          onTap: () => _showLanguageDialog(context),
        ),
      ],
    );
  }

  Widget _buildAboutSection(BuildContext context) {
    final textColor = Theme.of(context).textTheme.bodyLarge?.color;
    final subtitleColor = Theme.of(context).textTheme.bodySmall?.color;
    
    return _SettingsCard(
      children: [
        ListTile(
          leading: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.grey.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(Icons.info, color: Colors.grey),
          ),
          title: Text(
            'App Version',
            style: TextStyle(color: textColor, fontWeight: FontWeight.w500),
          ),
          subtitle: Text(
            '1.0.0 (Phase 1 MVP)',
            style: TextStyle(color: subtitleColor, fontSize: 12),
          ),
        ),
        const Divider(indent: 72),
        ListTile(
          leading: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.green.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(Icons.book, color: Colors.green),
          ),
          title: Text(
            'MCH Handbook',
            style: TextStyle(color: textColor, fontWeight: FontWeight.w500),
          ),
          subtitle: Text(
            'Kenya MCH Handbook 2020',
            style: TextStyle(color: subtitleColor, fontSize: 12),
          ),
        ),
        const Divider(indent: 72),
        ListTile(
          leading: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.teal.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(Icons.privacy_tip, color: Colors.teal),
          ),
          title: Text(
            'Privacy Policy',
            style: TextStyle(color: textColor, fontWeight: FontWeight.w500),
          ),
          trailing: const Icon(Icons.chevron_right, color: Colors.grey),
          onTap: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Privacy policy coming soon')),
            );
          },
        ),
        const Divider(indent: 72),
        ListTile(
          leading: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.orange.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(Icons.help, color: Colors.orange),
          ),
          title: Text(
            'Help & Support',
            style: TextStyle(color: textColor, fontWeight: FontWeight.w500),
          ),
          trailing: const Icon(Icons.chevron_right, color: Colors.grey),
          onTap: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Help & support coming soon')),
            );
          },
        ),
      ],
    );
  }

  Widget _buildAccountSection(BuildContext context, WidgetRef ref) {
    final textColor = Theme.of(context).textTheme.bodyLarge?.color;
    
    return _SettingsCard(
      children: [
        ListTile(
          leading: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.orange.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(Icons.lock, color: Colors.orange),
          ),
          title: Text(
            'Change Password',
            style: TextStyle(color: textColor, fontWeight: FontWeight.w500),
          ),
          trailing: const Icon(Icons.chevron_right, color: Colors.grey),
          onTap: () => context.push('/forgot-password'),
        ),
        const Divider(indent: 72),
        ListTile(
          leading: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.red.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(Icons.logout, color: Colors.red),
          ),
          title: const Text(
            'Logout',
            style: TextStyle(color: Colors.red, fontWeight: FontWeight.w500),
          ),
          onTap: () => _showLogoutDialog(context, ref),
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

  void _showThemeDialog(BuildContext context, WidgetRef ref, ThemeMode currentMode) {
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

  void _showLanguageDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Choose Language'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            RadioListTile<String>(
              title: const Text('English'),
              value: 'en',
              groupValue: 'en',
              onChanged: (value) {
                Navigator.pop(context);
              },
            ),
            RadioListTile<String>(
              title: const Text('Kiswahili'),
              value: 'sw',
              groupValue: 'en',
              onChanged: (value) {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Swahili coming soon')),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showLogoutDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to sign out?'),
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
                final authController = ref.read(authControllerProvider);
                await authController.signOut();
                
                if (context.mounted) {
                  Navigator.pop(context); // Close loading
                  context.go('/login');
                }
              } catch (e) {
                if (context.mounted) {
                  Navigator.pop(context); // Close loading
                  ErrorHelper.showErrorSnackbar(context, e);
                }
              }
            },
            style: FilledButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Logout'),
          ),
        ],
      ),
    );
  }
}

/// Settings Card Widget
class _SettingsCard extends StatelessWidget {
  final List<Widget> children;

  const _SettingsCard({required this.children});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: Theme.of(context).cardTheme.color ?? (isDark ? const Color(0xFF1E1E1E) : Colors.white),
        borderRadius: BorderRadius.circular(12),
        boxShadow: isDark ? null : [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: children,
      ),
    );
  }
}

