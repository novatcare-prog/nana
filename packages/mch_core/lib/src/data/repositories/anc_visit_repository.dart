import 'package:supabase_flutter/supabase_flutter.dart';
import '../../models/maternal/anc_visit.dart';

/// Repository for ANC Visit operations using Supabase
class ANCVisitRepository {
  final SupabaseClient _supabase;

  ANCVisitRepository(this._supabase);

  /// Get all visits for a patient
  Future<List<ANCVisit>> getVisitsByPatientId(String maternalProfileId) async {
    try {
      final response = await _supabase
          .from('anc_visits')
          .select()
          .eq('maternal_profile_id', maternalProfileId)
          .order('visit_date', ascending: false); // Newest first

      return (response as List)
          .map((json) => ANCVisit.fromJson(json))
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch visits: $e');
    }
  }

  /// Get a specific visit by ID
  Future<ANCVisit?> getVisitById(String id) async {
    try {
      final response = await _supabase
          .from('anc_visits')
          .select()
          .eq('id', id)
          .single();

      return ANCVisit.fromJson(response);
    } catch (e) {
      return null;
    }
  }

  /// Create a new visit
  Future<void> createVisit(ANCVisit visit) async {
    try {
      await _supabase.from('anc_visits').insert(visit.toJson());
    } catch (e) {
      throw Exception('Failed to create visit: $e');
    }
  }

  /// Update an existing visit
  Future<void> updateVisit(ANCVisit visit) async {
    try {
      await _supabase
          .from('anc_visits')
          .update(visit.toJson())
          .eq('id', visit.id);
    } catch (e) {
      throw Exception('Failed to update visit: $e');
    }
  }

  /// Delete a visit
  Future<void> deleteVisit(String id) async {
    try {
      await _supabase.from('anc_visits').delete().eq('id', id);
    } catch (e) {
      throw Exception('Failed to delete visit: $e');
    }
  }

  /// Get visit count for a patient
  Future<int> getVisitCount(String maternalProfileId) async {
    try {
      final response = await _supabase
          .from('anc_visits')
          .count(CountOption.exact)
          .eq('maternal_profile_id', maternalProfileId);
      
      return response;
    } catch (e) {
      return 0;
    }
  }

  /// Get latest visit for a patient
  Future<ANCVisit?> getLatestVisit(String maternalProfileId) async {
    try {
      final response = await _supabase
          .from('anc_visits')
          .select()
          .eq('maternal_profile_id', maternalProfileId)
          .order('visit_date', ascending: false)
          .limit(1)
          .maybeSingle(); // safe single retrieval

      if (response == null) return null;
      return ANCVisit.fromJson(response);
    } catch (e) {
      return null;
    }
  }

  /// Calculate next contact number for a patient
  Future<int> getNextContactNumber(String maternalProfileId) async {
    final count = await getVisitCount(maternalProfileId);
    return count + 1;
  }
}