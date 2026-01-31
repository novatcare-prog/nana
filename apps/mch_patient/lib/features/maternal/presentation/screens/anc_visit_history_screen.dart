import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:mch_core/mch_core.dart';
import '../../../../core/providers/maternal_profile_provider.dart';
import '../../../../core/providers/anc_visit_provider.dart';
import '../../../../core/utils/error_helper.dart';

/// ANC Visit History Screen
/// Shows all antenatal care visits for the current pregnancy
class AncVisitHistoryScreen extends ConsumerWidget {
  const AncVisitHistoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileAsync = ref.watch(currentMaternalProfileProvider);

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('ANC Visit History'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              ref.invalidate(currentMaternalProfileProvider);
            },
          ),
        ],
      ),
      body: profileAsync.when(
        data: (profile) {
          if (profile == null) {
            return const Center(
              child: Text('Maternal profile not found'),
            );
          }

          final visitsAsync = ref.watch(ancVisitsProvider(profile.id!));

          return visitsAsync.when(
            data: (visits) => _buildContent(context, profile, visits),
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, _) => ErrorHelper.buildErrorWidget(e),
          );
        },
        loading: () => const Center(
          child: CircularProgressIndicator(color: Color(0xFFE91E63)),
        ),
        error: (e, _) => Center(child: Text('Error: $e')),
      ),
    );
  }

  Widget _buildContent(
    BuildContext context,
    MaternalProfile profile,
    List<ANCVisit> visits,
  ) {
    if (visits.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.pink.shade50,
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.pregnant_woman,
                    size: 48, color: Colors.pink.shade300),
              ),
              const SizedBox(height: 24),
              Text(
                'No ANC Visits Yet',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: Theme.of(context).textTheme.bodyLarge?.color,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Your antenatal care visits will appear here after your clinic appointments.',
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Theme.of(context).textTheme.bodySmall?.color,
                    fontSize: 14),
              ),
            ],
          ),
        ),
      );
    }

    // Sort visits by date (most recent first)
    final sortedVisits = List<ANCVisit>.from(visits)
      ..sort((a, b) => b.visitDate.compareTo(a.visitDate));

    return Column(
      children: [
        // Summary Header
        _AncSummaryHeader(
          profile: profile,
          visits: sortedVisits,
        ),

        const SizedBox(height: 16),

        // Visits List
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: sortedVisits.length,
            itemBuilder: (context, index) {
              final visit = sortedVisits[index];
              return _AncVisitCard(
                visit: visit,
                isLatest: index == 0,
                onTap: () => _showVisitDetails(context, visit),
              );
            },
          ),
        ),
      ],
    );
  }

  void _showVisitDetails(BuildContext context, ANCVisit visit) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => _VisitDetailSheet(visit: visit),
    );
  }
}

/// Summary Header
class _AncSummaryHeader extends StatelessWidget {
  final MaternalProfile profile;
  final List<ANCVisit> visits;

  const _AncSummaryHeader({
    required this.profile,
    required this.visits,
  });

  @override
  Widget build(BuildContext context) {
    final latestVisit = visits.isNotEmpty ? visits.first : null;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFFE91E63), Color(0xFFC2185B)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Column(
        children: [
          const Icon(Icons.pregnant_woman, size: 40, color: Colors.white),
          const SizedBox(height: 8),
          Text(
            profile.clientName,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          if (profile.edd != null) ...[
            const SizedBox(height: 4),
            Text(
              'EDD: ${DateFormat('d MMM yyyy').format(profile.edd!)}',
              style: TextStyle(
                fontSize: 12,
                color: Colors.white.withOpacity(0.1),
              ),
            ),
          ],
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _SummaryItem(
                icon: Icons.event_note,
                value: '${visits.length}',
                label: 'Total Visits',
              ),
              if (latestVisit != null) ...[
                _SummaryItem(
                  icon: Icons.calendar_today,
                  value: DateFormat('d MMM').format(latestVisit.visitDate),
                  label: 'Last Visit',
                ),
                _SummaryItem(
                  icon: Icons.child_care,
                  value: '${latestVisit.gestationWeeks}w',
                  label: 'Gestation',
                ),
              ],
            ],
          ),
          if (latestVisit?.nextVisitDate != null) ...[
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.event_available,
                      size: 14, color: Colors.white),
                  const SizedBox(width: 4),
                  Text(
                    'Next: ${DateFormat('d MMM yyyy').format(latestVisit!.nextVisitDate!)}',
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}

/// Summary Item
class _SummaryItem extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;

  const _SummaryItem({
    required this.icon,
    required this.value,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, color: Colors.white, size: 20),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 10,
            color: Colors.white.withOpacity(0.1),
          ),
        ),
      ],
    );
  }
}

/// ANC Visit Card
class _AncVisitCard extends StatelessWidget {
  final ANCVisit visit;
  final bool isLatest;
  final VoidCallback onTap;

  const _AncVisitCard({
    required this.visit,
    required this.isLatest,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: isLatest ? 4 : 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: visit.isHighRisk == true
            ? const BorderSide(color: Colors.red, width: 2)
            : BorderSide.none,
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                children: [
                  // Contact Number Badge
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: isLatest
                          ? const Color(0xFFE91E63)
                          : Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      'Visit ${visit.contactNumber}',
                      style: TextStyle(
                        color: isLatest ? Colors.white : Colors.black87,
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
                          horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.warning, size: 12, color: Colors.white),
                          SizedBox(width: 4),
                          Text(
                            'High Risk',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 10,
                            ),
                          ),
                        ],
                      ),
                    ),
                  const Spacer(),
                  // Date
                  Text(
                    DateFormat('d MMM yyyy').format(visit.visitDate),
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              const Divider(height: 1),
              const SizedBox(height: 12),

              // Key Information
              Row(
                children: [
                  Expanded(
                    child: _InfoChip(
                      icon: Icons.calendar_month,
                      value: '${visit.gestationWeeks}w',
                      label: 'Gestation',
                      color: Colors.blue,
                    ),
                  ),
                  if (visit.weightKg != null) ...[
                    const SizedBox(width: 8),
                    Expanded(
                      child: _InfoChip(
                        icon: Icons.monitor_weight,
                        value: '${visit.weightKg}kg',
                        label: 'Weight',
                        color: Colors.green,
                      ),
                    ),
                  ],
                  if (visit.bloodPressure != null) ...[
                    const SizedBox(width: 8),
                    Expanded(
                      child: _InfoChip(
                        icon: Icons.favorite,
                        value: visit.bloodPressure!,
                        label: 'BP',
                        color: _getBPColor(visit.bloodPressure!),
                      ),
                    ),
                  ],
                ],
              ),

              // Baby Info
              if (visit.foetalHeartRate != null ||
                  visit.foetalMovement == true) ...[
                const SizedBox(height: 12),
                Row(
                  children: [
                    Icon(Icons.child_care, size: 16, color: Colors.pink[400]),
                    const SizedBox(width: 8),
                    if (visit.foetalHeartRate != null)
                      Text(
                        'FHR: ${visit.foetalHeartRate} bpm',
                        style: TextStyle(fontSize: 12, color: Colors.grey[700]),
                      ),
                    if (visit.foetalMovement == true) ...[
                      const SizedBox(width: 16),
                      Row(
                        children: [
                          Icon(Icons.check_circle,
                              size: 14, color: Colors.green[600]),
                          const SizedBox(width: 4),
                          Text(
                            'Movement felt',
                            style: TextStyle(
                                fontSize: 12, color: Colors.grey[700]),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ],

              // Complaints
              if (visit.complaints != null && visit.complaints!.isNotEmpty) ...[
                const SizedBox(height: 8),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(Icons.note, size: 14, color: Colors.grey[600]),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        visit.complaints!,
                        style: TextStyle(fontSize: 12, color: Colors.grey[700]),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ],

              // Next Visit
              if (visit.nextVisitDate != null) ...[
                const SizedBox(height: 12),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade50,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.event_available,
                          size: 14, color: Colors.blue),
                      const SizedBox(width: 8),
                      Text(
                        'Next: ${DateFormat('d MMM yyyy').format(visit.nextVisitDate!)}',
                        style: const TextStyle(
                          fontSize: 11,
                          color: Colors.blue,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ],

              // Tap hint
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    'Tap for details',
                    style: TextStyle(fontSize: 10, color: Colors.grey[400]),
                  ),
                  Icon(Icons.chevron_right, size: 14, color: Colors.grey[400]),
                ],
              ),
            ],
          ),
        ),
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
          return Colors.red;
        } else if (sys >= 120 || dia >= 80) {
          return Colors.orange;
        }
      }
    }
    return Colors.green;
  }
}

/// Info Chip
class _InfoChip extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;
  final Color color;

  const _InfoChip({
    required this.icon,
    required this.value,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.1)),
      ),
      child: Column(
        children: [
          Icon(icon, size: 18, color: color),
          const SizedBox(height: 2),
          Text(
            value,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          Text(
            label,
            style: TextStyle(fontSize: 9, color: Colors.grey[600]),
          ),
        ],
      ),
    );
  }
}

/// Visit Detail Sheet
class _VisitDetailSheet extends StatelessWidget {
  final ANCVisit visit;

  const _VisitDetailSheet({required this.visit});

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.85,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      expand: false,
      builder: (context, scrollController) => SingleChildScrollView(
        controller: scrollController,
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Handle
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

            // Header
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE91E63).withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.pregnant_woman,
                    color: Color(0xFFE91E63),
                    size: 24,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Visit ${visit.contactNumber}',
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        DateFormat('EEEE, d MMMM yyyy').format(visit.visitDate),
                        style: TextStyle(fontSize: 14, color: Colors.grey[600]),
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

            const SizedBox(height: 24),

            // High Risk Alert
            if (visit.isHighRisk == true)
              Container(
                padding: const EdgeInsets.all(12),
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: Colors.red.shade50,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.red),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.warning, color: Colors.red),
                    SizedBox(width: 8),
                    Text(
                      'High Risk Pregnancy',
                      style: TextStyle(
                        color: Colors.red,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),

            // Sections
            _buildSection('Visit Information', [
              _DetailRow(
                  label: 'Gestation', value: '${visit.gestationWeeks} weeks'),
              if (visit.healthWorkerName != null)
                _DetailRow(label: 'Seen By', value: visit.healthWorkerName!),
            ]),

            if (visit.weightKg != null ||
                visit.bloodPressure != null ||
                visit.haemoglobin != null)
              _buildSection('Vital Signs', [
                if (visit.weightKg != null)
                  _DetailRow(label: 'Weight', value: '${visit.weightKg} kg'),
                if (visit.bloodPressure != null)
                  _DetailRow(
                      label: 'Blood Pressure', value: visit.bloodPressure!),
                if (visit.muacCm != null)
                  _DetailRow(label: 'MUAC', value: '${visit.muacCm} cm'),
                if (visit.haemoglobin != null)
                  _DetailRow(
                      label: 'Haemoglobin', value: '${visit.haemoglobin} g/dL'),
                if (visit.pallor == true)
                  const _DetailRow(
                      label: 'Pallor', value: 'Present', isAlert: true),
              ]),

            if (visit.fundalHeight != null || visit.foetalHeartRate != null)
              _buildSection('Baby\'s Health', [
                if (visit.fundalHeight != null)
                  _DetailRow(
                      label: 'Fundal Height',
                      value: '${visit.fundalHeight} cm'),
                if (visit.presentation != null)
                  _DetailRow(label: 'Presentation', value: visit.presentation!),
                if (visit.lie != null)
                  _DetailRow(label: 'Lie', value: visit.lie!),
                if (visit.foetalHeartRate != null)
                  _DetailRow(
                      label: 'Heart Rate',
                      value: '${visit.foetalHeartRate} bpm'),
                if (visit.foetalMovement == true)
                  const _DetailRow(label: 'Movement', value: 'Present'),
              ]),

            if (visit.urineProtein != null || visit.hivTested == true)
              _buildSection('Lab Tests', [
                if (visit.urineProtein != null)
                  _DetailRow(
                      label: 'Urine Protein', value: visit.urineProtein!),
                if (visit.urineGlucose != null)
                  _DetailRow(
                      label: 'Urine Glucose', value: visit.urineGlucose!),
                if (visit.hivTested == true)
                  _DetailRow(
                      label: 'HIV Test', value: visit.hivResult ?? 'Tested'),
                if (visit.syphilisTested == true)
                  _DetailRow(
                      label: 'Syphilis Test',
                      value: visit.syphilisResult ?? 'Tested'),
              ]),

            if (visit.tdInjectionGiven == true ||
                visit.ifasTabletsGiven != null)
              _buildSection('Preventive Services', [
                if (visit.tdInjectionGiven == true)
                  const _DetailRow(label: 'TD Injection', value: 'Given'),
                if (visit.iptpSpGiven == true)
                  const _DetailRow(label: 'IPTp-SP', value: 'Given'),
                if (visit.ifasTabletsGiven != null)
                  _DetailRow(
                      label: 'IFAS Tablets',
                      value: '${visit.ifasTabletsGiven} tablets'),
                if (visit.lllinGiven == true)
                  const _DetailRow(
                      label: 'LLIN (Mosquito Net)', value: 'Given'),
                if (visit.dewormingGiven == true)
                  const _DetailRow(label: 'Deworming', value: 'Given'),
              ]),

            if (visit.complaints != null || visit.diagnosis != null)
              _buildSection('Clinical Notes', [
                if (visit.complaints != null)
                  _DetailRow(label: 'Complaints', value: visit.complaints!),
                if (visit.diagnosis != null)
                  _DetailRow(label: 'Diagnosis', value: visit.diagnosis!),
                if (visit.treatment != null)
                  _DetailRow(label: 'Treatment', value: visit.treatment!),
                if (visit.notes != null)
                  _DetailRow(label: 'Notes', value: visit.notes!),
              ]),

            if (visit.nextVisitDate != null)
              _buildSection('Next Appointment', [
                _DetailRow(
                  label: 'Date',
                  value: DateFormat('EEEE, d MMMM yyyy')
                      .format(visit.nextVisitDate!),
                ),
              ]),

            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Color(0xFFE91E63),
          ),
        ),
        const SizedBox(height: 8),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(children: children),
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}

/// Detail Row
class _DetailRow extends StatelessWidget {
  final String label;
  final String value;
  final bool isAlert;

  const _DetailRow({
    required this.label,
    required this.value,
    this.isAlert = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: TextStyle(
                fontSize: 13,
                color: Colors.grey[600],
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: isAlert ? Colors.red : Colors.black87,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
