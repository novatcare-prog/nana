/// Health Question model for Q&A feature.
/// Plain Dart class (no Freezed) to avoid build_runner dependency.
class HealthQuestion {
  final String? id;
  final String patientId;
  final String questionText;
  final String category;
  final bool isUrgent;
  final String status;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const HealthQuestion({
    this.id,
    required this.patientId,
    required this.questionText,
    this.category = 'general',
    this.isUrgent = false,
    this.status = 'open',
    this.createdAt,
    this.updatedAt,
  });

  factory HealthQuestion.fromJson(Map<String, dynamic> json) {
    return HealthQuestion(
      id: json['id'] as String?,
      patientId: json['patient_id'] as String? ?? '',
      questionText: json['question_text'] as String? ?? '',
      category: json['category'] as String? ?? 'general',
      isUrgent: json['is_urgent'] as bool? ?? false,
      status: json['status'] as String? ?? 'open',
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'] as String)
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'patient_id': patientId,
      'question_text': questionText,
      'category': category,
      'is_urgent': isUrgent,
      'status': status,
      if (createdAt != null) 'created_at': createdAt!.toIso8601String(),
      if (updatedAt != null) 'updated_at': updatedAt!.toIso8601String(),
    };
  }

  HealthQuestion copyWith({
    String? id,
    String? patientId,
    String? questionText,
    String? category,
    bool? isUrgent,
    String? status,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return HealthQuestion(
      id: id ?? this.id,
      patientId: patientId ?? this.patientId,
      questionText: questionText ?? this.questionText,
      category: category ?? this.category,
      isUrgent: isUrgent ?? this.isUrgent,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  /// Display label for the category
  String get categoryLabel {
    switch (category) {
      case 'general':
        return 'General Health';
      case 'pregnancy':
        return 'Pregnancy';
      case 'child_health':
        return 'Child Health';
      case 'nutrition':
        return 'Nutrition';
      case 'family_planning':
        return 'Family Planning';
      case 'emergency':
        return 'Emergency';
      default:
        return category;
    }
  }

  /// Whether the question has been answered
  bool get isAnswered => status == 'answered' || status == 'closed';

  /// Whether the question is still open
  bool get isOpen => status == 'open';

  @override
  String toString() =>
      'HealthQuestion(id: $id, category: $category, status: $status)';
}
