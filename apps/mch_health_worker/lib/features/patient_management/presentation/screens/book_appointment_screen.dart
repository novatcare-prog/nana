import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mch_core/mch_core.dart';
import 'package:intl/intl.dart';
import '../../../../core/providers/appointment_providers.dart';
import '../../../../core/providers/supabase_providers.dart';
import '../../../../core/providers/auth_providers.dart';

/// Book Appointment Screen
class BookAppointmentScreen extends ConsumerStatefulWidget {
  final DateTime? preselectedDate;
  final String? patientId;

  const BookAppointmentScreen({
    super.key,
    this.preselectedDate,
    this.patientId,
  });

  @override
  ConsumerState<BookAppointmentScreen> createState() =>
      _BookAppointmentScreenState();
}

class _BookAppointmentScreenState
    extends ConsumerState<BookAppointmentScreen> {
  final _formKey = GlobalKey<FormState>();
  
  String? _selectedPatientId;
  DateTime _selectedDate = DateTime.now();
  TimeOfDay _selectedTime = TimeOfDay.now();
  AppointmentType _selectedType = AppointmentType.ancVisit;
  final _notesController = TextEditingController();
  
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _selectedPatientId = widget.patientId;
    if (widget.preselectedDate != null) {
      _selectedDate = widget.preselectedDate!;
    }
  }

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _selectDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    
    if (picked != null) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Future<void> _selectTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
    );
    
    if (picked != null) {
      setState(() {
        _selectedTime = picked;
      });
    }
  }

  Future<void> _bookAppointment() async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedPatientId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a patient')),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final profile = ref.read(currentUserProfileProvider).value;
      final patients = await ref.read(maternalProfilesProvider.future);
      final patient = patients.firstWhere((p) => p.id == _selectedPatientId);

      // Combine date and time
      final appointmentDateTime = DateTime(
        _selectedDate.year,
        _selectedDate.month,
        _selectedDate.day,
        _selectedTime.hour,
        _selectedTime.minute,
      );

      final appointment = Appointment(
        maternalProfileId: _selectedPatientId!,
        patientName: patient.clientName,
        appointmentDate: appointmentDateTime,
        appointmentType: _selectedType,
        notes: _notesController.text.trim().isEmpty 
            ? null 
            : _notesController.text.trim(),
        facilityId: profile!.facilityId!,
        facilityName: patient.facilityName,
        createdBy: profile.id,
        createdByName: profile.fullName,
      );

      final createAppointment = ref.read(createAppointmentProvider);
      await createAppointment(appointment);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('✓ Appointment booked successfully'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(context, true);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to book appointment: $e'),
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
    final patientsAsync = ref.watch(maternalProfilesProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Book Appointment'),
      ),
      body: patientsAsync.when(
        data: (patients) => Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              // Patient Selection
              Text(
                'Patient Information',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 16),
              
              DropdownButtonFormField<String>(
                value: _selectedPatientId,
                decoration: const InputDecoration(
                  labelText: 'Select Patient *',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.person),
                ),
                items: patients
                    .map((patient) => DropdownMenuItem(
                          value: patient.id,
                          child: Text(
                            '${patient.clientName} (${patient.ancNumber})',
                            overflow: TextOverflow.ellipsis,
                          ),
                        ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedPatientId = value;
                  });
                },
                validator: (value) => 
                    value == null ? 'Please select a patient' : null,
              ),
              
              const SizedBox(height: 24),
              
              // Appointment Details
              Text(
                'Appointment Details',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 16),
              
              // Date Selection
              ListTile(
                leading: const Icon(Icons.calendar_today),
                title: const Text('Date'),
                subtitle: Text(DateFormat('EEEE, MMM dd, yyyy').format(_selectedDate)),
                trailing: const Icon(Icons.edit),
                onTap: _selectDate,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                  side: BorderSide(color: Colors.grey.shade300),
                ),
              ),
              
              const SizedBox(height: 16),
              
              // Time Selection
              ListTile(
                leading: const Icon(Icons.access_time),
                title: const Text('Time'),
                subtitle: Text(_selectedTime.format(context)),
                trailing: const Icon(Icons.edit),
                onTap: _selectTime,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                  side: BorderSide(color: Colors.grey.shade300),
                ),
              ),
              
              const SizedBox(height: 16),
              
              // Appointment Type
              DropdownButtonFormField<AppointmentType>(
                value: _selectedType,
                decoration: const InputDecoration(
                  labelText: 'Appointment Type *',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.medical_services),
                ),
                items: AppointmentType.values
                    .map((type) => DropdownMenuItem(
                          value: type,
                          child: Text(_formatAppointmentType(type)),
                        ))
                    .toList(),
                onChanged: (value) {
                  if (value != null) {
                    setState(() {
                      _selectedType = value;
                    });
                  }
                },
              ),
              
              const SizedBox(height: 16),
              
              // Notes
              TextFormField(
                controller: _notesController,
                decoration: const InputDecoration(
                  labelText: 'Notes (Optional)',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.notes),
                  hintText: 'Add any special instructions or notes',
                ),
                maxLines: 3,
              ),
              
              const SizedBox(height: 32),
              
              // Book Button
              ElevatedButton(
                onPressed: _isLoading ? null : _bookAppointment,
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                ),
                child: _isLoading
                    ? const SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Text(
                        'Book Appointment',
                        style: TextStyle(fontSize: 16),
                      ),
              ),
            ],
          ),
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 64, color: Colors.red),
              const SizedBox(height: 16),
              Text('Error loading patients: $error'),
            ],
          ),
        ),
      ),
    );
  }

  String _formatAppointmentType(AppointmentType type) {
    switch (type) {
      case AppointmentType.ancVisit:
        return 'ANC Visit';
      case AppointmentType.pncVisit:
        return 'PNC Visit';
      case AppointmentType.labTest:
        return 'Lab Test';
      case AppointmentType.ultrasound:
        return 'Ultrasound';
      case AppointmentType.delivery:
        return 'Delivery';
      case AppointmentType.immunization:
        return 'Immunization';
      case AppointmentType.consultation:
        return 'Consultation';
      case AppointmentType.followUp:
        return 'Follow-up';
    }
  }
}