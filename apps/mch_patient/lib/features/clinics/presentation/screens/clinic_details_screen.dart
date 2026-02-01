import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../domain/models/clinic.dart';
import '../../domain/models/health_worker.dart';
import '../providers/clinic_provider.dart';
import '../../../../core/utils/error_helper.dart';

class ClinicDetailsScreen extends ConsumerWidget {
  final String clinicId;
  final Clinic? clinic;

  const ClinicDetailsScreen({
    super.key,
    required this.clinicId,
    this.clinic,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final healthWorkersAsync = ref.watch(healthWorkersProvider(clinicId));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Clinic Details'),
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: Colors.black,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Clinic Header
            if (clinic != null) _buildClinicHeader(context, clinic!),

            const Padding(
              padding: EdgeInsets.fromLTRB(16, 24, 16, 8),
              child: Text(
                'Available Health Workers',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            // Health Workers List
            healthWorkersAsync.when(
              data: (workers) {
                if (workers.isEmpty) {
                  return const Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Text('No health workers available at this time.'),
                  );
                }
                return ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  padding: const EdgeInsets.all(16),
                  itemCount: workers.length,
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    return _HealthWorkerCard(
                      worker: workers[index],
                      onBook: () {
                        // Navigation to booking screen passing worker and clinic details
                        context.pushNamed(
                          'book-appointment',
                          pathParameters: {
                            'id': clinicId,
                            'workerId': workers[index].id
                          },
                          extra: {'worker': workers[index], 'clinic': clinic},
                        );
                      },
                    );
                  },
                );
              },
              loading: () => const Padding(
                padding: EdgeInsets.all(32.0),
                child: Center(
                    child: CircularProgressIndicator(color: Color(0xFFE91E63))),
              ),
              error: (error, _) => Padding(
                padding: const EdgeInsets.all(16.0),
                child: ErrorHelper.buildErrorWidget(
                  error,
                  onRetry: () =>
                      ref.invalidate(healthWorkersProvider(clinicId)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildClinicHeader(BuildContext context, Clinic clinic) {
    return Container(
      width: double.infinity,
      color: Colors.white,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: const Color(0xFFE91E63).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.local_hospital,
                    color: Color(0xFFE91E63), size: 30),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      clinic.name,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      clinic.address,
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
          const SizedBox(height: 16),
          Row(children: [
            _buildInfoChip(Icons.phone, clinic.phone),
            const SizedBox(width: 12),
            _buildInfoChip(Icons.star, clinic.rating.toString()),
          ]),
          const SizedBox(height: 16),
          const Text("Services", style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: clinic.services
                .map((s) => Chip(
                      label: Text(s, style: const TextStyle(fontSize: 12)),
                      backgroundColor: Colors.grey[100],
                      visualDensity: VisualDensity.compact,
                    ))
                .toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoChip(IconData icon, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(4),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: Colors.grey[600]),
          const SizedBox(width: 4),
          Text(label, style: TextStyle(fontSize: 12, color: Colors.grey[800])),
        ],
      ),
    );
  }
}

class _HealthWorkerCard extends StatelessWidget {
  final HealthWorker worker;
  final VoidCallback onBook;

  const _HealthWorkerCard({required this.worker, required this.onBook});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          children: [
            CircleAvatar(
              radius: 24,
              backgroundColor: const Color(0xFFE91E63).withOpacity(0.1),
              child: Text(
                worker.name.substring(0, 1).toUpperCase(),
                style: const TextStyle(
                  color: Color(0xFFE91E63),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    worker.name,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  Text(
                    worker.role,
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 13,
                    ),
                  ),
                  Row(
                    children: [
                      Icon(Icons.star, size: 14, color: Colors.amber[700]),
                      const SizedBox(width: 4),
                      Text(
                        worker.rating.toString(),
                        style: const TextStyle(
                            fontSize: 12, fontWeight: FontWeight.bold),
                      ),
                    ],
                  )
                ],
              ),
            ),
            ElevatedButton(
              onPressed: worker.isAvailable ? onBook : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFE91E63),
                foregroundColor: Colors.white,
                elevation: 0,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)),
              ),
              child: Text(worker.isAvailable ? 'Book' : 'Busy'),
            ),
          ],
        ),
      ),
    );
  }
}
