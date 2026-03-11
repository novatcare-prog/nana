import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:mch_core/mch_core.dart';

/// A single message in the chat conversation.
class ChatMessage {
  final String text;
  final bool isUser;
  final DateTime timestamp;
  final bool isStreaming;

  ChatMessage({
    required this.text,
    required this.isUser,
    required this.timestamp,
    this.isStreaming = false,
  });

  ChatMessage copyWith({String? text, bool? isStreaming}) => ChatMessage(
        text: text ?? this.text,
        isUser: isUser,
        timestamp: timestamp,
        isStreaming: isStreaming ?? this.isStreaming,
      );
}

/// Streaming chatbot service for the patient-facing Mama AI assistant.
class ChatbotService {
  final GeminiService _gemini;

  ChatbotService(this._gemini);

  /// Stream an AI response to a user message.
  /// [systemPrompt] — the opening system context (built with PatientContextBuilder).
  /// [history] — prior conversation turn pairs for context.
  /// [message] — the new user message.
  Stream<String> sendMessage({
    required String systemPrompt,
    required List<ChatMessage> history,
    required String message,
  }) {
    // Convert history to Gemini Content format
    // Prefix first user turn with system prompt
    final geminiHistory = _buildHistory(systemPrompt, history);

    return _gemini.streamText(message, history: geminiHistory);
  }

  /// Converts ChatMessage history to Gemini Content objects.
  List<Content> _buildHistory(String systemPrompt, List<ChatMessage> history) {
    final contents = <Content>[];

    // Inject system prompt as the first user turn (Gemini Flash doesn't have system role)
    // We simulate it as: user says "CONTEXT: ...", model says "Understood."
    contents.add(Content.text('SYSTEM CONTEXT (for AI only, not shown to user):\n$systemPrompt'));
    contents.add(Content.model([TextPart('Understood. I will use this context to help the patient.')]));

    // Add conversation history (skip last partial/streaming messages)
    for (final msg in history.where((m) => !m.isStreaming)) {
      if (msg.isUser) {
        contents.add(Content.text(msg.text));
      } else {
        contents.add(Content.model([TextPart(msg.text)]));
      }
    }

    return contents;
  }
}
