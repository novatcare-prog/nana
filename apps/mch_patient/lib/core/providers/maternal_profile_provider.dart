import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:mch_core/mch_core.dart';

/// Repository provider for maternal profiles
final maternalProfileRepositoryProvider = Provider<SupabaseMaternalProfileRepository>((ref) {
  return SupabaseMaternalProfileRepository(Supabase.instance.client);
});

/// Provider to get the current patient's maternal profile
/// This fetches the logged-in user's maternal profile using auth_id in maternal_profiles table
final currentMaternalProfileProvider = FutureProvider<MaternalProfile?>((ref) async {
  final supabase = Supabase.instance.client;
  final user = supabase.auth.currentUser;
  
  if (user == null) return null;
  
  try {
    // Query maternal_profiles directly using auth_id
    // This finds the maternal profile linked to the authenticated user
    final response = await supabase
        .from('maternal_profiles')
        .select()
        .eq('auth_id', user.id)
        .maybeSingle();
    
    if (response == null) return null;
    
    return MaternalProfile.fromJson(response);
  } catch (e) {
    print('Error fetching maternal profile: $e');
    return null;
  }
});

/// Computed provider: Check if patient has an active pregnancy
/// An active pregnancy = EDD (estimated due date) is in the future
final hasActivePregnancyProvider = Provider<bool>((ref) {
  final maternalProfileAsync = ref.watch(currentMaternalProfileProvider);
  
  return maternalProfileAsync.maybeWhen(
    data: (profile) {
      if (profile == null) return false;
      if (profile.edd == null) return false;
      
      // Active pregnancy = EDD is in the future
      return profile.edd!.isAfter(DateTime.now());
    },
    orElse: () => false,
  );
});

/// Computed provider: Calculate current pregnancy week
final pregnancyWeekProvider = Provider<int?>((ref) {
  final maternalProfileAsync = ref.watch(currentMaternalProfileProvider);
  
  return maternalProfileAsync.maybeWhen(
    data: (profile) {
      if (profile == null) return null;
      if (profile.lmp == null) return null;
      
      // Calculate weeks since LMP (Last Menstrual Period)
      final daysSinceLmp = DateTime.now().difference(profile.lmp!).inDays;
      final weeks = (daysSinceLmp / 7).floor();
      
      // Pregnancy is typically 40 weeks
      if (weeks < 0 || weeks > 45) return null;
      
      return weeks;
    },
    orElse: () => null,
  );
});

/// Computed provider: Days until EDD (due date)
final daysUntilDueDateProvider = Provider<int?>((ref) {
  final maternalProfileAsync = ref.watch(currentMaternalProfileProvider);
  
  return maternalProfileAsync.maybeWhen(
    data: (profile) {
      if (profile == null) return null;
      if (profile.edd == null) return null;
      
      final daysUntil = profile.edd!.difference(DateTime.now()).inDays;
      return daysUntil > 0 ? daysUntil : null;
    },
    orElse: () => null,
  );
});

/// Provider to update maternal profile
final updateMaternalProfileProvider = FutureProvider.family<MaternalProfile, MaternalProfile>((ref, profile) async {
  final repository = ref.read(maternalProfileRepositoryProvider);
  final updatedProfile = await repository.updateProfile(profile);
  
  // Invalidate the current profile to refresh data
  ref.invalidate(currentMaternalProfileProvider);
  
  return updatedProfile;
});
