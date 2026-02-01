import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../data/report_providers.dart';
import '../../domain/report_models.dart';
import '../../services/pdf_export_service.dart';
import '../../services/csv_export_service.dart';
import '../widgets/export_button.dart';
import '../../../patient_management/presentation/screens/patient_detail_screen.dart';
import '../../../patient_management/presentation/screens/book_appointment_screen.dart';

/// High Risk Patients Report Screen
/// Shows actionable list of high-risk patients with quick actions
class HighRiskReportScreen extends ConsumerStatefulWidget {
  const HighRiskReportScreen({super.key});

  @override
  ConsumerState<HighRiskReportScreen> createState() => _HighRiskReportScreenState();
}

class _HighRiskReportScreenState extends ConsumerState<HighRiskReportScreen> {
  String _filterRiskType = 'All';
  String _sortBy = 'priority'; // priority, edd, name
  bool _isExporting = false;
  List<HighRiskPatientReport> _currentData = [];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final reportAsync = ref.watch(highRiskPatientsReportProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('High Risk Patients'),
        actions: [
          ExportButton(
            isLoading: _isExporting,
            onExportPdf: _currentData.isNotEmpty ? _exportPdf : null,
            onExportCsv: _currentData.isNotEmpty ? _exportCsv : null,
          ),
          PopupMenuButton<String>(
            icon: const Icon(Icons.sort),
            tooltip: 'Sort by',
            onSelected: (value) => setState(() => _sortBy = value),
            itemBuilder: (context) => [
              CheckedPopupMenuItem(
                value: 'priority',
                checked: _sortBy == 'priority',
                child: const Text('Priority Score'),
              ),
              CheckedPopupMenuItem(
                value: 'edd',
                checked: _sortBy == 'edd',
                child: const Text('Due Date'),
              ),
              CheckedPopupMenuItem(
                value: 'name',
                checked: _sortBy == 'name',
                child: const Text('Name'),
              ),
            ],
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => ref.invalidate(highRiskPatientsReportProvider),
            tooltip: 'Refresh',
          ),
        ],
      ),
      body: Column(
        children: [
          // Filter chips
          _buildFilterChips(theme),
          
          // Patient list
          Expanded(
            child: reportAsync.when(
              data: (patients) {
                final filtered = _filterPatients(patients);
                final sorted = _sortPatients(filtered);
                _currentData = sorted;
                
                if (sorted.isEmpty) {
                  return _buildEmptyState(theme);
                }
                
                return RefreshIndicator(
                  onRefresh: () async {
                    ref.invalidate(highRiskPatientsReportProvider);
                  },
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: sorted.length + 1, // +1 for summary header
                    itemBuilder: (context, index) {
                      if (index == 0) {
                        return _buildSummaryHeader(theme, sorted);
                      }
                      return _buildPatientCard(theme, sorted[index - 1]);
                    },
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
                      onPressed: () => ref.invalidate(highRiskPatientsReportProvider),
                      icon: const Icon(Icons.refresh),
                      label: const Text('Retry'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _exportPdf() async {
    setState(() => _isExporting = true);
    try {
      final pdfBytes = await PdfExportService.generateHighRiskReport(
        patients: _currentData,
        facilityName: 'MCH Facility', // TODO: Get from user profile
      );
      await PdfExportService.sharePdf(pdfBytes, 'high_risk_patients');
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
      final filePath = await CsvExportService.exportHighRiskPatients(
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

  Widget _buildFilterChips(ThemeData theme) {
    final filters = ['All', 'HIV+', 'Hypertension', 'Diabetes', 'Age Risk', 'Previous CS'];
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: filters.map((filter) {
            final isSelected = _filterRiskType == filter;
            return Padding(
              padding: const EdgeInsets.only(right: 8),
              child: FilterChip(
                label: Text(filter),
                selected: isSelected,
                onSelected: (selected) {
                  setState(() => _filterRiskType = selected ? filter : 'All');
                },
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildSummaryHeader(ThemeData theme, List<HighRiskPatientReport> patients) {
    final overdueCount = patients.where((p) => p.isOverdueForVisit).length;
    final urgentCount = patients.where((p) => (p.daysUntilEdd ?? 999) <= 14).length;
    
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.red.shade700, Colors.red.shade500],
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          const Icon(Icons.warning_rounded, color: Colors.white, size: 40),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${patients.length} High Risk Patients',
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '$overdueCount overdue for visit • $urgentCount due in 2 weeks',
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

  Widget _buildPatientCard(ThemeData theme, HighRiskPatientReport patient) {
    final profile = patient.profile;
    final isOverdue = patient.isOverdueForVisit;
    final isUrgent = (patient.daysUntilEdd ?? 999) <= 14;
    
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: isUrgent ? Colors.red : (isOverdue ? Colors.orange : Colors.transparent),
          width: isUrgent || isOverdue ? 2 : 0,
        ),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () => _navigateToProfile(profile.id!),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header row
              Row(
                children: [
                  CircleAvatar(
                    backgroundColor: Colors.red.shade100,
                    child: Icon(Icons.person, color: Colors.red.shade700),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          profile.clientName,
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          profile.ancNumber,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (isUrgent)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        'URGENT',
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                ],
              ),
              
              const SizedBox(height: 12),
              
              // Risk factors
              Wrap(
                spacing: 6,
                runSpacing: 6,
                children: patient.riskFactors.map((factor) {
                  return Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: _getRiskColor(factor).withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      factor,
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: _getRiskColor(factor),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  );
                }).toList(),
              ),
              
              const SizedBox(height: 12),
              
              // Info row
              Row(
                children: [
                  Icon(Icons.calendar_today, size: 16, color: theme.colorScheme.primary),
                  const SizedBox(width: 4),
                  Text(
                    profile.edd != null 
                        ? 'EDD: ${DateFormat('MMM dd, yyyy').format(profile.edd!)}'
                        : 'EDD: Not set',
                    style: theme.textTheme.bodySmall,
                  ),
                  if (patient.daysUntilEdd != null) ...[
                    const SizedBox(width: 4),
                    Text(
                      '(${patient.daysUntilEdd} days)',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: isUrgent ? Colors.red : theme.colorScheme.onSurface.withValues(alpha: 0.6),
                        fontWeight: isUrgent ? FontWeight.bold : FontWeight.normal,
                      ),
                    ),
                  ],
                  const Spacer(),
                  if (isOverdue)
                    Row(
                      children: [
                        Icon(Icons.access_time, size: 16, color: Colors.orange.shade700),
                        const SizedBox(width: 4),
                        Text(
                          'Overdue for visit',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: Colors.orange.shade700,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                ],
              ),
              
              if (patient.lastVisitDate != null) ...[
                const SizedBox(height: 4),
                Text(
                  'Last visit: ${DateFormat('MMM dd, yyyy').format(patient.lastVisitDate!)}',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                  ),
                ),
              ],
              
              const SizedBox(height: 12),
              const Divider(height: 1),
              const SizedBox(height: 12),
              
              // Action buttons
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () => _callPatient(profile.telephone),
                      icon: const Icon(Icons.phone, size: 18),
                      label: const Text('Call'),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () => _bookAppointment(profile.id!),
                      icon: const Icon(Icons.calendar_month, size: 18),
                      label: const Text('Book Visit'),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: FilledButton.icon(
                      onPressed: () => _navigateToProfile(profile.id!),
                      icon: const Icon(Icons.person, size: 18),
                      label: const Text('View'),
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

  Widget _buildEmptyState(ThemeData theme) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.check_circle_outline, size: 80, color: Colors.green.shade300),
          const SizedBox(height: 16),
          Text(
            'No High Risk Patients',
            style: theme.textTheme.titleLarge,
          ),
          const SizedBox(height: 8),
          Text(
            _filterRiskType == 'All' 
                ? 'Great! There are no high-risk patients currently.'
                : 'No patients match the selected filter.',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
            ),
          ),
        ],
      ),
    );
  }

  List<HighRiskPatientReport> _filterPatients(List<HighRiskPatientReport> patients) {
    if (_filterRiskType == 'All') return patients;
    
    return patients.where((p) {
      switch (_filterRiskType) {
        case 'HIV+':
          return p.riskFactors.contains('HIV+');
        case 'Hypertension':
          return p.riskFactors.contains('Hypertension');
        case 'Diabetes':
          return p.riskFactors.contains('Diabetes');
        case 'Age Risk':
          return p.riskFactors.any((f) => f.contains('Age'));
        case 'Previous CS':
          return p.riskFactors.contains('Previous C-Section');
        default:
          return true;
      }
    }).toList();
  }

  List<HighRiskPatientReport> _sortPatients(List<HighRiskPatientReport> patients) {
    switch (_sortBy) {
      case 'priority':
        return [...patients]..sort((a, b) => b.priorityScore.compareTo(a.priorityScore));
      case 'edd':
        return [...patients]..sort((a, b) {
          if (a.profile.edd == null) return 1;
          if (b.profile.edd == null) return -1;
          return a.profile.edd!.compareTo(b.profile.edd!);
        });
      case 'name':
        return [...patients]..sort((a, b) => 
            a.profile.clientName.compareTo(b.profile.clientName));
      default:
        return patients;
    }
  }

  Color _getRiskColor(String factor) {
    switch (factor) {
      case 'HIV+':
        return Colors.red.shade700;
      case 'Hypertension':
        return Colors.orange.shade700;
      case 'Diabetes':
        return Colors.purple.shade600;
      case 'Tuberculosis':
        return Colors.brown.shade600;
      case 'Previous C-Section':
        return Colors.blue.shade700;
      default:
        return Colors.grey.shade700;
    }
  }

  void _navigateToProfile(String patientId) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PatientDetailScreen(patientId: patientId),
      ),
    );
  }

  void _bookAppointment(String patientId) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => BookAppointmentScreen(patientId: patientId),
      ),
    );
  }

  Future<void> _callPatient(String? phoneNumber) async {
    if (phoneNumber == null || phoneNumber.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No phone number available')),
      );
      return;
    }
    
    final uri = Uri.parse('tel:$phoneNumber');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Could not launch phone dialer')),
        );
      }
    }
  }
}
