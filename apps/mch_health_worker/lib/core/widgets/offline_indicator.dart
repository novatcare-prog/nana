import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/providers/supabase_providers.dart';
import '../../../../core/services/hive_service.dart';

/// Offline Indicator Widget
/// Shows connection status and pending sync items
class OfflineIndicator extends ConsumerWidget {
  const OfflineIndicator({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final connectionAsync = ref.watch(connectionStatusProvider);

    return connectionAsync.when(
      data: (isOnline) {
        if (isOnline) {
          return _buildOnlineIndicator(context);
        } else {
          return _buildOfflineIndicator(context);
        }
      },
      loading: () => const SizedBox.shrink(),
      error: (_, __) => const SizedBox.shrink(),
    );
  }

  Widget _buildOnlineIndicator(BuildContext context) {
    final syncQueue = HiveService.getSyncQueue();
    
    if (syncQueue.isEmpty) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: Colors.green.shade100,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: const [
            Icon(Icons.cloud_done, size: 16, color: Colors.green),
            SizedBox(width: 4),
            Text(
              'Online',
              style: TextStyle(fontSize: 12, color: Colors.green),
            ),
          ],
        ),
      );
    } else {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: Colors.orange.shade100,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.sync, size: 16, color: Colors.orange),
            const SizedBox(width: 4),
            Text(
              'Syncing ${syncQueue.length}',
              style: const TextStyle(fontSize: 12, color: Colors.orange),
            ),
          ],
        ),
      );
    }
  }

  Widget _buildOfflineIndicator(BuildContext context) {
    final syncQueue = HiveService.getSyncQueue();
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.red.shade100,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.cloud_off, size: 16, color: Colors.red),
          const SizedBox(width: 4),
          Text(
            'Offline${syncQueue.isNotEmpty ? " (${syncQueue.length} pending)" : ""}',
            style: const TextStyle(fontSize: 12, color: Colors.red),
          ),
        ],
      ),
    );
  }
}

/// Sync Button Widget
/// Manual sync trigger
class SyncButton extends ConsumerStatefulWidget {
  const SyncButton({super.key});

  @override
  ConsumerState<SyncButton> createState() => _SyncButtonState();
}

class _SyncButtonState extends ConsumerState<SyncButton> {
  bool _isSyncing = false;

  Future<void> _sync() async {
    setState(() => _isSyncing = true);

    try {
      final hybridRepo = ref.read(hybridPatientRepositoryProvider);
      await hybridRepo.syncOfflineChanges();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('✓ Sync completed successfully'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Sync failed: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isSyncing = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final syncQueue = HiveService.getSyncQueue();

    if (syncQueue.isEmpty) {
      return const SizedBox.shrink();
    }

    return IconButton(
      icon: _isSyncing
          ? const SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(strokeWidth: 2),
            )
          : const Icon(Icons.sync),
      tooltip: 'Sync ${syncQueue.length} pending changes',
      onPressed: _isSyncing ? null : _sync,
    );
  }
}