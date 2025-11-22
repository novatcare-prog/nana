import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:mch_core/mch_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Maternal Profile Repository using Supabase
class SupabaseMaternalProfileRepository {
  final SupabaseClient _supabase;

  SupabaseMaternalProfileRepository(this._supabase);

  /// ✅ NEW FUNCTION TO UPDATE DASHBOARD
  Future<void> flagPatientAsHighRisk(String profileId) async {
    try {
      await _supabase
          .from('maternal_profiles')
          .update({
            // This is the column your dashboard is already checking
            'hypertension': true 
          })
          .eq('id', profileId);
    } catch (e) {
      print('Failed to flag patient as high risk: $e');
      // Don't re-throw, as failing to flag is not a critical error
    }
  }

  /// Create a new maternal profile
Future<MaternalProfile> createProfile(MaternalProfile profile) async {
  try {
    final json = profile.toJson();
    
    // Remove id field - let database generate UUID
    json.remove('id');
    
    // Also remove created_at and updated_at - let database handle these
    json.remove('created_at');
    json.remove('updated_at');
    
    final response = await _supabase
        .from('maternal_profiles')
        .insert(json)
        .select()
        .single();

    return MaternalProfile.fromJson(response);
  } catch (e) {
    throw Exception('Failed to create profile: $e');
  }
}

  /// Get all maternal profiles
  Future<List<MaternalProfile>> getAllProfiles() async {
    try {
      final response = await _supabase
          .from('maternal_profiles')
          .select()
          .order('created_at', ascending: false);

      return (response as List)
          .map((json) => MaternalProfile.fromJson(json))
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch profiles: $e');
    }
  }

  /// Get a single profile by ID
  Future<MaternalProfile?> getProfileById(String id) async {
    try {
      final response = await _supabase
          .from('maternal_profiles')
          .select()
          .eq('id', id)
          .single();

      return MaternalProfile.fromJson(response);
    } catch (e) {
      return null;
    }
  }

  /// Update a maternal profile
  Future<MaternalProfile> updateProfile(MaternalProfile profile) async {
    try {
      final response = await _supabase
          .from('maternal_profiles')
          .update(profile.toJson())
          .eq('id', profile.id!)
          .select()
          .single();

      return MaternalProfile.fromJson(response);
    } catch (e) {
      throw Exception('Failed to update profile: $e');
    }
  }

  /// Delete a maternal profile
  Future<void> deleteProfile(String id) async {
    try {
      await _supabase.from('maternal_profiles').delete().eq('id', id);
    } catch (e) {
      throw Exception('Failed to delete profile: $e');
    }
  }

  /// Get statistics (This is for your dashboard)
  Future<Map<String, int>> getStatistics() async {
    try {
      final allProfiles = await getAllProfiles();
      
      final highRisk = allProfiles.where((p) => 
        p.diabetes == true || p.hypertension == true || p.previousCs == true || p.age > 35 || p.age < 18
      ).length;

      final now = DateTime.now();
      final thirtyDaysFromNow = now.add(const Duration(days: 30));
      final dueSoon = allProfiles.where((p) => 
        p.edd.isAfter(now) && p.edd.isBefore(thirtyDaysFromNow)
      ).length;

      return {
        'total': allProfiles.length,
        'highRisk': highRisk,
        'dueSoon': dueSoon,
      };
    } catch (e) {
      throw Exception('Failed to fetch statistics: $e');
    }
  }

  // ... (keep any other functions you have, like search)
}

// --- PROVIDERS ---
// (These should already be in yoursupabase_providers.dart or here)

final maternalProfileRepositoryProvider = Provider((ref) {
  return SupabaseMaternalProfileRepository(Supabase.instance.client);
});

final maternalProfilesProvider = FutureProvider<List<MaternalProfile>>((ref) async {
  return ref.watch(maternalProfileRepositoryProvider).getAllProfiles();
});

final statisticsProvider = FutureProvider<Map<String, int>>((ref) async {
  return ref.watch(maternalProfileRepositoryProvider).getStatistics();
});