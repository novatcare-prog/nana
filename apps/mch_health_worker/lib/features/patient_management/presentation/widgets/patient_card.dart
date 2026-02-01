import 'package:flutter/material.dart';
import 'package:mch_core/mch_core.dart';
import '../screens/patient_detail_screen.dart';
import '../screens/anc_visit_recording_screen.dart';

/// Clean Patient Card Widget
class PatientCard extends StatelessWidget {
  final MaternalProfile patient;
  final VoidCallback? onTap;

  const PatientCard({
    super.key,
    required this.patient,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final daysUntilDue = patient.edd?.difference(DateTime.now()).inDays;
    final isHighRisk = _isHighRisk(patient);
    final theme = Theme.of(context);

    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      child: InkWell(
        onTap: onTap ?? () => _navigateToDetails(context),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              // Avatar
              CircleAvatar(
                radius: 24,
                backgroundColor: isHighRisk
                    ? Colors.red.shade100
                    : theme.colorScheme.primaryContainer,
                child: Text(
                  patient.clientName.isNotEmpty
                      ? patient.clientName[0].toUpperCase()
                      : '?',
                  style: TextStyle(
                    color: isHighRisk
                        ? Colors.red.shade700
                        : theme.colorScheme.onPrimaryContainer,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ),
              const SizedBox(width: 14),

              // Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Name Row
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            patient.clientName,
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 15,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        if (isHighRisk) ...[
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.red.shade100,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: const Text(
                              'HIGH RISK',
                              style: TextStyle(
                                color: Colors.red,
                                fontSize: 9,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),

                    const SizedBox(height: 4),

                    // Phone
                    Row(
                      children: [
                        Icon(
                          Icons.phone_outlined,
                          size: 14,
                          color: Colors.grey[500],
                        ),
                        const SizedBox(width: 4),
                        Text(
                          patient.telephone ?? 'No phone',
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),

                    // EDD
                    if (patient.edd != null) ...[
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(
                            Icons.event_outlined,
                            size: 14,
                            color: Colors.grey[500],
                          ),
                          const SizedBox(width: 4),
                          Text(
                            'EDD: ${_formatDate(patient.edd!)}',
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.grey[600],
                            ),
                          ),
                          if (daysUntilDue != null &&
                              daysUntilDue >= 0 &&
                              daysUntilDue <= 30) ...[
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 6,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.orange.shade100,
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                '$daysUntilDue days',
                                style: TextStyle(
                                  color: Colors.orange.shade800,
                                  fontSize: 10,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ],
                  ],
                ),
              ),

              // Menu
              PopupMenuButton<String>(
                icon: Icon(Icons.more_vert, color: Colors.grey[500]),
                onSelected: (value) => _handleAction(context, value),
                itemBuilder: (context) => const [
                  PopupMenuItem(
                    value: 'view',
                    child: Row(
                      children: [
                        Icon(Icons.visibility, size: 20),
                        SizedBox(width: 12),
                        Text('View Details'),
                      ],
                    ),
                  ),
                  PopupMenuItem(
                    value: 'visit',
                    child: Row(
                      children: [
                        Icon(Icons.add_circle, size: 20),
                        SizedBox(width: 12),
                        Text('Record Visit'),
                      ],
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

  void _handleAction(BuildContext context, String action) {
    switch (action) {
      case 'view':
        _navigateToDetails(context);
        break;
      case 'visit':
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => ANCVisitRecordingScreen(
              patientId: patient.id!,
              patient: patient,
            ),
          ),
        );
        break;
    }
  }

  void _navigateToDetails(BuildContext context) {
    if (patient.id != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => PatientDetailScreen(patientId: patient.id!),
        ),
      );
    }
  }

  bool _isHighRisk(MaternalProfile patient) {
    return patient.diabetes == true ||
        patient.hypertension == true ||
        patient.previousCs == true ||
        patient.age > 35 ||
        patient.age < 18;
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}
