import 'package:flutter/material.dart';
import '../../models/doctor_model.dart';

/// Doctor Details Screen - Full profile view of a doctor
class DoctorDetailsScreen extends StatelessWidget {
  final DoctorModel doctor;
  const DoctorDetailsScreen({super.key, required this.doctor});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F9FC),
      body: CustomScrollView(
        slivers: [
          // Gradient App Bar with doctor info
          SliverAppBar(
            expandedHeight: 220,
            pinned: true,
            backgroundColor: const Color(0xFF0077B6),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios_rounded, color: Colors.white),
              onPressed: () => Navigator.pop(context),
            ),
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [Color(0xFF0077B6), Color(0xFF00B4D8), Color(0xFF48CAE4)]),
                ),
                child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                  const SizedBox(height: 40),
                  // Doctor Avatar
                  Container(
                    width: 80, height: 80,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(22),
                      border: Border.all(color: Colors.white.withOpacity(0.4), width: 2),
                    ),
                    child: Center(child: Text(doctor.name.replaceFirst('Dr. ', '')[0].toUpperCase(), style: const TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold))),
                  ),
                  const SizedBox(height: 12),
                  Text(doctor.name, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white)),
                  const SizedBox(height: 4),
                  Text(doctor.specialization, style: TextStyle(fontSize: 14, color: Colors.white.withOpacity(0.85))),
                ]),
              ),
            ),
          ),

          // Doctor Details
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(children: [
                // Status Badge
                Container(
                  width: double.infinity, padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: doctor.isAvailable ? const Color(0xFFE8F5E9) : const Color(0xFFFFEBEE),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: doctor.isAvailable ? const Color(0xFF4CAF50) : const Color(0xFFE53935), width: 0.5),
                  ),
                  child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                    Icon(doctor.isAvailable ? Icons.check_circle_rounded : Icons.cancel_rounded, color: doctor.isAvailable ? const Color(0xFF4CAF50) : const Color(0xFFE53935), size: 20),
                    const SizedBox(width: 8),
                    Text(doctor.isAvailable ? 'Available for Consultation' : 'Currently Unavailable', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: doctor.isAvailable ? const Color(0xFF2E7D32) : const Color(0xFFC62828))),
                  ]),
                ),
                const SizedBox(height: 20),

                // Info Cards
                _buildInfoCard(Icons.medical_services_outlined, 'Specialization', doctor.specialization),
                _buildInfoCard(Icons.work_outline, 'Experience', doctor.experience),
                _buildInfoCard(Icons.local_hospital_outlined, 'Hospital', doctor.hospitalName),
                _buildInfoCard(Icons.phone_outlined, 'Phone', doctor.phoneNumber),
                _buildInfoCard(Icons.email_outlined, 'Email', doctor.email),

                const SizedBox(height: 20),

                // Contact Button
                SizedBox(
                  width: double.infinity, height: 54,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: const Text('Contact feature coming soon!'), backgroundColor: const Color(0xFF0077B6), behavior: SnackBarBehavior.floating, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))));
                    },
                    icon: const Icon(Icons.call_rounded, color: Colors.white),
                    label: const Text('Contact Doctor', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.white)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF0077B6),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                      elevation: 4,
                      shadowColor: const Color(0xFF0077B6).withOpacity(0.3),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard(IconData icon, String label, String value) {
    return Container(
      width: double.infinity, margin: const EdgeInsets.only(bottom: 12), padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 8, offset: const Offset(0, 2))]),
      child: Row(children: [
        Container(
          width: 44, height: 44,
          decoration: BoxDecoration(color: const Color(0xFFE8F4FD), borderRadius: BorderRadius.circular(12)),
          child: Icon(icon, color: const Color(0xFF0077B6), size: 22),
        ),
        const SizedBox(width: 14),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(label, style: TextStyle(fontSize: 12, color: Colors.grey.shade500, fontWeight: FontWeight.w500)),
          const SizedBox(height: 2),
          Text(value, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: Color(0xFF1A1A2E))),
        ])),
      ]),
    );
  }
}
