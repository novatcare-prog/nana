import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/models/clinic.dart';
import '../../domain/models/health_worker.dart';
import '../../data/repositories/clinic_repository.dart';

final clinicRepositoryProvider = Provider((ref) => ClinicRepository());

final nearbyClinicsProvider = FutureProvider<List<Clinic>>((ref) async {
  final repository = ref.read(clinicRepositoryProvider);
  return repository.getNearbyClinics();
});

final healthWorkersProvider =
    FutureProvider.family<List<HealthWorker>, String>((ref, clinicId) async {
  final repository = ref.read(clinicRepositoryProvider);
  return repository.getHealthWorkersByClinicId(clinicId);
});
