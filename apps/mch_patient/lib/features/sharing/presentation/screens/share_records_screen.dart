import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../data/share_repository.dart';

class ShareRecordsScreen extends ConsumerStatefulWidget {
  const ShareRecordsScreen({super.key});

  @override
  ConsumerState<ShareRecordsScreen> createState() => _ShareRecordsScreenState();
}

class _ShareRecordsScreenState extends ConsumerState<ShareRecordsScreen> {
  SharedCode? _accessCode;
  bool _isLoading = true;
  String? _error;
  Timer? _timer;
  Duration _timeLeft = Duration.zero;

  @override
  void initState() {
    super.initState();
    _generateCode();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  Future<void> _generateCode() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final repo = ref.read(shareRecordsRepositoryProvider);
      final code = await repo.generateAccessCode();

      if (mounted) {
        setState(() {
          _accessCode = code;
          _isLoading = false;
          _timeLeft = code.expiresAt.difference(DateTime.now());
        });
        _startTimer();
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = e.toString();
          _isLoading = false;
        });
      }
    }
  }

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_timeLeft.inSeconds <= 0) {
        timer.cancel();
        // Optionally auto-regenerate or show expired state
      } else {
        setState(() {
          _timeLeft = _timeLeft - const Duration(seconds: 1);
        });
      }
    });
  }

  String _formatTime(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return '$minutes:$seconds';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('share.title'.tr()),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Icon(Icons.share_location, size: 64, color: Colors.blue),
              const SizedBox(height: 16),
              Text(
                'share.show_code_title'.tr(),
                textAlign: TextAlign.center,
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 8),
              Text(
                'share.grant_access'.tr(),
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.grey),
              ),
              const SizedBox(height: 32),
              if (_isLoading)
                const CircularProgressIndicator()
              else if (_error != null)
                Column(
                  children: [
                    Text('${_error}',
                        style: const TextStyle(color: Colors.red)),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: _generateCode,
                      child: Text('share.try_again'.tr()),
                    ),
                  ],
                )
              else if (_accessCode != null) ...[
                // QR Code
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 10,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: QrImageView(
                    data: _accessCode!.code,
                    version: QrVersions.auto,
                    size: 200.0,
                  ),
                ),

                const SizedBox(height: 32),

                // Manual Code Display
                Text('share.or_enter_code'.tr(),
                    style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.5,
                        color: Colors.grey)),
                const SizedBox(height: 8),
                Text(
                  _accessCode!.code,
                  style: const TextStyle(
                    fontSize: 48,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 4,
                  ),
                ),

                const SizedBox(height: 24),

                // Timer
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: _timeLeft.inSeconds < 60
                        ? Colors.red[50]
                        : Colors.blue[50],
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.timer,
                          size: 16,
                          color: _timeLeft.inSeconds < 60
                              ? Colors.red
                              : Colors.blue),
                      const SizedBox(width: 8),
                      Text(
                        'share.expires_in'
                            .tr(namedArgs: {'time': _formatTime(_timeLeft)}),
                        style: TextStyle(
                          color: _timeLeft.inSeconds < 60
                              ? Colors.red
                              : Colors.blue,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 32),

                OutlinedButton.icon(
                  onPressed: _generateCode,
                  icon: const Icon(Icons.refresh),
                  label: Text('share.generate_new'.tr()),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
