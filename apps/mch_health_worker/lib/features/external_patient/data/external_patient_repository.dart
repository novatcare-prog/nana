import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:mch_core/mch_core.dart';

final externalPatientRepositoryProvider = Provider((ref) {
  return ExternalPatientRepository(Supabase.instance.client);
});

class ExternalPatientRepository {
  final SupabaseClient _supabase;

  ExternalPatientRepository(this._supabase);

  Future<SharedPatientData> fetchSharedPatientData(String code) async {
    final response = await _supabase.rpc('get_shared_patient_data', params: {
      'input_code': code,
    });

    return SharedPatientData.fromJson(response);
  }
}
