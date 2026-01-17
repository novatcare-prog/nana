import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mch_core/mch_core.dart';
import '../../../../core/providers/supabase_providers.dart';
import '../../../../core/utils/error_helper.dart';
import 'anc_visit_recording_screen.dart';

/// ANC Visit History Screen - Shows all ANC visits for a patient
class ANCVisitHistoryScreen extends ConsumerWidget {
  final String patientId;
  final MaternalProfile patient;

  const ANCVisitHistoryScreen({
    super.key,
    required this.patientId,
    required this.patient,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final visitsAsync = ref.watch(patientVisitsProvider(patientId));

    return Scaffold(
      appBar: AppBar(
        title: Text('ANC Visits - ${patient.clientName}'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => ref.invalidate(patientVisitsProvider(patientId)),
            tooltip: 'Refresh',
          ),
        ],
      ),
      body: visitsAsync.when(
        data: (visits) {
          if (visits.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.event_note,
                    size: 64,
                    color: Colors.grey[400],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No ANC Visits Recorded',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[700],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Record the first ANC visit for this patient',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton.icon(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ANCVisitRecordingScreen(
                            patientId: patientId,
                            patient: patient,
                          ),
                        ),
                      );
                    },
                    icon: const Icon(Icons.add),
                    label: const Text('Record First Visit'),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }

          // Sort visits by date (most recent first)
          final sortedVisits = List<ANCVisit>.from(visits)
            ..sort((a, b) => b.visitDate.compareTo(a.visitDate));

          return Column(
            children: [
              // Summary Card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                color: Theme.of(context).colorScheme.primaryContainer,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildSummaryItem(
                      context,
                      'Total Visits',
                      visits.length.toString(),
                      Icons.event,
                    ),
                    _buildSummaryItem(
                      context,
                      'Last Visit',
                      _formatDate(sortedVisits.first.visitDate),
                      Icons.calendar_today,
                    ),
                    _buildSummaryItem(
                      context,
                      'Next Visit',
                      sortedVisits.first.nextVisitDate != null
                          ? _formatDate(sortedVisits.first.nextVisitDate!)
                          : 'Not set',
                      Icons.event_available,
                    ),
                  ],
                ),
              ),

              // Visits Timeline
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: sortedVisits.length,
                  itemBuilder: (context, index) {
                    final visit = sortedVisits[index];
                    final isFirst = index == 0;
                    final isLast = index == sortedVisits.length - 1;
                    
                    return _buildVisitCard(
                      context,
                      visit,
                      isFirst,
                      isLast,
                    );
                  },
                ),
              ),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => ErrorHelper.buildErrorWidget(
          error,
          onRetry: () => ref.invalidate(patientVisitsProvider(patientId)),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ANCVisitRecordingScreen(
                patientId: patientId,
                patient: patient,
              ),
            ),
          );
        },
        icon: const Icon(Icons.add),
        label: const Text('Record Visit'),
      ),
    );
  }

  Widget _buildSummaryItem(
    BuildContext context,
    String label,
    String value,
    IconData icon,
  ) {
    return Column(
      children: [
        Icon(
          icon,
          size: 24,
          color: Theme.of(context).colorScheme.primary,
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }

  Widget _buildVisitCard(
    BuildContext context,
    ANCVisit visit,
    bool isFirst,
    bool isLast,
  ) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: isFirst ? 4 : 2,
      child: InkWell(
        onTap: () {
          // Navigate to detailed view
          _showVisitDetails(context, visit);
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Row
              Row(
                children: [
                  // Contact Number Badge
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: isFirst
                          ? Theme.of(context).colorScheme.primary
                          : Colors.grey[300],
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      'Contact ${visit.contactNumber}',
                      style: TextStyle(
                        color: isFirst ? Colors.white : Colors.black87,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  // High Risk Badge
                  if (visit.isHighRisk == true)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.warning, size: 14, color: Colors.white),
                          SizedBox(width: 4),
                          Text(
                            'High Risk',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  const Spacer(),
                  // Date
                  Text(
                    _formatDate(visit.visitDate),
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              const Divider(),
              const SizedBox(height: 8),
              
              // Key Information Grid
              Row(
                children: [
                  Expanded(
                    child: _buildInfoChip(
                      'Gestation',
                      '${visit.gestationWeeks}w',
                      Icons.calendar_month,
                      Colors.blue,
                    ),
                  ),
                  const SizedBox(width: 8),
                  if (visit.weightKg != null)
                    Expanded(
                      child: _buildInfoChip(
                        'Weight',
                        '${visit.weightKg} kg',
                        Icons.monitor_weight,
                        Colors.green,
                      ),
                    ),
                  const SizedBox(width: 8),
                  if (visit.bloodPressure != null)
                    Expanded(
                      child: _buildInfoChip(
                        'BP',
                        visit.bloodPressure!,
                        Icons.favorite,
                        _getBPColor(visit.bloodPressure!),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 8),
              
              // Clinical Information
              if (visit.complaints != null || visit.diagnosis != null)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Divider(),
                    const SizedBox(height: 8),
                    if (visit.complaints != null)
                      _buildInfoRow('Complaints', visit.complaints!),
                    if (visit.diagnosis != null)
                      _buildInfoRow('Diagnosis', visit.diagnosis!),
                  ],
                ),
              
              // Next Visit Date
              if (visit.nextVisitDate != null)
                Column(
                  children: [
                    const SizedBox(height: 8),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.blue[50],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.event_available,
                            size: 16,
                            color: Colors.blue,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Next Visit: ${_formatDate(visit.nextVisitDate!)}',
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.blue,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
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

  Widget _buildInfoChip(
    String label,
    String value,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Icon(icon, size: 20, color: color),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          Text(
            label,
            style: TextStyle(
              fontSize: 10,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$label: ',
            style: const TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 12,
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[700],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Color _getBPColor(String bp) {
    if (bp.contains('/')) {
      final parts = bp.split('/');
      if (parts.length == 2) {
        final sys = int.tryParse(parts[0].trim()) ?? 0;
        final dia = int.tryParse(parts[1].trim()) ?? 0;
        if (sys >= 140 || dia >= 90) {
          return Colors.red; // High BP
        } else if (sys >= 120 || dia >= 80) {
          return Colors.orange; // Elevated
        }
      }
    }
    return Colors.green; // Normal
  }

  void _showVisitDetails(BuildContext context, ANCVisit visit) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.9,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        expand: false,
        builder: (context, scrollController) => SingleChildScrollView(
          controller: scrollController,
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      'Visit Details',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              const Divider(),
              const SizedBox(height: 16),

              // Visit Information
              _buildDetailSection('Visit Information', [
                _buildDetailRow('Contact Number', 'Contact ${visit.contactNumber}'),
                _buildDetailRow('Visit Date', _formatDate(visit.visitDate)),
                _buildDetailRow('Gestation', '${visit.gestationWeeks} weeks'),
                if (visit.isHighRisk == true)
                  _buildDetailRow('Risk Status', 'High Risk', isAlert: true),
              ]),

              // Vital Signs
              if (visit.weightKg != null ||
                  visit.bloodPressure != null ||
                  visit.haemoglobin != null)
                _buildDetailSection('Vital Signs', [
                  if (visit.weightKg != null)
                    _buildDetailRow('Weight', '${visit.weightKg} kg'),
                  if (visit.bloodPressure != null)
                    _buildDetailRow('Blood Pressure', visit.bloodPressure!),
                  if (visit.muacCm != null)
                    _buildDetailRow('MUAC', '${visit.muacCm} cm'),
                  if (visit.haemoglobin != null)
                    _buildDetailRow('Haemoglobin', '${visit.haemoglobin} g/dL'),
                  if (visit.pallor == true)
                    _buildDetailRow('Pallor', 'Present', isAlert: true),
                ]),

              // Physical Examination
              if (visit.fundalHeight != null ||
                  visit.presentation != null ||
                  visit.foetalHeartRate != null)
                _buildDetailSection('Physical Examination', [
                  if (visit.fundalHeight != null)
                    _buildDetailRow('Fundal Height', '${visit.fundalHeight} cm'),
                  if (visit.presentation != null)
                    _buildDetailRow('Presentation', visit.presentation!),
                  if (visit.lie != null) _buildDetailRow('Lie', visit.lie!),
                  if (visit.foetalHeartRate != null)
                    _buildDetailRow(
                        'Foetal Heart Rate', '${visit.foetalHeartRate} bpm'),
                  if (visit.foetalMovement == true)
                    _buildDetailRow('Foetal Movement', 'Present'),
                ]),

              // Lab Tests
              if (visit.urineProtein != null ||
                  visit.hivTested == true ||
                  visit.syphilisTested == true)
                _buildDetailSection('Lab Tests', [
                  if (visit.urineProtein != null)
                    _buildDetailRow('Urine Protein', visit.urineProtein!),
                  if (visit.urineGlucose != null)
                    _buildDetailRow('Urine Glucose', visit.urineGlucose!),
                  if (visit.hivTested == true)
                    _buildDetailRow(
                      'HIV Test',
                      visit.hivResult ?? 'Tested',
                      isAlert: visit.hivResult == 'Positive',
                    ),
                  if (visit.syphilisTested == true)
                    _buildDetailRow(
                      'Syphilis Test',
                      visit.syphilisResult ?? 'Tested',
                      isAlert: visit.syphilisResult == 'Positive',
                    ),
                ]),

              // Preventive Services
              if (visit.tdInjectionGiven == true ||
                  visit.iptpSpGiven == true ||
                  visit.lllinGiven == true)
                _buildDetailSection('Preventive Services', [
                  if (visit.tdInjectionGiven == true)
                    _buildDetailRow('TD Injection', 'Given'),
                  if (visit.iptpSpGiven == true) _buildDetailRow('IPTp-SP', 'Given'),
                  if (visit.ifasTabletsGiven != null)
                    _buildDetailRow(
                        'IFAS Tablets', '${visit.ifasTabletsGiven} tablets'),
                  if (visit.lllinGiven == true) _buildDetailRow('LLIN', 'Given'),
                  if (visit.dewormingGiven == true)
                    _buildDetailRow('Deworming', 'Given'),
                ]),

              // Clinical Notes
              if (visit.complaints != null ||
                  visit.diagnosis != null ||
                  visit.treatment != null)
                _buildDetailSection('Clinical Notes', [
                  if (visit.complaints != null)
                    _buildDetailRow('Complaints', visit.complaints!),
                  if (visit.diagnosis != null)
                    _buildDetailRow('Diagnosis', visit.diagnosis!),
                  if (visit.treatment != null)
                    _buildDetailRow('Treatment', visit.treatment!),
                  if (visit.notes != null) _buildDetailRow('Notes', visit.notes!),
                ]),

              // Next Visit
              if (visit.nextVisitDate != null || visit.healthWorkerName != null)
                _buildDetailSection('Follow-up', [
                  if (visit.nextVisitDate != null)
                    _buildDetailRow(
                        'Next Visit', _formatDate(visit.nextVisitDate!)),
                  if (visit.healthWorkerName != null)
                    _buildDetailRow('Health Worker', visit.healthWorkerName!),
                ]),

              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailSection(String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        ...children,
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildDetailRow(String label, String value, {bool isAlert = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 140,
            child: Text(
              label,
              style: TextStyle(
                fontWeight: FontWeight.w500,
                color: Colors.grey[700],
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                color: isAlert ? Colors.red : Colors.black87,
                fontWeight: isAlert ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }
}