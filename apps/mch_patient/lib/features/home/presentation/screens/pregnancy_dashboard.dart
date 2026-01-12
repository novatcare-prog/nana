import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:mch_core/mch_core.dart';
import '../../../../core/providers/auth_provider.dart';
import '../../../../core/providers/maternal_profile_provider.dart';
import '../../../../core/providers/child_provider.dart';
import '../../../../core/providers/appointment_provider.dart';

/// Pregnancy Dashboard Screen
/// Shown when the logged-in user has an active pregnancy
class PregnancyDashboard extends ConsumerStatefulWidget {
  const PregnancyDashboard({super.key});

  @override
  ConsumerState<PregnancyDashboard> createState() => _PregnancyDashboardState();
}

class _PregnancyDashboardState extends ConsumerState<PregnancyDashboard>
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
    final user = ref.watch(currentUserProvider);
    final userName = user?.userMetadata?['full_name'] as String? ?? 'Mama';
    final maternalProfileAsync = ref.watch(currentMaternalProfileProvider);
    final pregnancyWeek = ref.watch(pregnancyWeekProvider);
    final daysUntilDue = ref.watch(daysUntilDueDateProvider);

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScrolled) => [
            // App Bar
            SliverAppBar(
              floating: true,
              pinned: true,
              backgroundColor: Theme.of(context).cardTheme.color ?? Theme.of(context).scaffoldBackgroundColor,
              elevation: 0,
              title: Row(
                children: [
                  CircleAvatar(
                    backgroundColor: const Color(0xFFE91E63),
                    radius: 18,
                    child: Text(
                      userName.isNotEmpty ? userName[0].toUpperCase() : "M",
                      style: const TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                  Text(
                    _getTimeGreeting(),
                    style: TextStyle(fontSize: 10, color: Theme.of(context).textTheme.bodySmall?.color),
                  ),
                  Text(
                    userName,
                    style: TextStyle(
                      color: Theme.of(context).textTheme.bodyLarge?.color,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ],
          ),
          actions: [
            IconButton(
              icon: Icon(Icons.notifications_outlined, color: Theme.of(context).textTheme.bodyLarge?.color),
              onPressed: () {},
            ),
          ],
              bottom: TabBar(
                controller: _tabController,
                labelColor: const Color(0xFFE91E63),
                unselectedLabelColor: Colors.grey[600],
                indicatorColor: const Color(0xFFE91E63),
                indicatorWeight: 3,
                tabs: const [
                  Tab(
                    icon: Icon(Icons.pregnant_woman),
                    text: 'My Pregnancy',
                  ),
                  Tab(
                    icon: Icon(Icons.child_care),
                    text: 'My Children',
                  ),
                ],
              ),
            ),
          ],
          body: TabBarView(
            controller: _tabController,
            children: [
              // Tab 1: Pregnancy View
              _PregnancyView(
                maternalProfileAsync: maternalProfileAsync,
                pregnancyWeek: pregnancyWeek,
                daysUntilDue: daysUntilDue,
              ),
              // Tab 2: Children View
              const _ChildrenView(),
            ],
          ),
        ),
      ),
    );
  }

  String _getTimeGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Habari ya Asubuhi';
    if (hour < 16) return 'Habari ya Mchana';
    return 'Habari ya Jioni';
  }
}

/// Pregnancy View Tab Content
class _PregnancyView extends StatelessWidget {
  final AsyncValue maternalProfileAsync;
  final int? pregnancyWeek;
  final int? daysUntilDue;

  const _PregnancyView({
    required this.maternalProfileAsync,
    required this.pregnancyWeek,
    required this.daysUntilDue,
  });

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        await Future.delayed(const Duration(seconds: 1));
      },
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Pregnancy Progress Card
            _PregnancyProgressCard(
              currentWeek: pregnancyWeek ?? 0,
              daysUntilDue: daysUntilDue,
            ),

            const SizedBox(height: 20),

            // Next ANC Appointment Card
            const _NextAncAppointmentCard(),

            const SizedBox(height: 20),

            // Quick Actions
            const Text(
              'Quick Actions',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 12),
            _QuickActionsRow(),

            const SizedBox(height: 20),

            // Health Tips
            _PregnancyHealthTip(week: pregnancyWeek ?? 1),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}

/// Pregnancy Progress Card with Week Indicator and Visual Progress Bar
class _PregnancyProgressCard extends StatelessWidget {
  final int currentWeek;
  final int? daysUntilDue;

  const _PregnancyProgressCard({
    required this.currentWeek,
    this.daysUntilDue,
  });

  @override
  Widget build(BuildContext context) {
    final progress = (currentWeek / 40).clamp(0.0, 1.0);
    final trimester = _getTrimester(currentWeek);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFE91E63), Color(0xFF9C27B0)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFE91E63).withOpacity(0.1),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    trimester.toUpperCase(),
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.1),
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 1.2,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    textBaseline: TextBaseline.alphabetic,
                    children: [
                      Text(
                        'Week $currentWeek',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Text(
                        ' of 40',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 18,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              // Circular Progress Indicator
              SizedBox(
                width: 70,
                height: 70,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    CircularProgressIndicator(
                      value: progress,
                      strokeWidth: 6,
                      backgroundColor: Colors.white.withOpacity(0.1),
                      valueColor:
                          const AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                    Text(
                      '${(progress * 100).round()}%',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 24),

          // Linear Progress Bar
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Progress',
                    style: TextStyle(color: Colors.white70, fontSize: 12),
                  ),
                  Text(
                    daysUntilDue != null
                        ? '$daysUntilDue days to go'
                        : 'Calculating...',
                    style: const TextStyle(color: Colors.white70, fontSize: 12),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: LinearProgressIndicator(
                  value: progress,
                  minHeight: 10,
                  backgroundColor: Colors.white.withOpacity(0.1),
                  valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          // Trimester indicators
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _TrimesterBadge(
                label: '1st',
                isActive: currentWeek >= 1 && currentWeek <= 12,
                isCompleted: currentWeek > 12,
              ),
              _TrimesterBadge(
                label: '2nd',
                isActive: currentWeek >= 13 && currentWeek <= 26,
                isCompleted: currentWeek > 26,
              ),
              _TrimesterBadge(
                label: '3rd',
                isActive: currentWeek >= 27,
                isCompleted: false,
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _getTrimester(int week) {
    if (week <= 12) return '1st Trimester';
    if (week <= 26) return '2nd Trimester';
    return '3rd Trimester';
  }
}

/// Trimester Badge Widget
class _TrimesterBadge extends StatelessWidget {
  final String label;
  final bool isActive;
  final bool isCompleted;

  const _TrimesterBadge({
    required this.label,
    required this.isActive,
    required this.isCompleted,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: isActive
            ? Colors.white
            : isCompleted
                ? Colors.white.withOpacity(0.1)
                : Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (isCompleted)
            const Icon(Icons.check_circle, color: Colors.green, size: 12),
          if (isCompleted) const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              color: isActive
                  ? const Color(0xFFE91E63)
                  : isCompleted
                      ? Colors.grey[700]
                      : Colors.white70,
              fontSize: 11,
              fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}

/// Next ANC Appointment Card - Connected to real data
class _NextAncAppointmentCard extends ConsumerWidget {
  const _NextAncAppointmentCard();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final nextAppointmentAsync = ref.watch(nextAppointmentProvider);
    
    return nextAppointmentAsync.when(
      data: (appointment) {
        if (appointment == null) {
          return _buildNoAppointmentCard(context);
        }
        return _buildAppointmentCard(context, appointment);
      },
      loading: () => _buildLoadingCard(context),
      error: (_, __) => _buildNoAppointmentCard(context),
    );
  }
  
  Widget _buildLoadingCard(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).cardTheme.color ?? (isDark ? const Color(0xFF1E1E1E) : Colors.white),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: isDark ? Colors.grey.shade700 : Colors.grey.shade200),
      ),
      child: const Center(
        child: SizedBox(
          height: 40,
          width: 40,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            color: Color(0xFFE91E63),
          ),
        ),
      ),
    );
  }
  
  Widget _buildNoAppointmentCard(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).cardTheme.color ?? (isDark ? const Color(0xFF1E1E1E) : Colors.white),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: isDark ? Colors.grey.shade700 : Colors.grey.shade200),
        boxShadow: isDark ? null : [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              Icons.calendar_today,
              color: Colors.grey[400],
              size: 28,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'No Upcoming Appointments',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).textTheme.bodyLarge?.color,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Visit your health facility to schedule your next ANC visit',
                  style: TextStyle(
                    fontSize: 12,
                    color: Theme.of(context).textTheme.bodySmall?.color,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildAppointmentCard(BuildContext context, Appointment appointment) {
    final appointmentDate = appointment.appointmentDate;
    final daysUntil = appointmentDate.difference(DateTime.now()).inDays;
    
    // Format appointment type
    String typeLabel;
    switch (appointment.appointmentType) {
      case AppointmentType.ancVisit:
        typeLabel = 'Next ANC Visit';
        break;
      case AppointmentType.pncVisit:
        typeLabel = 'Next PNC Visit';
        break;
      case AppointmentType.immunization:
        typeLabel = 'Immunization';
        break;
      case AppointmentType.labTest:
        typeLabel = 'Lab Test';
        break;
      case AppointmentType.ultrasound:
        typeLabel = 'Ultrasound';
        break;
      default:
        typeLabel = 'Next Appointment';
    }
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).cardTheme.color ?? (isDark ? const Color(0xFF1E1E1E) : Colors.white),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: isDark ? Colors.grey.shade700 : Colors.grey.shade200),
        boxShadow: isDark ? null : [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          // Calendar Icon
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: const Color(0xFFE91E63).withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  DateFormat('dd').format(appointmentDate),
                  style: const TextStyle(
                    color: Color(0xFFE91E63),
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  DateFormat('MMM').format(appointmentDate).toUpperCase(),
                  style: const TextStyle(
                    color: Color(0xFFE91E63),
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          // Appointment Details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  typeLabel,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  DateFormat('EEEE, MMMM d').format(appointmentDate),
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey[600],
                  ),
                ),
                if (appointment.facilityName.isNotEmpty) ...[
                  const SizedBox(height: 2),
                  Text(
                    appointment.facilityName,
                    style: TextStyle(
                      fontSize: 11,
                      color: Colors.grey[500],
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
                const SizedBox(height: 4),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: daysUntil <= 3
                        ? Colors.orange.withOpacity(0.1)
                        : Colors.green.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    daysUntil == 0
                        ? 'Today'
                        : daysUntil == 1
                            ? 'Tomorrow'
                            : 'In $daysUntil days',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: daysUntil <= 3 ? Colors.orange[800] : Colors.green[800],
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Arrow
          Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey[400]),
        ],
      ),
    );
  }
}

/// Quick Actions Row
class _QuickActionsRow extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _QuickActionButton(
            icon: Icons.medical_services_outlined,
            label: 'ANC Records',
            color: const Color(0xFFE91E63),
            onTap: () {},
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _QuickActionButton(
            icon: Icons.science_outlined,
            label: 'Lab Results',
            color: const Color(0xFF9C27B0),
            onTap: () {},
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _QuickActionButton(
            icon: Icons.emergency_outlined,
            label: 'Emergency',
            color: Colors.red,
            onTap: () {},
          ),
        ),
      ],
    );
  }
}

class _QuickActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _QuickActionButton({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: Theme.of(context).cardTheme.color ?? (isDark ? const Color(0xFF1E1E1E) : Colors.white),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: isDark ? Colors.grey.shade700 : Colors.grey.shade200),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 28),
            const SizedBox(height: 8),
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: Theme.of(context).textTheme.bodyLarge?.color,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

/// Pregnancy Health Tip based on current week
class _PregnancyHealthTip extends StatelessWidget {
  final int week;

  const _PregnancyHealthTip({required this.week});

  @override
  Widget build(BuildContext context) {
    final tip = _getTipForWeek(week);

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFFFCE4EC), // Light pink
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.lightbulb_outline, color: Color(0xFFE91E63), size: 24),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'WEEK TIP',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFE91E63),
                    letterSpacing: 1.2,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  tip,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[800],
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _getTipForWeek(int week) {
    if (week <= 12) {
      return 'First trimester is crucial! Take your folic acid supplements daily and stay hydrated.';
    } else if (week <= 20) {
      return 'You may start feeling baby movements soon! Continue eating iron-rich foods like spinach and beans.';
    } else if (week <= 28) {
      return 'Your baby is growing rapidly. Rest when needed and keep attending your ANC appointments.';
    } else if (week <= 36) {
      return 'Start preparing for delivery. Pack your hospital bag and know the signs of labor.';
    } else {
      return 'Baby could arrive any day! Rest well and contact your health facility if you experience contractions.';
    }
  }
}

/// Children View Tab Content - Connected to real data
class _ChildrenView extends ConsumerWidget {
  const _ChildrenView();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final childrenAsync = ref.watch(patientChildrenProvider);
    
    return childrenAsync.when(
      data: (children) {
        if (children.isEmpty) {
          return _buildEmptyState(context);
        }
        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'My Children',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  Text(
                    '${children.length} ${children.length == 1 ? 'child' : 'children'}',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              
              // Real children list
              ...children.map((child) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: _ChildCard(
                  name: child.childName,
                  age: _calculateAge(child.dateOfBirth),
                  sex: child.sex,
                  onTap: () => context.push('/child/${child.id}'),
                ),
              )),
              
              const SizedBox(height: 12),

              // Add Child Button
              OutlinedButton.icon(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Add Child feature coming soon'),
                      backgroundColor: Color(0xFFE91E63),
                    ),
                  );
                },
                icon: const Icon(Icons.add),
                label: const Text('Add Child'),
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                  foregroundColor: const Color(0xFFE91E63),
                  side: const BorderSide(color: Color(0xFFE91E63)),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ],
          ),
        );
      },
      loading: () => const Center(
        child: CircularProgressIndicator(color: Color(0xFFE91E63)),
      ),
      error: (error, stack) => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 48, color: Colors.red[300]),
            const SizedBox(height: 16),
            Text('Failed to load children: $error'),
            ElevatedButton(
              onPressed: () => ref.invalidate(patientChildrenProvider),
              child: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.pink.shade50,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.child_care,
                size: 48,
                color: Colors.pink.shade200,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'No Children Yet',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.grey[800],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Children will appear here after delivery registration at your health facility.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  String _calculateAge(DateTime birthDate) {
    final now = DateTime.now();
    final difference = now.difference(birthDate);
    final days = difference.inDays;

    if (days < 0) return 'Not born yet';
    if (days < 30) return '$days days';
    if (days < 120) return '${(days / 7).floor()} weeks';
    if (days < 365) return '${(days / 30).floor()} months';
    return '${(days / 365).floor()} years';
  }
}

/// Child Card Widget
class _ChildCard extends StatelessWidget {
  final String name;
  final String age;
  final String sex;
  final VoidCallback? onTap;

  const _ChildCard({
    required this.name,
    required this.age,
    required this.sex,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isMale = sex.toLowerCase() == 'male';
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Theme.of(context).cardTheme.color ?? (isDark ? const Color(0xFF1E1E1E) : Colors.white),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: isDark ? Colors.grey.shade700 : Colors.grey.shade200),
        ),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: isMale 
                  ? Colors.blue.withOpacity(0.1)
                  : Colors.pink.withOpacity(0.1),
              radius: 24,
              child: Icon(
                isMale ? Icons.face_6 : Icons.face_3,
                color: isMale ? Colors.blue : Colors.pink,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).textTheme.bodyLarge?.color,
                    ),
                  ),
                  Text(
                    '$age • $sex',
                    style: TextStyle(
                      fontSize: 13,
                      color: Theme.of(context).textTheme.bodySmall?.color,
                    ),
                  ),
                ],
              ),
            ),
            Icon(Icons.arrow_forward_ios, size: 14, color: Theme.of(context).textTheme.bodySmall?.color),
          ],
        ),
      ),
    );
  }
}
