import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mch_core/mch_core.dart';
import 'package:intl/intl.dart';
import '../../../../core/providers/immunization_malaria_providers.dart';
import '../../../../core/providers/auth_providers.dart';

/// Record TT Dose Screen
class RecordTTDoseScreen extends ConsumerStatefulWidget {
  final String patientId;
  final MaternalProfile patient;

  const RecordTTDoseScreen({
    super.key,
    required this.patientId,
    required this.patient,
  });

  @override
  ConsumerState<RecordTTDoseScreen> createState() => _RecordTTDoseScreenState();
}

class _RecordTTDoseScreenState extends ConsumerState<RecordTTDoseScreen> {
  final _formKey = GlobalKey<FormState>();
  int _ttDose = 1;
  DateTime _doseDate = DateTime.now();
  final _batchNumberController = TextEditingController();
  final _notesController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _batchNumberController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _saveTTDose() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final profile = ref.read(currentUserProfileProvider).value;
      
      final immunization = MaternalImmunization(
        maternalProfileId: widget.patientId,
        patientName: widget.patient.clientName,
        ttDose: _ttDose,
        doseDate: _doseDate,
        nextDoseDue: _calculateNextDose(_ttDose, _doseDate),
        batchNumber: _batchNumberController.text.trim().isEmpty
            ? null
            : _batchNumberController.text.trim(),
        notes: _notesController.text.trim().isEmpty
            ? null
            : _notesController.text.trim(),
        facilityId: profile!.facilityId!,
        facilityName: widget.patient.facilityName,
        administeredBy: profile.id,
        administeredByName: profile.fullName,
      );

      final createImm = ref.read(createImmunizationProvider);
      await createImm(immunization);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('✓ TT dose recorded successfully'),
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

  DateTime? _calculateNextDose(int dose, DateTime currentDate) {
    switch (dose) {
      case 1:
        return currentDate.add(const Duration(days: 28)); // 4 weeks
      case 2:
        return currentDate.add(const Duration(days: 180)); // 6 months
      case 3:
        return currentDate.add(const Duration(days: 365)); // 1 year
      case 4:
        return currentDate.add(const Duration(days: 365)); // 1 year
      default:
        return null; // TT5 and TT+ provide lifetime protection
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Record TT Dose')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            DropdownButtonFormField<int>(
              value: _ttDose,
              decoration: const InputDecoration(
                labelText: 'TT Dose *',
                border: OutlineInputBorder(),
              ),
              items: List.generate(6, (i) => i + 1)
                  .map((dose) => DropdownMenuItem(
                        value: dose,
                        child: Text('TT$dose'),
                      ))
                  .toList(),
              onChanged: (value) => setState(() => _ttDose = value!),
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
              controller: _batchNumberController,
              decoration: const InputDecoration(
                labelText: 'Batch Number',
                border: OutlineInputBorder(),
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
              onPressed: _isLoading ? null : _saveTTDose,
              style: ElevatedButton.styleFrom(minimumSize: const Size(double.infinity, 50)),
              child: _isLoading
                  ? const CircularProgressIndicator()
                  : const Text('Save TT Dose'),
            ),
          ],
        ),
      ),
    );
  }
}