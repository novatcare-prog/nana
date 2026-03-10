import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mch_core/mch_core.dart';
import '../../../../core/providers/qa_provider.dart';

/// Screen showing question detail with threaded answers.
class QuestionDetailScreen extends ConsumerWidget {
  final String questionId;

  const QuestionDetailScreen({super.key, required this.questionId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final questionsAsync = ref.watch(myQuestionsProvider);
    final answersAsync = ref.watch(answersStreamProvider(questionId));
    final theme = Theme.of(context);
    final primaryColor = theme.primaryColor;

    // Find our question from the list
    final question = questionsAsync.when(
      data: (questions) {
        try {
          return questions.firstWhere((q) => q.id == questionId);
        } catch (_) {
          return null;
        }
      },
      loading: () => null,
      error: (_, __) => null,
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Question Detail'),
        elevation: 0,
        actions: [
          if (question != null && question.status != 'closed')
            PopupMenuButton<String>(
              onSelected: (value) {
                if (value == 'close') {
                  _showCloseDialog(context, ref);
                }
              },
              itemBuilder: (context) => [
                const PopupMenuItem(
                  value: 'close',
                  child: Row(
                    children: [
                      Icon(Icons.check_circle_outline, size: 20),
                      SizedBox(width: 8),
                      Text('Mark as Resolved'),
                    ],
                  ),
                ),
              ],
            ),
        ],
      ),
      body: question == null
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Question Card
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: primaryColor.withOpacity(0.04),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: primaryColor.withOpacity(0.15),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Category + Status row
                        Row(
                          children: [
                            _buildCategoryChip(question.category, primaryColor),
                            const Spacer(),
                            _buildStatusChip(question),
                          ],
                        ),
                        const SizedBox(height: 16),

                        // Question text
                        Text(
                          question.questionText,
                          style: theme.textTheme.bodyLarge?.copyWith(
                            height: 1.6,
                          ),
                        ),

                        const SizedBox(height: 12),

                        // Time
                        Row(
                          children: [
                            Icon(Icons.access_time,
                                size: 14, color: Colors.grey.shade500),
                            const SizedBox(width: 4),
                            Text(
                              _formatDateTime(question.createdAt),
                              style: TextStyle(
                                color: Colors.grey.shade500,
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  // Urgent Banner
                  if (question.isUrgent) ...[
                    const SizedBox(height: 16),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Colors.red.shade50,
                            Colors.red.shade100.withOpacity(0.5),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: Colors.red.shade300),
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.red.shade100,
                              shape: BoxShape.circle,
                            ),
                            child: Icon(Icons.warning_amber,
                                color: Colors.red.shade800, size: 24),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Seek Medical Attention',
                                  style: TextStyle(
                                    color: Colors.red.shade900,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'A health worker has flagged this as urgent. Please visit your nearest health facility as soon as possible.',
                                  style: TextStyle(
                                    color: Colors.red.shade800,
                                    fontSize: 13,
                                    height: 1.4,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],

                  const SizedBox(height: 28),

                  // Answers Section
                  Row(
                    children: [
                      Icon(Icons.forum_outlined, color: primaryColor, size: 20),
                      const SizedBox(width: 8),
                      Text(
                        'Responses from Health Workers',
                        style: theme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),

                  // Answers list
                  answersAsync.when(
                    loading: () => const Padding(
                      padding: EdgeInsets.symmetric(vertical: 32),
                      child: Center(child: CircularProgressIndicator()),
                    ),
                    error: (error, _) => Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      child: Text('Could not load responses. Please try again.',
                          style: TextStyle(color: Colors.grey.shade600)),
                    ),
                    data: (answers) {
                      if (answers.isEmpty) {
                        return _buildNoAnswersYet(context, primaryColor);
                      }
                      return Column(
                        children: answers
                            .map((a) => _AnswerCard(
                                answer: a, primaryColor: primaryColor))
                            .toList(),
                      );
                    },
                  ),

                  const SizedBox(height: 24),
                ],
              ),
            ),
    );
  }

  Widget _buildCategoryChip(String category, Color primaryColor) {
    final labels = {
      'general': 'General Health',
      'pregnancy': 'Pregnancy',
      'child_health': 'Child Health',
      'nutrition': 'Nutrition',
      'family_planning': 'Family Planning',
      'emergency': 'Emergency',
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: primaryColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        labels[category] ?? category,
        style: TextStyle(
          color: primaryColor,
          fontWeight: FontWeight.w600,
          fontSize: 12,
        ),
      ),
    );
  }

  Widget _buildStatusChip(HealthQuestion question) {
    if (question.isUrgent) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: Colors.red.shade600,
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Text(
          '⚠ URGENT',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 11,
          ),
        ),
      );
    }

    Color bg;
    Color fg;
    String label;
    switch (question.status) {
      case 'answered':
        bg = Colors.green.shade50;
        fg = Colors.green.shade700;
        label = '✓ Answered';
        break;
      case 'closed':
        bg = Colors.grey.shade100;
        fg = Colors.grey.shade600;
        label = 'Closed';
        break;
      default:
        bg = Colors.amber.shade50;
        fg = Colors.amber.shade800;
        label = 'Awaiting Response';
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        label,
        style: TextStyle(color: fg, fontWeight: FontWeight.w600, fontSize: 11),
      ),
    );
  }

  Widget _buildNoAnswersYet(BuildContext context, Color primaryColor) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        children: [
          Icon(Icons.hourglass_empty, size: 40, color: Colors.grey.shade400),
          const SizedBox(height: 12),
          Text(
            'No responses yet',
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: Colors.grey.shade700,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Health workers will respond soon.\nYou\'ll see their answers here.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.grey.shade500,
              fontSize: 13,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }

  void _showCloseDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Mark as Resolved?'),
        content: const Text(
            'This will close the question. Health workers will no longer respond.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () async {
              Navigator.pop(context);
              try {
                final close = ref.read(closeQuestionProvider);
                await close(questionId);
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Question marked as resolved'),
                      backgroundColor: Colors.green,
                    ),
                  );
                }
              } catch (e) {
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content:
                          Text('Could not resolve question. Please try again.'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              }
            },
            child: const Text('Resolve'),
          ),
        ],
      ),
    );
  }

  String _formatDateTime(DateTime? dt) {
    if (dt == null) return '';
    final now = DateTime.now();
    final diff = now.difference(dt);

    if (diff.inMinutes < 1) return 'Just now';
    if (diff.inMinutes < 60) return '${diff.inMinutes} minutes ago';
    if (diff.inHours < 24) return '${diff.inHours} hours ago';
    if (diff.inDays < 7) return '${diff.inDays} days ago';

    final months = [
      '',
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return '${months[dt.month]} ${dt.day}, ${dt.year}';
  }
}

/// Card widget for a single answer from a health worker.
class _AnswerCard extends StatelessWidget {
  final QuestionAnswer answer;
  final Color primaryColor;

  const _AnswerCard({required this.answer, required this.primaryColor});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color:
              answer.isUrgentFlag ? Colors.red.shade200 : Colors.grey.shade200,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // HW name + time
          Row(
            children: [
              CircleAvatar(
                radius: 16,
                backgroundColor: primaryColor.withOpacity(0.12),
                child: Icon(
                  Icons.medical_services,
                  size: 16,
                  color: primaryColor,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      answer.responderName.isEmpty
                          ? 'Health Worker'
                          : answer.responderName,
                      style: theme.textTheme.bodySmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      _formatTime(answer.createdAt),
                      style: TextStyle(
                        color: Colors.grey.shade500,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ),
              if (answer.isUrgentFlag)
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: Colors.red.shade600,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.warning, size: 12, color: Colors.white),
                      SizedBox(width: 3),
                      Text(
                        'SEEK CARE',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 10,
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
          const SizedBox(height: 12),

          // Answer text
          Text(
            answer.answerText,
            style: theme.textTheme.bodyMedium?.copyWith(
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  String _formatTime(DateTime? dt) {
    if (dt == null) return '';
    final now = DateTime.now();
    final diff = now.difference(dt);
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    return '${dt.day}/${dt.month}/${dt.year}';
  }
}
