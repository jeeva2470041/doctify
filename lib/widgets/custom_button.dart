/// ============================================================
/// Custom Button Widget - Reusable Action Button
/// ============================================================
/// A premium styled button with gradient background, rounded corners,
/// loading state, soft shadow, and ripple effect.
/// Uses AppColors — no hardcoded hex values.
/// ============================================================

import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class CustomButton extends StatelessWidget {
  // Text displayed on the button
  final String text;

  // Function called when button is pressed
  final VoidCallback onPressed;

  // Custom gradient override (defaults to primary → primaryLight)
  final List<Color>? gradientColors;

  // Text color (defaults to white)
  final Color textColor;

  // Whether the button is in loading state
  final bool isLoading;

  // Whether to use outline style instead of filled
  final bool isOutlined;

  // Icon to show before text (optional)
  final IconData? icon;

  // Width of the button (null = match parent)
  final double? width;

  // Height of the button
  final double height;

  // Border radius
  final double borderRadius;

  const CustomButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.gradientColors,
    this.textColor = Colors.white,
    this.isLoading = false,
    this.isOutlined = false,
    this.icon,
    this.width,
    this.height = 54,
    this.borderRadius = 14,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: SizedBox(
        width: width ?? double.infinity,
        height: height,
        child: isOutlined
            ? _buildOutlinedButton()
            : _buildFilledButton(),
      ),
    );
  }

  /// Builds a gradient filled button
  Widget _buildFilledButton() {
    final colors = gradientColors ?? [AppColors.primary, AppColors.primaryLight];

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: colors,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(borderRadius),
        boxShadow: [
          BoxShadow(
            color: colors[0].withOpacity(0.30),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: isLoading ? null : onPressed,
          borderRadius: BorderRadius.circular(borderRadius),
          splashColor: Colors.white.withOpacity(0.15),
          highlightColor: Colors.white.withOpacity(0.10),
          child: Center(child: _buildContent(colors[0])),
        ),
      ),
    );
  }

  /// Builds an outlined border button
  Widget _buildOutlinedButton() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(borderRadius),
        border: Border.all(color: AppColors.primary, width: 1.5),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: isLoading ? null : onPressed,
          borderRadius: BorderRadius.circular(borderRadius),
          splashColor: AppColors.primary.withOpacity(0.08),
          highlightColor: AppColors.primary.withOpacity(0.04),
          child: Center(child: _buildContent(AppColors.primary)),
        ),
      ),
    );
  }

  Widget _buildContent(Color color) {
    if (isLoading) {
      return SizedBox(
        height: 22,
        width: 22,
        child: CircularProgressIndicator(
          strokeWidth: 2.5,
          valueColor: AlwaysStoppedAnimation<Color>(
            isOutlined ? AppColors.primary : Colors.white,
          ),
        ),
      );
    }

    final textCol = isOutlined ? AppColors.primary : textColor;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (icon != null) ...[
          Icon(icon, color: textCol, size: 20),
          const SizedBox(width: 8),
        ],
        Text(
          text,
          style: TextStyle(
            color: textCol,
            fontSize: 16,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.3,
          ),
        ),
      ],
    );
  }
}
