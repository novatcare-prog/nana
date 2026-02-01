import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:mch_core/mch_core.dart';
import '../../../../core/providers/child_provider.dart';
import '../../../../core/providers/maternal_profile_provider.dart';

class AddChildScreen extends ConsumerStatefulWidget {
  const AddChildScreen({super.key});

  @override
  ConsumerState<AddChildScreen> createState() => _AddChildScreenState();
}

class _AddChildScreenState extends ConsumerState<AddChildScreen> {
  final _formKey = GlobalKey<FormState>();

  // Form Controllers
  final _nameController = TextEditingController();
  final _birthWeightController = TextEditingController();
  final _placeOfBirthController =
      TextEditingController(text: 'Hospital'); // Default

  DateTime _dateOfBirth = DateTime.now();
  String _sex = 'Female'; // Default

  bool _isSubmitting = false;

  @override
  void dispose() {
    _nameController.dispose();
    _birthWeightController.dispose();
    _placeOfBirthController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _dateOfBirth,
      firstDate: DateTime(2010),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFFE91E63),
              onPrimary: Colors.white,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != _dateOfBirth) {
      setState(() {
        _dateOfBirth = picked;
      });
    }
  }

  Future<void> _saveChild() async {
    if (!_formKey.currentState!.validate()) return;

    // Get Maternal Profile ID
    final maternalProfile = ref.read(currentMaternalProfileProvider).value;
    if (maternalProfile == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Error: Profile not loaded. Please try again.')),
      );
      return;
    }

    setState(() => _isSubmitting = true);

    try {
      final double weightKg = double.parse(_birthWeightController.text);
      final double weightGrams = weightKg * 1000;

      final newChild = ChildProfile(
        id: '', // Backend or Repository should handle ID, or we ignore it on insert
        maternalProfileId: maternalProfile.id!,
        childName: _nameController.text.trim(),
        sex: _sex,
        dateOfBirth: _dateOfBirth,
        dateFirstSeen: DateTime.now(),
        gestationAtBirthWeeks: 40, // Default for manual entry
        birthWeightGrams: weightGrams,
        birthLengthCm: 50.0, // Default
        placeOfBirth: _placeOfBirthController.text,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        // Defaults for nullable fields
        hivExposed: false,
        tbScreened: false,
      );

      final success = await ref
          .read(patientChildControllerProvider.notifier)
          .addChild(newChild);

      if (!mounted) return;

      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Child added successfully!'),
            backgroundColor: Colors.green,
          ),
        );
        context.pop(); // Go back to list
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to add child. Please try again.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
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
        title: const Text('Add Child'),
        backgroundColor: const Color(0xFFE91E63),
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Info Card
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.blue.shade200),
                ),
                child: Row(
                  children: [
                    Icon(Icons.info_outline, color: Colors.blue.shade700),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Please enter your child\'s details as they appear on the birth notification or certificate.',
                        style: TextStyle(color: Colors.blue.shade900),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Name Field
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Child\'s Name',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.person),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Date of Birth
              InkWell(
                onTap: () => _selectDate(context),
                child: InputDecorator(
                  decoration: const InputDecoration(
                    labelText: 'Date of Birth',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.calendar_today),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        DateFormat('d MMMM yyyy').format(_dateOfBirth),
                        style: const TextStyle(fontSize: 16),
                      ),
                      const Icon(Icons.arrow_drop_down),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Sex Selection
              const Text('Sex',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: RadioListTile<String>(
                      title: const Text('Female'),
                      value: 'Female',
                      groupValue: _sex,
                      activeColor: Colors.pink,
                      onChanged: (value) => setState(() => _sex = value!),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8)),
                      tileColor: _sex == 'Female' ? Colors.pink.shade50 : null,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: RadioListTile<String>(
                      title: const Text('Male'),
                      value: 'Male',
                      groupValue: _sex,
                      activeColor: Colors.blue,
                      onChanged: (value) => setState(() => _sex = value!),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8)),
                      tileColor: _sex == 'Male' ? Colors.blue.shade50 : null,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Birth Weight
              TextFormField(
                controller: _birthWeightController,
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                decoration: const InputDecoration(
                  labelText: 'Birth Weight (kg)',
                  hintText: 'e.g. 3.5',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.monitor_weight),
                  suffixText: 'kg',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter birth weight';
                  }
                  final weight = double.tryParse(value);
                  if (weight == null || weight <= 0 || weight > 10) {
                    return 'Please enter a valid weight (0.1 - 10 kg)';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Place of Birth
              TextFormField(
                controller: _placeOfBirthController,
                decoration: const InputDecoration(
                  labelText: 'Place of Birth',
                  hintText: 'e.g. Hospital name or Home',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.location_on),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter place of birth';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 32),

              // Submit Button
              SizedBox(
                height: 50,
                child: ElevatedButton(
                  onPressed: _isSubmitting ? null : _saveChild,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFE91E63),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: _isSubmitting
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text(
                          'Save Child',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
