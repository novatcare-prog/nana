import 'package:supabase_flutter/supabase_flutter.dart';
import '../../models/child/deworming_record.dart';

class DewormingRepository {
  final SupabaseClient _supabase;

  DewormingRepository(this._supabase);

  // Create new deworming record
  Future<DewormingRecord> createDeworming(DewormingRecord record) async {
    final jsonData = record.toJson();
    // Remove id if it's null (database will generate it)
    jsonData.remove('id');
    
    final data = await _supabase
        .from('deworming')
        .insert(jsonData)
        .select()
        .single();

    return DewormingRecord.fromJson(data);
  }

  // Get all deworming records for a child
  Future<List<DewormingRecord>> getDewormingByChildId(String childId) async {
    final data = await _supabase
        .from('deworming')
        .select()
        .eq('child_profile_id', childId)
        .order('date_given', ascending: false);

    return (data as List).map((e) => DewormingRecord.fromJson(e)).toList();
  }

  // Get single deworming record by ID
  Future<DewormingRecord?> getDewormingById(String id) async {
    final data = await _supabase
        .from('deworming')
        .select()
        .eq('id', id)
        .maybeSingle();

    return data != null ? DewormingRecord.fromJson(data) : null;
  }

  // Update deworming record
  Future<DewormingRecord> updateDeworming(DewormingRecord record) async {
    final data = await _supabase
        .from('deworming')
        .update(record.toJson())
        .eq('id', record.id!)
        .select()
        .single();

    return DewormingRecord.fromJson(data);
  }

  // Delete deworming record
  Future<void> deleteDeworming(String id) async {
    await _supabase
        .from('deworming')
        .delete()
        .eq('id', id);
  }

  // Get upcoming due doses
  Future<List<DewormingRecord>> getUpcomingDueDoses(String childId) async {
    final now = DateTime.now().toIso8601String().split('T')[0];
    
    final data = await _supabase
        .from('deworming')
        .select()
        .eq('child_profile_id', childId)
        .gte('next_dose_due_date', now)
        .order('next_dose_due_date', ascending: true);

    return (data as List).map((e) => DewormingRecord.fromJson(e)).toList();
  }

  // Get records with side effects
  Future<List<DewormingRecord>> getRecordsWithSideEffects(String childId) async {
    final data = await _supabase
        .from('deworming')
        .select()
        .eq('child_profile_id', childId)
        .eq('side_effects_reported', true)
        .order('date_given', ascending: false);

    return (data as List).map((e) => DewormingRecord.fromJson(e)).toList();
  }

  // Get total doses given
  Future<int> getTotalDosesCount(String childId) async {
    final data = await _supabase
        .from('deworming')
        .select()
        .eq('child_profile_id', childId);

    return (data as List).length;
  }

  // Get last dose given
  Future<DewormingRecord?> getLastDose(String childId) async {
    final data = await _supabase
        .from('deworming')
        .select()
        .eq('child_profile_id', childId)
        .order('date_given', ascending: false)
        .limit(1)
        .maybeSingle();

    return data != null ? DewormingRecord.fromJson(data) : null;
  }
}