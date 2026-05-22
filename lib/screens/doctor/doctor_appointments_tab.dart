/// ============================================================
/// Doctor Appointments Tab - View & Manage Appointments
/// ============================================================
/// Shows appointments with approve/reject buttons.
/// Uses AppColors throughout — no hardcoded hex values.
/// ============================================================

import 'package:flutter/material.dart';
import '../../models/doctor_model.dart';
import '../../models/appointment_model.dart';
import '../../data/dummy_data.dart';
import '../../theme/app_colors.dart';

class DoctorAppointmentsTab extends StatefulWidget {
  final DoctorModel doctor;

  const DoctorAppointmentsTab({
    super.key,
    required this.doctor,
  });

  @override
  State<DoctorAppointmentsTab> createState() => _DoctorAppointmentsTabState();
}

class _DoctorAppointmentsTabState extends State<DoctorAppointmentsTab> {
  List<AppointmentModel> _getDoctorAppointments() {
    return dummyAppointments
        .where((apt) => apt.doctorId == widget.doctor.id)
        .toList();
  }

  void _updateAppointmentStatus(String appointmentId, String newStatus) {
    final index =
        dummyAppointments.indexWhere((apt) => apt.id == appointmentId);
    if (index != -1) {
      setState(() {
        dummyAppointments[index] =
            dummyAppointments[index].copyWith(status: newStatus);
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('✓ Appointment ${newStatus.toLowerCase()}'),
          backgroundColor: newStatus == 'Approved'
              ? AppColors.available
              : AppColors.busy,
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final appointments = _getDoctorAppointments();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Appointments'),
        automaticallyImplyLeading: false,
      ),
      body: appointments.isEmpty
          ? _buildEmptyState()
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: appointments.length,
              itemBuilder: (context, index) {
                final appointment = appointments[index];
                return _buildAppointmentCard(appointment);
              },
            ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: AppColors.background,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: AppColors.border),
            ),
            child: Icon(
              Icons.calendar_month_outlined,
              size: 40,
              color: AppColors.textHint,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'No appointments yet',
            style: TextStyle(
              fontSize: 16,
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Appointments from patients will appear here',
            style: TextStyle(
              fontSize: 13,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAppointmentCard(AppointmentModel appointment) {
    Color statusColor;
    Color statusBgColor;
    IconData statusIcon;

    if (appointment.status == 'Approved') {
      statusColor = AppColors.available;
      statusBgColor = AppColors.availableBg;
      statusIcon = Icons.check_circle_rounded;
    } else if (appointment.status == 'Rejected') {
      statusColor = AppColors.busy;
      statusBgColor = AppColors.busyBg;
      statusIcon = Icons.cancel_rounded;
    } else {
      statusColor = AppColors.pending;
      statusBgColor = AppColors.pendingBg;
      statusIcon = Icons.schedule_rounded;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: AppColors.cardBg,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ---- Header with Status ----
            Row(
              children: [
                // Patient Avatar
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: AppColors.primaryBg,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.person_rounded,
                    color: AppColors.primary,
                    size: 22,
                  ),
                ),
                const SizedBox(width: 12),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        appointment.patientName,
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        'Age: ${appointment.age}',
                        style: TextStyle(
                          fontSize: 12,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),

                // Status Badge
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: statusBgColor,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(statusIcon, size: 11, color: statusColor),
                      const SizedBox(width: 4),
                      Text(
                        appointment.status,
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: statusColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),
            Divider(height: 1, color: AppColors.divider),
            const SizedBox(height: 12),

            // ---- Details ----
            _buildDetailRow(
                Icons.medical_services_outlined, appointment.symptoms),
            const SizedBox(height: 6),
            _buildDetailRow(
                Icons.calendar_today, appointment.appointmentDate),
            const SizedBox(height: 6),
            _buildDetailRow(
                Icons.timer_outlined, 'Consultation Duration: ${appointment.duration}'),
            const SizedBox(height: 6),
            _buildDetailRow(Icons.phone, appointment.contactNumber),

            // ---- Action Buttons (only for Pending) ----
            if (appointment.status == 'Pending') ...[
              const SizedBox(height: 14),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () => _updateAppointmentStatus(
                          appointment.id, 'Rejected'),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        side: const BorderSide(
                            color: AppColors.busy, width: 1.5),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      icon: const Icon(Icons.close,
                          size: 14, color: AppColors.busy),
                      label: const Text(
                        'Reject',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: AppColors.busy,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () => _updateAppointmentStatus(
                          appointment.id, 'Approved'),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        backgroundColor: AppColors.available,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        elevation: 0,
                      ),
                      icon: const Icon(Icons.check,
                          size: 14, color: Colors.white),
                      label: const Text(
                        'Approve',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 13, color: AppColors.textSecondary),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              fontSize: 12,
              color: AppColors.textSecondary,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
