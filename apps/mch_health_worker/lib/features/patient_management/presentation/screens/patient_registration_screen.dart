import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mch_core/mch_core.dart';
import '../../../../core/providers/supabase_providers.dart';
import '../../../../core/providers/facility_providers.dart';

/// Patient Registration Screen - 4 Steps
/// Based on MOH MCH Handbook 2020
class PatientRegistrationScreen extends ConsumerStatefulWidget {
  const PatientRegistrationScreen({super.key});

  @override
  ConsumerState<PatientRegistrationScreen> createState() =>
      _PatientRegistrationScreenState();
}

class _PatientRegistrationScreenState
    extends ConsumerState<PatientRegistrationScreen> {
  final _formKey = GlobalKey<FormState>();
  int _currentStep = 0;
  bool _isSubmitting = false;

  // Step 1: Facility Information
  final _kmhflCodeController = TextEditingController();
  final _facilityNameController = TextEditingController();
  final _ancNumberController = TextEditingController();
  final _pncNumberController = TextEditingController();

  // Step 2: Personal Information
  final _clientNameController = TextEditingController();
  final _idNumberController = TextEditingController();
  final _ageController = TextEditingController();
  final _telephoneController = TextEditingController();
  final _countyController = TextEditingController();
  final _subCountyController = TextEditingController();
  final _wardController = TextEditingController();
  final _villageController = TextEditingController();

  // Step 3: Obstetric Data
  final _gravidaController = TextEditingController();
  final _parityController = TextEditingController();
  final _heightController = TextEditingController();
  final _weightController = TextEditingController();
  DateTime? _lmp;
  DateTime? _edd;

  // Step 4: Medical History
  bool _diabetes = false;
  bool _hypertension = false;
  bool _tuberculosis = false;
  bool _bloodTransfusion = false;
  bool _drugAllergy = false;
  final _allergyDetailsController = TextEditingController();
  bool _previousCs = false;
  final _previousCsCountController = TextEditingController();
  bool _bleedingHistory = false;
  final _stillbirthsController = TextEditingController();
  final _neonatalDeathsController = TextEditingController();
  bool _fgmDone = false;

  // Next of Kin
  final _nextOfKinNameController = TextEditingController();
  final _nextOfKinRelationshipController = TextEditingController();
  final _nextOfKinPhoneController = TextEditingController();

  @override
  void dispose() {
    _kmhflCodeController.dispose();
    _facilityNameController.dispose();
    _ancNumberController.dispose();
    _pncNumberController.dispose();
    _clientNameController.dispose();
    _idNumberController.dispose();
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
    _allergyDetailsController.dispose();
    _previousCsCountController.dispose();
    _stillbirthsController.dispose();
    _neonatalDeathsController.dispose();
    _nextOfKinNameController.dispose();
    _nextOfKinRelationshipController.dispose();
    _nextOfKinPhoneController.dispose();
    super.dispose();
  }

  Future<void> _handleSubmit() async {
    // Final validation before submission
    if (_formKey.currentState!.validate()) {
      // Double check Dates
      if (_lmp == null || _edd == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please select LMP and EDD dates'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      // Double check Facility Provider
      final selectedFacility = ref.read(selectedFacilityProvider);
      if (selectedFacility == null) {
         ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('❌ No facility selected. Please return to Step 1.'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      setState(() {
        _isSubmitting = true;
      });

      try {
        final profile = MaternalProfile(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          facilityId: selectedFacility.id,
          kmhflCode: _kmhflCodeController.text,
          facilityName: _facilityNameController.text,
          ancNumber: _ancNumberController.text,
          pncNumber: _pncNumberController.text.isEmpty
              ? null
              : _pncNumberController.text,
          clientName: _clientNameController.text,
          idNumber: _idNumberController.text.isEmpty
              ? null
              : _idNumberController.text,
          age: int.parse(_ageController.text),
          telephone: _telephoneController.text.isEmpty
              ? null
              : _telephoneController.text,
          county: _countyController.text.isEmpty
              ? null
              : _countyController.text,
          subCounty: _subCountyController.text.isEmpty
              ? null
              : _subCountyController.text,
          ward: _wardController.text.isEmpty ? null : _wardController.text,
          village:
              _villageController.text.isEmpty ? null : _villageController.text,
          gravida: int.parse(_gravidaController.text),
          parity: int.parse(_parityController.text),
          heightCm: double.parse(_heightController.text),
          weightKg: double.parse(_weightController.text),
          lmp: _lmp!,
          edd: _edd!,
          gestationAtFirstVisit: null,
          diabetes: _diabetes,
          hypertension: _hypertension,
          tuberculosis: _tuberculosis,
          bloodTransfusion: _bloodTransfusion,
          drugAllergy: _drugAllergy,
          allergyDetails: _allergyDetailsController.text.isEmpty
              ? null
              : _allergyDetailsController.text,
          previousCs: _previousCs,
          previousCsCount: _previousCsCountController.text.isEmpty
              ? null
              : int.parse(_previousCsCountController.text),
          bleedingHistory: _bleedingHistory,
          stillbirths: _stillbirthsController.text.isEmpty
              ? 0
              : int.parse(_stillbirthsController.text),
          neonatalDeaths: _neonatalDeathsController.text.isEmpty
              ? 0
              : int.parse(_neonatalDeathsController.text),
          fgmDone: _fgmDone,
          nextOfKinName: _nextOfKinNameController.text.isEmpty
              ? null
              : _nextOfKinNameController.text,
          nextOfKinRelationship: _nextOfKinRelationshipController.text.isEmpty
              ? null
              : _nextOfKinRelationshipController.text,
          nextOfKinPhone: _nextOfKinPhoneController.text.isEmpty
              ? null
              : _nextOfKinPhoneController.text,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        );

        // Use Supabase provider
        final createProfile = ref.read(createMaternalProfileProvider);
        await createProfile(profile);

        // Invalidate providers to refresh data
        ref.invalidate(maternalProfilesProvider);
        ref.invalidate(statisticsProvider);

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('✅ Patient registered successfully!'),
              backgroundColor: Colors.green,
              duration: Duration(seconds: 2),
            ),
          );
          Navigator.pop(context);
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('❌ Error: ${e.toString()}'),
              backgroundColor: Colors.red,
              duration: const Duration(seconds: 3),
            ),
          );
        }
      } finally {
        if (mounted) {
          setState(() {
            _isSubmitting = false;
          });
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Register New Patient'),
      ),
      body: Form(
        key: _formKey,
        child: Stepper(
          currentStep: _currentStep,
          onStepContinue: () {
            // --- VALIDATION LOGIC ---
            
            // Step 1 Checks
            if (_currentStep == 0) {
              // 1. Check if facility is selected in Provider
              if (ref.read(selectedFacilityProvider) == null) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('⚠️ Please select a facility before continuing'),
                    backgroundColor: Colors.orange,
                  ),
                );
                return;
              }
              // 2. Check ANC Number
              if (_ancNumberController.text.isEmpty) {
                 ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('⚠️ Please enter ANC Number')),
                );
                return;
              }
            }

            // Proceed if validation passes
            if (_currentStep < 3) {
              setState(() {
                _currentStep++;
              });
            } else {
              _handleSubmit();
            }
          },
          onStepCancel: () {
            if (_currentStep > 0) {
              setState(() {
                _currentStep--;
              });
            } else {
              Navigator.pop(context);
            }
          },
          controlsBuilder: (context, details) {
            return Padding(
              padding: const EdgeInsets.only(top: 16),
              child: Row(
                children: [
                  ElevatedButton(
                    onPressed: _isSubmitting ? null : details.onStepContinue,
                    child: _isSubmitting
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : Text(_currentStep == 3 ? 'Submit' : 'Continue'),
                  ),
                  const SizedBox(width: 12),
                  TextButton(
                    onPressed: _isSubmitting ? null : details.onStepCancel,
                    child: Text(_currentStep == 0 ? 'Cancel' : 'Back'),
                  ),
                ],
              ),
            );
          },
          steps: [
            // Step 1: Facility Information
            Step(
              title: const Text('Facility Information'),
              content: Column(
                children: [
                  // Facility Selector Dropdown
                  Consumer(
                    builder: (context, ref, child) {
                      final facilitiesAsync = ref.watch(facilitiesProvider);
                      // Watch the selected facility to keep the dropdown in sync
                      final selectedFacility = ref.watch(selectedFacilityProvider);

                      return facilitiesAsync.when(
                        data: (facilities) {
                          return DropdownButtonFormField<String>(
                            // Binds the visual value to the provider (Single Source of Truth)
                            value: selectedFacility?.id, 
                            decoration: const InputDecoration(
                              labelText: 'Select Facility *',
                              border: OutlineInputBorder(),
                              prefixIcon: Icon(Icons.local_hospital),
                            ),
                            items: facilities.map((facility) {
                              return DropdownMenuItem(
                                value: facility.id,
                                child: Text('${facility.name} (${facility.kmhflCode})'),
                              );
                            }).toList(),
                            onChanged: (value) {
                              if (value != null) {
                                final facility = facilities.firstWhere((f) => f.id == value);
                                ref.read(selectedFacilityProvider.notifier).state = facility;
                                
                                // Auto-fill facility details
                                _kmhflCodeController.text = facility.kmhflCode;
                                _facilityNameController.text = facility.name;
                              }
                            },
                            validator: (value) => value == null ? 'Please select a facility' : null,
                          );
                        },
                        loading: () => const Center(child: CircularProgressIndicator()),
                        error: (error, stack) => Text('Error loading facilities: $error'),
                      );
                    },
                  ),
                  
                  const SizedBox(height: 16),

                  // KMHFL Code Field (Auto-filled, Read-only)
                  TextFormField(
                    controller: _kmhflCodeController,
                    readOnly: true,
                    decoration: const InputDecoration(
                      labelText: 'KMHFL Code',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.qr_code),
                      filled: true,
                      fillColor: Colors.black12,
                    ),
                  ),
                  
                  const SizedBox(height: 16),

                  // Facility Name Field (Auto-filled, Read-only)
                  TextFormField(
                    controller: _facilityNameController,
                    readOnly: true,
                    decoration: const InputDecoration(
                      labelText: 'Facility Name',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.business),
                      filled: true,
                      fillColor: Colors.black12, 
                    ),
                  ),

                  const SizedBox(height: 16),
                  
                  // ANC Number
                  TextFormField(
                    controller: _ancNumberController,
                    decoration: const InputDecoration(
                      labelText: 'ANC Number *',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) =>
                        value?.isEmpty ?? true ? 'Required' : null,
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // PNC Number
                  TextFormField(
                    controller: _pncNumberController,
                    decoration: const InputDecoration(
                      labelText: 'PNC Number (Optional)',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ],
              ),
              isActive: _currentStep >= 0,
              state: _currentStep > 0 ? StepState.complete : StepState.indexed,
            ),

            // Step 2: Personal Information
            Step(
              title: const Text('Personal Information'),
              content: Column(
                children: [
                  TextFormField(
                    controller: _clientNameController,
                    decoration: const InputDecoration(
                      labelText: 'Client Name *',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) =>
                        value?.isEmpty ?? true ? 'Required' : null,
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: _idNumberController,
                          decoration: const InputDecoration(
                            labelText: 'ID Number',
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: TextFormField(
                          controller: _ageController,
                          decoration: const InputDecoration(
                            labelText: 'Age *',
                            border: OutlineInputBorder(),
                          ),
                          keyboardType: TextInputType.number,
                          validator: (value) =>
                              value?.isEmpty ?? true ? 'Required' : null,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _telephoneController,
                    decoration: const InputDecoration(
                      labelText: 'Telephone',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.phone,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _countyController,
                    decoration: const InputDecoration(
                      labelText: 'County',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _subCountyController,
                    decoration: const InputDecoration(
                      labelText: 'Sub County',
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
                      const SizedBox(width: 12),
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
                ],
              ),
              isActive: _currentStep >= 1,
              state: _currentStep > 1 ? StepState.complete : StepState.indexed,
            ),

            // Step 3: Obstetric Data
            Step(
              title: const Text('Obstetric Data'),
              content: Column(
                children: [
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
                      const SizedBox(width: 12),
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
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: _heightController,
                          decoration: const InputDecoration(
                            labelText: 'Height (cm) *',
                            border: OutlineInputBorder(),
                          ),
                          keyboardType: TextInputType.number,
                          validator: (value) =>
                              value?.isEmpty ?? true ? 'Required' : null,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: TextFormField(
                          controller: _weightController,
                          decoration: const InputDecoration(
                            labelText: 'Weight (kg) *',
                            border: OutlineInputBorder(),
                          ),
                          keyboardType: TextInputType.number,
                          validator: (value) =>
                              value?.isEmpty ?? true ? 'Required' : null,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  ListTile(
                    title: const Text('LMP (Last Menstrual Period) *'),
                    subtitle: Text(_lmp != null
                        ? _lmp.toString().split(' ')[0]
                        : 'Not selected'),
                    trailing: const Icon(Icons.calendar_today),
                    onTap: () async {
                      final date = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now().subtract(
                          const Duration(days: 90),
                        ),
                        firstDate: DateTime.now().subtract(
                          const Duration(days: 365),
                        ),
                        lastDate: DateTime.now(),
                      );
                      if (date != null) {
                        setState(() {
                          _lmp = date;
                          _edd = date.add(const Duration(days: 280));
                        });
                      }
                    },
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                      side: const BorderSide(color: Colors.grey),
                    ),
                  ),
                  const SizedBox(height: 16),
                  ListTile(
                    title: const Text('EDD (Expected Date of Delivery) *'),
                    subtitle: Text(_edd != null
                        ? _edd.toString().split(' ')[0]
                        : 'Not selected'),
                    trailing: const Icon(Icons.calendar_today),
                    onTap: () async {
                      final date = await showDatePicker(
                        context: context,
                        initialDate: _edd ??
                            DateTime.now().add(const Duration(days: 280)),
                        firstDate: DateTime.now(),
                        lastDate: DateTime.now().add(
                          const Duration(days: 365),
                        ),
                      );
                      if (date != null) {
                        setState(() {
                          _edd = date;
                        });
                      }
                    },
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                      side: const BorderSide(color: Colors.grey),
                    ),
                  ),
                ],
              ),
              isActive: _currentStep >= 2,
              state: _currentStep > 2 ? StepState.complete : StepState.indexed,
            ),

            // Step 4: Medical History
            Step(
              title: const Text('Medical History'),
              content: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Medical Conditions:',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  CheckboxListTile(
                    title: const Text('Diabetes'),
                    value: _diabetes,
                    onChanged: (value) =>
                        setState(() => _diabetes = value ?? false),
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
                    title: const Text('Blood Transfusion'),
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
                  if (_drugAllergy)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: TextFormField(
                        controller: _allergyDetailsController,
                        decoration: const InputDecoration(
                          labelText: 'Allergy Details',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                  const SizedBox(height: 16),
                  const Text(
                    'Obstetric History:',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  CheckboxListTile(
                    title: const Text('Previous C-Section'),
                    value: _previousCs,
                    onChanged: (value) =>
                        setState(() => _previousCs = value ?? false),
                  ),
                  if (_previousCs)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: TextFormField(
                        controller: _previousCsCountController,
                        decoration: const InputDecoration(
                          labelText: 'Number of C-Sections',
                          border: OutlineInputBorder(),
                        ),
                        keyboardType: TextInputType.number,
                      ),
                    ),
                  CheckboxListTile(
                    title: const Text('Bleeding History'),
                    value: _bleedingHistory,
                    onChanged: (value) =>
                        setState(() => _bleedingHistory = value ?? false),
                  ),
                  CheckboxListTile(
                    title: const Text('FGM Done'),
                    value: _fgmDone,
                    onChanged: (value) =>
                        setState(() => _fgmDone = value ?? false),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _stillbirthsController,
                    decoration: const InputDecoration(
                      labelText: 'Number of Stillbirths',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _neonatalDeathsController,
                    decoration: const InputDecoration(
                      labelText: 'Number of Neonatal Deaths',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 16),
                  const Divider(),
                  const SizedBox(height: 16),
                  const Text(
                    'Next of Kin:',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _nextOfKinNameController,
                    decoration: const InputDecoration(
                      labelText: 'Next of Kin Name',
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
                      labelText: 'Next of Kin Phone',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.phone,
                  ),
                ],
              ),
              isActive: _currentStep >= 3,
            ),
          ],
        ),
      ),
    );
  }
}