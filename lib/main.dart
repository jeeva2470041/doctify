/// ============================================================
/// Doctor Info App - Main Entry Point
/// ============================================================
/// This is the root of the application. It sets up:
///   - Material App configuration
///   - Centralized AppTheme (Medical Blue premium palette)
///   - Firebase initialization
///   - Local Theme persistence initialization
///   - Initial route (Splash Screen)
/// ============================================================

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'screens/splash_screen.dart';
import 'services/firebase_service.dart';
import 'services/theme_service.dart';
import 'theme/app_theme.dart';
import 'theme/app_colors.dart';

void main() async {
  // Ensure Flutter is initialized
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  await FirebaseService().initializeFirebase();

  // Initialize local theme settings
  await ThemeService.instance.init();

  // Set the status bar style initially
  _updateSystemUI();

  runApp(const DoctorInfoApp());
}

void _updateSystemUI() {
  final isDark = ThemeService.instance.isDarkMode;
  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: isDark ? Brightness.light : Brightness.dark,
      statusBarBrightness: isDark ? Brightness.dark : Brightness.light,
      systemNavigationBarColor: AppColors.background,
      systemNavigationBarIconBrightness: isDark ? Brightness.light : Brightness.dark,
    ),
  );
}

/// Root widget of the application
class DoctorInfoApp extends StatelessWidget {
  const DoctorInfoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: ThemeService.instance.themeModeNotifier,
      builder: (context, themeMode, _) {
        // Dynamic UI overlay updates on theme changes
        _updateSystemUI();

        return MaterialApp(
          // App title shown in task switcher
          title: 'Dockify - Doctor Appointments',

          // Remove the debug banner
          debugShowCheckedModeBanner: false,

          // ---- Centralized Theme ----
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: themeMode,

          // ---- Start with Splash Screen ----
          home: const SplashScreen(),
        );
      },
    );
  }
}
