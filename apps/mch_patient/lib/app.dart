import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:easy_localization/easy_localization.dart';
import 'core/theme/app_theme.dart';
import 'core/router/app_router.dart';
import 'core/providers/settings_provider.dart';
import 'core/services/notification_service.dart';

/// Main App Widget
/// Simplified - just handles theme and routing
/// Initialization happens in SplashScreen
class MCHPatientApp extends ConsumerWidget {
  const MCHPatientApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);
    final themeMode = ref.watch(themeModeProvider);

    // Configure Notification Navigation
    // We do this here because we have access to the router
    NotificationService().onNotificationClick = (payload) {
      if (payload == null) return;

      debugPrint('🚀 Navigating based on notification: $payload');

      if (payload.startsWith('appointment:')) {
        router.go('/appointments');
      } else if (payload.startsWith('vaccination:')) {
        // Ideally go to specific child, but for now list is safe
        router.go('/children');
      } else if (payload == 'pregnancy_tip' || payload == 'health_tip') {
        router.go('/handbook');
      } else if (payload == 'family_planning') {
        router.go('/family-planning');
      } else {
        // Default fallbacks
        router.go('/home');
      }
    };

    return MaterialApp.router(
      title: 'app_name'.tr(),
      routerConfig: router,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themeMode,
      // Localization
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
    );
  }
}
