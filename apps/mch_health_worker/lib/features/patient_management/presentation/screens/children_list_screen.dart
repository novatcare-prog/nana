import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mch_core/mch_core.dart';
import '../../../../core/providers/childbirth_providers.dart';
import 'child_detail_screen.dart';

/// Children List Screen
/// Shows all children of a mother
class ChildrenListScreen extends ConsumerWidget {
  final String maternalProfileId;
  final MaternalProfile mother;

  const ChildrenListScreen({
    super.key,
    required this.maternalProfileId,
    required this.mother,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final childrenAsync = ref.watch(motherChildrenProvider(maternalProfileId));

    return Scaffold(
      appBar: AppBar(
        title: Text('${mother.clientName}\'s Children'),
      ),
      body: childrenAsync.when(
        data: (children) {
          if (children.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.child_care, size: 64, color: Colors.grey[400]),
                  const SizedBox(height: 16),
                  Text(
                    'No Children Recorded',
                    style: TextStyle(fontSize: 18, color: Colors.grey[600]),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Children will appear here after delivery is recorded',
                    style: TextStyle(color: Colors.grey[600]),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: children.length,
            itemBuilder: (context, index) {
              final child = children[index];
              return _buildChildCard(context, child);
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 64, color: Colors.red),
              const SizedBox(height: 16),
              Text('Error loading children: $error'),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildChildCard(BuildContext context, ChildProfile child) {
    final age = _calculateAge(child.dateOfBirth);
    final ageColor = age.months < 60 ? Colors.green : Colors.blue;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
             builder: (context) => ChildDetailScreen(
          child: child,
        )
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Name and Sex
              Row(
                children: [
                  CircleAvatar(
                    backgroundColor: child.sex == 'Male' ? Colors.blue : Colors.pink,
                    child: Icon(
                      child.sex == 'Male' ? Icons.boy : Icons.girl,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          child.childName,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          child.sex,
                          style: TextStyle(
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Icon(Icons.chevron_right, color: Colors.grey[400]),
                ],
              ),
              const SizedBox(height: 12),
              const Divider(),
              const SizedBox(height: 8),

              // Age
              Row(
                children: [
                  Icon(Icons.cake, size: 20, color: ageColor),
                  const SizedBox(width: 8),
                  Text(
                    'Age: ${_formatAge(age)}',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[700],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),

              // Date of Birth
              Row(
                children: [
                  Icon(Icons.calendar_today, size: 20, color: Colors.grey[600]),
                  const SizedBox(width: 8),
                  Text(
                    'Born: ${_formatDate(child.dateOfBirth)}',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[700],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),

              // Birth Details
              Row(
                children: [
                  _buildInfoChip(
                    '${child.birthWeightGrams.toStringAsFixed(0)}g',
                    Colors.blue,
                  ),
                  const SizedBox(width: 8),
                  _buildInfoChip(
                    '${child.birthLengthCm.toStringAsFixed(1)}cm',
                    Colors.green,
                  ),
                  const SizedBox(width: 8),
                  _buildInfoChip(
                    child.placeOfBirth,
                    Colors.orange,
                  ),
                ],
              ),

              // Special Indicators
              if (child.hivExposed == true || child.birthWeightLessThan2500g == true) ...[
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    if (child.hivExposed == true)
                      _buildAlertChip('HIV Exposed', Colors.red),
                    if (child.birthWeightLessThan2500g == true)
                      _buildAlertChip('Low Birth Weight', Colors.orange),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoChip(String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 12,
          color: color,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildAlertChip(String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.warning_amber, size: 14, color: color),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: color,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  ({int years, int months, int days}) _calculateAge(DateTime birthDate) {
    final now = DateTime.now();
    int years = now.year - birthDate.year;
    int months = now.month - birthDate.month;
    int days = now.day - birthDate.day;

    if (days < 0) {
      months--;
      days += DateTime(now.year, now.month, 0).day;
    }
    if (months < 0) {
      years--;
      months += 12;
    }

    return (years: years, months: months, days: days);
  }

  String _formatAge(({int years, int months, int days}) age) {
    if (age.years > 0) {
      return '${age.years}y ${age.months}m';
    } else if (age.months > 0) {
      return '${age.months} months';
    } else {
      return '${age.days} days';
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}