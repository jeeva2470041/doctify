/// ============================================================
/// Doctor Card Widget - Reusable Doctor List Item
/// ============================================================
/// Displays a doctor's summary in a premium card format.
/// Uses AppColors — no hardcoded hex values.
/// Features: avatar, name, specialization, availability badge, soft shadow.
/// ============================================================

import 'package:flutter/material.dart';
import '../models/doctor_model.dart';
import '../theme/app_colors.dart';
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
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            showModalBottomSheet(
              context: context,
              builder: (context) => DoctorInfoBottomSheet(
                doctor: doctor,
                isFavorite: false,
                onToggleFavorite: (_) {},
              ),
              isScrollControlled: true,
              useSafeArea: true,
              backgroundColor: Colors.transparent,
            );
          },
          borderRadius: BorderRadius.circular(16),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.07),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
                BoxShadow(
                  color: AppColors.primary.withOpacity(0.04),
                  blurRadius: 6,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              children: [
                // ---- Doctor Avatar ----
                _buildAvatar(),

                const SizedBox(width: 14),

                // ---- Doctor Info ----
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Doctor Name
                      Text(
                        doctor.name,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),

                      const SizedBox(height: 4),

                      // Specialization with icon
                      Row(
                        children: [
                          Icon(
                            Icons.medical_services_outlined,
                            size: 13,
                            color: AppColors.textSecondary,
                          ),
                          const SizedBox(width: 4),
                          Flexible(
                            child: Text(
                              doctor.specialization,
                              style: TextStyle(
                                fontSize: 13,
                                color: AppColors.textSecondary,
                                fontWeight: FontWeight.w500,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 4),

                      // Experience + Rating row
                      Row(
                        children: [
                          const Icon(
                            Icons.star_rounded,
                            size: 13,
                            color: Color(0xFFFF9500),
                          ),
                          const SizedBox(width: 2),
                          Text(
                            doctor.rating.toString(),
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Icon(
                            Icons.work_outline,
                            size: 12,
                            color: AppColors.textSecondary,
                          ),
                          const SizedBox(width: 3),
                          Flexible(
                            child: Text(
                              doctor.experience,
                              style: TextStyle(
                                fontSize: 12,
                                color: AppColors.textSecondary,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(width: 8),

                // ---- Availability Badge ----
                _buildAvailabilityBadge(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Builds the circular avatar with doctor's initial
  Widget _buildAvatar() {
    final String initial = doctor.name.replaceFirst('Dr. ', '').isNotEmpty
        ? doctor.name.replaceFirst('Dr. ', '')[0].toUpperCase()
        : 'D';

    return Container(
      width: 56,
      height: 56,
      decoration: BoxDecoration(
        gradient: AppColors.primaryGradient,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.22),
            blurRadius: 10,
            offset: const Offset(0, 4),
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
    final isAvail = doctor.isAvailable;
    final color = isAvail ? AppColors.available : AppColors.busy;
    final bgColor = isAvail ? AppColors.availableBg : AppColors.busyBg;
    final label = isAvail ? 'Available' : 'Busy';

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Pulsing dot
          Container(
            width: 7,
            height: 7,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: color,
            ),
          ),
          const SizedBox(width: 5),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}
