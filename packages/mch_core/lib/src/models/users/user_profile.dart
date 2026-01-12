import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_profile.freezed.dart';
part 'user_profile.g.dart';

/// User Profile Model
/// Extends Supabase auth.users with additional profile information
@freezed
class UserProfile with _$UserProfile {
  const factory UserProfile({
    required String id,
    required String email,
    @JsonKey(name: 'full_name') required String fullName,
    @JsonKey(name: 'phone') String? phone,
    @JsonKey(name: 'id_number') String? idNumber,
    required String role,
    @JsonKey(name: 'facility_id') String? facilityId,
    @JsonKey(name: 'maternal_profile_id') String? maternalProfileId,
    @JsonKey(name: 'is_active') @Default(true) bool isActive,
    @JsonKey(name: 'created_at') DateTime? createdAt,
    @JsonKey(name: 'updated_at') DateTime? updatedAt,
  }) = _UserProfile;

  factory UserProfile.fromJson(Map<String, dynamic> json) =>
      _$UserProfileFromJson(json);
}

/// Role enum for type safety
enum UserRole {
  healthWorker('health_worker'),
  patient('patient'),
  admin('admin');

  const UserRole(this.value);
  final String value;

  static UserRole fromString(String value) {
    return UserRole.values.firstWhere(
      (role) => role.value == value,
      orElse: () => UserRole.healthWorker,
    );
  }
}