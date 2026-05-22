/// ============================================================
/// AppColors - Centralized Color Palette
/// ============================================================
/// All color constants for the Doctor Appointment App.
/// Inspired by Practo, Apollo 247 and leading healthcare platforms.
/// ============================================================

import 'package:flutter/material.dart';
import '../services/theme_service.dart';

class AppColors {
  AppColors._(); // Prevent instantiation

  // ---- Primary Brand Colors ----
  static const Color primary = Color(0xFF0A84D0); // Medical Blue
  static const Color primaryLight = Color(0xFF36B4FF); // Light Blue Accent

  // ---- Backgrounds ----
  static Color get background => ThemeService.instance.isDarkMode
      ? const Color(0xFF0F172A) // Slate 900
      : const Color(0xFFF5F7FA); // App Background

  static Color get cardBg => ThemeService.instance.isDarkMode
      ? const Color(0xFF1E293B) // Slate 800
      : Colors.white; // Card Background

  static Color get surfaceLight => ThemeService.instance.isDarkMode
      ? const Color(0xFF1E293B) // Slate 800
      : const Color(0xFFF0F7FF); // Light blue tint surface

  // ---- Status Colors ----
  static const Color available = Color(0xFF34C759); // Available / Success
  static const Color busy = Color(0xFFFF3B30); // Busy / Rejected
  static const Color pending = Color(0xFFFF9500); // Pending / Warning

  // ---- Text Colors ----
  static Color get textPrimary => ThemeService.instance.isDarkMode
      ? const Color(0xFFF1F5F9) // Slate 100
      : const Color(0xFF1C1C1E); // Primary Text

  static Color get textSecondary => ThemeService.instance.isDarkMode
      ? const Color(0xFF94A3B8) // Slate 400
      : const Color(0xFF6E6E73); // Secondary Text

  static Color get textHint => ThemeService.instance.isDarkMode
      ? const Color(0xFF64748B) // Slate 500
      : const Color(0xFF8E8E93); // Hint / Placeholder Text

  // ---- Border Colors ----
  static Color get border => ThemeService.instance.isDarkMode
      ? const Color(0xFF334155) // Slate 700
      : const Color(0xFFE5E5EA); // Default Border

  static Color get divider => ThemeService.instance.isDarkMode
      ? const Color(0xFF334155) // Slate 700
      : const Color(0xFFF2F2F7); // Divider

  // ---- Semantic Backgrounds (status at 12% opacity) ----
  static Color get availableBg => available.withOpacity(0.12);
  static Color get busyBg => busy.withOpacity(0.12);
  static Color get pendingBg => pending.withOpacity(0.12);
  static Color get primaryBg => primary.withOpacity(0.08);

  // ---- Shadow Colors ----
  static Color get shadowPrimary => primary.withOpacity(0.25);
  static Color get shadowCard => ThemeService.instance.isDarkMode
      ? Colors.black.withOpacity(0.25)
      : Colors.black.withOpacity(0.08);

  // ---- Gradient ----
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [primary, primaryLight],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient primaryGradientV = LinearGradient(
    colors: [primary, primaryLight],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );
}
