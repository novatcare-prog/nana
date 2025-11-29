import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mch_core/mch_core.dart';
import '../../../../core/providers/growth_monitoring_providers.dart';
import 'growth_record_screen.dart';

/// Growth History Screen
/// Shows all growth measurements for a child
class GrowthHistoryScreen extends ConsumerWidget {
  final String childId;
  final ChildProfile child;

  const GrowthHistoryScreen({
    super.key,
    required this.childId,
    required this.child,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final recordsAsync = ref.watch(childGrowthRecordsProvider(childId));

    return Scaffold(
      appBar: AppBar(
        title: Text('Growth History - ${child.childName}'),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddGrowthRecordScreen(
                childId: childId,
                child: child,
              ),
            ),
          );
        },
        icon: const Icon(Icons.add),
        label: const Text('Add Measurement'),
      ),
      body: recordsAsync.when(
        data: (records) {
          if (records.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.show_chart, size: 64, color: Colors.grey[400]),
                  const SizedBox(height: 16),
                  Text(
                    'No Growth Records Yet',
                    style: TextStyle(fontSize: 18, color: Colors.grey[600]),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Tap the button below to add the first measurement',
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: records.length,
            itemBuilder: (context, index) {
              final record = records[index];
              return _buildRecordCard(context, record);
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 64, color: Colors.red),
              const SizedBox(height: 16),
              Text('Error loading records: $error'),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRecordCard(BuildContext context, GrowthRecord record) {
    // Determine if we should show length or height
    final measurement = record.lengthCm ?? record.heightCm;
    final measurementLabel = record.measuredLying == true ? 'Length' : 'Height';

    // Alert color based on nutritional status
    Color? statusColor;
    if (record.edemaPresent) {
      statusColor = Colors.red;
    } else if (record.nutritionalStatus == 'Severely Underweight') {
      statusColor = Colors.red;
    } else if (record.nutritionalStatus == 'Underweight') {
      statusColor = Colors.orange;
    } else if (record.referredForNutrition == true) {
      statusColor = Colors.orange;
    }

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      color: statusColor?.withOpacity(0.1),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: statusColor != null
            ? BorderSide(color: statusColor, width: 2)
            : BorderSide.none,
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Date and Age
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  _formatDate(record.measurementDate),
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade100,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '${record.ageInMonths} months',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Measurements Grid
            Row(
              children: [
                Expanded(
                  child: _buildMeasurementTile(
                    'Weight',
                    '${record.weightKg} kg',
                    Icons.monitor_weight,
                    Colors.blue,
                  ),
                ),
                if (measurement != null)
                  Expanded(
                    child: _buildMeasurementTile(
                      measurementLabel,
                      '${measurement.toStringAsFixed(1)} cm',
                      Icons.height,
                      Colors.green,
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 8),

            Row(
              children: [
                if (record.muacCm != null)
                  Expanded(
                    child: _buildMeasurementTile(
                      'MUAC',
                      '${record.muacCm!.toStringAsFixed(1)} cm',
                      Icons.straighten,
                      Colors.orange,
                    ),
                  ),
                if (record.headCircumferenceCm != null)
                  Expanded(
                    child: _buildMeasurementTile(
                      'Head Circ.',
                      '${record.headCircumferenceCm!.toStringAsFixed(1)} cm',
                      Icons.circle_outlined,
                      Colors.purple,
                    ),
                  ),
              ],
            ),

            // Status Indicators
            if (record.nutritionalStatus != null || record.edemaPresent) ...[
              const SizedBox(height: 12),
              const Divider(),
              const SizedBox(height: 8),
              if (record.edemaPresent) ...[
                _buildStatusChip(
                  '⚠️ Edema Present ${record.edemaGrade ?? ""}',
                  Colors.red,
                ),
                const SizedBox(height: 4),
              ],
              if (record.nutritionalStatus != null)
                _buildStatusChip(
                  'Status: ${record.nutritionalStatus}',
                  statusColor ?? Colors.green,
                ),
              if (record.referredForNutrition == true) ...[
                const SizedBox(height: 4),
                _buildStatusChip('Referred for Nutrition', Colors.orange),
              ],
            ],

            // Concerns
            if (record.concerns != null && record.concerns!.isNotEmpty) ...[
              const SizedBox(height: 12),
              const Divider(),
              const SizedBox(height: 8),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.warning_amber, size: 16, color: Colors.orange),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      record.concerns!,
                      style: const TextStyle(fontSize: 14),
                    ),
                  ),
                ],
              ),
            ],

            // Recorded By
            if (record.recordedBy != null) ...[
              const SizedBox(height: 8),
              Text(
                'Recorded by: ${record.recordedBy}',
                style: TextStyle(fontSize: 12, color: Colors.grey[600]),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildMeasurementTile(String label, String value, IconData icon, Color color) {
    return Container(
      margin: const EdgeInsets.all(4),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          Text(
            label,
            style: TextStyle(fontSize: 12, color: Colors.grey[700]),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusChip(String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: color,
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}