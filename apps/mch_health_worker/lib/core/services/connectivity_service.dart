import 'dart:async';
import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Service to monitor network connectivity (Windows-compatible)
/// Uses actual HTTP request to check connectivity, bypasses broken connectivity_plus
class ConnectivityService {
  StreamController<bool>? _connectionStatusController;
  Timer? _pollingTimer;
  
  bool _isOnline = true; // Assume online by default

  /// Initialize connectivity monitoring
  ConnectivityService() {
    _connectionStatusController = StreamController<bool>.broadcast();
    _startMonitoring();
  }

  /// Get current online status
  bool get isOnline => _isOnline;

  /// Stream of connectivity changes
  Stream<bool> get connectionStatus => _connectionStatusController!.stream;

  /// Check if device is currently connected (using real HTTP request)
  Future<bool> isConnected() async {
    return await _checkInternetAccess();
  }

  /// Actually check internet by making a request
  Future<bool> _checkInternetAccess() async {
    try {
      // Try to connect to a reliable server
      final result = await InternetAddress.lookup('google.com')
          .timeout(const Duration(seconds: 3));
      return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
    } on SocketException catch (_) {
      return false;
    } on TimeoutException catch (_) {
      return false;
    } catch (e) {
      print('⚠️ Internet check error: $e');
      return false;
    }
  }

  /// Start monitoring connectivity changes
  void _startMonitoring() async {
    // Check initial status
    _isOnline = await _checkInternetAccess();
    print(_isOnline ? '🟢 Initial: Online' : '🔴 Initial: Offline');
    
    // Start polling every 5 seconds
    _startPolling();
    
    print('🟢 Connectivity service initialized (HTTP check mode)');
  }

  /// Start polling for connectivity
  void _startPolling() {
    if (_pollingTimer != null) return; // Already polling
    
    _pollingTimer = Timer.periodic(const Duration(seconds: 5), (_) async {
      final wasOnline = _isOnline;
      _isOnline = await _checkInternetAccess();
      
      if (wasOnline != _isOnline) {
        _connectionStatusController?.add(_isOnline);
        print(_isOnline ? '🟢 Now Online' : '🔴 Now Offline');
      }
    });
  }

  /// Dispose resources
  void dispose() {
    _pollingTimer?.cancel();
    _connectionStatusController?.close();
    print('✅ Connectivity service disposed');
  }
}

/// Provider for connectivity service
final connectivityServiceProvider = Provider<ConnectivityService>((ref) {
  final service = ConnectivityService();
  
  ref.onDispose(() {
    service.dispose();
  });
  
  return service;
});

/// Provider for current connectivity status
final connectivityStatusProvider = StreamProvider<bool>((ref) {
  final service = ref.watch(connectivityServiceProvider);
  return service.connectionStatus;
});

/// Provider to check if currently online
final isOnlineProvider = Provider<bool>((ref) {
  final service = ref.watch(connectivityServiceProvider);
  return service.isOnline;
});