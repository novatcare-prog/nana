import 'package:supabase_flutter/supabase_flutter.dart';
import '../../models/child/developmental_milestone.dart';

class DevelopmentalMilestoneRepository {
  final SupabaseClient _supabase;

  DevelopmentalMilestoneRepository(this._supabase);

  // Create new milestone assessment
  Future<DevelopmentalMilestone> createMilestone(DevelopmentalMilestone milestone) async {
    final jsonData = milestone.toJson();
    // Remove id if it's null (database will generate it)
    jsonData.remove('id');
    
    final data = await _supabase
        .from('developmental_milestones')
        .insert(jsonData)
        .select()
        .single();

    return DevelopmentalMilestone.fromJson(data);
  }

  // Get all milestones for a child
  Future<List<DevelopmentalMilestone>> getMilestonesByChildId(String childId) async {
    final data = await _supabase
        .from('developmental_milestones')
        .select()
        .eq('child_profile_id', childId)
        .order('assessment_date', ascending: false);

    return (data as List).map((e) => DevelopmentalMilestone.fromJson(e)).toList();
  }

  // Get single milestone by ID
  Future<DevelopmentalMilestone?> getMilestoneById(String id) async {
    final data = await _supabase
        .from('developmental_milestones')
        .select()
        .eq('id', id)
        .maybeSingle();

    return data != null ? DevelopmentalMilestone.fromJson(data) : null;
  }

  // Update milestone
  Future<DevelopmentalMilestone> updateMilestone(DevelopmentalMilestone milestone) async {
    final data = await _supabase
        .from('developmental_milestones')
        .update(milestone.toJson())
        .eq('id', milestone.id!)
        .select()
        .single();

    return DevelopmentalMilestone.fromJson(data);
  }

  // Delete milestone
  Future<void> deleteMilestone(String id) async {
    await _supabase
        .from('developmental_milestones')
        .delete()
        .eq('id', id);
  }

  // Get upcoming assessments
  Future<List<DevelopmentalMilestone>> getUpcomingAssessments(String childId) async {
    final now = DateTime.now().toIso8601String().split('T')[0];
    
    final data = await _supabase
        .from('developmental_milestones')
        .select()
        .eq('child_profile_id', childId)
        .gte('next_assessment_date', now)
        .order('next_assessment_date', ascending: true);

    return (data as List).map((e) => DevelopmentalMilestone.fromJson(e)).toList();
  }

  // Get milestones with red flags
  Future<List<DevelopmentalMilestone>> getMilestonesWithRedFlags(String childId) async {
    final data = await _supabase
        .from('developmental_milestones')
        .select()
        .eq('child_profile_id', childId)
        .eq('red_flags_present', true)
        .order('assessment_date', ascending: false);

    return (data as List).map((e) => DevelopmentalMilestone.fromJson(e)).toList();
  }

  // Get latest milestone
  Future<DevelopmentalMilestone?> getLatestMilestone(String childId) async {
    final data = await _supabase
        .from('developmental_milestones')
        .select()
        .eq('child_profile_id', childId)
        .order('assessment_date', ascending: false)
        .limit(1)
        .maybeSingle();

    return data != null ? DevelopmentalMilestone.fromJson(data) : null;
  }

  // Get milestones by status
  Future<List<DevelopmentalMilestone>> getMilestonesByStatus(
    String childId,
    String status,
  ) async {
    final data = await _supabase
        .from('developmental_milestones')
        .select()
        .eq('child_profile_id', childId)
        .eq('overall_status', status)
        .order('assessment_date', ascending: false);

    return (data as List).map((e) => DevelopmentalMilestone.fromJson(e)).toList();
  }
}