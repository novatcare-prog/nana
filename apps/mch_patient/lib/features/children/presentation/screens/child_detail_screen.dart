import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:mch_core/mch_core.dart';
import '../../../../core/providers/child_provider.dart';
import '../../../../core/theme/app_colors.dart';

class ChildDetailScreen extends ConsumerWidget {
  final String childId;

  const ChildDetailScreen({
    super.key,
    required this.childId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Get actual child data from provider
    final childAsync = ref.watch(childByIdProvider(childId));

    return childAsync.when(
      data: (child) {
        if (child == null) {
          return Scaffold(
            appBar: AppBar(title: const Text('Child Not Found')),
            body: const Center(
              child: Text('This child could not be found.'),
            ),
          );
        }
        
        return _buildChildDetail(context, child);
      },
      loading: () => Scaffold(
        appBar: AppBar(title: const Text('Loading...')),
        body: const Center(
          child: CircularProgressIndicator(color: Color(0xFFE91E63)),
        ),
      ),
      error: (error, stack) => Scaffold(
        appBar: AppBar(title: const Text('Error')),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error_outline, size: 64, color: Colors.red[300]),
              const SizedBox(height: 16),
              Text('Failed to load child: $error'),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => ref.invalidate(childByIdProvider(childId)),
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildChildDetail(BuildContext context, ChildProfile child) {
    final isMale = child.sex.toLowerCase() == 'male';
    
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(child.childName),
        backgroundColor: isMale ? Colors.blue : const Color(0xFFE91E63),
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Share feature coming soon')),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Child Profile Header
            _ChildProfileHeader(child: child),

            const SizedBox(height: 16),

            // Quick Actions
            _QuickActionsSection(childId: child.id!),

            const SizedBox(height: 16),

            // Quick Stats
            _QuickStatsSection(child: child),

            const SizedBox(height: 16),

            // Birth Details
            _BirthDetailsSection(child: child),

            const SizedBox(height: 16),

            // Family Details
            _FamilyDetailsSection(child: child),

            const SizedBox(height: 16),

            // Health Status
            _HealthStatusSection(child: child),

            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}

// Child Profile Header
class _ChildProfileHeader extends StatelessWidget {
  final ChildProfile child;

  const _ChildProfileHeader({required this.child});

  @override
  Widget build(BuildContext context) {
    final age = _calculateAge(child.dateOfBirth);
    final isMale = child.sex.toLowerCase() == 'male';

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24.0),
      decoration: BoxDecoration(
        gradient: isMale
            ? LinearGradient(
                colors: [Colors.blue.shade400, Colors.blue.shade600],
              )
            : LinearGradient(
                colors: [Colors.pink.shade400, Colors.pink.shade600],
              ),
      ),
      child: Column(
        children: [
          CircleAvatar(
            radius: 50,
            backgroundColor: Colors.white,
            child: Icon(
              isMale ? Icons.face_6 : Icons.face_3,
              size: 60,
              color: isMale ? Colors.blue : Colors.pink,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            child.childName,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            age,
            style: const TextStyle(
              fontSize: 16,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Born ${DateFormat('d MMMM yyyy').format(child.dateOfBirth)}',
            style: TextStyle(
              fontSize: 14,
              color: Colors.white.withOpacity(0.1),
            ),
          ),
          const SizedBox(height: 8),
          // Place of birth
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Text(
              '📍 ${child.placeOfBirth}',
              style: const TextStyle(
                fontSize: 12,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _calculateAge(DateTime birthDate) {
    final now = DateTime.now();
    final difference = now.difference(birthDate);
    final days = difference.inDays;
    
    if (days < 0) return 'Not born yet';
    if (days < 30) return '$days days old';
    if (days < 120) return '${(days / 7).floor()} weeks old';
    if (days < 365) {
      final months = (days / 30).floor();
      return '$months ${months == 1 ? 'month' : 'months'} old';
    }
    
    final years = days ~/ 365;
    final remainingMonths = ((days % 365) / 30).floor();
    if (remainingMonths > 0) {
      return '$years yr $remainingMonths mo old';
    }
    return '$years ${years == 1 ? 'year' : 'years'} old';
  }
}

// Quick Stats Section - Using real birth data
class _QuickStatsSection extends StatelessWidget {
  final ChildProfile child;

  const _QuickStatsSection({required this.child});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        children: [
          Expanded(
            child: _StatCard(
              icon: Icons.monitor_weight_outlined,
              label: 'Birth Weight',
              value: '${(child.birthWeightGrams / 1000).toStringAsFixed(2)} kg',
              color: AppColors.info,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _StatCard(
              icon: Icons.height,
              label: 'Birth Length',
              value: '${child.birthLengthCm.toStringAsFixed(1)} cm',
              color: AppColors.success,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _StatCard(
              icon: Icons.circle_outlined,
              label: 'Head Circ.',
              value: child.headCircumferenceCm != null 
                  ? '${child.headCircumferenceCm!.toStringAsFixed(1)} cm'
                  : 'N/A',
              color: AppColors.warning,
            ),
          ),
        ],
      ),
    );
  }
}

// Stat Card Widget
class _StatCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;

  const _StatCard({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Icon(icon, color: color, size: 28),
            const SizedBox(height: 8),
            Text(
              value,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                color: AppColors.grey600,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

// Birth Details Section
class _BirthDetailsSection extends StatelessWidget {
  final ChildProfile child;

  const _BirthDetailsSection({required this.child});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Birth Details',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  _DetailRow(
                    label: 'Gestation at Birth',
                    value: '${child.gestationAtBirthWeeks} weeks',
                  ),
                  const Divider(height: 24),
                  _DetailRow(
                    label: 'Birth Order',
                    value: child.birthOrder?.toString() ?? 'N/A',
                  ),
                  const Divider(height: 24),
                  _DetailRow(
                    label: 'Place of Birth',
                    value: child.placeOfBirth,
                  ),
                  if (child.healthFacilityName != null) ...[
                    const Divider(height: 24),
                    _DetailRow(
                      label: 'Facility Name',
                      value: child.healthFacilityName!,
                    ),
                  ],
                  if (child.birthNotificationNumber != null) ...[
                    const Divider(height: 24),
                    _DetailRow(
                      label: 'Birth Notification No.',
                      value: child.birthNotificationNumber!,
                    ),
                  ],
                  if (child.birthCertificateNumber != null) ...[
                    const Divider(height: 24),
                    _DetailRow(
                      label: 'Birth Certificate No.',
                      value: child.birthCertificateNumber!,
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Family Details Section
class _FamilyDetailsSection extends StatelessWidget {
  final ChildProfile child;

  const _FamilyDetailsSection({required this.child});

  @override
  Widget build(BuildContext context) {
    // Only show if there's family data
    if (child.motherName == null && child.fatherName == null && child.guardianName == null) {
      return const SizedBox.shrink();
    }
    
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Family Details',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  if (child.motherName != null)
                    _DetailRow(
                      label: 'Mother',
                      value: child.motherName!,
                      icon: Icons.woman,
                    ),
                  if (child.motherName != null && child.fatherName != null)
                    const Divider(height: 24),
                  if (child.fatherName != null)
                    _DetailRow(
                      label: 'Father',
                      value: child.fatherName!,
                      icon: Icons.man,
                    ),
                  if (child.guardianName != null) ...[
                    const Divider(height: 24),
                    _DetailRow(
                      label: 'Guardian',
                      value: child.guardianName!,
                      icon: Icons.person,
                    ),
                  ],
                  if (child.village != null || child.county != null) ...[
                    const Divider(height: 24),
                    _DetailRow(
                      label: 'Location',
                      value: [child.village, child.subCounty, child.county]
                          .where((e) => e != null)
                          .join(', '),
                      icon: Icons.location_on,
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Health Status Section
class _HealthStatusSection extends StatelessWidget {
  final ChildProfile child;

  const _HealthStatusSection({required this.child});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Health Status',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  _HealthIndicator(
                    label: 'HIV Status',
                    value: child.hivStatus ?? 'Not Tested',
                    isPositive: child.hivStatus?.toLowerCase() != 'positive',
                  ),
                  const Divider(height: 24),
                  _HealthIndicator(
                    label: 'TB Screening',
                    value: child.tbScreened == true 
                        ? (child.tbScreeningResult ?? 'Done')
                        : 'Not Screened',
                    isPositive: child.tbScreeningResult?.toLowerCase() != 'positive',
                  ),
                  const Divider(height: 24),
                  _HealthIndicator(
                    label: 'Breastfeeding',
                    value: child.breastfeedingWell == true 
                        ? 'Breastfeeding Well'
                        : child.breastfeedingPoorly == true
                            ? 'Breastfeeding Poorly'
                            : child.unableToBreastfeed == true
                                ? 'Unable to Breastfeed'
                                : 'Not Recorded',
                    isPositive: child.breastfeedingWell == true,
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

// Detail Row Widget
class _DetailRow extends StatelessWidget {
  final String label;
  final String value;
  final IconData? icon;

  const _DetailRow({
    required this.label,
    required this.value,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        if (icon != null) ...[
          Icon(icon, size: 20, color: Colors.grey[600]),
          const SizedBox(width: 12),
        ],
        Expanded(
          child: Text(
            label,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
            ),
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}

// Health Indicator Widget
class _HealthIndicator extends StatelessWidget {
  final String label;
  final String value;
  final bool isPositive;

  const _HealthIndicator({
    required this.label,
    required this.value,
    required this.isPositive,
  });

  @override
  Widget build(BuildContext context) {
    final color = isPositive ? AppColors.success : AppColors.warning;
    
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 14),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            value,
            style: TextStyle(
              color: color,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}

// Quick Actions Section - Navigation to child features
class _QuickActionsSection extends StatelessWidget {
  final String childId;

  const _QuickActionsSection({required this.childId});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        children: [
          Expanded(
            child: _ActionButton(
              icon: Icons.vaccines,
              label: 'Vaccinations',
              color: const Color(0xFF4CAF50),
              onTap: () => context.push('/child/$childId/vaccinations'),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _ActionButton(
              icon: Icons.show_chart,
              label: 'Growth Charts',
              color: const Color(0xFF2196F3),
              onTap: () => context.push('/child/$childId/growth'),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _ActionButton(
              icon: Icons.history,
              label: 'Visit History',
              color: const Color(0xFFFF9800),
              onTap: () => context.push('/child/$childId/visits'),
            ),
          ),
        ],
      ),
    );
  }
}

// Action Button Widget
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
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withOpacity(0.1)),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 28),
            const SizedBox(height: 8),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: color,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
