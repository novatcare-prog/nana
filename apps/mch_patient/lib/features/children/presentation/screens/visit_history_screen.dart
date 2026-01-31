import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:mch_core/mch_core.dart';
import '../../../../core/providers/child_provider.dart';
import '../../../../core/providers/visit_provider.dart';
import '../../../../core/utils/error_helper.dart';

/// Visit History Screen
/// Shows all postnatal visits for a child
class VisitHistoryScreen extends ConsumerWidget {
  final String childId;

  const VisitHistoryScreen({
    super.key,
    required this.childId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final childAsync = ref.watch(childByIdProvider(childId));
    final visitsAsync = ref.watch(childVisitsProvider(childId));

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('Visit History'),
        backgroundColor:
            const Color(0xFFFF9800), // Keep orange for visits theme
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              ref.invalidate(childVisitsProvider(childId));
            },
          ),
        ],
      ),
      body: childAsync.when(
        data: (child) {
          if (child == null) {
            return const Center(child: Text('Child not found'));
          }

          return visitsAsync.when(
            data: (visits) => _buildContent(context, child, visits),
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, _) => ErrorHelper.buildErrorWidget(e),
          );
        },
        loading: () => const Center(
          child: CircularProgressIndicator(color: Color(0xFFFF9800)),
        ),
        error: (e, _) => Center(child: Text('Error: $e')),
      ),
    );
  }

  Widget _buildContent(
      BuildContext context, ChildProfile child, List<PostnatalVisit> visits) {
    if (visits.isEmpty) {
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
                child:
                    Icon(Icons.history, size: 48, color: Colors.grey.shade400),
              ),
              const SizedBox(height: 24),
              Text(
                'No Visit Records Yet',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: Theme.of(context).textTheme.bodyLarge?.color,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Past clinic visits will appear here after your child\'s checkups.',
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Theme.of(context).textTheme.bodySmall?.color,
                    fontSize: 14),
              ),
            ],
          ),
        ),
      );
    }

    return Column(
      children: [
        // Summary Header
        _VisitSummaryHeader(
          childName: child.childName,
          totalVisits: visits.length,
          latestVisit: visits.first,
        ),

        const SizedBox(height: 16),

        // Visits List
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: visits.length,
            itemBuilder: (context, index) {
              final visit = visits[index];
              return _VisitCard(visit: visit);
            },
          ),
        ),
      ],
    );
  }
}

/// Summary Header
class _VisitSummaryHeader extends StatelessWidget {
  final String childName;
  final int totalVisits;
  final PostnatalVisit latestVisit;

  const _VisitSummaryHeader({
    required this.childName,
    required this.totalVisits,
    required this.latestVisit,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFFFF9800), Color(0xFFF57C00)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Column(
        children: [
          const Icon(Icons.history, size: 40, color: Colors.white),
          const SizedBox(height: 12),
          Text(
            childName,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _SummaryItem(
                icon: Icons.event_note,
                value: '$totalVisits',
                label: 'Total Visits',
              ),
              _SummaryItem(
                icon: Icons.calendar_today,
                value: DateFormat('d MMM').format(latestVisit.visitDate),
                label: 'Last Visit',
              ),
              _SummaryItem(
                icon: Icons.medical_services,
                value: latestVisit.visitType,
                label: 'Last Type',
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// Summary Item
class _SummaryItem extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;

  const _SummaryItem({
    required this.icon,
    required this.value,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, color: Colors.white, size: 20),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 10,
            color: Colors.white.withOpacity(0.1),
          ),
        ),
      ],
    );
  }
}

/// Visit Card
class _VisitCard extends StatelessWidget {
  final PostnatalVisit visit;

  const _VisitCard({required this.visit});

  @override
  Widget build(BuildContext context) {
    // Check for danger signs
    final hasDangerSigns = visit.excessiveBleeding ||
        (visit.maternalDangerSigns != null &&
            visit.maternalDangerSigns!.isNotEmpty) ||
        (visit.babyDangerSigns != null && visit.babyDangerSigns!.isNotEmpty);

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: hasDangerSigns
            ? const BorderSide(color: Colors.red, width: 2)
            : BorderSide.none,
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFF9800).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(
                        Icons.calendar_today,
                        size: 20,
                        color: Color(0xFFFF9800),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          DateFormat('EEEE, d MMM yyyy')
                              .format(visit.visitDate),
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                        Text(
                          'Day ${visit.daysPostpartum} postpartum',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: _getVisitTypeColor(visit.visitType).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    visit.visitType,
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: _getVisitTypeColor(visit.visitType),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),
            const Divider(height: 1),
            const SizedBox(height: 12),

            // Baby Health Section
            if (visit.babyWeight != null || visit.babyTemperature != null) ...[
              const Text(
                'Baby\'s Health',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                  color: Color(0xFFFF9800),
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  if (visit.babyWeight != null)
                    _InfoChip(
                      icon: Icons.monitor_weight,
                      label: '${visit.babyWeight} kg',
                      color: Colors.blue,
                    ),
                  if (visit.babyTemperature != null) ...[
                    const SizedBox(width: 8),
                    _InfoChip(
                      icon: Icons.thermostat,
                      label: '${visit.babyTemperature}°C',
                      color: Colors.red,
                    ),
                  ],
                  if (visit.babyFeedingWell) ...[
                    const SizedBox(width: 8),
                    const _InfoChip(
                      icon: Icons.restaurant,
                      label: 'Feeding Well',
                      color: Colors.green,
                    ),
                  ],
                ],
              ),
              const SizedBox(height: 12),
            ],

            // Breastfeeding Section
            if (visit.breastfeedingStatus != null) ...[
              Row(
                children: [
                  const Icon(Icons.child_care, size: 16, color: Colors.purple),
                  const SizedBox(width: 4),
                  Text(
                    'Breastfeeding: ${visit.breastfeedingStatus}',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[700],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
            ],

            // Cord Status
            if (visit.cordStatus != null) ...[
              Row(
                children: [
                  Icon(
                    Icons.circle,
                    size: 12,
                    color: visit.cordStatus == 'Normal'
                        ? Colors.green
                        : Colors.orange,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    'Cord: ${visit.cordStatus}',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[700],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
            ],

            // Jaundice Alert
            if (visit.jaundicePresent) ...[
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.yellow.shade50,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.orange),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.warning_amber,
                        size: 16, color: Colors.orange),
                    const SizedBox(width: 8),
                    Text(
                      'Jaundice: ${visit.jaundiceSeverity ?? "Present"}',
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: Colors.orange,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
            ],

            // Danger Signs Alert
            if (hasDangerSigns) ...[
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.red.shade50,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.red),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.warning, size: 16, color: Colors.red),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        visit.babyDangerSigns ??
                            visit.maternalDangerSigns ??
                            'Danger signs noted',
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.red,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
            ],

            // Immunizations Given
            if (visit.immunizationsGiven != null &&
                visit.immunizationsGiven!.isNotEmpty) ...[
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.vaccines, size: 16, color: Colors.green),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      'Vaccines: ${visit.immunizationsGiven}',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[700],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
            ],

            // Next Visit
            if (visit.nextVisitDate != null) ...[
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.event, size: 16, color: Colors.blue),
                    const SizedBox(width: 8),
                    Text(
                      'Next visit: ${DateFormat('d MMM yyyy').format(visit.nextVisitDate!)}',
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: Colors.blue,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
            ],

            // Notes
            if (visit.generalNotes != null &&
                visit.generalNotes!.isNotEmpty) ...[
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(Icons.note, size: 14, color: Colors.grey[600]),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        visit.generalNotes!,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[700],
                        ),
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
            ],

            // Attended By
            if (visit.attendedBy != null) ...[
              const SizedBox(height: 8),
              Row(
                children: [
                  Icon(Icons.person, size: 12, color: Colors.grey[500]),
                  const SizedBox(width: 4),
                  Text(
                    'Seen by: ${visit.attendedBy}',
                    style: TextStyle(
                      fontSize: 10,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  Color _getVisitTypeColor(String type) {
    switch (type.toLowerCase()) {
      case '48 hours':
        return Colors.red;
      case '6 days':
        return Colors.orange;
      case '6 weeks':
        return Colors.blue;
      case '6 months':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }
}

/// Info Chip
class _InfoChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;

  const _InfoChip({
    required this.icon,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}
