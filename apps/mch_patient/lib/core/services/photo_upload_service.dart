import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Service for handling profile photo uploads to Supabase Storage
class PhotoUploadService {
  final ImagePicker _picker = ImagePicker();
  final SupabaseClient _supabase = Supabase.instance.client;
  
  static const String _bucketName = 'profile-photos';
  
  /// Pick an image from the gallery
  Future<File?> pickFromGallery() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 512,
        maxHeight: 512,
        imageQuality: 85,
      );
      
      if (image != null) {
        return File(image.path);
      }
      return null;
    } catch (e) {
      debugPrint('Error picking image from gallery: $e');
      return null;
    }
  }
  
  /// Take a photo with the camera
  Future<File?> takePhoto() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.camera,
        maxWidth: 512,
        maxHeight: 512,
        imageQuality: 85,
        preferredCameraDevice: CameraDevice.front,
      );
      
      if (image != null) {
        return File(image.path);
      }
      return null;
    } catch (e) {
      debugPrint('Error taking photo: $e');
      return null;
    }
  }
  
  /// Upload the image to Supabase Storage and return the public URL
  Future<String?> uploadProfilePhoto({
    required File imageFile,
    required String maternalProfileId,
  }) async {
    try {
      // Generate unique filename
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final extension = imageFile.path.split('.').last;
      final fileName = '$maternalProfileId-$timestamp.$extension';
      final filePath = 'maternal/$fileName';
      
      // Upload to Supabase Storage
      await _supabase.storage
          .from(_bucketName)
          .upload(
            filePath,
            imageFile,
            fileOptions: const FileOptions(
              cacheControl: '3600',
              upsert: true,
            ),
          );
      
      // Get the public URL
      final publicUrl = _supabase.storage
          .from(_bucketName)
          .getPublicUrl(filePath);
      
      debugPrint('Photo uploaded successfully: $publicUrl');
      return publicUrl;
    } catch (e) {
      debugPrint('Error uploading photo: $e');
      return null;
    }
  }
  
  /// Update the photo_url in the maternal_profiles table
  Future<bool> updateProfilePhotoUrl({
    required String maternalProfileId,
    required String photoUrl,
  }) async {
    try {
      await _supabase
          .from('maternal_profiles')
          .update({'photo_url': photoUrl})
          .eq('id', maternalProfileId);
      
      return true;
    } catch (e) {
      debugPrint('Error updating photo URL in database: $e');
      return false;
    }
  }
  
  /// Delete the old photo from storage (optional cleanup)
  Future<void> deleteOldPhoto(String? oldPhotoUrl) async {
    if (oldPhotoUrl == null || oldPhotoUrl.isEmpty) return;
    
    try {
      // Extract file path from URL
      final uri = Uri.parse(oldPhotoUrl);
      final pathSegments = uri.pathSegments;
      
      // Find the path after 'profile-photos'
      final bucketIndex = pathSegments.indexOf(_bucketName);
      if (bucketIndex != -1 && bucketIndex < pathSegments.length - 1) {
        final filePath = pathSegments.sublist(bucketIndex + 1).join('/');
        
        await _supabase.storage
            .from(_bucketName)
            .remove([filePath]);
        
        debugPrint('Old photo deleted: $filePath');
      }
    } catch (e) {
      debugPrint('Error deleting old photo: $e');
      // Non-critical error, don't throw
    }
  }
}
