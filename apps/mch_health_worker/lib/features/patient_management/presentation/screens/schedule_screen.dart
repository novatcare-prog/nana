import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mch_core/mch_core.dart';
import 'package:intl/intl.dart';
import '../../../../core/providers/appointment_providers.dart';
import 'book_appointment_screen.dart';

/// Schedule Screen with Responsive Calendar View
class ScheduleScreen extends ConsumerStatefulWidget {
  final Widget? drawer;

  const ScheduleScreen({super.key, this.drawer});

  @override
  ConsumerState<ScheduleScreen> createState() => _ScheduleScreenState();
}

class _ScheduleScreenState extends ConsumerState<ScheduleScreen> {
  DateTime _selectedDate = DateTime.now();
  DateTime _focusedMonth = DateTime.now();

  @override
  Widget build(BuildContext context) {
    final appointmentsAsync = ref.watch(monthAppointmentsProvider(_focusedMonth));
    final isDesktop = MediaQuery.of(context).size.width >= 900;

    return Scaffold(
      drawer: widget.drawer,
      appBar: AppBar(
        automaticallyImplyLeading: false, 
        leading: isDesktop
            ? null
            : Builder(
                builder: (context) => GestureDetector(
                  onTap: () {
                    Scaffold.of(context).openDrawer();
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: CircleAvatar(
                      backgroundColor: Colors.teal,
                      child: const Text(
                        "T",
                        style: TextStyle(
                          color: Colors.white, 
                          fontWeight: FontWeight.bold
                        ),
                      ),
                    ),
                  ),
                ),
              ),
        
        title: const Text('Schedule'),
        
        actions: [
          // Notification Bell
          Stack(
            alignment: Alignment.center,
            children: [
              IconButton(
                icon: const Icon(Icons.notifications_outlined),
                onPressed: () {
                  // TODO: Navigate to notifications screen
                },
              ),
              Positioned(
                top: 12,
                right: 12,
                child: Container(
                  padding: const EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  constraints: const BoxConstraints(
                    minWidth: 12,
                    minHeight: 12,
                  ),
                  child: const Text(
                    '3',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 8,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              )
            ],
          ),

          // Today Button
          IconButton(
            icon: const Icon(Icons.today),
            onPressed: () {
              setState(() {
                _selectedDate = DateTime.now();
                _focusedMonth = DateTime.now();
              });
            },
            tooltip: 'Go to Today',
          ),
        ],
      ),
      body: appointmentsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 64, color: Colors.red),
              const SizedBox(height: 16),
              Text('Error loading appointments: $error'),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => ref.invalidate(monthAppointmentsProvider),
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
        data: (appointments) => LayoutBuilder(
          builder: (context, constraints) {
            // DESKTOP LAYOUT
            if (constraints.maxWidth >= 900) {
              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // LEFT SIDE: Calendar + Month Summary
                  Expanded(
                    flex: 4,
                    child: ScrollConfiguration(
                      behavior: ScrollConfiguration.of(context).copyWith(scrollbars: false),
                      child: SingleChildScrollView(
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            children: [
                              _buildCalendar(appointments),
                              const SizedBox(height: 16),
                              _buildCalendarLegend(appointments),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  // RIGHT SIDE: Header + List
                  Expanded(
                    flex: 6,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Desktop Header
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Appointments",
                                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    DateFormat('EEEE, MMMM d, yyyy').format(_selectedDate),
                                    style: TextStyle(
                                      color: Colors.grey[600],
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                              FilledButton.icon(
                                onPressed: () => _navigateToBookAppointment(),
                                icon: const Icon(Icons.add),
                                label: const Text("New Appointment"),
                              ),
                            ],
                          ),
                          
                          const SizedBox(height: 24),
                          const Divider(),
                          
                          // Appointment List
                          Expanded(
                            child: _buildAppointmentsList(appointments),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            }
            // MOBILE LAYOUT
            else {
              return Column(
                children: [
                  _buildCalendar(appointments),
                  const Divider(height: 1),
                  Expanded(
                    child: _buildAppointmentsList(appointments),
                  ),
                ],
              );
            }
          },
        ),
      ),
      floatingActionButton: isDesktop
          ? null
          : FloatingActionButton.extended(
              onPressed: () => _navigateToBookAppointment(),
              icon: const Icon(Icons.add),
              label: const Text('New Appointment'),
            ),
    );
  }

  void _navigateToBookAppointment() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => BookAppointmentScreen(
          preselectedDate: _selectedDate,
        ),
      ),
    );
  }

  Widget _buildCalendarLegend(List<Appointment> appointments) {
    final total = appointments.length;
    final completed = appointments.where((a) => a.appointmentStatus == AppointmentStatus.completed).length;
    final pending = total - completed;

    return Card(
      margin: const EdgeInsets.all(8),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Month Summary",
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.blueGrey[800]),
            ),
            const SizedBox(height: 16),

            // Statistics
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStatItem("Total", "$total", Colors.blue),
                _buildStatItem("Done", "$completed", Colors.green),
                _buildStatItem("Pending", "$pending", Colors.orange),
              ],
            ),

            const Divider(height: 32),

            Text(
              "Status Key",
              style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.blueGrey[800]),
            ),
            const SizedBox(height: 12),

            // Legend
            Wrap(
              spacing: 16,
              runSpacing: 8,
              children: [
                _buildLegendItem("Scheduled", Colors.blue),
                _buildLegendItem("Completed", Colors.green),
                _buildLegendItem("Missed", Colors.red),
                _buildLegendItem("Cancelled", Colors.grey),
                _buildLegendItem("Rescheduled", Colors.orange),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(String label, String value, Color color) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: color),
        ),
        Text(
          label,
          style: TextStyle(fontSize: 12, color: Colors.grey[600]),
        ),
      ],
    );
  }

  Widget _buildLegendItem(String label, Color color) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 6),
        Text(
          label,
          style: TextStyle(fontSize: 12, color: Colors.grey[700]),
        ),
      ],
    );
  }

  Widget _buildCalendar(List<Appointment> appointments) {
    return Card(
      margin: const EdgeInsets.all(8),
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          children: [
            // Month Navigation
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: const Icon(Icons.chevron_left),
                  onPressed: () {
                    setState(() {
                      _focusedMonth = DateTime(
                        _focusedMonth.year,
                        _focusedMonth.month - 1,
                      );
                    });
                  },
                ),
                Text(
                  DateFormat('MMMM yyyy').format(_focusedMonth),
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.chevron_right),
                  onPressed: () {
                    setState(() {
                      _focusedMonth = DateTime(
                        _focusedMonth.year,
                        _focusedMonth.month + 1,
                      );
                    });
                  },
                ),
              ],
            ),
            const SizedBox(height: 8),
            // Weekday Headers
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun']
                  .map((day) => Expanded(
                        child: Center(
                          child: Text(
                            day,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.grey[600],
                            ),
                          ),
                        ),
                      ))
                  .toList(),
            ),
            const SizedBox(height: 8),
            // Calendar Grid
            _buildCalendarGrid(appointments),
          ],
        ),
      ),
    );
  }

  Widget _buildCalendarGrid(List<Appointment> appointments) {
    final firstDayOfMonth = DateTime(_focusedMonth.year, _focusedMonth.month, 1);
    final lastDayOfMonth = DateTime(_focusedMonth.year, _focusedMonth.month + 1, 0);
    final firstWeekday = firstDayOfMonth.weekday;
    final daysInMonth = lastDayOfMonth.day;

    final weeks = <Widget>[];
    final days = <Widget>[];

    for (int i = 1; i < firstWeekday; i++) {
      days.add(const Expanded(child: SizedBox()));
    }

    for (int day = 1; day <= daysInMonth; day++) {
      final date = DateTime(_focusedMonth.year, _focusedMonth.month, day);
      
      // ✅ CHANGED: Pass appointments list instead of boolean
      days.add(_buildDayCell(day, date, appointments));

      if ((firstWeekday + day - 1) % 7 == 0 || day == daysInMonth) {
        weeks.add(
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: List.from(days),
            ),
          ),
        );
        days.clear();
      }
    }
    return Column(children: weeks);
  }

  // ✅ UPDATED: Color-coded markers based on appointment status
  Widget _buildDayCell(int day, DateTime date, List<Appointment> appointments) {
    final isSelected = _selectedDate.year == date.year &&
        _selectedDate.month == date.month &&
        _selectedDate.day == date.day;
    final isToday = DateTime.now().year == date.year &&
        DateTime.now().month == date.month &&
        DateTime.now().day == date.day;

    // Get appointments for this specific day
    final dayAppointments = appointments.where((a) =>
        a.appointmentDate.year == date.year &&
        a.appointmentDate.month == date.month &&
        a.appointmentDate.day == date.day).toList();

    // Determine marker color based on appointment status
    Color? markerColor;
    if (dayAppointments.isNotEmpty) {
      // Check for different statuses
      final hasMissed = dayAppointments.any((a) =>
          a.appointmentStatus == AppointmentStatus.missed);
      
      final hasPending = dayAppointments.any((a) =>
          a.appointmentStatus == AppointmentStatus.scheduled ||
          a.appointmentStatus == AppointmentStatus.confirmed ||
          a.appointmentStatus == AppointmentStatus.rescheduled);
      
      final hasCompleted = dayAppointments.any((a) =>
          a.appointmentStatus == AppointmentStatus.completed);

      // Priority: Missed > Pending > Completed
      if (hasMissed) {
        markerColor = Colors.red;
      } else if (hasPending) {
        markerColor = Colors.orange;
      } else if (hasCompleted) {
        markerColor = Colors.green;
      }
    }

    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            _selectedDate = date;
          });
        },
        child: Container(
          margin: const EdgeInsets.all(2),
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: isSelected
                ? Theme.of(context).colorScheme.primary
                : isToday
                    ? Theme.of(context).colorScheme.primary.withOpacity(0.1)
                    : null,
            borderRadius: BorderRadius.circular(8),
            border: isToday && !isSelected
                ? Border.all(
                    color: Theme.of(context).colorScheme.primary,
                    width: 2,
                  )
                : null,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '$day',
                style: TextStyle(
                  color: isSelected
                      ? Colors.white
                      : date.month != _focusedMonth.month
                          ? Colors.grey
                          : null,
                  fontWeight: isToday ? FontWeight.bold : null,
                ),
              ),
              if (markerColor != null)
                Container(
                  margin: const EdgeInsets.only(top: 2),
                  width: 6,
                  height: 6,
                  decoration: BoxDecoration(
                    color: isSelected ? Colors.white : markerColor,
                    shape: BoxShape.circle,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAppointmentsList(List<Appointment> allAppointments) {
    final selectedDateAppointments = allAppointments.where((a) {
      final appointmentDate = a.appointmentDate;
      return appointmentDate.year == _selectedDate.year &&
          appointmentDate.month == _selectedDate.month &&
          appointmentDate.day == _selectedDate.day;
    }).toList();

    if (selectedDateAppointments.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.event_busy,
              size: 64,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              'No appointments on ${DateFormat('MMM dd, yyyy').format(_selectedDate)}',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(8),
      itemCount: selectedDateAppointments.length,
      itemBuilder: (context, index) {
        final appointment = selectedDateAppointments[index];
        return _buildAppointmentCard(appointment);
      },
    );
  }

  Widget _buildAppointmentCard(Appointment appointment) {
    final statusColor = _getStatusColor(appointment.appointmentStatus);
    final typeIcon = _getTypeIcon(appointment.appointmentType);

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: statusColor.withOpacity(0.2),
          child: Icon(typeIcon, color: statusColor),
        ),
        title: Text(
          appointment.patientName,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text(
              '${DateFormat('hh:mm a').format(appointment.appointmentDate)} • ${_formatAppointmentType(appointment.appointmentType)}',
            ),
            if (appointment.notes != null && appointment.notes!.isNotEmpty)
              Text(
                appointment.notes!,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
          ],
        ),
        trailing: Chip(
          label: Text(
            _formatStatus(appointment.appointmentStatus),
            style: const TextStyle(fontSize: 11),
          ),
          backgroundColor: statusColor.withOpacity(0.2),
          side: BorderSide.none,
        ),
        onTap: () {
          _showAppointmentDetails(appointment);
        },
      ),
    );
  }

  void _showAppointmentDetails(Appointment appointment) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(appointment.patientName),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDetailRow('Date', DateFormat('MMM dd, yyyy').format(appointment.appointmentDate)),
            _buildDetailRow('Time', DateFormat('hh:mm a').format(appointment.appointmentDate)),
            _buildDetailRow('Type', _formatAppointmentType(appointment.appointmentType)),
            _buildDetailRow('Status', _formatStatus(appointment.appointmentStatus)),
            if (appointment.notes != null && appointment.notes!.isNotEmpty)
              _buildDetailRow('Notes', appointment.notes!),
            _buildDetailRow('Facility', appointment.facilityName),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
          if (appointment.appointmentStatus == AppointmentStatus.scheduled)
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                if (appointment.id != null) {
                   _markAsCompleted(appointment.id!);
                }
              },
              child: const Text('Mark Completed'),
            ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80,
            child: Text(
              '$label:',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }

  // ✅ UPDATED: Added invalidate to refresh calendar
  void _markAsCompleted(String appointmentId) async {
    try {
      final updateStatus = ref.read(updateAppointmentStatusProvider);
      await updateStatus(appointmentId, AppointmentStatus.completed);

      // ✅ Refresh calendar markers
      ref.invalidate(monthAppointmentsProvider);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('✓ Appointment marked as completed'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to update: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Color _getStatusColor(AppointmentStatus status) {
    switch (status) {
      case AppointmentStatus.scheduled:
      case AppointmentStatus.confirmed:
        return Colors.blue;
      case AppointmentStatus.completed:
        return Colors.green;
      case AppointmentStatus.cancelled:
        return Colors.grey;
      case AppointmentStatus.missed:
        return Colors.red;
      case AppointmentStatus.rescheduled:
        return Colors.orange;
    }
  }

  IconData _getTypeIcon(AppointmentType type) {
    switch (type) {
      case AppointmentType.ancVisit:
        return Icons.pregnant_woman;
      case AppointmentType.pncVisit:
        return Icons.baby_changing_station;
      case AppointmentType.labTest:
        return Icons.science;
      case AppointmentType.ultrasound:
        return Icons.medical_services;
      case AppointmentType.delivery:
        return Icons.local_hospital;
      case AppointmentType.immunization:
        return Icons.vaccines;
      case AppointmentType.consultation:
        return Icons.medical_information;
      case AppointmentType.followUp:
        return Icons.follow_the_signs;
    }
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

  String _formatStatus(AppointmentStatus status) {
    switch (status) {
      case AppointmentStatus.scheduled:
        return 'Scheduled';
      case AppointmentStatus.confirmed:
        return 'Confirmed';
      case AppointmentStatus.completed:
        return 'Completed';
      case AppointmentStatus.cancelled:
        return 'Cancelled';
      case AppointmentStatus.missed:
        return 'Missed';
      case AppointmentStatus.rescheduled:
        return 'Rescheduled';
    }
  }
}