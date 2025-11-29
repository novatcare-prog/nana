import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mch_core/mch_core.dart';
import '/../../core/providers/child_immunization_providers.dart';
import 'add_immunization_screen.dart';
import 'immunization_history_screen.dart';

class ImmunizationCardScreen extends ConsumerWidget {
  final ChildProfile child;

  const ImmunizationCardScreen({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final immunizationsAsync = ref.watch(childImmunizationsProvider(child.id));
    final coverageAsync = ref.watch(immunizationCoverageProvider(child.id));

    return Scaffold(
      appBar: AppBar(
        title: Text('Immunization Card - ${child.childName}'),
        actions: [
          IconButton(
            icon: const Icon(Icons.history),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ImmunizationHistoryScreen(child: child),
                ),
              );
            },
            tooltip: 'View History',
          ),
        ],
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
          child: Text('Error: $error', style: const TextStyle(color: Colors.red)),
        ),
        data: (immunizations) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Child Info Card
                _buildChildInfoCard(context),
                const SizedBox(height: 16),

                // Coverage Summary
                coverageAsync.when(
                  data: (coverage) => _buildCoverageSummary(context, coverage),
                  loading: () => const SizedBox.shrink(),
                  error: (_, __) => const SizedBox.shrink(),
                ),
                const SizedBox(height: 24),

                // Vaccine Cards by Age
                _buildVaccineSection(
                  context,
                  'At Birth',
                  [ImmunizationType.bcg, ImmunizationType.bopv],
                  immunizations,
                  coverageAsync.value,
                ),
                const SizedBox(height: 16),

                _buildVaccineSection(
                  context,
                  '6 Weeks',
                  [
                    ImmunizationType.bopv,
                    ImmunizationType.pentavalent,
                    ImmunizationType.pcv10,
                    ImmunizationType.rotavirus,
                  ],
                  immunizations,
                  coverageAsync.value,
                ),
                const SizedBox(height: 16),

                _buildVaccineSection(
                  context,
                  '10 Weeks',
                  [
                    ImmunizationType.bopv,
                    ImmunizationType.pentavalent,
                    ImmunizationType.pcv10,
                    ImmunizationType.rotavirus,
                  ],
                  immunizations,
                  coverageAsync.value,
                ),
                const SizedBox(height: 16),

                _buildVaccineSection(
                  context,
                  '14 Weeks',
                  [
                    ImmunizationType.bopv,
                    ImmunizationType.pentavalent,
                    ImmunizationType.pcv10,
                    ImmunizationType.ipv,
                  ],
                  immunizations,
                  coverageAsync.value,
                ),
                const SizedBox(height: 16),

                _buildVaccineSection(
                  context,
                  '9 Months',
                  [
                    ImmunizationType.measlesRubella,
                    ImmunizationType.yellowFever,
                  ],
                  immunizations,
                  coverageAsync.value,
                ),
                const SizedBox(height: 16),

                _buildVaccineSection(
                  context,
                  '18 Months',
                  [ImmunizationType.measlesRubella],
                  immunizations,
                  coverageAsync.value,
                ),

                const SizedBox(height: 80), // Space for FAB
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildChildInfoCard(BuildContext context) {
    return Card(
      color: Colors.blue.shade50,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            CircleAvatar(
              radius: 30,
              backgroundColor: child.sex == 'Male' ? Colors.blue : Colors.pink,
              child: Icon(
                child.sex == 'Male' ? Icons.boy : Icons.girl,
                size: 32,
                color: Colors.white,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'child.childName',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Sex: ${child.sex}',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  Text(
                    'DOB: ${_formatDate(child.dateOfBirth)}',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  Text(
                    'Age: ${_calculateAge(child.dateOfBirth)}',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w500,
                        ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCoverageSummary(
    BuildContext context,
    Map<ImmunizationType, int> coverage,
  ) {
    final totalVaccines = coverage.values.fold(0, (sum, count) => sum + count);
    final vaccineTypes = coverage.length;

    return Card(
      color: Colors.green.shade50,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Immunization Summary',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildSummaryItem('Total Doses', '$totalVaccines', Icons.vaccines),
                _buildSummaryItem('Vaccine Types', '$vaccineTypes', Icons.medical_services),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryItem(String label, String value, IconData icon) {
    return Column(
      children: [
        Icon(icon, size: 32, color: Colors.green.shade700),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.green.shade700,
          ),
        ),
        Text(
          label,
          style: const TextStyle(fontSize: 12, color: Colors.grey),
        ),
      ],
    );
  }

  Widget _buildVaccineSection(
    BuildContext context,
    String ageLabel,
    List<ImmunizationType> vaccines,
    List<ImmunizationRecord> allImmunizations,
    Map<ImmunizationType, int>? coverage,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: Colors.purple.shade100,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            ageLabel,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.purple.shade900,
            ),
          ),
        ),
        const SizedBox(height: 8),
        ...vaccines.map((vaccine) {
          final doses = coverage?[vaccine] ?? 0;
          final expectedDoses = _getExpectedDoses(vaccine, ageLabel);
          final isComplete = doses >= expectedDoses;

          return _buildVaccineCard(
            context,
            vaccine,
            doses,
            expectedDoses,
            isComplete,
          );
        }).toList(),
      ],
    );
  }

  Widget _buildVaccineCard(
    BuildContext context,
    ImmunizationType vaccine,
    int dosesGiven,
    int expectedDoses,
    bool isComplete,
  ) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: Icon(
          isComplete ? Icons.check_circle : Icons.pending,
          color: isComplete ? Colors.green : Colors.orange,
          size: 32,
        ),
        title: Text(
          vaccine.label,
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        subtitle: Text(
          dosesGiven > 0
              ? 'Doses given: $dosesGiven/$expectedDoses'
              : 'Not yet given',
        ),
        trailing: Icon(
          isComplete ? Icons.verified : Icons.schedule,
          color: isComplete ? Colors.green : Colors.grey,
        ),
      ),
    );
  }

  int _getExpectedDoses(ImmunizationType vaccine, String ageLabel) {
    // Determine expected dose number based on vaccine and age
    switch (vaccine) {
      case ImmunizationType.bopv:
        if (ageLabel == 'At Birth') return 1;
        if (ageLabel == '6 Weeks') return 1;
        if (ageLabel == '10 Weeks') return 1;
        if (ageLabel == '14 Weeks') return 1;
        return 4; // Total
      case ImmunizationType.pentavalent:
      case ImmunizationType.pcv10:
        return 1; // Each age gets 1 dose
      case ImmunizationType.rotavirus:
        return 1; // Each age gets 1 dose
      case ImmunizationType.ipv:
      case ImmunizationType.bcg:
      case ImmunizationType.yellowFever:
        return 1;
      case ImmunizationType.measlesRubella:
        return 1; // Each age gets 1 dose
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  String _calculateAge(DateTime dateOfBirth) {
    final now = DateTime.now();
    final age = now.difference(dateOfBirth);
    final years = age.inDays ~/ 365;
    final months = (age.inDays % 365) ~/ 30;
    final days = (age.inDays % 365) % 30;

    if (years > 0) {
      return '$years year${years > 1 ? 's' : ''} $months month${months != 1 ? 's' : ''}';
    } else if (months > 0) {
      return '$months month${months != 1 ? 's' : ''} $days day${days != 1 ? 's' : ''}';
    } else {
      return '$days day${days != 1 ? 's' : ''}';
    }
  }
}