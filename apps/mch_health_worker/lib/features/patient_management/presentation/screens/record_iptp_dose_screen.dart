
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mch_core/mch_core.dart';
import 'package:intl/intl.dart';
import '../../../../core/providers/immunization_malaria_providers.dart';
import '../../../../core/providers/auth_providers.dart';

// Record IPTp Dose Screen
class RecordIPTpDoseScreen extends ConsumerStatefulWidget {
  final String patientId;
  final MaternalProfile patient;

  const RecordIPTpDoseScreen({
    super.key,
    required this.patientId,
    required this.patient,
  });

  @override
  ConsumerState<RecordIPTpDoseScreen> createState() => _RecordIPTpDoseScreenState();
}

class _RecordIPTpDoseScreenState extends ConsumerState<RecordIPTpDoseScreen> {
  final _formKey = GlobalKey<FormState>();
  int _spDose = 1;
  DateTime _doseDate = DateTime.now();
  final _gestationWeeksController = TextEditingController();
  bool _itnGiven = false;
  final _notesController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _gestationWeeksController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _saveIPTpDose() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final profile = ref.read(currentUserProfileProvider).value;
      
      final record = MalariaPreventionRecord(
        maternalProfileId: widget.patientId,
        patientName: widget.patient.clientName,
        spDose: _spDose,
        doseDate: _doseDate,
        gestationWeeks: _gestationWeeksController.text.isEmpty
            ? null
            : int.tryParse(_gestationWeeksController.text),
        itnGiven: _itnGiven,
        itnDate: _itnGiven ? _doseDate : null,
        notes: _notesController.text.trim().isEmpty
            ? null
            : _notesController.text.trim(),
        facilityId: profile!.facilityId!,
        facilityName: widget.patient.facilityName,
        administeredBy: profile.id,
        administeredByName: profile.fullName,
      );

      final createRecord = ref.read(createMalariaRecordProvider);
      await createRecord(record);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('✓ IPTp dose recorded successfully'),
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
      appBar: AppBar(title: const Text('Record IPTp Dose')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            DropdownButtonFormField<int>(
              value: _spDose,
              decoration: const InputDecoration(
                labelText: 'SP Dose *',
                border: OutlineInputBorder(),
              ),
              items: List.generate(5, (i) => i + 1)
                  .map((dose) => DropdownMenuItem(
                        value: dose,
                        child: Text('Dose $dose'),
                      ))
                  .toList(),
              onChanged: (value) => setState(() => _spDose = value!),
            ),
            const SizedBox(height: 16),
            ListTile(
              title: const Text('Dose Date'),
              subtitle: Text(DateFormat('MMM dd, yyyy').format(_doseDate)),
              trailing: const Icon(Icons.edit),
              onTap: () async {
                final picked = await showDatePicker(
                  context: context,
                  initialDate: _doseDate,
                  firstDate: DateTime.now().subtract(const Duration(days: 365)),
                  lastDate: DateTime.now(),
                );
                if (picked != null) setState(() => _doseDate = picked);
              },
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
                side: BorderSide(color: Colors.grey.shade300),
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _gestationWeeksController,
              decoration: const InputDecoration(
                labelText: 'Gestation (weeks)',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 16),
            CheckboxListTile(
              title: const Text('ITN (Insecticide Treated Net) Provided'),
              value: _itnGiven,
              onChanged: (value) => setState(() => _itnGiven = value!),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
                side: BorderSide(color: Colors.grey.shade300),
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _notesController,
              decoration: const InputDecoration(
                labelText: 'Notes',
                border: OutlineInputBorder(),
              ),
              maxLines: 2,
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: _isLoading ? null : _saveIPTpDose,
              style: ElevatedButton.styleFrom(minimumSize: const Size(double.infinity, 50)),
              child: _isLoading
                  ? const CircularProgressIndicator()
                  : const Text('Save IPTp Dose'),
            ),
          ],
        ),
      ),
    );
  }
}
































