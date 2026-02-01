import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:mch_core/mch_core.dart';
import '../services/auth_service.dart';

// ============================================
// AUTH SERVICE PROVIDER
// ============================================

final authServiceProvider = Provider<AuthService>((ref) {
  final supabase = Supabase.instance.client;
  return AuthService(supabase);
});

// ============================================
// AUTH STATE PROVIDER
// ============================================

/// Current auth state (logged in user)
final authStateProvider = StreamProvider<User?>((ref) {
  final authService = ref.watch(authServiceProvider);
  return authService.authStateChanges.map((state) => state.session?.user);
});

/// Check if user is authenticated
final isAuthenticatedProvider = Provider<bool>((ref) {
  final authState = ref.watch(authStateProvider);
  return authState.maybeWhen(
    data: (user) => user != null,
    orElse: () => false,
  );
});

// ============================================
// USER PROFILE PROVIDER
// ============================================

/// Current user's profile from database
final currentUserProfileProvider = FutureProvider<UserProfile?>((ref) async {
  final authService = ref.watch(authServiceProvider);
  final user = authService.currentUser;

  if (user == null) return null;

  try {
    final profileData = await authService
        .getUserProfile(user.id)
        .timeout(const Duration(seconds: 10));
    if (profileData == null) return null;

    return UserProfile.fromJson(profileData);
  } catch (e) {
    print('Error loading user profile: $e');
    return null;
  }
});

/// User's role
final userRoleProvider = Provider<UserRole?>((ref) {
  final profileAsync = ref.watch(currentUserProfileProvider);
  return profileAsync.maybeWhen(
    data: (profile) =>
        profile != null ? UserRole.fromString(profile.role) : null,
    orElse: () => null,
  );
});

/// Check if user is health worker
final isHealthWorkerProvider = Provider<bool>((ref) {
  final role = ref.watch(userRoleProvider);
  return role == UserRole.healthWorker || role == UserRole.admin;
});

/// Check if user is patient
final isPatientProvider = Provider<bool>((ref) {
  final role = ref.watch(userRoleProvider);
  return role == UserRole.patient;
});

/// Check if user is admin
final isAdminProvider = Provider<bool>((ref) {
  final role = ref.watch(userRoleProvider);
  return role == UserRole.admin;
});

/// User's facility ID (for health workers)
final userFacilityIdProvider = Provider<String?>((ref) {
  final profileAsync = ref.watch(currentUserProfileProvider);
  return profileAsync.maybeWhen(
    data: (profile) => profile?.facilityId,
    orElse: () => null,
  );
});

// ============================================
// AUTH ACTIONS PROVIDER
// ============================================

/// Provider for auth actions (login, logout, register)
final authActionsProvider = Provider<AuthActions>((ref) {
  final authService = ref.watch(authServiceProvider);
  return AuthActions(authService, ref);
});

/// Auth actions class
class AuthActions {
  final AuthService _authService;
  final Ref _ref;

  AuthActions(this._authService, this._ref);

  /// Sign in
  Future<void> signIn({
    required String email,
    required String password,
  }) async {
    final response = await _authService.signIn(
      email: email,
      password: password,
    );

    if (response.user == null) {
      throw Exception('Login failed');
    }

    // Refresh providers
    _ref.invalidate(authStateProvider);
    _ref.invalidate(currentUserProfileProvider);
  }

  /// Sign up
  Future<void> signUp({
    required String email,
    required String password,
    required String fullName,
    required String role,
    String? facilityId,
  }) async {
    final response = await _authService.signUp(
      email: email,
      password: password,
      fullName: fullName,
      role: role,
      facilityId: facilityId,
    );

    if (response.user == null) {
      throw Exception('Registration failed');
    }

    // Refresh providers
    _ref.invalidate(authStateProvider);
    _ref.invalidate(currentUserProfileProvider);
  }

  /// Sign out
  Future<void> signOut() async {
    try {
      await _authService.signOut();
    } catch (e) {
      print('Logout error: $e');
    } finally {
      // Always clear local state
      _ref.invalidate(authStateProvider);
      _ref.invalidate(currentUserProfileProvider);
    }
  }

  /// Reset password
  Future<void> resetPassword(String email) async {
    await _authService.resetPassword(email);
  }
}
