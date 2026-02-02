import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:easy_localization/easy_localization.dart';
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
        title: Text('settings.title'.tr()),
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
            _buildSectionHeader('settings.notifications_section'.tr()),
            _buildNotificationSettings(context, ref, notificationSettings),

            // Theme Section
            _buildSectionHeader('settings.appearance_section'.tr()),
            _buildThemeSettings(context, ref, themeMode),

            // Language Section
            _buildSectionHeader('settings.language_section'.tr()),
            _buildLanguageSettings(context),

            // About Section
            _buildSectionHeader('settings.about_section'.tr()),
            _buildAboutSection(context),

            // Account Section
            _buildSectionHeader('settings.account_section'.tr()),
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
    final textColor = Theme.of(context).textTheme.bodyLarge?.color ??
        Theme.of(context).colorScheme.onSurface;
    final subtitleColor = Theme.of(context).textTheme.bodySmall?.color ??
        Theme.of(context).colorScheme.onSurface.withOpacity(0.7);

    return _SettingsCard(
      children: [
        SwitchListTile(
          title: Text(
            'settings.enable_notifications'.tr(),
            style: TextStyle(color: textColor, fontWeight: FontWeight.w500),
          ),
          subtitle: Text(
            'settings.receive_reminders'.tr(),
            style: TextStyle(color: subtitleColor, fontSize: 12),
          ),
          value: settings.enabled,
          onChanged: (value) async {
            await ref
                .read(notificationSettingsProvider.notifier)
                .setEnabled(value);
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
            'settings.appointment_reminders'.tr(),
            style: TextStyle(
              color: settings.enabled ? textColor : Colors.grey,
              fontWeight: FontWeight.w500,
            ),
          ),
          subtitle: Text(
            'settings.upcoming_clinic_visits'.tr(),
            style: TextStyle(
              color: settings.enabled ? subtitleColor : Colors.grey.shade400,
              fontSize: 12,
            ),
          ),
          value: settings.appointmentReminders && settings.enabled,
          onChanged: settings.enabled
              ? (value) {
                  ref
                      .read(notificationSettingsProvider.notifier)
                      .setAppointmentReminders(value);
                }
              : null,
          contentPadding: const EdgeInsets.only(left: 72, right: 16),
        ),
        const Divider(indent: 72),
        SwitchListTile(
          title: Text(
            'settings.vaccine_reminders'.tr(),
            style: TextStyle(
              color: settings.enabled ? textColor : Colors.grey,
              fontWeight: FontWeight.w500,
            ),
          ),
          subtitle: Text(
            'settings.due_immunizations'.tr(),
            style: TextStyle(
              color: settings.enabled ? subtitleColor : Colors.grey.shade400,
              fontSize: 12,
            ),
          ),
          value: settings.vaccineReminders && settings.enabled,
          onChanged: settings.enabled
              ? (value) {
                  ref
                      .read(notificationSettingsProvider.notifier)
                      .setVaccineReminders(value);
                }
              : null,
          contentPadding: const EdgeInsets.only(left: 72, right: 16),
        ),
        const Divider(indent: 72),
        SwitchListTile(
          title: Text(
            'settings.visit_reminders'.tr(),
            style: TextStyle(
              color: settings.enabled ? textColor : Colors.grey,
              fontWeight: FontWeight.w500,
            ),
          ),
          subtitle: Text(
            'settings.anc_pnc_visits'.tr(),
            style: TextStyle(
              color: settings.enabled ? subtitleColor : Colors.grey.shade400,
              fontSize: 12,
            ),
          ),
          value: settings.visitReminders && settings.enabled,
          onChanged: settings.enabled
              ? (value) {
                  ref
                      .read(notificationSettingsProvider.notifier)
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
            'settings.theme'.tr(),
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
    final currentLang = context.locale.languageCode == 'sw'
        ? 'settings.swahili'.tr()
        : 'settings.english'.tr();

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
            'profile.language'.tr(),
            style: TextStyle(color: textColor, fontWeight: FontWeight.w500),
          ),
          subtitle: Text(
            currentLang,
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
            'settings.app_version'.tr(),
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
            'settings.mch_handbook'.tr(),
            style: TextStyle(color: textColor, fontWeight: FontWeight.w500),
          ),
          subtitle: Text(
            'settings.kenya_mch_handbook'.tr(),
            style: TextStyle(color: subtitleColor, fontSize: 12),
          ),
          trailing: const Icon(Icons.chevron_right, color: Colors.grey),
          onTap: () => context.push('/handbook'),
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
            'settings.privacy_policy'.tr(),
            style: TextStyle(color: textColor, fontWeight: FontWeight.w500),
          ),
          trailing: const Icon(Icons.chevron_right, color: Colors.grey),
          onTap: () => context.push('/privacy'),
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
            'settings.help_support'.tr(),
            style: TextStyle(color: textColor, fontWeight: FontWeight.w500),
          ),
          trailing: const Icon(Icons.chevron_right, color: Colors.grey),
          onTap: () => context.push('/help'),
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
            'settings.change_password'.tr(),
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
          title: Text(
            'settings.logout'.tr(),
            style:
                const TextStyle(color: Colors.red, fontWeight: FontWeight.w500),
          ),
          onTap: () => _showLogoutDialog(context, ref),
        ),
      ],
    );
  }

  String _getThemeName(ThemeMode mode) {
    switch (mode) {
      case ThemeMode.light:
        return 'settings.theme_light'.tr();
      case ThemeMode.dark:
        return 'settings.theme_dark'.tr();
      case ThemeMode.system:
        return 'settings.theme_system'.tr();
    }
  }

  void _showThemeDialog(
      BuildContext context, WidgetRef ref, ThemeMode currentMode) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('settings.choose_theme'.tr()),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            RadioListTile<ThemeMode>(
              title: Text('settings.theme_light'.tr()),
              value: ThemeMode.light,
              groupValue: currentMode,
              onChanged: (value) {
                ref.read(themeModeProvider.notifier).setThemeMode(value!);
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('✓ ${'settings.light_activated'.tr()}'),
                    backgroundColor: Colors.green,
                  ),
                );
              },
            ),
            RadioListTile<ThemeMode>(
              title: Text('settings.theme_dark'.tr()),
              value: ThemeMode.dark,
              groupValue: currentMode,
              onChanged: (value) {
                ref.read(themeModeProvider.notifier).setThemeMode(value!);
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('✓ ${'settings.dark_activated'.tr()}'),
                    backgroundColor: Colors.green,
                  ),
                );
              },
            ),
            RadioListTile<ThemeMode>(
              title: Text('settings.theme_system'.tr()),
              value: ThemeMode.system,
              groupValue: currentMode,
              onChanged: (value) {
                ref.read(themeModeProvider.notifier).setThemeMode(value!);
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('✓ ${'settings.using_system'.tr()}'),
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
    final currentLocale = context.locale;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('settings.select_language'.tr()),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            RadioListTile<String>(
              title: const Text('English'),
              value: 'en',
              groupValue: currentLocale.languageCode,
              onChanged: (value) {
                context.setLocale(const Locale('en'));
                Navigator.pop(context);
              },
            ),
            RadioListTile<String>(
              title: const Text('Kiswahili'),
              value: 'sw',
              groupValue: currentLocale.languageCode,
              onChanged: (value) {
                context.setLocale(const Locale('sw'));
                Navigator.pop(context);
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
        title: Text('settings.logout'.tr()),
        content: Text('settings.logout_confirm'.tr()),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('common.cancel'.tr()),
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
            child: Text('settings.logout'.tr()),
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
        color: Theme.of(context).cardTheme.color ??
            (isDark ? const Color(0xFF1E1E1E) : Colors.white),
        borderRadius: BorderRadius.circular(12),
        boxShadow: isDark
            ? null
            : [
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
