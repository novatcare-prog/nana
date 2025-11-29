import 'dart:async';
import 'dart:io';

/// Connectivity Service - Monitors internet connection
class ConnectivityService {
  StreamController<bool>? _connectionStatusController;
  Timer? _checkTimer;

  Stream<bool> get connectionStatus {
    _connectionStatusController ??= StreamController<bool>.broadcast();
    
    // Check connection every 10 seconds
    _checkTimer = Timer.periodic(const Duration(seconds: 10), (timer) async {
      final connected = await isConnected();
      _connectionStatusController?.add(connected);
    });

    return _connectionStatusController!.stream;
  }

  /// Check if device has actual internet connection
  Future<bool> isConnected() async {
    try {
      // Try to connect to multiple reliable servers
      final results = await Future.wait([
        _tryConnect('google.com'),
        _tryConnect('cloudflare.com'),
      ]);
      
      // If any connection succeeds, we're online
      return results.any((result) => result == true);
    } catch (e) {
      return false;
    }
  }

  /// Try to connect to a specific host
  Future<bool> _tryConnect(String host) async {
    try {
      final result = await InternetAddress.lookup(host)
          .timeout(const Duration(seconds: 3));
      
      return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
    } catch (_) {
      return false;
    }
  }

  /// Dispose
  void dispose() {
    _checkTimer?.cancel();
    _connectionStatusController?.close();
  }
}