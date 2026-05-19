/// ============================================================
/// Doctor Card Widget - Reusable Doctor List Item
/// ============================================================
/// Displays a doctor's summary in a beautiful card format.
/// Used in the doctor listing screens (User Home & Home Screen).
/// Features: avatar, name, specialization, availability badge.
/// ============================================================

import 'package:flutter/material.dart';
import '../models/doctor_model.dart';
import 'doctor_info_bottom_sheet.dart';

class DoctorCard extends StatelessWidget {
  // The doctor data to display
  final DoctorModel doctor;

  // Callback when the card is tapped
  final VoidCallback onTap;

  const DoctorCard({
    super.key,
    required this.doctor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: GestureDetector(
        onTap: () {
          // Show Modal Bottom Sheet instead of navigating
          showModalBottomSheet(
            context: context,
            builder: (context) => DoctorInfoBottomSheet(
              doctor: doctor,
            ),
            isScrollControlled: true,
            useSafeArea: true,
          );
        },
        // Animated scale effect on tap
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          child: Card(
            // Card elevation for shadow
            elevation: 3,
            shadowColor: const Color(0xFF0077B6).withOpacity(0.15),

            // Rounded corners
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),

            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                // Subtle gradient background
                gradient: const LinearGradient(
                  colors: [Colors.white, Color(0xFFF8FBFF)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Row(
                children: [
                  // ---- Doctor Avatar ----
                  _buildAvatar(),

                  const SizedBox(width: 16),

                  // ---- Doctor Info ----
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Doctor Name
                        Text(
                          doctor.name,
                          style: const TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1A1A2E),
                          ),
                        ),

                        const SizedBox(height: 4),

                        // Specialization with icon
                        Row(
                          children: [
                            Icon(
                              Icons.medical_services_outlined,
                              size: 15,
                              color: Colors.grey.shade500,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              doctor.specialization,
                              style: TextStyle(
                                fontSize: 13,
                                color: Colors.grey.shade600,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 4),

                        // Experience
                        Row(
                          children: [
                            Icon(
                              Icons.work_outline,
                              size: 15,
                              color: Colors.grey.shade500,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              doctor.experience,
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey.shade500,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  // ---- Availability Badge ----
                  _buildAvailabilityBadge(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// Builds the circular avatar with doctor's initial
  Widget _buildAvatar() {
    // Get first letter of the doctor's name (skip "Dr. ")
    final String initial = doctor.name.replaceFirst('Dr. ', '').isNotEmpty
        ? doctor.name.replaceFirst('Dr. ', '')[0].toUpperCase()
        : 'D';

    return Container(
      width: 56,
      height: 56,
      decoration: BoxDecoration(
        // Gradient circle for the avatar
        gradient: const LinearGradient(
          colors: [Color(0xFF0077B6), Color(0xFF00B4D8)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0077B6).withOpacity(0.25),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Center(
        child: Text(
          initial,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  /// Builds the availability status badge
  Widget _buildAvailabilityBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        // Green for available, red for unavailable
        color: doctor.isAvailable
            ? const Color(0xFFE8F5E9)
            : const Color(0xFFFFEBEE),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: doctor.isAvailable
              ? const Color(0xFF4CAF50)
              : const Color(0xFFE53935),
          width: 0.5,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Status dot
          Container(
            width: 7,
            height: 7,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: doctor.isAvailable
                  ? const Color(0xFF4CAF50)
                  : const Color(0xFFE53935),
            ),
          ),
          const SizedBox(width: 4),
          Text(
            doctor.isAvailable ? 'Available' : 'Busy',
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: doctor.isAvailable
                  ? const Color(0xFF2E7D32)
                  : const Color(0xFFC62828),
            ),
          ),
        ],
      ),
    );
  }
}
