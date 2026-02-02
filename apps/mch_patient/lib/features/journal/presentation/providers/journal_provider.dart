import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/models/journal_entry.dart';
import '../../data/repositories/journal_repository.dart';

final journalRepositoryProvider = Provider((ref) => JournalRepository());

final journalEntriesProvider = FutureProvider<List<JournalEntry>>((ref) async {
  final repository = ref.watch(journalRepositoryProvider);
  return repository.getEntries();
});

/// Provider for a single journal entry by ID
final journalEntryProvider =
    FutureProvider.family<JournalEntry?, String>((ref, id) async {
  final entries = await ref.watch(journalEntriesProvider.future);
  try {
    return entries.firstWhere((e) => e.id == id);
  } catch (_) {
    return null;
  }
});

/// Filter entries by category
final journalEntriesByCategoryProvider =
    Provider.family<AsyncValue<List<JournalEntry>>, String?>((ref, category) {
  final entriesAsync = ref.watch(journalEntriesProvider);
  return entriesAsync.whenData((entries) {
    if (category == null || category.isEmpty) return entries;
    return entries.where((e) => e.category == category).toList();
  });
});

/// Get entry count by mood
final journalMoodStatsProvider =
    Provider<AsyncValue<Map<JournalMood, int>>>((ref) {
  final entriesAsync = ref.watch(journalEntriesProvider);
  return entriesAsync.whenData((entries) {
    final stats = <JournalMood, int>{};
    for (final entry in entries) {
      if (entry.mood != null) {
        stats[entry.mood!] = (stats[entry.mood!] ?? 0) + 1;
      }
    }
    return stats;
  });
});

class JournalController extends StateNotifier<AsyncValue<void>> {
  final JournalRepository _repository;
  final Ref _ref;

  JournalController(this._repository, this._ref) : super(const AsyncData(null));

  Future<bool> addEntry({
    required String title,
    required String content,
    String? category,
    JournalMood? mood,
    DateTime? date,
  }) async {
    state = const AsyncLoading();
    try {
      final entry = JournalEntry.create(
        title: title,
        content: content,
        category: category,
        mood: mood,
        date: date,
      );
      await _repository.saveEntry(entry);
      state = const AsyncData(null);
      // Refresh list
      _ref.invalidate(journalEntriesProvider);
      return true;
    } catch (e) {
      state = AsyncError(e, StackTrace.current);
      return false;
    }
  }

  Future<bool> updateEntry(JournalEntry entry) async {
    state = const AsyncLoading();
    try {
      await _repository.saveEntry(entry);
      state = const AsyncData(null);
      _ref.invalidate(journalEntriesProvider);
      return true;
    } catch (e) {
      state = AsyncError(e, StackTrace.current);
      return false;
    }
  }

  Future<bool> deleteEntry(String id) async {
    state = const AsyncLoading();
    try {
      await _repository.deleteEntry(id);
      state = const AsyncData(null);
      _ref.invalidate(journalEntriesProvider);
      return true;
    } catch (e) {
      state = AsyncError(e, StackTrace.current);
      return false;
    }
  }
}

final journalControllerProvider =
    StateNotifierProvider<JournalController, AsyncValue<void>>((ref) {
  final repository = ref.watch(journalRepositoryProvider);
  return JournalController(repository, ref);
});
