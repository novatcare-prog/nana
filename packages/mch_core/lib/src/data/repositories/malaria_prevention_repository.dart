
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:mch_core/mch_core.dart';

/// Malaria Prevention Repository (IPTp-SP)
class MalariaPreventionRepository {
  final SupabaseClient _supabase;

  MalariaPreventionRepository(this._supabase);

  /// Create a new IPTp record
  Future<MalariaPreventionRecord> createRecord(
      MalariaPreventionRecord record) async {
    try {
      final json = record.toJson();
      json.remove('id');

      final response = await _supabase
          .from('malaria_prevention_records')
          .insert(json)
          .select()
          .single();

      return MalariaPreventionRecord.fromJson(response);
    } catch (e) {
      throw Exception('Failed to create malaria prevention record: $e');
    }
  }

  /// Get all IPTp records for a patient
  Future<List<MalariaPreventionRecord>> getRecordsByPatientId(
      String patientId) async {
    try {
      final response = await _supabase
          .from('malaria_prevention_records')
          .select()
          .eq('maternal_profile_id', patientId)
          .order('dose_date', ascending: true);

      return (response as List)
          .map((json) => MalariaPreventionRecord.fromJson(json))
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch malaria prevention records: $e');
    }
  }

  /// Get latest SP dose for a patient
  Future<MalariaPreventionRecord?> getLatestDose(String patientId) async {
    try {
      final response = await _supabase
          .from('malaria_prevention_records')
          .select()
          .eq('maternal_profile_id', patientId)
          .order('sp_dose', ascending: false)
          .limit(1)
          .maybeSingle();

      if (response == null) return null;
      return MalariaPreventionRecord.fromJson(response);
    } catch (e) {
      return null;
    }
  }

  /// Check if patient has ITN (Insecticide Treated Net)
  Future<bool> hasITN(String patientId) async {
    try {
      final response = await _supabase
          .from('malaria_prevention_records')
          .select('id')
          .eq('maternal_profile_id', patientId)
          .eq('itn_given', true)
          .limit(1);

      return (response as List).isNotEmpty;
    } catch (e) {
      return false;
    }
  }

  /// Update malaria prevention record
  Future<MalariaPreventionRecord> updateRecord(
      MalariaPreventionRecord record) async {
    try {
      if (record.id == null) {
        throw Exception('Record ID is required for update');
      }

      final response = await _supabase
          .from('malaria_prevention_records')
          .update(record.toJson())
          .eq('id', record.id!)
          .select()
          .single();

      return MalariaPreventionRecord.fromJson(response);
    } catch (e) {
      throw Exception('Failed to update malaria prevention record: $e');
    }
  }

  /// Delete malaria prevention record
  Future<void> deleteRecord(String id) async {
    try {
      await _supabase
          .from('malaria_prevention_records')
          .delete()
          .eq('id', id);
    } catch (e) {
      throw Exception('Failed to delete malaria prevention record: $e');
    }
  }
}
































