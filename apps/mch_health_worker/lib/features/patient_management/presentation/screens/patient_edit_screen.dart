import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mch_core/mch_core.dart';
import '../../../../core/providers/supabase_providers.dart';

/// Patient Edit Screen
/// Allows editing of maternal profile information
class PatientEditScreen extends ConsumerStatefulWidget {
  final MaternalProfile profile;

  const PatientEditScreen({
    super.key,
    required this.profile,
  });

  @override
  ConsumerState<PatientEditScreen> createState() => _PatientEditScreenState();
}

class _PatientEditScreenState extends ConsumerState<PatientEditScreen> {
  final _formKey = GlobalKey<FormState>();

  // Controllers - pre-filled with existing data
  late TextEditingController _clientNameController;
  late TextEditingController _ageController;
  late TextEditingController _telephoneController;
  late TextEditingController _countyController;
  late TextEditingController _subCountyController;
  late TextEditingController _wardController;
  late TextEditingController _villageController;
  late TextEditingController _gravidaController;
  late TextEditingController _parityController;
  late TextEditingController _heightController;
  late TextEditingController _weightController;
  late TextEditingController _nextOfKinNameController;
  late TextEditingController _nextOfKinPhoneController;
  late TextEditingController _nextOfKinRelationshipController;

  // Medical conditions
  late bool _diabetes;
  late bool _hypertension;
  late bool _tuberculosis;
  late bool _bloodTransfusion;
  late bool _drugAllergy;
  late bool _previousCs;

  // Dates
  late DateTime? _lmp;
  late DateTime? _edd;

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();

    // Initialize controllers with existing data
    _clientNameController =
        TextEditingController(text: widget.profile.clientName);
    _ageController = TextEditingController(text: widget.profile.age.toString());
    _telephoneController =
        TextEditingController(text: widget.profile.telephone ?? '');
    _countyController = TextEditingController(text: widget.profile.county);
    _subCountyController =
        TextEditingController(text: widget.profile.subCounty ?? '');
    _wardController = TextEditingController(text: widget.profile.ward ?? '');
    _villageController =
        TextEditingController(text: widget.profile.village ?? '');
    _gravidaController =
        TextEditingController(text: widget.profile.gravida.toString());
    _parityController =
        TextEditingController(text: widget.profile.parity.toString());
    _heightController =
        TextEditingController(text: widget.profile.heightCm.toString() ?? '');
    _weightController =
        TextEditingController(text: widget.profile.weightKg.toString() ?? '');
    _nextOfKinNameController =
        TextEditingController(text: widget.profile.nextOfKinName ?? '');
    _nextOfKinPhoneController =
        TextEditingController(text: widget.profile.nextOfKinPhone ?? '');
    _nextOfKinRelationshipController =
        TextEditingController(text: widget.profile.nextOfKinRelationship ?? '');

    // Initialize boolean values
    _diabetes = widget.profile.diabetes ?? false;
    _hypertension = widget.profile.hypertension ?? false;
    _tuberculosis = widget.profile.tuberculosis ?? false;
    _bloodTransfusion = widget.profile.bloodTransfusion ?? false;
    _drugAllergy = widget.profile.drugAllergy ?? false;
    _previousCs = widget.profile.previousCs ?? false;

    // Initialize dates
    _lmp = widget.profile.lmp;
    _edd = widget.profile.edd;
  }

  @override
  void dispose() {
    _clientNameController.dispose();
    _ageController.dispose();
    _telephoneController.dispose();
    _countyController.dispose();
    _subCountyController.dispose();
    _wardController.dispose();
    _villageController.dispose();
    _gravidaController.dispose();
    _parityController.dispose();
    _heightController.dispose();
    _weightController.dispose();
    _nextOfKinNameController.dispose();
    _nextOfKinPhoneController.dispose();
    _nextOfKinRelationshipController.dispose();
    super.dispose();
  }

  Future<void> _handleSave() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      // Create updated profile - only include fields that exist in database
      final updatedProfile = widget.profile.copyWith(
        clientName: _clientNameController.text.trim(),
        age: int.parse(_ageController.text),
        telephone: _telephoneController.text.trim().isEmpty
            ? null
            : _telephoneController.text.trim(),
        county: _countyController.text.trim(),
        subCounty: _subCountyController.text.trim().isEmpty
            ? null
            : _subCountyController.text.trim(),
        ward: _wardController.text.trim().isEmpty
            ? null
            : _wardController.text.trim(),
        village: _villageController.text.trim().isEmpty
            ? null
            : _villageController.text.trim(),
        gravida: int.parse(_gravidaController.text),
        parity: int.parse(_parityController.text),
        heightCm: _heightController.text.isEmpty
            ? 0.0
            : (double.tryParse(_heightController.text) ?? 0.0),
        weightKg: _weightController.text.isEmpty
            ? 0.0
            : (double.tryParse(_weightController.text) ?? 0.0),
        diabetes: _diabetes,
        hypertension: _hypertension,
        tuberculosis: _tuberculosis,
        bloodTransfusion: _bloodTransfusion,
        drugAllergy: _drugAllergy,
        previousCs: _previousCs,
        nextOfKinName: _nextOfKinNameController.text.trim().isEmpty
            ? null
            : _nextOfKinNameController.text.trim(),
        nextOfKinPhone: _nextOfKinPhoneController.text.trim().isEmpty
            ? null
            : _nextOfKinPhoneController.text.trim(),
        nextOfKinRelationship:
            _nextOfKinRelationshipController.text.trim().isEmpty
                ? null
                : _nextOfKinRelationshipController.text.trim(),
      );

      // Update in database
      final repository = ref.read(supabaseMaternalProfileRepositoryProvider);
      await repository.updateProfile(updatedProfile);

      // Invalidate providers to refresh data
      ref.invalidate(maternalProfilesProvider);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('✓ Patient information updated successfully'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(context, true); // Return true to indicate success
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to update: ${e.toString()}'),
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
        title: const Text('Edit Patient'),
        actions: [
          TextButton.icon(
            onPressed: _isLoading ? null : _handleSave,
            style: TextButton.styleFrom(
              foregroundColor: Colors.white,
            ),
            icon: _isLoading
                ? const SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                  )
                : const Icon(Icons.save),
            label: const Text('Save'),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _isLoading ? null : _handleSave,
        icon: _isLoading
            ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
              )
            : const Icon(Icons.save),
        label: Text(_isLoading ? 'Saving...' : 'Save Changes'),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Personal Information Section
            Text(
              'Personal Information',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),

            TextFormField(
              controller: _clientNameController,
              decoration: const InputDecoration(
                labelText: 'Full Name *',
                border: OutlineInputBorder(),
              ),
              validator: (value) => value?.isEmpty ?? true ? 'Required' : null,
            ),
            const SizedBox(height: 16),

            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _ageController,
                    decoration: const InputDecoration(
                      labelText: 'Age *',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value?.isEmpty ?? true) return 'Required';
                      final age = int.tryParse(value!);
                      if (age == null || age < 10 || age > 60) {
                        return 'Invalid age';
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: TextFormField(
                    controller: _telephoneController,
                    decoration: const InputDecoration(
                      labelText: 'Phone',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.phone,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Location Section
            Text(
              'Location',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),

            TextFormField(
              controller: _countyController,
              decoration: const InputDecoration(
                labelText: 'County *',
                border: OutlineInputBorder(),
              ),
              validator: (value) => value?.isEmpty ?? true ? 'Required' : null,
            ),
            const SizedBox(height: 16),

            TextFormField(
              controller: _subCountyController,
              decoration: const InputDecoration(
                labelText: 'Sub-County',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),

            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _wardController,
                    decoration: const InputDecoration(
                      labelText: 'Ward',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: TextFormField(
                    controller: _villageController,
                    decoration: const InputDecoration(
                      labelText: 'Village',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Obstetric History
            Text(
              'Obstetric History',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),

            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _gravidaController,
                    decoration: const InputDecoration(
                      labelText: 'Gravida *',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                    validator: (value) =>
                        value?.isEmpty ?? true ? 'Required' : null,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: TextFormField(
                    controller: _parityController,
                    decoration: const InputDecoration(
                      labelText: 'Parity *',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                    validator: (value) =>
                        value?.isEmpty ?? true ? 'Required' : null,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Physical Measurements
            Text(
              'Physical Measurements',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),

            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _heightController,
                    decoration: const InputDecoration(
                      labelText: 'Height (cm)',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: TextFormField(
                    controller: _weightController,
                    decoration: const InputDecoration(
                      labelText: 'Weight (kg)',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Medical Conditions
            Text(
              'Medical Conditions',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),

            CheckboxListTile(
              title: const Text('Diabetes'),
              value: _diabetes,
              onChanged: (value) => setState(() => _diabetes = value ?? false),
            ),
            CheckboxListTile(
              title: const Text('Hypertension'),
              value: _hypertension,
              onChanged: (value) =>
                  setState(() => _hypertension = value ?? false),
            ),
            CheckboxListTile(
              title: const Text('Tuberculosis'),
              value: _tuberculosis,
              onChanged: (value) =>
                  setState(() => _tuberculosis = value ?? false),
            ),
            CheckboxListTile(
              title: const Text('Previous Blood Transfusion'),
              value: _bloodTransfusion,
              onChanged: (value) =>
                  setState(() => _bloodTransfusion = value ?? false),
            ),
            CheckboxListTile(
              title: const Text('Drug Allergy'),
              value: _drugAllergy,
              onChanged: (value) =>
                  setState(() => _drugAllergy = value ?? false),
            ),
            CheckboxListTile(
              title: const Text('Previous Cesarean Section'),
              value: _previousCs,
              onChanged: (value) =>
                  setState(() => _previousCs = value ?? false),
            ),
            const SizedBox(height: 24),

            // Next of Kin
            Text(
              'Next of Kin',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),

            TextFormField(
              controller: _nextOfKinNameController,
              decoration: const InputDecoration(
                labelText: 'Name',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),

            TextFormField(
              controller: _nextOfKinRelationshipController,
              decoration: const InputDecoration(
                labelText: 'Relationship',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),

            TextFormField(
              controller: _nextOfKinPhoneController,
              decoration: const InputDecoration(
                labelText: 'Phone',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.phone,
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}
