import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mch_core/mch_core.dart';
import 'supabase_providers.dart';

// ============================================
// REPOSITORY PROVIDERS
// ============================================

final maternalImmunizationRepositoryProvider =
    Provider<MaternalImmunizationRepository>((ref) {
  final supabase = ref.watch(supabaseClientProvider);
  return MaternalImmunizationRepository(supabase);
});

final malariaPreventionRepositoryProvider =
    Provider<MalariaPreventionRepository>((ref) {
  final supabase = ref.watch(supabaseClientProvider);
  return MalariaPreventionRepository(supabase);
});

// ============================================
// MATERNAL IMMUNIZATION DATA PROVIDERS
// ============================================

/// Get all TT immunizations for a patient
final patientImmunizationsProvider =
    FutureProvider.family<List<MaternalImmunization>, String>(
        (ref, patientId) async {
  final repository = ref.watch(maternalImmunizationRepositoryProvider);
  return repository.getImmunizationsByPatientId(patientId);
});

/// Get latest TT dose for a patient
final latestTTDoseProvider =
    FutureProvider.family<MaternalImmunization?, String>((ref, patientId) async {
  final repository = ref.watch(maternalImmunizationRepositoryProvider);
  return repository.getLatestDose(patientId);
});

/// Check if patient has specific TT dose
final hasTTDoseProvider = FutureProvider.family<bool, DoseQuery>(
    (ref, query) async {
  final repository = ref.watch(maternalImmunizationRepositoryProvider);
  return repository.hasDose(query.patientId, query.doseNumber);
});

// ============================================
// MALARIA PREVENTION DATA PROVIDERS
// ============================================

/// Get all IPTp records for a patient
final patientMalariaRecordsProvider =
    FutureProvider.family<List<MalariaPreventionRecord>, String>(
        (ref, patientId) async {
  final repository = ref.watch(malariaPreventionRepositoryProvider);
  return repository.getRecordsByPatientId(patientId);
});

/// Get latest SP dose for a patient
final latestSPDoseProvider =
    FutureProvider.family<MalariaPreventionRecord?, String>(
        (ref, patientId) async {
  final repository = ref.watch(malariaPreventionRepositoryProvider);
  return repository.getLatestDose(patientId);
});

/// Check if patient has ITN
final hasITNProvider = FutureProvider.family<bool, String>(
    (ref, patientId) async {
  final repository = ref.watch(malariaPreventionRepositoryProvider);
  return repository.hasITN(patientId);
});

// ============================================
// MUTATION PROVIDERS
// ============================================

/// Create TT immunization
final createImmunizationProvider =
    Provider<Future<MaternalImmunization> Function(MaternalImmunization)>(
        (ref) {
  final repository = ref.watch(maternalImmunizationRepositoryProvider);
  return (immunization) async {
    final result = await repository.createImmunization(immunization);

    ref.invalidate(patientImmunizationsProvider(
        immunization.maternalProfileId));
    ref.invalidate(latestTTDoseProvider(immunization.maternalProfileId));

    return result;
  };
});

/// Create malaria prevention record
final createMalariaRecordProvider = Provider<
    Future<MalariaPreventionRecord> Function(MalariaPreventionRecord)>((ref) {
  final repository = ref.watch(malariaPreventionRepositoryProvider);
  return (record) async {
    final result = await repository.createRecord(record);

    ref.invalidate(patientMalariaRecordsProvider(record.maternalProfileId));
    ref.invalidate(latestSPDoseProvider(record.maternalProfileId));
    if (record.itnGiven) {
      ref.invalidate(hasITNProvider(record.maternalProfileId));
    }

    return result;
  };
});

/// Update TT immunization
final updateImmunizationProvider =
    Provider<Future<MaternalImmunization> Function(MaternalImmunization)>(
        (ref) {
  final repository = ref.watch(maternalImmunizationRepositoryProvider);
  return (immunization) async {
    final result = await repository.updateImmunization(immunization);

    ref.invalidate(patientImmunizationsProvider(
        immunization.maternalProfileId));
    ref.invalidate(latestTTDoseProvider(immunization.maternalProfileId));

    return result;
  };
});

/// Update malaria prevention record
final updateMalariaRecordProvider = Provider<
    Future<MalariaPreventionRecord> Function(MalariaPreventionRecord)>((ref) {
  final repository = ref.watch(malariaPreventionRepositoryProvider);
  return (record) async {
    final result = await repository.updateRecord(record);

    ref.invalidate(patientMalariaRecordsProvider(record.maternalProfileId));
    ref.invalidate(latestSPDoseProvider(record.maternalProfileId));

    return result;
  };
});

/// Delete TT immunization
final deleteImmunizationProvider =
    Provider<Future<void> Function(String)>((ref) {
  final repository = ref.watch(maternalImmunizationRepositoryProvider);
  return (id) async {
    await repository.deleteImmunization(id);
  };
});

/// Delete malaria prevention record
final deleteMalariaRecordProvider =
    Provider<Future<void> Function(String)>((ref) {
  final repository = ref.watch(malariaPreventionRepositoryProvider);
  return (id) async {
    await repository.deleteRecord(id);
  };
});

// ============================================
// HELPER CLASSES
// ============================================

class DoseQuery {
  final String patientId;
  final int doseNumber;

  DoseQuery({
    required this.patientId,
    required this.doseNumber,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DoseQuery &&
          runtimeType == other.runtimeType &&
          patientId == other.patientId &&
          doseNumber == other.doseNumber;

  @override
  int get hashCode => patientId.hashCode ^ doseNumber.hashCode;
}