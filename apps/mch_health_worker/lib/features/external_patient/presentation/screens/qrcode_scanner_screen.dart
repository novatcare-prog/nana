import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import '../../providers/external_patient_provider.dart';
import 'external_patient_view_screen.dart';

class QrCodeScannerScreen extends ConsumerStatefulWidget {
  const QrCodeScannerScreen({super.key});

  @override
  ConsumerState<QrCodeScannerScreen> createState() =>
      _QrCodeScannerScreenState();
}

class _QrCodeScannerScreenState extends ConsumerState<QrCodeScannerScreen> {
  final TextEditingController _codeController = TextEditingController();
  bool _isLoading = false;
  MobileScannerController cameraController = MobileScannerController();

  Future<void> _processCode(String code) async {
    if (_isLoading) return;
    setState(() => _isLoading = true);

    try {
      // Call provider to fetch data
      // We use ref.read(fetchExternalPatientProvider(code).future) to trigger the fetch
      await ref.read(fetchExternalPatientProvider(code).future);

      if (mounted) {
        // Navigate to view screen
        // Replace current route so back button goes to dashboard, not scanner
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const ExternalPatientViewScreen()),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content:
                  Text('Error: ${e.toString().replaceAll("Exception:", "")}'),
              backgroundColor: Colors.red),
        );
        setState(() => _isLoading = false);
        // Resume camera if it was paused
        cameraController.start();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Scan Patient Code')),
      body: Column(
        children: [
          // Scanner Area
          Expanded(
            flex: 2,
            child: MobileScanner(
              controller: cameraController,
              onDetect: (capture) {
                final List<Barcode> barcodes = capture.barcodes;
                for (final barcode in barcodes) {
                  if (barcode.rawValue != null) {
                    cameraController.stop(); // Stop scanning once detected
                    _processCode(barcode.rawValue!);
                    break;
                  }
                }
              },
            ),
          ),

          // Manual Entry Area
          Expanded(
            flex: 1,
            child: Container(
              padding: const EdgeInsets.all(24),
              color: Colors.white,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text(
                    'Or enter 6-digit code manually:',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _codeController,
                          keyboardType: TextInputType.number,
                          maxLength: 6,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            hintText: '123456',
                            counterText: "",
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      FilledButton(
                        onPressed: _isLoading
                            ? null
                            : () => _processCode(_codeController.text),
                        child: _isLoading
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                    strokeWidth: 2, color: Colors.white))
                            : const Text('GO'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
