import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mch_core/mch_core.dart';
import 'package:intl/intl.dart';
import '../../../../core/providers/lab_result_providers.dart';
import 'lab_result_screen.dart';

/// Lab Results History Screen
/// Shows all lab tests for a patient
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
      ),
      body: labResultsAsync.when(
        data: (labResults) {
          if (labResults.isEmpty) {
            return _buildEmptyState(context);
          }

          // Group by test type
          final groupedResults = <LabTestType, List<LabResult>>{};
          for (final result in labResults) {
            groupedResults.putIfAbsent(result.testType, () => []).add(result);
          }

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              // Summary Card
              _buildSummaryCard(labResults),
              
              const SizedBox(height: 16),
              
              // Grouped Results
              ...groupedResults.entries.map((entry) {
                return _buildTestTypeSection(
                  context,
                  entry.key,
                  entry.value,
                );
              }),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 64, color: Colors.red),
              const SizedBox(height: 16),
              Text('Error loading lab results: $error'),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => ref.invalidate(patientLabResultsProvider),
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
              builder: (context) => RecordLabResultScreen(
                patientId: patientId,
                patient: patient,
              ),
            ),
          );
        },
        icon: const Icon(Icons.add),
        label: const Text('New Lab Result'),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.science_outlined,
            size: 100,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
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
            'No laboratory tests recorded yet',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryCard(List<LabResult> results) {
    final abnormalCount = results.where((r) => r.isAbnormal).length;
    final testTypesCount = results.map((r) => r.testType).toSet().length;

    return Card(
      color: Colors.blue.shade50,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Summary',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildSummaryItem(
                  'Total Tests',
                  '${results.length}',
                  Colors.blue,
                ),
                _buildSummaryItem(
                  'Test Types',
                  '$testTypesCount',
                  Colors.green,
                ),
                _buildSummaryItem(
                  'Abnormal',
                  '$abnormalCount',
                  Colors.red,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryItem(String label, String value, Color color) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[700],
          ),
        ),
      ],
    );
  }

  Widget _buildTestTypeSection(
    BuildContext context,
    LabTestType testType,
    List<LabResult> results,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 16, bottom: 8),
          child: Row(
            children: [
              Icon(_getTestIcon(testType), size: 20),
              const SizedBox(width: 8),
              Text(
                _formatTestType(testType),
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(width: 8),
              Chip(
                label: Text('${results.length}'),
                padding: EdgeInsets.zero,
                visualDensity: VisualDensity.compact,
              ),
            ],
          ),
        ),
        ...results.map((result) => _buildLabResultCard(context, result)),
      ],
    );
  }

  Widget _buildLabResultCard(BuildContext context, LabResult result) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: result.isAbnormal
              ? Colors.red.withOpacity(0.2)
              : Colors.green.withOpacity(0.2),
          child: Icon(
            result.isAbnormal ? Icons.warning : Icons.check_circle,
            color: result.isAbnormal ? Colors.red : Colors.green,
          ),
        ),
        title: Text(
          result.testName,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text(
              'Result: ${result.resultValue}${result.resultUnit != null ? " ${result.resultUnit}" : ""}',
              style: TextStyle(
                color: result.isAbnormal ? Colors.red : Colors.black87,
                fontWeight:
                    result.isAbnormal ? FontWeight.bold : FontWeight.normal,
              ),
            ),
            if (result.referenceRange != null)
              Text(
                'Normal: ${result.referenceRange}',
                style: TextStyle(fontSize: 12, color: Colors.grey[600]),
              ),
            Text(
              DateFormat('MMM dd, yyyy').format(result.testDate),
              style: TextStyle(fontSize: 12, color: Colors.grey[600]),
            ),
          ],
        ),
        trailing: result.isAbnormal
            ? const Icon(Icons.flag, color: Colors.red, size: 20)
            : null,
        onTap: () => _showLabResultDetails(context, result),
      ),
    );
  }

  void _showLabResultDetails(BuildContext context, LabResult result) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(result.testName),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDetailRow('Test Date',
                DateFormat('MMM dd, yyyy').format(result.testDate)),
            _buildDetailRow('Result', result.resultValue),
            if (result.resultUnit != null)
              _buildDetailRow('Unit', result.resultUnit!),
            if (result.referenceRange != null)
              _buildDetailRow('Reference Range', result.referenceRange!),
            _buildDetailRow(
                'Status', result.isAbnormal ? 'Abnormal' : 'Normal'),
            if (result.notes != null && result.notes!.isNotEmpty)
              _buildDetailRow('Notes', result.notes!),
            _buildDetailRow('Performed By', result.performedByName ?? 'Unknown'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              '$label:',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(child: Text(value)),
        ],
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