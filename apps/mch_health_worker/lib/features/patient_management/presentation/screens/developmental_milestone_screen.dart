import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:mch_core/mch_core.dart';
import '../../../../core/providers/developmental_milestone_providers.dart';
import 'add_milestone_screen.dart';
import 'milestone_history_screen.dart';

class DevelopmentalMilestonesScreen extends ConsumerWidget {
  final ChildProfile child;

  const DevelopmentalMilestonesScreen({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final milestonesAsync = ref.watch(milestonesByChildProvider(child.id));
    final latestMilestoneAsync = ref.watch(latestMilestoneProvider(child.id));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Developmental Milestones'),
        backgroundColor: Colors.purple[700],
        actions: [
          TextButton.icon(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => MilestoneHistoryScreen(child: child),
                ),
              );
            },
            icon: const Icon(Icons.history, color: Colors.white),
            label: const Text(
              'View History',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Child Info Card
            _buildChildInfoCard(context),
            const SizedBox(height: 16),

            // Latest Assessment Card
            latestMilestoneAsync.when(
              data: (latestMilestone) => _buildLatestAssessmentCard(
                context,
                latestMilestone,
              ),
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, stack) => Text('Error: $error'),
            ),
            const SizedBox(height: 16),

            // Summary Card
            milestonesAsync.when(
              data: (milestones) => _buildSummaryCard(context, milestones),
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, stack) => Text('Error: $error'),
            ),
            const SizedBox(height: 16),

            // Expected Milestones by Age
            _buildExpectedMilestonesCard(context),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddMilestoneScreen(child: child),
            ),
          );
        },
        backgroundColor: Colors.purple[700],
        icon: const Icon(Icons.add),
        label: const Text('Add Assessment'),
      ),
    );
  }

  Widget _buildChildInfoCard(BuildContext context) {
    final ageInMonths = DateTime.now().difference(child.dateOfBirth).inDays ~/ 30;
    final ageInYears = ageInMonths ~/ 12;
    final remainingMonths = ageInMonths % 12;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            CircleAvatar(
              radius: 30,
              backgroundColor: child.sex == 'Male' ? Colors.blue[100] : Colors.pink[100],
              child: Icon(
                child.sex == 'Male' ? Icons.boy : Icons.girl,
                size: 35,
                color: child.sex == 'Male' ? Colors.blue[700] : Colors.pink[700],
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    child.childName,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${child.sex} • ${ageInYears > 0 ? '$ageInYears year${ageInYears > 1 ? 's' : ''} ' : ''}$remainingMonths month${remainingMonths != 1 ? 's' : ''}',
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 14,
                    ),
                  ),
                  Text(
                    'DOB: ${DateFormat('dd/MM/yyyy').format(child.dateOfBirth)}',
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLatestAssessmentCard(
    BuildContext context,
    DevelopmentalMilestone? latestMilestone,
  ) {
    if (latestMilestone == null) {
      return Card(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Center(
            child: Column(
              children: [
                Icon(Icons.assignment, size: 48, color: Colors.grey[400]),
                const SizedBox(height: 8),
                Text(
                  'No assessments recorded yet',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Tap the button below to add the first assessment',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[500],
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      );
    }

    final statusColor = latestMilestone.overallStatus == 'On Track'
        ? Colors.green
        : latestMilestone.overallStatus == 'Needs Monitoring'
            ? Colors.orange
            : Colors.red;

    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Latest Assessment',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: statusColor),
                  ),
                  child: Text(
                    latestMilestone.overallStatus ?? 'Unknown',
                    style: TextStyle(
                      fontSize: 12,
                      color: statusColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              'Date: ${DateFormat('dd/MM/yyyy').format(latestMilestone.assessmentDate)}',
              style: TextStyle(color: Colors.grey[700]),
            ),
            if (latestMilestone.ageAtAssessmentMonths != null)
              Text(
                'Age at assessment: ${latestMilestone.ageAtAssessmentMonths} months',
                style: TextStyle(color: Colors.grey[700]),
              ),
            const SizedBox(height: 16),
            
            // Development Areas
            _buildDevelopmentArea(
              'Gross Motor',
              latestMilestone.motorGrossAppropriate,
              latestMilestone.motorGrossNotes,
            ),
            _buildDevelopmentArea(
              'Fine Motor',
              latestMilestone.motorFineAppropriate,
              latestMilestone.motorFineNotes,
            ),
            _buildDevelopmentArea(
              'Language',
              latestMilestone.languageAppropriate,
              latestMilestone.languageNotes,
            ),
            _buildDevelopmentArea(
              'Social/Emotional',
              latestMilestone.socialAppropriate,
              latestMilestone.socialNotes,
            ),
            _buildDevelopmentArea(
              'Cognitive',
              latestMilestone.cognitiveAppropriate,
              latestMilestone.cognitiveNotes,
            ),

            if (latestMilestone.redFlagsPresent) ...[
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.red[50],
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.red[300]!),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.warning, color: Colors.red[700], size: 20),
                        const SizedBox(width: 8),
                        Text(
                          'Red Flags Identified',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.red[700],
                          ),
                        ),
                      ],
                    ),
                    if (latestMilestone.redFlagsDescription != null) ...[
                      const SizedBox(height: 8),
                      Text(
                        latestMilestone.redFlagsDescription!,
                        style: TextStyle(color: Colors.red[900]),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildDevelopmentArea(String area, bool isAppropriate, String? notes) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            isAppropriate ? Icons.check_circle : Icons.warning,
            color: isAppropriate ? Colors.green : Colors.orange,
            size: 20,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  area,
                  style: const TextStyle(fontWeight: FontWeight.w500),
                ),
                if (notes != null && notes.isNotEmpty)
                  Text(
                    notes,
                    style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryCard(BuildContext context, List<DevelopmentalMilestone> milestones) {
    final totalAssessments = milestones.length;
    final onTrack = milestones.where((m) => m.overallStatus == 'On Track').length;
    final needsMonitoring = milestones.where((m) => m.overallStatus == 'Needs Monitoring').length;
    final withRedFlags = milestones.where((m) => m.redFlagsPresent).length;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Assessment Summary',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildSummaryTile(
                    'Total',
                    totalAssessments.toString(),
                    Icons.assignment,
                    Colors.purple,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildSummaryTile(
                    'On Track',
                    onTrack.toString(),
                    Icons.check_circle,
                    Colors.green,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _buildSummaryTile(
                    'Monitoring',
                    needsMonitoring.toString(),
                    Icons.visibility,
                    Colors.orange,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildSummaryTile(
                    'Red Flags',
                    withRedFlags.toString(),
                    Icons.warning,
                    Colors.red,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryTile(String label, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[700],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExpectedMilestonesCard(BuildContext context) {
    final ageInMonths = DateTime.now().difference(child.dateOfBirth).inDays ~/ 30;
    
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Assessment Schedule',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Regular developmental assessments should be conducted at:',
              style: TextStyle(color: Colors.grey[700]),
            ),
            const SizedBox(height: 12),
            _buildScheduleItem('6 weeks', ageInMonths >= 1.5),
            _buildScheduleItem('10 weeks', ageInMonths >= 2.5),
            _buildScheduleItem('6 months', ageInMonths >= 6),
            _buildScheduleItem('9 months', ageInMonths >= 9),
            _buildScheduleItem('12 months (1 year)', ageInMonths >= 12),
            _buildScheduleItem('18 months', ageInMonths >= 18),
            _buildScheduleItem('2 years', ageInMonths >= 24),
            _buildScheduleItem('3 years', ageInMonths >= 36),
            _buildScheduleItem('4 years', ageInMonths >= 48),
            _buildScheduleItem('5 years', ageInMonths >= 60),
          ],
        ),
      ),
    );
  }

  Widget _buildScheduleItem(String ageLabel, bool isReached) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(
            isReached ? Icons.check_circle : Icons.radio_button_unchecked,
            size: 16,
            color: isReached ? Colors.green : Colors.grey,
          ),
          const SizedBox(width: 8),
          Text(
            ageLabel,
            style: TextStyle(
              fontSize: 14,
              color: isReached ? Colors.grey[800] : Colors.grey[500],
            ),
          ),
        ],
      ),
    );
  }
}