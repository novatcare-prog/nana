import 'package:flutter/material.dart';

/// Centralized error handling utility for user-friendly error messages
class ErrorHelper {
  /// Convert technical error messages to user-friendly text
  static String getFriendlyMessage(dynamic error) {
    final errorStr = error.toString().toLowerCase();
    
    // Authentication errors
    if (errorStr.contains('invalid_credentials') || 
        errorStr.contains('invalid login credentials')) {
      return 'Incorrect email or password.';
    }
    if (errorStr.contains('email not confirmed')) {
      return 'Please verify your email address before logging in.';
    }
    if (errorStr.contains('user not found')) {
      return 'Account not found. Please check your email or sign up.';
    }
    if (errorStr.contains('email already registered') ||
        errorStr.contains('user already registered')) {
      return 'This email is already registered. Try logging in instead.';
    }
    if (errorStr.contains('weak password')) {
      return 'Password is too weak. Please use at least 6 characters.';
    }
    if (errorStr.contains('invalid email')) {
      return 'Please enter a valid email address.';
    }
    if (errorStr.contains('session expired') ||
        errorStr.contains('refresh_token_not_found')) {
      return 'Your session has expired. Please log in again.';
    }
    
    // Network errors
    if (errorStr.contains('socketexception') ||
        errorStr.contains('connection refused') ||
        errorStr.contains('network is unreachable') ||
        errorStr.contains('no internet') ||
        errorStr.contains('failed host lookup')) {
      return 'No internet connection. Please check and try again.';
    }
    if (errorStr.contains('timeout') || 
        errorStr.contains('timed out')) {
      return 'Connection timed out. Please try again.';
    }
    
    // Server errors
    if (errorStr.contains('500') || 
        errorStr.contains('internal server error')) {
      return 'Server error. Please try again later.';
    }
    if (errorStr.contains('503') || 
        errorStr.contains('service unavailable')) {
      return 'Service temporarily unavailable. Please try again later.';
    }
    if (errorStr.contains('429') || 
        errorStr.contains('too many requests')) {
      return 'Too many attempts. Please wait a moment before trying again.';
    }
    
    // Permission errors
    if (errorStr.contains('permission denied') ||
        errorStr.contains('unauthorized') ||
        errorStr.contains('forbidden')) {
      return 'Access denied. Please log in again.';
    }
    
    // Database/Supabase errors
    if (errorStr.contains('row level security') ||
        errorStr.contains('rls')) {
      return 'Access denied. Please contact your administrator.';
    }
    if (errorStr.contains('duplicate key') ||
        errorStr.contains('unique constraint')) {
      return 'This record already exists.';
    }
    if (errorStr.contains('foreign key') ||
        errorStr.contains('violates')) {
      return 'Cannot complete this action due to related records.';
    }
    
    // Storage errors
    if (errorStr.contains('storage') || errorStr.contains('bucket')) {
      return 'File storage error. Please try again.';
    }
    if (errorStr.contains('file too large') || errorStr.contains('size')) {
      return 'File is too large. Please choose a smaller file.';
    }
    
    // Sync errors
    if (errorStr.contains('sync')) {
      return 'Sync failed. Changes will sync when online.';
    }
    
    // Facility errors
    if (errorStr.contains('facility')) {
      return 'Facility data error. Please try again.';
    }
    
    // Default
    return 'Something went wrong. Please try again.';
  }

  /// Show a user-friendly error snackbar
  static void showErrorSnackbar(BuildContext context, dynamic error, {String? prefix}) {
    final message = prefix != null 
        ? '$prefix ${getFriendlyMessage(error)}'
        : getFriendlyMessage(error);
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.error_outline, color: Colors.white, size: 20),
            const SizedBox(width: 12),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: Colors.red.shade600,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        margin: const EdgeInsets.all(16),
      ),
    );
  }

  /// Build a centered error widget with optional retry button
  static Widget buildErrorWidget(dynamic error, {VoidCallback? onRetry}) {
    final message = getFriendlyMessage(error);
    
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.red.shade50,
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.error_outline, size: 48, color: Colors.red.shade300),
            ),
            const SizedBox(height: 16),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 16),
            ),
            if (onRetry != null) ...[
              const SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: onRetry,
                icon: const Icon(Icons.refresh),
                label: const Text('Retry'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
                  foregroundColor: Colors.white,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
