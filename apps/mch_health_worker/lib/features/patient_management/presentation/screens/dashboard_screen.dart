import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mch_core/mch_core.dart';
import '../../../../core/providers/supabase_providers.dart';
import 'patient_detail_screen.dart';
import 'patient_registration_screen.dart';
import 'patient_list_screen.dart';
import '/../core/widgets/offline_indicator.dart';

/// Dashboard Screen - Main screen showing overview and quick actions
/// IMPROVED VERSION with UX fixes based on clinical workflow
class DashboardScreen extends ConsumerWidget {
  final Widget? drawer;

  const DashboardScreen({super.key, this.drawer});

  /// Helper method to get high risk reasons for a patient
  /// Based on MOH MCH Handbook 2020 - Page 26
  List<String> _getHighRiskReasons(MaternalProfile patient) {
    List<String> reasons = [];
    
    if (patient.diabetes == true) reasons.add('Diabetes');
    if (patient.hypertension == true) reasons.add('Hypertension');
    if (patient.previousCs == true) reasons.add('Previous CS');
    if (patient.age > 35) reasons.add('Age >35');
    if (patient.age < 18) reasons.add('Age <18');
    
    return reasons;
  }

  bool _isHighRisk(MaternalProfile patient) {
    return patient.diabetes == true ||
        patient.hypertension == true ||
        patient.previousCs == true ||
        patient.age > 35 ||
        patient.age < 18;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profilesAsync = ref.watch(maternalProfilesProvider);

    return Scaffold(
      drawer: drawer,
      appBar: AppBar(
        title: const Text('Dashboard'),
        actions: [
          const OfflineIndicator(),
          const SizedBox(width: 8),
          const SyncButton(),
          const SizedBox(width: 8),
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: 'Refresh data',
            onPressed: () {
              ref.invalidate(maternalProfilesProvider);
              ref.invalidate(statisticsProvider);
            },
          ),
        ],
      ),
      body: profilesAsync.when(
        data: (profiles) => _buildDashboard(context, ref, profiles),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 48, color: Colors.red),
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text('Error loading data: $error', textAlign: TextAlign.center),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => ref.invalidate(maternalProfilesProvider),
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const PatientRegistrationScreen(),
            ),
          );
        },
        icon: const Icon(Icons.person_add),
        label: const Text('New Patient'),
      ),
    );
  }

  Widget _buildDashboard(BuildContext context, WidgetRef ref, List<MaternalProfile> profiles) {
    // Calculate statistics
    final totalPatients = profiles.length;
    final today = DateTime.now();

    // Safe calculation for due this week
    final dueThisWeek = profiles.where((p) {
      if (p.edd == null) return false;
      final daysUntilDue = p.edd!.difference(today).inDays;
      return daysUntilDue >= 0 && daysUntilDue <= 7;
    }).length;

    final highRisk = profiles.where(_isHighRisk).length;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Date Card
          Card(
            color: Theme.of(context).colorScheme.primaryContainer,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  const Icon(Icons.calendar_today, size: 32),
                  const SizedBox(width: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _formatDate(today),
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const Text('Today'),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Statistics Cards
          Row(
            children: [
              Expanded(
                child: _buildStatCard(
                  context,
                  'Total Patients',
                  totalPatients.toString(),
                  Icons.people,
                  Colors.blue,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildStatCard(
                  context,
                  'Due This Week',
                  dueThisWeek.toString(),
                  Icons.event,
                  Colors.orange,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildStatCard(
                  context,
                  'High Risk',
                  highRisk.toString(),
                  Icons.warning,
                  Colors.red,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildStatCard(
                  context,
                  'Active',
                  totalPatients.toString(),
                  Icons.check_circle,
                  Colors.green,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Quick Actions - IMPROVED (Removed redundant New Patient)
          const Text(
            'Quick Actions',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              // IMPROVED: Navigate to patient list with search instead of separate search
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const PatientListScreen(),
                      ),
                    );
                  },
                  icon: const Icon(Icons.search),
                  label: const Text('Search Patients'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.all(16),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              // IMPROVED: Replace "New Patient" with "View All Patients"
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const PatientListScreen(),
                      ),
                    );
                  },
                  icon: const Icon(Icons.list),
                  label: const Text('All Patients'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.all(16),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // High Risk Patients Section
          if (highRisk > 0) ...[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'High Risk Patients',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                TextButton(
                  onPressed: () {
                    // Navigate to patient list with high risk filter
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const PatientListScreen(),
                      ),
                    );
                  },
                  child: const Text('View All'),
                ),
              ],
            ),
            const SizedBox(height: 12),
            ...profiles
                .where(_isHighRisk)
                .take(5)
                .map((patient) => _buildPatientCard(context, patient)),
            const SizedBox(height: 24),
          ],

          // Due Soon Section
          if (dueThisWeek > 0) ...[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Due This Week',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const PatientListScreen(),
                      ),
                    );
                  },
                  child: const Text('View All'),
                ),
              ],
            ),
            const SizedBox(height: 12),
            ...profiles
                .where((p) {
                  if (p.edd == null) return false;
                  final daysUntilDue = p.edd!.difference(today).inDays;
                  return daysUntilDue >= 0 && daysUntilDue <= 7;
                })
                .take(5)
                .map((patient) => _buildPatientCard(context, patient)),
          ],

          // Recently Registered Section
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Recently Registered',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const PatientListScreen(),
                    ),
                  );
                },
                child: const Text('View All'),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ...profiles
              .take(5)
              .map((patient) => _buildPatientCard(context, patient)),
        ],
      ),
    );
  }

  Widget _buildStatCard(
    BuildContext context,
    String label,
    String value,
    IconData icon,
    Color color,
  ) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Icon(icon, size: 32, color: color),
            const SizedBox(height: 8),
            Text(
              value,
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
            ),
            Text(
              label,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPatientCard(BuildContext context, MaternalProfile patient) {
    // Safe calculation for days until due
    final daysUntilDue = patient.edd?.difference(DateTime.now()).inDays;
    final isHighRisk = _isHighRisk(patient);
    final highRiskReasons = _getHighRiskReasons(patient);

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        // IMPROVED: Neutral grey for default avatar
        leading: CircleAvatar(
          backgroundColor: isHighRisk ? Colors.red : Colors.grey[400],
          child: Text(
            patient.clientName.isNotEmpty 
                ? patient.clientName.substring(0, 1).toUpperCase() 
                : '?',
            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
        title: Text(
          patient.clientName,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // IMPROVED: Show "Not Assigned" if ANC is empty
            Text(
              patient.ancNumber.isNotEmpty 
                  ? 'ANC: ${patient.ancNumber}'
                  : 'ANC: Not Assigned',
            ),
            // IMPROVED: Safe EDD display
            Text(
              patient.edd != null 
                  ? 'EDD: ${_formatDate(patient.edd!)} (${daysUntilDue ?? 0} days)'
                  : 'EDD: Not set'
            ),
            // IMPROVED: Show specific high risk reasons
            if (isHighRisk && highRiskReasons.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Row(
                  children: [
                    const Icon(Icons.warning, size: 14, color: Colors.red),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        'High Risk: ${highRiskReasons.join(", ")}',
                        style: const TextStyle(
                          color: Colors.red,
                          fontWeight: FontWeight.bold,
                          fontSize: 11,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
        trailing: const Icon(Icons.chevron_right),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => PatientDetailScreen(
                patientId: patient.id!,
              ),
            ),
          );
        },
      ),
    );
  }

  String _formatDate(DateTime date) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    
    return '${days[date.weekday - 1]}, ${months[date.month - 1]} ${date.day}, ${date.year}';
  }
}