// File: apps/mch_health_worker/lib/core/storage/sync_queue_item.dart

import 'package:hive/hive.dart';
import 'hive_type_ids.dart';

part 'sync_queue_item.g.dart';

/// Types of sync operations
@HiveType(typeId: HiveTypeIds.syncOperation)
enum SyncOperation {
  @HiveField(0)
  create,
  
  @HiveField(1)
  update,
  
  @HiveField(2)
  delete,
}

/// Queue item for pending sync operations
@HiveType(typeId: HiveTypeIds.syncQueueItem)
class SyncQueueItem extends HiveObject {
  @HiveField(0)
  final String id;
  
  @HiveField(1)
  final SyncOperation operation;
  
  @HiveField(2)
  final String tableName;
  
  @HiveField(3)
  final String recordId;
  
  @HiveField(4)
  final Map<String, dynamic> data;
  
  @HiveField(5)
  final DateTime createdAt;
  
  @HiveField(6)
  int retryCount;
  
  @HiveField(7)
  String? errorMessage;
  
  @HiveField(8)
  bool inProgress;
  
  SyncQueueItem({
    required this.id,
    required this.operation,
    required this.tableName,
    required this.recordId,
    required this.data,
    required this.createdAt,
    this.retryCount = 0,
    this.errorMessage,
    this.inProgress = false,
  });
  
  /// Create a new sync queue item
  factory SyncQueueItem.create({
    required String tableName,
    required String recordId,
    required Map<String, dynamic> data,
  }) {
    return SyncQueueItem(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      operation: SyncOperation.create,
      tableName: tableName,
      recordId: recordId,
      data: data,
      createdAt: DateTime.now(),
    );
  }
  
  /// Update operation
  factory SyncQueueItem.update({
    required String tableName,
    required String recordId,
    required Map<String, dynamic> data,
  }) {
    return SyncQueueItem(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      operation: SyncOperation.update,
      tableName: tableName,
      recordId: recordId,
      data: data,
      createdAt: DateTime.now(),
    );
  }
  
  /// Delete operation
  factory SyncQueueItem.delete({
    required String tableName,
    required String recordId,
  }) {
    return SyncQueueItem(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      operation: SyncOperation.delete,
      tableName: tableName,
      recordId: recordId,
      data: {},
      createdAt: DateTime.now(),
    );
  }
  
  /// Mark as in progress
  void markInProgress() {
    inProgress = true;
    save();
  }
  
  /// Mark as failed with error
  void markFailed(String error) {
    inProgress = false;
    retryCount++;
    errorMessage = error;
    save();
  }
  
  /// Check if should retry
  bool shouldRetry() => retryCount < 3;
  
  /// Get operation name
  String get operationName {
    switch (operation) {
      case SyncOperation.create:
        return 'CREATE';
      case SyncOperation.update:
        return 'UPDATE';
      case SyncOperation.delete:
        return 'DELETE';
    }
  }
  
  @override
  String toString() {
    return 'SyncQueueItem(id: $id, operation: $operationName, table: $tableName, recordId: $recordId, retries: $retryCount)';
  }
}