
import 'package:freezed_annotation/freezed_annotation.dart';
import '../maternal/maternal_profile.dart';

part 'shared_patient_data.freezed.dart';
part 'shared_patient_data.g.dart';

@freezed
class SharedPatientData with _$SharedPatientData {
  const factory SharedPatientData({
    required MaternalProfile profile,
    @Default([]) List<Map<String, dynamic>> recentVisits, 
    @Default([]) List<Map<String, dynamic>> vitals,      
    required DateTime accessedAt,
  }) = _SharedPatientData;

  factory SharedPatientData.fromJson(Map<String, dynamic> json) =>
      _$SharedPatientDataFromJson(json);
}
