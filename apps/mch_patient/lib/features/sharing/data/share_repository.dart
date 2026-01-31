import 'dart:math';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final shareRecordsRepositoryProvider = Provider((ref) {
  return ShareRecordsRepository(Supabase.instance.client);
});

class ShareRecordsRepository {
  final SupabaseClient _supabase;

  ShareRecordsRepository(this._supabase);

  Future<SharedCode> generateAccessCode() async {
    final user = _supabase.auth.currentUser;
    if (user == null) throw Exception('User not logged in');

    // Generate 6-digit code
    final rng = Random();
    final code = (100000 + rng.nextInt(900000)).toString();

    // Expires in 15 minutes
    final expiresAt = DateTime.now().add(const Duration(minutes: 15));

    await _supabase.from('patient_access_codes').insert({
      'patient_id': user.id,
      'code': code,
      'expires_at': expiresAt.toIso8601String(),
    });

    return SharedCode(code: code, expiresAt: expiresAt);
  }
}

class SharedCode {
  final String code;
  final DateTime expiresAt;

  SharedCode({required this.code, required this.expiresAt});
}
