import 'package:freezed_annotation/freezed_annotation.dart';

part 'appointment.freezed.dart';
part 'appointment.g.dart';

/// Appointment Types
enum AppointmentType {
  @JsonValue('anc_visit')
  ancVisit,
  
  @JsonValue('pnc_visit')
  pncVisit,
  
  @JsonValue('lab_test')
  labTest,
  
  @JsonValue('ultrasound')
  ultrasound,
  
  @JsonValue('delivery')
  delivery,
  
  @JsonValue('immunization')
  immunization,
  
  @JsonValue('consultation')
  consultation,
  
  @JsonValue('follow_up')
  followUp,
}

/// Appointment Status
enum AppointmentStatus {
  @JsonValue('scheduled')
  scheduled,
  
  @JsonValue('confirmed')
  confirmed,
  
  @JsonValue('completed')
  completed,
  
  @JsonValue('cancelled')
  cancelled,
  
  @JsonValue('missed')
  missed,
  
  @JsonValue('rescheduled')
  rescheduled,
}

@freezed
class Appointment with _$Appointment {
  const factory Appointment({
     String? id,
    @JsonKey(name: 'maternal_profile_id') required String maternalProfileId,
    @JsonKey(name: 'patient_name') @Default('') String patientName,
    @JsonKey(name: 'appointment_date') required DateTime appointmentDate,
    @JsonKey(name: 'appointment_type') required AppointmentType appointmentType,
    @JsonKey(name: 'appointment_status') @Default(AppointmentStatus.scheduled) AppointmentStatus appointmentStatus,
    String? notes,
    @JsonKey(name: 'facility_id') required String facilityId,
    @JsonKey(name: 'facility_name') @Default('') String facilityName,
    @JsonKey(name: 'created_by') required String createdBy,
    @JsonKey(name: 'created_by_name') String? createdByName,
    @JsonKey(name: 'reminder_sent') @Default(false) bool reminderSent,
    @JsonKey(name: 'created_at') DateTime? createdAt,
    @JsonKey(name: 'updated_at') DateTime? updatedAt,
  }) = _Appointment;

  factory Appointment.fromJson(Map<String, dynamic> json) =>
      _$AppointmentFromJson(json);
}