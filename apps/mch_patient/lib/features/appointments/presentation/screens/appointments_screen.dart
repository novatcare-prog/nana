import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:mch_core/mch_core.dart';
import '../../../../core/providers/appointment_provider.dart';
import '../../../../core/utils/error_helper.dart';

class AppointmentsScreen extends ConsumerStatefulWidget {
  const AppointmentsScreen({super.key});

  @override
  ConsumerState<AppointmentsScreen> createState() => _VisitsScreenState();
}

class _VisitsScreenState extends ConsumerState<AppointmentsScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('My Visits', style: TextStyle(fontWeight: FontWeight.bold)),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              ref.invalidate(upcomingAppointmentsProvider);
              ref.invalidate(pastAppointmentsProvider);
            },
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          labelStyle: const TextStyle(fontWeight: FontWeight.bold),
          tabs: const [
            Tab(text: 'Upcoming'),
            Tab(text: 'History'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _UpcomingAppointmentsTab(),
          _PastAppointmentsTab(),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Find Clinic feature coming soon'),
              backgroundColor: Color(0xFFE91E63),
            ),
          );
        },
        backgroundColor: const Color(0xFFE91E63),
        icon: const Icon(Icons.add_location_alt, color: Colors.white),
        label: const Text("Find Clinic", style: TextStyle(color: Colors.white)),
      ),
    );
  }
}

// Upcoming Appointments Tab
class _UpcomingAppointmentsTab extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appointmentsAsync = ref.watch(upcomingAppointmentsProvider);

    return appointmentsAsync.when(
      data: (appointments) {
        if (appointments.isEmpty) {
          return const _EmptyState(
            icon: Icons.event_available,
            title: 'No Upcoming Visits',
            message: 'You have no scheduled appointments. Book a visit at your nearest health facility.',
          );
        }

        return RefreshIndicator(
          onRefresh: () async {
            ref.invalidate(upcomingAppointmentsProvider);
            await ref.read(upcomingAppointmentsProvider.future);
          },
          child: ListView.builder(
            padding: const EdgeInsets.all(16.0),
            itemCount: appointments.length,
            itemBuilder: (context, index) {
              final appointment = appointments[index];
              return _AppointmentCard(
                appointment: appointment,
                isUpcoming: true,
              );
            },
          ),
        );
      },
      loading: () => const Center(
        child: CircularProgressIndicator(color: Color(0xFFE91E63)),
      ),
      error: (error, stack) => ErrorHelper.buildErrorWidget(
        error,
        onRetry: () => ref.invalidate(upcomingAppointmentsProvider),
      ),
    );
  }
}

// Past Appointments Tab
class _PastAppointmentsTab extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appointmentsAsync = ref.watch(pastAppointmentsProvider);

    return appointmentsAsync.when(
      data: (appointments) {
        if (appointments.isEmpty) {
          return const _EmptyState(
            icon: Icons.history,
            title: 'No Visit History',
            message: 'Your past appointments will appear here.',
          );
        }

        return RefreshIndicator(
          onRefresh: () async {
            ref.invalidate(pastAppointmentsProvider);
            await ref.read(pastAppointmentsProvider.future);
          },
          child: ListView.builder(
            padding: const EdgeInsets.all(16.0),
            itemCount: appointments.length,
            itemBuilder: (context, index) {
              final appointment = appointments[index];
              return _AppointmentCard(
                appointment: appointment,
                isUpcoming: false,
              );
            },
          ),
        );
      },
      loading: () => const Center(
        child: CircularProgressIndicator(color: Color(0xFFE91E63)),
      ),
      error: (error, stack) => ErrorHelper.buildErrorWidget(
        error,
        onRetry: () => ref.invalidate(pastAppointmentsProvider),
      ),
    );
  }
}

// Appointment Card Widget - Using real Appointment model
class _AppointmentCard extends StatelessWidget {
  final Appointment appointment;
  final bool isUpcoming;

  const _AppointmentCard({
    required this.appointment,
    required this.isUpcoming,
  });

  @override
  Widget build(BuildContext context) {
    final dateFormatted = DateFormat('dd MMM yyyy').format(appointment.appointmentDate);
    final dayOfWeek = DateFormat('EEEE').format(appointment.appointmentDate);
    final timeFormatted = DateFormat('HH:mm').format(appointment.appointmentDate);
    
    // Status Logic
    Color statusColor;
    String statusText;
    switch (appointment.appointmentStatus) {
      case AppointmentStatus.scheduled:
        statusColor = Colors.blue;
        statusText = "Scheduled";
        break;
      case AppointmentStatus.confirmed:
        statusColor = Colors.green;
        statusText = "Confirmed";
        break;
      case AppointmentStatus.completed:
        statusColor = Colors.teal;
        statusText = "Completed";
        break;
      case AppointmentStatus.cancelled:
        statusColor = Colors.red;
        statusText = "Cancelled";
        break;
      case AppointmentStatus.missed:
        statusColor = Colors.orange;
        statusText = "Missed";
        break;
      case AppointmentStatus.rescheduled:
        statusColor = Colors.purple;
        statusText = "Rescheduled";
        break;
    }

    // Appointment Type Logic
    IconData typeIcon;
    Color typeColor;
    switch (appointment.appointmentType) {
      case AppointmentType.ancVisit:
        typeIcon = Icons.pregnant_woman;
        typeColor = const Color(0xFFE91E63);
        break;
      case AppointmentType.pncVisit:
        typeIcon = Icons.baby_changing_station;
        typeColor = Colors.purple;
        break;
      case AppointmentType.immunization:
        typeIcon = Icons.vaccines;
        typeColor = Colors.green;
        break;
      case AppointmentType.labTest:
        typeIcon = Icons.science;
        typeColor = Colors.blue;
        break;
      case AppointmentType.ultrasound:
        typeIcon = Icons.monitor_heart;
        typeColor = Colors.teal;
        break;
      case AppointmentType.delivery:
        typeIcon = Icons.child_friendly;
        typeColor = Colors.pink;
        break;
      case AppointmentType.consultation:
        typeIcon = Icons.medical_services;
        typeColor = Colors.indigo;
        break;
      case AppointmentType.followUp:
        typeIcon = Icons.follow_the_signs;
        typeColor = Colors.amber;
        break;
    }

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Row: Date Badge + Status
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.calendar_month, size: 14, color: Colors.grey[700]),
                          const SizedBox(width: 6),
                          Text(
                            "$dayOfWeek, $dateFormatted",
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Colors.grey[800]),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      timeFormatted,
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    statusText.toUpperCase(),
                    style: TextStyle(color: statusColor, fontSize: 10, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 12),
              child: Divider(height: 1, color: Color(0xFFEEEEEE)),
            ),

            // Main Content
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  backgroundColor: typeColor.withOpacity(0.1),
                  radius: 24,
                  child: Icon(typeIcon, color: typeColor),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _formatAppointmentType(appointment.appointmentType),
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      if (appointment.patientName.isNotEmpty) ...[
                        const SizedBox(height: 4),
                        Text(
                          "Patient: ${appointment.patientName}",
                          style: TextStyle(color: Colors.grey[600], fontSize: 13),
                        ),
                      ],
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          Icon(Icons.location_on, size: 14, color: Colors.grey[500]),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              appointment.facilityName.isNotEmpty 
                                  ? appointment.facilityName 
                                  : 'Health Facility',
                              style: TextStyle(color: Colors.grey[600], fontSize: 12),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      if (appointment.notes != null && appointment.notes!.isNotEmpty) ...[
                        const SizedBox(height: 8),
                        Text(
                          appointment.notes!,
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 12,
                            fontStyle: FontStyle.italic,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),

            // Action Buttons (Only for upcoming)
            if (isUpcoming && appointment.appointmentStatus != AppointmentStatus.cancelled) ...[
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Reschedule feature coming soon')),
                        );
                      },
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        side: BorderSide(color: Colors.grey.shade300),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                      child: const Text("Reschedule", style: TextStyle(color: Colors.black87, fontSize: 12)),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Get Directions feature coming soon')),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        backgroundColor: typeColor,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        elevation: 0,
                      ),
                      child: const Text("Get Directions", style: TextStyle(color: Colors.white, fontSize: 12)),
                    ),
                  ),
                ],
              ),
            ],
          ],
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
      case AppointmentType.immunization:
        return 'Immunization';
      case AppointmentType.labTest:
        return 'Lab Test';
      case AppointmentType.ultrasound:
        return 'Ultrasound';
      case AppointmentType.delivery:
        return 'Delivery';
      case AppointmentType.consultation:
        return 'Consultation';
      case AppointmentType.followUp:
        return 'Follow Up';
    }
  }
}

// Empty State Widget
class _EmptyState extends StatelessWidget {
  final IconData icon;
  final String title;
  final String message;

  const _EmptyState({required this.icon, required this.title, required this.message});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(color: Colors.grey.shade100, shape: BoxShape.circle),
              child: Icon(icon, size: 48, color: Colors.grey.shade400),
            ),
            const SizedBox(height: 24),
            Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.black54)),
            const SizedBox(height: 8),
            Text(message, textAlign: TextAlign.center, style: TextStyle(color: Colors.grey[600], fontSize: 14)),
          ],
        ),
      ),
    );
  }
}
