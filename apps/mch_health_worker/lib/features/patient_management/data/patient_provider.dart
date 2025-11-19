import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mch_core/mch_core.dart';
import '../../../core/database/database_service.dart';

// Provider for the database service
final databaseServiceProvider = Provider<DatabaseService>((ref) {
  return DatabaseService();
});

// StateNotifier for managing patients
class PatientsNotifier extends StateNotifier<AsyncValue<List<MaternalProfile>>> {
  final DatabaseService _databaseService;

  PatientsNotifier(this._databaseService) : super(const AsyncValue.loading()) {
    loadPatients();
  }

  Future<void> loadPatients() async {
    state = const AsyncValue.loading();
    try {
      final patients = await _databaseService.getAllPatients();
      state = AsyncValue.data(patients);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  Future<void> addPatient(MaternalProfile patient) async {
    try {
      await _databaseService.insertPatient(patient);
      // Reload patients after adding
      await loadPatients();
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  Future<void> updatePatient(MaternalProfile patient) async {
    try {
      await _databaseService.updatePatient(patient);
      // Reload patients after updating
      await loadPatients();
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  Future<void> deletePatient(String id) async {
    try {
      await _databaseService.deletePatient(id);
      // Reload patients after deleting
      await loadPatients();
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }
}

// StateNotifierProvider for patients
final patientsProvider = StateNotifierProvider<PatientsNotifier, AsyncValue<List<MaternalProfile>>>((ref) {
  final databaseService = ref.watch(databaseServiceProvider);
  return PatientsNotifier(databaseService);
});