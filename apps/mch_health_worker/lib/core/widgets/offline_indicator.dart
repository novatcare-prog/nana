import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/connectivity_service.dart';
import '../services/sync_manager.dart';

/// Compact offline indicator for AppBar
class OfflineIndicator extends ConsumerWidget {
  const OfflineIndicator({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isOnline = ref.watch(isOnlineProvider);
    final pendingCount = ref.watch(pendingSyncCountProvider);

    // Show syncing indicator (online with pending items)
    if (isOnline && pendingCount > 0) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: Colors.blue.withOpacity(0.1),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(
              width: 12,
              height: 12,
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
            const SizedBox(width: 8),
            Text(
              'Syncing $pendingCount',
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: Colors.blue,
              ),
            ),
          ],
        ),
      );
    }

    // Hide when online and nothing pending
    if (isOnline && pendingCount == 0) {
      return const SizedBox.shrink();
    }

    // Show offline indicator
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.orange.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.cloud_off, size: 14, color: Colors.orange),
          const SizedBox(width: 6),
          Text(
            'Offline${pendingCount > 0 ? ' ($pendingCount)' : ''}',
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: Colors.orange,
            ),
          ),
        ],
      ),
    );
  }
}

/// Manual sync button for AppBar
class SyncButton extends ConsumerWidget {
  const SyncButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isOnline = ref.watch(isOnlineProvider);
    final pendingCount = ref.watch(pendingSyncCountProvider);

    // Only show when online and has pending items
    if (!isOnline || pendingCount == 0) {
      return const SizedBox.shrink();
    }

    return IconButton(
      icon: const Icon(Icons.sync),
      tooltip: 'Sync $pendingCount pending changes',
      onPressed: () => _triggerSync(context, ref),
    );
  }

  Future<void> _triggerSync(BuildContext context, WidgetRef ref) async {
    // Show loading dialog
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const AlertDialog(
        content: Row(
          children: [
            CircularProgressIndicator(),
            SizedBox(width: 16),
            Text('Syncing data...'),
          ],
        ),
      ),
    );

    try {
      final syncManager = ref.read(syncManagerProvider);
      final result = await syncManager.syncAll();

      if (context.mounted) {
        Navigator.pop(context); // Close loading dialog

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(result.message),
            backgroundColor: result.success ? Colors.green : Colors.orange,
            action: result.success
                ? null
                : SnackBarAction(
                    label: 'Retry',
                    onPressed: () => _triggerSync(context, ref),
                  ),
          ),
        );

        // Refresh UI
        ref.invalidate(pendingSyncCountProvider);
      }
    } catch (e) {
      if (context.mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Sync failed: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
}

/// Full-width offline banner
class OfflineBanner extends ConsumerWidget {
  const OfflineBanner({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isOnline = ref.watch(isOnlineProvider);

    if (isOnline) {
      return const SizedBox.shrink();
    }

    final pendingCount = ref.watch(pendingSyncCountProvider);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      color: Colors.orange.withOpacity(0.1),
      child: Row(
        children: [
          const Icon(Icons.cloud_off, color: Colors.orange, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Working Offline',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.orange,
                  ),
                ),
                if (pendingCount > 0)
                  Text(
                    '$pendingCount change${pendingCount == 1 ? '' : 's'} will sync when online',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.orange[700],
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Listens to sync results and shows user-friendly notifications
/// Wrap your main app widget with this to get automatic sync error notifications
class SyncErrorListener extends ConsumerWidget {
  final Widget child;
  
  const SyncErrorListener({super.key, required this.child});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Listen to sync results stream
    ref.listen<AsyncValue<SyncResult>>(syncResultsProvider, (previous, next) {
      next.whenData((result) {
        // Only show notification if there were failures
        if (result.failed > 0 && context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Row(
                children: [
                  const Icon(Icons.warning_amber, color: Colors.white),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Sync completed with ${result.failed} error${result.failed == 1 ? '' : 's'}',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        if (result.synced > 0)
                          Text(
                            '${result.synced} item${result.synced == 1 ? '' : 's'} synced successfully',
                            style: const TextStyle(fontSize: 12),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
              backgroundColor: Colors.orange.shade700,
              duration: const Duration(seconds: 5),
              action: SnackBarAction(
                label: 'Retry',
                textColor: Colors.white,
                onPressed: () {
                  final syncManager = ref.read(syncManagerProvider);
                  syncManager.syncAll();
                },
              ),
            ),
          );
        }
      });
    });
    
    return child;
  }
}