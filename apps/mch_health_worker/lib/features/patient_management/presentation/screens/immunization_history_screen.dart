import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mch_core/mch_core.dart';
import '/../../core/providers/child_immunization_providers.dart';
import 'add_immunization_screen.dart';

class ImmunizationHistoryScreen extends ConsumerWidget {
  final ChildProfile child;

  const ImmunizationHistoryScreen({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final immunizationsAsync = ref.watch(childImmunizationsProvider(child.id));

    return Scaffold(
      appBar: AppBar(
        title: Text('Immunization History - ${child.childName}'),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddImmunizationScreen(child: child),
            ),
          );
        },
        icon: const Icon(Icons.add),
        label: const Text('Add Vaccine'),
      ),
      body: immunizationsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error, size: 64, color: Colors.red),
              const SizedBox(height: 16),
              Text('Error: $error'),
            ],
          ),
        ),
        data: (immunizations) {
          if (immunizations.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.vaccines, size: 64, color: Colors.grey.shade400),
                  const SizedBox(height: 16),
                  Text(
                    'No immunization records yet',
                    style: TextStyle(fontSize: 18, color: Colors.grey.shade600),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Tap the + button to add a vaccine record',
                    style: TextStyle(color: Colors.grey.shade500),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: immunizations.length,
            itemBuilder: (context, index) {
              final immunization = immunizations[index];
              return _buildImmunizationCard(context, immunization);
            },
          );
        },
      ),
    );
  }

  Widget _buildImmunizationCard(BuildContext context, ImmunizationRecord immunization) {
    final hasAdverseReaction = immunization.adverseEventReported;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: hasAdverseReaction ? Colors.red : Colors.transparent,
          width: 2,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Row
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.green.shade100,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    immunization.vaccineType.label,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.green.shade900,
                    ),
                  ),
                ),
                const Spacer(),
                if (immunization.doseNumber != null)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.blue.shade100,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      'Dose ${immunization.doseNumber}',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.blue.shade900,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 12),

            // Date and Age
            Row(
              children: [
                const Icon(Icons.calendar_today, size: 16, color: Colors.grey),
                const SizedBox(width: 8),
                Text(
                  _formatDate(immunization.dateGiven),
                  style: const TextStyle(fontWeight: FontWeight.w500),
                ),
                const SizedBox(width: 16),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: Colors.purple.shade50,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    '${immunization.ageInWeeks} weeks',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.purple.shade700,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Administration Details
            if (immunization.administrationRoute != null || immunization.administrationSite != null) ...[
              Row(
                children: [
                  if (immunization.administrationRoute != null) ...[
                    _buildDetailChip(
                      Icons.medication,
                      immunization.administrationRoute!,
                      Colors.orange,
                    ),
                    const SizedBox(width: 8),
                  ],
                  if (immunization.administrationSite != null)
                    _buildDetailChip(
                      Icons.place,
                      immunization.administrationSite!,
                      Colors.blue,
                    ),
                ],
              ),
              const SizedBox(height: 12),
            ],

            // Batch Number
            if (immunization.batchNumber != null) ...[
              Row(
                children: [
                  const Icon(Icons.qr_code, size: 16, color: Colors.grey),
                  const SizedBox(width: 8),
                  Text(
                    'Batch: ${immunization.batchNumber}',
                    style: const TextStyle(fontSize: 13, color: Colors.grey),
                  ),
                ],
              ),
              const SizedBox(height: 8),
            ],

            // BCG Scar Check
            if (immunization.vaccineType == ImmunizationType.bcg &&
                immunization.bcgScarChecked == true) ...[
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: immunization.bcgScarPresent == true
                      ? Colors.green.shade50
                      : Colors.orange.shade50,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Icon(
                      immunization.bcgScarPresent == true
                          ? Icons.check_circle
                          : Icons.warning,
                      size: 16,
                      color: immunization.bcgScarPresent == true
                          ? Colors.green
                          : Colors.orange,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      immunization.bcgScarPresent == true
                          ? 'BCG scar present'
                          : 'BCG scar not present',
                      style: TextStyle(
                        fontSize: 12,
                        color: immunization.bcgScarPresent == true
                            ? Colors.green.shade900
                            : Colors.orange.shade900,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
            ],

            // Adverse Reaction Warning
            if (hasAdverseReaction) ...[
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.red.shade50,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.red.shade200),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.warning, color: Colors.red.shade700, size: 20),
                        const SizedBox(width: 8),
                        Text(
                          'Adverse Reaction Reported',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.red.shade900,
                          ),
                        ),
                      ],
                    ),
                    if (immunization.adverseEventDescription != null) ...[
                      const SizedBox(height: 8),
                      Text(
                        immunization.adverseEventDescription!,
                        style: TextStyle(color: Colors.red.shade700),
                      ),
                    ],
                    if (immunization.reactionSeverity != null) ...[
                      const SizedBox(height: 4),
                      Text(
                        'Severity: ${immunization.reactionSeverity}',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: Colors.red.shade900,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(height: 8),
            ],

            // Notes
            if (immunization.notes != null) ...[
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(Icons.note, size: 16, color: Colors.grey),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        immunization.notes!,
                        style: const TextStyle(fontSize: 13),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
            ],

            // Footer - Given By
            if (immunization.givenBy != null) ...[
              const Divider(),
              Row(
                children: [
                  Icon(Icons.person, size: 14, color: Colors.grey.shade600),
                  const SizedBox(width: 4),
                  Text(
                    'Given by: ${immunization.givenBy}',
                    style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                  ),
                  if (immunization.healthFacilityName != null) ...[
                    Text(
                      ' at ${immunization.healthFacilityName}',
                      style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                    ),
                  ],
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildDetailChip(IconData icon, String label, Color color) {
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
            style: TextStyle(fontSize: 12, color: color),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}