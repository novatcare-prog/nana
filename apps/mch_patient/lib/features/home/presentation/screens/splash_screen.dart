import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/services/app_initializer.dart';
import '../../../../core/services/notification_scheduler.dart';

/// Splash Screen with Initialization
/// Handles all app startup tasks with progress indication
class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> 
    with SingleTickerProviderStateMixin {
  
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;
  
  String _statusMessage = 'Starting...';
  double _progress = 0.0;
  bool _hasError = false;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _setupAnimations();
    _initializeApp();
  }

  void _setupAnimations() {
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.0, 0.5, curve: Curves.easeOut),
      ),
    );

    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.0, 0.5, curve: Curves.easeOutBack),
      ),
    );

    _animationController.forward();
  }

  Future<void> _initializeApp() async {
    final initializer = AppInitializer();
    
    final success = await initializer.initialize(
      onProgress: (step, progress) {
        if (mounted) {
          setState(() {
            _statusMessage = step;
            _progress = progress;
          });
        }
      },
    );

    if (!mounted) return;

    if (!success) {
      setState(() {
        _hasError = true;
        _errorMessage = initializer.error ?? 'Unknown error occurred';
      });
      return;
    }

    // Schedule notifications if user is authenticated
    if (initializer.isAuthenticated) {
      _scheduleNotifications();
    }

    // Small delay for UX, then navigate
    await Future.delayed(const Duration(milliseconds: 500));
    
    if (!mounted) return;
    
    // Navigate based on auth state
    if (initializer.isAuthenticated) {
      context.go('/home');
    } else {
      context.go('/login');
    }
  }

  void _scheduleNotifications() {
    try {
      ref.read(notificationSchedulerProvider).scheduleAllNotifications();
    } catch (e) {
      debugPrint('Failed to schedule notifications: $e');
    }
  }

  void _retryInitialization() {
    AppInitializer().reset();
    setState(() {
      _hasError = false;
      _errorMessage = '';
      _progress = 0.0;
      _statusMessage = 'Retrying...';
    });
    _initializeApp();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFFFFFFF), // White
              Color(0xFFFFF0F3), // Very soft pink tint
              Color(0xFFFFE4EA), // Light pink
            ],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: ScaleTransition(
                scale: _scaleAnimation,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Logo with text (Asset_2 includes Nana + tagline)
                    _buildLogo(),
                    
                    const SizedBox(height: 60),
                    
                    // Progress or Error
                    if (_hasError)
                      _buildErrorWidget()
                    else
                      _buildProgressWidget(),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLogo() {
    return Image.asset(
      'assets/images/Asset_2.png',
      width: 200,
      height: 280,
      fit: BoxFit.contain,
      errorBuilder: (context, error, stackTrace) {
        // Fallback to icon if image fails
        return Container(
          width: 180,
          height: 180,
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 30,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: const Icon(
            Icons.favorite,
            size: 90,
            color: Color(0xFFE91E63),
          ),
        );
      },
    );
  }

  Widget _buildProgressWidget() {
    return Column(
      children: [
        // Progress bar
        Container(
          width: 240,
          height: 6,
          decoration: BoxDecoration(
            color: const Color(0xFFE91E63).withOpacity(0.1),
            borderRadius: BorderRadius.circular(3),
          ),
          child: Stack(
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                width: 240 * _progress,
                height: 6,
                decoration: BoxDecoration(
                  color: const Color(0xFFE91E63),
                  borderRadius: BorderRadius.circular(3),
                ),
              ),
            ],
          ),
        ),
        
        const SizedBox(height: 16),
        
        // Status message
        Text(
          _statusMessage,
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }

  Widget _buildErrorWidget() {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          margin: const EdgeInsets.symmetric(horizontal: 32),
          decoration: BoxDecoration(
            color: Colors.red.shade50,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.red.shade200),
          ),
          child: Column(
            children: [
              Icon(
                Icons.error_outline,
                color: Colors.red.shade400,
                size: 48,
              ),
              const SizedBox(height: 16),
              Text(
                'Startup Failed',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.red.shade700,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                _errorMessage,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.grey[700],
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: _retryInitialization,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFE91E63),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                ),
                icon: const Icon(Icons.refresh),
                label: const Text('Retry'),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

/// Reusable Logo Widget for AppBar and other screens
class AppLogo extends StatelessWidget {
  final double size;
  final bool showText;
  final bool circleBackground;

  const AppLogo({
    super.key,
    this.size = 40,
    this.showText = false,
    this.circleBackground = false,
  });

  @override
  Widget build(BuildContext context) {
    Widget logoImage = Image.asset(
      'assets/images/patient_logo.png',
      width: size,
      height: size,
      fit: BoxFit.contain,
      errorBuilder: (context, error, stackTrace) {
        return Icon(
          Icons.favorite,
          size: size,
          color: const Color(0xFFE91E63),
        );
      },
    );

    if (circleBackground) {
      logoImage = Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        padding: EdgeInsets.all(size * 0.15),
        child: logoImage,
      );
    }

    if (!showText) {
      return logoImage;
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        logoImage,
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Nana',
              style: TextStyle(
                fontSize: size * 0.45,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF2D3748),
              ),
            ),
            Text(
              'Maternal & Child Health',
              style: TextStyle(
                fontSize: size * 0.25,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      ],
    );
  }
}
