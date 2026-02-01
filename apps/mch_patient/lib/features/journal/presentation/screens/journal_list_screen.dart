import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../providers/journal_provider.dart';
import '../../domain/models/journal_entry.dart';
import '../../../../core/utils/error_helper.dart';

class JournalListScreen extends ConsumerWidget {
  const JournalListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final entriesAsync = ref.watch(journalEntriesProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Journal'),
        elevation: 0,
      ),
      body: entriesAsync.when(
        data: (entries) {
          if (entries.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: Colors.pink.shade50,
                      shape: BoxShape.circle,
                    ),
                    child:
                        Icon(Icons.book, size: 48, color: Colors.pink.shade200),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Your journal is empty',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  const Text('Start documenting your pregnancy journey today!'),
                ],
              ),
            );
          }
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: entries.length,
            itemBuilder: (context, index) {
              final entry = entries[index];
              return _JournalEntryCard(entry: entry);
            },
          );
        },
        loading: () => const Center(
            child: CircularProgressIndicator(color: Color(0xFFE91E63))),
        error: (e, _) => ErrorHelper.buildErrorWidget(e,
            onRetry: () => ref.invalidate(journalEntriesProvider)),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push('/journal/add'),
        label: const Text('New Entry', style: TextStyle(color: Colors.white)),
        icon: const Icon(Icons.edit, color: Colors.white),
        backgroundColor: const Color(0xFFE91E63),
      ),
    );
  }
}

class _JournalEntryCard extends StatelessWidget {
  final JournalEntry entry;

  const _JournalEntryCard({required this.entry});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      child: InkWell(
        onTap: () => context.push('/journal/edit/${entry.id}', extra: entry),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    DateFormat('EEEE, MMMM d, y').format(entry.date),
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  if (entry.category != null)
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: const Color(0xFFE91E63).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        entry.category!,
                        style: const TextStyle(
                          fontSize: 10,
                          color: Color(0xFFE91E63),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                entry.title,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                entry.content,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontSize: 14, color: Colors.grey[800]),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
