import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:mch_core/mch_core.dart';

/// Immunization Record Repository
class ImmunizationRepository {
  final SupabaseClient _supabase;

  ImmunizationRepository(this._supabase);

  /// Create a new immunization record
  Future<ImmunizationRecord> createImmunization(ImmunizationRecord immunization) async {
    try {
      final json = immunization.toJson();
      json.remove('id');
      json.remove('created_at');
      json.remove('updated_at');

      final response = await _supabase
          .from('child_immunizations')
          .insert(json)
          .select()
          .single();

      return ImmunizationRecord.fromJson(response);
    } catch (e) {
      throw Exception('Failed to create immunization record: $e');
    }
  }

  /// Get all immunizations for a child
  Future<List<ImmunizationRecord>> getImmunizationsByChildId(String childId) async {
    try {
      final response = await _supabase
          .from('child_immunizations')
          .select()
          .eq('child_profile_id', childId)
          .order('date_given', ascending: false);

      return (response as List)
          .map((json) => ImmunizationRecord.fromJson(json))
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch immunizations: $e');
    }
  }

  /// Get single immunization by ID
  Future<ImmunizationRecord?> getImmunizationById(String id) async {
    try {
      final response = await _supabase
          .from('child_immunizations')
          .select()
          .eq('id', id)
          .single();

      return ImmunizationRecord.fromJson(response);
    } catch (e) {
      return null;
    }
  }

  /// Update immunization record
  Future<ImmunizationRecord> updateImmunization(ImmunizationRecord immunization) async {
    try {
      if (immunization.id == null) {
        throw Exception('Immunization ID is required for update');
      }

      final response = await _supabase
          .from('child_immunizations')
          .update(immunization.toJson())
          .eq('id', immunization.id!)
          .select()
          .single();

      return ImmunizationRecord.fromJson(response);
    } catch (e) {
      throw Exception('Failed to update immunization: $e');
    }
  }

  /// Delete immunization record
  Future<void> deleteImmunization(String id) async {
    try {
      await _supabase
          .from('child_immunizations')
          .delete()
          .eq('id', id);
    } catch (e) {
      throw Exception('Failed to delete immunization: $e');
    }
  }

  /// Get immunizations by vaccine type
  Future<List<ImmunizationRecord>> getImmunizationsByVaccineType({
    required String childId,
    required ImmunizationType vaccineType,
  }) async {
    try {
      final response = await _supabase
          .from('child_immunizations')
          .select()
          .eq('child_profile_id', childId)
          .eq('vaccine_type', vaccineType.label)
          .order('date_given', ascending: true);

      return (response as List)
          .map((json) => ImmunizationRecord.fromJson(json))
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch immunizations by type: $e');
    }
  }

  /// Get upcoming due vaccines for a child
  Future<List<ImmunizationRecord>> getUpcomingDueVaccines(String childId) async {
    try {
      final today = DateTime.now();
      final response = await _supabase
          .from('child_immunizations')
          .select()
          .eq('child_profile_id', childId)
          .gte('next_dose_due_date', today.toIso8601String())
          .order('next_dose_due_date', ascending: true);

      return (response as List)
          .map((json) => ImmunizationRecord.fromJson(json))
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch upcoming vaccines: $e');
    }
  }

  /// Get immunizations with adverse reactions
  Future<List<ImmunizationRecord>> getImmunizationsWithReactions(String childId) async {
    try {
      final response = await _supabase
          .from('child_immunizations')
          .select()
          .eq('child_profile_id', childId)
          .eq('adverse_reaction', true)
          .order('date_given', ascending: false);

      return (response as List)
          .map((json) => ImmunizationRecord.fromJson(json))
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch immunizations with reactions: $e');
    }
  }

  /// Get immunization coverage for a child
  /// Returns a map of vaccine type to number of doses received
  Future<Map<ImmunizationType, int>> getImmunizationCoverage(String childId) async {
    try {
      final immunizations = await getImmunizationsByChildId(childId);
      
      final coverage = <ImmunizationType, int>{};
      for (final immunization in immunizations) {
        coverage[immunization.vaccineType] = 
            (coverage[immunization.vaccineType] ?? 0) + 1;
      }
      
      return coverage;
    } catch (e) {
      throw Exception('Failed to calculate immunization coverage: $e');
    }
  }
}