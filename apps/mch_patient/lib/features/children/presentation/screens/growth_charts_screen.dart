import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:mch_core/mch_core.dart';
import '../../../../core/providers/child_provider.dart';
import '../../../../core/providers/growth_provider.dart';

/// Growth Charts Screen
/// Shows growth history and measurements for a child
class GrowthChartsScreen extends ConsumerWidget {
  final String childId;

  const GrowthChartsScreen({
    super.key,
    required this.childId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final childAsync = ref.watch(childByIdProvider(childId));
    final growthRecordsAsync = ref.watch(childGrowthRecordsProvider(childId));

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('Growth Charts'),
        backgroundColor: const Color(0xFF2196F3), // Keep blue for growth theme
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              ref.invalidate(childGrowthRecordsProvider(childId));
            },
          ),
        ],
      ),
      body: childAsync.when(
        data: (child) {
          if (child == null) {
            return const Center(child: Text('Child not found'));
          }

          return growthRecordsAsync.when(
            data: (records) => _buildContent(context, child, records),
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, _) => Center(child: Text('Error: $e')),
          );
        },
        loading: () => const Center(
          child: CircularProgressIndicator(color: Color(0xFF2196F3)),
        ),
        error: (e, _) => Center(child: Text('Error: $e')),
      ),
    );
  }

  Widget _buildContent(BuildContext context, ChildProfile child, List<GrowthRecord> records) {
    if (records.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.show_chart, size: 48, color: Colors.grey.shade400),
              ),
              const SizedBox(height: 24),
              Text(
                'No Growth Records Yet',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: Theme.of(context).textTheme.bodyLarge?.color,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Growth measurements will appear here after your child\'s health checkups.',
                textAlign: TextAlign.center,
                style: TextStyle(color: Theme.of(context).textTheme.bodySmall?.color, fontSize: 14),
              ),
            ],
          ),
        ),
      );
    }

    // Calculate age in months
    final ageInMonths = DateTime.now().difference(child.dateOfBirth).inDays ~/ 30;

    // Get the latest record for summary
    final latestRecord = records.first;

    return SingleChildScrollView(
      child: Column(
        children: [
          // Header with child info and latest stats
          _GrowthSummaryHeader(
            childName: child.childName,
            ageInMonths: ageInMonths,
            latestRecord: latestRecord,
          ),

          const SizedBox(height: 16),

          // Growth indicators
          _GrowthIndicatorsSection(latestRecord: latestRecord),

          const SizedBox(height: 16),

          // Growth Chart Visualization
          _GrowthChartSection(records: records),

          const SizedBox(height: 16),

          // Growth History List
          _GrowthHistorySection(records: records),

          const SizedBox(height: 24),
        ],
      ),
    );
  }
}

/// Header with summary
class _GrowthSummaryHeader extends StatelessWidget {
  final String childName;
  final int ageInMonths;
  final GrowthRecord latestRecord;

  const _GrowthSummaryHeader({
    required this.childName,
    required this.ageInMonths,
    required this.latestRecord,
  });

  @override
  Widget build(BuildContext context) {
    // Determine nutritional status color
    Color statusColor = Colors.green;
    String statusText = latestRecord.nutritionalStatus ?? 'Normal';
    
    if (latestRecord.edemaPresent) {
      statusColor = Colors.red;
      statusText = 'Needs Attention';
    } else if (statusText.toLowerCase().contains('severe')) {
      statusColor = Colors.red;
    } else if (statusText.toLowerCase().contains('under')) {
      statusColor = Colors.orange;
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [const Color(0xFF2196F3), const Color(0xFF1976D2)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Column(
        children: [
          Text(
            childName,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '$ageInMonths months old',
            style: TextStyle(
              fontSize: 14,
              color: Colors.white.withOpacity(0.8),
            ),
          ),
          const SizedBox(height: 20),

          // Stats row
          Row(
            children: [
              Expanded(
                child: _StatItem(
                  icon: Icons.monitor_weight,
                  label: 'Weight',
                  value: '${latestRecord.weightKg} kg',
                ),
              ),
              Expanded(
                child: _StatItem(
                  icon: Icons.height,
                  label: latestRecord.measuredLying == true ? 'Length' : 'Height',
                  value: '${(latestRecord.lengthCm ?? latestRecord.heightCm ?? 0).toStringAsFixed(1)} cm',
                ),
              ),
              if (latestRecord.headCircumferenceCm != null)
                Expanded(
                  child: _StatItem(
                    icon: Icons.circle_outlined,
                    label: 'Head',
                    value: '${latestRecord.headCircumferenceCm!.toStringAsFixed(1)} cm',
                  ),
                ),
            ],
          ),

          const SizedBox(height: 16),

          // Status badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: statusColor.withOpacity(0.8),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.white.withOpacity(0.8)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  statusColor == Colors.green
                      ? Icons.check_circle
                      : statusColor == Colors.orange
                          ? Icons.warning_amber
                          : Icons.error,
                  color: Colors.white,
                  size: 18,
                ),
                const SizedBox(width: 8),
                Text(
                  statusText,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),

          Text(
            'Last measured on ${DateFormat('d MMM yyyy').format(latestRecord.measurementDate)}',
            style: TextStyle(
              fontSize: 11,
              color: Colors.white.withOpacity(0.8),
            ),
          ),
        ],
      ),
    );
  }
}

/// Stat Item in Header
class _StatItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _StatItem({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, color: Colors.white, size: 24),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 11,
            color: Colors.white.withOpacity(0.8),
          ),
        ),
      ],
    );
  }
}

/// Growth Indicators Section - z-scores
class _GrowthIndicatorsSection extends StatelessWidget {
  final GrowthRecord latestRecord;

  const _GrowthIndicatorsSection({required this.latestRecord});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Growth Indicators',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  _GrowthIndicatorRow(
                    label: 'Weight for Age',
                    zScore: latestRecord.weightForAgeZScore,
                    interpretation: latestRecord.weightInterpretation,
                  ),
                  const Divider(height: 24),
                  _GrowthIndicatorRow(
                    label: 'Height for Age',
                    zScore: latestRecord.heightForAgeZScore,
                    interpretation: latestRecord.heightInterpretation,
                  ),
                  if (latestRecord.weightForHeightZScore != null) ...[
                    const Divider(height: 24),
                    _GrowthIndicatorRow(
                      label: 'Weight for Height',
                      zScore: latestRecord.weightForHeightZScore,
                      interpretation: null,
                    ),
                  ],
                  if (latestRecord.muacCm != null) ...[
                    const Divider(height: 24),
                    _MuacIndicatorRow(
                      muacCm: latestRecord.muacCm!,
                      interpretation: latestRecord.muacInterpretation,
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

/// Growth Indicator Row with z-score
class _GrowthIndicatorRow extends StatelessWidget {
  final String label;
  final double? zScore;
  final String? interpretation;

  const _GrowthIndicatorRow({
    required this.label,
    required this.zScore,
    required this.interpretation,
  });

  @override
  Widget build(BuildContext context) {
    // Determine status based on z-score
    Color statusColor;
    String statusText;

    if (zScore == null) {
      statusColor = Colors.grey;
      statusText = interpretation ?? 'Not measured';
    } else if (zScore! < -3) {
      statusColor = Colors.red;
      statusText = 'Severely Low';
    } else if (zScore! < -2) {
      statusColor = Colors.orange;
      statusText = 'Low';
    } else if (zScore! > 2) {
      statusColor = Colors.orange;
      statusText = 'High';
    } else {
      statusColor = Colors.green;
      statusText = 'Normal';
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
            ),
            if (zScore != null)
              Text(
                'Z-score: ${zScore!.toStringAsFixed(2)}',
                style: TextStyle(fontSize: 12, color: Colors.grey[600]),
              ),
          ],
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: statusColor.withOpacity(0.8),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            interpretation ?? statusText,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: statusColor,
            ),
          ),
        ),
      ],
    );
  }
}

/// MUAC Indicator Row
class _MuacIndicatorRow extends StatelessWidget {
  final double muacCm;
  final String? interpretation;

  const _MuacIndicatorRow({
    required this.muacCm,
    required this.interpretation,
  });

  @override
  Widget build(BuildContext context) {
    // MUAC interpretation
    Color statusColor;
    String statusText;

    if (muacCm < 11.5) {
      statusColor = Colors.red;
      statusText = 'Severe Acute Malnutrition';
    } else if (muacCm < 12.5) {
      statusColor = Colors.orange;
      statusText = 'Moderate Acute Malnutrition';
    } else if (muacCm < 13.5) {
      statusColor = Colors.yellow.shade700;
      statusText = 'At Risk';
    } else {
      statusColor = Colors.green;
      statusText = 'Normal';
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'MUAC',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
            ),
            Text(
              '${muacCm.toStringAsFixed(1)} cm',
              style: TextStyle(fontSize: 12, color: Colors.grey[600]),
            ),
          ],
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: statusColor.withOpacity(0.8),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            interpretation ?? statusText,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: statusColor,
            ),
          ),
        ),
      ],
    );
  }
}

/// Growth Chart Section - Simple visual representation
class _GrowthChartSection extends StatelessWidget {
  final List<GrowthRecord> records;

  const _GrowthChartSection({required this.records});

  @override
  Widget build(BuildContext context) {
    if (records.length < 2) {
      return const SizedBox.shrink();
    }

    // Get weight trend data (last 6 records)
    final recentRecords = records.take(6).toList().reversed.toList();
    final maxWeight = recentRecords.map((r) => r.weightKg).reduce((a, b) => a > b ? a : b);
    final minWeight = recentRecords.map((r) => r.weightKg).reduce((a, b) => a < b ? a : b);
    final range = maxWeight - minWeight;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Weight Trend',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  SizedBox(
                    height: 150,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: recentRecords.asMap().entries.map((entry) {
                        final record = entry.value;
                        final normalizedHeight = range > 0
                            ? ((record.weightKg - minWeight) / range * 0.8) + 0.2
                            : 0.5;

                        return Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 4),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Text(
                                  '${record.weightKg}kg',
                                  style: const TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Container(
                                  height: 100 * normalizedHeight,
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF2196F3),
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  '${record.ageInMonths}mo',
                                  style: TextStyle(
                                    fontSize: 10,
                                    color: Colors.grey[600],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }).toList(),
                    ),
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

/// Growth History Section
class _GrowthHistorySection extends StatelessWidget {
  final List<GrowthRecord> records;

  const _GrowthHistorySection({required this.records});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Measurement History',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          ...records.take(5).map((record) => _GrowthHistoryCard(record: record)),
          if (records.length > 5)
            Center(
              child: TextButton(
                onPressed: () {
                  // Could expand or navigate to full history
                },
                child: Text('View all ${records.length} measurements'),
              ),
            ),
        ],
      ),
    );
  }
}

/// Growth History Card
class _GrowthHistoryCard extends StatelessWidget {
  final GrowthRecord record;

  const _GrowthHistoryCard({required this.record});

  @override
  Widget build(BuildContext context) {
    final heightOrLength = record.lengthCm ?? record.heightCm;
    final measureLabel = record.measuredLying == true ? 'Length' : 'Height';

    // Alert color if needed
    Color? alertColor;
    if (record.edemaPresent) {
      alertColor = Colors.red;
    } else if (record.referredForNutrition == true) {
      alertColor = Colors.orange;
    }

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      color: alertColor?.withOpacity(0.8),
      shape: alertColor != null
          ? RoundedRectangleBorder(
              side: BorderSide(color: alertColor),
              borderRadius: BorderRadius.circular(12),
            )
          : null,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            // Date badge
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: const Color(0xFF2196F3).withOpacity(0.8),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    DateFormat('d').format(record.measurementDate),
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF2196F3),
                    ),
                  ),
                  Text(
                    DateFormat('MMM').format(record.measurementDate),
                    style: const TextStyle(
                      fontSize: 10,
                      color: Color(0xFF2196F3),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),

            // Age
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                '${record.ageInMonths}mo',
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(width: 12),

            // Measurements
            Expanded(
              child: Row(
                children: [
                  _MiniStat(
                    icon: Icons.monitor_weight,
                    value: '${record.weightKg}kg',
                    color: Colors.blue,
                  ),
                  if (heightOrLength != null) ...[
                    const SizedBox(width: 8),
                    _MiniStat(
                      icon: Icons.height,
                      value: '${heightOrLength.toStringAsFixed(1)}cm',
                      color: Colors.green,
                    ),
                  ],
                  if (record.muacCm != null) ...[
                    const SizedBox(width: 8),
                    _MiniStat(
                      icon: Icons.straighten,
                      value: '${record.muacCm!.toStringAsFixed(1)}',
                      color: Colors.orange,
                    ),
                  ],
                ],
              ),
            ),

            // Alert icon if needed
            if (alertColor != null)
              Icon(Icons.warning_amber, color: alertColor, size: 20),
          ],
        ),
      ),
    );
  }
}

/// Mini Stat for history card
class _MiniStat extends StatelessWidget {
  final IconData icon;
  final String value;
  final Color color;

  const _MiniStat({
    required this.icon,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 14, color: color),
        const SizedBox(width: 2),
        Text(
          value,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: color,
          ),
        ),
      ],
    );
  }
}
