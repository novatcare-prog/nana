import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mch_core/mch_core.dart';
import '../../../../core/providers/qa_provider.dart';
import 'answer_question_screen.dart';

/// Feed of anonymous patient questions for health workers.
class QuestionsFeedScreen extends ConsumerStatefulWidget {
  final Widget? drawer;

  const QuestionsFeedScreen({super.key, this.drawer});

  @override
  ConsumerState<QuestionsFeedScreen> createState() =>
      _QuestionsFeedScreenState();
}

class _QuestionsFeedScreenState extends ConsumerState<QuestionsFeedScreen> {
  String _filterCategory = 'all';
  bool _showAll = false; // false = open only, true = all

  @override
  Widget build(BuildContext context) {
    final questionsAsync = _showAll
        ? ref.watch(allQuestionsProvider)
        : ref.watch(openQuestionsProvider);
    final theme = Theme.of(context);

    return Scaffold(
      drawer: widget.drawer,
      appBar: AppBar(
        title: const Text('Patient Questions'),
        elevation: 0,
        actions: [
          // Toggle open/all
          TextButton.icon(
            onPressed: () => setState(() => _showAll = !_showAll),
            icon: Icon(
              _showAll ? Icons.filter_list_off : Icons.filter_list,
              size: 18,
            ),
            label: Text(_showAll ? 'All' : 'Open'),
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              ref.invalidate(openQuestionsProvider);
              ref.invalidate(allQuestionsProvider);
            },
            tooltip: 'Refresh',
          ),
        ],
      ),
      body: Column(
        children: [
          // Category filter chips
          _buildCategoryFilters(theme),

          // Questions list
          Expanded(
            child: questionsAsync.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, _) => Center(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.error_outline,
                          size: 48, color: Colors.red.shade300),
                      const SizedBox(height: 16),
                      const Text('Could not load questions. Please try again.',
                          textAlign: TextAlign.center),
                      const SizedBox(height: 16),
                      OutlinedButton(
                        onPressed: () {
                          ref.invalidate(openQuestionsProvider);
                          ref.invalidate(allQuestionsProvider);
                        },
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                ),
              ),
              data: (questions) {
                // Apply category filter
                final filtered = _filterCategory == 'all'
                    ? questions
                    : questions
                        .where((q) => q.category == _filterCategory)
                        .toList();

                if (filtered.isEmpty) {
                  return _buildEmptyState(theme);
                }

                return RefreshIndicator(
                  onRefresh: () async {
                    ref.invalidate(openQuestionsProvider);
                    ref.invalidate(allQuestionsProvider);
                  },
                  child: ListView.builder(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                    itemCount: filtered.length,
                    itemBuilder: (context, index) {
                      return _QuestionFeedCard(
                        question: filtered[index],
                        onTap: () => _openQuestion(filtered[index]),
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryFilters(ThemeData theme) {
    final categories = [
      {'value': 'all', 'label': 'All', 'icon': Icons.list},
      {'value': 'emergency', 'label': 'Emergency', 'icon': Icons.emergency},
      {
        'value': 'pregnancy',
        'label': 'Pregnancy',
        'icon': Icons.pregnant_woman
      },
      {'value': 'child_health', 'label': 'Child', 'icon': Icons.child_care},
      {'value': 'nutrition', 'label': 'Nutrition', 'icon': Icons.restaurant},
      {
        'value': 'family_planning',
        'label': 'FP',
        'icon': Icons.family_restroom
      },
      {'value': 'general', 'label': 'General', 'icon': Icons.health_and_safety},
    ];

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: theme.scaffoldBackgroundColor,
        border: Border(
          bottom: BorderSide(color: Colors.grey.shade200),
        ),
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          children: categories.map((cat) {
            final isSelected = _filterCategory == cat['value'];
            final isEmergency = cat['value'] == 'emergency';

            return Padding(
              padding: const EdgeInsets.only(right: 8),
              child: FilterChip(
                selected: isSelected,
                label: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      cat['icon'] as IconData,
                      size: 14,
                      color: isSelected
                          ? Colors.white
                          : (isEmergency ? Colors.red : Colors.grey.shade700),
                    ),
                    const SizedBox(width: 4),
                    Text(cat['label'] as String),
                  ],
                ),
                selectedColor:
                    isEmergency ? Colors.red.shade600 : theme.primaryColor,
                checkmarkColor: Colors.white,
                labelStyle: TextStyle(
                  color: isSelected ? Colors.white : Colors.grey.shade800,
                  fontSize: 12,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                ),
                backgroundColor: Colors.grey.shade100,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                side: BorderSide(
                  color: isSelected ? Colors.transparent : Colors.grey.shade300,
                ),
                onSelected: (_) {
                  setState(() => _filterCategory = cat['value'] as String);
                },
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildEmptyState(ThemeData theme) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: theme.primaryColor.withOpacity(0.08),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.check_circle_outline,
                size: 56,
                color: theme.primaryColor.withOpacity(0.5),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              _filterCategory == 'all'
                  ? 'No Questions'
                  : 'No Questions in This Category',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              _showAll
                  ? 'No patient questions have been submitted yet.'
                  : 'All patient questions have been answered!',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.grey.shade600,
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _openQuestion(HealthQuestion question) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AnswerQuestionScreen(question: question),
      ),
    );
  }
}

/// Card widget for an anonymous question in the feed.
class _QuestionFeedCard extends StatelessWidget {
  final HealthQuestion question;
  final VoidCallback onTap;

  const _QuestionFeedCard({
    required this.question,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: question.isUrgent ? 2 : 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
        side: BorderSide(
          color: question.isUrgent
              ? Colors.red.shade300
              : (question.category == 'emergency'
                  ? Colors.orange.shade200
                  : Colors.grey.shade200),
          width: question.isUrgent ? 1.5 : 1,
        ),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top row: Anonymous + Category + Status
              Row(
                children: [
                  // Anonymous avatar
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.person_outline,
                      size: 16,
                      color: Colors.grey.shade500,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Anonymous Patient',
                    style: TextStyle(
                      color: Colors.grey.shade600,
                      fontWeight: FontWeight.w500,
                      fontSize: 13,
                    ),
                  ),
                  const Spacer(),
                  _buildCategoryBadge(question.category),
                ],
              ),

              const SizedBox(height: 12),

              // Question text
              Text(
                question.questionText,
                maxLines: 4,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.bodyMedium?.copyWith(
                  height: 1.5,
                ),
              ),

              // Urgent indicator
              if (question.isUrgent) ...[
                const SizedBox(height: 12),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.red.shade50,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.red.shade200),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.warning_amber,
                          color: Colors.red.shade700, size: 16),
                      const SizedBox(width: 6),
                      Text(
                        'Flagged as Urgent',
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

              // Footer
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
                  _buildStatusIndicator(question.status),
                  const SizedBox(width: 8),
                  Icon(Icons.arrow_forward_ios,
                      size: 14, color: theme.primaryColor.withOpacity(0.5)),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryBadge(String category) {
    Color color;
    String label;
    IconData icon;

    switch (category) {
      case 'pregnancy':
        color = Colors.purple;
        label = 'Pregnancy';
        icon = Icons.pregnant_woman;
        break;
      case 'child_health':
        color = Colors.blue;
        label = 'Child Health';
        icon = Icons.child_care;
        break;
      case 'nutrition':
        color = Colors.orange;
        label = 'Nutrition';
        icon = Icons.restaurant;
        break;
      case 'family_planning':
        color = Colors.teal;
        label = 'Family Planning';
        icon = Icons.family_restroom;
        break;
      case 'emergency':
        color = Colors.red;
        label = 'Emergency';
        icon = Icons.emergency;
        break;
      default:
        color = Colors.green;
        label = 'General';
        icon = Icons.health_and_safety;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: color),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.w600,
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusIndicator(String status) {
    Color color;
    String label;

    switch (status) {
      case 'answered':
        color = Colors.green;
        label = 'Answered';
        break;
      case 'closed':
        color = Colors.grey;
        label = 'Closed';
        break;
      default:
        color = Colors.amber.shade700;
        label = 'Open';
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 4),
        Text(
          label,
          style: TextStyle(
            color: color,
            fontWeight: FontWeight.w600,
            fontSize: 12,
          ),
        ),
      ],
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
