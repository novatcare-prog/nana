import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:mch_core/mch_core.dart';

/// Growth Record Repository
class GrowthRecordRepository {
  final SupabaseClient _supabase;

  GrowthRecordRepository(this._supabase);

  /// Create a new growth record
  Future<GrowthRecord> createRecord(GrowthRecord record) async {
    try {
      final json = record.toJson();
      json.remove('id');
      json.remove('created_at');
      json.remove('updated_at');

      final response = await _supabase
          .from('growth_monitoring')
          .insert(json)
          .select()
          .single();

      return GrowthRecord.fromJson(response);
    } catch (e) {
      throw Exception('Failed to create growth record: $e');
    }
  }

  /// Get all growth records for a child
  Future<List<GrowthRecord>> getRecordsByChildId(String childId) async {
    try {
      final response = await _supabase
          .from('growth_monitoring')
          .select()
          .eq('child_profile_id', childId)
          .order('visit_date', ascending: false);

      return (response as List)
          .map((json) => GrowthRecord.fromJson(json))
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch growth records: $e');
    }
  }

  /// Get single growth record by ID
  Future<GrowthRecord?> getRecordById(String id) async {
    try {
      final response = await _supabase
          .from('growth_monitoring')
          .select()
          .eq('id', id)
          .single();

      return GrowthRecord.fromJson(response);
    } catch (e) {
      return null;
    }
  }

  /// Update growth record
  Future<GrowthRecord> updateRecord(GrowthRecord record) async {
    try {
      if (record.id == null) {
        throw Exception('Record ID is required for update');
      }

      final response = await _supabase
          .from('growth_monitoring')
          .update(record.toJson())
          .eq('id', record.id!)
          .select()
          .single();

      return GrowthRecord.fromJson(response);
    } catch (e) {
      throw Exception('Failed to update growth record: $e');
    }
  }

  /// Delete growth record
  Future<void> deleteRecord(String id) async {
    try {
      await _supabase
          .from('growth_monitoring')
          .delete()
          .eq('id', id);
    } catch (e) {
      throw Exception('Failed to delete growth record: $e');
    }
  }

  /// Get latest growth record for a child
  Future<GrowthRecord?> getLatestRecord(String childId) async {
    try {
      final response = await _supabase
          .from('growth_monitoring')
          .select()
          .eq('child_profile_id', childId)
          .order('visit_date', ascending: false)
          .limit(1)
          .maybeSingle();

      if (response == null) return null;
      return GrowthRecord.fromJson(response);
    } catch (e) {
      return null;
    }
  }

  /// Get growth records within a date range
  Future<List<GrowthRecord>> getRecordsByDateRange({
    required String childId,
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    try {
      final response = await _supabase
          .from('growth_monitoring')
          .select()
          .eq('child_profile_id', childId)
          .gte('visit_date', startDate.toIso8601String())
          .lte('visit_date', endDate.toIso8601String())
          .order('visit_date', ascending: true);

      return (response as List)
          .map((json) => GrowthRecord.fromJson(json))
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch growth records by date range: $e');
    }
  }

  /// Get records with malnutrition concerns (for alerts/dashboard)
  Future<List<GrowthRecord>> getMalnutritionCases() async {
    try {
      final response = await _supabase
          .from('growth_monitoring')
          .select()
          .or('edema_present.eq.true,referred_for_nutrition.eq.true')
          .order('visit_date', ascending: false)
          .limit(50);

      return (response as List)
          .map((json) => GrowthRecord.fromJson(json))
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch malnutrition cases: $e');
    }
  }

  /// Get all children needing growth monitoring follow-up
  Future<List<GrowthRecord>> getChildrenNeedingFollowUp() async {
    try {
      final today = DateTime.now();
      final response = await _supabase
          .from('growth_monitoring')
          .select()
          .lte('next_visit_date', today.toIso8601String())
          .order('next_visit_date', ascending: true);

      return (response as List)
          .map((json) => GrowthRecord.fromJson(json))
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch follow-up cases: $e');
    }
  }
}