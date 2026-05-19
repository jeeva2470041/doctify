/// ============================================================
/// Landing Page - Role Selection Screen
/// ============================================================
/// After the splash screen, users land here to choose their role:
///   1. Login as Doctor
///   2. Login as User
/// Features an attractive UI with cards and icons.
/// ============================================================

import 'package:flutter/material.dart';
import 'login/doctor_login_screen.dart';
import 'login/user_login_screen.dart';

class LandingPage extends StatelessWidget {
  const LandingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          // Soft gradient background
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFE8F4FD),
              Colors.white,
              Color(0xFFF0F8FF),
            ],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              children: [
                const SizedBox(height: 50),

                // ---- Header Icon ----
                Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF0077B6), Color(0xFF00B4D8)],
                    ),
                    borderRadius: BorderRadius.circular(25),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF0077B6).withOpacity(0.3),
                        blurRadius: 20,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.local_hospital_rounded,
                    size: 50,
                    color: Colors.white,
                  ),
                ),

                const SizedBox(height: 30),

                // ---- App Title ----
                const Text(
                  'Doctor Info App',
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1A1A2E),
                  ),
                ),

                const SizedBox(height: 8),

                // ---- Subtitle ----
                Text(
                  'Choose how you want to continue',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey.shade500,
                  ),
                ),

                const SizedBox(height: 50),

                // ---- Doctor Login Card ----
                _buildRoleCard(
                  context: context,
                  icon: Icons.medical_services_rounded,
                  title: 'Login as Doctor',
                  subtitle: 'Manage your profile and availability',
                  gradientColors: [
                    const Color(0xFF0077B6),
                    const Color(0xFF00B4D8),
                  ],
                  onTap: () {
                    // Navigate to Doctor Login Screen
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const DoctorLoginScreen(),
                      ),
                    );
                  },
                ),

                const SizedBox(height: 20),

                // ---- User Login Card ----
                _buildRoleCard(
                  context: context,
                  icon: Icons.person_rounded,
                  title: 'Login as User',
                  subtitle: 'Browse and find the best doctors',
                  gradientColors: [
                    const Color(0xFF00B4D8),
                    const Color(0xFF48CAE4),
                  ],
                  onTap: () {
                    // Navigate to User Login Screen
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const UserLoginScreen(),
                      ),
                    );
                  },
                ),

                const SizedBox(height: 40),

                // ---- Footer Text ----
                Text(
                  'Your Health, Our Priority',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey.shade400,
                    fontStyle: FontStyle.italic,
                  ),
                ),

                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Builds a beautiful role selection card
  Widget _buildRoleCard({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String subtitle,
    required List<Color> gradientColors,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: gradientColors[0].withOpacity(0.12),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
          border: Border.all(
            color: gradientColors[0].withOpacity(0.1),
            width: 1,
          ),
        ),
        child: Row(
          children: [
            // Icon container with gradient
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: gradientColors),
                borderRadius: BorderRadius.circular(18),
                boxShadow: [
                  BoxShadow(
                    color: gradientColors[0].withOpacity(0.3),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Icon(icon, color: Colors.white, size: 30),
            ),

            const SizedBox(width: 20),

            // Text content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1A1A2E),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey.shade500,
                    ),
                  ),
                ],
              ),
            ),

            // Arrow icon
            Icon(
              Icons.arrow_forward_ios_rounded,
              color: gradientColors[0],
              size: 20,
            ),
          ],
        ),
      ),
    );
  }
}
