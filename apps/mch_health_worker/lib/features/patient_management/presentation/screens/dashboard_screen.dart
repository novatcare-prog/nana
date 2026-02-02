import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mch_core/mch_core.dart';
import '../../../../core/providers/supabase_providers.dart';
import '../../../../core/providers/auth_providers.dart';
import '/core/widgets/offline_indicator.dart';
import 'patient_detail_screen.dart';
import 'patient_registration_screen.dart';
import 'patient_list_screen.dart';
import '../../../external_patient/presentation/screens/qrcode_scanner_screen.dart';

class DashboardScreen extends ConsumerWidget {
  final Widget? drawer;

  const DashboardScreen({super.key, this.drawer});

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
    final userProfile = ref.watch(currentUserProfileProvider);

    return Scaffold(
      drawer: drawer,
      appBar: AppBar(
        title: const Text('Dashboard'),
        elevation: 0,
        actions: [
          const OfflineIndicator(),
          const SizedBox(width: 4),
          const SyncButton(),
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: 'Refresh data',
            onPressed: () => ref.invalidate(maternalProfilesProvider),
          ),
        ],
      ),
      body: profilesAsync.when(
        data: (profiles) =>
            _buildDashboard(context, ref, profiles, userProfile),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => _buildErrorState(context, ref, error),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (_) => const PatientRegistrationScreen()),
          );
        },
        icon: const Icon(Icons.person_add),
        label: const Text('New Patient'),
      ),
    );
  }

  Widget _buildErrorState(BuildContext context, WidgetRef ref, Object error) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 48, color: Colors.red),
            const SizedBox(height: 16),
            Text(
              'Error loading data',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Text(
              '$error',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () => ref.invalidate(maternalProfilesProvider),
              icon: const Icon(Icons.refresh),
              label: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDashboard(
    BuildContext context,
    WidgetRef ref,
    List<MaternalProfile> profiles,
    AsyncValue<UserProfile?> userProfileAsync,
  ) {
    final totalPatients = profiles.length;
    final today = DateTime.now();
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final screenWidth = MediaQuery.of(context).size.width;
    final isDesktop = screenWidth >= 900;

    final dueThisWeek = profiles.where((p) {
      if (p.edd == null) return false;
      final daysUntilDue = p.edd!.difference(today).inDays;
      return daysUntilDue >= 0 && daysUntilDue <= 7;
    }).length;

    final highRisk = profiles.where(_isHighRisk).length;

    if (isDesktop) {
      // Desktop: Two-column layout with constrained widths
      return SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1400),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Left Column: Welcome, Stats, Quick Actions
                Expanded(
                  flex: 4,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 500),
                        child:
                            _buildWelcomeCard(context, userProfileAsync, today),
                      ),
                      const SizedBox(height: 20),
                      _buildStatsRow(
                          context, totalPatients, dueThisWeek, highRisk),
                      const SizedBox(height: 24),
                      _buildQuickActions(context),
                    ],
                  ),
                ),
                const SizedBox(width: 24),
                // Right Column: Patient Lists
                Expanded(
                  flex: 6,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // High Risk Section
                      if (highRisk > 0) ...[
                        _buildSectionTitle(
                          context,
                          'High Risk Patients',
                          Icons.warning_amber_rounded,
                          Colors.red,
                          () => _navigateToPatientList(context),
                        ),
                        const SizedBox(height: 12),
                        _buildPatientCardGrid(
                          context,
                          profiles.where(_isHighRisk).take(4).toList(),
                        ),
                        const SizedBox(height: 24),
                      ],

                      // Due This Week Section
                      if (dueThisWeek > 0) ...[
                        _buildSectionTitle(
                          context,
                          'Due This Week',
                          Icons.schedule,
                          Colors.orange,
                          () => _navigateToPatientList(context),
                        ),
                        const SizedBox(height: 12),
                        _buildPatientCardGrid(
                          context,
                          profiles
                              .where((p) {
                                if (p.edd == null) return false;
                                final daysUntilDue =
                                    p.edd!.difference(today).inDays;
                                return daysUntilDue >= 0 && daysUntilDue <= 7;
                              })
                              .take(4)
                              .toList(),
                        ),
                        const SizedBox(height: 24),
                      ],

                      // Recent Patients Section
                      _buildSectionTitle(
                        context,
                        'Recent Patients',
                        Icons.people,
                        colorScheme.primary,
                        () => _navigateToPatientList(context),
                      ),
                      const SizedBox(height: 12),
                      _buildPatientCardGrid(context, profiles.take(6).toList()),
                      const SizedBox(height: 80),
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
        // Welcome Card
        _buildWelcomeCard(context, userProfileAsync, today),
        const SizedBox(height: 20),

        // Stats Row
        _buildStatsRow(context, totalPatients, dueThisWeek, highRisk),
        const SizedBox(height: 24),

        // Quick Actions
        _buildQuickActions(context),
        const SizedBox(height: 24),

        // High Risk Section
        if (highRisk > 0) ...[
          _buildSectionTitle(
            context,
            'High Risk Patients',
            Icons.warning_amber_rounded,
            Colors.red,
            () => _navigateToPatientList(context),
          ),
          const SizedBox(height: 12),
          ...profiles
              .where(_isHighRisk)
              .take(3)
              .map((p) => _buildPatientTile(context, p)),
          const SizedBox(height: 20),
        ],

        // Due This Week Section
        if (dueThisWeek > 0) ...[
          _buildSectionTitle(
            context,
            'Due This Week',
            Icons.schedule,
            Colors.orange,
            () => _navigateToPatientList(context),
          ),
          const SizedBox(height: 12),
          ...profiles
              .where((p) {
                if (p.edd == null) return false;
                final daysUntilDue = p.edd!.difference(today).inDays;
                return daysUntilDue >= 0 && daysUntilDue <= 7;
              })
              .take(3)
              .map((p) => _buildPatientTile(context, p)),
          const SizedBox(height: 20),
        ],

        // Recent Patients Section
        _buildSectionTitle(
          context,
          'Recent Patients',
          Icons.people,
          colorScheme.primary,
          () => _navigateToPatientList(context),
        ),
        const SizedBox(height: 12),
        ...profiles.take(5).map((p) => _buildPatientTile(context, p)),

        // Bottom spacing for FAB
        const SizedBox(height: 80),
      ],
    );
  }

  /// Builds a grid of patient cards for desktop view
  Widget _buildPatientCardGrid(
      BuildContext context, List<MaternalProfile> patients) {
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: patients.map((p) {
        return SizedBox(
          width: 340,
          child: _buildCompactPatientCard(context, p),
        );
      }).toList(),
    );
  }

  /// Compact patient card for desktop grid layout
  Widget _buildCompactPatientCard(
      BuildContext context, MaternalProfile patient) {
    final daysUntilDue = patient.edd?.difference(DateTime.now()).inDays;
    final isHighRisk = _isHighRisk(patient);
    final theme = Theme.of(context);

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: isHighRisk
              ? Colors.red.withOpacity(0.3)
              : theme.colorScheme.outlineVariant.withOpacity(0.5),
        ),
      ),
      child: InkWell(
        onTap: () {
          if (patient.id != null) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => PatientDetailScreen(patientId: patient.id!),
              ),
            );
          }
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            children: [
              CircleAvatar(
                radius: 22,
                backgroundColor: isHighRisk
                    ? Colors.red.shade100
                    : theme.colorScheme.primaryContainer,
                child: Text(
                  patient.clientName.isNotEmpty
                      ? patient.clientName[0].toUpperCase()
                      : '?',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: isHighRisk
                        ? Colors.red.shade700
                        : theme.colorScheme.onPrimaryContainer,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            patient.clientName,
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        if (isHighRisk)
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: Colors.red.shade100,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: const Text(
                              'HIGH',
                              style: TextStyle(
                                color: Colors.red,
                                fontSize: 9,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Text(
                          'ANC: ${patient.ancNumber.isNotEmpty ? patient.ancNumber : "N/A"}',
                          style: theme.textTheme.bodySmall,
                        ),
                        if (daysUntilDue != null && daysUntilDue >= 0) ...[
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 5, vertical: 1),
                            decoration: BoxDecoration(
                              color: daysUntilDue <= 7
                                  ? Colors.orange.shade100
                                  : Colors.grey.shade200,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              '${daysUntilDue}d',
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w600,
                                color: daysUntilDue <= 7
                                    ? Colors.orange.shade800
                                    : Colors.grey.shade700,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
              Icon(Icons.chevron_right, size: 20, color: Colors.grey[400]),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildWelcomeCard(
    BuildContext context,
    AsyncValue<UserProfile?> userProfileAsync,
    DateTime today,
  ) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Card(
      color: colorScheme.primary,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.wb_sunny_outlined,
                  color: Colors.white.withOpacity(0.9),
                  size: 20,
                ),
                const SizedBox(width: 8),
                Text(
                  _getGreeting(),
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.9),
                    fontSize: 14,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            userProfileAsync.when(
              data: (profile) => Text(
                profile?.fullName ?? 'Health Worker',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              loading: () => const Text(
                'Loading...',
                style: TextStyle(color: Colors.white70, fontSize: 18),
              ),
              error: (_, __) => const Text(
                'Health Worker',
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                const Icon(Icons.calendar_today,
                    color: Colors.white70, size: 14),
                const SizedBox(width: 6),
                Text(
                  _formatDate(today),
                  style: const TextStyle(color: Colors.white70, fontSize: 13),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatsRow(
    BuildContext context,
    int total,
    int dueSoon,
    int highRisk,
  ) {
    return Row(
      children: [
        Expanded(
          child: _StatCard(
            title: 'Total',
            value: '$total',
            icon: Icons.people,
            color: Colors.blue,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _StatCard(
            title: 'Due Soon',
            value: '$dueSoon',
            icon: Icons.event,
            color: Colors.orange,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _StatCard(
            title: 'High Risk',
            value: '$highRisk',
            icon: Icons.warning,
            color: Colors.red,
          ),
        ),
      ],
    );
  }

  Widget _buildQuickActions(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Quick Actions',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _ActionButton(
                icon: Icons.search,
                label: 'Search',
                onTap: () => _navigateToPatientList(context),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _ActionButton(
                icon: Icons.list_alt,
                label: 'All Patients',
                onTap: () => _navigateToPatientList(context),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _ActionButton(
                icon: Icons.qr_code_scanner,
                label: 'Scan QR',
                color: const Color(0xFF7B1FA2),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const QrCodeScannerScreen(),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSectionTitle(
    BuildContext context,
    String title,
    IconData icon,
    Color iconColor,
    VoidCallback onViewAll,
  ) {
    return Row(
      children: [
        Icon(icon, size: 20, color: iconColor),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            title,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
        ),
        TextButton(
          onPressed: onViewAll,
          child: const Text('View All'),
        ),
      ],
    );
  }

  Widget _buildPatientTile(BuildContext context, MaternalProfile patient) {
    final daysUntilDue = patient.edd?.difference(DateTime.now()).inDays;
    final isHighRisk = _isHighRisk(patient);
    final theme = Theme.of(context);

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: isHighRisk
              ? Colors.red.shade100
              : theme.colorScheme.primaryContainer,
          foregroundColor:
              isHighRisk ? Colors.red : theme.colorScheme.onPrimaryContainer,
          child: Text(
            patient.clientName.isNotEmpty
                ? patient.clientName[0].toUpperCase()
                : '?',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        title: Text(
          patient.clientName,
          style: const TextStyle(fontWeight: FontWeight.w600),
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              patient.ancNumber.isNotEmpty
                  ? 'ANC: ${patient.ancNumber}'
                  : 'ANC: Not Assigned',
              style: theme.textTheme.bodySmall,
              overflow: TextOverflow.ellipsis,
            ),
            if (patient.edd != null)
              Text(
                'EDD: ${_formatShortDate(patient.edd!)} (${daysUntilDue}d)',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: daysUntilDue != null && daysUntilDue <= 7
                      ? Colors.orange
                      : null,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            if (isHighRisk)
              Text(
                'High Risk: ${_getHighRiskReasons(patient).join(", ")}',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: Colors.red,
                  fontWeight: FontWeight.w500,
                ),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
          ],
        ),
        isThreeLine: true,
        trailing: const Icon(Icons.chevron_right),
        onTap: () {
          if (patient.id != null) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => PatientDetailScreen(patientId: patient.id!),
              ),
            );
          }
        },
      ),
    );
  }

  void _navigateToPatientList(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const PatientListScreen()),
    );
  }

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good Morning';
    if (hour < 17) return 'Good Afternoon';
    return 'Good Evening';
  }

  String _formatDate(DateTime date) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec'
    ];
    const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    return '${days[date.weekday - 1]}, ${months[date.month - 1]} ${date.day}, ${date.year}';
  }

  String _formatShortDate(DateTime date) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec'
    ];
    return '${months[date.month - 1]} ${date.day}';
  }
}

// ============= REUSABLE WIDGETS =============

class _StatCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;

  const _StatCard({
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
        child: Column(
          children: [
            Icon(icon, color: color, size: 28),
            const SizedBox(height: 8),
            Text(
              value,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              title,
              style: Theme.of(context).textTheme.bodySmall,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final Color? color;

  const _ActionButton({
    required this.icon,
    required this.label,
    required this.onTap,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final buttonColor = color ?? theme.colorScheme.primary;
    final isDark = theme.brightness == Brightness.dark;

    return Material(
      color: isDark ? const Color(0xFF2C2C2C) : Colors.white,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isDark ? Colors.grey.shade700 : Colors.grey.shade300,
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, color: buttonColor, size: 24),
              const SizedBox(height: 8),
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: isDark ? Colors.white : Colors.grey[800],
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
