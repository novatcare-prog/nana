import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mch_core/mch_core.dart';
import 'package:intl/intl.dart';
import '../../../../core/providers/nutrition_providers.dart';
import '../../../../core/providers/lab_result_providers.dart';
import '../../../../core/providers/supabase_providers.dart';
import '../../../../core/providers/auth_providers.dart';
import 'record_nutrition_screen.dart';

/// Nutrition Tracking Screen
/// Shows nutrition interventions, MUAC measurements, and supplements
class NutritionTrackingScreen extends ConsumerWidget {
  final String patientId;
  final MaternalProfile patient;

  const NutritionTrackingScreen({
    super.key,
    required this.patientId,
    required this.patient,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final nutritionAsync = ref.watch(patientNutritionRecordsProvider(patientId));
    final muacAsync = ref.watch(patientMuacMeasurementsProvider(patientId));
    final latestMuacAsync = ref.watch(latestMuacMeasurementProvider(patientId));
    
    // Get latest hemoglobin result for anemia detection
    final latestHbAsync = ref.watch(latestTestResultProvider(
      LabTestQuery(
        patientId: patientId,
        testType: LabTestType.hemoglobin,
      ),
    ));
    
    // Get ANC visits for weight gain tracking
    final visitsAsync = ref.watch(patientVisitsProvider(patientId));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Nutrition Tracking'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Patient Info Card
          Card(
            color: Colors.blue.shade50,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    patient.clientName,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text('ANC Number: ${patient.ancNumber}'),
                ],
              ),
            ),
          ),

          const SizedBox(height: 24),

          // MUAC STATUS SECTION
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(Icons.straighten, color: Theme.of(context).colorScheme.primary),
                  const SizedBox(width: 8),
                  const Text(
                    'MUAC Status',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 12),

          latestMuacAsync.when(
            data: (latestMuac) => _buildMuacStatus(context, latestMuac),
            loading: () => const CircularProgressIndicator(),
            error: (error, stack) => Text('Error: $error'),
          ),

          const SizedBox(height: 16),

          // ANEMIA STATUS SECTION (NEW)
          latestHbAsync.when(
            data: (latestHb) {
              if (latestHb == null) return const SizedBox.shrink();
              return _buildAnemiaStatus(context, latestHb);
            },
            loading: () => const SizedBox.shrink(),
            error: (_, __) => const SizedBox.shrink(),
          ),

          const SizedBox(height: 16),

          // WEIGHT GAIN TRACKING SECTION
          visitsAsync.when(
            data: (visits) {
              if (visits.isEmpty || visits.length < 2) return const SizedBox.shrink();
              return Column(
                children: [
                  _buildWeightGainSummary(context, visits, patient),
                  const SizedBox(height: 16),
                ],
              );
            },
            loading: () => const SizedBox.shrink(),
            error: (_, __) => const SizedBox.shrink(),
          ),

          // MUAC TREND CHART
          muacAsync.when(
            data: (measurements) {
              if (measurements.isEmpty) return const SizedBox.shrink();
              return _buildMuacTrend(context, measurements);
            },
            loading: () => const SizedBox.shrink(),
            error: (error, stack) => const SizedBox.shrink(),
          ),

          const SizedBox(height: 24),

          // SUPPLEMENTS & INTERVENTIONS SECTION
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(Icons.medication, color: Theme.of(context).colorScheme.primary),
                  const SizedBox(width: 8),
                  const Text(
                    'Supplements & Interventions',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 12),

          nutritionAsync.when(
             data: (records) {
              if (records.isEmpty) {
                return _buildEmptyState();
              }
              return Column(
                children: records.map((record) => _buildNutritionCard(context, record, ref)).toList(),
              );
            },
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (error, stack) => Text('Error: $error'),
          ),
        ],
      ),
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          // Quick MUAC button
          FloatingActionButton.extended(
            heroTag: 'quick_muac',
            onPressed: () => _showQuickMuacDialog(context, ref),
            backgroundColor: Colors.orange,
            icon: const Icon(Icons.straighten, size: 20),
            label: const Text('Quick MUAC', style: TextStyle(fontSize: 13)),
          ),
          const SizedBox(height: 12),
          // Full Assessment button
          FloatingActionButton.extended(
            heroTag: 'full_assessment',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => RecordNutritionScreen(
                    patientId: patientId,
                    patient: patient,
                  ),
                ),
              );
            },
            icon: const Icon(Icons.add),
            label: const Text('Full Assessment'),
          ),
        ],
      ),
    );
  }

  Widget _buildMuacStatus(BuildContext context, MuacMeasurement? latest) {
    if (latest == null) {
      return Card(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Center(
            child: Column(
              children: [
                Icon(Icons.straighten, size: 48, color: Colors.grey[400]),
                const SizedBox(height: 8),
                Text(
                  'No MUAC measurements recorded',
                  style: TextStyle(color: Colors.grey[600]),
                ),
              ],
            ),
          ),
        ),
      );
    }

    final color = latest.isMalnourished ? Colors.red : Colors.green;
    final status = latest.isMalnourished ? 'Malnourished' : 'Normal';

    return Card(
      color: color.shade50,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            CircleAvatar(
              radius: 30,
              backgroundColor: color.shade100,
              child: Text(
                '${latest.muacCm}',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Latest MUAC: ${latest.muacCm} cm',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'Status: $status',
                    style: TextStyle(color: color, fontWeight: FontWeight.w500),
                  ),
                  Text(
                    DateFormat('MMM dd, yyyy').format(latest.measurementDate),
                    style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                  ),
                ],
              ),
            ),
            if (latest.isMalnourished)
              const Icon(Icons.warning, color: Colors.red, size: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildMuacTrend(BuildContext context, List<MuacMeasurement> measurements) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'MUAC Trend',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            ...measurements.take(5).map((m) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Row(
                    children: [
                      SizedBox(
                        width: 100,
                        child: Text(
                          DateFormat('MMM dd').format(m.measurementDate),
                          style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                        ),
                      ),
                      Expanded(
                        child: LinearProgressIndicator(
                          value: m.muacCm / 30,
                          backgroundColor: Colors.grey[200],
                          valueColor: AlwaysStoppedAnimation(
                            m.isMalnourished ? Colors.red : Colors.green,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '${m.muacCm} cm',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: m.isMalnourished ? Colors.red : Colors.green,
                        ),
                      ),
                    ],
                  ),
                )),
          ],
        ),
      ),
    );
  }

  Widget _buildNutritionCard(BuildContext context, NutritionRecord record, WidgetRef ref) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  DateFormat('MMM dd, yyyy').format(record.recordDate),
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (record.isMalnourished)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.red.shade100,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Text(
                          'Malnourished',
                          style: TextStyle(fontSize: 11, color: Colors.red),
                        ),
                      ),
                    IconButton(
                      icon: const Icon(Icons.delete_outline, size: 20),
                      color: Colors.red,
                      tooltip: 'Delete Record',
                      onPressed: () => _confirmDeleteRecord(context, record, ref),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                if (record.ironFolateGiven)
                  _buildBadge('Iron/Folate: ${record.ironFolateTablets ?? 0} tabs', Icons.medication, Colors.blue),
                if (record.calciumGiven)
                  _buildBadge('Calcium: ${record.calciumTablets ?? 0} tabs', Icons.medication, Colors.purple),
                if (record.dewormingGiven)
                  _buildBadge('Deworming: ${record.dewormingDrug ?? "Given"}', Icons.healing, Colors.orange),
                if (record.muacCm != null)
                  _buildBadge('MUAC: ${record.muacCm} cm', Icons.straighten, 
                    record.isMalnourished ? Colors.red : Colors.green),
                if (record.nutritionCounselingGiven)
                  _buildBadge('Counseling Given', Icons.psychology, Colors.teal),
              ],
            ),
            if (record.notes != null && record.notes!.isNotEmpty) ...[
              const SizedBox(height: 8),
              Text(
                record.notes!,
                style: TextStyle(fontSize: 12, color: Colors.grey[600]),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildBadge(String label, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: color),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(fontSize: 12, color: color, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Center(
          child: Column(
            children: [
              Icon(Icons.restaurant, size: 64, color: Colors.grey[400]),
              const SizedBox(height: 16),
              Text(
                'No Nutrition Records',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[700],
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'No nutrition interventions recorded yet',
                style: TextStyle(color: Colors.grey[600]),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAnemiaStatus(BuildContext context, LabResult latestHb) {
    final hbValue = double.tryParse(latestHb.resultValue ?? '0') ?? 0;
    final isAnemic = hbValue < 11.0; // WHO threshold for pregnant women
    
    final color = isAnemic ? Colors.red : Colors.green;
    final status = isAnemic ? 'Anemic' : 'Normal';
    
    return Card(
      color: color.shade50,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.bloodtype, color: color),
                const SizedBox(width: 8),
                const Text(
                  'Hemoglobin Level',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                CircleAvatar(
                  radius: 25,
                  backgroundColor: color.shade100,
                  child: Text(
                    hbValue.toStringAsFixed(1),
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: color,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '$status: ${hbValue.toStringAsFixed(1)} g/dL',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: color,
                        ),
                      ),
                      Text(
                        DateFormat('MMM dd, yyyy').format(latestHb.testDate),
                        style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                      ),
                      if (isAnemic) ...[
                        const SizedBox(height: 4),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.orange.shade100,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: const Text(
                            '⚠️ Emphasize iron/folate supplementation',
                            style: TextStyle(
                              fontSize: 11,
                              color: Colors.orange,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWeightGainSummary(BuildContext context, List<ANCVisit> visits, MaternalProfile patient) {
    // Sort by date (oldest first)
    final sortedVisits = visits.toList()..sort((a, b) => a.visitDate.compareTo(b.visitDate));
    
    final firstWeight = sortedVisits.first.weightKg;
    final latestWeight = sortedVisits.last.weightKg;
    
    if (firstWeight == null || latestWeight == null) return const SizedBox.shrink();
    
    final weightGain = latestWeight - firstWeight;
    
    // Calculate BMI and expected gain
    final bmi = _calculateBMI(patient.heightCm, firstWeight);
    final expectedGain = _calculateExpectedGain(bmi, sortedVisits.last.gestationWeeks);
    final isOnTrack = weightGain >= (expectedGain * 0.8); // 80% of expected = on track
    
    return Card(
      color: isOnTrack ? Colors.green.shade50 : Colors.orange.shade50,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.trending_up,
                  color: isOnTrack ? Colors.green : Colors.orange,
                ),
                const SizedBox(width: 8),
                const Text(
                  'Weight Gain Progress',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _WeightStat('First Visit', '${firstWeight.toStringAsFixed(1)} kg'),
                _WeightStat('Latest', '${latestWeight.toStringAsFixed(1)} kg'),
                _WeightStat('Gain', '+${weightGain.toStringAsFixed(1)} kg', 
                  color: isOnTrack ? Colors.green : Colors.orange),
              ],
            ),
            const SizedBox(height: 8),
            const Divider(),
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.info_outline, size: 16, color: Colors.grey[600]),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    isOnTrack
                        ? 'Weight gain is on track (Expected: ~${expectedGain.toStringAsFixed(1)} kg by week ${sortedVisits.last.gestationWeeks})'
                        : 'Weight gain below expected (~${expectedGain.toStringAsFixed(1)} kg by week ${sortedVisits.last.gestationWeeks}). Emphasize nutrition counseling.',
                    style: TextStyle(fontSize: 12, color: Colors.grey[700]),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  double _calculateBMI(double heightCm, double weightKg) {
    final heightM = heightCm / 100;
    return weightKg / (heightM * heightM);
  }

  double _calculateExpectedGain(double bmi, int weeks) {
    // MCH Handbook expected weight gain by BMI category
    double totalExpected;
    if (bmi < 18.5) {
      totalExpected = 15; // Underweight: 12.5-18 kg (using mid-point)
    } else if (bmi < 25) {
      totalExpected = 13.5; // Normal: 11.5-16 kg
    } else if (bmi < 30) {
      totalExpected = 9; // Overweight: 7-11.5 kg
    } else {
      totalExpected = 7; // Obese: 5-9 kg
    }
    
    // Pro-rate for current gestation (assuming 40 weeks total)
    return (totalExpected / 40) * weeks;
  }

  Future<void> _confirmDeleteRecord(BuildContext context, NutritionRecord record, WidgetRef ref) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Nutrition Record'),
        content: Text(
          'Are you sure you want to delete the nutrition record from ${DateFormat('MMM dd, yyyy').format(record.recordDate)}?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed == true && context.mounted) {
      if (record.id == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Cannot delete: Record ID is missing'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      try {
        // Call the provider as a function that returns a Future
        await ref.read(deleteNutritionRecordProvider)(record.id!);
        
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('✓ Nutrition record deleted'),
              backgroundColor: Colors.green,
            ),
          );
          // Refresh the list
          ref.invalidate(patientNutritionRecordsProvider(patientId));
        }
      } catch (e) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Failed to delete: $e'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }

  Future<void> _showQuickMuacDialog(BuildContext context, WidgetRef ref) async {
    final muacController = TextEditingController();
    final formKey = GlobalKey<FormState>();

    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.straighten, color: Colors.orange),
            SizedBox(width: 8),
            Text('Quick MUAC Entry'),
          ],
        ),
        content: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: muacController,
                autofocus: true,
                decoration: const InputDecoration(
                  labelText: 'MUAC (cm)',
                  hintText: 'e.g., 24.5',
                  helperText: 'Normal: ≥23 cm, Malnourished: <23 cm',
                  prefixIcon: Icon(Icons.straighten),
                  border: OutlineInputBorder(),
                ),
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter MUAC value';
                  }

                  final muac = double.tryParse(value);
                  if (muac == null) {
                    return 'Please enter a valid number';
                  }

                  if (muac < 15 || muac > 40) {
                    return 'MUAC must be between 15-40 cm';
                  }

                  return null;
                },
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (formKey.currentState!.validate()) {
                Navigator.pop(context, true);
              }
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );

    if (result == true && context.mounted) {
      final muacValue = double.tryParse(muacController.text);
      if (muacValue != null) {
        try {
          // Get current user profile for facilityId and recordedBy
          final userProfile = ref.read(currentUserProfileProvider).value;
          if (userProfile == null || userProfile.facilityId == null || userProfile.id == null) {
            throw Exception('User profile or facility information not found');
          }

          // Create MUAC measurement
          final measurement = MuacMeasurement(
            maternalProfileId: patientId,
            muacCm: muacValue,
            measurementDate: DateTime.now(),
            isMalnourished: muacValue < 23,
            facilityId: userProfile.facilityId!,
            recordedBy: userProfile.id!,
            recordedByName: userProfile.fullName,
          );

          await ref.read(createMuacMeasurementProvider)(measurement);

          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  muacValue < 23
                      ? '⚠️ MUAC recorded: ${muacValue.toStringAsFixed(1)} cm (Malnourished)'
                      : '✓ MUAC recorded: ${muacValue.toStringAsFixed(1)} cm',
                ),
                backgroundColor: muacValue < 23 ? Colors.orange : Colors.green,
              ),
            );

            // Refresh the measurements list
            ref.invalidate(patientMuacMeasurementsProvider(patientId));
          }
        } catch (e) {
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Failed to save MUAC: $e'),
                backgroundColor: Colors.red,
              ),
            );
          }
        }
      }
    }

    muacController.dispose();
  }
}

class _WeightStat extends StatelessWidget {
  final String label;
  final String value;
  final Color? color;

  const _WeightStat(this.label, this.value, {this.color});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: color ?? Colors.black87,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(fontSize: 11, color: Colors.grey[600]),
        ),
      ],
    );
  }
}
