import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mch_core/mch_core.dart';
import 'package:intl/intl.dart';
import '../../../../core/providers/appointment_providers.dart';
import '../../../../core/widgets/offline_indicator.dart';
import '../../../../core/widgets/notification_bell.dart';
import 'book_appointment_screen.dart';

/// Schedule Screen with Collapsible Calendar and Categorized Appointments
class ScheduleScreen extends ConsumerStatefulWidget {
  final Widget? drawer;

  const ScheduleScreen({super.key, this.drawer});

  @override
  ConsumerState<ScheduleScreen> createState() => _ScheduleScreenState();
}

class _ScheduleScreenState extends ConsumerState<ScheduleScreen>
    with SingleTickerProviderStateMixin {
  DateTime _selectedDate = DateTime.now();
  DateTime _focusedMonth = DateTime.now();
  bool _isCalendarExpanded = true;
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final appointmentsAsync =
        ref.watch(monthAppointmentsProvider(_focusedMonth));
    final isDesktop = MediaQuery.of(context).size.width >= 900;
    final theme = Theme.of(context);

    return Scaffold(
      drawer: widget.drawer,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: isDesktop
            ? null
            : Builder(
                builder: (context) => GestureDetector(
                  onTap: () => Scaffold.of(context).openDrawer(),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: CircleAvatar(
                      backgroundColor: theme.primaryColor,
                      child: const Text(
                        "T",
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),
              ),
        title: const Text('Schedule'),
        actions: [
          const OfflineIndicator(),
          const SizedBox(width: 4),
          const SyncButton(),
          const NotificationBell(),
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
        data: (appointments) => _buildBody(appointments, isDesktop),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _navigateToBookAppointment(),
        icon: const Icon(Icons.add),
        label: const Text('New'),
      ),
    );
  }

  Widget _buildBody(List<Appointment> appointments, bool isDesktop) {
    if (isDesktop) {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // LEFT: Calendar + Summary
          Expanded(
            flex: 4,
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  _buildCollapsibleCalendar(appointments),
                  const SizedBox(height: 16),
                  _buildQuickStats(appointments),
                ],
              ),
            ),
          ),
          // RIGHT: Appointments
          Expanded(
            flex: 6,
            child: _buildAppointmentTabs(appointments),
          ),
        ],
      );
    }

    // Mobile Layout
    return Column(
      children: [
        _buildCollapsibleCalendar(appointments),
        Expanded(child: _buildAppointmentTabs(appointments)),
      ],
    );
  }

  Widget _buildCollapsibleCalendar(List<Appointment> appointments) {
    return Card(
      margin: const EdgeInsets.all(8),
      child: Column(
        children: [
          // Header with expand/collapse
          InkWell(
            onTap: () =>
                setState(() => _isCalendarExpanded = !_isCalendarExpanded),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.calendar_month,
                        color: Theme.of(context).primaryColor,
                      ),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            DateFormat('MMMM yyyy').format(_focusedMonth),
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            DateFormat('EEE, d MMM').format(_selectedDate),
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      // Month Navigation
                      IconButton(
                        icon: const Icon(Icons.chevron_left, size: 20),
                        onPressed: () {
                          setState(() {
                            _focusedMonth = DateTime(
                              _focusedMonth.year,
                              _focusedMonth.month - 1,
                            );
                          });
                        },
                        visualDensity: VisualDensity.compact,
                      ),
                      IconButton(
                        icon: const Icon(Icons.chevron_right, size: 20),
                        onPressed: () {
                          setState(() {
                            _focusedMonth = DateTime(
                              _focusedMonth.year,
                              _focusedMonth.month + 1,
                            );
                          });
                        },
                        visualDensity: VisualDensity.compact,
                      ),
                      const SizedBox(width: 8),
                      Icon(
                        _isCalendarExpanded
                            ? Icons.keyboard_arrow_up
                            : Icons.keyboard_arrow_down,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          // Collapsible Calendar Grid
          AnimatedCrossFade(
            duration: const Duration(milliseconds: 200),
            crossFadeState: _isCalendarExpanded
                ? CrossFadeState.showFirst
                : CrossFadeState.showSecond,
            firstChild: Padding(
              padding: const EdgeInsets.fromLTRB(8, 0, 8, 8),
              child: Column(
                children: [
                  // Weekday Headers
                  Row(
                    children: ['M', 'T', 'W', 'T', 'F', 'S', 'S']
                        .map((day) => Expanded(
                              child: Center(
                                child: Text(
                                  day,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12,
                                    color: Colors.grey[600],
                                  ),
                                ),
                              ),
                            ))
                        .toList(),
                  ),
                  const SizedBox(height: 8),
                  _buildCalendarGrid(appointments),
                ],
              ),
            ),
            secondChild: const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }

  Widget _buildCalendarGrid(List<Appointment> appointments) {
    final firstDayOfMonth =
        DateTime(_focusedMonth.year, _focusedMonth.month, 1);
    final lastDayOfMonth =
        DateTime(_focusedMonth.year, _focusedMonth.month + 1, 0);
    final firstWeekday = firstDayOfMonth.weekday;
    final daysInMonth = lastDayOfMonth.day;

    final weeks = <Widget>[];
    final days = <Widget>[];

    for (int i = 1; i < firstWeekday; i++) {
      days.add(const Expanded(child: SizedBox(height: 36)));
    }

    for (int day = 1; day <= daysInMonth; day++) {
      final date = DateTime(_focusedMonth.year, _focusedMonth.month, day);
      days.add(_buildDayCell(day, date, appointments));

      if ((firstWeekday + day - 1) % 7 == 0 || day == daysInMonth) {
        weeks.add(
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 2),
            child: Row(children: List.from(days)),
          ),
        );
        days.clear();
      }
    }
    return Column(children: weeks);
  }

  Widget _buildDayCell(int day, DateTime date, List<Appointment> appointments) {
    final isSelected = _selectedDate.year == date.year &&
        _selectedDate.month == date.month &&
        _selectedDate.day == date.day;
    final isToday = DateTime.now().year == date.year &&
        DateTime.now().month == date.month &&
        DateTime.now().day == date.day;

    final dayAppointments = appointments
        .where((a) =>
            a.appointmentDate.year == date.year &&
            a.appointmentDate.month == date.month &&
            a.appointmentDate.day == date.day)
        .toList();

    final appointmentCount = dayAppointments.length;

    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _selectedDate = date),
        child: Container(
          height: 36,
          margin: const EdgeInsets.all(1),
          decoration: BoxDecoration(
            color: isSelected
                ? Theme.of(context).primaryColor
                : isToday
                    ? Theme.of(context).primaryColor.withOpacity(0.1)
                    : null,
            borderRadius: BorderRadius.circular(6),
            border: isToday && !isSelected
                ? Border.all(color: Theme.of(context).primaryColor, width: 1.5)
                : null,
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              Text(
                '$day',
                style: TextStyle(
                  fontSize: 13,
                  color: isSelected ? Colors.white : null,
                  fontWeight: isToday ? FontWeight.bold : null,
                ),
              ),
              if (appointmentCount > 0)
                Positioned(
                  bottom: 2,
                  child: Container(
                    width: 5,
                    height: 5,
                    decoration: BoxDecoration(
                      color: isSelected
                          ? Colors.white
                          : Theme.of(context).primaryColor,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQuickStats(List<Appointment> appointments) {
    final today = DateTime.now();
    final todayAppts = appointments
        .where((a) =>
            a.appointmentDate.year == today.year &&
            a.appointmentDate.month == today.month &&
            a.appointmentDate.day == today.day)
        .length;

    final pending = appointments
        .where((a) =>
            a.appointmentStatus == AppointmentStatus.scheduled ||
            a.appointmentStatus == AppointmentStatus.confirmed)
        .length;
    final completed = appointments
        .where((a) => a.appointmentStatus == AppointmentStatus.completed)
        .length;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildStatItem('Today', '$todayAppts', Colors.blue),
            _buildStatItem('Pending', '$pending', Colors.orange),
            _buildStatItem('Completed', '$completed', Colors.green),
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
          style: TextStyle(
              fontSize: 20, fontWeight: FontWeight.bold, color: color),
        ),
        Text(label, style: TextStyle(fontSize: 12, color: Colors.grey[600])),
      ],
    );
  }

  Widget _buildAppointmentTabs(List<Appointment> allAppointments) {
    // Filter for selected date
    final selectedAppts = allAppointments
        .where((a) =>
            a.appointmentDate.year == _selectedDate.year &&
            a.appointmentDate.month == _selectedDate.month &&
            a.appointmentDate.day == _selectedDate.day)
        .toList();

    // Categorize
    final patientRequested = selectedAppts
        .where((a) => a.appointmentType == AppointmentType.consultation)
        .toList();
    final healthWorkerBooked = selectedAppts
        .where((a) => a.appointmentType != AppointmentType.consultation)
        .toList();
    final confirmed = selectedAppts
        .where((a) => a.appointmentStatus == AppointmentStatus.confirmed)
        .toList();
    final completed = selectedAppts
        .where((a) => a.appointmentStatus == AppointmentStatus.completed)
        .toList();

    return Column(
      children: [
        // Date Header
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                DateFormat('EEEE, d MMMM').format(_selectedDate),
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                '${selectedAppts.length} appointment${selectedAppts.length != 1 ? 's' : ''}',
                style: TextStyle(color: Colors.grey[600]),
              ),
            ],
          ),
        ),

        // Tabs
        TabBar(
          controller: _tabController,
          isScrollable: true,
          labelColor: Theme.of(context).primaryColor,
          unselectedLabelColor: Colors.grey,
          indicatorColor: Theme.of(context).primaryColor,
          tabs: [
            _buildTab('All', selectedAppts.length),
            _buildTab('Patient Requested', patientRequested.length),
            _buildTab('Confirmed', confirmed.length),
            _buildTab('Completed', completed.length),
          ],
        ),

        // Tab Content
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: [
              _buildAppointmentsList(selectedAppts),
              _buildAppointmentsList(patientRequested),
              _buildAppointmentsList(confirmed),
              _buildAppointmentsList(completed),
            ],
          ),
        ),
      ],
    );
  }

  Tab _buildTab(String label, int count) {
    return Tab(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(label),
          if (count > 0) ...[
            const SizedBox(width: 6),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                '$count',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).primaryColor,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildAppointmentsList(List<Appointment> appointments) {
    if (appointments.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.event_busy, size: 48, color: Colors.grey[400]),
            const SizedBox(height: 12),
            Text(
              'No appointments',
              style: TextStyle(fontSize: 14, color: Colors.grey[600]),
            ),
          ],
        ),
      );
    }

    // Sort by time
    appointments.sort((a, b) => a.appointmentDate.compareTo(b.appointmentDate));

    return ListView.builder(
      padding: const EdgeInsets.all(8),
      itemCount: appointments.length,
      itemBuilder: (context, index) =>
          _buildAppointmentCard(appointments[index]),
    );
  }

  Widget _buildAppointmentCard(Appointment appointment) {
    final statusColor = _getStatusColor(appointment.appointmentStatus);
    final typeIcon = _getTypeIcon(appointment.appointmentType);
    final isPatientRequested =
        appointment.appointmentType == AppointmentType.consultation;

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: InkWell(
        onTap: () => _showAppointmentDetails(appointment),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              // Time Column
              Container(
                width: 60,
                padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  children: [
                    Text(
                      DateFormat('HH:mm').format(appointment.appointmentDate),
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: statusColor,
                      ),
                    ),
                    Text(
                      DateFormat('a').format(appointment.appointmentDate),
                      style: TextStyle(fontSize: 10, color: statusColor),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),

              // Content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            appointment.patientName,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                            ),
                          ),
                        ),
                        if (isPatientRequested)
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: Colors.purple.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: const Text(
                              'PATIENT',
                              style: TextStyle(
                                fontSize: 9,
                                fontWeight: FontWeight.bold,
                                color: Colors.purple,
                              ),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(typeIcon, size: 14, color: Colors.grey[600]),
                        const SizedBox(width: 4),
                        Text(
                          _formatAppointmentType(appointment.appointmentType),
                          style:
                              TextStyle(fontSize: 12, color: Colors.grey[600]),
                        ),
                        const SizedBox(width: 12),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: statusColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            _formatStatus(appointment.appointmentStatus),
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: statusColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Action
              Icon(Icons.chevron_right, color: Colors.grey[400]),
            ],
          ),
        ),
      ),
    );
  }

  void _navigateToBookAppointment() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            BookAppointmentScreen(preselectedDate: _selectedDate),
      ),
    );
  }

  void _showAppointmentDetails(Appointment appointment) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.5,
        minChildSize: 0.3,
        maxChildSize: 0.9,
        expand: false,
        builder: (context, scrollController) => SingleChildScrollView(
          controller: scrollController,
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Patient Name
              Text(
                appointment.patientName,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),

              // Details
              _buildDetailTile(
                  Icons.calendar_today,
                  'Date',
                  DateFormat('EEEE, d MMMM yyyy')
                      .format(appointment.appointmentDate)),
              _buildDetailTile(Icons.access_time, 'Time',
                  DateFormat('h:mm a').format(appointment.appointmentDate)),
              _buildDetailTile(Icons.medical_services, 'Type',
                  _formatAppointmentType(appointment.appointmentType)),
              _buildDetailTile(Icons.info_outline, 'Status',
                  _formatStatus(appointment.appointmentStatus)),
              if (appointment.facilityName.isNotEmpty)
                _buildDetailTile(
                    Icons.local_hospital, 'Facility', appointment.facilityName),
              if (appointment.notes != null && appointment.notes!.isNotEmpty)
                _buildDetailTile(Icons.notes, 'Notes', appointment.notes!),

              const SizedBox(height: 24),

              // Actions
              if (appointment.appointmentStatus ==
                      AppointmentStatus.scheduled ||
                  appointment.appointmentStatus == AppointmentStatus.confirmed)
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () {
                          Navigator.pop(context);
                          // TODO: Cancel logic
                        },
                        icon: const Icon(Icons.close),
                        label: const Text('Cancel'),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.red,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: FilledButton.icon(
                        onPressed: () {
                          Navigator.pop(context);
                          if (appointment.id != null) {
                            _markAsCompleted(appointment.id!);
                          }
                        },
                        icon: const Icon(Icons.check),
                        label: const Text('Complete'),
                      ),
                    ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailTile(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Colors.grey[600]),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label,
                  style: TextStyle(fontSize: 12, color: Colors.grey[600])),
              Text(value, style: const TextStyle(fontSize: 15)),
            ],
          ),
        ],
      ),
    );
  }

  void _markAsCompleted(String appointmentId) async {
    try {
      final updateStatus = ref.read(updateAppointmentStatusProvider);
      await updateStatus(appointmentId, AppointmentStatus.completed);
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
          SnackBar(content: Text('Failed: $e'), backgroundColor: Colors.red),
        );
      }
    }
  }

  Color _getStatusColor(AppointmentStatus status) {
    switch (status) {
      case AppointmentStatus.scheduled:
        return Colors.blue;
      case AppointmentStatus.confirmed:
        return Colors.teal;
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
        return Icons.person;
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
