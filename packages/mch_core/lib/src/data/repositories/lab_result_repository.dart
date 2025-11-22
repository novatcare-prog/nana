import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:mch_core/mch_core.dart';

/// Lab Results Repository using Supabase
class LabResultRepository {
  final SupabaseClient _supabase;

  LabResultRepository(this._supabase);

  /// Create a new lab result
  Future<LabResult> createLabResult(LabResult labResult) async {
    try {
      final json = labResult.toJson();
      json.remove('id'); // Let database generate the ID
      
      final response = await _supabase
          .from('lab_results')
          .insert(json)
          .select()
          .single();

      return LabResult.fromJson(response);
    } catch (e) {
      throw Exception('Failed to create lab result: $e');
    }
  }

  /// Get all lab results for a patient
  Future<List<LabResult>> getLabResultsByPatientId(String patientId) async {
    try {
      final response = await _supabase
          .from('lab_results')
          .select()
          .eq('maternal_profile_id', patientId)
          .order('test_date', ascending: false);

      return (response as List)
          .map((json) => LabResult.fromJson(json))
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch lab results: $e');
    }
  }

  /// Get lab results by test type for a patient
  Future<List<LabResult>> getLabResultsByTestType(
    String patientId,
    LabTestType testType,
  ) async {
    try {
      final response = await _supabase
          .from('lab_results')
          .select()
          .eq('maternal_profile_id', patientId)
          .eq('test_type', testType.name)
          .order('test_date', ascending: false);

      return (response as List)
          .map((json) => LabResult.fromJson(json))
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch lab results by type: $e');
    }
  }

  /// Get abnormal lab results for a patient
  Future<List<LabResult>> getAbnormalLabResults(String patientId) async {
    try {
      final response = await _supabase
          .from('lab_results')
          .select()
          .eq('maternal_profile_id', patientId)
          .eq('is_abnormal', true)
          .order('test_date', ascending: false);

      return (response as List)
          .map((json) => LabResult.fromJson(json))
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch abnormal lab results: $e');
    }
  }

  /// Get lab results for an ANC visit
  Future<List<LabResult>> getLabResultsByVisitId(String visitId) async {
    try {
      final response = await _supabase
          .from('lab_results')
          .select()
          .eq('anc_visit_id', visitId)
          .order('test_date', ascending: false);

      return (response as List)
          .map((json) => LabResult.fromJson(json))
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch lab results for visit: $e');
    }
  }

  /// Get recent lab results (last 30 days)
  Future<List<LabResult>> getRecentLabResults() async {
    try {
      final thirtyDaysAgo = DateTime.now().subtract(const Duration(days: 30));
      
      final response = await _supabase
          .from('lab_results')
          .select()
          .gte('test_date', thirtyDaysAgo.toIso8601String())
          .order('test_date', ascending: false);

      return (response as List)
          .map((json) => LabResult.fromJson(json))
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch recent lab results: $e');
    }
  }

  /// Update a lab result
  Future<LabResult> updateLabResult(LabResult labResult) async {
    try {
      if (labResult.id == null) {
        throw Exception('Lab result ID is required for update');
      }
      
      final response = await _supabase
          .from('lab_results')
          .update(labResult.toJson())
          .eq('id', labResult.id!)
          .select()
          .single();

      return LabResult.fromJson(response);
    } catch (e) {
      throw Exception('Failed to update lab result: $e');
    }
  }

  /// Delete a lab result
  Future<void> deleteLabResult(String id) async {
    try {
      await _supabase.from('lab_results').delete().eq('id', id);
    } catch (e) {
      throw Exception('Failed to delete lab result: $e');
    }
  }

  /// Get lab result statistics
  Future<Map<String, int>> getLabResultStatistics() async {
    try {
      final allResults = await _supabase.from('lab_results').select();
      final results = (allResults as List)
          .map((json) => LabResult.fromJson(json))
          .toList();

      final abnormal = results.where((r) => r.isAbnormal).length;
      final pending = 0; // Add if you implement pending status
      
      // Count by test type
      final hemoglobin = results.where((r) => r.testType == LabTestType.hemoglobin).length;
      final hiv = results.where((r) => r.testType == LabTestType.hivTest).length;

      return {
        'total': results.length,
        'abnormal': abnormal,
        'pending': pending,
        'hemoglobin': hemoglobin,
        'hiv': hiv,
      };
    } catch (e) {
      throw Exception('Failed to fetch lab statistics: $e');
    }
  }

  /// Check if patient has a specific test
  Future<bool> hasTestResult(String patientId, LabTestType testType) async {
    try {
      final response = await _supabase
          .from('lab_results')
          .select('id')
          .eq('maternal_profile_id', patientId)
          .eq('test_type', testType.name)
          .limit(1);

      return (response as List).isNotEmpty;
    } catch (e) {
      return false;
    }
  }

  /// Get latest result for a specific test type
  Future<LabResult?> getLatestTestResult(
    String patientId,
    LabTestType testType,
  ) async {
    try {
      final response = await _supabase
          .from('lab_results')
          .select()
          .eq('maternal_profile_id', patientId)
          .eq('test_type', testType.name)
          .order('test_date', ascending: false)
          .limit(1)
          .maybeSingle();

      if (response == null) return null;
      return LabResult.fromJson(response);
    } catch (e) {
      return null;
    }
  }
}