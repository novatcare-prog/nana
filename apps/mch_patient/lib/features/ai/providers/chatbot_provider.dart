import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mch_core/mch_core.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../services/chatbot_service.dart';

// ── GeminiService provider (overridden in main.dart) ────────────────────────
final patientGeminiServiceProvider = Provider<GeminiService>((ref) {
  throw UnimplementedError(
    'patientGeminiServiceProvider must be overridden in main.dart.',
  );
});

// ── ChatbotService provider ──────────────────────────────────────────────────
final chatbotServiceProvider = Provider<ChatbotService>((ref) {
  return ChatbotService(ref.watch(patientGeminiServiceProvider));
});

// ── Chatbot Notifier ─────────────────────────────────────────────────────────
final chatbotProvider =
    AsyncNotifierProvider<ChatbotNotifier, List<ChatMessage>>(ChatbotNotifier.new);

class ChatbotNotifier extends AsyncNotifier<List<ChatMessage>> {
  String? _systemPrompt;

  @override
  Future<List<ChatMessage>> build() async {
    // Build system prompt from current patient's profile
    _systemPrompt = await _buildSystemPrompt();
    return [
      ChatMessage(
        text: 'Habari! I am Mama AI 🌸\n\n'
            'I am here to help you with questions about your pregnancy, '
            'child health, nutrition, and more — following Kenya Ministry of Health guidelines.\n\n'
            'What would you like to know today?',
        isUser: false,
        timestamp: DateTime.now(),
      ),
    ];
  }

  Future<String> _buildSystemPrompt() async {
    try {
      final supabase = Supabase.instance.client;
      final userId = supabase.auth.currentUser?.id;
      if (userId == null) return PatientContextBuilder.buildChatbotSystemPrompt();

      final profileData = await supabase
          .from('maternal_profiles')
          .select()
          .eq('auth_id', userId)
          .maybeSingle();

      if (profileData == null) return PatientContextBuilder.buildChatbotSystemPrompt();

      final profile = MaternalProfile.fromJson(profileData);

      // Fetch children
      final childrenData = await supabase
          .from('child_profiles')
          .select()
          .eq('maternal_profile_id', profile.id ?? '');

      final children = (childrenData as List)
          .map((e) => ChildProfile.fromJson(e))
          .toList();

      return PatientContextBuilder.buildChatbotSystemPrompt(
        profile: profile,
        children: children,
      );
    } catch (_) {
      return PatientContextBuilder.buildChatbotSystemPrompt();
    }
  }

  /// Send a message and stream the AI response.
  Future<void> sendMessage(String text) async {
    if (text.trim().isEmpty) return;

    final currentMessages = state.value ?? [];

    // Add user message
    final userMsg = ChatMessage(text: text, isUser: true, timestamp: DateTime.now());
    final withUser = [...currentMessages, userMsg];
    state = AsyncValue.data(withUser);

    // Add streaming placeholder for AI response
    final streamingMsg = ChatMessage(
      text: '',
      isUser: false,
      timestamp: DateTime.now(),
      isStreaming: true,
    );
    state = AsyncValue.data([...withUser, streamingMsg]);

    try {
      final service = ref.read(chatbotServiceProvider);
      final responseStream = service.sendMessage(
        systemPrompt: _systemPrompt ?? '',
        history: withUser,
        message: text,
      );

      final buffer = StringBuffer();
      await for (final chunk in responseStream) {
        buffer.write(chunk);
        final msgs = state.value!;
        final updated = [...msgs];
        updated[updated.length - 1] = streamingMsg.copyWith(
          text: buffer.toString(),
          isStreaming: true,
        );
        state = AsyncValue.data(updated);
      }

      // Mark streaming complete
      final msgs = state.value!;
      final updated = [...msgs];
      updated[updated.length - 1] = streamingMsg.copyWith(
        text: buffer.toString(),
        isStreaming: false,
      );
      state = AsyncValue.data(updated);
    } catch (e) {
      // Replace streaming placeholder with error message
      final msgs = state.value!;
      final updated = [...msgs];
      updated[updated.length - 1] = ChatMessage(
        text: 'Sorry, I am unable to respond right now. '
            'Please check your internet connection and try again.',
        isUser: false,
        timestamp: DateTime.now(),
        isStreaming: false,
      );
      state = AsyncValue.data(updated);
    }
  }

  void clearChat() {
    state = AsyncValue.data([
      ChatMessage(
        text: 'Chat cleared. How can I help you? 🌸',
        isUser: false,
        timestamp: DateTime.now(),
      ),
    ]);
  }
}
