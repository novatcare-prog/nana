import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mch_core/mch_core.dart';
// ✅ FIX: Import the central provider file
import '../../../../core/providers/supabase_providers.dart';
import 'anc_visit_recording_screen.dart';

/// ANC Visit History Screen - Shows all visits for a patient
class ANCVisitHistoryScreen extends ConsumerWidget {
  final String patientId;
  final MaternalProfile patient;

  const ANCVisitHistoryScreen({
    super.key,
    required this.patientId,
    required this.patient,
  });

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  Color _getContactColor(int contactNumber) {
    if (contactNumber <= 2) return Colors.green;
    if (contactNumber <= 5) return Colors.blue;
    return Colors.purple;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // ✅ FIX: These providers will now be found
    final visitsAsync = ref.watch(patientVisitsProvider(patientId));
    final visitCountAsync = ref.watch(visitCountProvider(patientId));

    return Scaffold(
      appBar: AppBar(
        title: Text('ANC Visits - ${patient.clientName}'),
        actions: [
          visitCountAsync.when(
            data: (count) => Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  '$count/8 Visits',
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            loading: () => const SizedBox(),
            error: (_, __) => const SizedBox(),
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
                  Icon(Icons.calendar_today_outlined, size: 64, color: Colors.grey[400]),
                  const SizedBox(height: 16),
                  Text(
                    'No ANC visits recorded yet',
                    style: TextStyle(fontSize: 18, color: Colors.grey[600]),
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
                  ),
                ],
              ),
            );
          }

          return SingleChildScrollView(
            child: Column(
              children: [
                // Summary Cards
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: _buildSummaryCards(visits),
                ),

                // Progress Indicator
                _buildProgressIndicator(visits.length),

                // Visit List
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: visits.length,
                  itemBuilder: (context, index) {
                    final visit = visits[index];
                    return _buildVisitCard(context, visit, ref);
                  },
                ),

                const SizedBox(height: 80), // Space for FAB
              ],
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 64, color: Colors.red),
              const SizedBox(height: 16),
              Text('Error: ${error.toString()}'),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => ref.invalidate(patientVisitsProvider(patientId)),
                child: const Text('Retry'),
              ),
            ],
          ),
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
        label: const Text('New Visit'),
      ),
    );
  }

  Widget _buildSummaryCards(List<ANCVisit> visits) {
    final latestVisit = visits.first;
    final weights = visits.where((v) => v.weightKg != null).map((v) => v.weightKg!).toList();
    final avgWeight = weights.isNotEmpty ? weights.reduce((a, b) => a + b) / weights.length : null;

    return Row(
      children: [
        Expanded(
          child: Card(
            color: Colors.blue[50],
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  const Icon(Icons.calendar_today, color: Colors.blue, size: 32),
                  const SizedBox(height: 8),
                  const Text('Last Visit', style: TextStyle(fontSize: 12, color: Colors.grey)),
                  const SizedBox(height: 4),
                  Text(
                    _formatDate(latestVisit.visitDate),
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Card(
            color: Colors.green[50],
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  const Icon(Icons.pregnant_woman, color: Colors.green, size: 32),
                  const SizedBox(height: 8),
                  const Text('Gestation', style: TextStyle(fontSize: 12, color: Colors.grey)),
                  const SizedBox(height: 4),
                  Text(
                    '${latestVisit.gestationWeeks}w',
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Card(
            color: Colors.purple[50],
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  const Icon(Icons.monitor_weight, color: Colors.purple, size: 32),
                  const SizedBox(height: 8),
                  const Text('Avg Weight', style: TextStyle(fontSize: 12, color: Colors.grey)),
                  const SizedBox(height: 4),
                  Text(
                    avgWeight != null ? '${avgWeight.toStringAsFixed(1)}kg' : 'N/A',
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildProgressIndicator(int completedVisits) {
    const totalVisits = 8;
    final progress = completedVisits / totalVisits;

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'ANC Progress',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              Text(
                '$completedVisits/$totalVisits visits',
                style: TextStyle(fontSize: 14, color: Colors.grey[600]),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: progress > 1.0 ? 1.0 : progress, // Cap progress at 1.0
              minHeight: 12,
              backgroundColor: Colors.grey[200],
              valueColor: AlwaysStoppedAnimation<Color>(
                completedVisits >= 8 ? Colors.green : Colors.blue,
              ),
            ),
          ),
          if (completedVisits >= 8)
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Row(
                children: [
                  const Icon(Icons.check_circle, color: Colors.green, size: 16),
                  const SizedBox(width: 4),
                  Text(
                    'All ANC visits completed! 🎉',
                    style: TextStyle(color: Colors.green[700], fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildVisitCard(BuildContext context, ANCVisit visit, WidgetRef ref) {
    final contactColor = _getContactColor(visit.contactNumber);

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: InkWell(
        onTap: () {
          _showVisitDetails(context, visit);
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    backgroundColor: contactColor,
                    child: Text(
                      '${visit.contactNumber}',
                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Contact ${visit.contactNumber}',
                          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          _formatDate(visit.visitDate),
                          style: TextStyle(color: Colors.grey[600]),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.blue[50],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      '${visit.gestationWeeks}w',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              const Divider(),
              const SizedBox(height: 8),
              Wrap(
                spacing: 16,
                runSpacing: 8,
                children: [
                  if (visit.weightKg != null)
                    _buildInfoChip(Icons.monitor_weight, '${visit.weightKg}kg'),
                  if (visit.bloodPressure != null)
                    _buildInfoChip(Icons.favorite, visit.bloodPressure!),
                  if (visit.fundalHeight != null)
                    _buildInfoChip(Icons.straighten, '${visit.fundalHeight}cm FH'),
                  if (visit.foetalHeartRate != null)
                    _buildInfoChip(Icons.favorite_border, '${visit.foetalHeartRate} bpm'),
                ],
              ),
              if (visit.complaints != null || visit.diagnosis != null) ...[
                const SizedBox(height: 12),
                const Divider(),
                const SizedBox(height: 8),
                if (visit.complaints != null)
                  _buildInfoRow('Complaints', visit.complaints!),
                if (visit.diagnosis != null)
                  _buildInfoRow('Diagnosis', visit.diagnosis!),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoChip(IconData icon, String label) {
    return Chip(
      avatar: Icon(icon, size: 16),
      label: Text(label),
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      visualDensity: VisualDensity.compact,
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: TextStyle(fontWeight: FontWeight.w500, color: Colors.grey[700]),
            ),
          ),
          Expanded(
            child: Text(value),
          ),
        ],
      ),
    );
  }

  void _showVisitDetails(BuildContext context, ANCVisit visit) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        expand: false,
        builder: (context, scrollController) {
          return Container(
            padding: const EdgeInsets.all(16),
            child: ListView(
              controller: scrollController,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: _getContactColor(visit.contactNumber),
                      child: Text(
                        '${visit.contactNumber}',
                        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Contact ${visit.contactNumber} Details',
                            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            _formatDate(visit.visitDate),
                            style: TextStyle(color: Colors.grey[600]),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                const Divider(),
                
                // Vital Signs
                _buildDetailSection(
                  'Vital Signs',
                  [
                    if (visit.weightKg != null) _buildDetailRow('Weight', '${visit.weightKg} kg'),
                    if (visit.bloodPressure != null) _buildDetailRow('Blood Pressure', visit.bloodPressure!),
                    if (visit.muacCm != null) _buildDetailRow('MUAC', '${visit.muacCm} cm'),
                    if (visit.haemoglobin != null) _buildDetailRow('Haemoglobin', '${visit.haemoglobin} g/dL'),
                    if (visit.pallor == true) _buildDetailRow('Pallor', 'Yes', isAlert: true),
                  ],
                ),

                // Physical Examination
                _buildDetailSection(
                  'Physical Examination',
                  [
                    _buildDetailRow('Gestation', '${visit.gestationWeeks} weeks'),
                    if (visit.fundalHeight != null) _buildDetailRow('Fundal Height', '${visit.fundalHeight} cm'),
                    if (visit.presentation != null) _buildDetailRow('Presentation', visit.presentation!),
                    if (visit.lie != null) _buildDetailRow('Lie', visit.lie!),
                    if (visit.foetalHeartRate != null) _buildDetailRow('Foetal Heart Rate', '${visit.foetalHeartRate} bpm'),
                    if (visit.foetalMovement == true) _buildDetailRow('Foetal Movement', 'Yes'),
                  ],
                ),

                // Urine Test
                if (visit.urineProtein != null || visit.urineGlucose != null)
                  _buildDetailSection(
                    'Urine Test',
                    [
                      if (visit.urineProtein != null) _buildDetailRow('Protein', visit.urineProtein!),
                      if (visit.urineGlucose != null) _buildDetailRow('Glucose', visit.urineGlucose!),
                    ],
                  ),

                // Preventive Services
                _buildDetailSection(
                  'Preventive Services',
                  [
                    if (visit.tdInjectionGiven == true) _buildDetailRow('TD Injection', 'Given'),
                    if (visit.iptpSpGiven == true) _buildDetailRow('IPTp-SP', 'Given'),
                    if (visit.ifasTabletsGiven != null) _buildDetailRow('IFAS Tablets', '${visit.ifasTabletsGiven} tablets'),
                    if (visit.lllinGiven == true) _buildDetailRow('LLIN', 'Given'),
                    if (visit.dewormingGiven == true) _buildDetailRow('Deworming', 'Done'),
                  ],
                ),

                // Lab Tests
                if (visit.hbTested == true || visit.hivTested == true || visit.syphilisTested == true)
                  _buildDetailSection(
                    'Lab Tests',
                    [
                      if (visit.hbTested == true) _buildDetailRow('Haemoglobin Test', 'Done'),
                      if (visit.hivTested == true) 
                        _buildDetailRow('HIV Test', visit.hivResult ?? 'Done'),
                      if (visit.syphilisTested == true)
                        _buildDetailRow('Syphilis Test', visit.syphilisResult ?? 'Done'),
                    ],
                  ),

                // Clinical Notes
                if (visit.complaints != null || visit.diagnosis != null || visit.treatment != null || visit.notes != null)
                  _buildDetailSection(
                    'Clinical Notes',
                    [
                      if (visit.complaints != null) _buildDetailRow('Complaints', visit.complaints!),
                      if (visit.diagnosis != null) _buildDetailRow('Diagnosis', visit.diagnosis!),
                      if (visit.treatment != null) _buildDetailRow('Treatment', visit.treatment!),
                      if (visit.notes != null) _buildDetailRow('Notes', visit.notes!),
                    ],
                  ),

                // Next Visit
                if (visit.nextVisitDate != null)
                  _buildDetailSection(
                    'Next Visit',
                    [
                      _buildDetailRow('Scheduled Date', _formatDate(visit.nextVisitDate!)),
                    ],
                  ),

                if (visit.healthWorkerName != null)
                  _buildDetailSection(
                    'Recorded By',
                    [
                      _buildDetailRow('Health Worker', visit.healthWorkerName!),
                    ],
                  ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildDetailSection(String title, List<Widget> children) {
    // Filter out empty children to avoid rendering empty sections
    final validChildren = children.where((child) => child is! SizedBox || (child as SizedBox).height != 0).toList();
    if (validChildren.isEmpty) return const SizedBox();
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 16),
        Text(
          title,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        ...validChildren,
        const Divider(),
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
              style: TextStyle(fontWeight: FontWeight.w500, color: Colors.grey[700]),
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
}