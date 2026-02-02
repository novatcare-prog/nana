import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:mch_core/mch_core.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../core/providers/appointment_provider.dart';
import '../../../../core/utils/error_helper.dart';

class AppointmentsScreen extends ConsumerStatefulWidget {
  const AppointmentsScreen({super.key});

  @override
  ConsumerState<AppointmentsScreen> createState() => _VisitsScreenState();
}

class _VisitsScreenState extends ConsumerState<AppointmentsScreen>
    with SingleTickerProviderStateMixin {
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
        title: Text('appointment.title'.tr(),
            style: const TextStyle(fontWeight: FontWeight.bold)),
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
          tabs: [
            Tab(text: 'appointment.upcoming'.tr()),
            Tab(text: 'appointment.history'.tr()),
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
          context.push('/clinics');
        },
        backgroundColor: const Color(0xFFE91E63),
        icon: const Icon(Icons.add_location_alt, color: Colors.white),
        label: Text('appointment.find_clinic'.tr(),
            style: const TextStyle(color: Colors.white)),
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
          return _EmptyState(
            icon: Icons.event_available,
            title: 'appointment.no_upcoming_visits'.tr(),
            message: 'appointment.no_upcoming_message'.tr(),
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
          return _EmptyState(
            icon: Icons.history,
            title: 'appointment.no_history'.tr(),
            message: 'appointment.no_history_message'.tr(),
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
class _AppointmentCard extends ConsumerStatefulWidget {
  final Appointment appointment;
  final bool isUpcoming;

  const _AppointmentCard({
    required this.appointment,
    required this.isUpcoming,
  });

  @override
  ConsumerState<_AppointmentCard> createState() => _AppointmentCardState();
}

class _AppointmentCardState extends ConsumerState<_AppointmentCard> {
  bool _isProcessing = false;

  @override
  Widget build(BuildContext context) {
    final appointment = widget.appointment;
    final dateFormatted =
        DateFormat('dd MMM yyyy').format(appointment.appointmentDate);
    final dayOfWeek = DateFormat('EEEE').format(appointment.appointmentDate);
    final timeFormatted =
        DateFormat('HH:mm').format(appointment.appointmentDate);

    // Status Logic
    Color statusColor;
    String statusText;
    switch (appointment.appointmentStatus) {
      case AppointmentStatus.scheduled:
        statusColor = Colors.blue;
        statusText = 'appointment.status_scheduled'.tr();
        break;
      case AppointmentStatus.confirmed:
        statusColor = Colors.green;
        statusText = 'appointment.status_confirmed'.tr();
        break;
      case AppointmentStatus.completed:
        statusColor = Colors.teal;
        statusText = 'appointment.status_completed'.tr();
        break;
      case AppointmentStatus.cancelled:
        statusColor = Colors.red;
        statusText = 'appointment.status_cancelled'.tr();
        break;
      case AppointmentStatus.missed:
        statusColor = Colors.orange;
        statusText = 'appointment.status_missed'.tr();
        break;
      case AppointmentStatus.rescheduled:
        statusColor = Colors.purple;
        statusText = 'appointment.status_rescheduled'.tr();
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
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.calendar_month,
                              size: 14, color: Colors.grey[700]),
                          const SizedBox(width: 6),
                          Text(
                            "$dayOfWeek, $dateFormatted",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                                color: Colors.grey[800]),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      timeFormatted,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 12),
                    ),
                  ],
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    statusText.toUpperCase(),
                    style: TextStyle(
                        color: statusColor,
                        fontSize: 10,
                        fontWeight: FontWeight.bold),
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
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      if (appointment.patientName.isNotEmpty) ...[
                        const SizedBox(height: 4),
                        Text(
                          "${'appointment.patient'.tr()}: ${appointment.patientName}",
                          style:
                              TextStyle(color: Colors.grey[600], fontSize: 13),
                        ),
                      ],
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          Icon(Icons.location_on,
                              size: 14, color: Colors.grey[500]),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              appointment.facilityName.isNotEmpty
                                  ? appointment.facilityName
                                  : 'appointment.health_facility'.tr(),
                              style: TextStyle(
                                  color: Colors.grey[600], fontSize: 12),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      if (appointment.notes != null &&
                          appointment.notes!.isNotEmpty) ...[
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
            if (widget.isUpcoming &&
                appointment.appointmentStatus !=
                    AppointmentStatus.cancelled) ...[
              const SizedBox(height: 16),
              Row(
                children: [
                  // CONFIRM BUTTON (Show if scheduled)
                  if (appointment.appointmentStatus ==
                      AppointmentStatus.scheduled)
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: ElevatedButton.icon(
                          onPressed: _isProcessing
                              ? null
                              : () async {
                                  setState(() => _isProcessing = true);
                                  try {
                                    final confirm =
                                        ref.read(confirmAppointmentProvider);
                                    await confirm(appointment.id!);

                                    if (mounted) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                          content: Text(
                                              'appointment.confirmed_success'
                                                  .tr()),
                                          backgroundColor: Colors.green,
                                        ),
                                      );
                                    }
                                  } catch (e) {
                                    if (mounted) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                          content: Text('Failed: $e'),
                                          backgroundColor: Colors.red,
                                        ),
                                      );
                                    }
                                  } finally {
                                    if (mounted) {
                                      setState(() => _isProcessing = false);
                                    }
                                  }
                                },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8)),
                          ),
                          icon: _isProcessing
                              ? const SizedBox(
                                  width: 12,
                                  height: 12,
                                  child: CircularProgressIndicator(
                                      strokeWidth: 2, color: Colors.white))
                              : const Icon(Icons.check_circle, size: 16),
                          label: Text('appointment.confirm'.tr(),
                              style: const TextStyle(fontSize: 12)),
                        ),
                      ),
                    ),

                  // RESCHEDULE BUTTON
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                              content: Text(
                                  'appointment.contact_to_reschedule'.tr())),
                        );
                      },
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        side: BorderSide(color: Colors.grey.shade300),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8)),
                      ),
                      child: Text('appointment.reschedule'.tr(),
                          style: TextStyle(
                              color: Theme.of(context).colorScheme.onSurface,
                              fontSize: 12)),
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
        return 'appointment.next_anc_visit'.tr();
      case AppointmentType.pncVisit:
        return 'appointment.next_pnc_visit'.tr();
      case AppointmentType.immunization:
        return 'appointment.immunization'.tr();
      case AppointmentType.labTest:
        return 'appointment.lab_test'.tr();
      case AppointmentType.ultrasound:
        return 'appointment.ultrasound'.tr();
      case AppointmentType.delivery:
        return 'appointment.delivery'.tr();
      case AppointmentType.consultation:
        return 'appointment.consultation'.tr();
      case AppointmentType.followUp:
        return 'appointment.follow_up'.tr();
    }
  }
}

// Empty State Widget
class _EmptyState extends StatelessWidget {
  final IconData icon;
  final String title;
  final String message;

  const _EmptyState(
      {required this.icon, required this.title, required this.message});

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
              decoration: BoxDecoration(
                  color: Colors.grey.shade100, shape: BoxShape.circle),
              child: Icon(icon, size: 48, color: Colors.grey.shade400),
            ),
            const SizedBox(height: 24),
            Text(title,
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: Theme.of(context)
                        .colorScheme
                        .onSurface
                        .withOpacity(0.7))),
            const SizedBox(height: 8),
            Text(message,
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey[600], fontSize: 14)),
          ],
        ),
      ),
    );
  }
}
