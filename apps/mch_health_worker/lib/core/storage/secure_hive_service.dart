import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hive_flutter/hive_flutter.dart';

/// Opens Hive boxes with AES-256 encryption.
///
/// Each box gets its own 256-bit key generated on first launch and stored
/// in the device's secure keystore (Android Keystore / iOS Keychain) via
/// [FlutterSecureStorage]. Subsequent launches read the same key and reopen
/// the box transparently.
///
/// Usage:
///   final box = await SecureHiveService.openBox('patients');
class SecureHiveService {
  SecureHiveService._(); // static-only class

  static const _secureStorage = FlutterSecureStorage(
    // Use EncryptedSharedPreferences on Android (API 23+)
    aOptions: AndroidOptions(encryptedSharedPreferences: true),
    // Use the default keychain on iOS (already hardware-backed)
    iOptions: IOSOptions(accessibility: KeychainAccessibility.first_unlock),
  );

  /// Opens a Hive box with AES-256-CBC encryption.
  /// The encryption key is lazily generated and stored in the device keystore.
  static Future<Box<dynamic>> openBox(String boxName) async {
    final storageKey = 'hive_enc_key_$boxName';

    // Try to read existing key from secure storage
    String? keyB64 = await _secureStorage.read(key: storageKey);

    if (keyB64 == null) {
      // First launch for this box — generate a new 256-bit key
      final newKey = Hive.generateSecureKey();
      keyB64 = base64UrlEncode(newKey);
      await _secureStorage.write(key: storageKey, value: keyB64);
      debugPrint('🔐 Generated new encryption key for Hive box: $boxName');
    }

    final keyBytes = base64Url.decode(keyB64);
    return Hive.openBox(boxName, encryptionCipher: HiveAesCipher(keyBytes));
  }

  /// Opens a typed Hive box with AES-256-CBC encryption.
  static Future<Box<T>> openTypedBox<T>(String boxName) async {
    final storageKey = 'hive_enc_key_$boxName';

    String? keyB64 = await _secureStorage.read(key: storageKey);

    if (keyB64 == null) {
      final newKey = Hive.generateSecureKey();
      keyB64 = base64UrlEncode(newKey);
      await _secureStorage.write(key: storageKey, value: keyB64);
      debugPrint('🔐 Generated new encryption key for Hive box: $boxName');
    }

    final keyBytes = base64Url.decode(keyB64);
    return Hive.openBox<T>(boxName, encryptionCipher: HiveAesCipher(keyBytes));
  }

  /// Deletes the stored encryption key for a box (effectively makes it
  /// inaccessible). Use with caution — call BEFORE deleting the box file.
  static Future<void> deleteKey(String boxName) async {
    await _secureStorage.delete(key: 'hive_enc_key_$boxName');
    debugPrint('⚠️ Encryption key deleted for Hive box: $boxName');
  }
}
