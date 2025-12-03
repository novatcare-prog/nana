import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:mch_core/mch_core.dart';
import '../../../../core/providers/postnatal_visit_providers.dart';

class PostnatalVisitHistoryScreen extends ConsumerWidget {
  final MaternalProfile maternalProfile;

  const PostnatalVisitHistoryScreen({
    super.key,
    required this.maternalProfile,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final visitsAsync = ref.watch(postnatalVisitsByMaternalIdProvider(maternalProfile.id!));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Postnatal Visit History'),
        backgroundColor: Colors.teal[700],
      ),
      body: visitsAsync.when(
        data: (visits) {
          if (visits.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.medical_information, size: 64, color: Colors.grey[400]),
                  const SizedBox(height: 16),
                  Text(
                    'No postnatal visits recorded yet',
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
            itemCount: visits.length,
            itemBuilder: (context, index) {
              final visit = visits[index];
              return _buildVisitCard(context, visit);
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

  Widget _buildVisitCard(BuildContext context, PostnatalVisit visit) {
    final hasDangerSigns = visit.excessiveBleeding ||
        (visit.maternalDangerSigns != null && visit.maternalDangerSigns!.isNotEmpty) ||
        (visit.babyDangerSigns != null && visit.babyDangerSigns!.isNotEmpty);

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      shape: hasDangerSigns
          ? RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: BorderSide(color: Colors.red[700]!, width: 2),
            )
          : RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
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
                      DateFormat('dd/MM/yyyy').format(visit.visitDate),
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
                    color: Colors.teal[100],
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    visit.visitType,
                    style: TextStyle(
                      fontSize: 11,
                      color: Colors.teal[700],
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            
            // Days Postpartum Badge
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.purple[100],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                'Day ${visit.daysPostpartum} postpartum',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.purple[700],
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            const SizedBox(height: 12),

            // Mother's Health Section
            if (visit.motherTemperature != null ||
                visit.motherBloodPressure != null ||
                visit.motherWeight != null) ...[
              _buildSubsectionTitle('Mother\'s Health'),
              const SizedBox(height: 4),
              if (visit.motherTemperature != null)
                _buildInfoRow('Temperature', '${visit.motherTemperature}°C'),
              if (visit.motherBloodPressure != null)
                _buildInfoRow('Blood Pressure', visit.motherBloodPressure!),
              if (visit.motherPulse != null)
                _buildInfoRow('Pulse', '${visit.motherPulse} bpm'),
              if (visit.motherWeight != null)
                _buildInfoRow('Weight', '${visit.motherWeight} kg'),
              const SizedBox(height: 12),
            ],

            // Complications
            if (visit.excessiveBleeding ||
                visit.foulDischarge ||
                visit.breastProblems ||
                visit.perinealWoundInfection ||
                visit.cSectionWoundInfection ||
                visit.urinaryProblems) ...[
              _buildSubsectionTitle('Complications Noted'),
              const SizedBox(height: 4),
              if (visit.excessiveBleeding)
                _buildWarningChip('Excessive bleeding'),
              if (visit.foulDischarge)
                _buildWarningChip('Foul discharge'),
              if (visit.breastProblems)
                _buildWarningChip('Breast problems'),
              if (visit.perinealWoundInfection)
                _buildWarningChip('Perineal infection'),
              if (visit.cSectionWoundInfection)
                _buildWarningChip('C-section infection'),
              if (visit.urinaryProblems)
                _buildWarningChip('Urinary problems'),
              const SizedBox(height: 12),
            ],

            // Maternal Danger Signs
            if (visit.maternalDangerSigns != null && visit.maternalDangerSigns!.isNotEmpty) ...[
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
                          'Maternal Danger Signs',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.red[700],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      visit.maternalDangerSigns!,
                      style: TextStyle(color: Colors.red[900], fontSize: 13),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
            ],

            // Mental Health
            if (visit.moodAssessment != null) ...[
              _buildInfoRow('Mood', visit.moodAssessment!),
              if (visit.mentalHealthNotes != null && visit.mentalHealthNotes!.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(left: 8, top: 4),
                  child: Text(
                    visit.mentalHealthNotes!,
                    style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                  ),
                ),
              const SizedBox(height: 12),
            ],

            // Baby's Health Section
            if (visit.babyWeight != null ||
                visit.babyTemperature != null ||
                !visit.babyFeedingWell) ...[
              _buildSubsectionTitle('Baby\'s Health'),
              const SizedBox(height: 4),
              if (visit.babyWeight != null)
                _buildInfoRow('Weight', '${visit.babyWeight} kg'),
              if (visit.babyTemperature != null)
                _buildInfoRow('Temperature', '${visit.babyTemperature}°C'),
              _buildInfoRow('Feeding', visit.babyFeedingWell ? 'Well' : 'Poorly'),
              if (visit.cordStatus != null)
                _buildInfoRow('Cord Status', visit.cordStatus!),
              const SizedBox(height: 12),
            ],

            // Jaundice
            if (visit.jaundicePresent) ...[
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.orange[50],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Icon(Icons.warning, color: Colors.orange[700], size: 18),
                    const SizedBox(width: 8),
                    Text(
                      'Jaundice: ${visit.jaundiceSeverity ?? "Present"}',
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        color: Colors.orange[900],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
            ],

            // Baby Danger Signs
            if (visit.babyDangerSigns != null && visit.babyDangerSigns!.isNotEmpty) ...[
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
                          'Baby Danger Signs',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.red[700],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      visit.babyDangerSigns!,
                      style: TextStyle(color: Colors.red[900], fontSize: 13),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
            ],

            // Breastfeeding
            if (visit.breastfeedingStatus != null) ...[
              _buildSubsectionTitle('Breastfeeding'),
              const SizedBox(height: 4),
              _buildInfoRow('Status', visit.breastfeedingStatus!),
              if (visit.latchQuality != null)
                _buildInfoRow('Latch', visit.latchQuality!),
              if (visit.breastfeedingChallenges != null &&
                  visit.breastfeedingChallenges!.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(left: 8, top: 4),
                  child: Text(
                    'Challenges: ${visit.breastfeedingChallenges}',
                    style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                  ),
                ),
              const SizedBox(height: 12),
            ],

            // Family Planning
            if (visit.familyPlanningDiscussed) ...[
              _buildSubsectionTitle('Family Planning'),
              const SizedBox(height: 4),
              if (visit.familyPlanningMethodChosen != null)
                _buildInfoRow('Method', visit.familyPlanningMethodChosen!),
              if (visit.familyPlanningMethodProvided)
                Chip(
                  label: const Text('Method provided', style: TextStyle(fontSize: 11)),
                  backgroundColor: Colors.green[100],
                  avatar: Icon(Icons.check_circle, size: 16, color: Colors.green[700]),
                ),
              const SizedBox(height: 12),
            ],

            // Immunizations
            if (visit.immunizationsGiven != null && visit.immunizationsGiven!.isNotEmpty) ...[
              _buildSubsectionTitle('Immunizations Given'),
              const SizedBox(height: 4),
              Wrap(
                spacing: 4,
                runSpacing: 4,
                children: visit.immunizationsGiven!.split(', ').map((immunization) {
                  return Chip(
                    label: Text(immunization, style: const TextStyle(fontSize: 11)),
                    backgroundColor: Colors.blue[50],
                  );
                }).toList(),
              ),
              const SizedBox(height: 12),
            ],

            // Referral
            if (visit.referralMade) ...[
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.orange[50],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.local_hospital, color: Colors.orange[700], size: 20),
                        const SizedBox(width: 8),
                        Text(
                          'Referral Made',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.orange[700],
                          ),
                        ),
                      ],
                    ),
                    if (visit.referralTo != null) ...[
                      const SizedBox(height: 4),
                      Text('To: ${visit.referralTo}'),
                    ],
                    if (visit.referralReason != null) ...[
                      const SizedBox(height: 4),
                      Text('Reason: ${visit.referralReason}'),
                    ],
                  ],
                ),
              ),
              const SizedBox(height: 12),
            ],

            // Next Visit
            if (visit.nextVisitDate != null) ...[
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.blue[50],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Icon(Icons.event, color: Colors.blue[700], size: 20),
                    const SizedBox(width: 8),
                    Text(
                      'Next visit: ${DateFormat('dd/MM/yyyy').format(visit.nextVisitDate!)}',
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        color: Colors.blue[900],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
            ],

            // General Notes
            if (visit.generalNotes != null && visit.generalNotes!.isNotEmpty) ...[
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
                        visit.generalNotes!,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[800],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
            ],

            // Attended By
            if (visit.attendedBy != null) ...[
              Row(
                children: [
                  Icon(Icons.person, size: 14, color: Colors.grey[500]),
                  const SizedBox(width: 4),
                  Text(
                    'Attended by: ${visit.attendedBy}',
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

  Widget _buildSubsectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 14,
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        children: [
          Text(
            '$label: ',
            style: const TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 13,
            ),
          ),
          Text(
            value,
            style: TextStyle(fontSize: 13, color: Colors.grey[700]),
          ),
        ],
      ),
    );
  }

  Widget _buildWarningChip(String label) {
    return Padding(
      padding: const EdgeInsets.only(right: 8, bottom: 4),
      child: Chip(
        label: Text(label, style: const TextStyle(fontSize: 11)),
        backgroundColor: Colors.red[50],
        avatar: Icon(Icons.warning, size: 16, color: Colors.red[700]),
      ),
    );
  }
}