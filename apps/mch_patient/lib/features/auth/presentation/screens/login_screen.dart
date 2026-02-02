import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../core/providers/auth_provider.dart';

/// Flexible login screen - supports both email and phone number
class FlexibleLoginScreen extends ConsumerStatefulWidget {
  const FlexibleLoginScreen({super.key});

  @override
  ConsumerState<FlexibleLoginScreen> createState() =>
      _FlexibleLoginScreenState();
}

class _FlexibleLoginScreenState extends ConsumerState<FlexibleLoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _identifierController = TextEditingController(); // Email or Phone
  final _passwordController = TextEditingController();

  bool _isLoading = false;
  bool _obscurePassword = true;
  bool _isPhoneMode = false; // Toggle between phone and email

  @override
  void dispose() {
    _identifierController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final authController = ref.read(authControllerProvider);

      if (_isPhoneMode) {
        // Phone number login
        final phone = _formatPhoneNumber(_identifierController.text);
        await authController.signInWithPhone(
          phone: phone,
          password: _passwordController.text,
        );
      } else {
        // Email login
        await authController.signIn(
          email: _identifierController.text.trim(),
          password: _passwordController.text,
        );
      }

      if (mounted) {
        context.go('/home');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(Icons.error_outline, color: Colors.white),
                const SizedBox(width: 12),
                Expanded(child: Text(_getErrorMessage(e.toString()))),
              ],
            ),
            backgroundColor: const Color(0xFFF44336),
            behavior: SnackBarBehavior.floating,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            margin: const EdgeInsets.all(16),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  /// Convert technical error messages to user-friendly ones
  String _getErrorMessage(String error) {
    final errorLower = error.toLowerCase();

    // Invalid credentials
    if (errorLower.contains('invalid_credentials') ||
        errorLower.contains('invalid login credentials')) {
      return 'auth.invalid_credentials'.tr();
    }

    // User not found
    if (errorLower.contains('user not found') ||
        errorLower.contains('no user found')) {
      return 'auth.user_not_found'.tr();
    }

    // Email not confirmed
    if (errorLower.contains('email not confirmed')) {
      return 'auth.email_not_confirmed'.tr();
    }

    // Too many attempts
    if (errorLower.contains('too many requests') ||
        errorLower.contains('rate limit')) {
      return 'auth.too_many_requests'.tr();
    }

    // Network error
    if (errorLower.contains('network') ||
        errorLower.contains('connection') ||
        errorLower.contains('socket') ||
        errorLower.contains('timeout')) {
      return 'auth.network_error'.tr();
    }

    // Invalid email format
    if (errorLower.contains('invalid email')) {
      return 'auth.invalid_email'.tr();
    }

    // Password too weak
    if (errorLower.contains('password') && errorLower.contains('weak')) {
      return 'auth.weak_password'.tr();
    }

    // Account disabled
    if (errorLower.contains('disabled') || errorLower.contains('banned')) {
      return 'auth.account_disabled'.tr();
    }

    // Role mismatch (Patient App vs Health Worker App)
    if (errorLower.contains('app is for patients only')) {
      return 'auth.not_patient_account'.tr();
    }

    // Default fallback - show the actual error message if possible
    // This allows custom exceptions from AuthController to be seen
    String cleanError = error
        .replaceAll('Exception:', '')
        .replaceAll('AuthException:', '')
        .trim();
    if (cleanError.isNotEmpty) {
      return cleanError;
    }

    return 'auth.something_wrong'.tr();
  }

  String _formatPhoneNumber(String phone) {
    // Remove spaces and dashes
    phone = phone.replaceAll(RegExp(r'[\s-]'), '');

    // Convert 0712345678 → +254712345678
    if (phone.startsWith('0')) {
      phone = '+254${phone.substring(1)}';
    } else if (!phone.startsWith('+')) {
      phone = '+254$phone';
    }

    return phone;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.grey[50], // Removed to allow theme background
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 60),

                // Logo - switches based on theme brightness
                Center(
                  child: Image.asset(
                    Theme.of(context).brightness == Brightness.dark
                        ? 'assets/images/Asset_2.png'
                        : 'assets/images/Asset_3.png',
                    height: 180,
                  ),
                ),

                const SizedBox(height: 32),

                // Title
                Text(
                  'auth.welcome_back'.tr(),
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 8),

                Text(
                  'auth.sign_in_continue'.tr(),
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[600],
                  ),
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 40),

                // Toggle between Phone and Email
                Container(
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () => setState(() => _isPhoneMode = true),
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            decoration: BoxDecoration(
                              color: _isPhoneMode
                                  ? const Color(0xFFE91E63)
                                  : Colors.transparent,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.phone,
                                  size: 18,
                                  color: _isPhoneMode
                                      ? Colors.white
                                      : Colors.grey[700],
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  'auth.phone'.tr(),
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: _isPhoneMode
                                        ? Colors.white
                                        : Colors.grey[700],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: GestureDetector(
                          onTap: () => setState(() => _isPhoneMode = false),
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            decoration: BoxDecoration(
                              color: !_isPhoneMode
                                  ? const Color(0xFFE91E63)
                                  : Colors.transparent,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.email,
                                  size: 18,
                                  color: !_isPhoneMode
                                      ? Colors.white
                                      : Colors.grey[700],
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  'auth.email'.tr(),
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: !_isPhoneMode
                                        ? Colors.white
                                        : Colors.grey[700],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // Email or Phone Field
                TextFormField(
                  controller: _identifierController,
                  keyboardType: _isPhoneMode
                      ? TextInputType.phone
                      : TextInputType.emailAddress,
                  enabled: !_isLoading,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onSurface,
                    fontSize: 16,
                  ),
                  inputFormatters: _isPhoneMode
                      ? [
                          FilteringTextInputFormatter.digitsOnly,
                          LengthLimitingTextInputFormatter(10),
                        ]
                      : null,
                  decoration: InputDecoration(
                    labelText: _isPhoneMode
                        ? 'auth.phone_number'.tr()
                        : 'auth.email'.tr(),
                    hintText: _isPhoneMode ? '0712345678' : 'you@example.com',
                    hintStyle: TextStyle(color: Colors.grey[400]),
                    labelStyle: TextStyle(color: Colors.grey[700]),
                    prefixIcon: Icon(
                      _isPhoneMode ? Icons.phone : Icons.email_outlined,
                      color: Colors.grey[600],
                    ),
                    prefixText: _isPhoneMode ? '+254 ' : null,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.grey[300]!),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(
                        color: Color(0xFFE91E63),
                        width: 2,
                      ),
                    ),
                    filled: true,
                    fillColor:
                        Theme.of(context).inputDecorationTheme.fillColor ??
                            Theme.of(context).cardColor,
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return _isPhoneMode
                          ? 'auth.enter_phone'.tr()
                          : 'auth.enter_email'.tr();
                    }

                    if (_isPhoneMode) {
                      // Kenyan phone numbers: 07XX, 01XX (10 digits starting with 0)
                      if (!RegExp(r'^0[17]\d{8}$').hasMatch(value)) {
                        return 'auth.valid_phone'.tr();
                      }
                    } else {
                      // Email validation
                      if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                          .hasMatch(value)) {
                        return 'auth.valid_email'.tr();
                      }
                    }

                    return null;
                  },
                ),

                const SizedBox(height: 16),

                // Password Field
                TextFormField(
                  controller: _passwordController,
                  obscureText: _obscurePassword,
                  enabled: !_isLoading,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onSurface,
                    fontSize: 16,
                  ),
                  decoration: InputDecoration(
                    labelText: 'auth.password'.tr(),
                    hintText: 'auth.enter_password'.tr(),
                    hintStyle: TextStyle(color: Colors.grey[400]),
                    labelStyle: TextStyle(color: Colors.grey[700]),
                    prefixIcon: Icon(
                      Icons.lock_outlined,
                      color: Colors.grey[600],
                    ),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscurePassword
                            ? Icons.visibility_outlined
                            : Icons.visibility_off_outlined,
                        color: Colors.grey[600],
                      ),
                      onPressed: () {
                        setState(() => _obscurePassword = !_obscurePassword);
                      },
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.grey[300]!),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(
                        color: Color(0xFFE91E63),
                        width: 2,
                      ),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'auth.enter_password'.tr();
                    }
                    if (value.length < 6) {
                      return 'auth.min_password'.tr();
                    }
                    return null;
                  },
                  onFieldSubmitted: (_) => _handleLogin(),
                ),

                const SizedBox(height: 16),

                // Forgot Password
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () => context.push('/forgot-password'),
                    child: Text(
                      'auth.forgot_password'.tr(),
                      style: const TextStyle(
                        color: Color(0xFFE91E63),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 8),

                // Login Button
                SizedBox(
                  height: 56,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _handleLogin,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFE91E63),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 0,
                      disabledBackgroundColor: Colors.grey[300],
                    ),
                    child: _isLoading
                        ? const SizedBox(
                            height: 24,
                            width: 24,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                Colors.white,
                              ),
                            ),
                          )
                        : Text(
                            'auth.sign_in'.tr(),
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                  ),
                ),

                const SizedBox(height: 32),

                // Divider
                Row(
                  children: [
                    const Expanded(child: Divider()),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                        'auth.or'.tr(),
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                        ),
                      ),
                    ),
                    const Expanded(child: Divider()),
                  ],
                ),

                const SizedBox(height: 32),

                // Sign Up Link
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "${'auth.no_account'.tr()} ",
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                    TextButton(
                      onPressed:
                          _isLoading ? null : () => context.go('/signup'),
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.zero,
                        minimumSize: const Size(50, 30),
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      child: Text(
                        'auth.sign_up'.tr(),
                        style: const TextStyle(
                          color: Color(0xFFE91E63),
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 24),

                // Help Text
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.blue[50],
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: Colors.blue[200]!,
                      width: 1,
                    ),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(Icons.info_outline,
                          color: Colors.blue[700], size: 20),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'auth.phone_login_info'.tr(),
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                color: Colors.blue[900],
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'auth.phone_login_desc'.tr(),
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.blue[800],
                                height: 1.4,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
