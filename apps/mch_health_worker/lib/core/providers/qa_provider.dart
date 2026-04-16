import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:mch_core/mch_core.dart';

/// Repository provider for Q&A
final qaRepositoryProvider = Provider<HealthQuestionRepository>((ref) {
  return HealthQuestionRepository(Supabase.instance.client);
});

/// All open questions (for health worker feed)
final openQuestionsProvider = FutureProvider<List<HealthQuestion>>((ref) async {
  final repository = ref.read(qaRepositoryProvider);

  try {
    return await repository.getAllOpenQuestions();
  } catch (e) {
    debugPrint('❓ Error fetching open questions: $e');
    return <HealthQuestion>[];
  }
});

/// All questions (including closed)
final allQuestionsProvider = FutureProvider<List<HealthQuestion>>((ref) async {
  final repository = ref.read(qaRepositoryProvider);

  try {
    return await repository.getAllQuestions();
  } catch (e) {
    debugPrint('❓ Error fetching all questions: $e');
    return <HealthQuestion>[];
  }
});

/// Answers for a specific question
final questionAnswersProvider =
    FutureProvider.family<List<QuestionAnswer>, String>(
        (ref, questionId) async {
  final repository = ref.read(qaRepositoryProvider);

  try {
    return await repository.getAnswersForQuestion(questionId);
  } catch (e) {
    debugPrint('❓ Error fetching answers: $e');
    return <QuestionAnswer>[];
  }
});

/// Realtime stream of answers
final answersStreamProvider =
    StreamProvider.family<List<QuestionAnswer>, String>((ref, questionId) {
  final repository = ref.read(qaRepositoryProvider);

  return repository.watchAnswers(questionId).map((data) {
    return data.map((json) => QuestionAnswer.fromJson(json)).toList();
  });
});

/// Stream of all questions (for live badge updates)
final questionsStreamProvider = StreamProvider<List<HealthQuestion>>((ref) {
  final repository = ref.read(qaRepositoryProvider);

  return repository.watchQuestions().map((data) {
    return data.map((json) {
      json['patient_id'] = json['patient_id'] ?? '';
      return HealthQuestion.fromJson(json);
    }).toList();
  });
});

/// Unanswered questions count (for badge)
final unansweredQuestionsCountProvider = FutureProvider<int>((ref) async {
  final repository = ref.read(qaRepositoryProvider);

  try {
    return await repository.getUnansweredCount();
  } catch (e) {
    return 0;
  }
});

/// Action: Submit an answer
final submitAnswerProvider = Provider<
    Future<QuestionAnswer> Function(String questionId, String answerText,
        {bool isUrgent})>((ref) {
  final repository = ref.read(qaRepositoryProvider);
  final user = Supabase.instance.client.auth.currentUser;

  return (String questionId, String answerText, {bool isUrgent = false}) async {
    if (user == null) throw Exception('Not authenticated');

    // Get the health worker's name from metadata
    final name = user.userMetadata?['full_name'] as String? ?? 'Health Worker';

    final answer = QuestionAnswer(
      questionId: questionId,
      responderId: user.id,
      responderName: name,
      answerText: answerText,
      isUrgentFlag: isUrgent,
    );

    final result = await repository.submitAnswer(answer);

    // Refresh related providers
    ref.invalidate(openQuestionsProvider);
    ref.invalidate(questionAnswersProvider(questionId));
    ref.invalidate(unansweredQuestionsCountProvider);

    return result;
  };
});

/// Action: Flag a question as urgent
final flagUrgentProvider =
    Provider<Future<void> Function(String questionId)>((ref) {
  final repository = ref.read(qaRepositoryProvider);

  return (String questionId) async {
    await repository.flagUrgent(questionId);
    ref.invalidate(openQuestionsProvider);
  };
});

/// Action: Update question status
final updateQuestionStatusProvider =
    Provider<Future<void> Function(String questionId, String status)>((ref) {
  final repository = ref.read(qaRepositoryProvider);

  return (String questionId, String status) async {
    await repository.updateQuestionStatus(questionId, status);
    ref.invalidate(openQuestionsProvider);
    ref.invalidate(allQuestionsProvider);
    ref.invalidate(unansweredQuestionsCountProvider);
  };
});
