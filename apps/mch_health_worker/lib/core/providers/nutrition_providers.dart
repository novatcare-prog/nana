import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mch_core/mch_core.dart';
import 'supabase_providers.dart';

// ============================================
// REPOSITORY PROVIDERS
// ============================================

final nutritionRepositoryProvider = Provider<NutritionRepository>((ref) {
  final supabase = ref.watch(supabaseClientProvider);
  return NutritionRepository(supabase);
});

final muacRepositoryProvider = Provider<MuacRepository>((ref) {
  final supabase = ref.watch(supabaseClientProvider);
  return MuacRepository(supabase);
});

// ============================================
// NUTRITION DATA PROVIDERS
// ============================================

/// Get all nutrition records for a patient
final patientNutritionRecordsProvider =
    FutureProvider.family<List<NutritionRecord>, String>((ref, patientId) async {
  final repository = ref.watch(nutritionRepositoryProvider);
  return repository.getRecordsByPatientId(patientId);
});

/// Get latest nutrition record for a patient
final latestNutritionRecordProvider =
    FutureProvider.family<NutritionRecord?, String>((ref, patientId) async {
  final repository = ref.watch(nutritionRepositoryProvider);
  return repository.getLatestRecord(patientId);
});

/// Get malnourished patients
final malnourishedPatientsProvider =
    FutureProvider<List<NutritionRecord>>((ref) async {
  final repository = ref.watch(nutritionRepositoryProvider);
  return repository.getMalnourishedPatients();
});

// ============================================
// MUAC DATA PROVIDERS
// ============================================

/// Get all MUAC measurements for a patient
final patientMuacMeasurementsProvider =
    FutureProvider.family<List<MuacMeasurement>, String>((ref, patientId) async {
  final repository = ref.watch(muacRepositoryProvider);
  return repository.getMeasurementsByPatientId(patientId);
});

/// Get latest MUAC measurement for a patient
final latestMuacMeasurementProvider =
    FutureProvider.family<MuacMeasurement?, String>((ref, patientId) async {
  final repository = ref.watch(muacRepositoryProvider);
  return repository.getLatestMeasurement(patientId);
});

/// Check if patient is malnourished
final isPatientMalnourishedProvider =
    FutureProvider.family<bool, String>((ref, patientId) async {
  final repository = ref.watch(muacRepositoryProvider);
  return repository.isPatientMalnourished(patientId);
});

// ============================================
// MUTATION PROVIDERS
// ============================================

/// Create nutrition record
final createNutritionRecordProvider =
    Provider<Future<NutritionRecord> Function(NutritionRecord)>((ref) {
  final repository = ref.watch(nutritionRepositoryProvider);
  return (record) async {
    final result = await repository.createRecord(record);

    ref.invalidate(patientNutritionRecordsProvider(record.maternalProfileId));
    ref.invalidate(latestNutritionRecordProvider(record.maternalProfileId));
    if (record.isMalnourished) {
      ref.invalidate(malnourishedPatientsProvider);
    }

    return result;
  };
});

/// Create MUAC measurement
final createMuacMeasurementProvider =
    Provider<Future<MuacMeasurement> Function(MuacMeasurement)>((ref) {
  final repository = ref.watch(muacRepositoryProvider);
  return (measurement) async {
    final result = await repository.createMeasurement(measurement);

    ref.invalidate(
        patientMuacMeasurementsProvider(measurement.maternalProfileId));
    ref.invalidate(
        latestMuacMeasurementProvider(measurement.maternalProfileId));
    ref.invalidate(
        isPatientMalnourishedProvider(measurement.maternalProfileId));

    return result;
  };
});

/// Update nutrition record
final updateNutritionRecordProvider =
    Provider<Future<NutritionRecord> Function(NutritionRecord)>((ref) {
  final repository = ref.watch(nutritionRepositoryProvider);
  return (record) async {
    final result = await repository.updateRecord(record);

    ref.invalidate(patientNutritionRecordsProvider(record.maternalProfileId));
    ref.invalidate(latestNutritionRecordProvider(record.maternalProfileId));

    return result;
  };
});

/// Update MUAC measurement
final updateMuacMeasurementProvider =
    Provider<Future<MuacMeasurement> Function(MuacMeasurement)>((ref) {
  final repository = ref.watch(muacRepositoryProvider);
  return (measurement) async {
    final result = await repository.updateMeasurement(measurement);

    ref.invalidate(
        patientMuacMeasurementsProvider(measurement.maternalProfileId));
    ref.invalidate(
        latestMuacMeasurementProvider(measurement.maternalProfileId));

    return result;
  };
});

/// Delete nutrition record
final deleteNutritionRecordProvider =
    Provider<Future<void> Function(String)>((ref) {
  final repository = ref.watch(nutritionRepositoryProvider);
  return (id) async {
    await repository.deleteRecord(id);
    ref.invalidate(malnourishedPatientsProvider);
  };
});

/// Delete MUAC measurement
final deleteMuacMeasurementProvider =
    Provider<Future<void> Function(String)>((ref) {
  final repository = ref.watch(muacRepositoryProvider);
  return (id) async {
    await repository.deleteMeasurement(id);
  };
});