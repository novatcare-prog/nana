import 'package:supabase_flutter/supabase_flutter.dart';
import '../../models/maternal/postnatal_visit.dart';

class PostnatalVisitRepository {
  final SupabaseClient _supabase;

  PostnatalVisitRepository(this._supabase);

  // Create new postnatal visit
  Future<PostnatalVisit> createVisit(PostnatalVisit visit) async {
    final jsonData = visit.toJson();
    // Remove id if it's null (database will generate it)
    jsonData.remove('id');

    final data = await _supabase
        .from('postnatal_visits')
        .insert(jsonData)
        .select()
        .single();

    return PostnatalVisit.fromJson(data);
  }

  // Get all visits for a maternal profile
  Future<List<PostnatalVisit>> getVisitsByMaternalId(String maternalProfileId) async {
    final data = await _supabase
        .from('postnatal_visits')
        .select()
        .eq('maternal_profile_id', maternalProfileId)
        .order('visit_date', ascending: false);

    return (data as List).map((e) => PostnatalVisit.fromJson(e)).toList();
  }

  // Get all visits for a child
  Future<List<PostnatalVisit>> getVisitsByChildId(String childId) async {
    final data = await _supabase
        .from('postnatal_visits')
        .select()
        .eq('child_profile_id', childId)
        .order('visit_date', ascending: false);

    return (data as List).map((e) => PostnatalVisit.fromJson(e)).toList();
  }

  // Get single visit by ID
  Future<PostnatalVisit?> getVisitById(String id) async {
    final data = await _supabase
        .from('postnatal_visits')
        .select()
        .eq('id', id)
        .maybeSingle();

    return data != null ? PostnatalVisit.fromJson(data) : null;
  }

  // Update visit
  Future<PostnatalVisit> updateVisit(PostnatalVisit visit) async {
    final data = await _supabase
        .from('postnatal_visits')
        .update(visit.toJson())
        .eq('id', visit.id!)
        .select()
        .single();

    return PostnatalVisit.fromJson(data);
  }

  // Delete visit
  Future<void> deleteVisit(String id) async {
    await _supabase
        .from('postnatal_visits')
        .delete()
        .eq('id', id);
  }

  // Get upcoming visits
  Future<List<PostnatalVisit>> getUpcomingVisits(String maternalProfileId) async {
    final now = DateTime.now().toIso8601String().split('T')[0];

    final data = await _supabase
        .from('postnatal_visits')
        .select()
        .eq('maternal_profile_id', maternalProfileId)
        .gte('next_visit_date', now)
        .order('next_visit_date', ascending: true);

    return (data as List).map((e) => PostnatalVisit.fromJson(e)).toList();
  }

  // Get visits with danger signs
  Future<List<PostnatalVisit>> getVisitsWithDangerSigns(String maternalProfileId) async {
    final data = await _supabase
        .from('postnatal_visits')
        .select()
        .eq('maternal_profile_id', maternalProfileId)
        .or('excessive_bleeding.eq.true,maternal_danger_signs.not.is.null,baby_danger_signs.not.is.null')
        .order('visit_date', ascending: false);

    return (data as List).map((e) => PostnatalVisit.fromJson(e)).toList();
  }

  // Get latest visit
  Future<PostnatalVisit?> getLatestVisit(String maternalProfileId) async {
    final data = await _supabase
        .from('postnatal_visits')
        .select()
        .eq('maternal_profile_id', maternalProfileId)
        .order('visit_date', ascending: false)
        .limit(1)
        .maybeSingle();

    return data != null ? PostnatalVisit.fromJson(data) : null;
  }

  // Get visits by type
  Future<List<PostnatalVisit>> getVisitsByType(
    String maternalProfileId,
    String visitType,
  ) async {
    final data = await _supabase
        .from('postnatal_visits')
        .select()
        .eq('maternal_profile_id', maternalProfileId)
        .eq('visit_type', visitType)
        .order('visit_date', ascending: false);

    return (data as List).map((e) => PostnatalVisit.fromJson(e)).toList();
  }

  // Get total visits count
  Future<int> getTotalVisitsCount(String maternalProfileId) async {
    // FIX: Replaced FetchOptions inside select() with chained .count(CountOption.exact)
    final response = await _supabase
        .from('postnatal_visits')
        .select('id')
        .eq('maternal_profile_id', maternalProfileId)
        .count(CountOption.exact);

    return response.count;
  }
}