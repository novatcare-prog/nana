import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hive/hive.dart';

part 'appointment.freezed.dart';
part 'appointment.g.dart';

// --- ENUMS WITH HIVE TAGS ---

@HiveType(typeId: 4) // MUST MATCH YOUR OLD ADAPTER ID
enum AppointmentType {
  @JsonValue('anc_visit') @HiveField(0) ancVisit,
  @JsonValue('pnc_visit') @HiveField(1) pncVisit,
  @JsonValue('lab_test') @HiveField(2) labTest,
  @JsonValue('ultrasound') @HiveField(3) ultrasound,
  @JsonValue('delivery') @HiveField(4) delivery,
  @JsonValue('immunization') @HiveField(5) immunization,
  @JsonValue('consultation') @HiveField(6) consultation,
  @JsonValue('follow_up') @HiveField(7) followUp,
}

@HiveType(typeId: 5) // MUST MATCH YOUR OLD ADAPTER ID
enum AppointmentStatus {
  @JsonValue('scheduled') @HiveField(0) scheduled,
  @JsonValue('confirmed') @HiveField(1) confirmed,
  @JsonValue('completed') @HiveField(2) completed,
  @JsonValue('cancelled') @HiveField(3) cancelled,
  @JsonValue('missed') @HiveField(4) missed,
  @JsonValue('rescheduled') @HiveField(5) rescheduled,
}

// --- CLASS WITH HIVE TAGS & CORRECT PARAMETER NAME ---

@freezed
class Appointment with _$Appointment {
  @HiveType(typeId: 3) // MUST MATCH YOUR OLD ADAPTER ID
  const factory Appointment({
    @HiveField(0) String? id,
    @HiveField(1) @JsonKey(name: 'maternal_profile_id') required String maternalProfileId,
    @HiveField(2) @JsonKey(name: 'patient_name') @Default('') String patientName,
    @HiveField(3) @JsonKey(name: 'appointment_date') required DateTime appointmentDate,
    @HiveField(4) @JsonKey(name: 'appointment_type') required AppointmentType appointmentType,
    
    // 1. FIX PARAMETER NAME (status -> appointmentStatus)
    // 2. KEEP HIVE FIELD (So offline DB doesn't break)
    @HiveField(5) @JsonKey(name: 'appointment_status') @Default(AppointmentStatus.scheduled) AppointmentStatus appointmentStatus,
    
    @HiveField(6) String? notes,
    @HiveField(7) @JsonKey(name: 'facility_id') required String facilityId,
    @HiveField(8) @JsonKey(name: 'facility_name') @Default('') String facilityName,
    @HiveField(9) @JsonKey(name: 'created_by') required String createdBy,
    @HiveField(10) @JsonKey(name: 'created_by_name') String? createdByName,
    @HiveField(11) @JsonKey(name: 'reminder_sent') @Default(false) bool reminderSent,
    @HiveField(12) @JsonKey(name: 'created_at') DateTime? createdAt,
    @HiveField(13) @JsonKey(name: 'updated_at') DateTime? updatedAt,
  }) = _Appointment;

  factory Appointment.fromJson(Map<String, dynamic> json) =>
      _$AppointmentFromJson(json);
}