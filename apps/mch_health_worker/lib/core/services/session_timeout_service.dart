import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Automatically signs the user out after [_timeoutDuration] of inactivity.
class SessionTimeoutService {
  static const _timeoutDuration = Duration(minutes: 10);
  
  Timer? _timer;
  final VoidCallback onTimeout;

  SessionTimeoutService({required this.onTimeout});

  void resetTimer() {
    _timer?.cancel();
    _timer = Timer(_timeoutDuration, onTimeout);
  }

  void dispose() => _timer?.cancel();
}

final sessionTimeoutProvider = Provider<SessionTimeoutService>((ref) {
  final service = SessionTimeoutService(
    onTimeout: () async {
      await Supabase.instance.client.auth.signOut();
    },
  );
  ref.onDispose(service.dispose);
  return service;
});
