import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:mch_core/mch_core.dart';

// Supabase client provider
final supabaseClientProvider = Provider<SupabaseClient>((ref) {
  return Supabase.instance.client;
});

// Facility repository provider
final facilityRepositoryProvider = Provider<FacilityRepository>((ref) {
  final supabase = ref.watch(supabaseClientProvider);
  return FacilityRepository(supabase);
});

// All facilities provider
final facilitiesProvider = FutureProvider<List<Facility>>((ref) async {
  final repository = ref.watch(facilityRepositoryProvider);
  return repository.getAllFacilities();
});

// Selected facility provider (for current user's facility)
final selectedFacilityProvider = StateProvider<Facility?>((ref) => null);

// Provider to automatically select first facility on app start
final autoSelectFacilityProvider = FutureProvider<Facility?>((ref) async {
  final facilities = await ref.watch(facilitiesProvider.future);

  if (facilities.isEmpty) {
    return null;
  }

  // Auto-select the first facility
  final firstFacility = facilities.first;

  // Update the selected facility
  ref.read(selectedFacilityProvider.notifier).state = firstFacility;

  return firstFacility;
});

// Search facilities provider
final facilitySearchProvider =
    FutureProvider.family<List<Facility>, String>((ref, query) async {
  if (query.isEmpty) {
    return ref.watch(facilitiesProvider.future);
  }

  final repository = ref.watch(facilityRepositoryProvider);
  return repository.searchFacilities(query);
});

// Facilities by county provider
final facilitiesByCountyProvider =
    FutureProvider.family<List<Facility>, String>((ref, county) async {
  final repository = ref.watch(facilityRepositoryProvider);
  return repository.getFacilitiesByCounty(county);
});

// Facility by ID provider
final facilityByIdProvider =
    FutureProvider.family<Facility?, String>((ref, id) async {
  final repository = ref.watch(facilityRepositoryProvider);
  return repository.getFacilityById(id);
});
