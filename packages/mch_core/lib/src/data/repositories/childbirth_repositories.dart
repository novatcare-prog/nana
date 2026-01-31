import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:mch_core/mch_core.dart';

/// Childbirth Record Repository
class ChildbirthRecordRepository {
  final SupabaseClient _supabase;

  ChildbirthRecordRepository(this._supabase);

  /// Create childbirth record and child profile
  Future<Map<String, dynamic>> createDeliveryRecord({
    required ChildbirthRecord childbirthRecord,
    required ChildProfile childProfile,
  }) async {
    try {
      // 1. Create childbirth record
      final birthJson = childbirthRecord.toJson();
      birthJson.remove('id');
      birthJson.remove('created_at');
      birthJson.remove('updated_at');

      final birthResponse = await _supabase
          .from('childbirth_records')
          .insert(birthJson)
          .select()
          .single();

      final createdBirth = ChildbirthRecord.fromJson(birthResponse);

      // 2. Create child profile linked to birth record
      final childJson = childProfile.toJson();
      childJson.remove('id');
      childJson.remove('created_at');
      childJson.remove('updated_at');
      childJson['childbirth_record_id'] = createdBirth.id;

      final childResponse = await _supabase
          .from('child_profiles')
          .insert(childJson)
          .select()
          .single();

      final createdChild = ChildProfile.fromJson(childResponse);

      return {
        'childbirth_record': createdBirth,
        'child_profile': createdChild,
      };
    } catch (e) {
      throw Exception('Failed to create delivery record: $e');
    }
  }

  /// Get childbirth records for a patient
  Future<List<ChildbirthRecord>> getRecordsByPatientId(
      String maternalProfileId) async {
    try {
      final response = await _supabase
          .from('childbirth_records')
          .select()
          .eq('maternal_profile_id', maternalProfileId)
          .order('delivery_date', ascending: false);

      return (response as List)
          .map((json) => ChildbirthRecord.fromJson(json))
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch childbirth records: $e');
    }
  }

  /// Get single childbirth record
  Future<ChildbirthRecord?> getRecordById(String id) async {
    try {
      final response = await _supabase
          .from('childbirth_records')
          .select()
          .eq('id', id)
          .single();

      return ChildbirthRecord.fromJson(response);
    } catch (e) {
      return null;
    }
  }

  /// Update childbirth record
  Future<ChildbirthRecord> updateRecord(ChildbirthRecord record) async {
    try {
      final response = await _supabase
          .from('childbirth_records')
          .update(record.toJson())
          .eq('id', record.id!)
          .select()
          .single();

      return ChildbirthRecord.fromJson(response);
    } catch (e) {
      throw Exception('Failed to update childbirth record: $e');
    }
  }

  /// Delete childbirth record
  Future<void> deleteRecord(String id) async {
    try {
      await _supabase.from('childbirth_records').delete().eq('id', id);
    } catch (e) {
      throw Exception('Failed to delete childbirth record: $e');
    }
  }
}

/// Child Profile Repository
class ChildProfileRepository {
  final SupabaseClient _supabase;

  ChildProfileRepository(this._supabase);

  /// Get all children for a mother
  Future<List<ChildProfile>> getChildrenByMotherId(
      String maternalProfileId) async {
    try {
      final response = await _supabase
          .from('child_profiles')
          .select()
          .eq('maternal_profile_id', maternalProfileId)
          .eq('is_active', true)
          .order('date_of_birth', ascending: false);

      return (response as List)
          .map((json) => ChildProfile.fromJson(json))
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch children: $e');
    }
  }

  /// Get single child profile
  Future<ChildProfile?> getChildById(String id) async {
    try {
      final response =
          await _supabase.from('child_profiles').select().eq('id', id).single();

      return ChildProfile.fromJson(response);
    } catch (e) {
      return null;
    }
  }

  /// Update child profile
  Future<ChildProfile> updateChild(ChildProfile child) async {
    try {
      final response = await _supabase
          .from('child_profiles')
          .update(child.toJson())
          .eq('id', child.id)
          .select()
          .single();

      return ChildProfile.fromJson(response);
    } catch (e) {
      throw Exception('Failed to update child profile: $e');
    }
  }

  /// Create child profile (standalone, not from delivery)
  Future<ChildProfile> createChild(ChildProfile child) async {
    try {
      final json = child.toJson();
      json.remove('id');
      json.remove('created_at');
      json.remove('updated_at');

      final response =
          await _supabase.from('child_profiles').insert(json).select().single();

      return ChildProfile.fromJson(response);
    } catch (e) {
      throw Exception('Failed to create child profile: $e');
    }
  }

  /// Get all active children (for overall statistics)
  Future<List<ChildProfile>> getAllActiveChildren() async {
    try {
      final response = await _supabase
          .from('child_profiles')
          .select()
          .eq('is_active', true)
          .order('date_of_birth', ascending: false);

      return (response as List)
          .map((json) => ChildProfile.fromJson(json))
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch children: $e');
    }
  }

  /// Deactivate child profile (soft delete)
  Future<void> deactivateChild(String id) async {
    try {
      await _supabase.from('child_profiles').update({
        'is_active': false,
        'updated_at': DateTime.now().toIso8601String()
      }).eq('id', id);
    } catch (e) {
      throw Exception('Failed to deactivate child: $e');
    }
  }

  /// Delete child profile (hard delete)
  Future<void> deleteChild(String id) async {
    try {
      await _supabase.from('child_profiles').delete().eq('id', id);
    } catch (e) {
      throw Exception('Failed to delete child: $e');
    }
  }
}
