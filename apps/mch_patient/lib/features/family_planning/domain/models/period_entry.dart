import 'package:uuid/uuid.dart';

class PeriodEntry {
  final String id;
  final DateTime startDate;
  final DateTime? endDate;
  final int cycleLength; // Days since previous period started
  final int periodLength; // Duration of bleeding
  final String? notes;
  final List<String> symptoms;
  final DateTime createdAt;
  final DateTime updatedAt;

  PeriodEntry({
    required this.id,
    required this.startDate,
    this.endDate,
    this.cycleLength = 28, // Default, will be recalculated based on history
    this.periodLength = 5,
    this.notes,
    this.symptoms = const [],
    required this.createdAt,
    required this.updatedAt,
  });

  factory PeriodEntry.create({
    required DateTime startDate,
    DateTime? endDate,
    int cycleLength = 28,
    int periodLength = 5,
    String? notes,
    List<String> symptoms = const [],
  }) {
    final now = DateTime.now();
    return PeriodEntry(
      id: const Uuid().v4(),
      startDate: startDate,
      endDate: endDate,
      cycleLength: cycleLength,
      periodLength: periodLength,
      notes: notes,
      symptoms: symptoms,
      createdAt: now,
      updatedAt: now,
    );
  }

  PeriodEntry copyWith({
    DateTime? startDate,
    DateTime? endDate,
    int? cycleLength,
    int? periodLength,
    String? notes,
    List<String>? symptoms,
  }) {
    return PeriodEntry(
      id: id,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      cycleLength: cycleLength ?? this.cycleLength,
      periodLength: periodLength ?? this.periodLength,
      notes: notes ?? this.notes,
      symptoms: symptoms ?? this.symptoms,
      createdAt: createdAt,
      updatedAt: DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'startDate': startDate.toIso8601String(),
      'endDate': endDate?.toIso8601String(),
      'cycleLength': cycleLength,
      'periodLength': periodLength,
      'notes': notes,
      'symptoms': symptoms,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  factory PeriodEntry.fromJson(Map<String, dynamic> json) {
    return PeriodEntry(
      id: json['id'],
      startDate: DateTime.parse(json['startDate']),
      endDate: json['endDate'] != null ? DateTime.parse(json['endDate']) : null,
      cycleLength: json['cycleLength'] ?? 28,
      periodLength: json['periodLength'] ?? 5,
      notes: json['notes'],
      symptoms: (json['symptoms'] as List<dynamic>?)?.cast<String>() ?? [],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }
}
