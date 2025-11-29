import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:mch_core/mch_core.dart';
import '../../../../core/providers/vitamin_a_deworming_providers.dart';
import '../../../../core/providers/auth_providers.dart';

class AddVitaminAScreen extends ConsumerStatefulWidget {
  final ChildProfile child;

  const AddVitaminAScreen({
    super.key,
    required this.child,
  });

  @override
  ConsumerState<AddVitaminAScreen> createState() => _AddVitaminAScreenState();
}

class _AddVitaminAScreenState extends ConsumerState<AddVitaminAScreen> {
  final _formKey = GlobalKey<FormState>();
  
  DateTime _dateGiven = DateTime.now();
  int? _doseNumber;
  int _dosageIU = 100000;
  String _notes = '';
  bool _isLoading = false;

  int get _ageInMonths {
    return DateTime.now().difference(widget.child.dateOfBirth).inDays ~/ 30;
  }

  @override
  void initState() {
    super.initState();
    // Auto-select dosage based on age
    if (_ageInMonths >= 12) {
      _dosageIU = 200000;
    }
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

      final record = VitaminARecord(
        childId: widget.child.id,
        dateGiven: _dateGiven,
        ageInMonths: _ageInMonths,
        doseNumber: _doseNumber,
        dosageIU: _dosageIU,
        givenBy: userProfile?.fullName,
        healthFacilityName: userProfile?.fullName,
        nextDoseDate: _ageInMonths < 59 ? nextDoseDate : null,
        notes: _notes.isNotEmpty ? _notes : null,
      );

      final createVitaminA = ref.read(createVitaminAProvider);
      await createVitaminA(record);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('✅ Vitamin A record saved successfully!'),
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
        title: const Text('Record Vitamin A'),
        backgroundColor: Colors.orange[700],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Child Info Card
            Card(
              color: Colors.orange[50],
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
                    Text('DOB: ${DateFormat('dd/MM/yyyy').format(widget.child.dateOfBirth)}'),
                    Text('Age: $_ageInMonths months'),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Date Given
            Card(
              child: ListTile(
                leading: Icon(Icons.calendar_today, color: Colors.orange[700]),
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
                      value: _doseNumber,
                      decoration: const InputDecoration(
                        hintText: 'Select dose number',
                        border: OutlineInputBorder(),
                      ),
                      items: List.generate(
                        10,
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

            // Dosage
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Dosage (IU)',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 8),
                    RadioListTile<int>(
                      title: const Text('100,000 IU (6-11 months)'),
                      value: 100000,
                      groupValue: _dosageIU,
                      onChanged: (value) {
                        setState(() => _dosageIU = value!);
                      },
                      activeColor: Colors.orange[700],
                    ),
                    RadioListTile<int>(
                      title: const Text('200,000 IU (12-59 months)'),
                      value: 200000,
                      groupValue: _dosageIU,
                      onChanged: (value) {
                        setState(() => _dosageIU = value!);
                      },
                      activeColor: Colors.orange[700],
                    ),
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
                backgroundColor: Colors.orange[700],
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
                  : const Text('Save Vitamin A Record'),
            ),
          ],
        ),
      ),
    );
  }
}