import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mch_core/mch_core.dart';
import 'package:intl/intl.dart';
import '../../../../core/providers/nutrition_providers.dart';
import '../../../../core/providers/auth_providers.dart';

/// Record Nutrition Screen
/// Record supplements, MUAC, counseling
class RecordNutritionScreen extends ConsumerStatefulWidget {
  final String patientId;
  final MaternalProfile patient;

  const RecordNutritionScreen({
    super.key,
    required this.patientId,
    required this.patient,
  });

  @override
  ConsumerState<RecordNutritionScreen> createState() => _RecordNutritionScreenState();
}

class _RecordNutritionScreenState extends ConsumerState<RecordNutritionScreen> {
  final _formKey = GlobalKey<FormState>();
  DateTime _recordDate = DateTime.now();
  
  // MUAC
  final _muacController = TextEditingController();
  
  // Iron/Folate
  bool _ironFolateGiven = false;
  final _ironFolateTabletsController = TextEditingController(text: '30');
  
  // Calcium
  bool _calciumGiven = false;
  final _calciumTabletsController = TextEditingController(text: '30');
  
  // Deworming
  bool _dewormingGiven = false;
  String _dewormingDrug = 'Albendazole';
  
  // Counseling
  bool _counselingGiven = false;
  final List<String> _counselingTopics = [];
  
  final _notesController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _muacController.dispose();
    _ironFolateTabletsController.dispose();
    _calciumTabletsController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _saveNutritionRecord() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final profile = ref.read(currentUserProfileProvider).value;
      
      // Create nutrition record
      final nutritionRecord = NutritionRecord(
        maternalProfileId: widget.patientId,
        patientName: widget.patient.clientName,
        recordDate: _recordDate,
        muacCm: _muacController.text.isEmpty ? null : double.tryParse(_muacController.text),
        isMalnourished: _muacController.text.isEmpty 
            ? false 
            : (double.tryParse(_muacController.text) ?? 25) < 23,
        ironFolateGiven: _ironFolateGiven,
        ironFolateTablets: _ironFolateGiven ? int.tryParse(_ironFolateTabletsController.text) : null,
        calciumGiven: _calciumGiven,
        calciumTablets: _calciumGiven ? int.tryParse(_calciumTabletsController.text) : null,
        dewormingGiven: _dewormingGiven,
        dewormingDrug: _dewormingGiven ? _dewormingDrug : null,
        nutritionCounselingGiven: _counselingGiven,
        counselingTopics: _counselingGiven ? _counselingTopics.join(', ') : null,
        notes: _notesController.text.trim().isEmpty ? null : _notesController.text.trim(),
        facilityId: profile!.facilityId!,
        facilityName: widget.patient.facilityName,
        recordedBy: profile.id,
        recordedByName: profile.fullName,
      );

      final createRecord = ref.read(createNutritionRecordProvider);
      await createRecord(nutritionRecord);

      // If MUAC was recorded, also create MUAC measurement
      if (_muacController.text.isNotEmpty) {
        final muacValue = double.parse(_muacController.text);
        final muacMeasurement = MuacMeasurement(
          maternalProfileId: widget.patientId,
          patientName: widget.patient.clientName,
          measurementDate: _recordDate,
          muacCm: muacValue,
          isMalnourished: muacValue < 23,
          facilityId: profile.facilityId!,
          recordedBy: profile.id,
          recordedByName: profile.fullName,
        );

        final createMuac = ref.read(createMuacMeasurementProvider);
        await createMuac(muacMeasurement);
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('✓ Nutrition record saved successfully'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed: $e'), backgroundColor: Colors.red),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Record Nutrition')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Date
            ListTile(
              title: const Text('Record Date'),
              subtitle: Text(DateFormat('MMM dd, yyyy').format(_recordDate)),
              trailing: const Icon(Icons.edit),
              onTap: () async {
                final picked = await showDatePicker(
                  context: context,
                  initialDate: _recordDate,
                  firstDate: DateTime.now().subtract(const Duration(days: 365)),
                  lastDate: DateTime.now(),
                );
                if (picked != null) setState(() => _recordDate = picked);
              },
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
                side: BorderSide(color: Colors.grey.shade300),
              ),
            ),

            const SizedBox(height: 24),

            // MUAC Section
            Text('MUAC Measurement', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 8),
            TextFormField(
              controller: _muacController,
              decoration: const InputDecoration(
                labelText: 'MUAC (cm)',
                border: OutlineInputBorder(),
                hintText: 'e.g., 24.5',
                helperText: 'Normal: ≥23 cm, Malnourished: <23 cm',
                prefixIcon: Icon(Icons.straighten),
              ),
              keyboardType: TextInputType.number,
            ),

            const SizedBox(height: 24),

            // Supplements Section
            Text('Supplements', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 12),

            // Iron/Folate
            CheckboxListTile(
              title: const Text('Iron/Folate Given'),
              value: _ironFolateGiven,
              onChanged: (val) => setState(() => _ironFolateGiven = val!),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8), side: BorderSide(color: Colors.grey.shade300)),
            ),
            if (_ironFolateGiven) ...[
              const SizedBox(height: 8),
              TextFormField(
                controller: _ironFolateTabletsController,
                decoration: const InputDecoration(
                  labelText: 'Number of Tablets',
                  border: OutlineInputBorder(),
                  hintText: '30',
                ),
                keyboardType: TextInputType.number,
              ),
            ],

            const SizedBox(height: 12),

            // Calcium
            CheckboxListTile(
              title: const Text('Calcium Given'),
              value: _calciumGiven,
              onChanged: (val) => setState(() => _calciumGiven = val!),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8), side: BorderSide(color: Colors.grey.shade300)),
            ),
            if (_calciumGiven) ...[
              const SizedBox(height: 8),
              TextFormField(
                controller: _calciumTabletsController,
                decoration: const InputDecoration(
                  labelText: 'Number of Tablets',
                  border: OutlineInputBorder(),
                  hintText: '30',
                ),
                keyboardType: TextInputType.number,
              ),
            ],

            const SizedBox(height: 12),

            // Deworming
            CheckboxListTile(
              title: const Text('Deworming Given'),
              value: _dewormingGiven,
              onChanged: (val) => setState(() => _dewormingGiven = val!),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8), side: BorderSide(color: Colors.grey.shade300)),
            ),
            if (_dewormingGiven) ...[
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                value: _dewormingDrug,
                decoration: const InputDecoration(
                  labelText: 'Drug',
                  border: OutlineInputBorder(),
                ),
                items: ['Albendazole', 'Mebendazole']
                    .map((drug) => DropdownMenuItem(value: drug, child: Text(drug)))
                    .toList(),
                onChanged: (val) => setState(() => _dewormingDrug = val!),
              ),
            ],

            const SizedBox(height: 24),

            // Counseling
            CheckboxListTile(
              title: const Text('Nutrition Counseling Given'),
              value: _counselingGiven,
              onChanged: (val) => setState(() => _counselingGiven = val!),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8), side: BorderSide(color: Colors.grey.shade300)),
            ),

            const SizedBox(height: 16),

            // Notes
            TextFormField(
              controller: _notesController,
              decoration: const InputDecoration(
                labelText: 'Notes',
                border: OutlineInputBorder(),
                hintText: 'Additional observations',
              ),
              maxLines: 3,
            ),

            const SizedBox(height: 32),

            // Save Button
            ElevatedButton(
              onPressed: _isLoading ? null : _saveNutritionRecord,
              style: ElevatedButton.styleFrom(minimumSize: const Size(double.infinity, 50)),
              child: _isLoading
                  ? const CircularProgressIndicator()
                  : const Text('Save Nutrition Record'),
            ),
          ],
        ),
      ),
    );
  }
}