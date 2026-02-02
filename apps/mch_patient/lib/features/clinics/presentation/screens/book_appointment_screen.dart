import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../domain/models/clinic.dart';
import '../../domain/models/health_worker.dart';

class BookAppointmentScreen extends ConsumerStatefulWidget {
  final String clinicId;
  final String workerId;
  final Clinic? clinic;
  final HealthWorker? worker;

  const BookAppointmentScreen({
    super.key,
    required this.clinicId,
    required this.workerId,
    this.clinic,
    this.worker,
  });

  @override
  ConsumerState<BookAppointmentScreen> createState() =>
      _BookAppointmentScreenState();
}

class _BookAppointmentScreenState extends ConsumerState<BookAppointmentScreen> {
  DateTime _selectedDate = DateTime.now().add(const Duration(days: 1));
  String? _selectedTime;
  final TextEditingController _notesController = TextEditingController();
  bool _isLoading = false;

  List<String> _timeSlots = [];
  bool _checkingAvailability = false;
  String? _availabilityError;

  @override
  void initState() {
    super.initState();
    _checkAvailability();
  }

  Future<void> _checkAvailability() async {
    if (widget.worker == null) return;

    setState(() {
      _checkingAvailability = true;
      _availabilityError = null;
      _selectedTime = null;
      _timeSlots = [];
    });

    try {
      final weekday = _selectedDate.weekday; // 1=Mon, 7=Sun
      final supabase = Supabase.instance.client;

      final response = await supabase
          .from('health_worker_availability')
          .select()
          .eq('user_id', widget.worker!.id)
          .eq('day_of_week', weekday)
          .maybeSingle();

      if (response == null || response['is_available'] == false) {
        if (mounted) {
          setState(() {
            _availabilityError = 'booking.not_available'.tr();
            _checkingAvailability = false;
          });
        }
        return;
      }

      // Generate slots
      final startParts = (response['start_time'] as String).split(':');
      final endParts = (response['end_time'] as String).split(':');

      final startHour = int.parse(startParts[0]);
      final startMin = int.parse(startParts[1]);
      final endHour = int.parse(endParts[0]);
      final endMin = int.parse(endParts[1]);

      final slots = <String>[];
      var current = DateTime(2024, 1, 1, startHour, startMin);
      final end = DateTime(2024, 1, 1, endHour, endMin);

      while (current.isBefore(end)) {
        final hour = current.hour;
        final minute = current.minute.toString().padLeft(2, '0');
        final period = hour >= 12 ? 'PM' : 'AM';
        final displayHour = hour > 12 ? hour - 12 : (hour == 0 ? 12 : hour);

        slots.add('$displayHour:$minute $period');
        current = current.add(const Duration(minutes: 30));
      }

      if (mounted) {
        setState(() {
          _timeSlots = slots;
          _checkingAvailability = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _availabilityError = 'booking.could_not_check'.tr();
          _checkingAvailability = false;
        });
      }
    }
  }

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _submitBooking() async {
    if (_selectedTime == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('booking.please_select_time'.tr())),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final supabase = Supabase.instance.client;
      final user = supabase.auth.currentUser;

      if (user == null) {
        throw Exception('booking.must_be_logged_in'.tr());
      }

      // 1. Get Maternal Profile ID
      final profileResponse = await supabase
          .from('maternal_profiles')
          .select('id')
          .eq('auth_id', user.id)
          .maybeSingle();

      if (profileResponse == null) {
        throw Exception('booking.complete_profile'.tr());
      }

      final maternalProfileId = profileResponse['id'] as String;

      // 2. Parse Date & Time
      // _selectedTime is string like "9:30 AM" or "09:30 AM"
      // Date is _selectedDate
      final timeParts = _selectedTime!.split(' '); // ["09:30", "AM"]
      final hm = timeParts[0].split(':');
      int hour = int.parse(hm[0]);
      final minute = int.parse(hm[1]);
      final isPm = timeParts[1] == 'PM';

      if (isPm && hour != 12) hour += 12;
      if (!isPm && hour == 12) hour = 0;

      final appointmentDateTime = DateTime(
        _selectedDate.year,
        _selectedDate.month,
        _selectedDate.day,
        hour,
        minute,
      );

      // 3. Create Appointment
      // Note: 'appointments' table schema is assumed to match standard mch_core models
      // If facilityId is empty on worker, fallback to clinic ID passed to widget
      final facilityId = widget.worker?.facilityId.isEmpty == true
          ? widget.clinicId
          : widget.worker!.facilityId;

      await supabase.from('appointments').insert({
        'maternal_profile_id': maternalProfileId,
        'facility_id': facilityId,
        'facility_name':
            widget.clinic?.name ?? 'Health Facility', // Required field
        'health_worker_id': widget.worker?.id,
        'appointment_date': appointmentDateTime.toIso8601String(),
        'appointment_status': 'scheduled',
        'appointment_type': 'consultation',
        'patient_name': user.userMetadata?['full_name'] ?? 'Patient',
        'notes': _notesController.text,
        'created_by': user.id, // Required field
      });

      // 4. Create Notification for Patient
      await supabase.from('notifications').insert({
        'user_id': user.id,
        'title': 'booking.appointment_booked'.tr(),
        'body':
            'Your appointment with ${widget.worker?.name ?? "Health Worker"} is confirmed for $_selectedTime on ${_selectedDate.toString().split(" ")[0]}.',
        'type': 'appointment_booked',
        'is_read': false,
      });

      // 5. Create Notification for Health Worker
      if (widget.worker != null) {
        await supabase.from('notifications').insert({
          'user_id': widget.worker!
              .id, // Ensure HealthWorker model has the AUTH USER ID, not just a uuid
          'title': 'New Appointment',
          'body':
              'You have a new appointment with ${user.userMetadata?['full_name'] ?? "a patient"} at $_selectedTime on ${_selectedDate.toString().split(" ")[0]}.',
          'type': 'appointment_booked',
          'is_read': false,
        });
      }

      if (mounted) {
        setState(() => _isLoading = false);

        // Show Success Dialog
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => AlertDialog(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            title: Column(
              children: [
                const Icon(Icons.check_circle, color: Colors.green, size: 60),
                const SizedBox(height: 16),
                Text('booking.appointment_booked'.tr(), textAlign: TextAlign.center),
              ],
            ),
            content: Text(
              'booking.booking_success'.tr(),
              textAlign: TextAlign.center,
            ),
            actions: [
              TextButton(
                onPressed: () {
                  context.go('/appointments'); // Navigate to appointments list
                },
                child: Text('booking.view_appointments'.tr()),
              ),
              TextButton(
                onPressed: () {
                  context.go('/home');
                },
                child: Text('booking.go_home'.tr()),
              ),
            ],
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(
                  '${\'booking.error_booking\'.tr()}: ${e.toString().replaceAll("Exception: ", "")}')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('booking.title'.tr()),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Summary Card
            Card(
              elevation: 0,
              color: const Color(0xFFE91E63).withOpacity(0.05),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side:
                    BorderSide(color: const Color(0xFFE91E63).withOpacity(0.1)),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    if (widget.worker != null)
                      _buildSummaryRow(Icons.person, widget.worker!.name),
                    const SizedBox(height: 8),
                    if (widget.worker != null)
                      Padding(
                        padding: const EdgeInsets.only(left: 32),
                        child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(widget.worker!.role,
                                style: TextStyle(
                                    color: Colors.grey[600], fontSize: 13))),
                      ),
                    const SizedBox(height: 12),
                    if (widget.clinic != null)
                      _buildSummaryRow(
                          Icons.local_hospital, widget.clinic!.name),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),
            Text('booking.select_date'.tr(),
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 12),
            CalendarDatePicker(
              initialDate: _selectedDate,
              firstDate: DateTime.now(),
              lastDate: DateTime.now().add(const Duration(days: 90)),
              onDateChanged: (date) {
                setState(() {
                  _selectedDate = date;
                  _selectedTime = null; // Reset time on date change
                });
                _checkAvailability();
              },
            ),

            const SizedBox(height: 24),
            Row(
              children: [
                Text('booking.available_time_slots'.tr(),
                    style:
                        const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                if (_checkingAvailability) ...[
                  const SizedBox(width: 12),
                  const SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                ],
              ],
            ),
            const SizedBox(height: 12),

            if (_availabilityError != null)
              Container(
                padding: const EdgeInsets.all(12),
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.orange[50],
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.orange[200]!),
                ),
                child: Text(
                  _availabilityError!,
                  style: TextStyle(color: Colors.orange[800]),
                  textAlign: TextAlign.center,
                ),
              )
            else if (_timeSlots.isEmpty && !_checkingAvailability)
              Container(
                padding: const EdgeInsets.all(12),
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.grey[50],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  'booking.no_slots'.tr(),
                  style: const TextStyle(color: Colors.grey),
                  textAlign: TextAlign.center,
                ),
              )
            else
              Wrap(
                spacing: 12,
                runSpacing: 12,
                children: _timeSlots.map((time) {
                  final isSelected = _selectedTime == time;
                  return ChoiceChip(
                    label: Text(time),
                    selected: isSelected,
                    onSelected: (selected) {
                      setState(() {
                        _selectedTime = selected ? time : null;
                      });
                    },
                    selectedColor: const Color(0xFFE91E63),
                    labelStyle: TextStyle(
                      color: isSelected ? Colors.white : Colors.black,
                      fontWeight:
                          isSelected ? FontWeight.bold : FontWeight.normal,
                    ),
                  );
                }).toList(),
              ),

            const SizedBox(height: 24),
            Text('booking.reason_for_visit'.tr(),
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 12),
            TextField(
              controller: _notesController,
              decoration: InputDecoration(
                hintText: 'booking.reason_hint'.tr(),
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                filled: true,
                fillColor: Colors.grey[50],
              ),
              maxLines: 3,
            ),

            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _submitBooking,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFE91E63),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
                child: _isLoading
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                            color: Colors.white, strokeWidth: 2))
                    : Text('booking.confirm_appointment'.tr(),
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold)),
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, color: const Color(0xFFE91E63), size: 20),
        const SizedBox(width: 12),
        Expanded(
            child: Text(text,
                style: const TextStyle(
                    fontWeight: FontWeight.bold, fontSize: 15))),
      ],
    );
  }
}
