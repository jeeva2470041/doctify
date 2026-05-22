/// ============================================================
/// Custom Dropdown Field Widget - Reusable Selector
/// ============================================================
/// A premium styled dropdown input field that matches the styling
/// of CustomTextField. Automatically respects light/dark themes
/// using AppColors. Resolves the deprecation warning of value
/// property on DropdownButtonFormField.
/// ============================================================

import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class CustomDropdownField extends StatelessWidget {
  final String? value;
  final String hintText;
  final IconData prefixIcon;
  final List<String> items;
  final ValueChanged<String?> onChanged;
  final String? Function(String?)? validator;

  const CustomDropdownField({
    super.key,
    required this.value,
    required this.hintText,
    required this.prefixIcon,
    required this.items,
    required this.onChanged,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    final hasValue = value != null && value!.isNotEmpty;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 7.0),
      child: FormField<String>(
        initialValue: hasValue ? value : null,
        validator: validator,
        builder: (FormFieldState<String> state) {
          // Sync state value when parent value changes (e.g., on reset)
          final currentValue = hasValue ? value : null;
          if (state.value != currentValue) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (state.mounted) {
                state.didChange(currentValue);
              }
            });
          }

          return InputDecorator(
            decoration: InputDecoration(
              hintText: hintText,
              hintStyle: TextStyle(
                color: AppColors.textHint,
                fontSize: 14,
                fontWeight: FontWeight.w400,
              ),
              prefixIcon: Icon(
                prefixIcon,
                color: AppColors.primary,
                size: 20,
              ),
              filled: true,
              fillColor: AppColors.cardBg, // Dynamic background
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: AppColors.border, width: 1),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: AppColors.border, width: 1),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: AppColors.busy, width: 1.5),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: AppColors.busy, width: 1.5),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 14,
              ),
              errorText: state.errorText,
              errorStyle: const TextStyle(
                color: AppColors.busy,
                fontSize: 12,
              ),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: currentValue,
                hint: Text(
                  hintText,
                  style: TextStyle(
                    color: AppColors.textHint,
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                isExpanded: true,
                dropdownColor: AppColors.cardBg,
                icon: const Icon(
                  Icons.keyboard_arrow_down_rounded,
                  color: AppColors.primary,
                ),
                style: TextStyle(
                  fontSize: 15,
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w500,
                ),
                onChanged: (val) {
                  state.didChange(val);
                  onChanged(val);
                },
                items: items.map((item) {
                  return DropdownMenuItem<String>(
                    value: item,
                    child: Text(
                      item,
                      style: TextStyle(
                        color: AppColors.textPrimary,
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          );
        },
      ),
    );
  }
}
