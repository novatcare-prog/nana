import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mch_core/mch_core.dart';
import '../../../../core/providers/growth_monitoring_providers.dart';

/// Add Growth Record Screen
/// Records weight, length/height, MUAC, head circumference
class AddGrowthRecordScreen extends ConsumerStatefulWidget {
  final String childId;
  final ChildProfile child;

  const AddGrowthRecordScreen({
    super.key,
    required this.childId,
    required this.child,
  });

  @override
  ConsumerState<AddGrowthRecordScreen> createState() => _AddGrowthRecordScreenState();
}

class _AddGrowthRecordScreenState extends ConsumerState<AddGrowthRecordScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _isSubmitting = false;

  // Visit Information
  DateTime _visitDate = DateTime.now();
  int? _ageInMonths;

  // Measurements
  final _weightController = TextEditingController();
  final _lengthHeightController = TextEditingController();
  final _muacController = TextEditingController();
  final _headCircumferenceController = TextEditingController();

  // Measurement Type
  bool _measuredLying = true; // true = length (lying), false = height (standing)

  // Edema
  bool _edemaPresent = false;
  String? _edemaGrade;

  // Assessment
  String? _nutritionalStatus;
  bool _referredForNutrition = false;

  // Counseling
  bool _feedingCounselingGiven = false;
  final _feedingRecommendationsController = TextEditingController();

  // Clinical Notes
  final _concernsController = TextEditingController();
  final _interventionsController = TextEditingController();
  DateTime? _nextVisitDate;

  // Health Worker
  final _recordedByController = TextEditingController();
  final _healthFacilityController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _calculateAgeInMonths();
  }

  @override
  void dispose() {
    _weightController.dispose();
    _lengthHeightController.dispose();
    _muacController.dispose();
    _headCircumferenceController.dispose();
    _feedingRecommendationsController.dispose();
    _concernsController.dispose();
    _interventionsController.dispose();
    _recordedByController.dispose();
    _healthFacilityController.dispose();
    super.dispose();
  }

  void _calculateAgeInMonths() {
    final birthDate = widget.child.dateOfBirth;
    final now = DateTime.now();
    final months = (now.year - birthDate.year) * 12 + now.month - birthDate.month;
    setState(() => _ageInMonths = months);
  }

  Future<void> _handleSubmit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSubmitting = true);

    try {
      final record = GrowthRecord(
        id: null,
        childId: widget.childId,
        measurementDate: _visitDate,
        ageInMonths: _ageInMonths!,
        weightKg: double.parse(_weightController.text),
        lengthCm: _measuredLying && _lengthHeightController.text.isNotEmpty
            ? double.parse(_lengthHeightController.text)
            : null,
        heightCm: !_measuredLying && _lengthHeightController.text.isNotEmpty
            ? double.parse(_lengthHeightController.text)
            : null,
        measuredLying: _lengthHeightController.text.isNotEmpty ? _measuredLying : null,
        muacCm: _muacController.text.isEmpty ? null : double.parse(_muacController.text),
        headCircumferenceCm: _headCircumferenceController.text.isEmpty
            ? null
            : double.parse(_headCircumferenceController.text),
        edemaPresent: _edemaPresent,
        edemaGrade: _edemaGrade,
        nutritionalStatus: _nutritionalStatus,
        referredForNutrition: _referredForNutrition,
        feedingCounselingGiven: _feedingCounselingGiven,
        feedingRecommendations: _feedingRecommendationsController.text.isEmpty
            ? null
            : _feedingRecommendationsController.text,
        concerns: _concernsController.text.isEmpty ? null : _concernsController.text,
        interventions: _interventionsController.text.isEmpty ? null : _interventionsController.text,
        nextVisitDate: _nextVisitDate,
        recordedBy: _recordedByController.text.isEmpty ? null : _recordedByController.text,
        healthFacility: _healthFacilityController.text.isEmpty
            ? null
            : _healthFacilityController.text,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      final createRecord = ref.read(createGrowthRecordProvider);
      await createRecord(record);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('✅ Growth record saved successfully!'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('❌ Error: $e'),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 5),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isSubmitting = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Growth Record - ${widget.child.childName}'),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Child Info Card
            Card(
              color: Colors.blue.shade50,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.child.childName,
                      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Text('Age: $_ageInMonths months'),
                    Text('Sex: ${widget.child.sex}'),
                    Text('Date of Birth: ${_formatDate(widget.child.dateOfBirth)}'),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Visit Date
            ListTile(
              title: const Text('Visit Date *'),
              subtitle: Text(_formatDate(_visitDate)),
              trailing: const Icon(Icons.calendar_today),
              onTap: () async {
                final date = await showDatePicker(
                  context: context,
                  initialDate: _visitDate,
                  firstDate: DateTime(2020),
                  lastDate: DateTime.now(),
                );
                if (date != null) {
                  setState(() => _visitDate = date);
                }
              },
            ),
            const Divider(),
            const SizedBox(height: 16),

            // MEASUREMENTS SECTION
            const Text(
              'Measurements',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),

            // Weight
            TextFormField(
              controller: _weightController,
              decoration: const InputDecoration(
                labelText: 'Weight (kg) *',
                border: OutlineInputBorder(),
                suffixText: 'kg',
              ),
              keyboardType: TextInputType.number,
              validator: (value) => value?.isEmpty ?? true ? 'Required' : null,
            ),
            const SizedBox(height: 16),

            // Length/Height with toggle
            Row(
              children: [
                Expanded(
                  flex: 2,
                  child: TextFormField(
                    controller: _lengthHeightController,
                    decoration: InputDecoration(
                      labelText: _measuredLying ? 'Length (cm)' : 'Height (cm)',
                      border: const OutlineInputBorder(),
                      suffixText: 'cm',
                    ),
                    keyboardType: TextInputType.number,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  flex: 1,
                  child: DropdownButtonFormField<bool>(
                    value: _measuredLying,
                    decoration: const InputDecoration(
                      labelText: 'Type',
                      border: OutlineInputBorder(),
                    ),
                    items: const [
                      DropdownMenuItem(value: true, child: Text('Lying')),
                      DropdownMenuItem(value: false, child: Text('Standing')),
                    ],
                    onChanged: (value) => setState(() => _measuredLying = value!),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              _measuredLying
                  ? '📏 Length (lying down) - for children < 2 years'
                  : '📏 Height (standing) - for children ≥ 2 years',
              style: TextStyle(fontSize: 12, color: Colors.grey[600]),
            ),
            const SizedBox(height: 16),

            // MUAC (if child is 6-59 months)
            if (_ageInMonths != null && _ageInMonths! >= 6 && _ageInMonths! < 60) ...[
              TextFormField(
                controller: _muacController,
                decoration: const InputDecoration(
                  labelText: 'MUAC - Mid-Upper Arm Circumference (cm)',
                  border: OutlineInputBorder(),
                  suffixText: 'cm',
                  helperText: 'For malnutrition screening (6-59 months)',
                ),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 16),
            ],

            // Head Circumference (typically measured in first 2 years)
            if (_ageInMonths != null && _ageInMonths! < 24) ...[
              TextFormField(
                controller: _headCircumferenceController,
                decoration: const InputDecoration(
                  labelText: 'Head Circumference (cm)',
                  border: OutlineInputBorder(),
                  suffixText: 'cm',
                ),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 16),
            ],

            const Divider(),
            const SizedBox(height: 16),

            // EDEMA CHECK
            const Text(
              'Malnutrition Screening',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),

            CheckboxListTile(
              title: const Text('Edema Present'),
              subtitle: const Text('Swelling (indicates possible kwashiorkor)'),
              value: _edemaPresent,
              onChanged: (value) => setState(() => _edemaPresent = value ?? false),
            ),

            if (_edemaPresent) ...[
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                value: _edemaGrade,
                decoration: const InputDecoration(
                  labelText: 'Edema Grade',
                  border: OutlineInputBorder(),
                ),
                items: const [
                  DropdownMenuItem(value: '+', child: Text('+ (Mild)')),
                  DropdownMenuItem(value: '++', child: Text('++ (Moderate)')),
                  DropdownMenuItem(value: '+++', child: Text('+++ (Severe)')),
                ],
                onChanged: (value) => setState(() => _edemaGrade = value),
              ),
              const SizedBox(height: 16),
            ],

            // Nutritional Status
            DropdownButtonFormField<String>(
              value: _nutritionalStatus,
              decoration: const InputDecoration(
                labelText: 'Nutritional Status',
                border: OutlineInputBorder(),
              ),
              items: const [
                DropdownMenuItem(value: 'Normal', child: Text('Normal')),
                DropdownMenuItem(value: 'Underweight', child: Text('Underweight')),
                DropdownMenuItem(value: 'Severely Underweight', child: Text('Severely Underweight')),
                DropdownMenuItem(value: 'Overweight', child: Text('Overweight')),
                DropdownMenuItem(value: 'Obese', child: Text('Obese')),
              ],
              onChanged: (value) => setState(() => _nutritionalStatus = value),
            ),
            const SizedBox(height: 16),

            CheckboxListTile(
              title: const Text('Referred for Nutrition Support'),
              value: _referredForNutrition,
              onChanged: (value) => setState(() => _referredForNutrition = value ?? false),
            ),

            const Divider(),
            const SizedBox(height: 16),

            // COUNSELING
            const Text(
              'Counseling & Recommendations',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),

            CheckboxListTile(
              title: const Text('Feeding Counseling Given'),
              value: _feedingCounselingGiven,
              onChanged: (value) => setState(() => _feedingCounselingGiven = value ?? false),
            ),

            if (_feedingCounselingGiven) ...[
              const SizedBox(height: 8),
              TextFormField(
                controller: _feedingRecommendationsController,
                decoration: const InputDecoration(
                  labelText: 'Feeding Recommendations',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
              ),
              const SizedBox(height: 16),
            ],

            // Clinical Notes
            TextFormField(
              controller: _concernsController,
              decoration: const InputDecoration(
                labelText: 'Concerns',
                border: OutlineInputBorder(),
              ),
              maxLines: 2,
            ),
            const SizedBox(height: 16),

            TextFormField(
              controller: _interventionsController,
              decoration: const InputDecoration(
                labelText: 'Interventions',
                border: OutlineInputBorder(),
              ),
              maxLines: 2,
            ),
            const SizedBox(height: 16),

            // Next Visit Date
            ListTile(
              title: const Text('Next Visit Date'),
              subtitle: Text(_nextVisitDate != null ? _formatDate(_nextVisitDate!) : 'Not set'),
              trailing: const Icon(Icons.calendar_today),
              onTap: () async {
                final date = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now().add(const Duration(days: 30)),
                  firstDate: DateTime.now(),
                  lastDate: DateTime.now().add(const Duration(days: 365)),
                );
                if (date != null) {
                  setState(() => _nextVisitDate = date);
                }
              },
            ),

            const Divider(),
            const SizedBox(height: 16),

            // Health Worker Info
            TextFormField(
              controller: _recordedByController,
              decoration: const InputDecoration(
                labelText: 'Recorded By',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),

            TextFormField(
              controller: _healthFacilityController,
              decoration: const InputDecoration(
                labelText: 'Health Facility',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 24),

            // Submit Button
            ElevatedButton(
              onPressed: _isSubmitting ? null : _handleSubmit,
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
              ),
              child: _isSubmitting
                  ? const CircularProgressIndicator()
                  : const Text('Save Growth Record', style: TextStyle(fontSize: 16)),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}