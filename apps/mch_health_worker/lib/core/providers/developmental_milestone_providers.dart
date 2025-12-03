import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mch_core/mch_core.dart';
import 'supabase_providers.dart';

// Repository Provider
final developmentalMilestoneRepositoryProvider = Provider<DevelopmentalMilestoneRepository>((ref) {
  final supabase = ref.watch(supabaseClientProvider);
  return DevelopmentalMilestoneRepository(supabase);
});

// Get all milestones for a child
final milestonesByChildProvider = FutureProvider.family<List<DevelopmentalMilestone>, String>((ref, childId) async {
  final repository = ref.watch(developmentalMilestoneRepositoryProvider);
  return repository.getMilestonesByChildId(childId);
});

// Get single milestone by ID
final milestoneByIdProvider = FutureProvider.family<DevelopmentalMilestone?, String>((ref, milestoneId) async {
  final repository = ref.watch(developmentalMilestoneRepositoryProvider);
  return repository.getMilestoneById(milestoneId);
});

// Get upcoming assessments
final upcomingMilestoneAssessmentsProvider = FutureProvider.family<List<DevelopmentalMilestone>, String>((ref, childId) async {
  final repository = ref.watch(developmentalMilestoneRepositoryProvider);
  return repository.getUpcomingAssessments(childId);
});

// Get milestones with red flags
final milestonesWithRedFlagsProvider = FutureProvider.family<List<DevelopmentalMilestone>, String>((ref, childId) async {
  final repository = ref.watch(developmentalMilestoneRepositoryProvider);
  return repository.getMilestonesWithRedFlags(childId);
});

// Get latest milestone
final latestMilestoneProvider = FutureProvider.family<DevelopmentalMilestone?, String>((ref, childId) async {
  final repository = ref.watch(developmentalMilestoneRepositoryProvider);
  return repository.getLatestMilestone(childId);
});

// Get milestones by status
final milestonesByStatusProvider = FutureProvider.family<List<DevelopmentalMilestone>, ({String childId, String status})>((ref, params) async {
  final repository = ref.watch(developmentalMilestoneRepositoryProvider);
  return repository.getMilestonesByStatus(params.childId, params.status);
});

// Create milestone
final createMilestoneProvider = Provider<Future<DevelopmentalMilestone> Function(DevelopmentalMilestone)>((ref) {
  return (milestone) async {
    final repository = ref.read(developmentalMilestoneRepositoryProvider);
    final result = await repository.createMilestone(milestone);
    
    // Invalidate related providers
    ref.invalidate(milestonesByChildProvider(milestone.childProfileId));
    ref.invalidate(latestMilestoneProvider(milestone.childProfileId));
    ref.invalidate(upcomingMilestoneAssessmentsProvider(milestone.childProfileId));
    
    return result;
  };
});

// Update milestone
final updateMilestoneProvider = Provider<Future<DevelopmentalMilestone> Function(DevelopmentalMilestone)>((ref) {
  return (milestone) async {
    final repository = ref.read(developmentalMilestoneRepositoryProvider);
    final result = await repository.updateMilestone(milestone);
    
    // Invalidate related providers
    ref.invalidate(milestonesByChildProvider(milestone.childProfileId));
    ref.invalidate(milestoneByIdProvider(milestone.id!));
    ref.invalidate(latestMilestoneProvider(milestone.childProfileId));
    ref.invalidate(upcomingMilestoneAssessmentsProvider(milestone.childProfileId));
    
    return result;
  };
});

// Delete milestone
final deleteMilestoneProvider = Provider<Future<void> Function(String, String)>((ref) {
  return (milestoneId, childId) async {
    final repository = ref.read(developmentalMilestoneRepositoryProvider);
    await repository.deleteMilestone(milestoneId);
    
    // Invalidate related providers
    ref.invalidate(milestonesByChildProvider(childId));
    ref.invalidate(milestoneByIdProvider(milestoneId));
    ref.invalidate(latestMilestoneProvider(childId));
    ref.invalidate(upcomingMilestoneAssessmentsProvider(childId));
  };
});