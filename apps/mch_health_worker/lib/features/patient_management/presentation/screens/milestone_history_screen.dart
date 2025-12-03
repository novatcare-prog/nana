import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:mch_core/mch_core.dart';
import '../../../../core/providers/developmental_milestone_providers.dart';

class MilestoneHistoryScreen extends ConsumerWidget {
  final ChildProfile child;

  const MilestoneHistoryScreen({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final milestonesAsync = ref.watch(milestonesByChildProvider(child.id));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Assessment History'),
        backgroundColor: Colors.purple[700],
      ),
      body: milestonesAsync.when(
        data: (milestones) {
          if (milestones.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.assignment, size: 64, color: Colors.grey[400]),
                  const SizedBox(height: 16),
                  Text(
                    'No assessments recorded yet',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: milestones.length,
            itemBuilder: (context, index) {
              final milestone = milestones[index];
              return _buildMilestoneCard(context, milestone);
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
          child: Text('Error: $error'),
        ),
      ),
    );
  }

  Widget _buildMilestoneCard(BuildContext context, DevelopmentalMilestone milestone) {
    final statusColor = milestone.overallStatus == 'On Track'
        ? Colors.green
        : milestone.overallStatus == 'Needs Monitoring'
            ? Colors.orange
            : Colors.red;

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: milestone.redFlagsPresent ? Colors.red : Colors.transparent,
          width: 2,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(Icons.calendar_today, size: 16, color: Colors.grey[600]),
                    const SizedBox(width: 4),
                    Text(
                      DateFormat('dd/MM/yyyy').format(milestone.assessmentDate),
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: statusColor),
                  ),
                  child: Text(
                    milestone.overallStatus ?? 'Unknown',
                    style: TextStyle(
                      fontSize: 11,
                      color: statusColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            
            // Age Badge
            if (milestone.ageAtAssessmentMonths != null)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.purple[100],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  'Age: ${milestone.ageAtAssessmentMonths} months',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.purple[700],
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            const SizedBox(height: 12),

            // Development Areas
            _buildAreaRow('Gross Motor', milestone.motorGrossAppropriate),
            _buildAreaRow('Fine Motor', milestone.motorFineAppropriate),
            _buildAreaRow('Language', milestone.languageAppropriate),
            _buildAreaRow('Social/Emotional', milestone.socialAppropriate),
            _buildAreaRow('Cognitive', milestone.cognitiveAppropriate),

            // Red Flags Warning
            if (milestone.redFlagsPresent) ...[
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.red[50],
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.red[300]!),
                ),
                child: Row(
                  children: [
                    Icon(Icons.warning, color: Colors.red[700], size: 20),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Red Flags Present',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.red[700],
                              fontSize: 12,
                            ),
                          ),
                          if (milestone.redFlagsDescription != null) ...[
                            const SizedBox(height: 4),
                            Text(
                              milestone.redFlagsDescription!,
                              style: TextStyle(
                                fontSize: 11,
                                color: Colors.red[900],
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],

            // Intervention Info
            if (milestone.interventionNeeded || milestone.referralMade) ...[
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  if (milestone.interventionNeeded)
                    Chip(
                      avatar: Icon(Icons.medical_services, size: 16, color: Colors.blue[700]),
                      label: const Text('Intervention', style: TextStyle(fontSize: 11)),
                      backgroundColor: Colors.blue[50],
                    ),
                  if (milestone.referralMade)
                    Chip(
                      avatar: Icon(Icons.person_search, size: 16, color: Colors.orange[700]),
                      label: Text(
                        milestone.referralTo ?? 'Referral',
                        style: const TextStyle(fontSize: 11),
                      ),
                      backgroundColor: Colors.orange[50],
                    ),
                ],
              ),
            ],

            // General Notes
            if (milestone.generalNotes != null && milestone.generalNotes!.isNotEmpty) ...[
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(Icons.note, size: 16, color: Colors.grey[600]),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        milestone.generalNotes!,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[800],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],

            // Assessed By
            if (milestone.assessedBy != null) ...[
              const SizedBox(height: 12),
              Row(
                children: [
                  Icon(Icons.person, size: 14, color: Colors.grey[500]),
                  const SizedBox(width: 4),
                  Text(
                    'Assessed by: ${milestone.assessedBy}',
                    style: TextStyle(
                      fontSize: 11,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildAreaRow(String label, bool isAppropriate) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(
            isAppropriate ? Icons.check_circle : Icons.warning,
            color: isAppropriate ? Colors.green : Colors.orange,
            size: 18,
          ),
          const SizedBox(width: 8),
          Text(
            label,
            style: const TextStyle(fontSize: 13),
          ),
        ],
      ),
    );
  }
}