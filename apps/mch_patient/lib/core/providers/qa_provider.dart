import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:mch_core/mch_core.dart';

/// Repository provider for Q&A
final qaRepositoryProvider = Provider<HealthQuestionRepository>((ref) {
  return HealthQuestionRepository(Supabase.instance.client);
});

/// Provider for the current patient's questions
final myQuestionsProvider = FutureProvider<List<HealthQuestion>>((ref) async {
  final repository = ref.read(qaRepositoryProvider);
  final user = Supabase.instance.client.auth.currentUser;

  if (user == null) return <HealthQuestion>[];

  try {
    final questions = await repository.getMyQuestions(user.id);
    return questions;
  } catch (e) {
    print('❓ Error fetching my questions: $e');
    return <HealthQuestion>[];
  }
});

/// Provider for answers to a specific question
final questionAnswersProvider =
    FutureProvider.family<List<QuestionAnswer>, String>(
        (ref, questionId) async {
  final repository = ref.read(qaRepositoryProvider);

  try {
    return await repository.getAnswersForQuestion(questionId);
  } catch (e) {
    print('❓ Error fetching answers: $e');
    return <QuestionAnswer>[];
  }
});

/// Stream provider for realtime answer updates on a specific question
final answersStreamProvider =
    StreamProvider.family<List<QuestionAnswer>, String>((ref, questionId) {
  final repository = ref.read(qaRepositoryProvider);

  return repository.watchAnswers(questionId).map((data) {
    return data.map((json) => QuestionAnswer.fromJson(json)).toList();
  });
});

/// Action provider to submit a new question
final submitQuestionProvider = Provider<
    Future<HealthQuestion> Function(
        String questionText, String category)>((ref) {
  final repository = ref.read(qaRepositoryProvider);
  final user = Supabase.instance.client.auth.currentUser;

  return (String questionText, String category) async {
    if (user == null) throw Exception('Not authenticated');

    final question = HealthQuestion(
      patientId: user.id,
      questionText: questionText,
      category: category,
    );

    final result = await repository.submitQuestion(question);

    // Refresh the questions list
    ref.invalidate(myQuestionsProvider);

    return result;
  };
});

/// Action provider to close a question
final closeQuestionProvider =
    Provider<Future<void> Function(String questionId)>((ref) {
  final repository = ref.read(qaRepositoryProvider);

  return (String questionId) async {
    await repository.closeQuestion(questionId);
    ref.invalidate(myQuestionsProvider);
  };
});

/// Count of questions that have new answers (answered status)
final answeredQuestionsCountProvider = Provider<int>((ref) {
  final questionsAsync = ref.watch(myQuestionsProvider);
  return questionsAsync.when(
    data: (questions) => questions.where((q) => q.status == 'answered').length,
    loading: () => 0,
    error: (_, __) => 0,
  );
});
