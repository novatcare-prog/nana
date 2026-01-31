import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
// Import from shared mch_core package

// Supabase client provider
final supabaseClientProvider = Provider<SupabaseClient>((ref) {
  return Supabase.instance.client;
});

// Auth state provider
final authStateProvider = StreamProvider<AuthState>((ref) {
  final supabase = ref.watch(supabaseClientProvider);
  return supabase.auth.onAuthStateChange;
});

// Current user provider
final currentUserProvider = Provider<User?>((ref) {
  final authState = ref.watch(authStateProvider);
  return authState.when(
    data: (state) => state.session?.user,
    loading: () => null,
    error: (_, __) => null,
  );
});

// Check if user is a patient (not a health worker)
final isPatientProvider = Provider<bool>((ref) {
  final user = ref.watch(currentUserProvider);
  if (user == null) return false;

  final role = user.userMetadata?['role'] as String?;
  return role == 'patient';
});

// Auth controller provider
final authControllerProvider = Provider<AuthController>((ref) {
  return AuthController(ref);
});

class AuthController {
  final Ref ref;

  AuthController(this.ref);

  SupabaseClient get _supabase => ref.read(supabaseClientProvider);

  // Sign in with email and password
  Future<AuthResponse> signIn({
    required String email,
    required String password,
  }) async {
    final response = await _supabase.auth.signInWithPassword(
      email: email,
      password: password,
    );

    // Verify user is a patient
    final role = response.user?.userMetadata?['role'] as String?;
    if (role != 'patient') {
      await _supabase.auth.signOut();
      throw Exception(
          'This app is for patients only. Please use the Health Worker app.');
    }

    return response;
  }

  // Sign in with phone number and password
  Future<AuthResponse> signInWithPhone({
    required String phone,
    required String password,
  }) async {
    // For phone login, we use email as phone@mchkenya.app
    // This allows us to use password auth while supporting phone numbers
    final emailFromPhone = '${phone.replaceAll('+', '')}@mchkenya.app';

    final response = await _supabase.auth.signInWithPassword(
      email: emailFromPhone,
      password: password,
    );

    // Verify user is a patient
    final role = response.user?.userMetadata?['role'] as String?;
    if (role != 'patient') {
      await _supabase.auth.signOut();
      throw Exception(
          'This app is for patients only. Please use the Health Worker app.');
    }

    return response;
  }

  // Sign up with email and password (patients only)
  Future<AuthResponse> signUp({
    required String email,
    required String password,
    required String fullName,
    required String phone,
    required String idNumber,
  }) async {
    return await _supabase.auth.signUp(
      email: email,
      password: password,
      data: {
        'full_name': fullName,
        'phone': phone,
        'id_number': idNumber,
        'role': 'patient', // Force patient role in patient app
      },
    );
  }

  // Sign out
  Future<void> signOut() async {
    await _supabase.auth.signOut();
  }

  // Send password reset email with OTP code
  Future<void> sendPasswordResetOtp({required String email}) async {
    // Supabase doesn't have built-in OTP for password reset
    // We'll use the magic link approach, but users can copy the token from the URL
    await _supabase.auth.resetPasswordForEmail(email);
  }

  // Verify OTP and reset password
  Future<void> verifyOtpAndResetPassword({
    required String email,
    required String token,
    required String newPassword,
  }) async {
    try {
      // First, verify the OTP token
      print(
          '🔐 Attempting OTP verification for: $email with token: ${token.substring(0, 2)}...');

      final response = await _supabase.auth.verifyOTP(
        email: email,
        token: token,
        type: OtpType.recovery,
      );

      print(
          '🔐 OTP verification response - user: ${response.user?.id}, session: ${response.session != null}');

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
      print('🔐 Password reset error: $e');

      // Re-throw with more specific messages
      final errorStr = e.toString().toLowerCase();
      if (errorStr.contains('otp_expired') ||
          (errorStr.contains('otp') && errorStr.contains('expired'))) {
        throw Exception('Code has expired. Please request a new one.');
      } else if (errorStr.contains('invalid') || errorStr.contains('otp')) {
        throw Exception('Invalid code. Please check and try again.');
      } else if (errorStr.contains('same_password')) {
        throw Exception(
            'New password must be different from your current password.');
      } else if (errorStr.contains('weak')) {
        throw Exception(
            'Password is too weak. Please use a stronger password.');
      }
      rethrow;
    }
  }

  // Update password (for logged-in users)
  Future<UserResponse> updatePassword({required String newPassword}) async {
    return await _supabase.auth.updateUser(
      UserAttributes(password: newPassword),
    );
  }

  // Check if user is authenticated
  bool get isAuthenticated {
    return _supabase.auth.currentUser != null;
  }

  // Get current user
  User? get currentUser {
    return _supabase.auth.currentUser;
  }

  // Get user ID
  String? get userId {
    return _supabase.auth.currentUser?.id;
  }

  // Get user email
  String? get userEmail {
    return _supabase.auth.currentUser?.email;
  }

  // Get user metadata
  Map<String, dynamic>? get userMetadata {
    return _supabase.auth.currentUser?.userMetadata;
  }

  // Get user full name
  String? get userFullName {
    return _supabase.auth.currentUser?.userMetadata?['full_name'] as String?;
  }

  // Get user phone
  String? get userPhone {
    return _supabase.auth.currentUser?.userMetadata?['phone'] as String?;
  }

  // Get user ID number (National ID)
  String? get userIdNumber {
    return _supabase.auth.currentUser?.userMetadata?['id_number'] as String?;
  }
}
