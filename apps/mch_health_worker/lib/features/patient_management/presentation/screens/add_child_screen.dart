import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mch_core/mch_core.dart';
import '../../../../core/providers/childbirth_providers.dart';
import '../../../../core/providers/auth_providers.dart';

/// Add Child Screen - Multi-step child registration
/// Excludes childbirth-specific fields
class AddChildScreen extends ConsumerStatefulWidget {
  final String maternalProfileId;
  final String motherName;

  const AddChildScreen({
    super.key,
    required this.maternalProfileId,
    required this.motherName,
  });

  @override
  ConsumerState<AddChildScreen> createState() => _AddChildScreenState();
}

class _AddChildScreenState extends ConsumerState<AddChildScreen> {
  int _currentStep = 0;
  bool _isLoading = false;

  // Step 1: Basic Information controllers
  final _childNameController = TextEditingController();
  String _selectedSex = 'Male';
  DateTime? _dateOfBirth;
  DateTime _dateFirstSeen = DateTime.now();
  final _birthOrderController = TextEditingController();

  // Step 2: Contact & Registration controllers
  final _fatherNameController = TextEditingController();
  final _fatherPhoneController = TextEditingController();
  final _guardianNameController = TextEditingController();
  final _guardianPhoneController = TextEditingController();
  final _countyController = TextEditingController();
  final _subCountyController = TextEditingController();
  final _wardController = TextEditingController();
  final _villageController = TextEditingController();
  final _immunizationRegController = TextEditingController();
  final _cwcNumberController = TextEditingController();
  final _birthCertNumberController = TextEditingController();

  // Step 3: Health Assessment controllers
  final _weightController = TextEditingController();
  final _lengthController = TextEditingController();
  final _headCircumferenceController = TextEditingController();
  bool? _hivExposed;
  String _hivStatus = 'Unknown';
  bool _tbScreened = false;

  @override
  void dispose() {
    _childNameController.dispose();
    _birthOrderController.dispose();
    _fatherNameController.dispose();
    _fatherPhoneController.dispose();
    _guardianNameController.dispose();
    _guardianPhoneController.dispose();
    _countyController.dispose();
    _subCountyController.dispose();
    _wardController.dispose();
    _villageController.dispose();
    _immunizationRegController.dispose();
    _cwcNumberController.dispose();
    _birthCertNumberController.dispose();
    _weightController.dispose();
    _lengthController.dispose();
    _headCircumferenceController.dispose();
    super.dispose();
  }

  Future<void> _saveChild() async {
    setState(() => _isLoading = true);

    try {
      final child = ChildProfile(
        id: '',
        maternalProfileId: widget.maternalProfileId,
        // Basic Information
        childName: _childNameController.text.trim(),
        sex: _selectedSex,
        dateOfBirth: _dateOfBirth!,
        dateFirstSeen: _dateFirstSeen,
        birthOrder: _birthOrderController.text.isNotEmpty 
            ? int.tryParse(_birthOrderController.text) 
            : null,
        // Removed childbirth-specific fields
        gestationAtBirthWeeks: 0, // Not applicable for manual registration
        birthWeightGrams: 0, // Not applicable
        birthLengthCm: 0, // Not applicable
        placeOfBirth: 'Unknown', // Not applicable
        // Family Details
        fatherName: _fatherNameController.text.trim().isEmpty 
            ? null 
            : _fatherNameController.text.trim(),
        fatherPhone: _fatherPhoneController.text.trim().isEmpty 
            ? null 
            : _fatherPhoneController.text.trim(),
        motherName: widget.motherName,
        guardianName: _guardianNameController.text.trim().isEmpty 
            ? null 
            : _guardianNameController.text.trim(),
        guardianPhone: _guardianPhoneController.text.trim().isEmpty 
            ? null 
            : _guardianPhoneController.text.trim(),
        // Address
        county: _countyController.text.trim().isEmpty 
            ? null 
            : _countyController.text.trim(),
        subCounty: _subCountyController.text.trim().isEmpty 
            ? null 
            : _subCountyController.text.trim(),
        ward: _wardController.text.trim().isEmpty 
            ? null 
            : _wardController.text.trim(),
        village: _villageController.text.trim().isEmpty 
            ? null 
            : _villageController.text.trim(),
        // Registration Numbers
        immunizationRegNumber: _immunizationRegController.text.trim().isEmpty 
            ? null 
            : _immunizationRegController.text.trim(),
        cwcNumber: _cwcNumberController.text.trim().isEmpty 
            ? null 
            : _cwcNumberController.text.trim(),
        birthCertificateNumber: _birthCertNumberController.text.trim().isEmpty 
            ? null 
            : _birthCertNumberController.text.trim(),
        // Current Health Status
        weightAtFirstContact: _weightController.text.isNotEmpty 
            ? double.tryParse(_weightController.text) 
            : null,
        lengthAtFirstContact: _lengthController.text.isNotEmpty 
            ? double.tryParse(_lengthController.text) 
            : null,
        headCircumferenceCm: _headCircumferenceController.text.isNotEmpty 
            ? double.tryParse(_headCircumferenceController.text) 
            : null,
        hivExposed: _hivExposed,
        hivStatus: _hivStatus == 'Unknown' ? null : _hivStatus,
        tbScreened: _tbScreened,
      );

      await ref.read(createChildProfileProvider)(child);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('✓ Child registered successfully'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to register child: $e'),
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

  Widget _buildStep1BasicInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Basic Information',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        
        TextFormField(
          controller: _childNameController,
          decoration: const InputDecoration(
            labelText: 'Child Name *',
            hintText: 'Enter child full name',
            prefixIcon: Icon(Icons.child_care),
            border: OutlineInputBorder(),
          ),
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'Please enter child name';
            }
            return null;
          },
        ),
        const SizedBox(height: 16),

        DropdownButtonFormField<String>(
          value: _selectedSex,
          decoration: const InputDecoration(
            labelText: 'Sex *',
            prefixIcon: Icon(Icons.person),
            border: OutlineInputBorder(),
          ),
          items: ['Male', 'Female'].map((sex) {
            return DropdownMenuItem(value: sex, child: Text(sex));
          }).toList(),
          onChanged: (value) {
            setState(() => _selectedSex = value!);
          },
        ),
        const SizedBox(height: 16),

        ListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          tileColor: Colors.grey[100],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4),
            side: BorderSide(color: Colors.grey[400]!),
          ),
          leading: const Icon(Icons.calendar_today),
          title: Text(
            _dateOfBirth == null
                ? 'Select Date of Birth *'
                : 'Born: ${_dateOfBirth!.day}/${_dateOfBirth!.month}/${_dateOfBirth!.year}',
          ),
          trailing: const Icon(Icons.edit),
          onTap: () async {
            final date = await showDatePicker(
              context: context,
              initialDate: DateTime.now(),
              firstDate: DateTime.now().subtract(const Duration(days: 365 * 10)),
              lastDate: DateTime.now(),
            );
            if (date != null) {
              setState(() => _dateOfBirth = date);
            }
          },
        ),
        const SizedBox(height: 16),

        ListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          tileColor: Colors.grey[100],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4),
            side: BorderSide(color: Colors.grey[400]!),
          ),
          leading: const Icon(Icons.event),
          title: Text(
            'First Seen: ${_dateFirstSeen.day}/${_dateFirstSeen.month}/${_dateFirstSeen.year}',
          ),
          trailing: const Icon(Icons.edit),
          onTap: () async {
            final date = await showDatePicker(
              context: context,
              initialDate: _dateFirstSeen,
              firstDate: DateTime.now().subtract(const Duration(days: 365 * 10)),
              lastDate: DateTime.now(),
            );
            if (date != null) {
              setState(() => _dateFirstSeen = date);
            }
          },
        ),
        const SizedBox(height: 16),

        TextFormField(
          controller: _birthOrderController,
          decoration: const InputDecoration(
            labelText: 'Birth Order (Optional)',
            hintText: 'e.g., 1 for first child, 2 for second',
            prefixIcon: Icon(Icons.format_list_numbered),
            border: OutlineInputBorder(),
          ),
          keyboardType: TextInputType.number,
        ),
      ],
    );
  }

  Widget _buildStep2ContactRegistration() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Contact & Registration',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Text(
          'All fields in this step are optional',
          style: TextStyle(color: Colors.grey[600], fontSize: 14),
        ),
        const SizedBox(height: 16),

        const Text('Family Details', style: TextStyle(fontWeight: FontWeight.w600)),
        const SizedBox(height: 12),
        
        TextFormField(
          controller: _fatherNameController,
          decoration: const InputDecoration(
            labelText: 'Father Name',
            prefixIcon: Icon(Icons.person_outline),
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 12),

        TextFormField(
          controller: _fatherPhoneController,
          decoration: const InputDecoration(
            labelText: 'Father Phone',
            prefixIcon: Icon(Icons.phone),
            border: OutlineInputBorder(),
          ),
          keyboardType: TextInputType.phone,
        ),
        const SizedBox(height: 12),

        TextFormField(
          controller: _guardianNameController,
          decoration: const InputDecoration(
            labelText: 'Guardian Name',
            prefixIcon: Icon(Icons.person_outline),
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 12),

        TextFormField(
          controller: _guardianPhoneController,
          decoration: const InputDecoration(
            labelText: 'Guardian Phone',
            prefixIcon: Icon(Icons.phone),
            border: OutlineInputBorder(),
          ),
          keyboardType: TextInputType.phone,
        ),
        const SizedBox(height: 24),

        const Text('Address', style: TextStyle(fontWeight: FontWeight.w600)),
        const SizedBox(height: 12),
        
        TextFormField(
          controller: _countyController,
          decoration: const InputDecoration(
            labelText: 'County',
            prefixIcon: Icon(Icons.location_city),
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 12),

        TextFormField(
          controller: _subCountyController,
          decoration: const InputDecoration(
            labelText: 'Sub-County',
            prefixIcon: Icon(Icons.location_on),
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 12),

        TextFormField(
          controller: _wardController,
          decoration: const InputDecoration(
            labelText: 'Ward',
            prefixIcon: Icon(Icons.map),
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 12),

        TextFormField(
          controller: _villageController,
          decoration: const InputDecoration(
            labelText: 'Village',
            prefixIcon: Icon(Icons.home),
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 24),

        const Text('Registration Numbers', style: TextStyle(fontWeight: FontWeight.w600)),
        const SizedBox(height: 12),
        
        TextFormField(
          controller: _immunizationRegController,
          decoration: const InputDecoration(
            labelText: 'Immunization Registration Number',
            prefixIcon: Icon(Icons.vaccines),
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 12),

        TextFormField(
          controller: _cwcNumberController,
          decoration: const InputDecoration(
            labelText: 'CWC Number',
            prefixIcon: Icon(Icons.badge),
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 12),

        TextFormField(
          controller: _birthCertNumberController,
          decoration: const InputDecoration(
            labelText: 'Birth Certificate Number',
            prefixIcon: Icon(Icons.description),
            border: OutlineInputBorder(),
          ),
        ),
      ],
    );
  }

  Widget _buildStep3HealthAssessment() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Health Assessment',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Text(
          'Current health measurements (at first contact)',
          style: TextStyle(color: Colors.grey[600], fontSize: 14),
        ),
        const SizedBox(height: 16),

        const Text('Current Measurements', style: TextStyle(fontWeight: FontWeight.w600)),
        const SizedBox(height: 12),
        
        TextFormField(
          controller: _weightController,
          decoration: const InputDecoration(
            labelText: 'Weight at First Contact',
            hintText: 'Current weight in kg',
            prefixIcon: Icon(Icons.monitor_weight),
            border: OutlineInputBorder(),
            suffixText: 'kg',
          ),
          keyboardType: TextInputType.number,
        ),
        const SizedBox(height: 12),

        TextFormField(
          controller: _lengthController,
          decoration: const InputDecoration(
            labelText: 'Length at First Contact',
            hintText: 'Current length in cm',
            prefixIcon: Icon(Icons.straighten),
            border: OutlineInputBorder(),
            suffixText: 'cm',
          ),
          keyboardType: TextInputType.number,
        ),
        const SizedBox(height: 12),

        TextFormField(
          controller: _headCircumferenceController,
          decoration: const InputDecoration(
            labelText: 'Head Circumference',
            hintText: 'Current measurement in cm',
            prefixIcon: Icon(Icons.circle_outlined),
            border: OutlineInputBorder(),
            suffixText: 'cm',
          ),
          keyboardType: TextInputType.number,
        ),
        const SizedBox(height: 24),

        const Text('Health Screening', style: TextStyle(fontWeight: FontWeight.w600)),
        const SizedBox(height: 12),

        DropdownButtonFormField<bool?>(
          value: _hivExposed,
          decoration: const InputDecoration(
            labelText: 'HIV Exposed',
            prefixIcon: Icon(Icons.health_and_safety),
            border: OutlineInputBorder(),
          ),
          items: const [
            DropdownMenuItem(value: null, child: Text('Unknown')),
            DropdownMenuItem(value: true, child: Text('Yes')),
            DropdownMenuItem(value: false, child: Text('No')),
          ],
          onChanged: (value) {
            setState(() => _hivExposed = value);
          },
        ),
        const SizedBox(height: 12),

        DropdownButtonFormField<String>(
          value: _hivStatus,
          decoration: const InputDecoration(
            labelText: 'HIV Status',
            prefixIcon: Icon(Icons.medical_information),
            border: OutlineInputBorder(),
          ),
          items: ['Unknown', 'Negative', 'Positive', 'Not Tested'].map((status) {
            return DropdownMenuItem(value: status, child: Text(status));
          }).toList(),
          onChanged: (value) {
            setState(() => _hivStatus = value!);
          },
        ),
        const SizedBox(height: 12),

        SwitchListTile(
          title: const Text('TB Screened'),
          subtitle: const Text('Has the child been screened for TB?'),
          value: _tbScreened,
          onChanged: (value) {
            setState(() => _tbScreened = value);
          },
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Child - ${widget.motherName}'),
      ),
      body: Stepper(
        type: StepperType.horizontal,
        currentStep: _currentStep,
        onStepContinue: () {
          if (_currentStep == 0) {
            // Validate Step 1
            if (_childNameController.text.trim().isEmpty) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Please enter child name'),
                  backgroundColor: Colors.orange,
                ),
              );
              return;
            }
            if (_dateOfBirth == null) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Please select date of birth'),
                  backgroundColor: Colors.orange,
                ),
              );
              return;
            }
          }

          if (_currentStep < 2) {
            setState(() => _currentStep++);
          } else {
            _saveChild();
          }
        },
        onStepCancel: () {
          if (_currentStep > 0) {
            setState(() => _currentStep--);
          }
        },
        controlsBuilder: (context, details) {
          return Padding(
            padding: const EdgeInsets.only(top: 16),
            child: Row(
              children: [
                ElevatedButton(
                  onPressed: _isLoading ? null : details.onStepContinue,
                  child: Text(_currentStep == 2 ? 'Save' : 'Next'),
                ),
                const SizedBox(width: 12),
                if (_currentStep > 0)
                  TextButton(
                    onPressed: details.onStepCancel,
                    child: const Text('Back'),
                  ),
                const Spacer(),
                if (_currentStep > 0 && _currentStep < 2)
                  TextButton(
                    onPressed: () {
                      setState(() => _currentStep = 2);
                    },
                    child: const Text('Skip to Health'),
                  ),
              ],
            ),
          );
        },
        steps: [
          Step(
            title: const Text('Basic'),
            content: _buildStep1BasicInfo(),
            isActive: _currentStep >= 0,
            state: _currentStep > 0 ? StepState.complete : StepState.indexed,
          ),
          Step(
            title: const Text('Contact'),
            content: _buildStep2ContactRegistration(),
            isActive: _currentStep >= 1,
            state: _currentStep > 1 ? StepState.complete : StepState.indexed,
          ),
          Step(
            title: const Text('Health'),
            content: _buildStep3HealthAssessment(),
            isActive: _currentStep >= 2,
          ),
        ],
      ),
    );
  }
}
