import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

class PdfViewerScreen extends StatefulWidget {
  final String assetPath;
  final String title;

  const PdfViewerScreen({
    super.key,
    required this.assetPath,
    required this.title,
  });

  @override
  State<PdfViewerScreen> createState() => _PdfViewerScreenState();
}

class _PdfViewerScreenState extends State<PdfViewerScreen> {
  String? _localFilePath;
  bool _isLoading = true;
  int _totalPages = 0;
  int _currentPage = 0;
  PDFViewController? _pdfViewController;

  @override
  void initState() {
    super.initState();
    _loadPdfFromAssets();
  }

  /// Copies the asset PDF to a temporary file so the PDFView (and Share) can access it
  Future<void> _loadPdfFromAssets() async {
    try {
      final filename = widget.assetPath.split('/').last;
      final dir = await getApplicationDocumentsDirectory();
      final file = File('${dir.path}/$filename');

      // Check if file already exists to avoid re-copying every time (optional optimization)
      // For development, we overwrite to ensure updates are seen.
      final data = await rootBundle.load(widget.assetPath);
      final bytes = data.buffer.asUint8List();
      await file.writeAsBytes(bytes, flush: true);

      if (mounted) {
        setState(() {
          _localFilePath = file.path;
          _isLoading = false;
        });
      }
    } catch (e) {
      debugPrint('Error loading PDF: $e');
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error loading PDF: $e')),
        );
      }
    }
  }

  Future<void> _sharePdf() async {
    if (_localFilePath == null) return;

    try {
      final file = XFile(_localFilePath!);
      await Share.shareXFiles([file], text: 'Check out the ${widget.title}');
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error sharing file: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          if (!_isLoading && _localFilePath != null)
            IconButton(
              icon: const Icon(Icons.share),
              tooltip: 'Share / Save',
              onPressed: _sharePdf,
            ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _localFilePath == null
              ? const Center(child: Text('Failed to load PDF'))
              : Stack(
                  children: [
                    PDFView(
                      filePath: _localFilePath,
                      enableSwipe: true,
                      swipeHorizontal:
                          false, // Vertical scrolling is standard for docs
                      autoSpacing: true,
                      pageFling: true,
                      pageSnap: false, // Smooth scrolling
                      fitPolicy: FitPolicy.WIDTH,
                      onRender: (pages) {
                        setState(() {
                          _totalPages = pages ?? 0;
                        });
                      },
                      onViewCreated: (PDFViewController pdfViewController) {
                        _pdfViewController = pdfViewController;
                      },
                      onPageChanged: (int? page, int? total) {
                        setState(() {
                          _currentPage = page ?? 0;
                        });
                      },
                      onError: (error) {
                        debugPrint(error.toString());
                      },
                      onPageError: (page, error) {
                        debugPrint('$page: ${error.toString()}');
                      },
                    ),
                    // Optional: Page indicator overlay
                    Positioned(
                      bottom: 20,
                      right: 20,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.6),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          '${_currentPage + 1} / $_totalPages',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
    );
  }
}
