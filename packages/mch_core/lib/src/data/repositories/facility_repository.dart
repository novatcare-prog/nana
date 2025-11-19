import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:mch_core/mch_core.dart';

/// Repository for facility operations using Supabase
class FacilityRepository {
  final SupabaseClient _supabase;

  FacilityRepository(this._supabase);

  /// Get all facilities
  Future<List<Facility>> getAllFacilities() async {
    try {
      final response = await _supabase
          .from('facilities')
          .select()
          // ✅ FIX: Changed 'name' to 'facility_name'
          .order('facility_name', ascending: true);

      return (response as List)
          .map((json) => Facility.fromJson(json))
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch facilities: $e');
    }
  }

  /// Get facility by ID
  Future<Facility?> getFacilityById(String id) async {
    try {
      final response = await _supabase
          .from('facilities')
          .select()
          .eq('id', id)
          .single();

      return Facility.fromJson(response);
    } catch (e) {
      return null;
    }
  }

  /// Get facility by KMHFL code
  Future<Facility?> getFacilityByKmhflCode(String kmhflCode) async {
    try {
      final response = await _supabase
          .from('facilities')
          .select()
          .eq('kmhfl_code', kmhflCode)
          .single();

      return Facility.fromJson(response);
    } catch (e) {
      return null;
    }
  }

  /// Search facilities by name
  Future<List<Facility>> searchFacilities(String query) async {
    try {
      final response = await _supabase
          .from('facilities')
          .select()
          // ✅ FIX: Changed 'name' to 'facility_name'
          .ilike('facility_name', '%$query%')
          // ✅ FIX: Changed 'name' to 'facility_name'
          .order('facility_name', ascending: true);

      return (response as List)
          .map((json) => Facility.fromJson(json))
          .toList();
    } catch (e) {
      throw Exception('Failed to search facilities: $e');
    }
  }

  /// Get facilities by county
  Future<List<Facility>> getFacilitiesByCounty(String county) async {
    try {
      final response = await _supabase
          .from('facilities')
          .select()
          .eq('county', county)
          // ✅ FIX: Changed 'name' to 'facility_name'
          .order('facility_name', ascending: true);

      return (response as List)
          .map((json) => Facility.fromJson(json))
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch facilities by county: $e');
    }
  }

  /// Create a new facility
  Future<Facility> createFacility(Facility facility) async {
    try {
      final response = await _supabase
          .from('facilities')
          .insert(facility.toJson())
          .select()
          .single();

      return Facility.fromJson(response);
    } catch (e) {
      throw Exception('Failed to create facility: $e');
    }
  }

  /// Update facility
  Future<Facility> updateFacility(Facility facility) async {
    try {
      final response = await _supabase
          .from('facilities')
          .update(facility.toJson())
          .eq('id', facility.id)
          .select()
          .single();

      return Facility.fromJson(response);
    } catch (e) {
      throw Exception('Failed to update facility: $e');
    }
  }

  /// Delete facility
  Future<void> deleteFacility(String id) async {
    try {
      await _supabase.from('facilities').delete().eq('id', id);
    } catch (e) {
      throw Exception('Failed to delete facility: $e');
    }
  }
}