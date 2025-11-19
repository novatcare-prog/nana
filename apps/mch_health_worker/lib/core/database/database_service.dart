import 'package:mch_core/mch_core.dart';
import 'database_helper.dart';

class DatabaseService {
  final DatabaseHelper _dbHelper = DatabaseHelper();

  // Get all patients
  Future<List<MaternalProfile>> getAllPatients() async {
    final db = await _dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.query('maternal_profiles');

    if (maps.isEmpty) {
      return [];
    }

    return List.generate(maps.length, (i) {
      return MaternalProfile.fromJson(maps[i]);
    });
  }

  // Get patient by ID
  Future<MaternalProfile?> getPatientById(String id) async {
    final db = await _dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'maternal_profiles',
      where: 'id = ?',
      whereArgs: [id],
    );

    if (maps.isEmpty) {
      return null;
    }

    return MaternalProfile.fromJson(maps.first);
  }

  // Insert new patient
  Future<void> insertPatient(MaternalProfile patient) async {
    final db = await _dbHelper.database;
    await db.insert(
      'maternal_profiles',
      patient.toJson(),
    );
  }

  // Update patient
  Future<void> updatePatient(MaternalProfile patient) async {
    final db = await _dbHelper.database;
    await db.update(
      'maternal_profiles',
      patient.toJson(),
      where: 'id = ?',
      whereArgs: [patient.id],
    );
  }

  // Delete patient
  Future<void> deletePatient(String id) async {
    final db = await _dbHelper.database;
    await db.delete(
      'maternal_profiles',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // Search patients by name
  Future<List<MaternalProfile>> searchPatients(String query) async {
    final db = await _dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'maternal_profiles',
      where: 'clientName LIKE ?',
      whereArgs: ['%$query%'],
    );

    if (maps.isEmpty) {
      return [];
    }

    return List.generate(maps.length, (i) {
      return MaternalProfile.fromJson(maps[i]);
    });
  }
}