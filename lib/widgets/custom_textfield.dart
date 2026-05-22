/// ============================================================
/// Custom TextField Widget - Reusable Input Field
/// ============================================================
/// A premium styled text field with white fill, rounded corners,
/// primary focused border, and AppColors theming.
/// No hardcoded hex values — uses AppColors throughout.
/// ============================================================

import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class CustomTextField extends StatelessWidget {
  // Controller to read/write the text value
  final TextEditingController controller;

  // Hint text shown when the field is empty
  final String hintText;

  // Icon displayed at the start of the field
  final IconData prefixIcon;

  // Whether to hide the text (for passwords)
  final bool obscureText;

  // Keyboard type (email, number, text, etc.)
  final TextInputType keyboardType;

  // Validation function
  final String? Function(String?)? validator;

  // Optional suffix widget (e.g., toggle password visibility)
  final Widget? suffixIcon;

  // Maximum number of lines
  final int maxLines;

  // Label text (optional)
  final String? labelText;

  const CustomTextField({
    super.key,
    required this.controller,
    required this.hintText,
    required this.prefixIcon,
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
    this.validator,
    this.suffixIcon,
    this.maxLines = 1,
    this.labelText,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 7.0),
      child: TextFormField(
        controller: controller,
        obscureText: obscureText,
        keyboardType: keyboardType,
        maxLines: maxLines,
        validator: validator,
        style: TextStyle(
          fontSize: 15,
          color: AppColors.textPrimary,
          fontWeight: FontWeight.w500,
        ),
        decoration: InputDecoration(
          hintText: hintText,
          labelText: labelText,
          hintStyle: TextStyle(
            color: AppColors.textHint,
            fontSize: 14,
            fontWeight: FontWeight.w400,
          ),
          labelStyle: TextStyle(
            color: AppColors.textSecondary,
            fontSize: 14,
          ),
          floatingLabelStyle: const TextStyle(
            color: AppColors.primary,
            fontSize: 13,
            fontWeight: FontWeight.w500,
          ),

          // Icon at the beginning of the field
          prefixIcon: Icon(
            prefixIcon,
            color: AppColors.primary,
            size: 20,
          ),

          // Optional suffix icon
          suffixIcon: suffixIcon,

          // Dynamic background fill
          filled: true,
          fillColor: AppColors.cardBg,

          // Default border
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: AppColors.border, width: 1),
          ),

          // Enabled (not focused) border
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: AppColors.border, width: 1),
          ),

          // Focused border — primary blue
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
          ),

          // Validation error border
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: AppColors.busy, width: 1.5),
          ),

          // Focused with error border
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: AppColors.busy, width: 1.5),
          ),

          // Content padding
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 14,
          ),

          errorStyle: const TextStyle(
            color: AppColors.busy,
            fontSize: 12,
          ),
        ),
      ),
    );
  }
}
