import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:mch_core/mch_core.dart';
import '../../../../core/providers/child_provider.dart';

class ChildrenListScreen extends ConsumerWidget {
  const ChildrenListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch the real children data from provider
    final childrenAsync = ref.watch(patientChildrenProvider);

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text(
          'My Children',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              // Refresh children list
              ref.invalidate(patientChildrenProvider);
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          // TODO: Navigate to Add Child Form
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Add Child feature coming soon'),
              backgroundColor: Color(0xFFE91E63),
            ),
          );
        },
        backgroundColor: const Color(0xFFE91E63),
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text("Add Child", style: TextStyle(color: Colors.white)),
      ),
      body: childrenAsync.when(
        data: (children) {
          if (children.isEmpty) {
            return const _EmptyState();
          }
          return RefreshIndicator(
            onRefresh: () async {
              ref.invalidate(patientChildrenProvider);
              await ref.read(patientChildrenProvider.future);
            },
            child: ListView.builder(
              padding: const EdgeInsets.all(16.0),
              itemCount: children.length,
              itemBuilder: (context, index) {
                final child = children[index];
                return _ChildListItem(child: child);
              },
            ),
          );
        },
        loading: () => const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(color: Color(0xFFE91E63)),
              SizedBox(height: 16),
              Text('Loading children...', style: TextStyle(color: Colors.grey)),
            ],
          ),
        ),
        error: (error, stack) => Center(
          child: Padding(
            padding: const EdgeInsets.all(32.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.error_outline, size: 64, color: Colors.red[300]),
                const SizedBox(height: 16),
                Text(
                  'Failed to load children',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[800],
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  error.toString(),
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.grey[600], fontSize: 14),
                ),
                const SizedBox(height: 24),
                ElevatedButton.icon(
                  onPressed: () => ref.invalidate(patientChildrenProvider),
                  icon: const Icon(Icons.refresh),
                  label: const Text('Retry'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFE91E63),
                    foregroundColor: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// --- CHILD LIST ITEM WIDGET ---
class _ChildListItem extends StatelessWidget {
  final ChildProfile child;

  const _ChildListItem({required this.child});

  @override
  Widget build(BuildContext context) {
    final age = _calculateAge(child.dateOfBirth);
    final isMale = child.sex.toLowerCase() == 'male';
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardTheme.color ?? (isDark ? const Color(0xFF1E1E1E) : Colors.white),
        borderRadius: BorderRadius.circular(12),
        boxShadow: isDark ? null : [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: InkWell(
        onTap: () => context.push('/child/${child.id}'),
        borderRadius: BorderRadius.circular(12),
        child: IntrinsicHeight(
          child: Row(
            children: [
              // Left color strip (based on gender)
              Container(
                width: 6,
                decoration: BoxDecoration(
                  color: isMale ? Colors.blue : Colors.pink,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(12),
                    bottomLeft: Radius.circular(12),
                  ),
                ),
              ),
              
              // Main content
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      // Top Row: Avatar + Name + Gender
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CircleAvatar(
                            radius: 28,
                            backgroundColor: isMale
                                ? Colors.blue.withOpacity(0.1)
                                : Colors.pink.withOpacity(0.1),
                            child: Icon(
                              isMale ? Icons.face_6 : Icons.face_3,
                              size: 32,
                              color: isMale ? Colors.blue : Colors.pink,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  child.childName,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black87,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  "$age • ${child.sex}",
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: Colors.grey[600],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          // Birth weight chip
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.green.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              '${(child.birthWeightGrams / 1000).toStringAsFixed(1)} kg',
                              style: const TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                color: Colors.green,
                              ),
                            ),
                          ),
                        ],
                      ),
                      
                      const SizedBox(height: 16),
                      const Divider(height: 1, color: Color(0xFFEEEEEE)),
                      const SizedBox(height: 12),

                      // Bottom Row: Birth details
                      Row(
                        children: [
                          Icon(Icons.cake, size: 16, color: Colors.grey[500]),
                          const SizedBox(width: 8),
                          Text(
                            "Born: ",
                            style: TextStyle(fontSize: 13, color: Colors.grey[600]),
                          ),
                          Text(
                            DateFormat('d MMM yyyy').format(child.dateOfBirth),
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                          const Spacer(),
                          Icon(Icons.arrow_forward_ios, size: 14, color: Colors.grey[400]),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Helper for Age (Includes Weeks for infants)
  String _calculateAge(DateTime birthDate) {
    final now = DateTime.now();
    final difference = now.difference(birthDate);
    final days = difference.inDays;

    if (days < 0) return 'Not born yet';
    if (days < 30) return '$days days old';
    if (days < 120) return '${(days / 7).floor()} weeks old';
    if (days < 365) return '${(days / 30).floor()} months old';
    
    final years = (days / 365).floor();
    final remainingMonths = ((days % 365) / 30).floor();
    if (remainingMonths > 0) {
      return '$years yr ${remainingMonths} mo';
    }
    return '$years years old';
  }
}

// --- EMPTY STATE WIDGET ---
class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.pink.shade50,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.child_care,
                size: 64,
                color: Colors.pink.shade200,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'No Children Registered',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[800],
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              'Children registered at your health facility will appear here automatically. You can also add a child manually using the button below.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 14,
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
