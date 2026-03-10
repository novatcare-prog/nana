import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/providers/qa_provider.dart';

/// Screen for patients to submit a new anonymous question to health workers.
class AskQuestionScreen extends ConsumerStatefulWidget {
  const AskQuestionScreen({super.key});

  @override
  ConsumerState<AskQuestionScreen> createState() => _AskQuestionScreenState();
}

class _AskQuestionScreenState extends ConsumerState<AskQuestionScreen> {
  final _formKey = GlobalKey<FormState>();
  final _questionController = TextEditingController();
  String _selectedCategory = 'general';
  bool _isSubmitting = false;

  static const _categories = [
    {
      'value': 'general',
      'label': 'General Health',
      'icon': Icons.health_and_safety
    },
    {'value': 'pregnancy', 'label': 'Pregnancy', 'icon': Icons.pregnant_woman},
    {
      'value': 'child_health',
      'label': 'Child Health',
      'icon': Icons.child_care
    },
    {'value': 'nutrition', 'label': 'Nutrition', 'icon': Icons.restaurant},
    {
      'value': 'family_planning',
      'label': 'Family Planning',
      'icon': Icons.family_restroom
    },
    {'value': 'emergency', 'label': 'Emergency', 'icon': Icons.emergency},
  ];

  @override
  void dispose() {
    _questionController.dispose();
    super.dispose();
  }

  Future<void> _submitQuestion() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSubmitting = true);

    try {
      final submit = ref.read(submitQuestionProvider);
      await submit(_questionController.text.trim(), _selectedCategory);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Row(
              children: [
                Icon(Icons.check_circle, color: Colors.white, size: 20),
                SizedBox(width: 8),
                Text('Question submitted anonymously!'),
              ],
            ),
            backgroundColor: Colors.green.shade600,
            behavior: SnackBarBehavior.floating,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Row(
              children: [
                Icon(Icons.error_outline, color: Colors.white, size: 20),
                SizedBox(width: 12),
                Expanded(
                    child: Text(
                        'Could not submit your question. Please try again.')),
              ],
            ),
            backgroundColor: Colors.red.shade600,
            behavior: SnackBarBehavior.floating,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            margin: const EdgeInsets.all(16),
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primaryColor = theme.primaryColor;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Ask a Question'),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Anonymity Notice Card
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      primaryColor.withOpacity(0.08),
                      primaryColor.withOpacity(0.03),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: primaryColor.withOpacity(0.2),
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: primaryColor.withOpacity(0.12),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.shield_outlined,
                        color: primaryColor,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Your Identity is Protected',
                            style: theme.textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: primaryColor,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Your name and personal details will not be shared with health workers.',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: Colors.grey.shade700,
                              height: 1.4,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Category Selection
              Text(
                'Category',
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 10),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: _categories.map((cat) {
                  final isSelected = _selectedCategory == cat['value'];
                  return FilterChip(
                    selected: isSelected,
                    label: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          cat['icon'] as IconData,
                          size: 16,
                          color:
                              isSelected ? Colors.white : Colors.grey.shade700,
                        ),
                        const SizedBox(width: 6),
                        Text(cat['label'] as String),
                      ],
                    ),
                    selectedColor: cat['value'] == 'emergency'
                        ? Colors.red.shade600
                        : primaryColor,
                    checkmarkColor: Colors.white,
                    labelStyle: TextStyle(
                      color: isSelected ? Colors.white : Colors.grey.shade800,
                      fontWeight:
                          isSelected ? FontWeight.w600 : FontWeight.normal,
                    ),
                    backgroundColor: Colors.grey.shade100,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    side: BorderSide(
                      color: isSelected
                          ? Colors.transparent
                          : Colors.grey.shade300,
                    ),
                    onSelected: (_) {
                      setState(
                          () => _selectedCategory = cat['value'] as String);
                    },
                  );
                }).toList(),
              ),

              if (_selectedCategory == 'emergency') ...[
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.red.shade50,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.red.shade200),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.warning_amber,
                          color: Colors.red.shade700, size: 20),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          'If this is a life-threatening emergency, please call emergency services immediately.',
                          style: TextStyle(
                            color: Colors.red.shade800,
                            fontSize: 13,
                            height: 1.3,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],

              const SizedBox(height: 24),

              // Question Text Field
              Text(
                'Your Question',
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _questionController,
                maxLines: 6,
                maxLength: 1000,
                textCapitalization: TextCapitalization.sentences,
                decoration: InputDecoration(
                  hintText:
                      'Type your health question here...\n\nBe as specific as possible so health workers can give you the best advice.',
                  hintStyle: TextStyle(
                    color: Colors.grey.shade400,
                    fontSize: 14,
                    height: 1.5,
                  ),
                  filled: true,
                  fillColor: Colors.grey.shade50,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide(color: Colors.grey.shade300),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide(color: Colors.grey.shade300),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide(color: primaryColor, width: 1.5),
                  ),
                  contentPadding: const EdgeInsets.all(16),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter your question';
                  }
                  if (value.trim().length < 10) {
                    return 'Question is too short. Please provide more detail.';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 28),

              // Submit Button
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: _isSubmitting ? null : _submitQuestion,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    elevation: 0,
                  ),
                  child: _isSubmitting
                      ? const SizedBox(
                          width: 22,
                          height: 22,
                          child: CircularProgressIndicator(
                            strokeWidth: 2.5,
                            color: Colors.white,
                          ),
                        )
                      : const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.send_rounded, size: 20),
                            SizedBox(width: 8),
                            Text(
                              'Submit Question Anonymously',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                ),
              ),

              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
