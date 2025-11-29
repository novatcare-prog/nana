import 'package:supabase_flutter/supabase_flutter.dart';
import '../../models/child/vitamin_a_record.dart';

class VitaminARepository {
  final SupabaseClient _supabase;

  VitaminARepository(this._supabase);

  // Create new Vitamin A record
  Future<VitaminARecord> createVitaminA(VitaminARecord record) async {
    final jsonData = record.toJson();
    // Remove id if it's null (database will generate it)
    jsonData.remove('id');
    
    final data = await _supabase
        .from('vitamin_a_supplementation')
        .insert(jsonData)
        .select()
        .single();

    return VitaminARecord.fromJson(data);
  }

  // Get all Vitamin A records for a child
  Future<List<VitaminARecord>> getVitaminAByChildId(String childId) async {
    final data = await _supabase
        .from('vitamin_a_supplementation')
        .select()
        .eq('child_profile_id', childId)
        .order('date_given', ascending: false);

    return (data as List).map((e) => VitaminARecord.fromJson(e)).toList();
  }

  // Get single Vitamin A record by ID
  Future<VitaminARecord?> getVitaminAById(String id) async {
    final data = await _supabase
        .from('vitamin_a_supplementation')
        .select()
        .eq('id', id)
        .maybeSingle();

    return data != null ? VitaminARecord.fromJson(data) : null;
  }

  // Update Vitamin A record
  Future<VitaminARecord> updateVitaminA(VitaminARecord record) async {
    final data = await _supabase
        .from('vitamin_a_supplementation')
        .update(record.toJson())
        .eq('id', record.id!)
        .select()
        .single();

    return VitaminARecord.fromJson(data);
  }

  // Delete Vitamin A record
  Future<void> deleteVitaminA(String id) async {
    await _supabase
        .from('vitamin_a_supplementation')
        .delete()
        .eq('id', id);
  }

  // Get upcoming due doses
  Future<List<VitaminARecord>> getUpcomingDueDoses(String childId) async {
    final now = DateTime.now().toIso8601String().split('T')[0];
    
    final data = await _supabase
        .from('vitamin_a_supplementation')
        .select()
        .eq('child_profile_id', childId)
        .gte('next_dose_due_date', now)
        .order('next_dose_due_date', ascending: true);

    return (data as List).map((e) => VitaminARecord.fromJson(e)).toList();
  }

  // Get total doses given
  Future<int> getTotalDosesCount(String childId) async {
    final data = await _supabase
        .from('vitamin_a_supplementation')
        .select()
        .eq('child_profile_id', childId);

    return (data as List).length;
  }

  // Get last dose given
  Future<VitaminARecord?> getLastDose(String childId) async {
    final data = await _supabase
        .from('vitamin_a_supplementation')
        .select()
        .eq('child_profile_id', childId)
        .order('date_given', ascending: false)
        .limit(1)
        .maybeSingle();

    return data != null ? VitaminARecord.fromJson(data) : null;
  }
}