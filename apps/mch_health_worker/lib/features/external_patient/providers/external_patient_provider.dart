import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mch_core/mch_core.dart';
import '../data/external_patient_repository.dart';

// Steps:
// 1. Scan -> call fetch -> update state
// 2. View Screen watches this state
// 3. Exit -> set state to null

final externalPatientDataProvider =
    StateProvider<SharedPatientData?>((ref) => null);

final fetchExternalPatientProvider =
    FutureProvider.family<void, String>((ref, code) async {
  final repo = ref.read(externalPatientRepositoryProvider);
  final data = await repo.fetchSharedPatientData(code);
  ref.read(externalPatientDataProvider.notifier).state = data;
});
