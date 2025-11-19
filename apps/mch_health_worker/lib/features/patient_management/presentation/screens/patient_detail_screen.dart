import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mch_core/mch_core.dart';
import '../../../../core/providers/supabase_providers.dart';
import 'anc_visit_history_screen.dart'; // Corrected import

/// Patient Detail Screen - Shows full patient information
class PatientDetailScreen extends ConsumerWidget {
  final String patientId;

  const PatientDetailScreen({
    super.key,
    required this.patientId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Use the provider to get the profile. 
    // We use 'maternalProfilesProvider' and find the specific patient in the list
    // This is efficient because the list is likely already cached.
    final profilesAsync = ref.watch(maternalProfilesProvider);

    return profilesAsync.when(
      data: (profiles) {
        // Find the specific patient
        final patient = profiles.firstWhere(
          (p) => p.id == patientId,
          orElse: () => throw Exception('Patient not found'),
        );

        return Scaffold(
          appBar: AppBar(
            title: const Text('Patient Details'),
            actions: [
              IconButton(
                icon: const Icon(Icons.history),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ANCVisitHistoryScreen(
                        patientId: patientId,
                        patient: patient,
                      ),
                    ),
                  );
                },
                tooltip: 'View ANC Visits',
              ),
              IconButton(
                icon: const Icon(Icons.edit),
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Edit feature coming soon!')),
                  );
                },
              ),
            ],
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Patient Header Card
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            CircleAvatar(
                              radius: 40,
                              backgroundColor: Colors.blue,
                              child: Text(
                                patient.clientName.isNotEmpty ? patient.clientName[0] : '?',
                                style: const TextStyle(
                                  fontSize: 32,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    patient.clientName,
                                    style: const TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    'ANC: ${patient.ancNumber}',
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                  Text(
                                    '${patient.age} years old',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                // Facility Information
                _buildSection(
                  'Facility Information',
                  [
                    _buildInfoRow('Facility', patient.facilityName),
                    _buildInfoRow('KMHFL Code', patient.kmhflCode),
                    _buildInfoRow('ANC Number', patient.ancNumber),
                    if (patient.pncNumber != null)
                      _buildInfoRow('PNC Number', patient.pncNumber!),
                  ],
                ),

                // Obstetric Information
                _buildSection(
                  'Obstetric Information',
                  [
                    _buildInfoRow('Gravida', patient.gravida.toString()),
                    _buildInfoRow('Parity', patient.parity.toString()),
                    _buildInfoRow('Height', '${patient.heightCm} cm'),
                    _buildInfoRow('Weight', '${patient.weightKg} kg'),
                    _buildInfoRow('LMP', patient.lmp.toString().split(' ')[0]),
                    _buildInfoRow('EDD', patient.edd.toString().split(' ')[0]),
                  ],
                ),

                // Contact Information
                _buildSection(
                  'Contact Information',
                  [
                    if (patient.telephone != null)
                      _buildInfoRow('Phone', patient.telephone!),
                    if (patient.county != null)
                      _buildInfoRow('County', patient.county!),
                    if (patient.subCounty != null)
                      _buildInfoRow('Sub County', patient.subCounty!),
                    if (patient.ward != null)
                      _buildInfoRow('Ward', patient.ward!),
                    if (patient.village != null)
                      _buildInfoRow('Village', patient.village!),
                  ],
                ),

                // Medical History
                if (patient.diabetes == true ||
                    patient.hypertension == true ||
                    patient.tuberculosis == true ||
                    patient.bloodTransfusion == true ||
                    patient.drugAllergy == true)
                  _buildSection(
                    'Medical History',
                    [
                      if (patient.diabetes == true)
                        _buildInfoRow('Diabetes', 'Yes', isAlert: true),
                      if (patient.hypertension == true)
                        _buildInfoRow('Hypertension', 'Yes', isAlert: true),
                      if (patient.tuberculosis == true)
                        _buildInfoRow('Tuberculosis', 'Yes', isAlert: true),
                      if (patient.bloodTransfusion == true)
                        _buildInfoRow('Blood Transfusion', 'Yes'),
                      if (patient.drugAllergy == true)
                        _buildInfoRow('Drug Allergy', patient.allergyDetails ?? 'Yes', isAlert: true),
                    ],
                  ),

                // Next of Kin
                if (patient.nextOfKinName != null)
                  _buildSection(
                    'Next of Kin',
                    [
                      _buildInfoRow('Name', patient.nextOfKinName!),
                      if (patient.nextOfKinRelationship != null)
                        _buildInfoRow('Relationship', patient.nextOfKinRelationship!),
                      if (patient.nextOfKinPhone != null)
                        _buildInfoRow('Phone', patient.nextOfKinPhone!),
                    ],
                  ),
              ],
            ),
          ),
        );
      },
      loading: () => const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      ),
      error: (error, stack) => Scaffold(
        appBar: AppBar(title: const Text('Error')),
        body: Center(child: Text('Error loading profile: $error')),
      ),
    );
  }

  Widget _buildSection(String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: children,
            ),
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildInfoRow(String label, String value, {bool isAlert = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: TextStyle(
                fontWeight: FontWeight.w500,
                color: Colors.grey[700],
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                color: isAlert ? Colors.red : Colors.black87,
                fontWeight: isAlert ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ),
        ],
      ),
    );
  }
}