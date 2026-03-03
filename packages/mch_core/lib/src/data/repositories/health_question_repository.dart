import 'package:supabase_flutter/supabase_flutter.dart';
import '../../models/qa/health_question.dart';
import '../../models/qa/question_answer.dart';

/// Repository for the Q&A feature.
/// Handles CRUD operations for health questions and answers via Supabase.
class HealthQuestionRepository {
  final SupabaseClient _supabase;

  HealthQuestionRepository(this._supabase);

  // ===================== PATIENT METHODS =====================

  /// Submit a new question (patient)
  Future<HealthQuestion> submitQuestion(HealthQuestion question) async {
    try {
      final json = question.toJson();
      json.remove('id'); // Let DB generate
      json.remove('created_at');
      json.remove('updated_at');

      final response = await _supabase
          .from('health_questions')
          .insert(json)
          .select()
          .single();

      return HealthQuestion.fromJson(response);
    } catch (e) {
      throw Exception('Failed to submit question: $e');
    }
  }

  /// Get all questions for the current patient
  Future<List<HealthQuestion>> getMyQuestions(String patientId) async {
    try {
      final response = await _supabase
          .from('health_questions')
          .select()
          .eq('patient_id', patientId)
          .order('created_at', ascending: false);

      return (response as List)
          .map((json) => HealthQuestion.fromJson(json))
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch my questions: $e');
    }
  }

  /// Close a question (patient marks as resolved)
  Future<void> closeQuestion(String questionId) async {
    try {
      await _supabase
          .from('health_questions')
          .update({'status': 'closed'}).eq('id', questionId);
    } catch (e) {
      throw Exception('Failed to close question: $e');
    }
  }

  // ===================== HEALTH WORKER METHODS =====================

  /// Get all open/answered questions (health worker view).
  /// Intentionally selects only non-identifying columns for anonymity.
  Future<List<HealthQuestion>> getAllOpenQuestions() async {
    try {
      final response = await _supabase
          .from('health_questions')
          .select(
              'id, question_text, category, is_urgent, status, created_at, updated_at')
          .inFilter('status', ['open', 'answered'])
          .order('is_urgent', ascending: false)
          .order('created_at', ascending: false);

      return (response as List).map((json) {
        // Ensure patient_id is blank for health worker view
        json['patient_id'] = '';
        return HealthQuestion.fromJson(json);
      }).toList();
    } catch (e) {
      throw Exception('Failed to fetch questions: $e');
    }
  }

  /// Get all questions (including closed) for health worker
  Future<List<HealthQuestion>> getAllQuestions() async {
    try {
      final response = await _supabase
          .from('health_questions')
          .select(
              'id, question_text, category, is_urgent, status, created_at, updated_at')
          .order('created_at', ascending: false);

      return (response as List).map((json) {
        json['patient_id'] = '';
        return HealthQuestion.fromJson(json);
      }).toList();
    } catch (e) {
      throw Exception('Failed to fetch all questions: $e');
    }
  }

  /// Flag a question as urgent (health worker)
  Future<void> flagUrgent(String questionId) async {
    try {
      await _supabase
          .from('health_questions')
          .update({'is_urgent': true}).eq('id', questionId);
    } catch (e) {
      throw Exception('Failed to flag question: $e');
    }
  }

  /// Update question status
  Future<void> updateQuestionStatus(String questionId, String status) async {
    try {
      await _supabase
          .from('health_questions')
          .update({'status': status}).eq('id', questionId);
    } catch (e) {
      throw Exception('Failed to update question status: $e');
    }
  }

  // ===================== ANSWERS =====================

  /// Get all answers for a question
  Future<List<QuestionAnswer>> getAnswersForQuestion(String questionId) async {
    try {
      final response = await _supabase
          .from('question_answers')
          .select()
          .eq('question_id', questionId)
          .order('created_at', ascending: true);

      return (response as List)
          .map((json) => QuestionAnswer.fromJson(json))
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch answers: $e');
    }
  }

  /// Submit an answer to a question (health worker)
  Future<QuestionAnswer> submitAnswer(QuestionAnswer answer) async {
    try {
      final json = answer.toJson();
      json.remove('id');
      json.remove('created_at');

      final response = await _supabase
          .from('question_answers')
          .insert(json)
          .select()
          .single();

      return QuestionAnswer.fromJson(response);
    } catch (e) {
      throw Exception('Failed to submit answer: $e');
    }
  }

  // ===================== REALTIME =====================

  /// Stream of changes to health_questions table
  Stream<List<Map<String, dynamic>>> watchQuestions() {
    return _supabase
        .from('health_questions')
        .stream(primaryKey: ['id']).order('created_at', ascending: false);
  }

  /// Stream of changes to answers for a specific question
  Stream<List<Map<String, dynamic>>> watchAnswers(String questionId) {
    return _supabase
        .from('question_answers')
        .stream(primaryKey: ['id'])
        .eq('question_id', questionId)
        .order('created_at', ascending: true);
  }

  // ===================== STATISTICS =====================

  /// Get count of unanswered questions (for badge)
  Future<int> getUnansweredCount() async {
    try {
      final response = await _supabase
          .from('health_questions')
          .select('id')
          .eq('status', 'open');

      return (response as List).length;
    } catch (e) {
      return 0;
    }
  }
}
