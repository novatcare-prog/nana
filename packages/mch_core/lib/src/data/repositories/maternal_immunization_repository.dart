import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:mch_core/mch_core.dart';

/// Maternal Immunization Repository (TT Doses)
class MaternalImmunizationRepository {
  final SupabaseClient _supabase;

  MaternalImmunizationRepository(this._supabase);

  /// Create a new TT immunization record
  Future<MaternalImmunization> createImmunization(
      MaternalImmunization immunization) async {
    try {
      final json = immunization.toJson();
      json.remove('id');

      final response = await _supabase
          .from('maternal_immunizations')
          .insert(json)
          .select()
          .single();

      return MaternalImmunization.fromJson(response);
    } catch (e) {
      throw Exception('Failed to create immunization record: $e');
    }
  }

  /// Get all TT immunizations for a patient
  Future<List<MaternalImmunization>> getImmunizationsByPatientId(
      String patientId) async {
    try {
      final response = await _supabase
          .from('maternal_immunizations')
          .select()
          .eq('maternal_profile_id', patientId)
          .order('dose_date', ascending: true);

      return (response as List)
          .map((json) => MaternalImmunization.fromJson(json))
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch immunizations: $e');
    }
  }

  /// Get latest TT dose for a patient
  Future<MaternalImmunization?> getLatestDose(String patientId) async {
    try {
      final response = await _supabase
          .from('maternal_immunizations')
          .select()
          .eq('maternal_profile_id', patientId)
          .order('tt_dose', ascending: false)
          .limit(1)
          .maybeSingle();

      if (response == null) return null;
      return MaternalImmunization.fromJson(response);
    } catch (e) {
      return null;
    }
  }

  /// Check if patient has received a specific TT dose
  Future<bool> hasDose(String patientId, int doseNumber) async {
    try {
      final response = await _supabase
          .from('maternal_immunizations')
          .select('id')
          .eq('maternal_profile_id', patientId)
          .eq('tt_dose', doseNumber)
          .limit(1);

      return (response as List).isNotEmpty;
    } catch (e) {
      return false;
    }
  }

  /// Update immunization record
  Future<MaternalImmunization> updateImmunization(
      MaternalImmunization immunization) async {
    try {
      if (immunization.id == null) {
        throw Exception('Immunization ID is required for update');
      }

      final response = await _supabase
          .from('maternal_immunizations')
          .update(immunization.toJson())
          .eq('id', immunization.id!)
          .select()
          .single();

      return MaternalImmunization.fromJson(response);
    } catch (e) {
      throw Exception('Failed to update immunization: $e');
    }
  }

  /// Delete immunization record
  Future<void> deleteImmunization(String id) async {
    try {
      await _supabase.from('maternal_immunizations').delete().eq('id', id);
    } catch (e) {
      throw Exception('Failed to delete immunization: $e');
    }
  }
}
