import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/models/clinic.dart';
import '../../data/repositories/clinic_repository.dart';

final clinicRepositoryProvider = Provider((ref) => ClinicRepository());

final nearbyClinicsProvider = FutureProvider<List<Clinic>>((ref) async {
  final repository = ref.read(clinicRepositoryProvider);
  return repository.getNearbyClinics();
});
