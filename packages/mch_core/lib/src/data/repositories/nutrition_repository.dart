import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:mch_core/mch_core.dart';

/// Nutrition Records Repository
class NutritionRepository {
  final SupabaseClient _supabase;

  NutritionRepository(this._supabase);

  /// Create a new nutrition record
  Future<NutritionRecord> createRecord(NutritionRecord record) async {
    try {
      final json = record.toJson();
      json.remove('id');

      final response = await _supabase
          .from('nutrition_records')
          .insert(json)
          .select()
          .single();

      return NutritionRecord.fromJson(response);
    } catch (e) {
      throw Exception('Failed to create nutrition record: $e');
    }
  }

  /// Get all nutrition records for a patient
  Future<List<NutritionRecord>> getRecordsByPatientId(String patientId) async {
    try {
      final response = await _supabase
          .from('nutrition_records')
          .select()
          .eq('maternal_profile_id', patientId)
          .order('record_date', ascending: false);

      return (response as List)
          .map((json) => NutritionRecord.fromJson(json))
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch nutrition records: $e');
    }
  }

  /// Get latest nutrition record for a patient
  Future<NutritionRecord?> getLatestRecord(String patientId) async {
    try {
      final response = await _supabase
          .from('nutrition_records')
          .select()
          .eq('maternal_profile_id', patientId)
          .order('record_date', ascending: false)
          .limit(1)
          .maybeSingle();

      if (response == null) return null;
      return NutritionRecord.fromJson(response);
    } catch (e) {
      return null;
    }
  }

  /// Get malnourished patients
  Future<List<NutritionRecord>> getMalnourishedPatients() async {
    try {
      final response = await _supabase
          .from('nutrition_records')
          .select()
          .eq('is_malnourished', true)
          .order('record_date', ascending: false);

      return (response as List)
          .map((json) => NutritionRecord.fromJson(json))
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch malnourished patients: $e');
    }
  }

  /// Update nutrition record
  Future<NutritionRecord> updateRecord(NutritionRecord record) async {
    try {
      if (record.id == null) {
        throw Exception('Record ID is required for update');
      }

      final response = await _supabase
          .from('nutrition_records')
          .update(record.toJson())
          .eq('id', record.id!)
          .select()
          .single();

      return NutritionRecord.fromJson(response);
    } catch (e) {
      throw Exception('Failed to update nutrition record: $e');
    }
  }

  /// Delete nutrition record
  Future<void> deleteRecord(String id) async {
    try {
      await _supabase.from('nutrition_records').delete().eq('id', id);
    } catch (e) {
      throw Exception('Failed to delete nutrition record: $e');
    }
  }
}