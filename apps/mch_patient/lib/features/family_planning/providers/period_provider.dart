import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/repositories/period_repository.dart';
import '../domain/models/period_entry.dart';
import '../domain/fertility_calculator.dart';

// Repository Provider
final periodRepositoryProvider = Provider<PeriodRepository>((ref) {
  return PeriodRepository();
});

// Period Entries Provider
final periodEntriesProvider =
    StateNotifierProvider<PeriodEntriesNotifier, AsyncValue<List<PeriodEntry>>>(
        (ref) {
  return PeriodEntriesNotifier(ref.read(periodRepositoryProvider));
});

class PeriodEntriesNotifier
    extends StateNotifier<AsyncValue<List<PeriodEntry>>> {
  final PeriodRepository _repository;

  PeriodEntriesNotifier(this._repository) : super(const AsyncValue.loading()) {
    loadEntries();
  }

  Future<void> loadEntries() async {
    try {
      final entries = await _repository.getEntries();
      state = AsyncValue.data(entries);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  Future<void> addEntry(PeriodEntry entry) async {
    try {
      await _repository.saveEntry(entry);
      await loadEntries(); // Refresh list
    } catch (e) {
      // Handle error (maybe show snackbar via UI/listener)
      print('Error saving period entry: $e');
    }
  }

  Future<void> deleteEntry(String id) async {
    try {
      await _repository.deleteEntry(id);
      await loadEntries();
    } catch (e) {
      print('Error deleting period entry: $e');
    }
  }
}

// Derived Provider: Latest Period Entry (Start of current cycle)
final latestPeriodProvider = Provider<PeriodEntry?>((ref) {
  final entriesState = ref.watch(periodEntriesProvider);
  return entriesState.maybeWhen(
    data: (entries) => entries.isNotEmpty ? entries.first : null,
    orElse: () => null,
  );
});

// Derived Provider: Average Cycle Length (Simple average of last 3 cycles)
final averageCycleLengthProvider = Provider<int>((ref) {
  final entriesState = ref.watch(periodEntriesProvider);

  return entriesState.maybeWhen(
    data: (entries) {
      if (entries.length < 2) return 28; // Default

      // Calculate diff between recent start dates
      int totalDays = 0;
      int count = 0;

      // Look at last 6 months (approx 6 cycles)
      final limit = entries.length > 7 ? 7 : entries.length;

      for (int i = 0; i < limit - 1; i++) {
        final current = entries[i];
        final previous = entries[i + 1];

        final diff = current.startDate.difference(previous.startDate).inDays;

        // Filter out unreasonable outliers (e.g. missed logging periods)
        // Normal cycle 21-35 days. Allow 20-45 range.
        if (diff >= 20 && diff <= 45) {
          totalDays += diff;
          count++;
        }
      }

      if (count == 0) return 28;
      return (totalDays / count).round();
    },
    orElse: () => 28,
  );
});

// Derived Provider: Current Fertility Status
// Returns: 'safe', 'fertile', 'ovulation', 'period'
final currentFertilityStatusProvider = Provider<String>((ref) {
  final latestPeriod = ref.watch(latestPeriodProvider);
  final cycleLength = ref.watch(averageCycleLengthProvider);

  if (latestPeriod == null) return 'unknown';

  final today = DateTime.now();
  final ovulationDate = FertilityCalculator.predictOvulation(
      latestPeriod.startDate,
      cycleLength: cycleLength);

  if (FertilityCalculator.isProbablePeriodDay(today, latestPeriod.startDate,
      cycleLength: cycleLength)) {
    return 'period';
  }

  if (FertilityCalculator.isOvulationDate(today, ovulationDate)) {
    return 'ovulation';
  }

  if (FertilityCalculator.isFertileDate(today, ovulationDate)) {
    return 'fertile';
  }

  return 'safe';
});

// Derived Provider: Days until next period
final daysUntilNextPeriodProvider = Provider<int?>((ref) {
  final latestPeriod = ref.watch(latestPeriodProvider);
  final cycleLength = ref.watch(averageCycleLengthProvider);

  if (latestPeriod == null) return null;

  final nextPeriod = FertilityCalculator.predictNextPeriod(
      latestPeriod.startDate,
      cycleLength: cycleLength);
  final diff = nextPeriod.difference(DateTime.now()).inDays;

  return diff; // Can be negative if overdue
});
