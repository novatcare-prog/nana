import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../providers/external_patient_provider.dart';

class ExternalPatientViewScreen extends ConsumerWidget {
  const ExternalPatientViewScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final patientData = ref.watch(externalPatientDataProvider);

    if (patientData == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('External Record')),
        body: const Center(child: Text('No data loaded. Please scan again.')),
      );
    }

    final profile = patientData.profile;

    return Scaffold(
      appBar: AppBar(
        title: const Text('External Patient Record'),
        backgroundColor: Colors.purple,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: () {
              // Clear data on exit
              ref.read(externalPatientDataProvider.notifier).state = null;
              Navigator.of(context).popUntil((route) => route.isFirst);
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Warning Banner
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            color: Colors.amber[100],
            child: Row(
              children: [
                const Icon(Icons.warning_amber_rounded, color: Colors.orange),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'READ ONLY VIEW. Data is not stored on this device.',
                    style: TextStyle(
                        color: Colors.orange[900], fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),

          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Profile Header
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          const CircleAvatar(
                            radius: 40,
                            backgroundColor: Colors.purple,
                            child: Icon(Icons.person,
                                size: 40, color: Colors.white),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            profile.clientName,
                            style: const TextStyle(
                                fontSize: 24, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 8),
                          Text('ANC: ${profile.ancNumber}'),
                          Text('ID: ${profile.idNumber ?? "N/A"}'),
                          const Divider(),
                          _InfoRow(label: 'Age', value: '${profile.age}'),
                          _InfoRow(
                              label: 'Phone', value: profile.telephone ?? "--"),
                          _InfoRow(
                              label: 'Facility', value: profile.facilityName),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),
                  const Text('Recent Visits',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),

                  if (patientData.recentVisits.isEmpty)
                    const Card(
                        child: Padding(
                            padding: EdgeInsets.all(16),
                            child: Text('No recent visits recorded.')))
                  else
                    ...patientData.recentVisits.map((visit) {
                      // visit is Map<String, dynamic>
                      final dateStr = visit['appointment_date'] as String?;
                      final date =
                          dateStr != null ? DateTime.tryParse(dateStr) : null;

                      return Card(
                        child: ListTile(
                          leading: const Icon(Icons.calendar_today,
                              color: Colors.purple),
                          title: Text(visit['status'] ?? 'Visit'),
                          subtitle: Text(visit['notes'] ?? 'No notes'),
                          trailing: Text(date != null
                              ? DateFormat('d MMM yyyy').format(date)
                              : '--'),
                        ),
                      );
                    }),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;
  const _InfoRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Colors.grey)),
          Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
