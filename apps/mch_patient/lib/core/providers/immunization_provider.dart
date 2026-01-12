import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:mch_core/mch_core.dart';

/// Immunization Repository Provider
final immunizationRepositoryProvider = Provider<ImmunizationRepository>((ref) {
  return ImmunizationRepository(Supabase.instance.client);
});

/// Get immunization records for a specific child
final childImmunizationsProvider = FutureProvider.family<List<ImmunizationRecord>, String>((ref, childId) async {
  final repository = ref.read(immunizationRepositoryProvider);
  
  try {
    return await repository.getImmunizationsByChildId(childId);
  } catch (e) {
    print('Error fetching immunizations: $e');
    return <ImmunizationRecord>[];
  }
});

/// Get immunization coverage (doses received per vaccine type)
final immunizationCoverageProvider = FutureProvider.family<Map<ImmunizationType, int>, String>((ref, childId) async {
  final repository = ref.read(immunizationRepositoryProvider);
  
  try {
    return await repository.getImmunizationCoverage(childId);
  } catch (e) {
    print('Error fetching immunization coverage: $e');
    return <ImmunizationType, int>{};
  }
});

/// Kenya EPI Schedule - MCH Handbook Pages 33-34
/// Returns the expected vaccines at each age milestone
class KenyaEPISchedule {
  static const List<VaccineSchedule> schedule = [
    // At Birth
    VaccineSchedule(
      ageLabel: 'At Birth',
      ageInWeeks: 0,
      vaccines: [
        ScheduledVaccine(type: ImmunizationType.bcg, dose: 1, name: 'BCG'),
        ScheduledVaccine(type: ImmunizationType.bopv, dose: 1, name: 'OPV 0 (Birth)'),
      ],
    ),
    // 6 Weeks
    VaccineSchedule(
      ageLabel: '6 Weeks',
      ageInWeeks: 6,
      vaccines: [
        ScheduledVaccine(type: ImmunizationType.bopv, dose: 2, name: 'OPV 1'),
        ScheduledVaccine(type: ImmunizationType.pentavalent, dose: 1, name: 'Pentavalent 1'),
        ScheduledVaccine(type: ImmunizationType.pcv10, dose: 1, name: 'PCV10 1'),
        ScheduledVaccine(type: ImmunizationType.rotavirus, dose: 1, name: 'Rotavirus 1'),
      ],
    ),
    // 10 Weeks
    VaccineSchedule(
      ageLabel: '10 Weeks',
      ageInWeeks: 10,
      vaccines: [
        ScheduledVaccine(type: ImmunizationType.bopv, dose: 3, name: 'OPV 2'),
        ScheduledVaccine(type: ImmunizationType.pentavalent, dose: 2, name: 'Pentavalent 2'),
        ScheduledVaccine(type: ImmunizationType.pcv10, dose: 2, name: 'PCV10 2'),
        ScheduledVaccine(type: ImmunizationType.rotavirus, dose: 2, name: 'Rotavirus 2'),
      ],
    ),
    // 14 Weeks
    VaccineSchedule(
      ageLabel: '14 Weeks',
      ageInWeeks: 14,
      vaccines: [
        ScheduledVaccine(type: ImmunizationType.bopv, dose: 4, name: 'OPV 3'),
        ScheduledVaccine(type: ImmunizationType.pentavalent, dose: 3, name: 'Pentavalent 3'),
        ScheduledVaccine(type: ImmunizationType.pcv10, dose: 3, name: 'PCV10 3'),
        ScheduledVaccine(type: ImmunizationType.ipv, dose: 1, name: 'IPV'),
      ],
    ),
    // 9 Months
    VaccineSchedule(
      ageLabel: '9 Months',
      ageInWeeks: 39, // ~9 months
      vaccines: [
        ScheduledVaccine(type: ImmunizationType.measlesRubella, dose: 1, name: 'Measles-Rubella 1'),
        ScheduledVaccine(type: ImmunizationType.yellowFever, dose: 1, name: 'Yellow Fever'),
      ],
    ),
    // 18 Months
    VaccineSchedule(
      ageLabel: '18 Months',
      ageInWeeks: 78, // ~18 months
      vaccines: [
        ScheduledVaccine(type: ImmunizationType.measlesRubella, dose: 2, name: 'Measles-Rubella 2'),
      ],
    ),
  ];
  
  /// Get the vaccination status for a child
  static VaccinationStatus getChildVaccinationStatus({
    required DateTime dateOfBirth,
    required Map<ImmunizationType, int> coverage,
  }) {
    final now = DateTime.now();
    final ageInWeeks = now.difference(dateOfBirth).inDays ~/ 7;
    
    int totalDue = 0;
    int totalReceived = 0;
    int overdue = 0;
    
    for (final milestone in schedule) {
      if (ageInWeeks >= milestone.ageInWeeks) {
        // This milestone is due
        for (final vaccine in milestone.vaccines) {
          totalDue++;
          final receivedDoses = coverage[vaccine.type] ?? 0;
          if (receivedDoses >= vaccine.dose) {
            totalReceived++;
          } else {
            overdue++;
          }
        }
      }
    }
    
    return VaccinationStatus(
      totalDue: totalDue,
      totalReceived: totalReceived,
      overdue: overdue,
      percentComplete: totalDue > 0 ? (totalReceived / totalDue * 100).round() : 0,
    );
  }
}

/// A scheduled vaccine milestone
class VaccineSchedule {
  final String ageLabel;
  final int ageInWeeks;
  final List<ScheduledVaccine> vaccines;
  
  const VaccineSchedule({
    required this.ageLabel,
    required this.ageInWeeks,
    required this.vaccines,
  });
}

/// A single vaccine in the schedule
class ScheduledVaccine {
  final ImmunizationType type;
  final int dose;
  final String name;
  
  const ScheduledVaccine({
    required this.type,
    required this.dose,
    required this.name,
  });
}

/// Vaccination status summary
class VaccinationStatus {
  final int totalDue;
  final int totalReceived;
  final int overdue;
  final int percentComplete;
  
  const VaccinationStatus({
    required this.totalDue,
    required this.totalReceived,
    required this.overdue,
    required this.percentComplete,
  });
  
  bool get isUpToDate => overdue == 0;
}
