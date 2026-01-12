import 'package:flutter/material.dart';

/// Utility class for converting technical errors to user-friendly messages
class ErrorHelper {
  /// Convert any error to a user-friendly message
  static String getFriendlyMessage(dynamic error) {
    final errorStr = error.toString().toLowerCase();
    
    // Authentication errors
    if (errorStr.contains('invalid_credentials') || 
        errorStr.contains('invalid login credentials')) {
      return 'Incorrect email or password.';
    }
    if (errorStr.contains('user not found') || 
        errorStr.contains('no user found')) {
      return 'Account not found.';
    }
    if (errorStr.contains('email not confirmed')) {
      return 'Please verify your email first.';
    }
    if (errorStr.contains('too many requests') || 
        errorStr.contains('rate limit')) {
      return 'Too many attempts. Please wait and try again.';
    }
    
    // Network errors
    if (errorStr.contains('network') || 
        errorStr.contains('connection') ||
        errorStr.contains('socket') ||
        errorStr.contains('timeout') ||
        errorStr.contains('host lookup')) {
      return 'No internet connection. Please check and try again.';
    }
    
    // Database/Server errors
    if (errorStr.contains('postgresql') || 
        errorStr.contains('database') ||
        errorStr.contains('supabase')) {
      return 'Server error. Please try again later.';
    }
    
    // Permission errors
    if (errorStr.contains('permission') || 
        errorStr.contains('denied') ||
        errorStr.contains('unauthorized')) {
      return 'Access denied. Please log in again.';
    }
    
    // Storage errors
    if (errorStr.contains('storage') || errorStr.contains('bucket')) {
      return 'Storage unavailable. Please try again.';
    }
    
    // Not found
    if (errorStr.contains('not found') || errorStr.contains('404')) {
      return 'Data not found.';
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

  /// Build a user-friendly error widget for display in UI
  static Widget buildErrorWidget(dynamic error, {VoidCallback? onRetry}) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 48, color: Colors.grey[400]),
            const SizedBox(height: 16),
            Text(
              getFriendlyMessage(error),
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, color: Colors.grey[600]),
            ),
            if (onRetry != null) ...[
              const SizedBox(height: 16),
              TextButton.icon(
                onPressed: onRetry,
                icon: const Icon(Icons.refresh),
                label: const Text('Retry'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
