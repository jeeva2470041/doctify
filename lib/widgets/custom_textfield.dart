/// ============================================================
/// Custom TextField Widget - Reusable Input Field
/// ============================================================
/// A beautifully styled text field that can be reused across
/// all login, registration, and form screens.
/// Features: rounded corners, prefix icon, validation support.
/// ============================================================

import 'package:flutter/material.dart';

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
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      // Add vertical spacing between text fields
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: controller,
        obscureText: obscureText,
        keyboardType: keyboardType,
        maxLines: maxLines,
        validator: validator,

        // Style the input text
        style: const TextStyle(
          fontSize: 15,
          color: Color(0xFF1A1A2E),
        ),

        // Decoration for the text field appearance
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: TextStyle(
            color: Colors.grey.shade400,
            fontSize: 14,
          ),

          // Icon at the beginning of the field
          prefixIcon: Icon(
            prefixIcon,
            color: const Color(0xFF0077B6),
            size: 22,
          ),

          // Optional suffix icon
          suffixIcon: suffixIcon,

          // Background fill color
          filled: true,
          fillColor: const Color(0xFFF0F4F8),

          // Border styling - rounded corners
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide.none,
          ),

          // When the field is focused
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(
              color: Color(0xFF0077B6),
              width: 1.5,
            ),
          ),

          // When there's a validation error
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(
              color: Colors.redAccent,
              width: 1.5,
            ),
          ),

          // When focused with an error
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(
              color: Colors.redAccent,
              width: 1.5,
            ),
          ),

          // Content padding inside the field
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 16,
          ),
        ),
      ),
    );
  }
}
