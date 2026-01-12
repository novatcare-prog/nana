import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:mch_core/mch_core.dart'; // Imports the Shared Repo & Models

// 1. REPOSITORY PROVIDER
// Instantiates the shared logic with this app's Supabase client
final childRepositoryProvider = Provider<ChildProfileRepository>((ref) {
  return ChildProfileRepository(Supabase.instance.client);
});

// 2. DATA PROVIDER (The Patient List)
// Used by the "Patients List" screen to show all children
final allChildrenProvider = FutureProvider.autoDispose<List<ChildProfile>>((ref) async {
  final repository = ref.watch(childRepositoryProvider);
  // Uses the method you wrote: getAllActiveChildren()
  return repository.getAllActiveChildren();
});

// 3. CONTROLLER (The Action Handler)
// Used by "Registration Forms" to Create/Update/Delete
final childControllerProvider = StateNotifierProvider<ChildController, AsyncValue<void>>((ref) {
  return ChildController(ref.watch(childRepositoryProvider), ref);
});

class ChildController extends StateNotifier<AsyncValue<void>> {
  final ChildProfileRepository _repository;
  final Ref _ref;

  ChildController(this._repository, this._ref) : super(const AsyncValue.data(null));

  /// Register a new child
  Future<bool> registerChild(ChildProfile child) async {
    state = const AsyncValue.loading();
    try {
      await _repository.createChild(child);
      state = const AsyncValue.data(null);
      // Refresh the list so the new child appears immediately
      _ref.invalidate(allChildrenProvider); 
      return true; // Success
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
      return false; // Failed
    }
  }

  /// Update an existing child
  Future<bool> updateChild(ChildProfile child) async {
    state = const AsyncValue.loading();
    try {
      await _repository.updateChild(child);
      state = const AsyncValue.data(null);
      _ref.invalidate(allChildrenProvider);
      return true;
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
      return false;
    }
  }

  /// Deactivate (Soft Delete) a child
  Future<void> deactivateChild(String childId) async {
    state = const AsyncValue.loading();
    try {
      await _repository.deactivateChild(childId);
      state = const AsyncValue.data(null);
      _ref.invalidate(allChildrenProvider);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }
}