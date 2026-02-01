import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mch_core/mch_core.dart';
import 'package:intl/intl.dart';
import '../../../../core/providers/lab_result_providers.dart';
import '../../../../core/providers/auth_providers.dart';

/// Record Lab Result Screen
/// Based on MCH Handbook 2020 - Section 4: Laboratory Investigations
class RecordLabResultScreen extends ConsumerStatefulWidget {
  final String patientId;
  final MaternalProfile patient;
  final String? visitId;

  const RecordLabResultScreen({
    super.key,
    required this.patientId,
    required this.patient,
    this.visitId,
  });

  @override
  ConsumerState<RecordLabResultScreen> createState() =>
      _RecordLabResultScreenState();
}

class _RecordLabResultScreenState extends ConsumerState<RecordLabResultScreen> {
  final _formKey = GlobalKey<FormState>();

  LabTestType _selectedTestType = LabTestType.hemoglobin;
  DateTime _testDate = DateTime.now();
  final _resultValueController = TextEditingController();
  final _resultUnitController = TextEditingController();
  final _referenceRangeController = TextEditingController();
  final _notesController = TextEditingController();
  bool _isAbnormal = false;

  bool _isLoading = false;

  // Test templates based on MCH Handbook
  final Map<LabTestType, Map<String, String>> _testTemplates = {
    LabTestType.hemoglobin: {
      'name': 'Hemoglobin (Hb)',
      'unit': 'g/dL',
      'reference': '11.0-16.0',
    },
    LabTestType.bloodGroup: {
      'name': 'Blood Group & Rhesus',
      'unit': '',
      'reference': 'A+, A-, B+, B-, AB+, AB-, O+, O-',
    },
    LabTestType.urinalysis: {
      'name': 'Urinalysis',
      'unit': '',
      'reference': 'Negative, Trace, +, ++, +++',
    },
    LabTestType.vdrlSyphilis: {
      'name': 'VDRL/RPR (Syphilis)',
      'unit': '',
      'reference': 'Reactive / Non-Reactive',
    },
    LabTestType.hivTest: {
      'name': 'HIV Test',
      'unit': '',
      'reference': 'Positive / Negative',
    },
    LabTestType.bloodSugar: {
      'name': 'Blood Sugar',
      'unit': 'mg/dL',
      'reference': 'FBS: 70-100, RBS: 70-140',
    },
    LabTestType.hepatitisB: {
      'name': 'Hepatitis B (HBsAg)',
      'unit': '',
      'reference': 'Positive / Negative',
    },
    LabTestType.tbScreening: {
      'name': 'TB Screening',
      'unit': '',
      'reference': 'Positive / Negative',
    },
  };

  @override
  void initState() {
    super.initState();
    _updateTemplateFields();
  }

  @override
  void dispose() {
    _resultValueController.dispose();
    _resultUnitController.dispose();
    _referenceRangeController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  void _updateTemplateFields() {
    final template = _testTemplates[_selectedTestType]!;
    _resultUnitController.text = template['unit']!;
    _referenceRangeController.text = template['reference']!;
  }

  Future<void> _selectDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _testDate,
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime.now(),
    );

    if (picked != null) {
      setState(() {
        _testDate = picked;
      });
    }
  }

  Future<void> _saveLabResult() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final profile = ref.read(currentUserProfileProvider).value;
      final template = _testTemplates[_selectedTestType]!;

      final labResult = LabResult(
        maternalProfileId: widget.patientId,
        patientName: widget.patient.clientName,
        ancVisitId: widget.visitId,
        testType: _selectedTestType,
        testName: template['name']!,
        testDate: _testDate,
        resultValue: _resultValueController.text.trim(),
        resultUnit: _resultUnitController.text.trim().isEmpty
            ? null
            : _resultUnitController.text.trim(),
        referenceRange: _referenceRangeController.text.trim().isEmpty
            ? null
            : _referenceRangeController.text.trim(),
        isAbnormal: _isAbnormal,
        notes: _notesController.text.trim().isEmpty
            ? null
            : _notesController.text.trim(),
        facilityId: profile!.facilityId!,
        facilityName: widget.patient.facilityName,
        performedBy: profile.id,
        performedByName: profile.fullName,
      );

      final createLabResult = ref.read(createLabResultProvider);
      await createLabResult(labResult);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('✓ Lab result recorded successfully'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(context, true);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to record lab result: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Record Lab Result'),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
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
                      widget.patient.clientName,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text('ANC Number: ${widget.patient.ancNumber}'),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Test Type
            Text(
              'Test Information',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),

            DropdownButtonFormField<LabTestType>(
              initialValue: _selectedTestType,
              decoration: const InputDecoration(
                labelText: 'Test Type *',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.science),
              ),
              items: LabTestType.values
                  .map((type) => DropdownMenuItem(
                        value: type,
                        child: Text(_testTemplates[type]!['name']!),
                      ))
                  .toList(),
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    _selectedTestType = value;
                    _updateTemplateFields();
                  });
                }
              },
            ),

            const SizedBox(height: 16),

            // Test Date
            ListTile(
              leading: const Icon(Icons.calendar_today),
              title: const Text('Test Date'),
              subtitle:
                  Text(DateFormat('EEEE, MMM dd, yyyy').format(_testDate)),
              trailing: const Icon(Icons.edit),
              onTap: _selectDate,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
                side: BorderSide(color: Colors.grey.shade300),
              ),
            ),

            const SizedBox(height: 24),

            // Test Results
            Text(
              'Test Results',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),

            // Result Value
            TextFormField(
              controller: _resultValueController,
              decoration: const InputDecoration(
                labelText: 'Result Value *',
                border: OutlineInputBorder(),
                hintText: 'Enter test result',
                prefixIcon: Icon(Icons.assessment),
              ),
              validator: (value) =>
                  value?.isEmpty ?? true ? 'Result is required' : null,
            ),

            const SizedBox(height: 16),

            // Unit (optional)
            TextFormField(
              controller: _resultUnitController,
              decoration: const InputDecoration(
                labelText: 'Unit',
                border: OutlineInputBorder(),
                hintText: 'e.g., g/dL, mg/dL',
                prefixIcon: Icon(Icons.straighten),
              ),
            ),

            const SizedBox(height: 16),

            // Reference Range
            TextFormField(
              controller: _referenceRangeController,
              decoration: const InputDecoration(
                labelText: 'Reference Range',
                border: OutlineInputBorder(),
                hintText: 'Normal range',
                prefixIcon: Icon(Icons.bar_chart),
              ),
            ),

            const SizedBox(height: 16),

            // Is Abnormal Flag
            CheckboxListTile(
              title: const Text('Abnormal Result'),
              subtitle: const Text('Check if result is outside normal range'),
              value: _isAbnormal,
              onChanged: (value) {
                setState(() {
                  _isAbnormal = value ?? false;
                });
              },
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
                side: BorderSide(color: Colors.grey.shade300),
              ),
            ),

            const SizedBox(height: 16),

            // Notes
            TextFormField(
              controller: _notesController,
              decoration: const InputDecoration(
                labelText: 'Notes (Optional)',
                border: OutlineInputBorder(),
                hintText: 'Additional observations or comments',
                prefixIcon: Icon(Icons.notes),
              ),
              maxLines: 3,
            ),

            const SizedBox(height: 32),

            // Save Button
            ElevatedButton(
              onPressed: _isLoading ? null : _saveLabResult,
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
              ),
              child: _isLoading
                  ? const SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Text(
                      'Save Lab Result',
                      style: TextStyle(fontSize: 16),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
