import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:mch_core/mch_core.dart';

// ✅ FIX: Add these two imports to tell this file where your repositories are
import 'package:mch_core/src/data/repositories/supabase_maternal_profile_repository.dart';
import 'package:mch_core/src/data/repositories/anc_visit_repository.dart';

// ============================================
// SUPABASE CLIENT PROVIDER
// ============================================

final supabaseClientProvider = Provider<SupabaseClient>((ref) {
  return Supabase.instance.client;
});

// ============================================
// REPOSITORY PROVIDERS
// ============================================

// This will now work
final supabaseMaternalProfileRepositoryProvider = Provider<SupabaseMaternalProfileRepository>((ref) {
  final supabase = ref.watch(supabaseClientProvider);
  return SupabaseMaternalProfileRepository(supabase);
});

// This will now work
final ancVisitRepositoryProvider = Provider<ANCVisitRepository>((ref) {
  final supabase = ref.watch(supabaseClientProvider);
  return ANCVisitRepository(supabase);
});


// ============================================
// MATERNAL PROFILE DATA PROVIDERS
// ============================================

final maternalProfilesProvider = FutureProvider<List<MaternalProfile>>((ref) async {
  final repository = ref.watch(supabaseMaternalProfileRepositoryProvider);
  return repository.getAllProfiles();
});

final maternalProfileByIdProvider = FutureProvider.family<MaternalProfile?, String>((ref, id) async {
  final repository = ref.watch(supabaseMaternalProfileRepositoryProvider);
  return repository.getProfileById(id);
});

final highRiskProfilesProvider = FutureProvider<List<MaternalProfile>>((ref) async {
  final repository = ref.watch(supabaseMaternalProfileRepositoryProvider);
  return repository.getHighRiskProfiles();
});

final profilesDueSoonProvider = FutureProvider<List<MaternalProfile>>((ref) async {
  final repository = ref.watch(supabaseMaternalProfileRepositoryProvider);
  return repository.getProfilesDueSoon();
});

final searchProfilesProvider = FutureProvider.family<List<MaternalProfile>, String>((ref, query) async {
  final repository = ref.watch(supabaseMaternalProfileRepositoryProvider);
  if (query.isEmpty) {
    return repository.getAllProfiles();
  }
  return repository.searchProfiles(query);
});

final statisticsProvider = FutureProvider<Map<String, int>>((ref) async {
  final repository = ref.watch(supabaseMaternalProfileRepositoryProvider);
  return repository.getStatistics();
});

// ============================================
// ANC VISIT DATA PROVIDERS
// ============================================

final patientVisitsProvider = FutureProvider.family<List<ANCVisit>, String>((ref, profileId) async {
  final repo = ref.watch(ancVisitRepositoryProvider);
  return repo.getVisitsByPatientId(profileId);
});

final visitCountProvider = FutureProvider.family<int, String>((ref, profileId) async {
  final repo = ref.watch(ancVisitRepositoryProvider);
  return repo.getVisitCount(profileId);
});

final nextContactNumberProvider = FutureProvider.family<int, String>((ref, profileId) async {
  final repo = ref.watch(ancVisitRepositoryProvider);
  return repo.getNextContactNumber(profileId);
});


// ============================================
// MUTATION PROVIDERS (for creating/updating)
// ============================================

final createMaternalProfileProvider = Provider<Future<MaternalProfile> Function(MaternalProfile)>((ref) {
  final repository = ref.watch(supabaseMaternalProfileRepositoryProvider);
  return (profile) async {
    final result = await repository.createProfile(profile);
    ref.invalidate(maternalProfilesProvider);
    ref.invalidate(highRiskProfilesProvider);
    ref.invalidate(profilesDueSoonProvider);
    ref.invalidate(statisticsProvider);
    return result;
  };
});

final updateMaternalProfileProvider = Provider<Future<MaternalProfile> Function(MaternalProfile)>((ref) {
  final repository = ref.watch(supabaseMaternalProfileRepositoryProvider);
  return (profile) async {
    final result = await repository.updateProfile(profile);
    ref.invalidate(maternalProfilesProvider);
    ref.invalidate(maternalProfileByIdProvider(profile.id!));
    ref.invalidate(highRiskProfilesProvider);
    ref.invalidate(profilesDueSoonProvider);
    ref.invalidate(statisticsProvider);
    return result;
  };
});

final deleteMaternalProfileProvider = Provider<Future<void> Function(String)>((ref) {
  final repository = ref.watch(supabaseMaternalProfileRepositoryProvider);
  return (id) async {
    await repository.deleteProfile(id);
    ref.invalidate(maternalProfilesProvider);
    ref.invalidate(highRiskProfilesProvider);
    ref.invalidate(profilesDueSoonProvider);
    ref.invalidate(statisticsProvider);
  };
});

// ✅ This provider will now be created correctly
final createVisitProvider = Provider<Future<void> Function(ANCVisit, bool)>((ref) {
  final ancRepo = ref.watch(ancVisitRepositoryProvider);
  final profileRepo = ref.watch(supabaseMaternalProfileRepositoryProvider);
  
  return (visit, bool isHighRisk) async {
    // 1. Save the visit
    await ancRepo.createVisit(visit);
    
    // 2. If high risk, flag the main profile
    if (isHighRisk) {
      await profileRepo.flagPatientAsHighRisk(visit.maternalProfileId);
      // Invalidate dashboard providers
      ref.invalidate(maternalProfilesProvider);
      ref.invalidate(statisticsProvider);
      ref.invalidate(highRiskProfilesProvider);
    }
    
    // 3. Invalidate visit-specific providers
    ref.invalidate(patientVisitsProvider(visit.maternalProfileId));
    ref.invalidate(visitCountProvider(visit.maternalProfileId));
  };
});