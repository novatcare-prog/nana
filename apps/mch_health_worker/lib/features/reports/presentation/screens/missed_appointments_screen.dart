import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:mch_core/mch_core.dart';

import '../../data/report_providers.dart';
import '../../services/pdf_export_service.dart';
import '../../services/csv_export_service.dart';
import '../widgets/export_button.dart';
import '../../../patient_management/presentation/screens/patient_detail_screen.dart';
import '../../../patient_management/presentation/screens/book_appointment_screen.dart';

/// Missed Appointments Report Screen
/// Shows appointments that were missed or are past due for follow-up
class MissedAppointmentsScreen extends ConsumerStatefulWidget {
  const MissedAppointmentsScreen({super.key});

  @override
  ConsumerState<MissedAppointmentsScreen> createState() => _MissedAppointmentsScreenState();
}

class _MissedAppointmentsScreenState extends ConsumerState<MissedAppointmentsScreen> 
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool _isExporting = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final missedAsync = ref.watch(missedAppointmentsProvider);
    final pendingAsync = ref.watch(pendingFollowupAppointmentsProvider);

    // Combine data for export
    final allAppointments = <Appointment>[
      ...missedAsync.valueOrNull ?? [],
      ...pendingAsync.valueOrNull ?? [],
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Missed Appointments'),
        actions: [
          ExportButton(
            isLoading: _isExporting,
            onExportPdf: allAppointments.isNotEmpty 
                ? () => _exportPdf(allAppointments) : null,
            onExportCsv: allAppointments.isNotEmpty 
                ? () => _exportCsv(allAppointments) : null,
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              ref.invalidate(missedAppointmentsProvider);
              ref.invalidate(pendingFollowupAppointmentsProvider);
            },
            tooltip: 'Refresh',
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Marked Missed'),
            Tab(text: 'Needs Follow-up'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _MissedTab(theme: theme),
          _PendingFollowupTab(theme: theme),
        ],
      ),
    );
  }

  Future<void> _exportPdf(List<Appointment> appointments) async {
    setState(() => _isExporting = true);
    try {
      final pdfBytes = await PdfExportService.generateMissedAppointmentsReport(
        appointments: appointments,
        facilityName: 'MCH Facility',
      );
      await PdfExportService.sharePdf(pdfBytes, 'missed_appointments');
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

  Future<void> _exportCsv(List<Appointment> appointments) async {
    setState(() => _isExporting = true);
    try {
      final filePath = await CsvExportService.exportMissedAppointments(
        appointments: appointments,
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
}

class _MissedTab extends ConsumerWidget {
  final ThemeData theme;

  const _MissedTab({required this.theme});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appointmentsAsync = ref.watch(missedAppointmentsProvider);

    return appointmentsAsync.when(
      data: (appointments) {
        if (appointments.isEmpty) {
          return _buildEmptyState(
            theme,
            'No Missed Appointments',
            'All appointments have been attended to.',
            Icons.check_circle_outline,
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: appointments.length + 1,
          itemBuilder: (context, index) {
            if (index == 0) {
              return _buildHeader(theme, appointments.length, 'missed');
            }
            return _AppointmentCard(
              appointment: appointments[index - 1],
              theme: theme,
              cardColor: Colors.red,
            );
          },
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => _buildErrorState(theme, ref, error),
    );
  }
}

class _PendingFollowupTab extends ConsumerWidget {
  final ThemeData theme;

  const _PendingFollowupTab({required this.theme});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appointmentsAsync = ref.watch(pendingFollowupAppointmentsProvider);

    return appointmentsAsync.when(
      data: (appointments) {
        if (appointments.isEmpty) {
          return _buildEmptyState(
            theme,
            'No Pending Follow-ups',
            'There are no past-due appointments needing attention.',
            Icons.event_available,
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: appointments.length + 1,
          itemBuilder: (context, index) {
            if (index == 0) {
              return _buildHeader(theme, appointments.length, 'pending');
            }
            return _AppointmentCard(
              appointment: appointments[index - 1],
              theme: theme,
              cardColor: Colors.orange,
            );
          },
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => _buildErrorState(theme, ref, error),
    );
  }
}

Widget _buildHeader(ThemeData theme, int count, String type) {
  final isPending = type == 'pending';
  
  return Container(
    margin: const EdgeInsets.only(bottom: 16),
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      gradient: LinearGradient(
        colors: isPending 
            ? [Colors.orange.shade700, Colors.orange.shade500]
            : [Colors.red.shade700, Colors.red.shade500],
      ),
      borderRadius: BorderRadius.circular(12),
    ),
    child: Row(
      children: [
        Icon(
          isPending ? Icons.schedule : Icons.event_busy,
          color: Colors.white,
          size: 40,
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '$count ${isPending ? 'Pending Follow-ups' : 'Missed Appointments'}',
                style: theme.textTheme.titleMedium?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                isPending 
                    ? 'These appointments are past due but still scheduled'
                    : 'Patients who did not attend their appointments',
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

Widget _buildEmptyState(ThemeData theme, String title, String subtitle, IconData icon) {
  return Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(icon, size: 80, color: Colors.green.shade300),
        const SizedBox(height: 16),
        Text(title, style: theme.textTheme.titleLarge),
        const SizedBox(height: 8),
        Text(
          subtitle,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
          ),
        ),
      ],
    ),
  );
}

Widget _buildErrorState(ThemeData theme, WidgetRef ref, Object error) {
  return Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.error_outline, size: 64, color: theme.colorScheme.error),
        const SizedBox(height: 16),
        Text('Error loading data', style: theme.textTheme.titleLarge),
        const SizedBox(height: 8),
        Text(error.toString(), textAlign: TextAlign.center),
        const SizedBox(height: 16),
        FilledButton.icon(
          onPressed: () {
            ref.invalidate(missedAppointmentsProvider);
            ref.invalidate(pendingFollowupAppointmentsProvider);
          },
          icon: const Icon(Icons.refresh),
          label: const Text('Retry'),
        ),
      ],
    ),
  );
}

class _AppointmentCard extends StatelessWidget {
  final Appointment appointment;
  final ThemeData theme;
  final Color cardColor;

  const _AppointmentCard({
    required this.appointment,
    required this.theme,
    required this.cardColor,
  });

  @override
  Widget build(BuildContext context) {
    final daysSince = DateTime.now().difference(appointment.appointmentDate).inDays;

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: cardColor.withValues(alpha: 0.3)),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () => _navigateToProfile(context, appointment.maternalProfileId),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header row
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: cardColor.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      _getAppointmentIcon(appointment.appointmentType),
                      color: cardColor,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          appointment.patientName,
                          style: theme.textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          _formatAppointmentType(appointment.appointmentType),
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: cardColor.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      '$daysSince days ago',
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: cardColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 8),
              
              // Date info
              Row(
                children: [
                  Icon(Icons.calendar_today, size: 14, color: theme.colorScheme.primary),
                  const SizedBox(width: 4),
                  Text(
                    'Scheduled: ${DateFormat('MMM dd, yyyy').format(appointment.appointmentDate)}',
                    style: theme.textTheme.bodySmall,
                  ),
                  if (appointment.facilityName.isNotEmpty) ...[
                    const SizedBox(width: 12),
                    Icon(Icons.local_hospital, size: 14, color: theme.colorScheme.primary),
                    const SizedBox(width: 4),
                    Text(
                      appointment.facilityName,
                      style: theme.textTheme.bodySmall,
                    ),
                  ],
                ],
              ),
              
              if (appointment.notes != null && appointment.notes!.isNotEmpty) ...[
                const SizedBox(height: 4),
                Text(
                  'Notes: ${appointment.notes}',
                  style: theme.textTheme.bodySmall?.copyWith(
                    fontStyle: FontStyle.italic,
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
              
              const SizedBox(height: 12),
              
              // Action buttons
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () => _navigateToProfile(context, appointment.maternalProfileId),
                      icon: const Icon(Icons.person, size: 18),
                      label: const Text('View Patient'),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: FilledButton.icon(
                      onPressed: () => _bookAppointment(context, appointment.maternalProfileId),
                      icon: const Icon(Icons.calendar_month, size: 18),
                      label: const Text('Reschedule'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  IconData _getAppointmentIcon(AppointmentType type) {
    switch (type) {
      case AppointmentType.ancVisit:
        return Icons.pregnant_woman;
      case AppointmentType.pncVisit:
        return Icons.child_care;
      case AppointmentType.labTest:
        return Icons.science;
      case AppointmentType.ultrasound:
        return Icons.monitor_heart;
      case AppointmentType.delivery:
        return Icons.local_hospital;
      case AppointmentType.immunization:
        return Icons.vaccines;
      case AppointmentType.consultation:
        return Icons.medical_services;
      case AppointmentType.followUp:
        return Icons.event_repeat;
    }
  }

  String _formatAppointmentType(AppointmentType type) {
    switch (type) {
      case AppointmentType.ancVisit:
        return 'ANC Visit';
      case AppointmentType.pncVisit:
        return 'PNC Visit';
      case AppointmentType.labTest:
        return 'Lab Test';
      case AppointmentType.ultrasound:
        return 'Ultrasound';
      case AppointmentType.delivery:
        return 'Delivery';
      case AppointmentType.immunization:
        return 'Immunization';
      case AppointmentType.consultation:
        return 'Consultation';
      case AppointmentType.followUp:
        return 'Follow-up';
    }
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
}
