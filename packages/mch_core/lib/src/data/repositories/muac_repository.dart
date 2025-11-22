import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:mch_core/mch_core.dart';



/// MUAC Measurements Repository
class MuacRepository {
  final SupabaseClient _supabase;

  MuacRepository(this._supabase);

  /// Create a new MUAC measurement
  Future<MuacMeasurement> createMeasurement(MuacMeasurement measurement) async {
    try {
      final json = measurement.toJson();
      json.remove('id');

      final response = await _supabase
          .from('muac_measurements')
          .insert(json)
          .select()
          .single();

      return MuacMeasurement.fromJson(response);
    } catch (e) {
      throw Exception('Failed to create MUAC measurement: $e');
    }
  }

  /// Get all MUAC measurements for a patient
  Future<List<MuacMeasurement>> getMeasurementsByPatientId(
      String patientId) async {
    try {
      final response = await _supabase
          .from('muac_measurements')
          .select()
          .eq('maternal_profile_id', patientId)
          .order('measurement_date', ascending: true);

      return (response as List)
          .map((json) => MuacMeasurement.fromJson(json))
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch MUAC measurements: $e');
    }
  }

  /// Get latest MUAC measurement for a patient
  Future<MuacMeasurement?> getLatestMeasurement(String patientId) async {
    try {
      final response = await _supabase
          .from('muac_measurements')
          .select()
          .eq('maternal_profile_id', patientId)
          .order('measurement_date', ascending: false)
          .limit(1)
          .maybeSingle();

      if (response == null) return null;
      return MuacMeasurement.fromJson(response);
    } catch (e) {
      return null;
    }
  }

  /// Check if patient is malnourished (latest MUAC < 23cm)
  Future<bool> isPatientMalnourished(String patientId) async {
    try {
      final latest = await getLatestMeasurement(patientId);
      return latest?.isMalnourished ?? false;
    } catch (e) {
      return false;
    }
  }

  /// Update MUAC measurement
  Future<MuacMeasurement> updateMeasurement(MuacMeasurement measurement) async {
    try {
      if (measurement.id == null) {
        throw Exception('Measurement ID is required for update');
      }

      final response = await _supabase
          .from('muac_measurements')
          .update(measurement.toJson())
          .eq('id', measurement.id!)
          .select()
          .single();

      return MuacMeasurement.fromJson(response);
    } catch (e) {
      throw Exception('Failed to update MUAC measurement: $e');
    }
  }

  /// Delete MUAC measurement
  Future<void> deleteMeasurement(String id) async {
    try {
      await _supabase.from('muac_measurements').delete().eq('id', id);
    } catch (e) {
      throw Exception('Failed to delete MUAC measurement: $e');
    }
  }
}


































