import 'package:flutter/material.dart';

/// Export Button Widget with PDF and CSV options
/// Shows a dropdown with export format choices
class ExportButton extends StatelessWidget {
  final VoidCallback? onExportPdf;
  final VoidCallback? onExportCsv;
  final bool isLoading;

  const ExportButton({
    super.key,
    this.onExportPdf,
    this.onExportCsv,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Padding(
        padding: EdgeInsets.all(12),
        child: SizedBox(
          width: 24,
          height: 24,
          child: CircularProgressIndicator(strokeWidth: 2),
        ),
      );
    }

    return PopupMenuButton<String>(
      icon: const Icon(Icons.download),
      tooltip: 'Export Report',
      onSelected: (value) {
        if (value == 'pdf' && onExportPdf != null) {
          onExportPdf!();
        } else if (value == 'csv' && onExportCsv != null) {
          onExportCsv!();
        }
      },
      itemBuilder: (context) => [
        PopupMenuItem(
          value: 'pdf',
          enabled: onExportPdf != null,
          child: Row(
            children: [
              Icon(Icons.picture_as_pdf, 
                  color: onExportPdf != null ? Colors.red : Colors.grey),
              const SizedBox(width: 12),
              const Text('Export as PDF'),
            ],
          ),
        ),
        PopupMenuItem(
          value: 'csv',
          enabled: onExportCsv != null,
          child: Row(
            children: [
              Icon(Icons.table_chart, 
                  color: onExportCsv != null ? Colors.green : Colors.grey),
              const SizedBox(width: 12),
              const Text('Export as CSV'),
            ],
          ),
        ),
      ],
    );
  }
}

/// Full-width export buttons for use in dialogs or bottom sheets
class ExportOptionsSheet extends StatelessWidget {
  final VoidCallback? onExportPdf;
  final VoidCallback? onExportCsv;
  final VoidCallback? onPrint;
  final String reportName;

  const ExportOptionsSheet({
    super.key,
    this.onExportPdf,
    this.onExportCsv,
    this.onPrint,
    required this.reportName,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Export $reportName',
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 24),
          if (onPrint != null)
            _buildExportOption(
              context,
              icon: Icons.print,
              label: 'Print Report',
              subtitle: 'Send to printer or save as PDF',
              color: Colors.blue,
              onTap: () {
                Navigator.pop(context);
                onPrint!();
              },
            ),
          if (onExportPdf != null)
            _buildExportOption(
              context,
              icon: Icons.picture_as_pdf,
              label: 'Share as PDF',
              subtitle: 'Export and share PDF file',
              color: Colors.red,
              onTap: () {
                Navigator.pop(context);
                onExportPdf!();
              },
            ),
          if (onExportCsv != null)
            _buildExportOption(
              context,
              icon: Icons.table_chart,
              label: 'Export as CSV',
              subtitle: 'For Excel or spreadsheet analysis',
              color: Colors.green,
              onTap: () {
                Navigator.pop(context);
                onExportCsv!();
              },
            ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildExportOption(
    BuildContext context, {
    required IconData icon,
    required String label,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: color.withValues(alpha: 0.15),
        child: Icon(icon, color: color),
      ),
      title: Text(label),
      subtitle: Text(subtitle),
      onTap: onTap,
    );
  }
}

/// Show export options as a bottom sheet
Future<void> showExportOptionsSheet(
  BuildContext context, {
  required String reportName,
  VoidCallback? onExportPdf,
  VoidCallback? onExportCsv,
  VoidCallback? onPrint,
}) {
  return showModalBottomSheet(
    context: context,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
    ),
    builder: (context) => ExportOptionsSheet(
      reportName: reportName,
      onExportPdf: onExportPdf,
      onExportCsv: onExportCsv,
      onPrint: onPrint,
    ),
  );
}
