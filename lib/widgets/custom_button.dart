/// ============================================================
/// Custom Button Widget - Reusable Action Button
/// ============================================================
/// A beautifully styled button that can be reused across
/// all screens. Features: gradient background, rounded corners,
/// loading state, and elevation.
/// ============================================================

import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  // Text displayed on the button
  final String text;

  // Function called when button is pressed
  final VoidCallback onPressed;

  // Background color (defaults to primary blue)
  final Color? backgroundColor;

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

  const CustomButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.backgroundColor,
    this.textColor = Colors.white,
    this.isLoading = false,
    this.isOutlined = false,
    this.icon,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    // Default gradient colors
    final Color bgColor = backgroundColor ?? const Color(0xFF0077B6);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: SizedBox(
        width: width ?? double.infinity,
        height: 54,
        child: isOutlined
            ? _buildOutlinedButton(bgColor)
            : _buildFilledButton(bgColor),
      ),
    );
  }

  /// Builds a filled/gradient button
  Widget _buildFilledButton(Color bgColor) {
    return Container(
      decoration: BoxDecoration(
        // Gradient background for a premium look
        gradient: LinearGradient(
          colors: [
            bgColor,
            bgColor.withOpacity(0.8),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(14),
        // Soft shadow for elevation effect
        boxShadow: [
          BoxShadow(
            color: bgColor.withOpacity(0.3),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
        child: isLoading
            ? const SizedBox(
                height: 22,
                width: 22,
                child: CircularProgressIndicator(
                  strokeWidth: 2.5,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (icon != null) ...[
                    Icon(icon, color: textColor, size: 20),
                    const SizedBox(width: 8),
                  ],
                  Text(
                    text,
                    style: TextStyle(
                      color: textColor,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.5,
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  /// Builds an outlined/border button
  Widget _buildOutlinedButton(Color bgColor) {
    return OutlinedButton(
      onPressed: isLoading ? null : onPressed,
      style: OutlinedButton.styleFrom(
        side: BorderSide(color: bgColor, width: 1.5),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
        ),
      ),
      child: isLoading
          ? SizedBox(
              height: 22,
              width: 22,
              child: CircularProgressIndicator(
                strokeWidth: 2.5,
                valueColor: AlwaysStoppedAnimation<Color>(bgColor),
              ),
            )
          : Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (icon != null) ...[
                  Icon(icon, color: bgColor, size: 20),
                  const SizedBox(width: 8),
                ],
                Text(
                  text,
                  style: TextStyle(
                    color: bgColor,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.5,
                  ),
                ),
              ],
            ),
    );
  }
}
