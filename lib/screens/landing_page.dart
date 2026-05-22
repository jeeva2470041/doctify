/// ============================================================
/// Landing Page - Role Selection Screen
/// ============================================================
/// After the splash screen, users land here to choose their role:
///   1. Login as Doctor
///   2. Login as User
/// Features a premium, interactive UI with ambient glows and a
/// floating theme toggle button.
/// ============================================================

import 'dart:math' show sin, cos, pi;
import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../services/theme_service.dart';
import 'login/doctor_login_screen.dart';
import 'login/user_login_screen.dart';

class LandingPage extends StatefulWidget {
  const LandingPage({super.key});

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> with SingleTickerProviderStateMixin {
  late AnimationController _driftController;

  @override
  void initState() {
    super.initState();
    // A slow controller to animate the drifting background bubbles and breathing logo
    _driftController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    )..repeat();
  }

  @override
  void dispose() {
    _driftController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: ThemeService.instance.themeModeNotifier,
      builder: (context, mode, _) {
        final isDark = mode == ThemeMode.dark;

        return Scaffold(
          backgroundColor: AppColors.background,
          body: Stack(
            children: [
              // ---- Decorative Ambient Drifting Glows ----
              AnimatedBuilder(
                animation: _driftController,
                builder: (context, child) {
                  final angle = _driftController.value * 2 * pi;
                  
                  // Bubble 1 moves in a slow circle
                  final dx1 = 35.0 * sin(angle);
                  final dy1 = 35.0 * cos(angle);
                  
                  // Bubble 2 moves offset in another circle
                  final dx2 = 45.0 * cos(angle + 1.57);
                  final dy2 = 45.0 * sin(angle + 1.57);

                  return Stack(
                    children: [
                      // Top Left Bubble
                      Positioned(
                        top: -120 + dy1,
                        left: -120 + dx1,
                        child: Container(
                          width: 360,
                          height: 360,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.primary.withOpacity(isDark ? 0.16 : 0.12),
                                blurRadius: 180,
                                spreadRadius: 90,
                              ),
                            ],
                          ),
                        ),
                      ),
                      // Bottom Right Bubble
                      Positioned(
                        bottom: -150 + dy2,
                        right: -150 + dx2,
                        child: Container(
                          width: 380,
                          height: 380,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xFF64CFFF).withOpacity(isDark ? 0.14 : 0.10),
                                blurRadius: 200,
                                spreadRadius: 100,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),

              // ---- Main Content ----
              SafeArea(
                child: Center(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(height: 48),

                        // ---- Header Icon / Logo (Breathing Animation) ----
                        StaggeredEntrance(
                          delay: Duration.zero,
                          child: Center(
                            child: AnimatedBuilder(
                              animation: _driftController,
                              builder: (context, child) {
                                final pulse = 1.0 + 0.03 * sin(_driftController.value * 2 * pi);
                                return Transform.scale(
                                  scale: pulse,
                                  child: child,
                                );
                              },
                              child: Container(
                                width: 104,
                                height: 104,
                                decoration: BoxDecoration(
                                  gradient: AppColors.primaryGradient,
                                  borderRadius: BorderRadius.circular(28),
                                  boxShadow: [
                                    BoxShadow(
                                      color: AppColors.primary.withOpacity(isDark ? 0.40 : 0.25),
                                      blurRadius: 28,
                                      offset: const Offset(0, 10),
                                    ),
                                  ],
                                ),
                                child: const Icon(
                                  Icons.local_hospital_rounded,
                                  size: 52,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 32),

                        // ---- App Title ----
                        StaggeredEntrance(
                          delay: const Duration(milliseconds: 150),
                          child: Text(
                            'Dockify',
                            style: TextStyle(
                              fontSize: 38,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textPrimary,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ),

                        const SizedBox(height: 8),

                        // ---- Subtitle ----
                        StaggeredEntrance(
                          delay: const Duration(milliseconds: 250),
                          child: Text(
                            'Choose how you want to continue',
                            style: TextStyle(
                              fontSize: 16,
                              color: AppColors.textSecondary,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),

                        const SizedBox(height: 48),

                        // ---- Doctor Login Card ----
                        StaggeredEntrance(
                          delay: const Duration(milliseconds: 400),
                          child: InteractiveRoleCard(
                            icon: Icons.medical_services_rounded,
                            title: 'Login as Doctor',
                            subtitle: 'Manage your profile and availability',
                            gradientColors: const [AppColors.primary, AppColors.primaryLight],
                            isDark: isDark,
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const DoctorLoginScreen(),
                                ),
                              );
                            },
                          ),
                        ),

                        const SizedBox(height: 20),

                        // ---- User/Patient Login Card ----
                        StaggeredEntrance(
                          delay: const Duration(milliseconds: 550),
                          child: InteractiveRoleCard(
                            icon: Icons.person_rounded,
                            title: 'Login as Patient',
                            subtitle: 'Browse and book the best doctors',
                            gradientColors: const [
                              AppColors.primaryLight,
                              Color(0xFF64CFFF),
                            ],
                            isDark: isDark,
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const UserLoginScreen(),
                                ),
                              );
                            },
                          ),
                        ),

                        const SizedBox(height: 56),

                        // ---- Footer Text ----
                        StaggeredEntrance(
                          delay: const Duration(milliseconds: 700),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                width: 24,
                                height: 1,
                                color: AppColors.border,
                              ),
                              const SizedBox(width: 12),
                              Text(
                                'Your Health, Our Priority',
                                style: TextStyle(
                                  fontSize: 13,
                                  color: AppColors.textHint,
                                  fontStyle: FontStyle.italic,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Container(
                                width: 24,
                                height: 1,
                                color: AppColors.border,
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 32),
                      ],
                    ),
                  ),
                ),
              ),

              // ---- Premium Day/Night Switch Float ----
              Positioned(
                top: 24,
                right: 24,
                child: SafeArea(
                  child: ThemeModeSlider(
                    isDark: isDark,
                    onChanged: (val) => ThemeService.instance.toggleTheme(val),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

/// ============================================================
/// InteractiveRoleCard - Card with stateful hover effects
/// ============================================================
class InteractiveRoleCard extends StatefulWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final List<Color> gradientColors;
  final bool isDark;
  final VoidCallback onTap;

  const InteractiveRoleCard({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.gradientColors,
    required this.isDark,
    required this.onTap,
  });

  @override
  State<InteractiveRoleCard> createState() => _InteractiveRoleCardState();
}

class _InteractiveRoleCardState extends State<InteractiveRoleCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final activeGlowColor = widget.gradientColors[0];

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOutCubic,
        transform: Matrix4.identity()
          ..translate(_isHovered ? -2.0 : 0.0, _isHovered ? -4.0 : 0.0, 0.0)
          ..scale(_isHovered ? 1.025 : 1.0),
        width: double.infinity,
        decoration: BoxDecoration(
          color: widget.isDark
              ? (_isHovered ? const Color(0xFF24334C) : AppColors.cardBg)
              : (_isHovered ? const Color(0xFFF9FBFF) : AppColors.cardBg),
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: _isHovered
                  ? activeGlowColor.withOpacity(widget.isDark ? 0.25 : 0.15)
                  : Colors.transparent,
              blurRadius: _isHovered ? 24 : 0,
              spreadRadius: _isHovered ? 2 : 0,
              offset: _isHovered ? const Offset(0, 10) : Offset.zero,
            ),
            BoxShadow(
              color: Colors.black.withOpacity(widget.isDark ? 0.25 : 0.06),
              blurRadius: _isHovered ? 15 : 10,
              offset: const Offset(0, 4),
            ),
          ],
          border: Border.all(
            color: _isHovered
                ? activeGlowColor.withOpacity(0.8)
                : AppColors.border,
            width: _isHovered ? 2.0 : 1.0,
          ),
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: widget.onTap,
            borderRadius: BorderRadius.circular(24),
            hoverColor: Colors.transparent,
            splashColor: activeGlowColor.withOpacity(0.15),
            highlightColor: activeGlowColor.withOpacity(0.08),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 24),
              child: Row(
                children: [
                  // Icon container with gradient
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 250),
                    curve: Curves.easeOutCubic,
                    width: 68,
                    height: 68,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: widget.gradientColors,
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: activeGlowColor.withOpacity(_isHovered ? 0.5 : 0.3),
                          blurRadius: _isHovered ? 16 : 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    transform: Matrix4.identity()
                      ..scale(_isHovered ? 1.05 : 1.0),
                    child: Icon(widget.icon, color: Colors.white, size: 32),
                  ),

                  const SizedBox(width: 20),

                  // Text content
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.title,
                          style: TextStyle(
                            fontSize: 19,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          widget.subtitle,
                          style: TextStyle(
                            fontSize: 13.5,
                            color: AppColors.textSecondary,
                            fontWeight: FontWeight.w400,
                            height: 1.35,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(width: 12),

                  // Arrow icon
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 250),
                    curve: Curves.easeOutCubic,
                    width: 38,
                    height: 38,
                    transform: Matrix4.identity()
                      ..translate(_isHovered ? 4.0 : 0.0, 0.0, 0.0),
                    decoration: BoxDecoration(
                      color: _isHovered
                          ? activeGlowColor.withOpacity(widget.isDark ? 0.25 : 0.15)
                          : activeGlowColor.withOpacity(widget.isDark ? 0.12 : 0.06),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      Icons.arrow_forward_ios_rounded,
                      color: activeGlowColor,
                      size: 14,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// ============================================================
/// ThemeModeSlider - Premium sliding toggle switch for Dark Mode
/// ============================================================
class ThemeModeSlider extends StatelessWidget {
  final bool isDark;
  final ValueChanged<bool> onChanged;

  const ThemeModeSlider({
    super.key,
    required this.isDark,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onChanged(!isDark),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeInOutBack,
        width: 88,
        height: 44,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          color: isDark ? const Color(0xFF1E293B) : const Color(0xFFE2E8F0),
          border: Border.all(
            color: isDark ? const Color(0xFF334155) : const Color(0xFFCBD5E1),
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(isDark ? 0.3 : 0.08),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Stack(
          children: [
            // Slide transition knob
            AnimatedAlign(
              duration: const Duration(milliseconds: 350),
              curve: Curves.easeInOutBack,
              alignment: isDark ? Alignment.centerRight : Alignment.centerLeft,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4.0),
                child: Container(
                  width: 34,
                  height: 34,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: isDark
                        ? const LinearGradient(
                            colors: [Color(0xFF312E81), Color(0xFF4F46E5)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          )
                        : const LinearGradient(
                            colors: [Color(0xFFF59E0B), Color(0xFFFBBF24)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                    boxShadow: [
                      BoxShadow(
                        color: isDark
                            ? const Color(0xFF4F46E5).withOpacity(0.5)
                            : const Color(0xFFF59E0B).withOpacity(0.5),
                        blurRadius: 6,
                        spreadRadius: 1,
                      ),
                    ],
                  ),
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 250),
                    child: Icon(
                      isDark ? Icons.dark_mode_rounded : Icons.light_mode_rounded,
                      key: ValueKey<bool>(isDark),
                      color: Colors.white,
                      size: 18,
                    ),
                  ),
                ),
              ),
            ),

            // Icons in track
            Positioned.fill(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 12.0),
                    child: Icon(
                      Icons.light_mode_outlined,
                      size: 14,
                      color: isDark ? Colors.white30 : Colors.transparent,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 12.0),
                    child: Icon(
                      Icons.dark_mode_outlined,
                      size: 14,
                      color: isDark ? Colors.transparent : Colors.black26,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// ============================================================
/// StaggeredEntrance - Staggered fade and slide-up animation
/// ============================================================
class StaggeredEntrance extends StatefulWidget {
  final Widget child;
  final Duration delay;
  final Duration duration;

  const StaggeredEntrance({
    super.key,
    required this.child,
    required this.delay,
    this.duration = const Duration(milliseconds: 600),
  });

  @override
  State<StaggeredEntrance> createState() => _StaggeredEntranceState();
}

class _StaggeredEntranceState extends State<StaggeredEntrance> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _opacity;
  late Animation<double> _slide;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: widget.duration);
    _opacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );
    _slide = Tween<double>(begin: 30.0, end: 0.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic),
    );

    Future.delayed(widget.delay, () {
      if (mounted) {
        _controller.forward();
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
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Opacity(
          opacity: _opacity.value,
          child: Transform.translate(
            offset: Offset(0, _slide.value),
            child: child,
          ),
        );
      },
      child: widget.child,
    );
  }
}
