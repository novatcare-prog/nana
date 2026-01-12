import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:mch_core/mch_core.dart';
import 'maternal_profile_provider.dart';

/// Repository provider for child profiles
final childProfileRepositoryProvider = Provider<ChildProfileRepository>((ref) {
  return ChildProfileRepository(Supabase.instance.client);
});

/// Provider to get the current patient's children
/// Fetches children linked to the patient's maternal profile
final patientChildrenProvider = FutureProvider<List<ChildProfile>>((ref) async {
  final maternalProfileAsync = ref.watch(currentMaternalProfileProvider);
  final repository = ref.read(childProfileRepositoryProvider);
  
  return maternalProfileAsync.when(
    data: (maternalProfile) async {
      if (maternalProfile == null || maternalProfile.id == null || maternalProfile.id!.isEmpty) {
        print('📋 No maternal profile found, returning empty children list');
        return <ChildProfile>[];
      }
      
      print('📋 Fetching children for maternal profile: ${maternalProfile.id}');
      try {
        final children = await repository.getChildrenByMotherId(maternalProfile.id!);
        print('📋 Found ${children.length} children');
        return children;
      } catch (e) {
        print('📋 Error fetching children: $e');
        return <ChildProfile>[];
      }
    },
    loading: () async {
      print('📋 Waiting for maternal profile...');
      return <ChildProfile>[];
    },
    error: (error, stack) async {
      print('📋 Maternal profile error: $error');
      return <ChildProfile>[];
    },
  );
});

/// Provider to get a single child by ID
final childByIdProvider = FutureProvider.family<ChildProfile?, String>((ref, childId) async {
  final repository = ref.read(childProfileRepositoryProvider);
  
  try {
    return await repository.getChildById(childId);
  } catch (e) {
    print('Error fetching child by ID: $e');
    return null;
  }
});

/// Controller for child CRUD operations
class PatientChildController extends StateNotifier<AsyncValue<void>> {
  final ChildProfileRepository _repository;
  final Ref _ref;

  PatientChildController(this._repository, this._ref) : super(const AsyncValue.data(null));

  /// Register a new child
  Future<bool> addChild(ChildProfile child) async {
    state = const AsyncValue.loading();
    try {
      await _repository.createChild(child);
      state = const AsyncValue.data(null);
      // Refresh the children list
      _ref.invalidate(patientChildrenProvider);
      return true;
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
      return false;
    }
  }

  /// Update an existing child
  Future<bool> updateChild(ChildProfile child) async {
    state = const AsyncValue.loading();
    try {
      await _repository.updateChild(child);
      state = const AsyncValue.data(null);
      _ref.invalidate(patientChildrenProvider);
      return true;
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
      return false;
    }
  }
}

final patientChildControllerProvider = StateNotifierProvider<PatientChildController, AsyncValue<void>>((ref) {
  return PatientChildController(
    ref.watch(childProfileRepositoryProvider),
    ref,
  );
});
