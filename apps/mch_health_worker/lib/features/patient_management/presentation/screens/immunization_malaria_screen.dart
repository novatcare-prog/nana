import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mch_core/mch_core.dart';
import 'package:intl/intl.dart';
import '../../../../core/providers/immunization_malaria_providers.dart';
import 'record_tt_dose_screen.dart';
import 'record_iptp_dose_screen.dart';

/// Immunization & Malaria Prevention Screen
/// Shows TT doses and IPTp-SP doses
class ImmunizationMalariaScreen extends ConsumerWidget {
  final String patientId;
  final MaternalProfile patient;

  const ImmunizationMalariaScreen({
    super.key,
    required this.patientId,
    required this.patient,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final immunizationsAsync = ref.watch(patientImmunizationsProvider(patientId));
    final malariaAsync = ref.watch(patientMalariaRecordsProvider(patientId));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Immunization & Malaria'),
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

          // TT IMMUNIZATIONS SECTION
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(Icons.vaccines, color: Theme.of(context).colorScheme.primary),
                  const SizedBox(width: 8),
                  const Text(
                    'Tetanus Toxoid (TT)',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              TextButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => RecordTTDoseScreen(
                        patientId: patientId,
                        patient: patient,
                      ),
                    ),
                  );
                },
                icon: const Icon(Icons.add, size: 20),
                label: const Text('Add TT'),
              ),
            ],
          ),

          const SizedBox(height: 8),

          immunizationsAsync.when(
            data: (immunizations) => _buildTTSection(context, immunizations),
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (error, stack) => Text('Error: $error'),
          ),

          const SizedBox(height: 32),

          // MALARIA PREVENTION SECTION
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(Icons.health_and_safety, color: Theme.of(context).colorScheme.primary),
                  const SizedBox(width: 8),
                  const Text(
                    'Malaria Prevention (IPTp)',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              TextButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => RecordIPTpDoseScreen(
                        patientId: patientId,
                        patient: patient,
                      ),
                    ),
                  );
                },
                icon: const Icon(Icons.add, size: 20),
                label: const Text('Add SP'),
              ),
            ],
          ),

          const SizedBox(height: 8),

          malariaAsync.when(
            data: (records) => _buildMalariaSection(context, records),
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (error, stack) => Text('Error: $error'),
          ),
        ],
      ),
    );
  }

  Widget _buildTTSection(BuildContext context, List<MaternalImmunization> immunizations) {
    if (immunizations.isEmpty) {
      return Card(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Center(
            child: Column(
              children: [
                Icon(Icons.vaccines, size: 48, color: Colors.grey[400]),
                const SizedBox(height: 8),
                Text(
                  'No TT doses recorded',
                  style: TextStyle(color: Colors.grey[600]),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return Column(
      children: [
        // TT Progress Indicator
        _buildTTProgress(immunizations),
        const SizedBox(height: 12),
        // TT Dose Cards
        ...immunizations.map((imm) => _buildTTCard(context, imm)),
      ],
    );
  }

  Widget _buildTTProgress(List<MaternalImmunization> immunizations) {
    final maxDose = immunizations.map((e) => e.ttDose).reduce((a, b) => a > b ? a : b);
    
    return Card(
      color: Colors.green.shade50,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            const Icon(Icons.check_circle, color: Colors.green),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'TT Protection: ${_getTTProtectionStatus(maxDose)}',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(
                    'Last dose: TT$maxDose',
                    style: TextStyle(fontSize: 12, color: Colors.grey[700]),
                  ),
                ],
              ),
            ),
            Text(
              '$maxDose/6',
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getTTProtectionStatus(int dose) {
    if (dose >= 5) return 'Fully Protected (Lifetime)';
    if (dose >= 2) return 'Protected (3 years)';
    return 'Partially Protected';
  }

  Widget _buildTTCard(BuildContext context, MaternalImmunization imm) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.blue.shade100,
          child: Text('TT${imm.ttDose}'),
        ),
        title: Text('TT Dose ${imm.ttDose}'),
        subtitle: Text(DateFormat('MMM dd, yyyy').format(imm.doseDate)),
        trailing: imm.nextDoseDue != null
            ? Chip(
                label: Text(
                  'Next: ${DateFormat('MMM dd').format(imm.nextDoseDue!)}',
                  style: const TextStyle(fontSize: 11),
                ),
              )
            : null,
      ),
    );
  }

  Widget _buildMalariaSection(BuildContext context, List<MalariaPreventionRecord> records) {
    if (records.isEmpty) {
      return Card(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Center(
            child: Column(
              children: [
                Icon(Icons.health_and_safety, size: 48, color: Colors.grey[400]),
                const SizedBox(height: 8),
                Text(
                  'No IPTp doses recorded',
                  style: TextStyle(color: Colors.grey[600]),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return Column(
      children: [
        // IPTp Summary
        _buildIPTpSummary(records),
        const SizedBox(height: 12),
        // IPTp Dose Cards
        ...records.map((record) => _buildIPTpCard(context, record)),
      ],
    );
  }

  Widget _buildIPTpSummary(List<MalariaPreventionRecord> records) {
    final hasITN = records.any((r) => r.itnGiven);
    final totalDoses = records.length;

    return Card(
      color: Colors.orange.shade50,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                const Icon(Icons.medication, color: Colors.orange),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'IPTp-SP Doses',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        '$totalDoses dose${totalDoses != 1 ? "s" : ""} given',
                        style: TextStyle(fontSize: 12, color: Colors.grey[700]),
                      ),
                    ],
                  ),
                ),
                Text(
                  '$totalDoses',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.orange,
                  ),
                ),
              ],
            ),
            if (hasITN) ...[
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.green.shade100,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    Icon(Icons.check_circle, size: 16, color: Colors.green),
                    SizedBox(width: 4),
                    Text('ITN Provided', style: TextStyle(fontSize: 12)),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildIPTpCard(BuildContext context, MalariaPreventionRecord record) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.orange.shade100,
          child: Text('SP${record.spDose}'),
        ),
        title: Text('SP Dose ${record.spDose}'),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(DateFormat('MMM dd, yyyy').format(record.doseDate)),
            if (record.gestationWeeks != null)
              Text(
                '${record.gestationWeeks} weeks gestation',
                style: TextStyle(fontSize: 11, color: Colors.grey[600]),
              ),
          ],
        ),
        trailing: record.itnGiven
            ? const Icon(Icons.bed, color: Colors.green, size: 20)
            : null,
      ),
    );
  }
}