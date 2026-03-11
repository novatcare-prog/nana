import 'package:google_generative_ai/google_generative_ai.dart';

/// Central Gemini AI client for MCH Kenya.
/// Initialize once in main.dart, then use via provider.
class GeminiService {
  late final GenerativeModel _model;
  late final GenerativeModel _streamModel;
  bool _initialized = false;

  void initialize(String apiKey) {
    _model = GenerativeModel(
      model: 'gemini-2.0-flash',
      apiKey: apiKey,
      generationConfig: GenerationConfig(
        temperature: 0.3, // Lower = more factual, less creative (good for health)
        maxOutputTokens: 1024,
      ),
    );
    _streamModel = GenerativeModel(
      model: 'gemini-2.0-flash',
      apiKey: apiKey,
      generationConfig: GenerationConfig(
        temperature: 0.5,
        maxOutputTokens: 800,
      ),
    );
    _initialized = true;
  }

  bool get isInitialized => _initialized;

  /// Generate a single text response (used for risk assessment, clinical support, dropout prediction).
  Future<String> generateText(String prompt) async {
    _assertInitialized();
    try {
      final response = await _model.generateContent([Content.text(prompt)]);
      return response.text ?? '';
    } catch (e) {
      throw GeminiException('Failed to generate text: $e');
    }
  }

  /// Stream text response word-by-word (used for chatbot).
  Stream<String> streamText(String prompt, {List<Content>? history}) async* {
    _assertInitialized();
    try {
      final chat = _streamModel.startChat(history: history ?? []);
      final response = chat.sendMessageStream(Content.text(prompt));
      await for (final chunk in response) {
        if (chunk.text != null && chunk.text!.isNotEmpty) {
          yield chunk.text!;
        }
      }
    } catch (e) {
      throw GeminiException('Failed to stream text: $e');
    }
  }

  void _assertInitialized() {
    if (!_initialized) {
      throw GeminiException(
        'GeminiService not initialized. Call initialize(apiKey) in main.dart first.',
      );
    }
  }
}

class GeminiException implements Exception {
  final String message;
  GeminiException(this.message);

  @override
  String toString() => 'GeminiException: $message';
}
