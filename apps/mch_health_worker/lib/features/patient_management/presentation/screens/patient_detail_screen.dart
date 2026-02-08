import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mch_core/mch_core.dart';
import '../../../../core/providers/supabase_providers.dart';
import '../../../../core/providers/lab_result_providers.dart';
import 'anc_visit_history_screen.dart';
import 'patient_edit_screen.dart';
import 'lab_results_history_screen.dart';
import '../../presentation/screens/immunization_malaria_screen.dart';
import '../../presentation/screens/nutrition_tracking_screen.dart';
import '../../presentation/screens/record_delivery_screen.dart';
import '../../presentation/screens/children_list_screen.dart';
import 'postnatal_screen.dart';
import 'anc_visit_recording_screen.dart';

/// Clean Patient Detail Screen
class PatientDetailScreen extends ConsumerStatefulWidget {
  final String patientId;

  const PatientDetailScreen({super.key, required this.patientId});

  @override
  ConsumerState<PatientDetailScreen> createState() =>
      _PatientDetailScreenState();
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
        return _buildScreen(context, patient);
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
              const Icon(Icons.error_outline, size: 48, color: Colors.red),
              const SizedBox(height: 16),
              Text('Error: $error'),
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

  Widget _buildScreen(BuildContext context, MaternalProfile patient) {
    return Scaffold(
      appBar: AppBar(
        title: Text(patient.clientName),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            tooltip: 'Edit Patient',
            onPressed: () async {
              final result = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => PatientEditScreen(profile: patient),
                ),
              );
              if (result == true) {
                ref.invalidate(maternalProfilesProvider);
              }
            },
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          indicatorColor: Colors.white,
          indicatorWeight: 3,
          labelStyle: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
          unselectedLabelStyle: const TextStyle(
            fontWeight: FontWeight.normal,
            fontSize: 14,
          ),
          tabs: const [
            Tab(text: 'Profile'),
            Tab(text: 'Medical'),
            Tab(text: 'Lab Results'),
            Tab(text: 'Visits'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _ProfileTab(patient: patient),
          _MedicalTab(patient: patient, patientId: widget.patientId),
          _LabResultsTab(patient: patient, patientId: widget.patientId),
          _VisitsTab(patient: patient, patientId: widget.patientId),
        ],
      ),
    );
  }
}

// ============= PROFILE TAB =============
class _ProfileTab extends StatelessWidget {
  final MaternalProfile patient;

  const _ProfileTab({required this.patient});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final gestationWeeks = patient.lmp != null
        ? DateTime.now().difference(patient.lmp!).inDays ~/ 7
        : null;

    return LayoutBuilder(
      builder: (context, constraints) {
        final isDesktop = constraints.maxWidth >= 900;

        if (isDesktop) {
          // Desktop: Two-column layout with centered, constrained content
          return SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1200),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Left Column: Header Card
                    SizedBox(
                      width: 380,
                      child: Column(
                        children: [
                          _buildHeaderCard(context, theme, gestationWeeks),
                          const SizedBox(height: 16),
                          // Next of Kin
                          if (patient.nextOfKinName != null)
                            _buildInfoSection(
                              context,
                              'Next of Kin',
                              Icons.people,
                              [
                                _InfoItem('Name', patient.nextOfKinName!),
                                if (patient.nextOfKinRelationship != null)
                                  _InfoItem('Relationship',
                                      patient.nextOfKinRelationship!),
                                if (patient.nextOfKinPhone != null)
                                  _InfoItem('Phone', patient.nextOfKinPhone!),
                              ],
                            ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 24),
                    // Right Columns: Info Cards in a grid
                    Expanded(
                      child: Wrap(
                        spacing: 16,
                        runSpacing: 16,
                        children: [
                          // Facility Info
                          SizedBox(
                            width: 360,
                            child: _buildInfoSection(
                              context,
                              'Facility Information',
                              Icons.local_hospital,
                              [
                                _InfoItem('Facility', patient.facilityName),
                                _InfoItem('KMHFL Code', patient.kmhflCode),
                                _InfoItem('ANC Number', patient.ancNumber),
                                if (patient.pncNumber != null)
                                  _InfoItem('PNC Number', patient.pncNumber!),
                              ],
                            ),
                          ),
                          // Obstetric Info
                          SizedBox(
                            width: 360,
                            child: _buildInfoSection(
                              context,
                              'Obstetric Information',
                              Icons.pregnant_woman,
                              [
                                _InfoItem('Height', '${patient.heightCm} cm'),
                                _InfoItem('Weight', '${patient.weightKg} kg'),
                                if (patient.lmp != null)
                                  _InfoItem('LMP', _formatDate(patient.lmp!)),
                                if (patient.edd != null) ...[
                                  _InfoItem('EDD', _formatDate(patient.edd!)),
                                  _InfoItem(
                                    'Days Until Due',
                                    '${patient.edd!.difference(DateTime.now()).inDays} days',
                                  ),
                                ],
                              ],
                            ),
                          ),
                          // Contact Info
                          SizedBox(
                            width: 360,
                            child: _buildInfoSection(
                              context,
                              'Contact Information',
                              Icons.phone,
                              [
                                if (patient.telephone != null)
                                  _InfoItem('Phone', patient.telephone!),
                                if (patient.county != null)
                                  _InfoItem('County', patient.county!),
                                if (patient.subCounty != null)
                                  _InfoItem('Sub County', patient.subCounty!),
                                if (patient.ward != null)
                                  _InfoItem('Ward', patient.ward!),
                                if (patient.village != null)
                                  _InfoItem('Village', patient.village!),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }

        // Mobile: Original stacked layout
        return ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _buildHeaderCard(context, theme, gestationWeeks),
            const SizedBox(height: 16),
            _buildInfoSection(
                context, 'Facility Information', Icons.local_hospital, [
              _InfoItem('Facility', patient.facilityName),
              _InfoItem('KMHFL Code', patient.kmhflCode),
              _InfoItem('ANC Number', patient.ancNumber),
              if (patient.pncNumber != null)
                _InfoItem('PNC Number', patient.pncNumber!),
            ]),
            const SizedBox(height: 12),
            _buildInfoSection(
                context, 'Obstetric Information', Icons.pregnant_woman, [
              _InfoItem('Height', '${patient.heightCm} cm'),
              _InfoItem('Weight', '${patient.weightKg} kg'),
              if (patient.lmp != null)
                _InfoItem('LMP', _formatDate(patient.lmp!)),
              if (patient.edd != null) ...[
                _InfoItem('EDD', _formatDate(patient.edd!)),
                _InfoItem(
                  'Days Until Due',
                  '${patient.edd!.difference(DateTime.now()).inDays} days',
                ),
              ],
            ]),
            const SizedBox(height: 12),
            _buildInfoSection(context, 'Contact Information', Icons.phone, [
              if (patient.telephone != null)
                _InfoItem('Phone', patient.telephone!),
              if (patient.county != null) _InfoItem('County', patient.county!),
              if (patient.subCounty != null)
                _InfoItem('Sub County', patient.subCounty!),
              if (patient.ward != null) _InfoItem('Ward', patient.ward!),
              if (patient.village != null)
                _InfoItem('Village', patient.village!),
            ]),
            const SizedBox(height: 12),
            if (patient.nextOfKinName != null)
              _buildInfoSection(context, 'Next of Kin', Icons.people, [
                _InfoItem('Name', patient.nextOfKinName!),
                if (patient.nextOfKinRelationship != null)
                  _InfoItem('Relationship', patient.nextOfKinRelationship!),
                if (patient.nextOfKinPhone != null)
                  _InfoItem('Phone', patient.nextOfKinPhone!),
              ]),
            const SizedBox(height: 24),
          ],
        );
      },
    );
  }

  Widget _buildHeaderCard(
      BuildContext context, ThemeData theme, int? gestationWeeks) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: theme.colorScheme.outlineVariant.withOpacity(0.5),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            CircleAvatar(
              radius: 40,
              backgroundColor: theme.colorScheme.primary,
              child: Text(
                patient.clientName.isNotEmpty
                    ? patient.clientName[0].toUpperCase()
                    : '?',
                style: const TextStyle(
                  fontSize: 32,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              patient.clientName,
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 4),
            Text(
              '${patient.age} years • ${patient.ancNumber}',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _StatItem(value: '${patient.gravida}', label: 'Gravida'),
                _StatItem(value: '${patient.parity}', label: 'Parity'),
                _StatItem(
                  value: gestationWeeks != null ? '${gestationWeeks}w' : '-',
                  label: 'Gestation',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoSection(BuildContext context, String title, IconData icon,
      List<_InfoItem> items) {
    if (items.isEmpty) return const SizedBox.shrink();
    final theme = Theme.of(context);

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: theme.colorScheme.outlineVariant.withOpacity(0.5),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, size: 18, color: theme.colorScheme.primary),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const Divider(height: 24),
            ...items.map((item) => Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: 110,
                        child: Text(
                          item.label,
                          style:
                              TextStyle(color: Colors.grey[600], fontSize: 13),
                        ),
                      ),
                      Expanded(
                        child: Text(
                          item.value,
                          style: const TextStyle(
                              fontWeight: FontWeight.w500, fontSize: 13),
                        ),
                      ),
                    ],
                  ),
                )),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}

// ============= MEDICAL TAB =============
class _MedicalTab extends StatelessWidget {
  final MaternalProfile patient;
  final String patientId;

  const _MedicalTab({required this.patient, required this.patientId});

  bool get _hasConditions =>
      patient.diabetes == true ||
      patient.hypertension == true ||
      patient.tuberculosis == true ||
      patient.bloodTransfusion == true ||
      patient.drugAllergy == true ||
      patient.previousCs == true;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // Conditions
        if (!_hasConditions)
          Card(
            child: Padding(
              padding: const EdgeInsets.all(32),
              child: Column(
                children: [
                  Icon(Icons.check_circle, size: 48, color: Colors.green[400]),
                  const SizedBox(height: 12),
                  Text(
                    'No Medical Conditions',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey[700],
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'No conditions recorded for this patient',
                    style: TextStyle(color: Colors.grey[500]),
                  ),
                ],
              ),
            ),
          )
        else ...[
          if (patient.diabetes == true ||
              patient.hypertension == true ||
              patient.tuberculosis == true)
            _ConditionSection(
              title: 'High Risk Conditions',
              conditions: [
                if (patient.diabetes == true)
                  const _Condition('Diabetes', Icons.medication, Colors.red),
                if (patient.hypertension == true)
                  const _Condition('Hypertension', Icons.favorite, Colors.red),
                if (patient.tuberculosis == true)
                  const _Condition(
                      'Tuberculosis', Icons.coronavirus, Colors.red),
              ],
            ),
          if (patient.previousCs == true)
            const _ConditionSection(
              title: 'Obstetric History',
              conditions: [
                _Condition('Previous Cesarean Section', Icons.local_hospital,
                    Colors.orange),
              ],
            ),
          if (patient.drugAllergy == true || patient.bloodTransfusion == true)
            _ConditionSection(
              title: 'Other History',
              conditions: [
                if (patient.drugAllergy == true)
                  _Condition(
                    'Drug Allergy: ${patient.allergyDetails ?? "Not specified"}',
                    Icons.warning_amber,
                    Colors.orange,
                  ),
                if (patient.bloodTransfusion == true)
                  const _Condition(
                      'Blood Transfusion', Icons.bloodtype, Colors.blue),
              ],
            ),
        ],

        const SizedBox(height: 24),

        // Action Buttons
        Text(
          'Actions',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 12),

        _ActionButton(
          icon: Icons.child_care,
          label: 'Record Delivery',
          color: Colors.pink,
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => RecordDeliveryScreen(
                patientId: patientId,
                patient: patient,
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),

        _ActionButton(
          icon: Icons.child_friendly,
          label: 'View Children',
          color: Colors.purple,
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => ChildrenListScreen(
                maternalProfileId: patientId,
                mother: patient,
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),

        _ActionButton(
          icon: Icons.vaccines,
          label: 'Immunization & Malaria',
          color: Colors.teal,
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => ImmunizationMalariaScreen(
                patientId: patientId,
                patient: patient,
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),

        _ActionButton(
          icon: Icons.restaurant,
          label: 'Nutrition Tracking',
          color: Colors.green,
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => NutritionTrackingScreen(
                patientId: patientId,
                patient: patient,
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),

        _ActionButton(
          icon: Icons.pregnant_woman,
          label: 'Postnatal Care',
          color: Colors.indigo,
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => PostnatalCareScreen(maternalProfile: patient),
            ),
          ),
        ),

        const SizedBox(height: 24),
      ],
    );
  }
}

// ============= LAB RESULTS TAB =============
class _LabResultsTab extends ConsumerWidget {
  final MaternalProfile patient;
  final String patientId;

  const _LabResultsTab({required this.patient, required this.patientId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final labResultsAsync = ref.watch(patientLabResultsProvider(patientId));

    return labResultsAsync.when(
      data: (results) {
        if (results.isEmpty) {
          return _buildEmptyState(context);
        }

        final abnormalCount = results.where((r) => r.isAbnormal).length;

        return ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Summary
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _SummaryItem('${results.length}', 'Total', Colors.blue),
                    _SummaryItem('$abnormalCount', 'Abnormal', Colors.red),
                    _SummaryItem(
                      '${results.length - abnormalCount}',
                      'Normal',
                      Colors.green,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Results List
            ...results.map((result) => _buildLabResultCard(context, result)),

            const SizedBox(height: 80),
          ],
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, _) => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 48, color: Colors.red),
            const SizedBox(height: 16),
            Text('Error loading results: $error'),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.science_outlined, size: 64, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text(
            'No Lab Results',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'No laboratory tests recorded yet',
            style: TextStyle(color: Colors.grey[500]),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => LabResultsHistoryScreen(
                  patientId: patientId,
                  patient: patient,
                ),
              ),
            ),
            icon: const Icon(Icons.add),
            label: const Text('Add Lab Result'),
          ),
        ],
      ),
    );
  }

  Widget _buildLabResultCard(BuildContext context, LabResult result) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor:
              result.isAbnormal ? Colors.red.shade100 : Colors.green.shade100,
          child: Icon(
            result.isAbnormal ? Icons.warning : Icons.check,
            color: result.isAbnormal ? Colors.red : Colors.green,
            size: 20,
          ),
        ),
        title: Text(
          result.testName,
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        subtitle: Text(
          '${result.resultValue}${result.resultUnit != null ? " ${result.resultUnit}" : ""}',
          style: TextStyle(
            color: result.isAbnormal ? Colors.red : null,
            fontWeight: result.isAbnormal ? FontWeight.w600 : null,
          ),
        ),
        trailing: Text(
          _formatDate(result.testDate),
          style: Theme.of(context).textTheme.bodySmall,
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}

// ============= VISITS TAB =============
class _VisitsTab extends StatelessWidget {
  final MaternalProfile patient;
  final String patientId;

  const _VisitsTab({required this.patient, required this.patientId});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Record New Visit
          ElevatedButton.icon(
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => ANCVisitRecordingScreen(
                  patientId: patientId,
                  patient: patient,
                ),
              ),
            ),
            icon: const Icon(Icons.add),
            label: const Text('Record New Visit'),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
          ),
          const SizedBox(height: 12),

          // View History
          OutlinedButton.icon(
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => ANCVisitHistoryScreen(
                  patientId: patientId,
                  patient: patient,
                ),
              ),
            ),
            icon: const Icon(Icons.history),
            label: const Text('View Visit History'),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
          ),

          const SizedBox(height: 32),

          // Placeholder
          Expanded(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.event_note, size: 64, color: Colors.grey[300]),
                  const SizedBox(height: 16),
                  Text(
                    'Visit Management',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Record and manage patient visits',
                    style: TextStyle(color: Colors.grey[500]),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ============= HELPER WIDGETS =============

class _StatItem extends StatelessWidget {
  final String value;
  final String label;

  const _StatItem({required this.value, required this.label});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: theme.colorScheme.primary,
          ),
        ),
        const SizedBox(height: 2),
        Text(label, style: TextStyle(fontSize: 12, color: Colors.grey[600])),
      ],
    );
  }
}

class _InfoItem {
  final String label;
  final String value;

  const _InfoItem(this.label, this.value);
}

class _ConditionSection extends StatelessWidget {
  final String title;
  final List<_Condition> conditions;

  const _ConditionSection({required this.title, required this.conditions});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            ...conditions.map((c) => Container(
                  margin: const EdgeInsets.only(bottom: 8),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: c.color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      Icon(c.icon, color: c.color, size: 20),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          c.name,
                          style: TextStyle(
                            color: c.color,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                )),
          ],
        ),
      ),
    );
  }
}

class _Condition {
  final String name;
  final IconData icon;
  final Color color;

  const _Condition(this.name, this.icon, this.color);
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _ActionButton({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: color,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: Row(
            children: [
              Icon(icon, color: Colors.white),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  label,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 15,
                  ),
                ),
              ),
              const Icon(Icons.chevron_right, color: Colors.white70),
            ],
          ),
        ),
      ),
    );
  }
}

class _SummaryItem extends StatelessWidget {
  final String value;
  final String label;
  final Color color;

  const _SummaryItem(this.value, this.label, this.color);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        Text(label, style: TextStyle(fontSize: 12, color: Colors.grey[600])),
      ],
    );
  }
}
