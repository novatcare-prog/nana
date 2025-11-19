import 'package:hive_flutter/hive_flutter.dart';
import 'package:mch_core/mch_core.dart';
import 'package:uuid/uuid.dart';

class PatientRepository {
  static const String _boxName = 'maternal_profiles';
  Box<Map>? _box;

  Future<void> init() async {
    _box = await Hive.openBox<Map>(_boxName);
  }

  Future<String> registerPatient(MaternalProfile profile) async {
    if (_box == null) await init();
    
    final id = profile.id.isEmpty ? const Uuid().v4() : profile.id;
    final profileWithId = profile.copyWith(
      id: id,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
    
    await _box!.put(id, profileWithId.toJson());
    return id;
  }

  Future<List<MaternalProfile>> getAllPatients() async {
    if (_box == null) await init();
    
    return _box!.values
        .map((json) => MaternalProfile.fromJson(Map<String, dynamic>.from(json)))
        .toList();
  }

  Future<MaternalProfile?> getPatientById(String id) async {
    if (_box == null) await init();
    
    final json = _box!.get(id);
    if (json == null) return null;
    
    return MaternalProfile.fromJson(Map<String, dynamic>.from(json));
  }

  Future<void> updatePatient(MaternalProfile profile) async {
    if (_box == null) await init();
    
    final updated = profile.copyWith(updatedAt: DateTime.now());
    await _box!.put(profile.id, updated.toJson());
  }

  Future<void> deletePatient(String id) async {
    if (_box == null) await init();
    await _box!.delete(id);
  }

  Future<List<MaternalProfile>> searchPatients(String query) async {
    if (_box == null) await init();
    
    final allPatients = await getAllPatients();
    
    if (query.isEmpty) return allPatients;
    
    final lowercaseQuery = query.toLowerCase();
    return allPatients.where((patient) {
      return patient.clientName.toLowerCase().contains(lowercaseQuery) ||
             patient.ancNumber.toLowerCase().contains(lowercaseQuery) ||
             (patient.telephone?.toLowerCase().contains(lowercaseQuery) ?? false);
    }).toList();
  }
}