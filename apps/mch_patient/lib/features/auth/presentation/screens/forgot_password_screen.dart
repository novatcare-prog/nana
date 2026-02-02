import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/providers/auth_provider.dart';
import '../../../../core/utils/error_helper.dart';

class ForgotPasswordScreen extends ConsumerStatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  ConsumerState<ForgotPasswordScreen> createState() =>
      _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends ConsumerState<ForgotPasswordScreen> {
  final _emailFormKey = GlobalKey<FormState>();
  final _resetFormKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _codeController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _isLoading = false;
  bool _codeSent = false;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  String _userEmail = '';

  @override
  void dispose() {
    _emailController.dispose();
    _codeController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _handleSendCode() async {
    if (!_emailFormKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      await ref.read(authControllerProvider).sendPasswordResetOtp(
            email: _emailController.text.trim(),
          );

      setState(() {
        _codeSent = true;
        _userEmail = _emailController.text.trim();
        _isLoading = false;
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('auth.code_sent'.tr()),
            backgroundColor: AppColors.success,
          ),
        );
      }
    } catch (e) {
      setState(() => _isLoading = false);

      if (mounted) {
        ErrorHelper.showErrorSnackbar(context, e);
      }
    }
  }

  Future<void> _handleResetPassword() async {
    if (!_resetFormKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      // Verify the OTP and update password
      await ref.read(authControllerProvider).verifyOtpAndResetPassword(
            email: _userEmail,
            token: _codeController.text.trim(),
            newPassword: _passwordController.text,
          );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('auth.password_reset_success'.tr()),
            backgroundColor: AppColors.success,
          ),
        );

        // Navigate to login
        context.go('/login');
      }
    } catch (e) {
      setState(() => _isLoading = false);

      if (mounted) {
        ErrorHelper.showErrorSnackbar(context, e);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back,
              color: Theme.of(context).colorScheme.onSurface),
          onPressed: () => context.pop(),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: _codeSent ? _buildResetPasswordForm() : _buildSendCodeForm(),
        ),
      ),
    );
  }

  Widget _buildSendCodeForm() {
    return Form(
      key: _emailFormKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 20),

          // Logo
          Center(
            child: SizedBox(
              width: 120,
              height: 120,
              child: Image.asset(
                Theme.of(context).brightness == Brightness.dark
                    ? 'assets/images/Asset_2.png'
                    : 'assets/images/Asset_3.png',
                fit: BoxFit.contain,
              ),
            ),
          ),

          const SizedBox(height: 32),

          // Title
          Text(
            'auth.forgot_password_title'.tr(),
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.onSurface,
            ),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: 12),

          // Subtitle
          Text(
            'auth.forgot_password_subtitle'.tr(),
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: 40),

          // Email Field
          TextFormField(
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.done,
            enabled: !_isLoading,
            style: TextStyle(
              color: Theme.of(context).colorScheme.onSurface,
              fontSize: 16,
            ),
            decoration: InputDecoration(
              labelText: 'auth.email_address'.tr(),
              hintText: 'auth.enter_email'.tr(),
              hintStyle: TextStyle(color: Colors.grey[400]),
              labelStyle: TextStyle(color: Colors.grey[700]),
              prefixIcon: Icon(Icons.email_outlined, color: Colors.grey[600]),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.grey[300]!),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide:
                    const BorderSide(color: Color(0xFFFF6B9D), width: 2),
              ),
              filled: true,
              fillColor: Theme.of(context).inputDecorationTheme.fillColor ??
                  Theme.of(context).cardColor,
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'auth.enter_email'.tr();
              }
              if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                  .hasMatch(value)) {
                return 'auth.valid_email'.tr();
              }
              return null;
            },
            onFieldSubmitted: (_) => _handleSendCode(),
          ),

          const SizedBox(height: 24),

          // Send Code Button
          SizedBox(
            height: 56,
            child: ElevatedButton(
              onPressed: _isLoading ? null : _handleSendCode,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFF6B9D),
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
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                  : Text(
                      'auth.send_reset_code'.tr(),
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
            ),
          ),

          const SizedBox(height: 24),

          // Back to Login
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '${'auth.remember_password'.tr()} ',
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 14,
                ),
              ),
              TextButton(
                onPressed: () => context.pop(),
                style: TextButton.styleFrom(
                  padding: EdgeInsets.zero,
                  minimumSize: const Size(50, 30),
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                child: Text(
                  'auth.sign_in'.tr(),
                  style: const TextStyle(
                    color: Color(0xFFFF6B9D),
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildResetPasswordForm() {
    return Form(
      key: _resetFormKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 20),

          // Logo
          Center(
            child: SizedBox(
              width: 120,
              height: 120,
              child: Image.asset(
                Theme.of(context).brightness == Brightness.dark
                    ? 'assets/images/Asset_2.png'
                    : 'assets/images/Asset_3.png',
                fit: BoxFit.contain,
              ),
            ),
          ),

          const SizedBox(height: 32),

          // Title
          Text(
            'auth.enter_reset_code'.tr(),
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.onSurface,
            ),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: 12),

          // Subtitle
          Text(
            'auth.we_sent_code'.tr(),
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
            ),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: 4),

          Text(
            _userEmail,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Color(0xFFFF6B9D),
            ),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: 32),

          // Reset Code Field
          TextFormField(
            controller: _codeController,
            keyboardType: TextInputType.number,
            textInputAction: TextInputAction.next,
            enabled: !_isLoading,
            style: TextStyle(
              color: Theme.of(context).colorScheme.onSurface,
              fontSize: 20,
              fontWeight: FontWeight.bold,
              letterSpacing: 8,
            ),
            textAlign: TextAlign.center,
            decoration: InputDecoration(
              labelText: 'auth.reset_code'.tr(),
              hintText: '000000',
              hintStyle: TextStyle(
                color: Colors.grey[300],
                letterSpacing: 8,
              ),
              labelStyle: TextStyle(color: Colors.grey[700]),
              prefixIcon: Icon(Icons.pin, color: Colors.grey[600]),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.grey[300]!),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide:
                    const BorderSide(color: Color(0xFFFF6B9D), width: 2),
              ),
              filled: true,
              fillColor: Theme.of(context).inputDecorationTheme.fillColor ??
                  Theme.of(context).cardColor,
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'auth.enter_code'.tr();
              }
              if (value.length != 6) {
                return 'auth.code_6_digits'.tr();
              }
              return null;
            },
          ),

          const SizedBox(height: 16),

          // New Password Field
          TextFormField(
            controller: _passwordController,
            obscureText: _obscurePassword,
            textInputAction: TextInputAction.next,
            enabled: !_isLoading,
            style: TextStyle(
              color: Theme.of(context).colorScheme.onSurface,
              fontSize: 16,
            ),
            decoration: InputDecoration(
              labelText: 'auth.new_password'.tr(),
              hintText: 'auth.enter_new_password'.tr(),
              hintStyle: TextStyle(color: Colors.grey[400]),
              labelStyle: TextStyle(color: Colors.grey[700]),
              prefixIcon: Icon(Icons.lock_outlined, color: Colors.grey[600]),
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
                borderSide:
                    const BorderSide(color: Color(0xFFFF6B9D), width: 2),
              ),
              filled: true,
              fillColor: Theme.of(context).inputDecorationTheme.fillColor ??
                  Theme.of(context).cardColor,
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'auth.enter_password_validation'.tr();
              }
              if (value.length < 6) {
                return 'auth.password_too_short'.tr();
              }
              return null;
            },
          ),

          const SizedBox(height: 16),

          // Confirm Password Field
          TextFormField(
            controller: _confirmPasswordController,
            obscureText: _obscureConfirmPassword,
            textInputAction: TextInputAction.done,
            enabled: !_isLoading,
            style: TextStyle(
              color: Theme.of(context).colorScheme.onSurface,
              fontSize: 16,
            ),
            decoration: InputDecoration(
              labelText: 'auth.confirm_password'.tr(),
              hintText: 'auth.confirm_new_password'.tr(),
              hintStyle: TextStyle(color: Colors.grey[400]),
              labelStyle: TextStyle(color: Colors.grey[700]),
              prefixIcon: Icon(Icons.lock_outlined, color: Colors.grey[600]),
              suffixIcon: IconButton(
                icon: Icon(
                  _obscureConfirmPassword
                      ? Icons.visibility_outlined
                      : Icons.visibility_off_outlined,
                  color: Colors.grey[600],
                ),
                onPressed: () {
                  setState(
                      () => _obscureConfirmPassword = !_obscureConfirmPassword);
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
                borderSide:
                    const BorderSide(color: Color(0xFFFF6B9D), width: 2),
              ),
              filled: true,
              fillColor: Theme.of(context).inputDecorationTheme.fillColor ??
                  Theme.of(context).cardColor,
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'auth.confirm_password_validation'.tr();
              }
              if (value != _passwordController.text) {
                return 'auth.passwords_not_match'.tr();
              }
              return null;
            },
            onFieldSubmitted: (_) => _handleResetPassword(),
          ),

          const SizedBox(height: 24),

          // Info Box
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.blue[50],
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: Colors.blue[100]!,
                width: 1,
              ),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.info_outline, color: Colors.blue[700], size: 20),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'auth.check_email_info'.tr(),
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.blue[800],
                      height: 1.4,
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // Reset Password Button
          SizedBox(
            height: 56,
            child: ElevatedButton(
              onPressed: _isLoading ? null : _handleResetPassword,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFF6B9D),
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
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                  : Text(
                      'auth.reset_password'.tr(),
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
            ),
          ),

          const SizedBox(height: 16),

          // Resend Code
          Center(
            child: TextButton(
              onPressed: _isLoading
                  ? null
                  : () {
                      setState(() => _codeSent = false);
                    },
              child: Text(
                'auth.resend_code'.tr(),
                style: const TextStyle(
                  color: Color(0xFFFF6B9D),
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
