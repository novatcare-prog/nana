import 'package:hive_flutter/hive_flutter.dart';
import '../../domain/models/journal_entry.dart';

class JournalRepository {
  static const String _boxName = 'journal_entries';

  Future<Box> _getBox() async {
    if (!Hive.isBoxOpen(_boxName)) {
      return await Hive.openBox(_boxName);
    }
    return Hive.box(_boxName);
  }

  Future<List<JournalEntry>> getEntries() async {
    final box = await _getBox();
    final entries = box.values.map((e) {
      if (e is Map) {
        // Convert Map<dynamic, dynamic> to Map<String, dynamic> if needed
        return JournalEntry.fromJson(Map<String, dynamic>.from(e));
      }
      return JournalEntry.fromJson(e as Map<String, dynamic>);
    }).toList();

    // Sort by date descending (newest first)
    entries.sort((a, b) => b.date.compareTo(a.date));
    return entries;
  }

  Future<void> saveEntry(JournalEntry entry) async {
    final box = await _getBox();
    await box.put(entry.id, entry.toJson());
  }

  Future<void> deleteEntry(String id) async {
    final box = await _getBox();
    await box.delete(id);
  }
}
