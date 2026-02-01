import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:mch_core/mch_core.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/providers/supabase_providers.dart';
import '../../services/pdf_export_service.dart';
import '../../services/csv_export_service.dart';
import '../widgets/export_button.dart';
import '../../../patient_management/presentation/screens/patient_detail_screen.dart';
import '../../../patient_management/presentation/screens/book_appointment_screen.dart';

/// Patients Due Soon Report Screen
/// Shows patients with EDD within the next 30 days, sorted by urgency
class PatientsDueSoonScreen extends ConsumerStatefulWidget {
  const PatientsDueSoonScreen({super.key});

  @override
  ConsumerState<PatientsDueSoonScreen> createState() => _PatientsDueSoonScreenState();
}

class _PatientsDueSoonScreenState extends ConsumerState<PatientsDueSoonScreen> {
  bool _isExporting = false;
  List<MaternalProfile> _currentData = [];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final patientsAsync = ref.watch(profilesDueSoonProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Patients Due Soon'),
        actions: [
          ExportButton(
            isLoading: _isExporting,
            onExportPdf: _currentData.isNotEmpty ? _exportPdf : null,
            onExportCsv: _currentData.isNotEmpty ? _exportCsv : null,
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => ref.invalidate(profilesDueSoonProvider),
            tooltip: 'Refresh',
          ),
        ],
      ),
      body: patientsAsync.when(
        data: (patients) {
          if (patients.isEmpty) {
            return _buildEmptyState(theme);
          }

          // Sort by EDD ascending (soonest first)
          final sorted = [...patients]..sort((a, b) {
            if (a.edd == null) return 1;
            if (b.edd == null) return -1;
            return a.edd!.compareTo(b.edd!);
          });
          _currentData = sorted;

          // Group by urgency
          final urgent = sorted.where((p) => _daysUntilEdd(p) <= 7).toList();
          final soon = sorted.where((p) => _daysUntilEdd(p) > 7 && _daysUntilEdd(p) <= 14).toList();
          final upcoming = sorted.where((p) => _daysUntilEdd(p) > 14).toList();

          return RefreshIndicator(
            onRefresh: () async {
              ref.invalidate(profilesDueSoonProvider);
            },
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                // Summary header
                _buildSummaryHeader(theme, sorted),
                const SizedBox(height: 16),

                // Urgent section (< 7 days)
                if (urgent.isNotEmpty) ...[
                  _buildSectionHeader(theme, 'Due Within 7 Days', Colors.red, urgent.length),
                  ...urgent.map((p) => _buildPatientCard(context, ref, theme, p, Colors.red)),
                  const SizedBox(height: 16),
                ],

                // Soon section (7-14 days)
                if (soon.isNotEmpty) ...[
                  _buildSectionHeader(theme, 'Due in 1-2 Weeks', Colors.orange, soon.length),
                  ...soon.map((p) => _buildPatientCard(context, ref, theme, p, Colors.orange)),
                  const SizedBox(height: 16),
                ],

                // Upcoming section (14-30 days)
                if (upcoming.isNotEmpty) ...[
                  _buildSectionHeader(theme, 'Due in 2-4 Weeks', Colors.blue, upcoming.length),
                  ...upcoming.map((p) => _buildPatientCard(context, ref, theme, p, Colors.blue)),
                ],
              ],
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error_outline, size: 64, color: theme.colorScheme.error),
              const SizedBox(height: 16),
              Text('Error loading report', style: theme.textTheme.titleLarge),
              const SizedBox(height: 8),
              Text(error.toString(), textAlign: TextAlign.center),
              const SizedBox(height: 16),
              FilledButton.icon(
                onPressed: () => ref.invalidate(profilesDueSoonProvider),
                icon: const Icon(Icons.refresh),
                label: const Text('Retry'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _exportPdf() async {
    setState(() => _isExporting = true);
    try {
      final pdfBytes = await PdfExportService.generateDueSoonReport(
        patients: _currentData,
        facilityName: 'MCH Facility',
      );
      await PdfExportService.sharePdf(pdfBytes, 'patients_due_soon');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('PDF exported successfully')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Export failed: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _isExporting = false);
    }
  }

  Future<void> _exportCsv() async {
    setState(() => _isExporting = true);
    try {
      final filePath = await CsvExportService.exportPatientsDueSoon(
        patients: _currentData,
        facilityName: 'MCH Facility',
      );
      await CsvExportService.shareFile(filePath);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('CSV exported successfully')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Export failed: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _isExporting = false);
    }
  }

  int _daysUntilEdd(MaternalProfile profile) {
    if (profile.edd == null) return 999;
    return profile.edd!.difference(DateTime.now()).inDays;
  }

  Widget _buildSummaryHeader(ThemeData theme, List<MaternalProfile> patients) {
    final urgentCount = patients.where((p) => _daysUntilEdd(p) <= 7).length;
    
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.pink.shade700, Colors.pink.shade500],
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          const Icon(Icons.pregnant_woman, color: Colors.white, size: 40),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${patients.length} Patients Due Soon',
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '$urgentCount need immediate attention (< 7 days)',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: Colors.white70,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(ThemeData theme, String title, Color color, int count) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Container(
            width: 4,
            height: 24,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(width: 8),
          Text(
            title,
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const Spacer(),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              '$count',
              style: theme.textTheme.labelMedium?.copyWith(
                color: color,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPatientCard(BuildContext context, WidgetRef ref, ThemeData theme, MaternalProfile patient, Color urgencyColor) {
    final daysLeft = _daysUntilEdd(patient);
    
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: urgencyColor.withValues(alpha: 0.3)),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () => _navigateToProfile(context, patient.id!),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              // Days countdown
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: urgencyColor.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '$daysLeft',
                      style: theme.textTheme.headlineSmall?.copyWith(
                        color: urgencyColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'days',
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: urgencyColor,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              
              // Patient info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      patient.clientName,
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      patient.ancNumber,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(Icons.calendar_today, size: 14, color: theme.colorScheme.primary),
                        const SizedBox(width: 4),
                        Text(
                          patient.edd != null 
                              ? 'EDD: ${DateFormat('MMM dd, yyyy').format(patient.edd!)}'
                              : 'EDD: Not set',
                          style: theme.textTheme.bodySmall,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              
              // Quick actions
              Column(
                children: [
                  IconButton(
                    icon: const Icon(Icons.phone_outlined),
                    onPressed: () => _callPatient(context, patient.telephone),
                    tooltip: 'Call',
                    iconSize: 20,
                  ),
                  IconButton(
                    icon: const Icon(Icons.calendar_month_outlined),
                    onPressed: () => _bookAppointment(context, patient.id!),
                    tooltip: 'Book',
                    iconSize: 20,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState(ThemeData theme) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.event_available, size: 80, color: Colors.green.shade300),
          const SizedBox(height: 16),
          Text(
            'No Patients Due Soon',
            style: theme.textTheme.titleLarge,
          ),
          const SizedBox(height: 8),
          Text(
            'There are no patients with EDD in the next 30 days.',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
            ),
          ),
        ],
      ),
    );
  }

  void _navigateToProfile(BuildContext context, String patientId) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PatientDetailScreen(patientId: patientId),
      ),
    );
  }

  void _bookAppointment(BuildContext context, String patientId) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => BookAppointmentScreen(patientId: patientId),
      ),
    );
  }

  Future<void> _callPatient(BuildContext context, String? phoneNumber) async {
    if (phoneNumber == null || phoneNumber.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No phone number available')),
      );
      return;
    }
    
    final uri = Uri.parse('tel:$phoneNumber');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }
}
