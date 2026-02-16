import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:mch_core/mch_core.dart';

/// Repository provider for maternal profiles
final maternalProfileRepositoryProvider =
    Provider<SupabaseMaternalProfileRepository>((ref) {
  return SupabaseMaternalProfileRepository(Supabase.instance.client);
});

/// Provider to get the current patient's maternal profile
/// This fetches the logged-in user's maternal profile using auth_id, phone, or ID number
final currentMaternalProfileProvider =
    FutureProvider<MaternalProfile?>((ref) async {
  final supabase = Supabase.instance.client;
  final user = supabase.auth.currentUser;

  if (user == null) return null;

  try {
    // First try: Query by auth_id
    var response = await supabase
        .from('maternal_profiles')
        .select('*, facilities(facility_name)')
        .eq('auth_id', user.id)
        .maybeSingle();

    // If not found by auth_id, try phone and ID number from user metadata
    if (response == null) {
      final userPhone = user.userMetadata?['phone'] as String?;
      final userIdNumber = user.userMetadata?['id_number'] as String?;

      print('📋 Profile not found by auth_id, trying phone: $userPhone and ID: $userIdNumber');

      if (userPhone != null || userIdNumber != null) {
        // Build OR query for phone and/or ID number
        final query = supabase
            .from('maternal_profiles')
            .select('*, facilities(facility_name)');

        if (userPhone != null && userIdNumber != null) {
          // Both available: match either phone OR id_number
          response = await query
              .or('telephone.eq.$userPhone,id_number.eq.$userIdNumber')
              .maybeSingle();
        } else if (userPhone != null) {
          // Only phone available
          response = await query.eq('telephone', userPhone).maybeSingle();
        } else if (userIdNumber != null) {
          // Only ID available
          response = await query.eq('id_number', userIdNumber).maybeSingle();
        }

        // If we found a profile via phone/ID, update its auth_id
        if (response != null && response['auth_id'] == null) {
          print('✅ Found profile via phone/ID, updating auth_id');
          await supabase
              .from('maternal_profiles')
              .update({'auth_id': user.id})
              .eq('id', response['id']);
          
          // Update local response with new auth_id
          response['auth_id'] = user.id;
        }
      }
    }

    if (response == null) {
      print('📋 No maternal profile found for user ${user.id}');
      return null;
    }

    // Map facility name if it came from relation
    final data = Map<String, dynamic>.from(response);
    if (data['facilities'] != null &&
        data['facilities']['facility_name'] != null) {
      data['facility_name'] = data['facilities']['facility_name'];
    }

    print('✅ Maternal profile loaded: ${data['client_name']}');
    return MaternalProfile.fromJson(data);
  } catch (e) {
    print('❌ Error fetching maternal profile: $e');
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
final updateMaternalProfileProvider =
    FutureProvider.family<MaternalProfile, MaternalProfile>(
        (ref, profile) async {
  final repository = ref.read(maternalProfileRepositoryProvider);
  final updatedProfile = await repository.updateProfile(profile);

  // Invalidate the current profile to refresh data
  ref.invalidate(currentMaternalProfileProvider);

  return updatedProfile;
});
