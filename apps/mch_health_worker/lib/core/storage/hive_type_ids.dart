// File: apps/mch_health_worker/lib/core/storage/hive_type_ids.dart

/// Hive Type IDs for all adapters
/// IMPORTANT: These IDs must be unique and never changed once assigned
/// Range: 0-223 are reserved by Hive, we use 224+

class HiveTypeIds {
  // User & Auth (224-229)
  static const int userProfile = 224;
  static const int userRole = 225;
  
  // Maternal Health (230-239)
  static const int maternalProfile = 230;
  static const int ancVisit = 231;
  static const int maternalImmunization = 232;
  static const int malariaPrevention = 233;
  static const int nutritionTracking = 234;
  static const int childbirthRecord = 235;
  static const int postnatalVisit = 236;
  
  // Child Health (240-249)
  static const int childProfile = 240;
  static const int growthRecord = 241;
  static const int childImmunization = 242;
  static const int vitaminA = 243;
  static const int deworming = 244;
  static const int developmentalMilestone = 245;
  
  // Clinical (250-259)
  static const int labResult = 246;
  static const int appointment = 247;
  static const int facility = 248;
  
  // Enums (260-279)
  static const int appointmentStatus = 260;
  static const int appointmentType = 261;
  static const int bloodGroup = 262;
  static const int deliveryMode = 263;
  static const int visitType = 264;
  
  // Sync Management (280-289)
  static const int syncQueueItem = 280;
  static const int syncOperation = 281;
}

/// Box names for Hive storage
class HiveBoxNames {
  // Main data boxes
  static const String users = 'users';
  static const String maternalProfiles = 'maternal_profiles';
  static const String ancVisits = 'anc_visits';
  static const String childProfiles = 'child_profiles';
  static const String appointments = 'appointments';
  static const String facilities = 'facilities';
  static const String growthRecords = 'growth_records';
  static const String immunizations = 'immunizations';
  static const String labResults = 'lab_results';
  
  // Sync & metadata boxes
  static const String syncQueue = 'sync_queue';
  static const String metadata = 'metadata';
  static const String settings = 'settings';
  
  // Cache boxes (for temporary data)
  static const String cache = 'cache';
  static const String lastSync = 'last_sync';
}

/// Keys for metadata storage
class MetadataKeys {
  static const String lastSyncTimestamp = 'last_sync_timestamp';
  static const String currentUserId = 'current_user_id';
  static const String currentFacilityId = 'current_facility_id';
  static const String syncInProgress = 'sync_in_progress';
  static const String pendingOperations = 'pending_operations';
  static const String offlineMode = 'offline_mode';
}