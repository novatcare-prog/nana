import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mch_core/mch_core.dart';
import '../../../../core/providers/qa_provider.dart';

/// Screen for health workers to view a question and submit answers.
class AnswerQuestionScreen extends ConsumerStatefulWidget {
  final HealthQuestion question;

  const AnswerQuestionScreen({super.key, required this.question});

  @override
  ConsumerState<AnswerQuestionScreen> createState() =>
      _AnswerQuestionScreenState();
}

class _AnswerQuestionScreenState extends ConsumerState<AnswerQuestionScreen> {
  final _answerController = TextEditingController();
  bool _isSubmitting = false;
  bool _markUrgent = false;

  @override
  void dispose() {
    _answerController.dispose();
    super.dispose();
  }

  Future<void> _submitAnswer() async {
    if (_answerController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter your response')),
      );
      return;
    }

    setState(() => _isSubmitting = true);

    try {
      final submit = ref.read(submitAnswerProvider);
      await submit(
        widget.question.id!,
        _answerController.text.trim(),
        isUrgent: _markUrgent,
      );

      if (mounted) {
        _answerController.clear();
        setState(() => _markUrgent = false);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Row(
              children: [
                Icon(Icons.check_circle, color: Colors.white, size: 20),
                SizedBox(width: 8),
                Text('Response submitted successfully'),
              ],
            ),
            backgroundColor: Colors.green.shade600,
            behavior: SnackBarBehavior.floating,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
        );

        // Refresh answers
        ref.invalidate(questionAnswersProvider(widget.question.id!));
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to submit: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  Future<void> _flagAsUrgent() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(Icons.warning_amber, color: Colors.red.shade700),
            const SizedBox(width: 8),
            const Text('Flag as Urgent?'),
          ],
        ),
        content: const Text(
          'This will notify the patient to seek immediate medical attention at their nearest health facility.\n\nOnly use this for genuinely urgent situations.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            style: FilledButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Flag Urgent'),
          ),
        ],
      ),
    );

    if (confirm == true) {
      try {
        final flag = ref.read(flagUrgentProvider);
        await flag(widget.question.id!);

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('⚠️ Question flagged as urgent'),
              backgroundColor: Colors.red,
            ),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primaryColor = theme.primaryColor;
    final answersAsync = ref.watch(answersStreamProvider(widget.question.id!));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Respond to Question'),
        elevation: 0,
        actions: [
          if (!widget.question.isUrgent)
            IconButton(
              icon: Icon(Icons.warning_amber, color: Colors.red.shade400),
              onPressed: _flagAsUrgent,
              tooltip: 'Flag as Urgent',
            ),
          PopupMenuButton<String>(
            onSelected: (value) async {
              if (value == 'close') {
                try {
                  final update = ref.read(updateQuestionStatusProvider);
                  await update(widget.question.id!, 'closed');
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Question closed'),
                        backgroundColor: Colors.green,
                      ),
                    );
                    Navigator.pop(context);
                  }
                } catch (e) {
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Error: $e')),
                    );
                  }
                }
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'close',
                child: Row(
                  children: [
                    Icon(Icons.check_circle_outline, size: 20),
                    SizedBox(width: 8),
                    Text('Close Question'),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Anonymous Patient Question Card
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade50,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: widget.question.isUrgent
                            ? Colors.red.shade200
                            : Colors.grey.shade200,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Header
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Colors.grey.shade200,
                                shape: BoxShape.circle,
                              ),
                              child: Icon(Icons.person_outline,
                                  size: 20, color: Colors.grey.shade600),
                            ),
                            const SizedBox(width: 10),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Anonymous Patient',
                                  style: theme.textTheme.bodyMedium?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  _formatTime(widget.question.createdAt),
                                  style: TextStyle(
                                    color: Colors.grey.shade500,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                            const Spacer(),
                            _buildCategoryChip(widget.question.category),
                          ],
                        ),

                        const SizedBox(height: 16),

                        // Question text
                        Text(
                          widget.question.questionText,
                          style: theme.textTheme.bodyLarge?.copyWith(
                            height: 1.6,
                          ),
                        ),

                        // Urgent banner
                        if (widget.question.isUrgent) ...[
                          const SizedBox(height: 16),
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.red.shade50,
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: Colors.red.shade200),
                            ),
                            child: Row(
                              children: [
                                Icon(Icons.warning_amber,
                                    color: Colors.red.shade700, size: 20),
                                const SizedBox(width: 8),
                                Text(
                                  'Flagged as Urgent',
                                  style: TextStyle(
                                    color: Colors.red.shade800,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Existing answers
                  Row(
                    children: [
                      Icon(Icons.forum_outlined, color: primaryColor, size: 20),
                      const SizedBox(width: 8),
                      Text(
                        'Responses',
                        style: theme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  answersAsync.when(
                    loading: () => const Padding(
                      padding: EdgeInsets.symmetric(vertical: 24),
                      child: Center(child: CircularProgressIndicator()),
                    ),
                    error: (error, _) =>
                        Text('Error loading responses: $error'),
                    data: (answers) {
                      if (answers.isEmpty) {
                        return Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: Colors.amber.shade50,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.amber.shade200),
                          ),
                          child: Row(
                            children: [
                              Icon(Icons.hourglass_empty,
                                  color: Colors.amber.shade700, size: 24),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  'No responses yet. Be the first to help this patient!',
                                  style: TextStyle(
                                    color: Colors.amber.shade900,
                                    height: 1.4,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      }

                      return Column(
                        children: answers
                            .map((a) => _AnswerBubble(
                                answer: a, primaryColor: primaryColor))
                            .toList(),
                      );
                    },
                  ),

                  const SizedBox(height: 80), // Space for input area
                ],
              ),
            ),
          ),

          // Reply input area
          _buildReplyInput(theme, primaryColor),
        ],
      ),
    );
  }

  Widget _buildReplyInput(ThemeData theme, Color primaryColor) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
      decoration: BoxDecoration(
        color: theme.scaffoldBackgroundColor,
        border: Border(
          top: BorderSide(color: Colors.grey.shade200),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Column(
          children: [
            // Urgent toggle
            Row(
              children: [
                Checkbox(
                  value: _markUrgent,
                  onChanged: (val) =>
                      setState(() => _markUrgent = val ?? false),
                  activeColor: Colors.red,
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  visualDensity: VisualDensity.compact,
                ),
                const SizedBox(width: 4),
                Icon(Icons.warning_amber, size: 16, color: Colors.red.shade400),
                const SizedBox(width: 4),
                Text(
                  'Advise patient to seek immediate care',
                  style: TextStyle(
                    color: Colors.red.shade600,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),

            // Text input + send
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Expanded(
                  child: TextField(
                    controller: _answerController,
                    maxLines: 4,
                    minLines: 1,
                    textCapitalization: TextCapitalization.sentences,
                    decoration: InputDecoration(
                      hintText: 'Type your response...',
                      hintStyle: TextStyle(color: Colors.grey.shade400),
                      filled: true,
                      fillColor: Colors.grey.shade100,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 10),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  decoration: BoxDecoration(
                    color: primaryColor,
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    onPressed: _isSubmitting ? null : _submitAnswer,
                    icon: _isSubmitting
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : const Icon(Icons.send, color: Colors.white, size: 20),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryChip(String category) {
    final configs = {
      'general': ('General', Colors.green),
      'pregnancy': ('Pregnancy', Colors.purple),
      'child_health': ('Child Health', Colors.blue),
      'nutrition': ('Nutrition', Colors.orange),
      'family_planning': ('Family Planning', Colors.teal),
      'emergency': ('Emergency', Colors.red),
    };

    final config = configs[category] ?? ('General', Colors.green);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: config.$2.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        config.$1,
        style: TextStyle(
          color: config.$2,
          fontWeight: FontWeight.w600,
          fontSize: 11,
        ),
      ),
    );
  }

  String _formatTime(DateTime? dt) {
    if (dt == null) return '';
    final now = DateTime.now();
    final diff = now.difference(dt);
    if (diff.inMinutes < 1) return 'Just now';
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    if (diff.inDays < 7) return '${diff.inDays}d ago';
    return '${dt.day}/${dt.month}/${dt.year}';
  }
}

/// Answer bubble for a health worker's response.
class _AnswerBubble extends StatelessWidget {
  final QuestionAnswer answer;
  final Color primaryColor;

  const _AnswerBubble({
    required this.answer,
    required this.primaryColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: primaryColor.withOpacity(0.04),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: answer.isUrgentFlag
              ? Colors.red.shade200
              : primaryColor.withOpacity(0.15),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 14,
                backgroundColor: primaryColor.withOpacity(0.12),
                child:
                    Icon(Icons.medical_services, size: 14, color: primaryColor),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  answer.responderName.isEmpty
                      ? 'Health Worker'
                      : answer.responderName,
                  style: theme.textTheme.bodySmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Text(
                _formatTime(answer.createdAt),
                style: TextStyle(color: Colors.grey.shade500, fontSize: 11),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            answer.answerText,
            style: theme.textTheme.bodyMedium?.copyWith(height: 1.5),
          ),
          if (answer.isUrgentFlag) ...[
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.red.shade50,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.warning, size: 14, color: Colors.red.shade700),
                  const SizedBox(width: 4),
                  Text(
                    'Advised to seek immediate care',
                    style: TextStyle(
                      color: Colors.red.shade700,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  String _formatTime(DateTime? dt) {
    if (dt == null) return '';
    final now = DateTime.now();
    final diff = now.difference(dt);
    if (diff.inMinutes < 1) return 'Just now';
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    return '${dt.day}/${dt.month}/${dt.year}';
  }
}
