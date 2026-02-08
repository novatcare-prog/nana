import 'package:supabase_flutter/supabase_flutter.dart';

/// Authentication Service
/// Handles all Supabase authentication operations
class AuthService {
  final SupabaseClient _supabase;

  AuthService(this._supabase);

  /// Get current user
  User? get currentUser => _supabase.auth.currentUser;

  /// Get current session
  Session? get currentSession => _supabase.auth.currentSession;

  /// Check if user is logged in
  bool get isLoggedIn => currentUser != null;

  /// Auth state changes stream
  Stream<AuthState> get authStateChanges => _supabase.auth.onAuthStateChange;

  /// Sign in with email and password
  Future<AuthResponse> signIn({
    required String email,
    required String password,
  }) async {
    try {
      print('🔐 Attempting login for: $email');
      final response = await _supabase.auth.signInWithPassword(
        email: email,
        password: password,
      );
      print('🔐 Login successful for: ${response.user?.email}');
      return response;
    } catch (e) {
      print('🔐 LOGIN ERROR: $e');
      rethrow;
    }
  }


  /// Sign up with email and password
  Future<AuthResponse> signUp({
    required String email,
    required String password,
    required String fullName,
    required String role,
    String? facilityId,
  }) async {
    try {
      final response = await _supabase.auth.signUp(
        email: email,
        password: password,
        data: {
          'full_name': fullName,
          'role': role,
          if (facilityId != null) 'facility_id': facilityId,
        },
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  /// Sign out
  Future<void> signOut() async {
    try {
      await _supabase.auth.signOut();
    } catch (e) {
      rethrow;
    }
  }

  /// Reset password
  Future<void> resetPassword(String email) async {
    try {
      await _supabase.auth.resetPasswordForEmail(email);
    } catch (e) {
      rethrow;
    }
  }

  /// Update password
  Future<UserResponse> updatePassword(String newPassword) async {
    try {
      final response = await _supabase.auth.updateUser(
        UserAttributes(password: newPassword),
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  /// Verify OTP and reset password
  /// This is used for the forgot password flow with 6-digit code
  Future<void> verifyOtpAndResetPassword({
    required String email,
    required String token,
    required String newPassword,
  }) async {
    try {
      print('🔐 Attempting OTP verification for: $email');
      
      // First, verify the OTP token to establish a session
      final response = await _supabase.auth.verifyOTP(
        email: email,
        token: token,
        type: OtpType.recovery,
      );
      
      print('🔐 OTP verification response - user: ${response.user?.id}, session: ${response.session != null}');
      
      if (response.user == null) {
        throw Exception('Invalid or expired code. Please request a new one.');
      }
      
      // Then update the password
      print('🔐 Updating password...');
      await _supabase.auth.updateUser(
        UserAttributes(password: newPassword),
      );
      print('🔐 Password updated successfully!');
      
    } catch (e) {
      print('🔐 ==========================================');
      print('🔐 PASSWORD RESET ERROR:');
      print('🔐 Error type: ${e.runtimeType}');
      print('🔐 Full error: $e');
      print('🔐 ==========================================');
      
      // Show the ACTUAL error message instead of generic ones
      final errorMessage = e.toString();
      throw Exception('Reset failed: $errorMessage');
    }
  }

  /// Get user profile from database
  Future<Map<String, dynamic>?> getUserProfile(String userId) async {
    try {
      final response = await _supabase
          .from('user_profiles')
          .select()
          .eq('id', userId)
          .maybeSingle();
      return response;
    } catch (e) {
      rethrow;
    }
  }

  /// Update user profile
  Future<void> updateUserProfile({
    required String userId,
    String? fullName,
    String? phone,
    String? facilityId,
  }) async {
    try {
      final updates = <String, dynamic>{
        'updated_at': DateTime.now().toIso8601String(),
      };

      if (fullName != null) updates['full_name'] = fullName;
      if (phone != null) updates['phone'] = phone;
      if (facilityId != null) updates['facility_id'] = facilityId;

      await _supabase.from('user_profiles').update(updates).eq('id', userId);
    } catch (e) {
      rethrow;
    }
  }
}