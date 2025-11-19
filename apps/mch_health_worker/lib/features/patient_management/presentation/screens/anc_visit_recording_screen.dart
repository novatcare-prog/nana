import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mch_core/mch_core.dart';
// Import the central provider file
import '../../../../core/providers/supabase_providers.dart';

/// ANC Visit Recording Screen - Based on MOH MCH Handbook Page 8
class ANCVisitRecordingScreen extends ConsumerStatefulWidget {
  final String patientId;
  final MaternalProfile patient;

  const ANCVisitRecordingScreen({
    super.key,
    required this.patientId,
    required this.patient,
  });

  @override
  ConsumerState<ANCVisitRecordingScreen> createState() => _ANCVisitRecordingScreenState();
}

class _ANCVisitRecordingScreenState extends ConsumerState<ANCVisitRecordingScreen> {
  final _formKey = GlobalKey<FormState>();
  int _currentStep = 0;
  bool _isSubmitting = false;

  // Visit Information
  int? _contactNumber;
  DateTime _visitDate = DateTime.now();
  int? _gestationWeeks;

  // Vital Signs Controllers
  final _weightController = TextEditingController();
  final _bloodPressureController = TextEditingController();
  final _muacController = TextEditingController();
  final _haemoglobinController = TextEditingController();
  bool _pallor = false;

  // Physical Examination Controllers
  final _fundalHeightController = TextEditingController();
  String? _presentation;
  String? _lie;
  final _foetalHeartRateController = TextEditingController();
  bool _foetalMovement = false;

  // Urine Test
  String? _urineProtein;
  String? _urineGlucose;

  // Preventive Services
  bool _tdInjectionGiven = false;
  bool _iptpSpGiven = false;
  final _ifasTabletsController = TextEditingController();
  bool _lllinGiven = false;
  bool _dewormingGiven = false;

  // Lab Tests
  bool _hbTested = false;
  bool _hivTested = false;
  String? _hivResult;
  bool _syphilisTested = false;
  String? _syphilisResult;

  // Clinical Notes
  final _complaintsController = TextEditingController();
  final _diagnosisController = TextEditingController();
  final _treatmentController = TextEditingController();
  final _notesController = TextEditingController();

  // Next Visit
  DateTime? _nextVisitDate;
  final _healthWorkerNameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _calculateGestationWeeks();
    _loadNextContactNumber();
  }

  void _calculateGestationWeeks() {
    // FIX: Handle null LMP by using visit date as fallback to prevent crash
    final lmpDate = widget.patient.lmp ?? _visitDate;
    final daysSinceLMP = _visitDate.difference(lmpDate).inDays;
    setState(() {
      _gestationWeeks = (daysSinceLMP / 7).floor();
    });
  }

  Future<void> _loadNextContactNumber() async {
    final nextContact = await ref.read(nextContactNumberProvider(widget.patientId).future);
    if (mounted) {
      setState(() {
        _contactNumber = nextContact;
      });
    }
  }

  @override
  void dispose() {
    _weightController.dispose();
    _bloodPressureController.dispose();
    _muacController.dispose();
    _haemoglobinController.dispose();
    _fundalHeightController.dispose();
    _foetalHeartRateController.dispose();
    _ifasTabletsController.dispose();
    _complaintsController.dispose();
    _diagnosisController.dispose();
    _treatmentController.dispose();
    _notesController.dispose();
    _healthWorkerNameController.dispose();
    super.dispose();
  }
  Future<void> _handleSubmit() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isSubmitting = true;
      });

      try {
        // --- 1. RISK CALCULATION (MCH Handbook Aligned) ---
        bool isHighBP = false;
        if (_bloodPressureController.text.contains('/')) {
          final parts = _bloodPressureController.text.split('/');
          if (parts.length == 2) {
            final int sys = int.tryParse(parts[0].trim()) ?? 0;
            final int dia = int.tryParse(parts[1].trim()) ?? 0;
            // Check for High BP (>= 140/90)
            if (sys >= 140 || dia >= 90) {
              isHighBP = true;
            }
          }
        }

        // Check for Low Hemoglobin (< 11.0)
        final bool isLowHB = (_haemoglobinController.text.isNotEmpty &&
            (double.tryParse(_haemoglobinController.text) ?? 12) < 11);

        // Check for Proteinuria
        final bool hasProtein = _urineProtein != null && _urineProtein != 'Negative';
        
        final bool currentVisitIsHighRisk = isHighBP || isLowHB || hasProtein;
        // --- END OF RISK CALCULATION ---

        final visit = ANCVisit(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          maternalProfileId: widget.patientId,
          contactNumber: _contactNumber!,
          visitDate: _visitDate,
          gestationWeeks: _gestationWeeks!,
          
          isHighRisk: currentVisitIsHighRisk,

          weightKg: _weightController.text.isEmpty ? null : double.parse(_weightController.text),
          bloodPressure: _bloodPressureController.text.isEmpty ? null : _bloodPressureController.text,
          muacCm: _muacController.text.isEmpty ? null : double.parse(_muacController.text),
          haemoglobin: _haemoglobinController.text.isEmpty ? null : double.parse(_haemoglobinController.text),
          pallor: _pallor,
          fundalHeight: _fundalHeightController.text.isEmpty ? null : double.parse(_fundalHeightController.text),
          presentation: _presentation,
          lie: _lie,
          foetalHeartRate: _foetalHeartRateController.text.isEmpty ? null : int.parse(_foetalHeartRateController.text),
          foetalMovement: _foetalMovement,
          urineProtein: _urineProtein,
          urineGlucose: _urineGlucose,
          tdInjectionGiven: _tdInjectionGiven,
          iptpSpGiven: _iptpSpGiven,
          ifasTabletsGiven: _ifasTabletsController.text.isEmpty ? null : int.parse(_ifasTabletsController.text),
          lllinGiven: _lllinGiven,
          dewormingGiven: _dewormingGiven,
          hbTested: _hbTested,
          hivTested: _hivTested,
          hivResult: _hivResult,
          syphilisTested: _syphilisTested,
          syphilisResult: _syphilisResult,
          complaints: _complaintsController.text.isEmpty ? null : _complaintsController.text,
          diagnosis: _diagnosisController.text.isEmpty ? null : _diagnosisController.text,
          treatment: _treatmentController.text.isEmpty ? null : _treatmentController.text,
          notes: _notesController.text.isEmpty ? null : _notesController.text,
          nextVisitDate: _nextVisitDate,
          healthWorkerName: _healthWorkerNameController.text.isEmpty ? null : _healthWorkerNameController.text,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        );

        // --- 2. CALL THE CENTRAL PROVIDER ---
        await ref.read(createVisitProvider)(visit, currentVisitIsHighRisk);

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('✅ ANC visit recorded successfully!'),
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
    final nextContactAsync = ref.watch(nextContactNumberProvider(widget.patientId));

    return Scaffold(
      appBar: AppBar(
        title: Text('ANC Visit - ${widget.patient.clientName}'),
      ),
      body: Form(
        key: _formKey,
        child: Stepper(
          currentStep: _currentStep,
          onStepContinue: () {
            if (_currentStep < 4) {
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
                        : Text(_currentStep == 4 ? 'Submit' : 'Continue'),
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
            // Step 1: Visit Information
            Step(
              title: const Text('Visit Information'),
              content: Column(
                children: [
                  nextContactAsync.when(
                    data: (contact) {
                      _contactNumber = contact;
                      return ListTile(
                        title: const Text('Contact Number'),
                        subtitle: Text('Contact $contact of 8'),
                        tileColor: Colors.blue[50],
                      );
                    },
                    loading: () => ListTile(
                      title: const Text('Contact Number'),
                      subtitle: const Text('Loading...'),
                      tileColor: Colors.grey[50],
                    ),
                    error: (e, s) => ListTile(
                      title: Text('Error', style: TextStyle(color: Colors.red[700])),
                      subtitle: Text('$e'),
                      tileColor: Colors.red[50],
                    ),
                  ),
                  const SizedBox(height: 16),
                  ListTile(
                    title: const Text('Visit Date'),
                    subtitle: Text(_visitDate.toString().split(' ')[0]),
                    trailing: const Icon(Icons.calendar_today),
                    onTap: () async {
                      // FIX: Safe fallback for null LMP
                      final firstDate = widget.patient.lmp ?? DateTime.now().subtract(const Duration(days: 300));
                      final date = await showDatePicker(
                        context: context,
                        initialDate: _visitDate,
                        firstDate: firstDate,
                        lastDate: DateTime.now(),
                      );
                      if (date != null) {
                        setState(() {
                          _visitDate = date;
                          _calculateGestationWeeks();
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
                    title: const Text('Gestation'),
                    subtitle: Text(_gestationWeeks != null ? '$_gestationWeeks weeks' : 'Calculating...'),
                    tileColor: Colors.grey[100],
                  ),
                ],
              ),
              isActive: _currentStep >= 0,
            ),

            // Step 2: Vital Signs & Physical Exam
            Step(
              title: const Text('Vital Signs & Examination'),
              content: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Vital Signs:', style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Row(
                    children: [
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
                      const SizedBox(width: 12),
                      Expanded(
                        child: TextFormField(
                          controller: _bloodPressureController,
                          decoration: const InputDecoration(
                            labelText: 'BP (e.g. 120/80)',
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: _muacController,
                          decoration: const InputDecoration(
                            labelText: 'MUAC (cm)',
                            border: OutlineInputBorder(),
                          ),
                          keyboardType: TextInputType.number,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: TextFormField(
                          controller: _haemoglobinController,
                          decoration: const InputDecoration(
                            labelText: 'Haemoglobin (g/dL)',
                            border: OutlineInputBorder(),
                          ),
                          keyboardType: TextInputType.number,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  CheckboxListTile(
                    title: const Text('Pallor'),
                    value: _pallor,
                    onChanged: (value) => setState(() => _pallor = value ?? false),
                  ),
                  const SizedBox(height: 16),
                  const Text('Physical Examination:', style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _fundalHeightController,
                    decoration: const InputDecoration(
                      labelText: 'Fundal Height (cm)',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<String>(
                    value: _presentation,
                    decoration: const InputDecoration(
                      labelText: 'Presentation',
                      border: OutlineInputBorder(),
                    ),
                    items: const [
                      DropdownMenuItem(value: 'Cephalic', child: Text('Cephalic')),
                      DropdownMenuItem(value: 'Breech', child: Text('Breech')),
                      DropdownMenuItem(value: 'Transverse', child: Text('Transverse')),
                    ],
                    onChanged: (value) => setState(() => _presentation = value),
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<String>(
                    value: _lie,
                    decoration: const InputDecoration(
                      labelText: 'Lie',
                      border: OutlineInputBorder(),
                    ),
                    items: const [
                      DropdownMenuItem(value: 'Longitudinal', child: Text('Longitudinal')),
                      DropdownMenuItem(value: 'Transverse', child: Text('Transverse')),
                      DropdownMenuItem(value: 'Oblique', child: Text('Oblique')),
                    ],
                    onChanged: (value) => setState(() => _lie = value),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _foetalHeartRateController,
                    decoration: const InputDecoration(
                      labelText: 'Foetal Heart Rate (bpm)',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                  ),
                  CheckboxListTile(
                    title: const Text('Foetal Movement'),
                    value: _foetalMovement,
                    onChanged: (value) => setState(() => _foetalMovement = value ?? false),
                  ),
                ],
              ),
              isActive: _currentStep >= 1,
            ),

            // Step 3: Urine Test & Lab Tests
            Step(
              title: const Text('Urine & Lab Tests'),
              content: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Urine Test:', style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  DropdownButtonFormField<String>(
                    value: _urineProtein,
                    decoration: const InputDecoration(
                      labelText: 'Urine Protein',
                      border: OutlineInputBorder(),
                    ),
                    items: const [
                      DropdownMenuItem(value: 'Negative', child: Text('Negative')),
                      DropdownMenuItem(value: 'Trace', child: Text('Trace')),
                      DropdownMenuItem(value: '+', child: Text('+')),
                      DropdownMenuItem(value: '++', child: Text('++')),
                      DropdownMenuItem(value: '+++', child: Text('+++')),
                    ],
                    onChanged: (value) => setState(() => _urineProtein = value),
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<String>(
                    value: _urineGlucose,
                    decoration: const InputDecoration(
                      labelText: 'Urine Glucose',
                      border: OutlineInputBorder(),
                    ),
                    items: const [
                      DropdownMenuItem(value: 'Negative', child: Text('Negative')),
                      DropdownMenuItem(value: 'Trace', child: Text('Trace')),
                      DropdownMenuItem(value: '+', child: Text('+')),
                      DropdownMenuItem(value: '++', child: Text('++')),
                      DropdownMenuItem(value: '+++', child: Text('+++')),
                    ],
                    onChanged: (value) => setState(() => _urineGlucose = value),
                  ),
                  const SizedBox(height: 16),
                  const Divider(),
                  const SizedBox(height: 8),
                  const Text('Lab Tests:', style: TextStyle(fontWeight: FontWeight.bold)),
                  CheckboxListTile(
                    title: const Text('Haemoglobin Tested'),
                    value: _hbTested,
                    onChanged: (value) => setState(() => _hbTested = value ?? false),
                  ),
                  CheckboxListTile(
                    title: const Text('HIV Tested'),
                    value: _hivTested,
                    onChanged: (value) => setState(() => _hivTested = value ?? false),
                  ),
                  if (_hivTested)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: DropdownButtonFormField<String>(
                        value: _hivResult,
                        decoration: const InputDecoration(
                          labelText: 'HIV Result',
                          border: OutlineInputBorder(),
                        ),
                        items: const [
                          DropdownMenuItem(value: 'Negative', child: Text('Negative')),
                          DropdownMenuItem(value: 'Positive', child: Text('Positive')),
                        ],
                        onChanged: (value) => setState(() => _hivResult = value),
                      ),
                    ),
                  const SizedBox(height: 8),
                  CheckboxListTile(
                    title: const Text('Syphilis Tested'),
                    value: _syphilisTested,
                    onChanged: (value) => setState(() => _syphilisTested = value ?? false),
                  ),
                  if (_syphilisTested)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: DropdownButtonFormField<String>(
                        value: _syphilisResult,
                        decoration: const InputDecoration(
                          labelText: 'Syphilis Result',
                          border: OutlineInputBorder(),
                        ),
                        items: const [
                          DropdownMenuItem(value: 'Negative', child: Text('Negative')),
                          DropdownMenuItem(value: 'Positive', child: Text('Positive')),
                        ],
                        onChanged: (value) => setState(() => _syphilisResult = value),
                      ),
                    ),
                ],
              ),
              isActive: _currentStep >= 2,
            ),

            // Step 4: Preventive Services
            Step(
              title: const Text('Preventive Services'),
              content: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Services Given:', style: TextStyle(fontWeight: FontWeight.bold)),
                  CheckboxListTile(
                    title: const Text('TD Injection'),
                    value: _tdInjectionGiven,
                    onChanged: (value) => setState(() => _tdInjectionGiven = value ?? false),
                  ),
                  CheckboxListTile(
                    title: const Text('IPTp-SP (Malaria)'),
                    value: _iptpSpGiven,
                    onChanged: (value) => setState(() => _iptpSpGiven = value ?? false),
                  ),
                  CheckboxListTile(
                    title: const Text('LLIN (Mosquito Net)'),
                    value: _lllinGiven,
                    onChanged: (value) => setState(() => _lllinGiven = value ?? false),
                  ),
                  CheckboxListTile(
                    title: const Text('Deworming'),
                    value: _dewormingGiven,
                    onChanged: (value) => setState(() => _dewormingGiven = value ?? false),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _ifasTabletsController,
                    decoration: const InputDecoration(
                      labelText: 'IFAS Tablets Given (count)',
                      border: OutlineInputBorder(),
                      helperText: 'Iron/Folic Acid Supplement',
                    ),
                    keyboardType: TextInputType.number,
                  ),
                ],
              ),
              isActive: _currentStep >= 3,
            ),

            // Step 5: Clinical Notes & Next Visit
            Step(
              title: const Text('Clinical Notes'),
              content: Column(
                children: [
                  TextFormField(
                    controller: _complaintsController,
                    decoration: const InputDecoration(
                      labelText: 'Complaints',
                      border: OutlineInputBorder(),
                    ),
                    maxLines: 2,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _diagnosisController,
                    decoration: const InputDecoration(
                      labelText: 'Diagnosis',
                      border: OutlineInputBorder(),
                    ),
                    maxLines: 2,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _treatmentController,
                    decoration: const InputDecoration(
                      labelText: 'Treatment',
                      border: OutlineInputBorder(),
                    ),
                    maxLines: 2,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _notesController,
                    decoration: const InputDecoration(
                      labelText: 'Additional Notes',
                      border: OutlineInputBorder(),
                    ),
                    maxLines: 3,
                  ),
                  const SizedBox(height: 24),
                  const Divider(),
                  const SizedBox(height: 16),
                  ListTile(
                    title: const Text('Next Visit Date'),
                    subtitle: Text(
                      _nextVisitDate != null
                          ? _nextVisitDate.toString().split(' ')[0]
                          : 'Not set',
                    ),
                    trailing: const Icon(Icons.calendar_today),
                    onTap: () async {
                      // FIX: Safe fallback for null EDD
                      final lastDate = widget.patient.edd ?? DateTime.now().add(const Duration(days: 300));
                      final date = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now().add(const Duration(days: 28)),
                        firstDate: DateTime.now(),
                        lastDate: lastDate,
                      );
                      if (date != null) {
                        setState(() {
                          _nextVisitDate = date;
                        });
                      }
                    },
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                      side: const BorderSide(color: Colors.grey),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _healthWorkerNameController,
                    decoration: const InputDecoration(
                      labelText: 'Health Worker Name',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ],
              ),
              isActive: _currentStep >= 4,
            ),
          ],
        ),
      ),
    );
  }
}