/// Question Answer model for Q&A feature.
/// Plain Dart class (no Freezed) to avoid build_runner dependency.
class QuestionAnswer {
  final String? id;
  final String questionId;
  final String responderId;
  final String responderName;
  final String answerText;
  final bool isUrgentFlag;
  final DateTime? createdAt;

  const QuestionAnswer({
    this.id,
    required this.questionId,
    required this.responderId,
    this.responderName = '',
    required this.answerText,
    this.isUrgentFlag = false,
    this.createdAt,
  });

  factory QuestionAnswer.fromJson(Map<String, dynamic> json) {
    return QuestionAnswer(
      id: json['id'] as String?,
      questionId: json['question_id'] as String? ?? '',
      responderId: json['responder_id'] as String? ?? '',
      responderName: json['responder_name'] as String? ?? 'Health Worker',
      answerText: json['answer_text'] as String? ?? '',
      isUrgentFlag: json['is_urgent_flag'] as bool? ?? false,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'question_id': questionId,
      'responder_id': responderId,
      'responder_name': responderName,
      'answer_text': answerText,
      'is_urgent_flag': isUrgentFlag,
      if (createdAt != null) 'created_at': createdAt!.toIso8601String(),
    };
  }

  QuestionAnswer copyWith({
    String? id,
    String? questionId,
    String? responderId,
    String? responderName,
    String? answerText,
    bool? isUrgentFlag,
    DateTime? createdAt,
  }) {
    return QuestionAnswer(
      id: id ?? this.id,
      questionId: questionId ?? this.questionId,
      responderId: responderId ?? this.responderId,
      responderName: responderName ?? this.responderName,
      answerText: answerText ?? this.answerText,
      isUrgentFlag: isUrgentFlag ?? this.isUrgentFlag,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  String toString() =>
      'QuestionAnswer(id: $id, questionId: $questionId, urgent: $isUrgentFlag)';
}
