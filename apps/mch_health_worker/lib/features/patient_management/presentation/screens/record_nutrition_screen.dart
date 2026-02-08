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
  ConsumerState<RecordNutritionScreen> createState() =>
      _RecordNutritionScreenState();
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
  final Map<String, bool> _counselingTopicsSelected = {};

  // MCH Handbook 2020 - Section 7: Nutrition Counseling Topics
  static const List<String> mchCounselingTopics = [
    'Eat variety of foods daily',
    'Iron-rich foods (vegetables, meat, beans)',
    'Calcium-rich foods (milk, omena)',
    'Eat 4-5 small meals per day',
    'Drink 8-10 glasses of water daily',
    'Take IFAS tablets daily with food',
    'Importance of deworming',
    'Avoid excessive salt, sugar, spicy foods',
    'Recognize malnutrition signs (MUAC <23cm)',
  ];

  final _notesController = TextEditingController();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    // Initialize counseling topics selection
    for (final topic in mchCounselingTopics) {
      _counselingTopicsSelected[topic] = false;
    }
  }

  @override
  void dispose() {
    _muacController.dispose();
    _ironFolateTabletsController.dispose();
    _calciumTabletsController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _saveNutritionRecord() async {
    if (!_formKey.currentState!.validate()) {
      // Show user-friendly alert
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('⚠️ Please fix the errors in the form before saving'),
          backgroundColor: Colors.orange,
          duration: Duration(seconds: 3),
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final profile = ref.read(currentUserProfileProvider).value;

      // Create nutrition record
      final nutritionRecord = NutritionRecord(
        maternalProfileId: widget.patientId,
        patientName: widget.patient.clientName,
        recordDate: _recordDate,
        muacCm: _muacController.text.isEmpty
            ? null
            : double.tryParse(_muacController.text),
        isMalnourished: _muacController.text.isEmpty
            ? false
            : (double.tryParse(_muacController.text) ?? 25) < 23,
        ironFolateGiven: _ironFolateGiven,
        ironFolateTablets: _ironFolateGiven
            ? int.tryParse(_ironFolateTabletsController.text)
            : null,
        calciumGiven: _calciumGiven,
        calciumTablets:
            _calciumGiven ? int.tryParse(_calciumTabletsController.text) : null,
        dewormingGiven: _dewormingGiven,
        dewormingDrug: _dewormingGiven ? _dewormingDrug : null,
        nutritionCounselingGiven: _counselingGiven,
        counselingTopics: _counselingGiven
            ? _counselingTopicsSelected.entries
                .where((e) => e.value)
                .map((e) => e.key)
                .join('; ')
            : null,
        notes: _notesController.text.trim().isEmpty
            ? null
            : _notesController.text.trim(),
        facilityId: profile!.facilityId!,
        facilityName: widget.patient.facilityName,
        recordedBy: profile.id,
        recordedByName: profile.fullName,
      );

      final createRecord = ref.read(createNutritionRecordProvider);
      await createRecord(nutritionRecord);

      // If MUAC was recorded, also create MUAC measurement
      if (_muacController.text.trim().isNotEmpty) {
        try {
          final muacValue = double.parse(_muacController.text.trim());
          
          // Only create MUAC measurement if value is valid (within reasonable range)
          if (muacValue > 0 && muacValue <= 100) {
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
        } catch (e) {
          // If MUAC parsing fails, continue without creating MUAC measurement
          print('⚠️ Failed to parse MUAC value: $e');
        }
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
    // Calculate gestation weeks
    final gestationWeeks = widget.patient.lmp != null
        ? DateTime.now().difference(widget.patient.lmp!).inDays ~/ 7
        : null;

    return Scaffold(
      appBar: AppBar(title: const Text('Record Nutrition')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Gestation-specific recommendation banner
            if (gestationWeeks != null) _buildGestationBanner(context, gestationWeeks),
            if (gestationWeeks != null) const SizedBox(height: 16),

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
            Text('MUAC Measurement',
                style: Theme.of(context).textTheme.titleLarge),
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
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return null; // Optional field
                }
                
                final muac = double.tryParse(value);
                if (muac == null) {
                  return 'Please enter a valid number';
                }
                
                if (muac < 15 || muac > 40) {
                  return 'MUAC must be between 15-40 cm';
                }
                
                return null;
              },
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
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                  side: BorderSide(color: Colors.grey.shade300)),
            ),
            if (_ironFolateGiven) ...[
              const SizedBox(height: 8),
              TextFormField(
                controller: _ironFolateTabletsController,
                decoration: const InputDecoration(
                  labelText: 'Number of Tablets',
                  border: OutlineInputBorder(),
                  hintText: '30',
                  suffixText: 'tablets',
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (!_ironFolateGiven) return null;
                  
                  if (value == null || value.isEmpty) {
                    return 'Enter number of tablets given';
                  }
                  
                  final tablets = int.tryParse(value);
                  if (tablets == null || tablets < 1) {
                    return 'Must be at least 1 tablet';
                  }
                  if (tablets > 180) {
                    return 'Cannot exceed 180 tablets (6 months)';
                  }
                  return null;
                },
              ),
            ],

            const SizedBox(height: 12),

            // Calcium
            CheckboxListTile(
              title: const Text('Calcium Given'),
              value: _calciumGiven,
              onChanged: (val) => setState(() => _calciumGiven = val!),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                  side: BorderSide(color: Colors.grey.shade300)),
            ),
            if (_calciumGiven) ...[
              const SizedBox(height: 8),
              TextFormField(
                controller: _calciumTabletsController,
                decoration: const InputDecoration(
                  labelText: 'Number of Tablets',
                  border: OutlineInputBorder(),
                  hintText: '30',
                  suffixText: 'tablets',
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (!_calciumGiven) return null;
                  
                  if (value == null || value.isEmpty) {
                    return 'Enter number of tablets given';
                  }
                  
                  final tablets = int.tryParse(value);
                  if (tablets == null || tablets < 1) {
                    return 'Must be at least 1 tablet';
                  }
                  if (tablets > 180) {
                    return 'Cannot exceed 180 tablets';
                  }
                  return null;
                },
              ),
            ],

            const SizedBox(height: 12),

            // Deworming
            CheckboxListTile(
              title: const Text('Deworming Given'),
              value: _dewormingGiven,
              onChanged: (val) => setState(() => _dewormingGiven = val!),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                  side: BorderSide(color: Colors.grey.shade300)),
            ),
            if (_dewormingGiven) ...[
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                initialValue: _dewormingDrug,
                decoration: const InputDecoration(
                  labelText: 'Drug',
                  border: OutlineInputBorder(),
                ),
                items: ['Albendazole', 'Mebendazole']
                    .map((drug) =>
                        DropdownMenuItem(value: drug, child: Text(drug)))
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
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                  side: BorderSide(color: Colors.grey.shade300)),
            ),
            
            if (_counselingGiven) ...[
              const SizedBox(height: 12),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  'Topics Covered (MCH Handbook Section 7):',
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
                ),
              ),
              const SizedBox(height: 8),
              ...mchCounselingTopics.map((topic) => CheckboxListTile(
                dense: true,
                title: Text(topic, style: const TextStyle(fontSize: 14)),
                value: _counselingTopicsSelected[topic],
                onChanged: (val) => setState(() => _counselingTopicsSelected[topic] = val!),
              )),
              const SizedBox(height: 12),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: TextFormField(
                  controller: _notesController,
                  decoration: const InputDecoration(
                    labelText: 'Additional Counseling Notes',
                    border: OutlineInputBorder(),
                    hintText: 'Custom topics or specific advice given...',
                  ),
                  maxLines: 3,
                ),
              ),
            ],

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
              style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50)),
              child: _isLoading
                  ? const CircularProgressIndicator()
                  : const Text('Save Nutrition Record'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGestationBanner(BuildContext context, int weeks) {
    final recommendation = _getNutritionRecommendation(weeks);
    
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.blue.shade200),
      ),
      child: Row(
        children: [
          Icon(Icons.lightbulb_outline, color: Colors.blue.shade700, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  recommendation.$1,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.blue.shade900,
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  recommendation.$2,
                  style: TextStyle(fontSize: 12, color: Colors.grey[700]),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  (String, String) _getNutritionRecommendation(int weeks) {
    if (weeks < 13) {
      return (
        '1st Trimester (Week $weeks)',
        'Folic acid critical. Manage nausea with small frequent meals. Emphasize IFAS tablets.',
      );
    } else if (weeks < 28) {
      return (
        '2nd Trimester (Week $weeks)',
        'Iron needs increase. Give deworming medication. Monitor MUAC for malnutrition.',
      );
    } else {
      return (
        '3rd Trimester (Week $weeks)',
        'Increase calories (+300 kcal/day). Monitor weight gain closely. Continue supplements.',
      );
    }
  }
}
