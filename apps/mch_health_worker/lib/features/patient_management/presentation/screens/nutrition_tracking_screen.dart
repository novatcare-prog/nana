import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mch_core/mch_core.dart';
import 'package:intl/intl.dart';
import '../../../../core/providers/nutrition_providers.dart';
import 'record_nutrition_screen.dart';

/// Nutrition Tracking Screen
/// Shows nutrition interventions, MUAC measurements, and supplements
class NutritionTrackingScreen extends ConsumerWidget {
  final String patientId;
  final MaternalProfile patient;

  const NutritionTrackingScreen({
    super.key,
    required this.patientId,
    required this.patient,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final nutritionAsync = ref.watch(patientNutritionRecordsProvider(patientId));
    final muacAsync = ref.watch(patientMuacMeasurementsProvider(patientId));
    final latestMuacAsync = ref.watch(latestMuacMeasurementProvider(patientId));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Nutrition Tracking'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Patient Info Card
          Card(
            color: Colors.blue.shade50,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    patient.clientName,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text('ANC Number: ${patient.ancNumber}'),
                ],
              ),
            ),
          ),

          const SizedBox(height: 24),

          // MUAC STATUS SECTION
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(Icons.straighten, color: Theme.of(context).colorScheme.primary),
                  const SizedBox(width: 8),
                  const Text(
                    'MUAC Status',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 12),

          latestMuacAsync.when(
            data: (latestMuac) => _buildMuacStatus(context, latestMuac),
            loading: () => const CircularProgressIndicator(),
            error: (error, stack) => Text('Error: $error'),
          ),

          const SizedBox(height: 24),

          // MUAC TREND CHART
          muacAsync.when(
            data: (measurements) {
              if (measurements.isEmpty) return const SizedBox.shrink();
              return _buildMuacTrend(context, measurements);
            },
            loading: () => const SizedBox.shrink(),
            error: (error, stack) => const SizedBox.shrink(),
          ),

          const SizedBox(height: 24),

          // SUPPLEMENTS & INTERVENTIONS SECTION
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(Icons.medication, color: Theme.of(context).colorScheme.primary),
                  const SizedBox(width: 8),
                  const Text(
                    'Supplements & Interventions',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 12),

          nutritionAsync.when(
            data: (records) {
              if (records.isEmpty) {
                return _buildEmptyState();
              }
              return Column(
                children: records.map((record) => _buildNutritionCard(context, record)).toList(),
              );
            },
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (error, stack) => Text('Error: $error'),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => RecordNutritionScreen(
                patientId: patientId,
                patient: patient,
              ),
            ),
          );
        },
        icon: const Icon(Icons.add),
        label: const Text('Record Nutrition'),
      ),
    );
  }

  Widget _buildMuacStatus(BuildContext context, MuacMeasurement? latest) {
    if (latest == null) {
      return Card(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Center(
            child: Column(
              children: [
                Icon(Icons.straighten, size: 48, color: Colors.grey[400]),
                const SizedBox(height: 8),
                Text(
                  'No MUAC measurements recorded',
                  style: TextStyle(color: Colors.grey[600]),
                ),
              ],
            ),
          ),
        ),
      );
    }

    final color = latest.isMalnourished ? Colors.red : Colors.green;
    final status = latest.isMalnourished ? 'Malnourished' : 'Normal';

    return Card(
      color: color.shade50,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            CircleAvatar(
              radius: 30,
              backgroundColor: color.shade100,
              child: Text(
                '${latest.muacCm}',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Latest MUAC: ${latest.muacCm} cm',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'Status: $status',
                    style: TextStyle(color: color, fontWeight: FontWeight.w500),
                  ),
                  Text(
                    DateFormat('MMM dd, yyyy').format(latest.measurementDate),
                    style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                  ),
                ],
              ),
            ),
            if (latest.isMalnourished)
              const Icon(Icons.warning, color: Colors.red, size: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildMuacTrend(BuildContext context, List<MuacMeasurement> measurements) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'MUAC Trend',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            ...measurements.take(5).map((m) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Row(
                    children: [
                      SizedBox(
                        width: 100,
                        child: Text(
                          DateFormat('MMM dd').format(m.measurementDate),
                          style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                        ),
                      ),
                      Expanded(
                        child: LinearProgressIndicator(
                          value: m.muacCm / 30,
                          backgroundColor: Colors.grey[200],
                          valueColor: AlwaysStoppedAnimation(
                            m.isMalnourished ? Colors.red : Colors.green,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '${m.muacCm} cm',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: m.isMalnourished ? Colors.red : Colors.green,
                        ),
                      ),
                    ],
                  ),
                )),
          ],
        ),
      ),
    );
  }

  Widget _buildNutritionCard(BuildContext context, NutritionRecord record) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  DateFormat('MMM dd, yyyy').format(record.recordDate),
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                if (record.isMalnourished)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.red.shade100,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Text(
                      'Malnourished',
                      style: TextStyle(fontSize: 11, color: Colors.red),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                if (record.ironFolateGiven)
                  _buildBadge('Iron/Folate: ${record.ironFolateTablets ?? 0} tabs', Icons.medication, Colors.blue),
                if (record.calciumGiven)
                  _buildBadge('Calcium: ${record.calciumTablets ?? 0} tabs', Icons.medication, Colors.purple),
                if (record.dewormingGiven)
                  _buildBadge('Deworming: ${record.dewormingDrug ?? "Given"}', Icons.healing, Colors.orange),
                if (record.muacCm != null)
                  _buildBadge('MUAC: ${record.muacCm} cm', Icons.straighten, 
                    record.isMalnourished ? Colors.red : Colors.green),
                if (record.nutritionCounselingGiven)
                  _buildBadge('Counseling Given', Icons.psychology, Colors.teal),
              ],
            ),
            if (record.notes != null && record.notes!.isNotEmpty) ...[
              const SizedBox(height: 8),
              Text(
                record.notes!,
                style: TextStyle(fontSize: 12, color: Colors.grey[600]),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildBadge(String label, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: color),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(fontSize: 12, color: color.withOpacity(0.1)),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Center(
          child: Column(
            children: [
              Icon(Icons.restaurant, size: 64, color: Colors.grey[400]),
              const SizedBox(height: 16),
              Text(
                'No Nutrition Records',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[700],
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'No nutrition interventions recorded yet',
                style: TextStyle(color: Colors.grey[600]),
              ),
            ],
          ),
        ),
      ),
    );
  }
}