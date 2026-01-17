import 'package:flutter/material.dart';
import 'package:mch_core/mch_core.dart';
import '../screens/patient_detail_screen.dart';
import '../screens/anc_visit_recording_screen.dart';

/// Optimized PatientCard widget - extracted for better performance
/// Uses const constructor where possible to avoid unnecessary rebuilds
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
    final highRiskReasons = _getHighRiskReasons(patient);

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      elevation: isHighRisk ? 2 : 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: isHighRisk
            ? const BorderSide(color: Colors.red, width: 1.5)
            : BorderSide.none,
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: CircleAvatar(
          backgroundColor: isHighRisk ? Colors.red.shade100 : Colors.blue.shade100,
          child: Text(
            patient.clientName.isNotEmpty ? patient.clientName[0].toUpperCase() : '?',
            style: TextStyle(
              color: isHighRisk ? Colors.red.shade800 : Colors.blue.shade800,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        title: Row(
          children: [
            Expanded(
              child: Text(
                patient.clientName,
                style: const TextStyle(fontWeight: FontWeight.bold),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            if (isHighRisk)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.red.shade100,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: const Text(
                  'HIGH RISK',
                  style: TextStyle(
                    color: Colors.red,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
          ],
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Row(
              children: [
                Icon(Icons.phone, size: 14, color: Colors.grey.shade600),
                const SizedBox(width: 4),
                Text(
                  patient.telephone ?? 'No phone',
                  style: TextStyle(color: Colors.grey.shade600),
                ),
              ],
            ),
            if (patient.edd != null) ...[
              const SizedBox(height: 4),
              Row(
                children: [
                  Icon(Icons.calendar_today, size: 14, color: Colors.grey.shade600),
                  const SizedBox(width: 4),
                  Text(
                    'EDD: ${_formatDate(patient.edd!)}',
                    style: TextStyle(color: Colors.grey.shade600),
                  ),
                  if (daysUntilDue != null && daysUntilDue >= 0 && daysUntilDue <= 30) ...[
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: Colors.orange.shade100,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        '$daysUntilDue days',
                        style: TextStyle(
                          color: Colors.orange.shade800,
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ],
            if (isHighRisk && highRiskReasons.isNotEmpty) ...[
              const SizedBox(height: 4),
              Wrap(
                spacing: 4,
                children: highRiskReasons.map((reason) => Chip(
                  label: Text(reason, style: const TextStyle(fontSize: 10)),
                  padding: EdgeInsets.zero,
                  labelPadding: const EdgeInsets.symmetric(horizontal: 4),
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  backgroundColor: Colors.red.shade50,
                )).toList(),
              ),
            ],
          ],
        ),
        trailing: PopupMenuButton<String>(
          icon: const Icon(Icons.more_vert),
          onSelected: (value) => _handleMenuAction(context, value),
          itemBuilder: (context) => const [
            PopupMenuItem(
              value: 'view',
              child: Row(
                children: [
                  Icon(Icons.visibility),
                  SizedBox(width: 8),
                  Text('View Details'),
                ],
              ),
            ),
            PopupMenuItem(
              value: 'visit',
              child: Row(
                children: [
                  Icon(Icons.add_circle),
                  SizedBox(width: 8),
                  Text('Record Visit'),
                ],
              ),
            ),
          ],
        ),
        onTap: onTap ?? () => _navigateToDetails(context),
      ),
    );
  }

  void _handleMenuAction(BuildContext context, String action) {
    switch (action) {
      case 'view':
        _navigateToDetails(context);
        break;
      case 'visit':
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ANCVisitRecordingScreen(
              patientId: patient.id!,
              patient: patient,
            ),
          ),
        );
        break;
    }
  }

  void _navigateToDetails(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PatientDetailScreen(patientId: patient.id!),
      ),
    );
  }

  bool _isHighRisk(MaternalProfile patient) {
    return patient.diabetes == true ||
        patient.hypertension == true ||
        patient.previousCs == true ||
        patient.age > 35 ||
        patient.age < 18;
  }

  List<String> _getHighRiskReasons(MaternalProfile patient) {
    List<String> reasons = [];
    if (patient.diabetes == true) reasons.add('Diabetes');
    if (patient.hypertension == true) reasons.add('Hypertension');
    if (patient.previousCs == true) reasons.add('Previous CS');
    if (patient.age > 35) reasons.add('Age >35');
    if (patient.age < 18) reasons.add('Age <18');
    return reasons;
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}
