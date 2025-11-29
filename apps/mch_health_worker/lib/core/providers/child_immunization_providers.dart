import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mch_core/mch_core.dart';
import 'supabase_providers.dart';

// Repository Provider
final immunizationRepositoryProvider = Provider<ImmunizationRepository>((ref) {
  final supabase = ref.watch(supabaseClientProvider);
  return ImmunizationRepository(supabase);
});

// Get all immunizations for a child
final childImmunizationsProvider = FutureProvider.family<List<ImmunizationRecord>, String>((ref, childId) async {
  final repository = ref.watch(immunizationRepositoryProvider);
  return repository.getImmunizationsByChildId(childId);
});

// Get immunization by ID
final immunizationByIdProvider = FutureProvider.family<ImmunizationRecord?, String>((ref, immunizationId) async {
  final repository = ref.watch(immunizationRepositoryProvider);
  return repository.getImmunizationById(immunizationId);
});

// Get immunizations by vaccine type
final immunizationsByVaccineTypeProvider = FutureProvider.family<List<ImmunizationRecord>, ({String childId, ImmunizationType vaccineType})>((ref, params) async {
  final repository = ref.watch(immunizationRepositoryProvider);
  return repository.getImmunizationsByVaccineType(
    childId: params.childId,
    vaccineType: params.vaccineType,
  );
});

// Get upcoming due vaccines
final upcomingDueVaccinesProvider = FutureProvider.family<List<ImmunizationRecord>, String>((ref, childId) async {
  final repository = ref.watch(immunizationRepositoryProvider);
  return repository.getUpcomingDueVaccines(childId);
});

// Get immunizations with adverse reactions
final immunizationsWithReactionsProvider = FutureProvider.family<List<ImmunizationRecord>, String>((ref, childId) async {
  final repository = ref.watch(immunizationRepositoryProvider);
  return repository.getImmunizationsWithReactions(childId);
});

// Get immunization coverage
final immunizationCoverageProvider = FutureProvider.family<Map<ImmunizationType, int>, String>((ref, childId) async {
  final repository = ref.watch(immunizationRepositoryProvider);
  return repository.getImmunizationCoverage(childId);
});

// Create immunization mutation
final createImmunizationProvider = Provider<Future<ImmunizationRecord> Function(ImmunizationRecord)>((ref) {
  return (immunization) async {
    final repository = ref.read(immunizationRepositoryProvider);
    final result = await repository.createImmunization(immunization);
    
    // Invalidate related providers
    ref.invalidate(childImmunizationsProvider(immunization.childId));
    ref.invalidate(immunizationCoverageProvider(immunization.childId));
    ref.invalidate(upcomingDueVaccinesProvider(immunization.childId));
    
    return result;
  };
});

// Update immunization mutation
final updateImmunizationProvider = Provider<Future<ImmunizationRecord> Function(ImmunizationRecord)>((ref) {
  return (immunization) async {
    final repository = ref.read(immunizationRepositoryProvider);
    final result = await repository.updateImmunization(immunization);
    
    // Invalidate related providers
    ref.invalidate(childImmunizationsProvider(immunization.childId));
    ref.invalidate(immunizationCoverageProvider(immunization.childId));
    ref.invalidate(upcomingDueVaccinesProvider(immunization.childId));
    if (immunization.id != null) {
      ref.invalidate(immunizationByIdProvider(immunization.id!));
    }
    
    return result;
  };
});

// Delete immunization mutation
final deleteImmunizationProvider = Provider<Future<void> Function(String, String)>((ref) {
  return (immunizationId, childId) async {
    final repository = ref.read(immunizationRepositoryProvider);
    await repository.deleteImmunization(immunizationId);
    
    // Invalidate related providers
    ref.invalidate(childImmunizationsProvider(childId));
    ref.invalidate(immunizationCoverageProvider(childId));
    ref.invalidate(upcomingDueVaccinesProvider(childId));
    ref.invalidate(immunizationByIdProvider(immunizationId));
  };
});