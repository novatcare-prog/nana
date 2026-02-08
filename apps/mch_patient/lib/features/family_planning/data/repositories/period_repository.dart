import 'package:hive_flutter/hive_flutter.dart';
import '../../domain/models/period_entry.dart';

class PeriodRepository {
  static const String _boxName = 'period_entries';

  Future<Box> _getBox() async {
    if (!Hive.isBoxOpen(_boxName)) {
      return await Hive.openBox(_boxName);
    }
    return Hive.box(_boxName);
  }

  Future<List<PeriodEntry>> getEntries() async {
    final box = await _getBox();
    final entries = box.values.map((e) {
      if (e is Map) {
        return PeriodEntry.fromJson(Map<String, dynamic>.from(e));
      }
      return PeriodEntry.fromJson(e as Map<String, dynamic>);
    }).toList();

    // Sort by start date descending (newest first)
    entries.sort((a, b) => b.startDate.compareTo(a.startDate));
    return entries;
  }

  Future<void> saveEntry(PeriodEntry entry) async {
    final box = await _getBox();
    await box.put(entry.id, entry.toJson());
  }

  Future<void> deleteEntry(String id) async {
    final box = await _getBox();
    await box.delete(id);
  }
}
