import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:mch_core/mch_core.dart';
import '../../../../core/providers/vitamin_a_deworming_providers.dart';
import '/../core/providers/auth_providers.dart';
import '../../../../core/utils/error_helper.dart';

class AddDewormingScreen extends ConsumerStatefulWidget {
  final ChildProfile child;

  const AddDewormingScreen({
    super.key,
    required this.child,
  });

  @override
  ConsumerState<AddDewormingScreen> createState() => _AddDewormingScreenState();
}

class _AddDewormingScreenState extends ConsumerState<AddDewormingScreen> {
  final _formKey = GlobalKey<FormState>();

  DateTime _dateGiven = DateTime.now();
  int? _doseNumber;
  String _drugName = 'Albendazole';
  String _dosage = '400mg';
  bool _sideEffectsReported = false;
  String _sideEffectsDescription = '';
  String _notes = '';
  bool _isLoading = false;

  int get _ageInMonths {
    return DateTime.now().difference(widget.child.dateOfBirth).inDays ~/ 30;
  }

  Future<void> _saveRecord() async {
    if (!_formKey.currentState!.validate()) return;

    _formKey.currentState!.save();

    setState(() => _isLoading = true);

    try {
      final userProfile = ref.read(currentUserProfileProvider).value;

      // Calculate next dose date (6 months later)
      final nextDoseDate = DateTime(
        _dateGiven.year,
        _dateGiven.month + 6,
        _dateGiven.day,
      );

      final record = DewormingRecord(
        childId: widget.child.id,
        dateGiven: _dateGiven,
        ageInMonths: _ageInMonths,
        doseNumber: _doseNumber,
        drugName: _drugName,
        dosage: _dosage,
        givenBy: userProfile?.fullName,
        healthFacilityName: userProfile?.fullName,
        sideEffectsReported: _sideEffectsReported,
        sideEffectsDescription:
            _sideEffectsReported && _sideEffectsDescription.isNotEmpty
                ? _sideEffectsDescription
                : null,
        nextDoseDate: _ageInMonths < 59 ? nextDoseDate : null,
        notes: _notes.isNotEmpty ? _notes : null,
      );

      final createDeworming = ref.read(createDewormingProvider);
      await createDeworming(record);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('✅ Deworming record saved successfully!'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ErrorHelper.showErrorSnackbar(context, e);
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
        title: const Text('Record Deworming'),
        backgroundColor: Colors.teal[700],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Child Info Card
            Card(
              color: Colors.teal[50],
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.child.childName,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                        'DOB: ${DateFormat('dd/MM/yyyy').format(widget.child.dateOfBirth)}'),
                    Text('Age: $_ageInMonths months'),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Date Given
            Card(
              child: ListTile(
                leading: Icon(Icons.calendar_today, color: Colors.teal[700]),
                title: const Text('Date Given'),
                subtitle: Text(DateFormat('dd/MM/yyyy').format(_dateGiven)),
                trailing: const Icon(Icons.edit),
                onTap: () async {
                  final date = await showDatePicker(
                    context: context,
                    initialDate: _dateGiven,
                    firstDate: widget.child.dateOfBirth,
                    lastDate: DateTime.now(),
                  );
                  if (date != null) {
                    setState(() => _dateGiven = date);
                  }
                },
              ),
            ),
            const SizedBox(height: 16),

            // Dose Number
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Dose Number (Optional)',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 8),
                    DropdownButtonFormField<int>(
                      initialValue: _doseNumber,
                      decoration: const InputDecoration(
                        hintText: 'Select dose number',
                        border: OutlineInputBorder(),
                      ),
                      items: List.generate(
                        8,
                        (index) => DropdownMenuItem(
                          value: index + 1,
                          child: Text('Dose ${index + 1}'),
                        ),
                      ),
                      onChanged: (value) {
                        setState(() => _doseNumber = value);
                      },
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Drug Selection
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Drug',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 8),
                    RadioListTile<String>(
                      title: const Text('Albendazole'),
                      subtitle: const Text('400mg'),
                      value: 'Albendazole',
                      groupValue: _drugName,
                      onChanged: (value) {
                        setState(() {
                          _drugName = value!;
                          _dosage = '400mg';
                        });
                      },
                      activeColor: Colors.teal[700],
                    ),
                    RadioListTile<String>(
                      title: const Text('Mebendazole'),
                      subtitle: const Text('500mg'),
                      value: 'Mebendazole',
                      groupValue: _drugName,
                      onChanged: (value) {
                        setState(() {
                          _drugName = value!;
                          _dosage = '500mg';
                        });
                      },
                      activeColor: Colors.teal[700],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Side Effects
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CheckboxListTile(
                      title: const Text('Side Effects Reported'),
                      value: _sideEffectsReported,
                      onChanged: (value) {
                        setState(() => _sideEffectsReported = value ?? false);
                      },
                      activeColor: Colors.teal[700],
                      contentPadding: EdgeInsets.zero,
                    ),
                    if (_sideEffectsReported) ...[
                      const SizedBox(height: 8),
                      TextFormField(
                        maxLines: 3,
                        decoration: InputDecoration(
                          labelText: 'Describe Side Effects',
                          hintText: 'Nausea, vomiting, diarrhea, etc.',
                          border: const OutlineInputBorder(),
                          prefixIcon:
                              Icon(Icons.warning, color: Colors.orange[700]),
                        ),
                        onSaved: (value) =>
                            _sideEffectsDescription = value ?? '',
                        validator: _sideEffectsReported
                            ? (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please describe the side effects';
                                }
                                return null;
                              }
                            : null,
                      ),
                    ],
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Notes
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Notes (Optional)',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      maxLines: 3,
                      decoration: const InputDecoration(
                        hintText: 'Add any notes...',
                        border: OutlineInputBorder(),
                      ),
                      onSaved: (value) => _notes = value ?? '',
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Save Button
            ElevatedButton(
              onPressed: _isLoading ? null : _saveRecord,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.teal[700],
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                textStyle: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              child: _isLoading
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                  : const Text('Save Deworming Record'),
            ),
          ],
        ),
      ),
    );
  }
}
