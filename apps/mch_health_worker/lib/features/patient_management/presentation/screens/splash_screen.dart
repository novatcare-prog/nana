import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // For status bar styling
import 'package:mch_health_worker/main.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    // 1. Hide status bar for full immersion (Optional)
    // SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);

    _controller = AnimationController(
      duration: const Duration(milliseconds: 2500),
      vsync: this,
    )..forward();

    // Smooth fade in
    _fadeAnimation = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.0, 0.6, curve: Curves.easeIn),
    );

    // Gentle scale up effect for the logo
    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.5, curve: Curves.easeOutBack),
      ),
    );

    // 2. Navigation Timer
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        // Restore status bar overlay if you hid it
        // SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);

        Navigator.of(context).pushReplacement(
          PageRouteBuilder(
            pageBuilder: (_, __, ___) => const AuthGate(),
            transitionDuration: const Duration(milliseconds: 800),
            transitionsBuilder: (_, a, __, c) =>
                FadeTransition(opacity: a, child: c),
          ),
        );
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // 3. Gradient Background (Matches the logo's "Clean/Health" vibe)
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.white,
              Colors.blue.shade50, // Very subtle blue tint at bottom
            ],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Spacer(flex: 2), // Pushes content slightly up

                // LOGO ANIMATION
                ScaleTransition(
                  scale: _scaleAnimation,
                  child: Container(
                    height: 180,
                    width: 180,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.blue.withOpacity(0.15),
                          blurRadius: 30,
                          offset: const Offset(0, 15),
                        ),
                      ],
                    ),
                    padding: EdgeInsets.zero,
                    child: ClipOval(
                      child: Image.asset(
                        'assets/images/BLUE_app_launcher_ICON-01.png',
                        fit: BoxFit.cover,
                        // If the logo fails to load, this prevents a crash
                        errorBuilder: (c, o, s) => const Icon(
                            Icons.local_hospital,
                            size: 60,
                            color: Colors.blue),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                // TEXT ANIMATION
                FadeTransition(
                  opacity: _fadeAnimation,
                  child: Column(
                    children: [
                      const Text(
                        'Nana',
                        style: TextStyle(
                          fontSize: 48,
                          fontWeight: FontWeight.bold,
                          color:
                              Color(0xFF2196F3), // Match your logo blue exactly
                          // ✅ FIX: Height property prevents clipping of 'g', 'y', etc.
                          height: 1.2,
                          letterSpacing: -0.5,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Maternal Care Companion',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey.shade600,
                          letterSpacing: 1.2,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),

                const Spacer(flex: 3),

                // LOADING INDICATOR
                FadeTransition(
                  opacity: _fadeAnimation,
                  child: const SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.5,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                    ),
                  ),
                ),

                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
