import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:mch_core/mch_core.dart';
import '../../../../core/providers/postnatal_visit_providers.dart';
import 'add_postnatal_visit_screen.dart';
import 'postnatal_visit_history_screen.dart';

class PostnatalCareScreen extends ConsumerWidget {
  final MaternalProfile maternalProfile;

  const PostnatalCareScreen({
    super.key,
    required this.maternalProfile,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final visitsAsync = ref.watch(postnatalVisitsByMaternalIdProvider(maternalProfile.id!));
    final latestVisitAsync = ref.watch(latestPostnatalVisitProvider(maternalProfile.id!));
    final totalVisitsAsync = ref.watch(totalPostnatalVisitsCountProvider(maternalProfile.id!));

    // Calculate days postpartum
    final deliveryDate = maternalProfile.edd; // Assuming delivery on EDD for now
    final daysPostpartum = deliveryDate != null 
        ? DateTime.now().difference(deliveryDate).inDays 
        : null;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Postnatal Care'),
        backgroundColor: Colors.teal[700],
        actions: [
          TextButton.icon(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PostnatalVisitHistoryScreen(
                    maternalProfile: maternalProfile,
                  ),
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
            // Mother Info Card
            _buildMotherInfoCard(context, daysPostpartum),
            const SizedBox(height: 16),

            // Latest Visit Card
            latestVisitAsync.when(
              data: (latestVisit) => _buildLatestVisitCard(context, latestVisit),
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, stack) => Text('Error: $error'),
            ),
            const SizedBox(height: 16),

            // Summary Card
            totalVisitsAsync.when(
              data: (totalVisits) => visitsAsync.when(
                data: (visits) => _buildSummaryCard(context, totalVisits, visits),
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (error, stack) => Text('Error: $error'),
              ),
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, stack) => Text('Error: $error'),
            ),
            const SizedBox(height: 16),

            // Visit Schedule Card
            _buildVisitScheduleCard(context, daysPostpartum),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddPostnatalVisitScreen(
                maternalProfile: maternalProfile,
              ),
            ),
          );
        },
        backgroundColor: Colors.teal[700],
        icon: const Icon(Icons.add),
        label: const Text('Record Visit'),
      ),
    );
  }

  Widget _buildMotherInfoCard(BuildContext context, int? daysPostpartum) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            CircleAvatar(
              radius: 30,
              backgroundColor: Colors.teal[100],
              child: Icon(
                Icons.pregnant_woman,
                size: 35,
                color: Colors.teal[700],
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    maternalProfile.clientName,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  if (daysPostpartum != null) ...[
                    Text(
                      'Days Postpartum: $daysPostpartum',
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    if (daysPostpartum <= 42)
                      Container(
                        margin: const EdgeInsets.only(top: 4),
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.orange[100],
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          'Critical Period',
                          style: TextStyle(
                            fontSize: 11,
                            color: Colors.orange[900],
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                  ] else
                    Text(
                      'Delivery date not recorded',
                      style: TextStyle(
                        color: Colors.grey[500],
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

  Widget _buildLatestVisitCard(BuildContext context, PostnatalVisit? latestVisit) {
    if (latestVisit == null) {
      return Card(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Center(
            child: Column(
              children: [
                Icon(Icons.medical_information, size: 48, color: Colors.grey[400]),
                const SizedBox(height: 8),
                Text(
                  'No postnatal visits recorded yet',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Tap the button below to record the first visit',
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

    final hasDangerSigns = latestVisit.excessiveBleeding ||
        (latestVisit.maternalDangerSigns != null && latestVisit.maternalDangerSigns!.isNotEmpty) ||
        (latestVisit.babyDangerSigns != null && latestVisit.babyDangerSigns!.isNotEmpty);

    return Card(
      elevation: 2,
      shape: hasDangerSigns
          ? RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: BorderSide(color: Colors.red[700]!, width: 2),
            )
          : null,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Latest Visit',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.teal[100],
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    latestVisit.visitType,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.teal[700],
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              'Date: ${DateFormat('dd/MM/yyyy').format(latestVisit.visitDate)}',
              style: TextStyle(color: Colors.grey[700]),
            ),
            Text(
              'Days postpartum: ${latestVisit.daysPostpartum}',
              style: TextStyle(color: Colors.grey[700]),
            ),
            const SizedBox(height: 16),

            // Mother's Health
            _buildInfoSection('Mother\'s Health', [
              if (latestVisit.motherTemperature != null)
                'Temperature: ${latestVisit.motherTemperature}°C',
              if (latestVisit.motherBloodPressure != null)
                'BP: ${latestVisit.motherBloodPressure}',
              if (latestVisit.motherWeight != null)
                'Weight: ${latestVisit.motherWeight} kg',
            ]),

            if (hasDangerSigns) ...[
              const SizedBox(height: 12),
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
                          'Danger Signs Present',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.red[700],
                          ),
                        ),
                      ],
                    ),
                    if (latestVisit.excessiveBleeding) ...[
                      const SizedBox(height: 8),
                      Text('• Excessive bleeding', style: TextStyle(color: Colors.red[900])),
                    ],
                    if (latestVisit.maternalDangerSigns != null &&
                        latestVisit.maternalDangerSigns!.isNotEmpty) ...[
                      const SizedBox(height: 4),
                      Text('• ${latestVisit.maternalDangerSigns}',
                          style: TextStyle(color: Colors.red[900])),
                    ],
                  ],
                ),
              ),
            ],

            // Baby's Health
            const SizedBox(height: 16),
            _buildInfoSection('Baby\'s Health', [
              if (latestVisit.babyWeight != null) 'Weight: ${latestVisit.babyWeight} kg',
              if (latestVisit.babyTemperature != null)
                'Temperature: ${latestVisit.babyTemperature}°C',
              'Feeding: ${latestVisit.babyFeedingWell ? "Well" : "Poorly"}',
              if (latestVisit.cordStatus != null) 'Cord: ${latestVisit.cordStatus}',
            ]),

            // Breastfeeding
            if (latestVisit.breastfeedingStatus != null) ...[
              const SizedBox(height: 16),
              _buildInfoSection('Breastfeeding', [
                'Status: ${latestVisit.breastfeedingStatus}',
                if (latestVisit.latchQuality != null) 'Latch: ${latestVisit.latchQuality}',
              ]),
            ],

            // Next Visit
            if (latestVisit.nextVisitDate != null) ...[
              const SizedBox(height: 16),
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
                      'Next visit: ${DateFormat('dd/MM/yyyy').format(latestVisit.nextVisitDate!)}',
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        color: Colors.blue[900],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildInfoSection(String title, List<String> items) {
    if (items.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 4),
        ...items.map((item) => Padding(
              padding: const EdgeInsets.only(left: 8, top: 2),
              child: Text(
                '• $item',
                style: TextStyle(fontSize: 13, color: Colors.grey[700]),
              ),
            )),
      ],
    );
  }

  Widget _buildSummaryCard(BuildContext context, int totalVisits, List<PostnatalVisit> visits) {
    final visitsWithDangerSigns = visits.where((v) =>
        v.excessiveBleeding ||
        (v.maternalDangerSigns != null && v.maternalDangerSigns!.isNotEmpty) ||
        (v.babyDangerSigns != null && v.babyDangerSigns!.isNotEmpty)).length;
    
    final familyPlanningProvided = visits.where((v) => v.familyPlanningMethodProvided).length;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Care Summary',
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
                    'Total Visits',
                    totalVisits.toString(),
                    Icons.medical_information,
                    Colors.teal,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildSummaryTile(
                    'Danger Signs',
                    visitsWithDangerSigns.toString(),
                    Icons.warning,
                    Colors.red,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _buildSummaryTile(
                    'Family Planning',
                    familyPlanningProvided.toString(),
                    Icons.health_and_safety,
                    Colors.purple,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(child: Container()), // Empty space for symmetry
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
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildVisitScheduleCard(BuildContext context, int? daysPostpartum) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Postnatal Visit Schedule',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Standard postnatal care visits:',
              style: TextStyle(color: Colors.grey[700]),
            ),
            const SizedBox(height: 12),
            _buildScheduleItem('48 hours (2 days)', daysPostpartum != null && daysPostpartum >= 2),
            _buildScheduleItem('6 days', daysPostpartum != null && daysPostpartum >= 6),
            _buildScheduleItem('6 weeks (42 days)', daysPostpartum != null && daysPostpartum >= 42),
            _buildScheduleItem('6 months (180 days)', daysPostpartum != null && daysPostpartum >= 180),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.orange[50],
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.orange[200]!),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.info, color: Colors.orange[700], size: 20),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'The first 42 days (6 weeks) postpartum is the critical period. Ensure all scheduled visits are completed.',
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.orange[900],
                      ),
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

  Widget _buildScheduleItem(String visitLabel, bool isReached) {
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
            visitLabel,
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