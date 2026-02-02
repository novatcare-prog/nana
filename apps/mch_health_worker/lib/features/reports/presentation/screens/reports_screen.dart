import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:intl/intl.dart';

import 'high_risk_report_screen.dart';
import 'patients_due_soon_screen.dart';
import 'missed_appointments_screen.dart';
import 'anc_coverage_report_screen.dart';

/// Reports & Analytics Screen
/// Shows facility-level statistics and reports
class ReportsScreen extends ConsumerStatefulWidget {
  const ReportsScreen({super.key});

  @override
  ConsumerState<ReportsScreen> createState() => _ReportsScreenState();
}

class _ReportsScreenState extends ConsumerState<ReportsScreen> {
  bool _isLoading = true;
  Map<String, dynamic> _stats = {};
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadStats();
  }

  Future<void> _loadStats() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final supabase = Supabase.instance.client;

      // Get total patients
      final patientsResult = await supabase
          .from('maternal_profiles')
          .select('id')
          .count(CountOption.exact);

      // Get new patients this month
      final newPatientsResult = await supabase
          .from('maternal_profiles')
          .select('id')
          .gte(
              'created_at',
              DateTime(DateTime.now().year, DateTime.now().month, 1)
                  .toIso8601String())
          .count(CountOption.exact);

      // Get high risk patients (those with diabetes, hypertension, or HIV positive)
      final highRiskResult = await supabase
          .from('maternal_profiles')
          .select('id')
          .or('diabetes.eq.true,hypertension.eq.true,hiv_result.eq.positive')
          .count(CountOption.exact);

      // Get total ANC visits
      final ancVisitsResult = await supabase
          .from('anc_visits')
          .select('id')
          .count(CountOption.exact);

      // Get visits this week
      final weekStart =
          DateTime.now().subtract(Duration(days: DateTime.now().weekday - 1));
      final visitsThisWeekResult = await supabase
          .from('anc_visits')
          .select('id')
          .gte('visit_date', weekStart.toIso8601String())
          .count(CountOption.exact);

      // Get appointments today
      final today = DateTime.now();
      final appointmentsTodayResult = await supabase
          .from('appointments')
          .select('id')
          .gte('appointment_date',
              DateTime(today.year, today.month, today.day).toIso8601String())
          .lt(
              'appointment_date',
              DateTime(today.year, today.month, today.day + 1)
                  .toIso8601String())
          .count(CountOption.exact);

      // Get pending appointments
      final pendingAppointmentsResult = await supabase
          .from('appointments')
          .select('id')
          .eq('appointment_status', 'scheduled')
          .gte('appointment_date', DateTime.now().toIso8601String())
          .count(CountOption.exact);

      // Get immunizations given this month
      final immunizationsResult = await supabase
          .from('maternal_immunizations')
          .select('id')
          .gte(
              'dose_date',
              DateTime(DateTime.now().year, DateTime.now().month, 1)
                  .toIso8601String())
          .count(CountOption.exact);

      // Get count of patients with EDD in the future (active pregnancies)
      final activeResult = await supabase
          .from('maternal_profiles')
          .select('id')
          .gte('edd', DateTime.now().toIso8601String())
          .count(CountOption.exact);

      // Get delivered patients (EDD in the past)
      final deliveredResult = await supabase
          .from('maternal_profiles')
          .select('id')
          .lt('edd', DateTime.now().toIso8601String())
          .not('edd', 'is', null)
          .count(CountOption.exact);

      setState(() {
        _stats = {
          'totalPatients': patientsResult.count,
          'newThisMonth': newPatientsResult.count,
          'highRisk': highRiskResult.count,
          'totalAncVisits': ancVisitsResult.count,
          'visitsThisWeek': visitsThisWeekResult.count,
          'appointmentsToday': appointmentsTodayResult.count,
          'pendingAppointments': pendingAppointmentsResult.count,
          'immunizationsThisMonth': immunizationsResult.count,
          'activePatients': activeResult.count,
          'delivered': deliveredResult.count,
        };
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Reports & Analytics'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadStats,
            tooltip: 'Refresh',
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
              ? _buildErrorView(theme)
              : RefreshIndicator(
                  onRefresh: _loadStats,
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      final isDesktop = constraints.maxWidth >= 900;

                      if (isDesktop) {
                        return SingleChildScrollView(
                          padding: const EdgeInsets.all(24),
                          child: Center(
                            child: ConstrainedBox(
                              constraints: const BoxConstraints(maxWidth: 1300),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Header
                                  _buildHeader(theme),
                                  const SizedBox(height: 24),

                                  // Desktop: Two-column layout
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      // Left Column: Stats and Activity
                                      Expanded(
                                        flex: 5,
                                        child: Column(
                                          children: [
                                            _buildSummarySection(theme),
                                            const SizedBox(height: 20),
                                            _buildActivitySection(theme),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(width: 24),
                                      // Right Column: Status and Reports
                                      Expanded(
                                        flex: 5,
                                        child: Column(
                                          children: [
                                            _buildPatientStatusSection(theme),
                                            const SizedBox(height: 20),
                                            _buildQuickReportsSection(theme),
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

                      // Mobile layout
                      return ListView(
                        padding: const EdgeInsets.all(16),
                        children: [
                          _buildHeader(theme),
                          const SizedBox(height: 20),
                          _buildSummarySection(theme),
                          const SizedBox(height: 20),
                          _buildPatientStatusSection(theme),
                          const SizedBox(height: 20),
                          _buildActivitySection(theme),
                          const SizedBox(height: 20),
                          _buildQuickReportsSection(theme),
                          const SizedBox(height: 24),
                        ],
                      );
                    },
                  ),
                ),
    );
  }

  Widget _buildErrorView(ThemeData theme) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 64, color: theme.colorScheme.error),
            const SizedBox(height: 16),
            Text('Error loading statistics', style: theme.textTheme.titleLarge),
            const SizedBox(height: 8),
            Text(
              _error!,
              style: theme.textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            FilledButton.icon(
              onPressed: _loadStats,
              icon: const Icon(Icons.refresh),
              label: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(ThemeData theme) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            theme.colorScheme.primary,
            theme.colorScheme.primary.withOpacity(0.8),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.analytics, color: Colors.white, size: 32),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Facility Dashboard',
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Updated: ${DateFormat('MMM dd, HH:mm').format(DateTime.now())}',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: Colors.white70,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummarySection(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Overview',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        // First row of stat cards
        Row(
          children: [
            Expanded(
              child: _StatCard(
                title: 'Total Patients',
                value: '${_stats['totalPatients'] ?? 0}',
                icon: Icons.people,
                color: Colors.blue,
                subtitle: '+${_stats['newThisMonth'] ?? 0} this month',
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _StatCard(
                title: 'High Risk',
                value: '${_stats['highRisk'] ?? 0}',
                icon: Icons.warning_amber_rounded,
                color: Colors.red,
                subtitle: 'Needs attention',
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        // Second row of stat cards
        Row(
          children: [
            Expanded(
              child: _StatCard(
                title: 'ANC Visits',
                value: '${_stats['totalAncVisits'] ?? 0}',
                icon: Icons.medical_services,
                color: Colors.green,
                subtitle: '${_stats['visitsThisWeek'] ?? 0} this week',
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _StatCard(
                title: 'Appointments',
                value: '${_stats['appointmentsToday'] ?? 0}',
                icon: Icons.calendar_today,
                color: Colors.orange,
                subtitle: 'Scheduled today',
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildPatientStatusSection(ThemeData theme) {
    final total = (_stats['totalPatients'] ?? 1) as int;
    final active = (_stats['activePatients'] ?? 0) as int;
    final highRisk = (_stats['highRisk'] ?? 0) as int;
    final delivered = (_stats['delivered'] ?? 0) as int;

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
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
                Icon(
                  Icons.pie_chart_outline,
                  size: 20,
                  color: theme.colorScheme.primary,
                ),
                const SizedBox(width: 8),
                Text(
                  'Patient Status',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _ProgressRow(
              label: 'Active/Ongoing',
              value: active,
              total: total,
              color: Colors.green,
            ),
            const SizedBox(height: 14),
            _ProgressRow(
              label: 'High Risk',
              value: highRisk,
              total: total,
              color: Colors.red,
            ),
            const SizedBox(height: 14),
            _ProgressRow(
              label: 'Delivered',
              value: delivered,
              total: total,
              color: Colors.blue,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActivitySection(ThemeData theme) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
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
                Icon(
                  Icons.trending_up,
                  size: 20,
                  color: theme.colorScheme.primary,
                ),
                const SizedBox(width: 8),
                Text(
                  'This Month\'s Activity',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            // First row of activity tiles
            Row(
              children: [
                Expanded(
                  child: _ActivityTile(
                    icon: Icons.person_add,
                    label: 'New Registrations',
                    value: '${_stats['newThisMonth'] ?? 0}',
                    color: Colors.blue,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _ActivityTile(
                    icon: Icons.vaccines,
                    label: 'Immunizations',
                    value: '${_stats['immunizationsThisMonth'] ?? 0}',
                    color: Colors.purple,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            // Second row of activity tiles
            Row(
              children: [
                Expanded(
                  child: _ActivityTile(
                    icon: Icons.event_available,
                    label: 'Pending Appts',
                    value: '${_stats['pendingAppointments'] ?? 0}',
                    color: Colors.orange,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _ActivityTile(
                    icon: Icons.medical_services_outlined,
                    label: 'Visits This Week',
                    value: '${_stats['visitsThisWeek'] ?? 0}',
                    color: Colors.green,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickReportsSection(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Quick Reports',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        _ReportTile(
          icon: Icons.warning_amber_rounded,
          title: 'High Risk Patients',
          subtitle: 'Patients needing attention',
          iconColor: Colors.red,
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const HighRiskReportScreen()),
          ),
        ),
        _ReportTile(
          icon: Icons.schedule,
          title: 'Patients Due Soon',
          subtitle: 'Delivery within 30 days',
          iconColor: Colors.orange,
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const PatientsDueSoonScreen()),
          ),
        ),
        _ReportTile(
          icon: Icons.event_busy,
          title: 'Missed Appointments',
          subtitle: 'Follow up with no-shows',
          iconColor: Colors.deepPurple,
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const MissedAppointmentsScreen()),
          ),
        ),
        _ReportTile(
          icon: Icons.pregnant_woman,
          title: 'ANC Coverage Report',
          subtitle: 'Antenatal care statistics',
          iconColor: Colors.teal,
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const AncCoverageReportScreen()),
          ),
        ),
      ],
    );
  }
}

// ==================== HELPER WIDGETS ====================

class _StatCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;
  final String subtitle;

  const _StatCard({
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: theme.colorScheme.outlineVariant.withOpacity(0.5),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(icon, color: color, size: 20),
                ),
                const Spacer(),
              ],
            ),
            const SizedBox(height: 12),
            FittedBox(
              fit: BoxFit.scaleDown,
              alignment: Alignment.centerLeft,
              child: Text(
                value,
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 2),
            Text(
              title,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurface.withOpacity(0.7),
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 2),
            Text(
              subtitle,
              style: theme.textTheme.labelSmall?.copyWith(
                color: color,
                fontWeight: FontWeight.w500,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}

class _ProgressRow extends StatelessWidget {
  final String label;
  final int value;
  final int total;
  final Color color;

  const _ProgressRow({
    required this.label,
    required this.value,
    required this.total,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final percentage = total > 0 ? (value / total * 100) : 0.0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
              child: Text(
                label,
                style: theme.textTheme.bodyMedium,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(width: 8),
            Text(
              '$value (${percentage.toStringAsFixed(0)}%)',
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: color,
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: total > 0 ? value / total : 0,
            backgroundColor: color.withOpacity(0.15),
            valueColor: AlwaysStoppedAnimation(color),
            minHeight: 6,
          ),
        ),
      ],
    );
  }
}

class _ActivityTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;

  const _ActivityTile({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.08),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: color.withOpacity(0.2),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 26),
          const SizedBox(height: 8),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              value,
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: theme.textTheme.labelSmall?.copyWith(
              color: theme.colorScheme.onSurface.withOpacity(0.7),
            ),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}

class _ReportTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color iconColor;
  final VoidCallback onTap;

  const _ReportTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.iconColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 10),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
        side: BorderSide(
          color: theme.colorScheme.outlineVariant.withOpacity(0.5),
        ),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: iconColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: iconColor, size: 22),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurface.withOpacity(0.6),
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Icon(
                Icons.chevron_right,
                color: theme.colorScheme.onSurface.withOpacity(0.4),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
