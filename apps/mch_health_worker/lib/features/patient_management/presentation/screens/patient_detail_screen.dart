import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mch_core/mch_core.dart';
import '../../../../core/providers/supabase_providers.dart';
import 'anc_visit_history_screen.dart';
import 'patient_edit_screen.dart';
import 'lab_results_history_screen.dart';
import '../../presentation/screens/immunization_malaria_screen.dart';
import '../../presentation/screens/nutrition_tracking_screen.dart';
/// Patient Detail Screen with Tabbed Interface
/// Design: Profile | Medical History | Lab Results | Visits
class PatientDetailScreen extends ConsumerStatefulWidget {
  final String patientId;

  const PatientDetailScreen({
    super.key,
    required this.patientId,
  });

  @override
  ConsumerState<PatientDetailScreen> createState() => _PatientDetailScreenState();
}

class _PatientDetailScreenState extends ConsumerState<PatientDetailScreen>
    with SingleTickerProviderStateMixin {
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
    final profilesAsync = ref.watch(maternalProfilesProvider);

    return profilesAsync.when(
      data: (profiles) {
        final patient = profiles.firstWhere(
          (p) => p.id == widget.patientId,
          orElse: () => throw Exception('Patient not found'),
        );

        return Scaffold(
          appBar: AppBar(
            title: const Text('Patient Details'),
            actions: [
              IconButton(
                icon: const Icon(Icons.edit),
                onPressed: () async {
                  final result = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PatientEditScreen(profile: patient),
                    ),
                  );
                  
                  // If edit was successful, refresh the page
                  if (result == true) {
                    ref.invalidate(maternalProfilesProvider);
                  }
                },
                tooltip: 'Edit Patient',
              ),
              IconButton(
                icon: const Icon(Icons.more_vert),
                onPressed: () {
                  // Show more options
                },
                tooltip: 'More options',
              ),
            ],
            bottom: TabBar(
              controller: _tabController,
              tabs: const [
                Tab(icon: Icon(Icons.person), text: 'Profile'),
                Tab(icon: Icon(Icons.medical_services), text: 'Medical History'),
                Tab(icon: Icon(Icons.science), text: 'Lab Results'),
                Tab(icon: Icon(Icons.event), text: 'Visits'),
              ],
            ),
          ),
          body: TabBarView(
            controller: _tabController,
            children: [
              _buildProfileTab(patient),
              _buildMedicalHistoryTab(patient),
              _buildLabResultsTab(patient),
              _buildVisitsTab(patient),
            ],
          ),
        );
      },
      loading: () => const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      ),
      error: (error, stack) => Scaffold(
        appBar: AppBar(title: const Text('Error')),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 64, color: Colors.red),
              const SizedBox(height: 16),
              Text('Error loading patient: $error'),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Go Back'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Profile Tab - Patient header and basic info
  Widget _buildProfileTab(MaternalProfile patient) {
    final gestationWeeks = patient.lmp != null
        ? _calculateGestationWeeks(patient.lmp!)
        : null;

    return SingleChildScrollView(
      child: Column(
        children: [
          // Patient Header Card with Avatar
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(24),
            color: Theme.of(context).colorScheme.surface,
            child: Column(
              children: [
                // Avatar
                CircleAvatar(
                  radius: 50,
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  child: Text(
                    patient.clientName.isNotEmpty
                        ? patient.clientName[0].toUpperCase()
                        : '?',
                    style: const TextStyle(
                      fontSize: 40,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                // Patient Name
                Text(
                  patient.clientName,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                // Age and ANC Number
                Text(
                  '${patient.age} years • ${patient.ancNumber}',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 24),
                // Gravida, Parity, Gestation Cards
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.green.shade50,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildStatCard(
                        patient.gravida.toString(),
                        'Gravida',
                        Colors.green,
                      ),
                      _buildStatCard(
                        patient.parity.toString(),
                        'Parity',
                        Colors.green,
                      ),
                      _buildStatCard(
                        gestationWeeks != null ? '${gestationWeeks}w' : 'N/A',
                        'Gestation',
                        Colors.green,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Facility Information Section
          _buildSection(
            context,
            'Facility Information',
            Icons.local_hospital,
            [
              _buildInfoRow('Facility Name', patient.facilityName),
              _buildInfoRow('KMHFL Code', patient.kmhflCode),
              _buildInfoRow('ANC Number', patient.ancNumber),
              if (patient.pncNumber != null)
                _buildInfoRow('PNC Number', patient.pncNumber!),
            ],
          ),

          // Obstetric Information Section
          _buildSection(
            context,
            'Obstetric Information',
            Icons.pregnant_woman,
            [
              _buildInfoRow('Height', '${patient.heightCm} cm'),
              _buildInfoRow('Weight', '${patient.weightKg} kg'),
              if (patient.lmp != null)
                _buildInfoRow('LMP', _formatDate(patient.lmp!)),
              if (patient.edd != null)
                _buildInfoRow('EDD', _formatDate(patient.edd!)),
              if (patient.edd != null)
                _buildInfoRow(
                  'Days Until Due',
                  '${patient.edd!.difference(DateTime.now()).inDays} days',
                ),
            ],
          ),

          // Contact Information Section
          _buildSection(
            context,
            'Contact Information',
            Icons.contact_phone,
            [
              if (patient.telephone != null)
                _buildInfoRow('Phone', patient.telephone!),
              if (patient.county != null)
                _buildInfoRow('County', patient.county!),
              if (patient.subCounty != null)
                _buildInfoRow('Sub County', patient.subCounty!),
              if (patient.ward != null) _buildInfoRow('Ward', patient.ward!),
              if (patient.village != null)
                _buildInfoRow('Village', patient.village!),
            ],
          ),

          // Next of Kin Section
          if (patient.nextOfKinName != null)
            _buildSection(
              context,
              'Next of Kin',
              Icons.people,
              [
                _buildInfoRow('Name', patient.nextOfKinName!),
                if (patient.nextOfKinRelationship != null)
                  _buildInfoRow('Relationship', patient.nextOfKinRelationship!),
                if (patient.nextOfKinPhone != null)
                  _buildInfoRow('Phone', patient.nextOfKinPhone!),
              ],
            ),

          const SizedBox(height: 16),
        ],
      ),
    );
  }

  /// Medical History Tab
  Widget _buildMedicalHistoryTab(MaternalProfile patient) {
    final hasAnyCondition = patient.diabetes == true ||
        patient.hypertension == true ||
        patient.tuberculosis == true ||
        patient.bloodTransfusion == true ||
        patient.drugAllergy == true ||
        patient.previousCs == true;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!hasAnyCondition)
            Center(
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: Column(
                  children: [
                    Icon(
                      Icons.check_circle_outline,
                      size: 64,
                      color: Colors.green[300],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'No Medical Conditions Recorded',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
            ),

          // High Risk Conditions
          if (patient.diabetes == true ||
              patient.hypertension == true ||
              patient.tuberculosis == true)
            _buildSection(
              context,
              'High Risk Conditions',
              Icons.warning,
              [
                if (patient.diabetes == true)
                  _buildConditionCard(
                    'Diabetes',
                    Icons.medication,
                    Colors.red,
                  ),
                if (patient.hypertension == true)
                  _buildConditionCard(
                    'Hypertension',
                    Icons.favorite,
                    Colors.red,
                  ),
                if (patient.tuberculosis == true)
                  _buildConditionCard(
                    'Tuberculosis',
                    Icons.coronavirus,
                    Colors.red,
                  ),
              ],
            ),

          // Obstetric History
          if (patient.previousCs == true)
            _buildSection(
              context,
              'Obstetric History',
              Icons.history,
              [
                _buildConditionCard(
                  'Previous Cesarean Section',
                  Icons.local_hospital,
                  Colors.orange,
                ),
              ],
            ),

          // Allergies and Transfusions
          if (patient.drugAllergy == true || patient.bloodTransfusion == true)
            _buildSection(
              context,
              'Other Medical History',
              Icons.medical_information,
              [
                if (patient.drugAllergy == true)
                  _buildConditionCard(
                    'Drug Allergy: ${patient.allergyDetails ?? "Not specified"}',
                    Icons.warning_amber,
                    Colors.orange,
                  ),
                if (patient.bloodTransfusion == true)
                  _buildConditionCard(
                    'Previous Blood Transfusion',
                    Icons.bloodtype,
                    Colors.blue,
                  ),
              ],
            ),
            const SizedBox(height: 24),

// Immunization & Malaria Button
ElevatedButton.icon(
  onPressed: () {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ImmunizationMalariaScreen(
          patientId: widget.patientId,
          patient: patient,
        ),
      ),
    );
  },
  icon: const Icon(Icons.vaccines),
  label: const Text('View Immunization & Malaria'),
  style: ElevatedButton.styleFrom(
    minimumSize: const Size(double.infinity, 48),
  ),
),
const SizedBox(height: 12),

// Nutrition Button
ElevatedButton.icon(
  onPressed: () {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => NutritionTrackingScreen(
          patientId: widget.patientId,
          patient: patient,
        ),
      ),
    );
  },
  icon: const Icon(Icons.restaurant),
  label: const Text('View Nutrition Tracking'),
  style: ElevatedButton.styleFrom(
    minimumSize: const Size(double.infinity, 48),
  ),
),
        ],
      ),
    );
  }

  /// Lab Results Tab
Widget _buildLabResultsTab(MaternalProfile patient) {
  return Center(
    child: Padding(
      padding: const EdgeInsets.all(32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.science_outlined,
            size: 64,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            'Lab Results',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.grey[700],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'View and manage laboratory test results',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => LabResultsHistoryScreen(
                    patientId: widget.patientId,
                    patient: patient,
                  ),
                ),
              );
            },
            icon: const Icon(Icons.science),
            label: const Text('View Lab Results'),
            style: ElevatedButton.styleFrom(
              minimumSize: const Size(200, 48),
            ),
          ),
        ],
      ),
    ),
  );
}

  /// Visits Tab
  Widget _buildVisitsTab(MaternalProfile patient) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: ElevatedButton.icon(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ANCVisitHistoryScreen(
                    patientId: widget.patientId,
                    patient: patient,
                  ),
                ),
              );
            },
            icon: const Icon(Icons.history),
            label: const Text('View ANC Visit History'),
            style: ElevatedButton.styleFrom(
              minimumSize: const Size(double.infinity, 48),
            ),
          ),
        ),
        Expanded(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(32),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.event_note,
                    size: 64,
                    color: Colors.grey[400],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Visit Management',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[700],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'View and manage patient visits',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  /// Build a stat card (Gravida, Parity, Gestation)
  Widget _buildStatCard(String value, String label, Color color) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }

  /// Build a section with title and content
  Widget _buildSection(
    BuildContext context,
    String title,
    IconData icon,
    List<Widget> children,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 20, color: Theme.of(context).colorScheme.primary),
              const SizedBox(width: 8),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: children,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Build an information row
  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 140,
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
              style: const TextStyle(
                color: Colors.black87,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Build a condition card
  Widget _buildConditionCard(String condition, IconData icon, Color color) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              condition,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: color,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Calculate gestation weeks from LMP
  int _calculateGestationWeeks(DateTime lmp) {
    final now = DateTime.now();
    final difference = now.difference(lmp);
    return (difference.inDays / 7).floor();
  }

  /// Format date as DD/MM/YYYY
  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }
}