import 'package:flutter/material.dart';

/// Utility class for converting technical errors to user-friendly messages
class ErrorHelper {
  /// Convert any error to a user-friendly message
  static String getFriendlyMessage(dynamic error) {
    final errorStr = error.toString().toLowerCase();

    // Authentication errors
    if (errorStr.contains('invalid_credentials') ||
        errorStr.contains('invalid login credentials')) {
      return 'Incorrect email or password. Please try again.';
    }
    if (errorStr.contains('user not found') ||
        errorStr.contains('no user found')) {
      return 'Account not found. Please check your details or sign up.';
    }
    if (errorStr.contains('email not confirmed')) {
      return 'Please verify your email before logging in.';
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
    if (errorStr.contains('same_password')) {
      return 'New password must be different from your current password.';
    }
    if (errorStr.contains('session expired') ||
        errorStr.contains('refresh_token_not_found') ||
        errorStr.contains('not authenticated')) {
      return 'Your session has expired. Please log in again.';
    }
    if (errorStr.contains('disabled') || errorStr.contains('banned')) {
      return 'Your account has been disabled. Please contact support.';
    }
    if (errorStr.contains('app is for patients only')) {
      return 'This app is for patients only. Please use the health worker app.';
    }
    if (errorStr.contains('too many requests') ||
        errorStr.contains('rate limit') ||
        errorStr.contains('429')) {
      return 'Too many attempts. Please wait a moment and try again.';
    }

    // OTP / Token errors
    if (errorStr.contains('otp') || errorStr.contains('token')) {
      if (errorStr.contains('expired')) {
        return 'Your code has expired. Please request a new one.';
      }
      if (errorStr.contains('invalid')) {
        return 'Invalid code. Please check and try again.';
      }
    }

    // Network errors
    if (errorStr.contains('socketexception') ||
        errorStr.contains('connection refused') ||
        errorStr.contains('network is unreachable') ||
        errorStr.contains('no internet') ||
        errorStr.contains('failed host lookup') ||
        errorStr.contains('host lookup') ||
        errorStr.contains('network') ||
        errorStr.contains('connection') ||
        errorStr.contains('socket')) {
      return 'No internet connection. Please check your network and try again.';
    }
    if (errorStr.contains('timeout') || errorStr.contains('timed out')) {
      return 'Connection timed out. Please try again.';
    }

    // Server errors
    if (errorStr.contains('500') ||
        errorStr.contains('internal server error')) {
      return 'Server error. Please try again later.';
    }
    if (errorStr.contains('503') || errorStr.contains('service unavailable')) {
      return 'Service temporarily unavailable. Please try again later.';
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
        errorStr.contains('unauthorized') ||
        errorStr.contains('forbidden')) {
      return 'Access denied. Please log in again.';
    }

    // Row Level Security
    if (errorStr.contains('row level security') || errorStr.contains('rls')) {
      return 'Access denied. Please contact support.';
    }

    // Duplicate/constraint errors
    if (errorStr.contains('duplicate key') ||
        errorStr.contains('unique constraint')) {
      return 'This record already exists.';
    }
    if (errorStr.contains('foreign key') || errorStr.contains('violates')) {
      return 'Cannot complete this action due to related records.';
    }

    // Storage errors
    if (errorStr.contains('storage') || errorStr.contains('bucket')) {
      return 'File storage error. Please try again.';
    }
    if (errorStr.contains('file too large') ||
        errorStr.contains('payload too large')) {
      return 'File is too large. Please choose a smaller file.';
    }

    // Sync errors
    if (errorStr.contains('sync')) {
      return 'Sync failed. Changes will be saved when you\'re back online.';
    }

    // Not found
    if (errorStr.contains('not found') || errorStr.contains('404')) {
      return 'The requested information could not be found.';
    }

    // Default
    return 'Something went wrong. Please try again.';
  }

  /// Show a user-friendly error snackbar
  static void showErrorSnackbar(BuildContext context, dynamic error,
      {String? prefix}) {
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
