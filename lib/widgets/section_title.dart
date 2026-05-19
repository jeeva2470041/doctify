/// ============================================================
/// Section Title Widget - Reusable Heading
/// ============================================================
/// A styled heading widget for consistent section titles
/// across all screens. Supports an optional action button.
/// ============================================================

import 'package:flutter/material.dart';

class SectionTitle extends StatelessWidget {
  // The title text
  final String title;

  // Optional subtitle
  final String? subtitle;

  // Optional trailing action (e.g., "View All")
  final Widget? trailing;

  const SectionTitle({
    super.key,
    required this.title,
    this.subtitle,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Title and subtitle column
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1A1A2E),
                ),
              ),
              if (subtitle != null) ...[
                const SizedBox(height: 2),
                Text(
                  subtitle!,
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey.shade500,
                  ),
                ),
              ],
            ],
          ),

          // Optional trailing widget
          if (trailing != null) trailing!,
        ],
      ),
    );
  }
}
