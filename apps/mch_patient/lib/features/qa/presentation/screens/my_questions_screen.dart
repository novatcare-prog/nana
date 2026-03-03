import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mch_core/mch_core.dart';
import '../../../../core/providers/qa_provider.dart';

/// Screen showing the patient's own questions list.
class MyQuestionsScreen extends ConsumerWidget {
  const MyQuestionsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final questionsAsync = ref.watch(myQuestionsProvider);
    final theme = Theme.of(context);
    final primaryColor = theme.primaryColor;

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Questions'),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => ref.invalidate(myQuestionsProvider),
            tooltip: 'Refresh',
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push('/qa/ask'),
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add),
        label: const Text('Ask Question'),
      ),
      body: questionsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.error_outline, size: 48, color: Colors.red.shade300),
                const SizedBox(height: 16),
                Text('Error loading questions',
                    style: theme.textTheme.titleMedium),
                const SizedBox(height: 8),
                Text('$error', textAlign: TextAlign.center),
                const SizedBox(height: 16),
                OutlinedButton(
                  onPressed: () => ref.invalidate(myQuestionsProvider),
                  child: const Text('Retry'),
                ),
              ],
            ),
          ),
        ),
        data: (questions) {
          if (questions.isEmpty) {
            return _buildEmptyState(context, primaryColor);
          }
          return RefreshIndicator(
            onRefresh: () async => ref.invalidate(myQuestionsProvider),
            child: ListView.builder(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 80),
              itemCount: questions.length,
              itemBuilder: (context, index) {
                final question = questions[index];
                return _QuestionCard(question: question);
              },
            ),
          );
        },
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context, Color primaryColor) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: primaryColor.withOpacity(0.08),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.question_answer_outlined,
                size: 56,
                color: primaryColor.withOpacity(0.6),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'No Questions Yet',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 10),
            Text(
              'Ask health workers any health-related question.\nYour identity stays private.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.grey.shade600,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 28),
            ElevatedButton.icon(
              onPressed: () => context.push('/qa/ask'),
              icon: const Icon(Icons.add),
              label: const Text('Ask Your First Question'),
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryColor,
                foregroundColor: Colors.white,
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Individual question card widget.
class _QuestionCard extends StatelessWidget {
  final HealthQuestion question;

  const _QuestionCard({required this.question});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primaryColor = theme.primaryColor;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
        side: BorderSide(
          color: question.isUrgent ? Colors.red.shade200 : Colors.grey.shade200,
        ),
      ),
      child: InkWell(
        onTap: () => context.push('/qa/view/${question.id}'),
        borderRadius: BorderRadius.circular(14),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header: Category + Status
              Row(
                children: [
                  _CategoryBadge(category: question.category),
                  const Spacer(),
                  _StatusBadge(
                    status: question.status,
                    isUrgent: question.isUrgent,
                  ),
                ],
              ),

              const SizedBox(height: 12),

              // Question text
              Text(
                question.questionText,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.bodyMedium?.copyWith(
                  height: 1.4,
                ),
              ),

              // Urgent banner
              if (question.isUrgent) ...[
                const SizedBox(height: 12),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.red.shade50,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.red.shade200),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.warning_amber,
                          color: Colors.red.shade700, size: 18),
                      const SizedBox(width: 8),
                      Text(
                        'Health worker advises seeking care',
                        style: TextStyle(
                          color: Colors.red.shade800,
                          fontWeight: FontWeight.w600,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
              ],

              const SizedBox(height: 12),

              // Footer: Time
              Row(
                children: [
                  Icon(Icons.access_time,
                      size: 14, color: Colors.grey.shade500),
                  const SizedBox(width: 4),
                  Text(
                    _formatTime(question.createdAt),
                    style: TextStyle(
                      color: Colors.grey.shade500,
                      fontSize: 12,
                    ),
                  ),
                  const Spacer(),
                  Icon(Icons.chevron_right,
                      color: primaryColor.withOpacity(0.5), size: 20),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatTime(DateTime? dateTime) {
    if (dateTime == null) return '';
    final now = DateTime.now();
    final diff = now.difference(dateTime);

    if (diff.inMinutes < 1) return 'Just now';
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    if (diff.inDays < 7) return '${diff.inDays}d ago';
    return '${dateTime.day}/${dateTime.month}/${dateTime.year}';
  }
}

/// Category badge chip
class _CategoryBadge extends StatelessWidget {
  final String category;

  const _CategoryBadge({required this.category});

  @override
  Widget build(BuildContext context) {
    final config = _getCategoryConfig(category);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: config.color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(config.icon, size: 14, color: config.color),
          const SizedBox(width: 4),
          Text(
            config.label,
            style: TextStyle(
              color: config.color,
              fontWeight: FontWeight.w600,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  _CategoryConfig _getCategoryConfig(String category) {
    switch (category) {
      case 'pregnancy':
        return _CategoryConfig(
            'Pregnancy', Icons.pregnant_woman, Colors.purple);
      case 'child_health':
        return _CategoryConfig('Child Health', Icons.child_care, Colors.blue);
      case 'nutrition':
        return _CategoryConfig('Nutrition', Icons.restaurant, Colors.orange);
      case 'family_planning':
        return _CategoryConfig(
            'Family Planning', Icons.family_restroom, Colors.teal);
      case 'emergency':
        return _CategoryConfig('Emergency', Icons.emergency, Colors.red);
      default:
        return _CategoryConfig(
            'General', Icons.health_and_safety, Colors.green);
    }
  }
}

class _CategoryConfig {
  final String label;
  final IconData icon;
  final Color color;

  _CategoryConfig(this.label, this.icon, this.color);
}

/// Status badge
class _StatusBadge extends StatelessWidget {
  final String status;
  final bool isUrgent;

  const _StatusBadge({required this.status, required this.isUrgent});

  @override
  Widget build(BuildContext context) {
    if (isUrgent) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
        decoration: BoxDecoration(
          color: Colors.red.shade600,
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.priority_high, size: 12, color: Colors.white),
            SizedBox(width: 2),
            Text(
              'URGENT',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 10,
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
      );
    }

    Color bgColor;
    Color textColor;
    String label;

    switch (status) {
      case 'answered':
        bgColor = Colors.green.shade50;
        textColor = Colors.green.shade700;
        label = 'Answered';
        break;
      case 'closed':
        bgColor = Colors.grey.shade100;
        textColor = Colors.grey.shade600;
        label = 'Closed';
        break;
      default:
        bgColor = Colors.amber.shade50;
        textColor = Colors.amber.shade800;
        label = 'Awaiting Response';
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: textColor,
          fontWeight: FontWeight.w600,
          fontSize: 11,
        ),
      ),
    );
  }
}
