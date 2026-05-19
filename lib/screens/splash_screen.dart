import 'package:flutter/material.dart';
import 'landing_page.dart';

/// Splash Screen - App Entry Point with animated logo and auto-navigation
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnim;
  late Animation<double> _scaleAnim;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 1500));
    _fadeAnim = Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
    _scaleAnim = Tween<double>(begin: 0.5, end: 1.0).animate(CurvedAnimation(parent: _controller, curve: Curves.elasticOut));
    _controller.forward();

    // Auto-navigate after 3 seconds
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        Navigator.pushReplacement(context, PageRouteBuilder(
          pageBuilder: (_, __, ___) => const LandingPage(),
          transitionsBuilder: (_, anim, __, child) => FadeTransition(opacity: anim, child: child),
          transitionDuration: const Duration(milliseconds: 500),
        ));
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
      body: Container(
        width: double.infinity, height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [Color(0xFF0077B6), Color(0xFF00B4D8), Color(0xFF48CAE4)]),
        ),
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          // Animated Logo
          AnimatedBuilder(
            animation: _controller,
            builder: (context, child) => Opacity(
              opacity: _fadeAnim.value,
              child: Transform.scale(scale: _scaleAnim.value, child: child),
            ),
            child: Container(
              width: 120, height: 120,
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(30), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.15), blurRadius: 20, offset: const Offset(0, 8))]),
              child: const Icon(Icons.local_hospital_rounded, size: 60, color: Color(0xFF0077B6)),
            ),
          ),
          const SizedBox(height: 30),
          FadeTransition(opacity: _fadeAnim, child: const Text('Doctor Info App', style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.white, letterSpacing: 1.2))),
          const SizedBox(height: 8),
          FadeTransition(opacity: _fadeAnim, child: Text('Your Health, Our Priority', style: TextStyle(fontSize: 16, color: Colors.white.withOpacity(0.85), letterSpacing: 0.5))),
          const SizedBox(height: 60),
          FadeTransition(opacity: _fadeAnim, child: const SizedBox(width: 36, height: 36, child: CircularProgressIndicator(strokeWidth: 3, valueColor: AlwaysStoppedAnimation<Color>(Colors.white)))),
        ]),
      ),
    );
  }
}
