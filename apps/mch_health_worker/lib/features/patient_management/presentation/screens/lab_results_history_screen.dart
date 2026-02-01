import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mch_core/mch_core.dart';
import 'package:intl/intl.dart';
import '../../../../core/providers/lab_result_providers.dart';
import 'lab_result_screen.dart';

/// Clean Lab Results History Screen
class LabResultsHistoryScreen extends ConsumerWidget {
  final String patientId;
  final MaternalProfile patient;

  const LabResultsHistoryScreen({
    super.key,
    required this.patientId,
    required this.patient,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final labResultsAsync = ref.watch(patientLabResultsProvider(patientId));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Lab Results'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () =>
                ref.invalidate(patientLabResultsProvider(patientId)),
          ),
        ],
      ),
      body: labResultsAsync.when(
        data: (results) {
          if (results.isEmpty) {
            return _buildEmptyState(context);
          }
          return _buildResultsList(context, results);
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => _buildErrorState(context, ref, error),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => RecordLabResultScreen(
                patientId: patientId,
                patient: patient,
              ),
            ),
          );
        },
        icon: const Icon(Icons.add),
        label: const Text('New Result'),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.science_outlined, size: 80, color: Colors.grey[300]),
            const SizedBox(height: 24),
            Text(
              'No Lab Results',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.grey[700],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'No laboratory tests have been recorded for this patient yet.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey[500]),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorState(BuildContext context, WidgetRef ref, Object error) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 64, color: Colors.red),
            const SizedBox(height: 16),
            Text(
              'Error loading results',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.grey[700],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '$error',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey[500]),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () =>
                  ref.invalidate(patientLabResultsProvider(patientId)),
              icon: const Icon(Icons.refresh),
              label: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResultsList(BuildContext context, List<LabResult> results) {
    final abnormalCount = results.where((r) => r.isAbnormal).length;
    final testTypes = results.map((r) => r.testType).toSet().length;

    // Group by test type
    final grouped = <LabTestType, List<LabResult>>{};
    for (final result in results) {
      grouped.putIfAbsent(result.testType, () => []).add(result);
    }

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // Summary Card
        Card(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Summary',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[700],
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _SummaryItem(
                        '${results.length}', 'Total Tests', Colors.blue),
                    _SummaryItem('$testTypes', 'Test Types', Colors.purple),
                    _SummaryItem('$abnormalCount', 'Abnormal', Colors.red),
                  ],
                ),
              ],
            ),
          ),
        ),

        const SizedBox(height: 20),

        // Grouped Results
        ...grouped.entries.map((entry) => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Section Header
                Padding(
                  padding: const EdgeInsets.only(bottom: 8, top: 8),
                  child: Row(
                    children: [
                      Icon(
                        _getTestIcon(entry.key),
                        size: 18,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        _formatTestType(entry.key),
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          '${entry.value.length}',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: Colors.grey[700],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // Results
                ...entry.value
                    .map((result) => _buildResultCard(context, result)),
              ],
            )),

        const SizedBox(height: 80),
      ],
    );
  }

  Widget _buildResultCard(BuildContext context, LabResult result) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: InkWell(
        onTap: () => _showDetails(context, result),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              // Status Icon
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: result.isAbnormal
                      ? Colors.red.shade50
                      : Colors.green.shade50,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  result.isAbnormal
                      ? Icons.warning_rounded
                      : Icons.check_circle,
                  color: result.isAbnormal ? Colors.red : Colors.green,
                  size: 22,
                ),
              ),
              const SizedBox(width: 14),

              // Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      result.testName,
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Text(
                          '${result.resultValue}${result.resultUnit != null ? " ${result.resultUnit}" : ""}',
                          style: TextStyle(
                            color: result.isAbnormal
                                ? Colors.red
                                : Colors.grey[700],
                            fontWeight: result.isAbnormal
                                ? FontWeight.bold
                                : FontWeight.normal,
                          ),
                        ),
                        if (result.referenceRange != null) ...[
                          const SizedBox(width: 8),
                          Text(
                            '(${result.referenceRange})',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[500],
                            ),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),

              // Date
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    DateFormat('MMM d').format(result.testDate),
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey[600],
                    ),
                  ),
                  Text(
                    DateFormat('yyyy').format(result.testDate),
                    style: TextStyle(
                      fontSize: 11,
                      color: Colors.grey[500],
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

  void _showDetails(BuildContext context, LabResult result) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: result.isAbnormal
                        ? Colors.red.shade50
                        : Colors.green.shade50,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    result.isAbnormal ? Icons.warning : Icons.check_circle,
                    color: result.isAbnormal ? Colors.red : Colors.green,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        result.testName,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        result.isAbnormal ? 'Abnormal Result' : 'Normal Result',
                        style: TextStyle(
                          color: result.isAbnormal ? Colors.red : Colors.green,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),
            const Divider(),
            const SizedBox(height: 16),

            // Details
            _DetailRow('Test Date',
                DateFormat('MMMM d, yyyy').format(result.testDate)),
            _DetailRow('Result',
                '${result.resultValue}${result.resultUnit != null ? " ${result.resultUnit}" : ""}'),
            if (result.referenceRange != null)
              _DetailRow('Reference Range', result.referenceRange!),
            if (result.notes != null && result.notes!.isNotEmpty)
              _DetailRow('Notes', result.notes!),
            if (result.performedByName != null)
              _DetailRow('Performed By', result.performedByName!),

            const SizedBox(height: 24),

            // Close Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Close'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  IconData _getTestIcon(LabTestType type) {
    switch (type) {
      case LabTestType.hemoglobin:
        return Icons.bloodtype;
      case LabTestType.bloodGroup:
        return Icons.water_drop;
      case LabTestType.urinalysis:
        return Icons.science;
      case LabTestType.vdrlSyphilis:
      case LabTestType.hivTest:
      case LabTestType.hepatitisB:
      case LabTestType.tbScreening:
        return Icons.coronavirus;
      case LabTestType.bloodSugar:
        return Icons.monitor_heart;
    }
  }

  String _formatTestType(LabTestType type) {
    switch (type) {
      case LabTestType.hemoglobin:
        return 'Hemoglobin (Hb)';
      case LabTestType.bloodGroup:
        return 'Blood Group & Rhesus';
      case LabTestType.urinalysis:
        return 'Urinalysis';
      case LabTestType.vdrlSyphilis:
        return 'VDRL/RPR (Syphilis)';
      case LabTestType.hivTest:
        return 'HIV Test';
      case LabTestType.bloodSugar:
        return 'Blood Sugar';
      case LabTestType.hepatitisB:
        return 'Hepatitis B';
      case LabTestType.tbScreening:
        return 'TB Screening';
    }
  }
}

// ============= HELPER WIDGETS =============

class _SummaryItem extends StatelessWidget {
  final String value;
  final String label;
  final Color color;

  const _SummaryItem(this.value, this.label, this.color);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(fontSize: 12, color: Colors.grey[600]),
        ),
      ],
    );
  }
}

class _DetailRow extends StatelessWidget {
  final String label;
  final String value;

  const _DetailRow(this.label, this.value);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: TextStyle(
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }
}
