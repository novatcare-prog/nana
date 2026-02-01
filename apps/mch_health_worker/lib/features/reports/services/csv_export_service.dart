import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:intl/intl.dart';
import 'package:mch_core/mch_core.dart';

import '../domain/report_models.dart';

/// CSV Export Service for generating spreadsheet-compatible exports
class CsvExportService {
  static final _dateFormat = DateFormat('yyyy-MM-dd');
  static final _timestampFormat = DateFormat('yyyy-MM-dd_HHmm');

  /// Export High Risk Patients to CSV
  static Future<String> exportHighRiskPatients({
    required List<HighRiskPatientReport> patients,
    required String facilityName,
  }) async {
    final rows = <List<String>>[];
    
    // Header row
    rows.add([
      'Patient Name',
      'ANC Number',
      'Age',
      'Phone',
      'EDD',
      'Days Until EDD',
      'Risk Factors',
      'Last Visit Date',
      'Overdue for Visit',
      'Priority Score',
      'Village',
      'Sub County',
    ]);

    // Data rows
    for (final p in patients) {
      rows.add([
        p.profile.clientName,
        p.profile.ancNumber,
        p.profile.age.toString(),
        p.profile.telephone ?? '',
        p.profile.edd != null ? _dateFormat.format(p.profile.edd!) : '',
        (p.daysUntilEdd ?? '').toString(),
        p.riskFactors.join('; '),
        p.lastVisitDate != null ? _dateFormat.format(p.lastVisitDate!) : '',
        p.isOverdueForVisit ? 'Yes' : 'No',
        p.priorityScore.toString(),
        p.profile.village ?? '',
        p.profile.subCounty ?? '',
      ]);
    }

    return _saveAndShareCsv(rows, 'high_risk_patients', facilityName);
  }

  /// Export Patients Due Soon to CSV
  static Future<String> exportPatientsDueSoon({
    required List<MaternalProfile> patients,
    required String facilityName,
  }) async {
    final rows = <List<String>>[];
    
    // Header row
    rows.add([
      'Patient Name',
      'ANC Number',
      'Age',
      'Phone',
      'EDD',
      'Days Until EDD',
      'Gravida',
      'Parity',
      'Village',
      'Sub County',
      'County',
      'Next of Kin',
      'Next of Kin Phone',
    ]);

    // Data rows (sorted by EDD)
    final sorted = [...patients]..sort((a, b) {
      if (a.edd == null) return 1;
      if (b.edd == null) return -1;
      return a.edd!.compareTo(b.edd!);
    });

    for (final p in sorted) {
      final daysUntil = p.edd != null 
          ? p.edd!.difference(DateTime.now()).inDays 
          : '';
      
      rows.add([
        p.clientName,
        p.ancNumber,
        p.age.toString(),
        p.telephone ?? '',
        p.edd != null ? _dateFormat.format(p.edd!) : '',
        daysUntil.toString(),
        p.gravida.toString(),
        p.parity.toString(),
        p.village ?? '',
        p.subCounty ?? '',
        p.county ?? '',
        p.nextOfKinName ?? '',
        p.nextOfKinPhone ?? '',
      ]);
    }

    return _saveAndShareCsv(rows, 'patients_due_soon', facilityName);
  }

  /// Export Missed Appointments to CSV
  static Future<String> exportMissedAppointments({
    required List<Appointment> appointments,
    required String facilityName,
  }) async {
    final rows = <List<String>>[];
    
    // Header row
    rows.add([
      'Patient Name',
      'Appointment Date',
      'Appointment Type',
      'Status',
      'Facility',
      'Notes',
      'Days Since Missed',
    ]);

    // Data rows
    for (final a in appointments) {
      final daysSince = DateTime.now().difference(a.appointmentDate).inDays;
      
      rows.add([
        a.patientName,
        _dateFormat.format(a.appointmentDate),
        _formatAppointmentType(a.appointmentType),
        a.appointmentStatus.name,
        a.facilityName,
        a.notes ?? '',
        daysSince.toString(),
      ]);
    }

    return _saveAndShareCsv(rows, 'missed_appointments', facilityName);
  }

  /// Export ANC Coverage Statistics to CSV
  static Future<String> exportAncCoverageStats({
    required AncCoverageStats stats,
    required String facilityName,
  }) async {
    final rows = <List<String>>[];
    
    // Header row
    rows.add([
      'Visit Number',
      'Patient Count',
      'Total Active Patients',
      'Coverage Percentage',
      'Meets MOH Target (80%)',
    ]);

    // Data rows
    final visits = [
      ['1st ANC Visit', stats.firstVisitCount],
      ['2nd ANC Visit', stats.secondVisitCount],
      ['3rd ANC Visit', stats.thirdVisitCount],
      ['4th+ ANC Visit', stats.fourthPlusVisitCount],
    ];

    for (final v in visits) {
      final count = v[1] as int;
      final percent = stats.totalActivePatients > 0 
          ? (count / stats.totalActivePatients * 100) 
          : 0.0;
      
      rows.add([
        v[0] as String,
        count.toString(),
        stats.totalActivePatients.toString(),
        '${percent.toStringAsFixed(1)}%',
        percent >= 80 ? 'Yes' : 'No',
      ]);
    }

    return _saveAndShareCsv(rows, 'anc_coverage', facilityName);
  }

  /// Generate CSV content from rows
  static String _generateCsvContent(List<List<String>> rows) {
    return rows.map((row) => row.map(_escapeCsvField).join(',')).join('\n');
  }

  /// Escape special characters in CSV fields
  static String _escapeCsvField(String field) {
    if (field.contains(',') || field.contains('"') || field.contains('\n')) {
      return '"${field.replaceAll('"', '""')}"';
    }
    return field;
  }

  /// Save CSV to file and share it
  static Future<String> _saveAndShareCsv(
    List<List<String>> rows, 
    String reportType, 
    String facilityName,
  ) async {
    final csvContent = _generateCsvContent(rows);
    final timestamp = _timestampFormat.format(DateTime.now());
    final filename = '${reportType}_${timestamp}.csv';
    
    // Get temporary directory
    final directory = await getTemporaryDirectory();
    final file = File('${directory.path}/$filename');
    
    // Write CSV content
    await file.writeAsString(csvContent, encoding: utf8);
    
    return file.path;
  }

  /// Share the CSV file
  static Future<void> shareFile(String filePath) async {
    await Share.shareXFiles([XFile(filePath)]);
  }

  /// Get CSV content as string (for preview or clipboard)
  static String generateCsvString(List<List<String>> rows) {
    return _generateCsvContent(rows);
  }

  static String _formatAppointmentType(AppointmentType type) {
    switch (type) {
      case AppointmentType.ancVisit: return 'ANC Visit';
      case AppointmentType.pncVisit: return 'PNC Visit';
      case AppointmentType.labTest: return 'Lab Test';
      case AppointmentType.ultrasound: return 'Ultrasound';
      case AppointmentType.delivery: return 'Delivery';
      case AppointmentType.immunization: return 'Immunization';
      case AppointmentType.consultation: return 'Consultation';
      case AppointmentType.followUp: return 'Follow-up';
    }
  }
}
