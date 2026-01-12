// File: apps/mch_health_worker/lib/core/storage/hive_initialization.dart

import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'hive_type_ids.dart';
import 'sync_queue_item.dart';

/// Comprehensive Hive initialization service
class HiveInitialization {
  static bool _initialized = false;
  
  /// Initialize Hive with all type adapters and boxes
  static Future<void> initialize() async {
    if (_initialized) return;
    
    // Initialize Hive
    await Hive.initFlutter();
    
    // Register type adapters
    await _registerAdapters();
    
    // Open boxes
    await _openBoxes();
    
    _initialized = true;
    print('✅ Hive initialized successfully');
  }
  
  /// Register all Hive type adapters
  static Future<void> _registerAdapters() async {
    // Sync management adapters
    if (!Hive.isAdapterRegistered(HiveTypeIds.syncQueueItem)) {
      Hive.registerAdapter(SyncQueueItemAdapter());
    }
    if (!Hive.isAdapterRegistered(HiveTypeIds.syncOperation)) {
      Hive.registerAdapter(SyncOperationAdapter());
    }
    
    // TODO: Register model adapters as they're created
    // Example:
    // if (!Hive.isAdapterRegistered(HiveTypeIds.maternalProfile)) {
    //   Hive.registerAdapter(MaternalProfileAdapter());
    // }
    
    print('✅ Hive adapters registered');
  }
  
  /// Open all required Hive boxes
  static Future<void> _openBoxes() async {
    try {
      // Main data boxes
      await Hive.openBox(HiveBoxNames.users);
      await Hive.openBox(HiveBoxNames.maternalProfiles);
      await Hive.openBox(HiveBoxNames.ancVisits);
      await Hive.openBox(HiveBoxNames.childProfiles);
      await Hive.openBox(HiveBoxNames.appointments);
      await Hive.openBox(HiveBoxNames.facilities);
      await Hive.openBox(HiveBoxNames.growthRecords);
      await Hive.openBox(HiveBoxNames.immunizations);
      await Hive.openBox(HiveBoxNames.labResults);
      
      // Sync & metadata boxes
      await Hive.openBox<SyncQueueItem>(HiveBoxNames.syncQueue);
      await Hive.openBox(HiveBoxNames.metadata);
      await Hive.openBox(HiveBoxNames.settings);
      await Hive.openBox(HiveBoxNames.cache);
      await Hive.openBox(HiveBoxNames.lastSync);
      
      print('✅ Hive boxes opened');
    } catch (e) {
      print('❌ Error opening Hive boxes: $e');
      rethrow;
    }
  }
  
  /// Close all Hive boxes (call on app termination)
  static Future<void> close() async {
    await Hive.close();
    _initialized = false;
    print('✅ Hive closed');
  }
  
  /// Clear all data (use with caution!)
  static Future<void> clearAll() async {
    await Hive.deleteFromDisk();
    _initialized = false;
    print('⚠️ All Hive data cleared');
  }
  
  /// Get metadata box
  static Box getMetadataBox() => Hive.box(HiveBoxNames.metadata);
  
  /// Get sync queue box
  static Box<SyncQueueItem> getSyncQueueBox() => 
      Hive.box<SyncQueueItem>(HiveBoxNames.syncQueue);
  
  /// Get a box by name
  static Box getBox(String boxName) => Hive.box(boxName);
  
  /// Check if a box exists and is open
  static bool isBoxOpen(String boxName) => Hive.isBoxOpen(boxName);
  
  /// Get box size (number of entries)
  static int getBoxSize(String boxName) {
    if (!isBoxOpen(boxName)) return 0;
    return Hive.box(boxName).length;
  }
  
  /// Get total storage size across all boxes
  static Future<Map<String, int>> getStorageStats() async {
    final stats = <String, int>{};
    
    final boxNames = [
      HiveBoxNames.users,
      HiveBoxNames.maternalProfiles,
      HiveBoxNames.ancVisits,
      HiveBoxNames.childProfiles,
      HiveBoxNames.appointments,
      HiveBoxNames.facilities,
      HiveBoxNames.syncQueue,
      HiveBoxNames.metadata,
    ];
    
    for (final boxName in boxNames) {
      if (isBoxOpen(boxName)) {
        stats[boxName] = getBoxSize(boxName);
      }
    }
    
    return stats;
  }
}