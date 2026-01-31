import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:mch_core/mch_core.dart';

/// Maternal Profile Repository using Supabase
class SupabaseMaternalProfileRepository {
  final SupabaseClient _supabase;

  SupabaseMaternalProfileRepository(this._supabase);

  /// Updates a patient's profile to flag them as high risk.
  Future<void> flagPatientAsHighRisk(String profileId) async {
    try {
      await _supabase
          .from('maternal_profiles') // Correct table
          .update({'hypertension': true}).eq('id', profileId);
    } catch (e) {
      print('Failed to flag patient as high risk: $e');
    }
  }

  /// Create a new maternal profile
  Future<MaternalProfile> createProfile(MaternalProfile profile) async {
    try {
      final response = await _supabase
          .from('maternal_profiles') // Correct table
          .insert(profile.toJson())
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
          .from('maternal_profiles') // ✅ FIX was here
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
          .from('maternal_profiles') // Correct table
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
          .from('maternal_profiles') // Correct table
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
      await _supabase
          .from('maternal_profiles')
          .delete()
          .eq('id', id); // Correct table
    } catch (e) {
      throw Exception('Failed to delete profile: $e');
    }
  }

  /// Get high-risk profiles
  Future<List<MaternalProfile>> getHighRiskProfiles() async {
    try {
      final response = await _supabase
          .from('maternal_profiles') // Correct table
          .select()
          .or('diabetes.eq.true,hypertension.eq.true,tuberculosis.eq.true,previous_cs.eq.true,age.gt.35,age.lt.18')
          .order('created_at', ascending: false);

      return (response as List)
          .map((json) => MaternalProfile.fromJson(json))
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch high-risk profiles: $e');
    }
  }

  /// Get profiles due soon (within 30 days)
  Future<List<MaternalProfile>> getProfilesDueSoon() async {
    try {
      final now = DateTime.now();
      final thirtyDaysFromNow = now.add(const Duration(days: 30));

      final response = await _supabase
          .from('maternal_profiles') // Correct table
          .select()
          .gte('edd', now.toIso8601String())
          .lte('edd', thirtyDaysFromNow.toIso8601String())
          .order('edd', ascending: true);

      return (response as List)
          .map((json) => MaternalProfile.fromJson(json))
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch profiles due soon: $e');
    }
  }

  /// Search profiles by name or ANC number
  Future<List<MaternalProfile>> searchProfiles(String query) async {
    try {
      final response = await _supabase
          .from('maternal_profiles') // Correct table
          .select()
          .or('client_name.ilike.%$query%,anc_number.ilike.%$query%')
          .order('created_at', ascending: false);

      return (response as List)
          .map((json) => MaternalProfile.fromJson(json))
          .toList();
    } catch (e) {
      throw Exception('Failed to search profiles: $e');
    }
  }

  /// Get statistics (This is for your dashboard)
  Future<Map<String, int>> getStatistics() async {
    try {
      // Use .count() for efficiency instead of fetching all profiles
      final totalResponse = await _supabase
          .from('maternal_profiles') // Correct table
          .count(CountOption.exact);

      final highRiskResponse = await _supabase
          .from('maternal_profiles') // Correct table
          .count(CountOption.exact)
          .or('diabetes.eq.true,hypertension.eq.true,tuberculosis.eq.true,previous_cs.eq.true,age.gt.35,age.lt.18');

      final now = DateTime.now();
      final thirtyDaysFromNow = now.add(const Duration(days: 30));
      final dueSoonResponse = await _supabase
          .from('maternal_profiles') // Correct table
          .count(CountOption.exact)
          .gte('edd', now.toIso8601String())
          .lte('edd', thirtyDaysFromNow.toIso8601String());

      return {
        'total': totalResponse,
        'highRisk': highRiskResponse,
        'dueSoon': dueSoonResponse,
      };
    } catch (e) {
      throw Exception('Failed to fetch statistics: $e');
    }
  }
}
