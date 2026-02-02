import 'package:mch_core/mch_core.dart';

/// Data model for ANC Coverage Statistics
class AncCoverageStats {
  final int totalActivePatients;
  final int firstVisitCount;
  final int secondVisitCount;
  final int thirdVisitCount;
  final int fourthPlusVisitCount;

  const AncCoverageStats({
    required this.totalActivePatients,
    required this.firstVisitCount,
    required this.secondVisitCount,
    required this.thirdVisitCount,
    required this.fourthPlusVisitCount,
  });

  /// Calculate coverage percentage for a visit number
  double coveragePercentage(int visitNumber) {
    if (totalActivePatients == 0) return 0;
    final count = switch (visitNumber) {
      1 => firstVisitCount,
      2 => secondVisitCount,
      3 => thirdVisitCount,
      _ => fourthPlusVisitCount,
    };
    return (count / totalActivePatients) * 100;
  }
}

/// Data model for Immunization Coverage Statistics
class ImmunizationCoverageStats {
  final int totalActivePatients;
  final int ttVaccinated;
  final int tdVaccinated;
  final List<VaccineCount> otherVaccines;

  const ImmunizationCoverageStats({
    required this.totalActivePatients,
    required this.ttVaccinated,
    required this.tdVaccinated,
    required this.otherVaccines,
  });

  double get ttCoveragePercent =>
      totalActivePatients > 0 ? (ttVaccinated / totalActivePatients) * 100 : 0;

  double get tdCoveragePercent =>
      totalActivePatients > 0 ? (tdVaccinated / totalActivePatients) * 100 : 0;
}

/// Simple count for a vaccine type
class VaccineCount {
  final String type;
  final int count;

  const VaccineCount({required this.type, required this.count});
}

/// Enriched high-risk patient data for reports
class HighRiskPatientReport {
  final MaternalProfile profile;
  final List<String> riskFactors;
  final DateTime? lastVisitDate;
  final int? daysUntilEdd;

  const HighRiskPatientReport({
    required this.profile,
    required this.riskFactors,
    this.lastVisitDate,
    this.daysUntilEdd,
  });

  /// Check if patient is overdue for a visit (>4 weeks since last visit)
  bool get isOverdueForVisit {
    if (lastVisitDate == null) return true;
    return DateTime.now().difference(lastVisitDate!).inDays > 28;
  }

  /// Priority level based on EDD proximity and risk factors
  int get priorityScore {
    int score = 0;

    // More risk factors = higher priority
    score += riskFactors.length * 10;

    // Closer to EDD = higher priority
    if (daysUntilEdd != null) {
      if (daysUntilEdd! <= 7) {
        score += 50;
      } else if (daysUntilEdd! <= 14)
        score += 30;
      else if (daysUntilEdd! <= 30) score += 15;
    }

    // Overdue for visit = higher priority
    if (isOverdueForVisit) score += 20;

    return score;
  }
}

/// Date range for filtering reports
class ReportDateRange {
  final DateTime startDate;
  final DateTime endDate;

  const ReportDateRange({
    required this.startDate,
    required this.endDate,
  });

  /// Create a date range for the current month
  factory ReportDateRange.thisMonth() {
    final now = DateTime.now();
    return ReportDateRange(
      startDate: DateTime(now.year, now.month, 1),
      endDate: DateTime(now.year, now.month + 1, 0),
    );
  }

  /// Create a date range for the last 30 days
  factory ReportDateRange.last30Days() {
    final now = DateTime.now();
    return ReportDateRange(
      startDate: now.subtract(const Duration(days: 30)),
      endDate: now,
    );
  }

  /// Create a date range for the last 7 days
  factory ReportDateRange.last7Days() {
    final now = DateTime.now();
    return ReportDateRange(
      startDate: now.subtract(const Duration(days: 7)),
      endDate: now,
    );
  }
}
