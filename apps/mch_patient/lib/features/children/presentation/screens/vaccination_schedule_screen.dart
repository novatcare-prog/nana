import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:mch_core/mch_core.dart';
import '../../../../core/providers/child_provider.dart';
import '../../../../core/providers/immunization_provider.dart';
import '../../../../core/utils/error_helper.dart';

/// Vaccination Schedule Screen
/// Shows Kenya EPI vaccination schedule and child's immunization status
class VaccinationScheduleScreen extends ConsumerWidget {
  final String childId;

  const VaccinationScheduleScreen({
    super.key,
    required this.childId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final childAsync = ref.watch(childByIdProvider(childId));
    final immunizationsAsync = ref.watch(childImmunizationsProvider(childId));
    final coverageAsync = ref.watch(immunizationCoverageProvider(childId));

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('Vaccination Schedule'),
        backgroundColor: const Color(0xFF4CAF50), // Keep green for health theme
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              ref.invalidate(childImmunizationsProvider(childId));
              ref.invalidate(immunizationCoverageProvider(childId));
            },
          ),
        ],
      ),
      body: childAsync.when(
        data: (child) {
          if (child == null) {
            return const Center(child: Text('Child not found'));
          }
          
          return coverageAsync.when(
            data: (coverage) {
              return immunizationsAsync.when(
                data: (immunizations) {
                  return _buildContent(context, child, coverage, immunizations);
                },
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (e, _) => ErrorHelper.buildErrorWidget(e),
              );
            },
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, _) => Center(child: Text('Error: $e')),
          );
        },
        loading: () => const Center(
          child: CircularProgressIndicator(color: Color(0xFF4CAF50)),
        ),
        error: (e, _) => Center(child: Text('Error: $e')),
      ),
    );
  }

  Widget _buildContent(
    BuildContext context,
    ChildProfile child,
    Map<ImmunizationType, int> coverage,
    List<ImmunizationRecord> immunizations,
  ) {
    // Calculate vaccination status
    final status = KenyaEPISchedule.getChildVaccinationStatus(
      dateOfBirth: child.dateOfBirth,
      coverage: coverage,
    );
    
    final ageInWeeks = DateTime.now().difference(child.dateOfBirth).inDays ~/ 7;

    return SingleChildScrollView(
      child: Column(
        children: [
          // Header with status summary
          _StatusHeader(
            childName: child.childName,
            status: status,
            ageInWeeks: ageInWeeks,
          ),
          
          const SizedBox(height: 16),
          
          // Legend
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                _LegendItem(color: Colors.green, label: 'Given'),
                const SizedBox(width: 16),
                _LegendItem(color: Colors.orange, label: 'Due'),
                const SizedBox(width: 16),
                _LegendItem(color: Colors.red, label: 'Overdue'),
                const SizedBox(width: 16),
                _LegendItem(color: Colors.grey, label: 'Upcoming'),
              ],
            ),
          ),
          
          const SizedBox(height: 16),
          
          // Vaccination Timeline
          ...KenyaEPISchedule.schedule.map((milestone) {
            return _VaccineMilestoneCard(
              milestone: milestone,
              childDob: child.dateOfBirth,
              currentAgeWeeks: ageInWeeks,
              coverage: coverage,
              immunizations: immunizations,
            );
          }),
          
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}

/// Status Summary Header
class _StatusHeader extends StatelessWidget {
  final String childName;
  final VaccinationStatus status;
  final int ageInWeeks;

  const _StatusHeader({
    required this.childName,
    required this.status,
    required this.ageInWeeks,
  });

  @override
  Widget build(BuildContext context) {
    Color statusColor;
    String statusText;
    IconData statusIcon;
    
    if (status.isUpToDate) {
      statusColor = Colors.green;
      statusText = 'Up to Date';
      statusIcon = Icons.check_circle;
    } else if (status.overdue <= 2) {
      statusColor = Colors.orange;
      statusText = '${status.overdue} Vaccine(s) Due';
      statusIcon = Icons.warning_amber;
    } else {
      statusColor = Colors.red;
      statusText = '${status.overdue} Vaccine(s) Overdue';
      statusIcon = Icons.error;
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [statusColor.shade600, statusColor.shade400],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Column(
        children: [
          Icon(statusIcon, size: 48, color: Colors.white),
          const SizedBox(height: 12),
          Text(
            childName,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            _formatAge(ageInWeeks),
            style: TextStyle(
              fontSize: 14,
              color: Colors.white.withOpacity(0.1),
            ),
          ),
          const SizedBox(height: 16),
          
          // Status badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              statusText,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
          
          const SizedBox(height: 16),
          
          // Progress bar
          Row(
            children: [
              Expanded(
                child: Column(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: LinearProgressIndicator(
                        value: status.percentComplete / 100,
                        minHeight: 8,
                        backgroundColor: Colors.white.withOpacity(0.1),
                        valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '${status.totalReceived}/${status.totalDue} vaccines (${status.percentComplete}%)',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.white.withOpacity(0.1),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
  
  String _formatAge(int weeks) {
    if (weeks < 6) return '$weeks weeks old';
    if (weeks < 52) {
      final months = (weeks / 4.3).floor();
      return '$months months old';
    }
    final years = (weeks / 52).floor();
    final remainingMonths = ((weeks % 52) / 4.3).floor();
    if (remainingMonths > 0) {
      return '$years years, $remainingMonths months old';
    }
    return '$years years old';
  }
}

/// Legend Item
class _LegendItem extends StatelessWidget {
  final Color color;
  final String label;

  const _LegendItem({required this.color, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 11,
            color: Colors.grey[700],
          ),
        ),
      ],
    );
  }
}

/// Vaccine Milestone Card
class _VaccineMilestoneCard extends StatelessWidget {
  final VaccineSchedule milestone;
  final DateTime childDob;
  final int currentAgeWeeks;
  final Map<ImmunizationType, int> coverage;
  final List<ImmunizationRecord> immunizations;

  const _VaccineMilestoneCard({
    required this.milestone,
    required this.childDob,
    required this.currentAgeWeeks,
    required this.coverage,
    required this.immunizations,
  });

  @override
  Widget build(BuildContext context) {
    final dueDate = childDob.add(Duration(days: milestone.ageInWeeks * 7));
    final isPast = currentAgeWeeks >= milestone.ageInWeeks;
    final isCurrent = currentAgeWeeks >= milestone.ageInWeeks && 
                      currentAgeWeeks < milestone.ageInWeeks + 4;
    
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isCurrent ? const Color(0xFF4CAF50) : Colors.grey.shade200,
          width: isCurrent ? 2 : 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isPast 
                  ? const Color(0xFF4CAF50).withOpacity(0.1)
                  : Colors.grey.shade50,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(11),
                topRight: Radius.circular(11),
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: isPast
                        ? const Color(0xFF4CAF50).withOpacity(0.1)
                        : Colors.grey.shade200,
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      milestone.ageLabel.split(' ')[0],
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: isPast ? const Color(0xFF4CAF50) : Colors.grey[600],
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        milestone.ageLabel,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'Due: ${DateFormat('d MMM yyyy').format(dueDate)}',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
                if (isCurrent)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: const Color(0xFF4CAF50),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Text(
                      'CURRENT',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
              ],
            ),
          ),
          
          // Vaccines list
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: milestone.vaccines.map((vaccine) {
                return _VaccineRow(
                  vaccine: vaccine,
                  isPast: isPast,
                  coverage: coverage,
                  immunizations: immunizations,
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}

/// Individual Vaccine Row
class _VaccineRow extends StatelessWidget {
  final ScheduledVaccine vaccine;
  final bool isPast;
  final Map<ImmunizationType, int> coverage;
  final List<ImmunizationRecord> immunizations;

  const _VaccineRow({
    required this.vaccine,
    required this.isPast,
    required this.coverage,
    required this.immunizations,
  });

  @override
  Widget build(BuildContext context) {
    final receivedDoses = coverage[vaccine.type] ?? 0;
    final isGiven = receivedDoses >= vaccine.dose;
    
    // Find the immunization record if given
    ImmunizationRecord? record;
    if (isGiven && vaccine.dose > 0) {
      final typeRecords = immunizations
          .where((r) => r.vaccineType == vaccine.type)
          .toList()
        ..sort((a, b) => a.dateGiven.compareTo(b.dateGiven));
      
      final targetIndex = vaccine.dose - 1;
      if (typeRecords.isNotEmpty && targetIndex >= 0 && targetIndex < typeRecords.length) {
        record = typeRecords[targetIndex];
      }
    } else if (isGiven && vaccine.dose == 0) {
      // For dose 0 (birth dose), get first record of this type
      final typeRecords = immunizations
          .where((r) => r.vaccineType == vaccine.type)
          .toList();
      if (typeRecords.isNotEmpty) {
        record = typeRecords.first;
      }
    }
    
    Color statusColor;
    IconData statusIcon;
    String statusLabel;
    
    if (isGiven) {
      statusColor = Colors.green;
      statusIcon = Icons.check_circle;
      statusLabel = 'Given';
    } else if (isPast) {
      statusColor = Colors.red;
      statusIcon = Icons.error;
      statusLabel = 'Overdue';
    } else {
      statusColor = Colors.grey;
      statusIcon = Icons.schedule;
      statusLabel = 'Upcoming';
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: statusColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: statusColor.withOpacity(0.1)),
      ),
      child: Row(
        children: [
          Icon(statusIcon, color: statusColor, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  vaccine.name,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey[800],
                  ),
                ),
                if (record != null)
                  Text(
                    'Given on ${DateFormat('d MMM yyyy').format(record.dateGiven)}',
                    style: TextStyle(
                      fontSize: 11,
                      color: Colors.grey[600],
                    ),
                  ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: statusColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              statusLabel,
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.bold,
                color: statusColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

extension on Color {
  Color get shade600 => HSLColor.fromColor(this).withLightness(0.4).toColor();
  Color get shade400 => HSLColor.fromColor(this).withLightness(0.5).toColor();
}
