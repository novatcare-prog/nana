import 'package:flutter/material.dart';
import 'pdf_viewer_screen.dart';

class HandbookScreen extends StatelessWidget {
  const HandbookScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('MCH Handbook'),
        backgroundColor: const Color(0xFFE91E63), // Pink theme
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.blue[50],
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.menu_book_rounded,
                size: 80,
                color: Colors.blue,
              ),
            ),
            const SizedBox(height: 32),
            const Text(
              'Mother & Child Health Handbook',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Text(
              'Access the complete guide for maternal and child health. Read locally or download to your device.',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 48),
            SizedBox(
              width: double.infinity,
              height: 56,
              child: FilledButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const PdfViewerScreen(
                        assetPath: 'assets/pdfs/mch_handbook.pdf',
                        title: 'MCH Handbook',
                      ),
                    ),
                  );
                },
                icon: const Icon(Icons.chrome_reader_mode),
                label: const Text(
                  'Read Handbook',
                  style: TextStyle(fontSize: 18),
                ),
                style: FilledButton.styleFrom(
                  backgroundColor: const Color(0xFFE91E63),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
