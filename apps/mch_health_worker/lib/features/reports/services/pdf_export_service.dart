import 'dart:typed_data';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:intl/intl.dart';
import 'package:mch_core/mch_core.dart';

import '../domain/report_models.dart';

/// PDF Export Service for generating printable reports
class PdfExportService {
  static final _dateFormat = DateFormat('MMM dd, yyyy');
  static final _timestampFormat = DateFormat('yyyy-MM-dd HH:mm');

  /// Generate High Risk Patients Report PDF
  static Future<Uint8List> generateHighRiskReport({
    required List<HighRiskPatientReport> patients,
    required String facilityName,
  }) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(32),
        header: (context) =>
            _buildHeader('High Risk Patients Report', facilityName),
        footer: (context) => _buildFooter(context),
        build: (context) => [
          _buildSummaryBox([
            'Total High Risk Patients: ${patients.length}',
            'Overdue for Visit: ${patients.where((p) => p.isOverdueForVisit).length}',
            'Due in 2 Weeks: ${patients.where((p) => (p.daysUntilEdd ?? 999) <= 14).length}',
          ]),
          pw.SizedBox(height: 20),
          pw.Table.fromTextArray(
            context: context,
            headerStyle:
                pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 10),
            cellStyle: const pw.TextStyle(fontSize: 9),
            headerDecoration: const pw.BoxDecoration(color: PdfColors.grey300),
            headers: [
              'Name',
              'ANC #',
              'Age',
              'EDD',
              'Risk Factors',
              'Last Visit'
            ],
            data: patients
                .map((p) => [
                      p.profile.clientName,
                      p.profile.ancNumber,
                      '${p.profile.age}',
                      p.profile.edd != null
                          ? _dateFormat.format(p.profile.edd!)
                          : '-',
                      p.riskFactors.join(', '),
                      p.lastVisitDate != null
                          ? _dateFormat.format(p.lastVisitDate!)
                          : 'Never',
                    ])
                .toList(),
          ),
        ],
      ),
    );

    return pdf.save();
  }

  /// Generate Patients Due Soon Report PDF
  static Future<Uint8List> generateDueSoonReport({
    required List<MaternalProfile> patients,
    required String facilityName,
  }) async {
    final pdf = pw.Document();

    // Sort by EDD
    final sorted = [...patients]..sort((a, b) {
        if (a.edd == null) return 1;
        if (b.edd == null) return -1;
        return a.edd!.compareTo(b.edd!);
      });

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(32),
        header: (context) =>
            _buildHeader('Patients Due Soon Report', facilityName),
        footer: (context) => _buildFooter(context),
        build: (context) => [
          _buildSummaryBox([
            'Total Patients Due (30 days): ${patients.length}',
            'Due in 7 days: ${patients.where((p) => _daysUntilEdd(p) <= 7).length}',
            'Due in 14 days: ${patients.where((p) => _daysUntilEdd(p) <= 14).length}',
          ]),
          pw.SizedBox(height: 20),
          pw.Table.fromTextArray(
            context: context,
            headerStyle:
                pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 10),
            cellStyle: const pw.TextStyle(fontSize: 9),
            headerDecoration: const pw.BoxDecoration(color: PdfColors.grey300),
            headers: ['Name', 'ANC #', 'Phone', 'EDD', 'Days Left', 'Address'],
            data: sorted
                .map((p) => [
                      p.clientName,
                      p.ancNumber,
                      p.telephone ?? '-',
                      p.edd != null ? _dateFormat.format(p.edd!) : '-',
                      '${_daysUntilEdd(p)}',
                      [p.village, p.ward, p.subCounty]
                          .where((s) => s != null)
                          .join(', '),
                    ])
                .toList(),
          ),
        ],
      ),
    );

    return pdf.save();
  }

  /// Generate Missed Appointments Report PDF
  static Future<Uint8List> generateMissedAppointmentsReport({
    required List<Appointment> appointments,
    required String facilityName,
  }) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(32),
        header: (context) =>
            _buildHeader('Missed Appointments Report', facilityName),
        footer: (context) => _buildFooter(context),
        build: (context) => [
          _buildSummaryBox([
            'Total Missed Appointments: ${appointments.length}',
          ]),
          pw.SizedBox(height: 20),
          pw.Table.fromTextArray(
            context: context,
            headerStyle:
                pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 10),
            cellStyle: const pw.TextStyle(fontSize: 9),
            headerDecoration: const pw.BoxDecoration(color: PdfColors.grey300),
            headers: ['Patient Name', 'Appointment Date', 'Type', 'Notes'],
            data: appointments
                .map((a) => [
                      a.patientName,
                      _dateFormat.format(a.appointmentDate),
                      _formatAppointmentType(a.appointmentType),
                      a.notes ?? '-',
                    ])
                .toList(),
          ),
        ],
      ),
    );

    return pdf.save();
  }

  /// Generate ANC Coverage Report PDF
  static Future<Uint8List> generateAncCoverageReport({
    required AncCoverageStats stats,
    required String facilityName,
  }) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(32),
        build: (context) => pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            _buildHeader('ANC Coverage Report', facilityName),
            pw.SizedBox(height: 30),
            _buildSummaryBox([
              'Total Active Patients: ${stats.totalActivePatients}',
              'MOH Target: 80% coverage per visit',
            ]),
            pw.SizedBox(height: 30),
            pw.Text('Coverage by Visit Number',
                style:
                    pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold)),
            pw.SizedBox(height: 12),
            _buildCoverageBar('1st ANC Visit', stats.firstVisitCount,
                stats.totalActivePatients, PdfColors.green),
            pw.SizedBox(height: 8),
            _buildCoverageBar('2nd ANC Visit', stats.secondVisitCount,
                stats.totalActivePatients, PdfColors.blue),
            pw.SizedBox(height: 8),
            _buildCoverageBar('3rd ANC Visit', stats.thirdVisitCount,
                stats.totalActivePatients, PdfColors.orange),
            pw.SizedBox(height: 8),
            _buildCoverageBar('4th+ ANC Visit', stats.fourthPlusVisitCount,
                stats.totalActivePatients, PdfColors.purple),
            pw.Spacer(),
            _buildFooter(context),
          ],
        ),
      ),
    );

    return pdf.save();
  }

  /// Print or share a PDF
  static Future<void> printPdf(Uint8List pdfBytes, String documentName) async {
    await Printing.layoutPdf(
      onLayout: (format) async => pdfBytes,
      name: documentName,
    );
  }

  /// Share a PDF
  static Future<void> sharePdf(Uint8List pdfBytes, String documentName) async {
    await Printing.sharePdf(
      bytes: pdfBytes,
      filename: '$documentName.pdf',
    );
  }

  // Helper methods
  static pw.Widget _buildHeader(String title, String facilityName) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
          children: [
            pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text(title,
                    style: pw.TextStyle(
                        fontSize: 18, fontWeight: pw.FontWeight.bold)),
                pw.SizedBox(height: 4),
                pw.Text(facilityName, style: const pw.TextStyle(fontSize: 12)),
              ],
            ),
            pw.Text('Generated: ${_timestampFormat.format(DateTime.now())}',
                style:
                    const pw.TextStyle(fontSize: 10, color: PdfColors.grey700)),
          ],
        ),
        pw.Divider(thickness: 1),
      ],
    );
  }

  static pw.Widget _buildFooter(pw.Context context) {
    return pw.Column(
      children: [
        pw.Divider(thickness: 0.5),
        pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
          children: [
            pw.Text('MCH Kenya Health System',
                style:
                    const pw.TextStyle(fontSize: 8, color: PdfColors.grey600)),
            pw.Text('Page ${context.pageNumber} of ${context.pagesCount}',
                style:
                    const pw.TextStyle(fontSize: 8, color: PdfColors.grey600)),
          ],
        ),
      ],
    );
  }

  static pw.Widget _buildSummaryBox(List<String> items) {
    return pw.Container(
      padding: const pw.EdgeInsets.all(12),
      decoration: pw.BoxDecoration(
        color: PdfColors.blue50,
        borderRadius: const pw.BorderRadius.all(pw.Radius.circular(4)),
        border: pw.Border.all(color: PdfColors.blue200),
      ),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: items
            .map((item) => pw.Padding(
                  padding: const pw.EdgeInsets.symmetric(vertical: 2),
                  child: pw.Text(item, style: const pw.TextStyle(fontSize: 11)),
                ))
            .toList(),
      ),
    );
  }

  static pw.Widget _buildCoverageBar(
      String label, int count, int total, PdfColor color) {
    final percent = total > 0 ? (count / total * 100) : 0.0;

    return pw.Row(
      children: [
        pw.SizedBox(
          width: 100,
          child: pw.Text(label, style: const pw.TextStyle(fontSize: 10)),
        ),
        pw.Expanded(
          child: pw.Stack(
            children: [
              pw.Container(
                height: 16,
                decoration: const pw.BoxDecoration(
                  color: PdfColors.grey200,
                  borderRadius: pw.BorderRadius.all(pw.Radius.circular(4)),
                ),
              ),
              pw.Container(
                height: 16,
                width: (percent / 100) * 300,
                decoration: pw.BoxDecoration(
                  color: color,
                  borderRadius:
                      const pw.BorderRadius.all(pw.Radius.circular(4)),
                ),
              ),
            ],
          ),
        ),
        pw.SizedBox(width: 8),
        pw.Text('${percent.toStringAsFixed(1)}% ($count/$total)',
            style: const pw.TextStyle(fontSize: 9)),
      ],
    );
  }

  static int _daysUntilEdd(MaternalProfile p) {
    if (p.edd == null) return 999;
    return p.edd!.difference(DateTime.now()).inDays;
  }

  static String _formatAppointmentType(AppointmentType type) {
    switch (type) {
      case AppointmentType.ancVisit:
        return 'ANC Visit';
      case AppointmentType.pncVisit:
        return 'PNC Visit';
      case AppointmentType.labTest:
        return 'Lab Test';
      case AppointmentType.ultrasound:
        return 'Ultrasound';
      case AppointmentType.delivery:
        return 'Delivery';
      case AppointmentType.immunization:
        return 'Immunization';
      case AppointmentType.consultation:
        return 'Consultation';
      case AppointmentType.followUp:
        return 'Follow-up';
    }
  }
}
