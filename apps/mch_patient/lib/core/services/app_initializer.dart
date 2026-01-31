import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'notification_service.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

/// App Initializer Service
/// Handles all app initialization in one place with progress tracking
class AppInitializer {
  static final AppInitializer _instance = AppInitializer._internal();
  factory AppInitializer() => _instance;
  AppInitializer._internal();

  bool _isInitialized = false;
  String _currentStep = '';
  double _progress = 0.0;
  String? _error;

  bool get isInitialized => _isInitialized;
  String get currentStep => _currentStep;
  double get progress => _progress;
  String? get error => _error;
  bool get hasError => _error != null;

  /// Supabase configuration from compile-time environment variables
  /// Set via --dart-define during build for better security
  static const String _supabaseUrl = String.fromEnvironment('SUPABASE_URL');
  static const String _supabaseAnonKey =
      String.fromEnvironment('SUPABASE_ANON_KEY');

  /// Initialize all app services
  /// Returns true if successful, false if failed

  Future<bool> initialize({
    void Function(String step, double progress)? onProgress,
  }) async {
    if (_isInitialized) return true;

    _error = null;

    try {
      // Step 1: Validate configuration (20%)
      _updateProgress('Loading configuration...', 0.0, onProgress);

      String url = _supabaseUrl;
      String key = _supabaseAnonKey;

      // specific logic to load from .env if dart-define is missing
      if (url.isEmpty || key.isEmpty) {
        try {
          await dotenv.load(fileName: ".env");
          url = dotenv.env['SUPABASE_URL'] ?? '';
          key = dotenv.env['SUPABASE_ANON_KEY'] ?? '';
        } catch (e) {
          debugPrint('Failed to load .env: $e');
        }
      }

      if (url.isEmpty || key.isEmpty) {
        throw Exception('Missing Supabase configuration. '
            'Build with: flutter run --dart-define=SUPABASE_URL=xxx --dart-define=SUPABASE_ANON_KEY=xxx '
            'OR ensure .env file exists with SUPABASE_URL and SUPABASE_ANON_KEY');
      }
      _updateProgress('Configuration loaded', 0.2, onProgress);

      // Step 2: Initialize Hive for offline storage (40%)
      _updateProgress('Setting up offline storage...', 0.2, onProgress);
      await Hive.initFlutter();
      _updateProgress('Offline storage ready', 0.4, onProgress);

      // Step 3: Initialize Supabase (70%)
      _updateProgress('Connecting to server...', 0.4, onProgress);

      await Supabase.initialize(
        url: url,
        anonKey: key,
      );
      _updateProgress('Connected to server', 0.7, onProgress);

      // Step 4: Initialize Notifications (90%)
      _updateProgress('Setting up notifications...', 0.7, onProgress);
      await NotificationService().initialize();
      _updateProgress('Notifications ready', 0.9, onProgress);

      // Step 5: Final checks (100%)
      _updateProgress('Almost ready...', 0.9, onProgress);
      await Future.delayed(
          const Duration(milliseconds: 300)); // Small delay for UX
      _updateProgress('Ready!', 1.0, onProgress);

      _isInitialized = true;
      debugPrint('✅ App initialization complete');
      return true;
    } catch (e) {
      _error = e.toString();
      debugPrint('❌ App initialization failed: $e');
      return false;
    }
  }

  void _updateProgress(
      String step, double progress, void Function(String, double)? callback) {
    _currentStep = step;
    _progress = progress;
    callback?.call(step, progress);
  }

  /// Check if user is authenticated
  bool get isAuthenticated {
    try {
      return Supabase.instance.client.auth.currentUser != null;
    } catch (e) {
      return false;
    }
  }

  /// Get current user
  User? get currentUser {
    try {
      return Supabase.instance.client.auth.currentUser;
    } catch (e) {
      return null;
    }
  }

  /// Reset initialization state (for testing or retry)
  void reset() {
    _isInitialized = false;
    _currentStep = '';
    _progress = 0.0;
    _error = null;
  }
}
