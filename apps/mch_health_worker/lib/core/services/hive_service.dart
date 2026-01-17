import 'package:hive_flutter/hive_flutter.dart';
import 'package:mch_core/mch_core.dart';

/// Enhanced HiveService with offline-first support
/// Maintains all existing functionality + adds new offline features
class HiveService {
  // ==================== EXISTING BOX NAMES ====================
  static const String _patientsBox = 'patients';
  static const String _labResultsBox = 'lab_results';
  static const String _immunizationsBox = 'immunizations';
  static const String _malariaBox = 'malaria_records';
  static const String _nutritionBox = 'nutrition_records';
  static const String _ancVisitsBox = 'anc_visits';
  static const String _draftsBox = 'drafts';
  static const String _syncQueueBox = 'sync_queue';
  static const String _settingsBox = 'settings';
  
  // ==================== NEW BOX NAMES (For Offline System) ====================
  static const String _appointmentsBox = 'appointments';
  static const String _facilitiesBox = 'facilities';
  static const String _childProfilesBox = 'child_profiles';
  static const String _growthRecordsBox = 'growth_records';
  static const String _metadataBox = 'metadata';
  static const String _cacheBox = 'cache';
  static const String _lastSyncBox = 'last_sync';

  /// Initialize all boxes (UPDATED - includes new boxes)
  static Future<void> initAll() async {
    // Initialize Hive for Flutter
    await Hive.initFlutter();

    // Open existing boxes
    await Hive.openBox(_patientsBox);
    await Hive.openBox(_labResultsBox);
    await Hive.openBox(_immunizationsBox);
    await Hive.openBox(_malariaBox);
    await Hive.openBox(_nutritionBox);
    await Hive.openBox(_ancVisitsBox);
    await Hive.openBox(_draftsBox);
    await Hive.openBox(_syncQueueBox);
    await Hive.openBox(_settingsBox);
    
    // Open new boxes for offline system
    await Hive.openBox(_appointmentsBox);
    await Hive.openBox(_facilitiesBox);
    await Hive.openBox(_childProfilesBox);
    await Hive.openBox(_growthRecordsBox);
    await Hive.openBox(_metadataBox);
    await Hive.openBox(_cacheBox);
    await Hive.openBox(_lastSyncBox);
    
    print('✅ All Hive boxes initialized (${_getAllBoxNames().length} boxes)');
  }

  /// Get all box names
  static List<String> _getAllBoxNames() {
    return [
      _patientsBox,
      _labResultsBox,
      _immunizationsBox,
      _malariaBox,
      _nutritionBox,
      _ancVisitsBox,
      _draftsBox,
      _syncQueueBox,
      _settingsBox,
      _appointmentsBox,
      _facilitiesBox,
      _childProfilesBox,
      _growthRecordsBox,
      _metadataBox,
      _cacheBox,
      _lastSyncBox,
    ];
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
      'retry_count': 0,  // Track failed attempts
      'max_retries': 5,  // Max retry limit
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

  /// Increment retry count for failed sync item, returns true if max retries exceeded
  static Future<bool> incrementRetryCount(String syncId) async {
    final box = Hive.box(_syncQueueBox);
    final item = box.get(syncId);
    if (item == null) return true;
    
    final data = Map<String, dynamic>.from(item);
    final retryCount = (data['retry_count'] ?? 0) + 1;
    final maxRetries = data['max_retries'] ?? 5;
    
    if (retryCount >= maxRetries) {
      // Max retries exceeded - move to dead letter queue or remove
      await box.delete(syncId);
      print('⚠️ Max retries exceeded for $syncId - removed from queue');
      return true;
    }
    
    data['retry_count'] = retryCount;
    data['last_retry'] = DateTime.now().toIso8601String();
    await box.put(syncId, data);
    return false;
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
  
  // NEW: Metadata box methods
  static Future<void> setMetadata(String key, dynamic value) async {
    final box = Hive.box(_metadataBox);
    await box.put(key, value);
  }
  
  static dynamic getMetadata(String key) {
    final box = Hive.box(_metadataBox);
    return box.get(key);
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

  // ==================== APPOINTMENTS (NEW) ====================
  
  static Future<void> cacheAppointment(String id, Map<String, dynamic> appointment) async {
    final box = Hive.box(_appointmentsBox);
    await box.put(id, appointment);
  }
  
  static Future<void> cacheAppointments(List<Map<String, dynamic>> appointments) async {
    final box = Hive.box(_appointmentsBox);
    final Map<dynamic, dynamic> entries = {
      for (var a in appointments) a['id']: a
    };
    await box.putAll(entries);
  }
  
  static Map<String, dynamic>? getCachedAppointment(String id) {
    final box = Hive.box(_appointmentsBox);
    final data = box.get(id);
    if (data == null) return null;
    return Map<String, dynamic>.from(data);
  }
  
  static List<Map<String, dynamic>> getCachedAppointments() {
    final box = Hive.box(_appointmentsBox);
    return box.values
        .map((e) => Map<String, dynamic>.from(e))
        .toList();
  }
  
  static Future<void> deleteAppointment(String id) async {
    final box = Hive.box(_appointmentsBox);
    await box.delete(id);
  }

  // ==================== FACILITIES (NEW) ====================
  
  static Future<void> cacheFacilities(List<Map<String, dynamic>> facilities) async {
    final box = Hive.box(_facilitiesBox);
    final Map<dynamic, dynamic> entries = {
      for (var f in facilities) f['id']: f
    };
    await box.putAll(entries);
  }
  
  static List<Map<String, dynamic>> getCachedFacilities() {
    final box = Hive.box(_facilitiesBox);
    return box.values
        .map((e) => Map<String, dynamic>.from(e))
        .toList();
  }

  // ==================== CHILD PROFILES (NEW) ====================
  
  static Future<void> cacheChildProfile(String id, Map<String, dynamic> profile) async {
    final box = Hive.box(_childProfilesBox);
    await box.put(id, profile);
  }
  
  static List<Map<String, dynamic>> getCachedChildProfiles(String maternalId) {
    final box = Hive.box(_childProfilesBox);
    return box.values
        .where((e) {
          final profile = Map<String, dynamic>.from(e);
          return profile['maternal_profile_id'] == maternalId;
        })
        .map((e) => Map<String, dynamic>.from(e))
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

  // ==================== STORAGE STATS (NEW) ====================
  
  /// Get storage statistics for all boxes
  static Map<String, int> getStorageStats() {
    final stats = <String, int>{};
    
    for (final boxName in _getAllBoxNames()) {
      try {
        if (Hive.isBoxOpen(boxName)) {
          stats[boxName] = Hive.box(boxName).length;
        }
      } catch (e) {
        stats[boxName] = 0;
      }
    }
    
    return stats;
  }
  
  /// Get total number of cached items
  static int getTotalCachedItems() {
    return getStorageStats().values.fold(0, (sum, count) => sum + count);
  }

  // ==================== BOX ACCESS (NEW - for offline system) ====================
  
  /// Get a box by name (for advanced use)
  static Box getBox(String boxName) {
    return Hive.box(boxName);
  }
  
  /// Check if a box is open
  static bool isBoxOpen(String boxName) {
    return Hive.isBoxOpen(boxName);
  }

  // ==================== CLEAR ALL ====================
  
  static Future<void> clearAllCache() async {
    // Clear existing boxes
    await Hive.box(_patientsBox).clear();
    await Hive.box(_labResultsBox).clear();
    await Hive.box(_immunizationsBox).clear();
    await Hive.box(_malariaBox).clear();
    await Hive.box(_nutritionBox).clear();
    await Hive.box(_ancVisitsBox).clear();
    await Hive.box(_draftsBox).clear();
    await Hive.box(_syncQueueBox).clear();
    await Hive.box(_settingsBox).clear();
    
    // Clear new boxes
    await Hive.box(_appointmentsBox).clear();
    await Hive.box(_facilitiesBox).clear();
    await Hive.box(_childProfilesBox).clear();
    await Hive.box(_growthRecordsBox).clear();
    await Hive.box(_metadataBox).clear();
    await Hive.box(_cacheBox).clear();
    await Hive.box(_lastSyncBox).clear();
    
    print('⚠️ All cache cleared');
  }
  
  /// Clear only appointment cache (useful for testing)
  static Future<void> clearAppointmentCache() async {
    await Hive.box(_appointmentsBox).clear();
    print('⚠️ Appointment cache cleared');
  }

  // ==================== CLOSE ALL (NEW) ====================
  
  /// Close all Hive boxes (call on app termination)
  static Future<void> closeAll() async {
    await Hive.close();
    print('✅ All Hive boxes closed');
  }
}