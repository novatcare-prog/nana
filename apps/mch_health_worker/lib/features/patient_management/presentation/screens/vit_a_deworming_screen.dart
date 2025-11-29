import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:mch_core/mch_core.dart';
import '../../../../core/providers/vitamin_a_deworming_providers.dart';
import 'vitamin_a_screen.dart';
import 'deworming_screen.dart';



class VitaminADewormingCardScreen extends ConsumerWidget {
  final ChildProfile child;

  const VitaminADewormingCardScreen({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final vitaminARecords = ref.watch(vitaminARecordsByChildProvider(child.id));
    final dewormingRecords = ref.watch(dewormingRecordsByChildProvider(child.id));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Vitamin A & Deworming'),
        backgroundColor: Colors.orange[700],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Child Info Card
            _buildChildInfoCard(context),
            const SizedBox(height: 16),

            // Vitamin A Section
            _buildSectionHeader(
              context,
              'Vitamin A Supplementation',
              Icons.local_pharmacy,
              Colors.orange,
            ),
            const SizedBox(height: 8),
            _buildVitaminACard(context, ref, vitaminARecords),
            const SizedBox(height: 24),

            // Deworming Section
            _buildSectionHeader(
              context,
              'Deworming',
              Icons.healing,
              Colors.teal,
            ),
            const SizedBox(height: 8),
            _buildDewormingCard(context, ref, dewormingRecords),
          ],
        ),
      ),
    );
  }

  Widget _buildChildInfoCard(BuildContext context) {
    final ageInMonths = DateTime.now().difference(child.dateOfBirth).inDays ~/ 30;
    
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            CircleAvatar(
              radius: 30,
              backgroundColor: child.sex == 'Male' ? Colors.blue[100] : Colors.pink[100],
              child: Icon(
                child.sex == 'Male' ? Icons.boy : Icons.girl,
                size: 35,
                color: child.sex == 'Male' ? Colors.blue[700] : Colors.pink[700],
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    child.childName,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${child.sex} • $ageInMonths months',
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 14,
                    ),
                  ),
                  Text(
                    'DOB: ${DateFormat('dd/MM/yyyy').format(child.dateOfBirth)}',
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 14,
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

  Widget _buildSectionHeader(
    BuildContext context,
    String title,
    IconData icon,
    Color color,
  ) {
    return Row(
      children: [
        Icon(icon, color: color, size: 28),
        const SizedBox(width: 8),
        Text(
          title,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ],
    );
  }

  Widget _buildVitaminACard(
    BuildContext context,
    WidgetRef ref,
    AsyncValue<List<VitaminARecord>> recordsAsync,
  ) {
    return recordsAsync.when(
      data: (records) {
        final ageInMonths = DateTime.now().difference(child.dateOfBirth).inDays ~/ 30;
        final isEligible = ageInMonths >= 6 && ageInMonths <= 59;
        final totalDoses = records.length;
        final lastDose = records.isNotEmpty ? records.first : null;

        return Card(
          elevation: 2,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Eligibility Status
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: isEligible ? Colors.green[50] : Colors.grey[200],
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: isEligible ? Colors.green : Colors.grey,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        isEligible ? Icons.check_circle : Icons.info,
                        size: 16,
                        color: isEligible ? Colors.green : Colors.grey,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        isEligible
                            ? 'Eligible (6-59 months)'
                            : ageInMonths < 6
                                ? 'Not yet eligible (< 6 months)'
                                : 'No longer eligible (> 59 months)',
                        style: TextStyle(
                          fontSize: 12,
                          color: isEligible ? Colors.green[700] : Colors.grey[700],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // Summary
                Row(
                  children: [
                    Expanded(
                      child: _buildInfoTile(
                        'Total Doses',
                        totalDoses.toString(),
                        Icons.medication,
                        Colors.orange,
                      ),
                    ),
                    if (lastDose != null) ...[
                      const SizedBox(width: 16),
                      Expanded(
                        child: _buildInfoTile(
                          'Last Dose',
                          DateFormat('dd/MM/yy').format(lastDose.dateGiven),
                          Icons.calendar_today,
                          Colors.blue,
                        ),
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 16),

                // Schedule Info
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.orange[50],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Schedule:',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 8),
                      _buildScheduleItem('6 months: 100,000 IU', totalDoses >= 1),
                      _buildScheduleItem('12, 18, 24, 30 months: 200,000 IU', totalDoses >= 2),
                      _buildScheduleItem('36, 42, 48, 54 months: 200,000 IU', totalDoses >= 6),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // Add Button
                if (isEligible)
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AddVitaminAScreen(child: this.child),
                          ),
                        );
                      },
                      icon: const Icon(Icons.add),
                      label: const Text('Record Vitamin A Dose'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange[700],
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        );
      },
      loading: () => const Card(
        child: Padding(
          padding: EdgeInsets.all(40),
          child: Center(child: CircularProgressIndicator()),
        ),
      ),
      error: (error, stack) => Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Text('Error: $error'),
        ),
      ),
    );
  }

  Widget _buildDewormingCard(
    BuildContext context,
    WidgetRef ref,
    AsyncValue<List<DewormingRecord>> recordsAsync,
  ) {
    return recordsAsync.when(
      data: (records) {
        final ageInMonths = DateTime.now().difference(child.dateOfBirth).inDays ~/ 30;
        final isEligible = ageInMonths >= 12 && ageInMonths <= 59;
        final totalDoses = records.length;
        final lastDose = records.isNotEmpty ? records.first : null;

        return Card(
          elevation: 2,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Eligibility Status
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: isEligible ? Colors.green[50] : Colors.grey[200],
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: isEligible ? Colors.green : Colors.grey,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        isEligible ? Icons.check_circle : Icons.info,
                        size: 16,
                        color: isEligible ? Colors.green : Colors.grey,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        isEligible
                            ? 'Eligible (12-59 months)'
                            : ageInMonths < 12
                                ? 'Not yet eligible (< 12 months)'
                                : 'No longer eligible (> 59 months)',
                        style: TextStyle(
                          fontSize: 12,
                          color: isEligible ? Colors.green[700] : Colors.grey[700],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // Summary
                Row(
                  children: [
                    Expanded(
                      child: _buildInfoTile(
                        'Total Doses',
                        totalDoses.toString(),
                        Icons.medication,
                        Colors.teal,
                      ),
                    ),
                    if (lastDose != null) ...[
                      const SizedBox(width: 16),
                      Expanded(
                        child: _buildInfoTile(
                          'Last Dose',
                          DateFormat('dd/MM/yy').format(lastDose.dateGiven),
                          Icons.calendar_today,
                          Colors.blue,
                        ),
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 16),

                // Schedule Info
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.teal[50],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Schedule:',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 8),
                      _buildScheduleItem('Every 6 months from 12-59 months', totalDoses >= 1),
                      const SizedBox(height: 4),
                      const Text(
                        'Drug: Albendazole 400mg or Mebendazole 500mg',
                        style: TextStyle(
                          fontSize: 12,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // Add Button
                if (isEligible)
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AddDewormingScreen(child: this.child),
                          ),
                        );
                      },
                      icon: const Icon(Icons.add),
                      label: const Text('Record Deworming Dose'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.teal[700],
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        );
      },
      loading: () => const Card(
        child: Padding(
          padding: EdgeInsets.all(40),
          child: Center(child: CircularProgressIndicator()),
        ),
      ),
      error: (error, stack) => Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Text('Error: $error'),
        ),
      ),
    );
  }

  Widget _buildInfoTile(String label, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[700],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildScheduleItem(String text, bool isCompleted) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          Icon(
            isCompleted ? Icons.check_circle : Icons.radio_button_unchecked,
            size: 16,
            color: isCompleted ? Colors.green : Colors.grey,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 13,
                color: Colors.grey[800],
              ),
            ),
          ),
        ],
      ),
    );
  }
}