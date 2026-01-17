import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mch_core/mch_core.dart';
import 'supabase_providers.dart';
import '../services/hive_service.dart';
import '../services/connectivity_service.dart';

// Repository Provider
final developmentalMilestoneRepositoryProvider = Provider<DevelopmentalMilestoneRepository>((ref) {
  final supabase = ref.watch(supabaseClientProvider);
  return DevelopmentalMilestoneRepository(supabase);
});

// ============================================
// DATA PROVIDERS (OFFLINE-FIRST)
// ============================================

/// Get all milestones for a child (offline-first)
final milestonesByChildProvider = FutureProvider.family<List<DevelopmentalMilestone>, String>((ref, childId) async {
  final repository = ref.watch(developmentalMilestoneRepositoryProvider);
  final connectivity = ref.watch(connectivityServiceProvider);
  
  try {
    if (connectivity.isOnline) {
      final results = await repository.getMilestonesByChildId(childId);
      return results;
    }
  } catch (e) {
    print('⚠️ Failed to fetch milestones online: $e');
  }
  
  return [];
});

/// Get single milestone by ID
final milestoneByIdProvider = FutureProvider.family<DevelopmentalMilestone?, String>((ref, milestoneId) async {
  final repository = ref.watch(developmentalMilestoneRepositoryProvider);
  final connectivity = ref.watch(connectivityServiceProvider);
  
  if (connectivity.isOnline) {
    return repository.getMilestoneById(milestoneId);
  }
  return null;
});

/// Get upcoming assessments (online only)
final upcomingMilestoneAssessmentsProvider = FutureProvider.family<List<DevelopmentalMilestone>, String>((ref, childId) async {
  final repository = ref.watch(developmentalMilestoneRepositoryProvider);
  final connectivity = ref.watch(connectivityServiceProvider);
  
  if (!connectivity.isOnline) return [];
  return repository.getUpcomingAssessments(childId);
});

/// Get milestones with red flags (offline-first)
final milestonesWithRedFlagsProvider = FutureProvider.family<List<DevelopmentalMilestone>, String>((ref, childId) async {
  final milestones = await ref.watch(milestonesByChildProvider(childId).future);
  return milestones.where((m) => m.redFlagsPresent == true).toList();
});

/// Get latest milestone (offline-first)
final latestMilestoneProvider = FutureProvider.family<DevelopmentalMilestone?, String>((ref, childId) async {
  final milestones = await ref.watch(milestonesByChildProvider(childId).future);
  if (milestones.isEmpty) return null;
  milestones.sort((a, b) => b.assessmentDate.compareTo(a.assessmentDate));
  return milestones.first;
});

/// Get milestones by status (offline-first)
final milestonesByStatusProvider = FutureProvider.family<List<DevelopmentalMilestone>, ({String childId, String status})>((ref, params) async {
  final milestones = await ref.watch(milestonesByChildProvider(params.childId).future);
  return milestones.where((m) => m.overallStatus == params.status).toList();
});

// ============================================
// MUTATION PROVIDERS (WITH OFFLINE SUPPORT)
// ============================================

/// Create milestone (with offline queue)
final createMilestoneProvider = Provider<Future<DevelopmentalMilestone> Function(DevelopmentalMilestone)>((ref) {
  final connectivity = ref.watch(connectivityServiceProvider);
  
  return (milestone) async {
    if (connectivity.isOnline) {
      final repository = ref.read(developmentalMilestoneRepositoryProvider);
      final result = await repository.createMilestone(milestone);
      
      // Invalidate related providers
      ref.invalidate(milestonesByChildProvider(milestone.childProfileId));
      ref.invalidate(latestMilestoneProvider(milestone.childProfileId));
      ref.invalidate(upcomingMilestoneAssessmentsProvider(milestone.childProfileId));
      
      return result;
    } else {
      // Offline: add to sync queue
      await HiveService.addToSyncQueue(
        operation: 'insert',
        table: 'developmental_milestones',
        data: milestone.toJson(),
      );
      
      ref.invalidate(milestonesByChildProvider(milestone.childProfileId));
      ref.invalidate(latestMilestoneProvider(milestone.childProfileId));
      
      return milestone;
    }
  };
});

/// Update milestone (with offline queue)
final updateMilestoneProvider = Provider<Future<DevelopmentalMilestone> Function(DevelopmentalMilestone)>((ref) {
  final connectivity = ref.watch(connectivityServiceProvider);
  
  return (milestone) async {
    if (connectivity.isOnline) {
      final repository = ref.read(developmentalMilestoneRepositoryProvider);
      final result = await repository.updateMilestone(milestone);
      
      // Invalidate related providers
      ref.invalidate(milestonesByChildProvider(milestone.childProfileId));
      ref.invalidate(milestoneByIdProvider(milestone.id!));
      ref.invalidate(latestMilestoneProvider(milestone.childProfileId));
      ref.invalidate(upcomingMilestoneAssessmentsProvider(milestone.childProfileId));
      
      return result;
    } else {
      await HiveService.addToSyncQueue(
        operation: 'update',
        table: 'developmental_milestones',
        data: milestone.toJson(),
      );
      
      ref.invalidate(milestonesByChildProvider(milestone.childProfileId));
      ref.invalidate(latestMilestoneProvider(milestone.childProfileId));
      
      return milestone;
    }
  };
});

/// Delete milestone (with offline queue)
final deleteMilestoneProvider = Provider<Future<void> Function(String, String)>((ref) {
  final connectivity = ref.watch(connectivityServiceProvider);
  
  return (milestoneId, childId) async {
    if (connectivity.isOnline) {
      final repository = ref.read(developmentalMilestoneRepositoryProvider);
      await repository.deleteMilestone(milestoneId);
    } else {
      await HiveService.addToSyncQueue(
        operation: 'delete',
        table: 'developmental_milestones',
        data: {'id': milestoneId},
      );
    }
    
    // Invalidate related providers
    ref.invalidate(milestonesByChildProvider(childId));
    ref.invalidate(milestoneByIdProvider(milestoneId));
    ref.invalidate(latestMilestoneProvider(childId));
    ref.invalidate(upcomingMilestoneAssessmentsProvider(childId));
  };
});