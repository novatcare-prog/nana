import 'package:hive_flutter/hive_flutter.dart';
import 'package:mch_core/mch_core.dart';

class HiveService {
  // Box names
  static const String _patientsBox = 'patients';
  static const String _labResultsBox = 'lab_results';
  static const String _immunizationsBox = 'immunizations';
  static const String _malariaBox = 'malaria_records';
  static const String _nutritionBox = 'nutrition_records';
  static const String _ancVisitsBox = 'anc_visits';
  static const String _draftsBox = 'drafts';
  static const String _syncQueueBox = 'sync_queue';
  static const String _settingsBox = 'settings'; 

  /// Initialize all boxes
  static Future<void> initAll() async {
    // ✅ FIX: Initialize Hive for Flutter (finds the correct directory)
    await Hive.initFlutter();

    // Now open the boxes
    await Hive.openBox(_patientsBox);
    await Hive.openBox(_labResultsBox);
    await Hive.openBox(_immunizationsBox);
    await Hive.openBox(_malariaBox);
    await Hive.openBox(_nutritionBox);
    await Hive.openBox(_ancVisitsBox);
    await Hive.openBox(_draftsBox);
    await Hive.openBox(_syncQueueBox);
    await Hive.openBox(_settingsBox);
  }

  // ==================== PATIENTS (MaternalProfile) ====================

  static Future<void> cachePatient(MaternalProfile patient) async {
    final box = Hive.box(_patientsBox);
    await box.put(patient.id, patient.toJson());
  }

  static Future<void> cachePatients(List<MaternalProfile> patients) async {
    final box = Hive.box(_patientsBox);
    final Map<dynamic, dynamic> entries = {
      for (var p in patients) p.id: p.toJson()
    };
    await box.putAll(entries);
  }

  static MaternalProfile? getCachedPatient(String id) {
    final box = Hive.box(_patientsBox);
    final data = box.get(id);
    
    if (data == null) return null;
    return MaternalProfile.fromJson(Map<String, dynamic>.from(data));
  }

  static List<MaternalProfile> getCachedPatients() {
    final box = Hive.box(_patientsBox);
    return box.values
        .map((e) => MaternalProfile.fromJson(Map<String, dynamic>.from(e)))
        .toList();
  }

  // ==================== SYNC QUEUE (Required by Repository) ====================

  static Future<void> addToSyncQueue({
    required String operation,
    required String table,
    required Map<String, dynamic> data,
  }) async {
    final box = Hive.box(_syncQueueBox);
    final syncId = '${table}_${operation}_${DateTime.now().millisecondsSinceEpoch}';
    
    await box.put(syncId, {
      'id': syncId,
      'operation': operation,
      'table': table,
      'data': data,
      'created_at': DateTime.now().toIso8601String(),
    });
  }

  static List<Map<String, dynamic>> getSyncQueue() {
    final box = Hive.box(_syncQueueBox);
    final List<Map<String, dynamic>> items = [];
    
    for (final key in box.keys) {
      try {
        final json = box.get(key) as Map<dynamic, dynamic>;
        items.add(Map<String, dynamic>.from(json));
      } catch (e) {
        print('Error loading sync item: $e');
      }
    }
    return items;
  }

  static Future<void> removeFromSyncQueue(String syncId) async {
    final box = Hive.box(_syncQueueBox);
    await box.delete(syncId);
  }

  static int getSyncQueueCount() {
    return Hive.box(_syncQueueBox).length;
  }

  // ==================== SETTINGS / METADATA ====================

  static Future<void> setLastSyncTime(DateTime time) async {
    final box = Hive.box(_settingsBox);
    await box.put('last_sync_time', time.toIso8601String());
  }

  static DateTime? getLastSyncTime() {
    final box = Hive.box(_settingsBox);
    final timeStr = box.get('last_sync_time');
    if (timeStr != null) {
      return DateTime.tryParse(timeStr);
    }
    return null;
  }

  // ==================== LAB RESULTS ====================
  
  static Future<void> cacheLabResults(String patientId, List<LabResult> results) async {
    final box = Hive.box(_labResultsBox);
    await box.put(patientId, results.map((r) => r.toJson()).toList());
  }

  static List<LabResult> getCachedLabResults(String patientId) {
    final box = Hive.box(_labResultsBox);
    final data = box.get(patientId);
    if (data == null) return [];
    
    return (data as List)
        .map((json) => LabResult.fromJson(Map<String, dynamic>.from(json)))
        .toList();
  }

  // ==================== IMMUNIZATIONS ====================
  
  static Future<void> cacheImmunizations(String patientId, List<MaternalImmunization> immunizations) async {
    final box = Hive.box(_immunizationsBox);
    await box.put(patientId, immunizations.map((i) => i.toJson()).toList());
  }

  static List<MaternalImmunization> getCachedImmunizations(String patientId) {
    final box = Hive.box(_immunizationsBox);
    final data = box.get(patientId);
    if (data == null) return [];
    
    return (data as List)
        .map((json) => MaternalImmunization.fromJson(Map<String, dynamic>.from(json)))
        .toList();
  }

  // ==================== MALARIA PREVENTION ====================
  
  static Future<void> cacheMalariaRecords(String patientId, List<MalariaPreventionRecord> records) async {
    final box = Hive.box(_malariaBox);
    await box.put(patientId, records.map((r) => r.toJson()).toList());
  }

  static List<MalariaPreventionRecord> getCachedMalariaRecords(String patientId) {
    final box = Hive.box(_malariaBox);
    final data = box.get(patientId);
    if (data == null) return [];
    
    return (data as List)
        .map((json) => MalariaPreventionRecord.fromJson(Map<String, dynamic>.from(json)))
        .toList();
  }

  // ==================== NUTRITION ====================
  
  static Future<void> cacheNutritionRecords(String patientId, List<NutritionRecord> records) async {
    final box = Hive.box(_nutritionBox);
    await box.put(patientId, records.map((r) => r.toJson()).toList());
  }

  static List<NutritionRecord> getCachedNutritionRecords(String patientId) {
    final box = Hive.box(_nutritionBox);
    final data = box.get(patientId);
    if (data == null) return [];
    
    return (data as List)
        .map((json) => NutritionRecord.fromJson(Map<String, dynamic>.from(json)))
        .toList();
  }

  // ==================== ANC VISITS ====================
  
  static Future<void> cacheANCVisits(String patientId, List<ANCVisit> visits) async {
    final box = Hive.box(_ancVisitsBox);
    await box.put(patientId, visits.map((v) => v.toJson()).toList());
  }

  static List<ANCVisit> getCachedANCVisits(String patientId) {
    final box = Hive.box(_ancVisitsBox);
    final data = box.get(patientId);
    if (data == null) return [];
    
    return (data as List)
        .map((json) => ANCVisit.fromJson(Map<String, dynamic>.from(json)))
        .toList();
  }

  // ==================== DRAFTS ====================
  
  static Future<String> saveDraft({
    required String type,
    required String patientId,
    required Map<String, dynamic> data,
  }) async {
    final box = Hive.box(_draftsBox);
    final draftId = '${type}_${patientId}_${DateTime.now().millisecondsSinceEpoch}';
    
    await box.put(draftId, {
      'id': draftId,
      'type': type,
      'patient_id': patientId,
      'data': data,
      'created_at': DateTime.now().toIso8601String(),
    });
    
    return draftId;
  }

  static List<Map<String, dynamic>> getAllDrafts() {
    final box = Hive.box(_draftsBox);
    final List<Map<String, dynamic>> drafts = [];
    
    for (final key in box.keys) {
      try {
        final json = box.get(key) as Map<dynamic, dynamic>;
        drafts.add(Map<String, dynamic>.from(json));
      } catch (e) {
        print('Error loading draft: $e');
      }
    }
    
    return drafts;
  }

  static Future<void> deleteDraft(String draftId) async {
    final box = Hive.box(_draftsBox);
    await box.delete(draftId);
  }

  // ==================== CLEAR ALL ====================
  
  static Future<void> clearAllCache() async {
    await Hive.box(_patientsBox).clear();
    await Hive.box(_labResultsBox).clear();
    await Hive.box(_immunizationsBox).clear();
    await Hive.box(_malariaBox).clear();
    await Hive.box(_nutritionBox).clear();
    await Hive.box(_ancVisitsBox).clear();
    await Hive.box(_draftsBox).clear();
    await Hive.box(_syncQueueBox).clear();
    await Hive.box(_settingsBox).clear();
  }
}