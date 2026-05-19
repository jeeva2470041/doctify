import 'package:flutter/material.dart';
import '../../models/doctor_model.dart';
import '../../models/appointment_model.dart';
import '../../data/dummy_data.dart';
import '../landing_page.dart';
import 'doctor_edit_screen.dart';

/// Doctor Dashboard - Doctor's personal area after login
class DoctorDashboard extends StatefulWidget {
  final DoctorModel doctor;
  const DoctorDashboard({super.key, required this.doctor});
  @override
  State<DoctorDashboard> createState() => _DoctorDashboardState();
}

class _DoctorDashboardState extends State<DoctorDashboard> {
  late DoctorModel _doctor;

  @override
  void initState() {
    super.initState();
    _doctor = widget.doctor;
  }

  /// Get appointments for this doctor
  List<AppointmentModel> _getDoctorAppointments() {
    return appointmentBookings
        .where((apt) => apt.doctorId == _doctor.id)
        .toList();
  }

  /// Update appointment status
  void _updateAppointmentStatus(String appointmentId, String newStatus) {
    final index = appointmentBookings
        .indexWhere((apt) => apt.id == appointmentId);
    if (index != -1) {
      appointmentBookings[index] =
          appointmentBookings[index].copyWith(status: newStatus);
      setState(() {});

      // Show confirmation
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            '✓ Appointment ${newStatus.toLowerCase()}',
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
          backgroundColor: newStatus == 'Approved'
              ? const Color(0xFF4CAF50)
              : const Color(0xFFE53935),
          duration: const Duration(seconds: 2),
          behavior: SnackBarBehavior.floating,
          margin: const EdgeInsets.all(16),
        ),
      );
    }
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Logout', style: TextStyle(fontWeight: FontWeight.bold)),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_) => const LandingPage()), (route) => false);
            },
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF0077B6), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
            child: const Text('Logout', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F9FC),
      appBar: AppBar(
        title: const Text('Dashboard', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
        centerTitle: true,
        backgroundColor: const Color(0xFF0077B6),
        elevation: 0,
        automaticallyImplyLeading: false,
        actions: [
          IconButton(icon: const Icon(Icons.logout_rounded, color: Colors.white), onPressed: _showLogoutDialog),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(children: [
          // Welcome Header
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(20, 24, 20, 28),
            decoration: const BoxDecoration(
              color: Color(0xFF0077B6),
              borderRadius: BorderRadius.only(bottomLeft: Radius.circular(24), bottomRight: Radius.circular(24)),
            ),
            child: Column(children: [
              Container(
                width: 80, height: 80,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(22),
                  border: Border.all(color: Colors.white.withOpacity(0.4), width: 2),
                ),
                child: Center(child: Text(_doctor.name.replaceFirst('Dr. ', '')[0].toUpperCase(), style: const TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold))),
              ),
              const SizedBox(height: 14),
              Text('Welcome, ${_doctor.name}!', style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white)),
              const SizedBox(height: 4),
              Text(_doctor.specialization, style: TextStyle(fontSize: 14, color: Colors.white.withOpacity(0.85))),
              const SizedBox(height: 12),
              // Availability badge
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                decoration: BoxDecoration(
                  color: _doctor.isAvailable ? Colors.white.withOpacity(0.2) : Colors.red.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.white.withOpacity(0.3)),
                ),
                child: Row(mainAxisSize: MainAxisSize.min, children: [
                  Container(width: 8, height: 8, decoration: BoxDecoration(shape: BoxShape.circle, color: _doctor.isAvailable ? const Color(0xFF4CAF50) : const Color(0xFFE53935))),
                  const SizedBox(width: 6),
                  Text(_doctor.isAvailable ? 'Available' : 'Unavailable', style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w500)),
                ]),
              ),
            ]),
          ),

          const SizedBox(height: 24),

          // Dashboard Menu Cards
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(children: [
              _buildMenuCard(
                icon: Icons.person_rounded,
                title: 'View Profile',
                subtitle: 'See your complete profile details',
                color: const Color(0xFF0077B6),
                onTap: () => _showProfileBottomSheet(),
              ),
              _buildMenuCard(
                icon: Icons.edit_rounded,
                title: 'Edit Details',
                subtitle: 'Update your profile information',
                color: const Color(0xFF00B4D8),
                onTap: () async {
                  final updatedDoctor = await Navigator.push<DoctorModel>(context, MaterialPageRoute(builder: (_) => DoctorEditScreen(doctor: _doctor)));
                  if (updatedDoctor != null) {
                    setState(() => _doctor = updatedDoctor);
                    // Update in dummy data
                    final index = dummyDoctors.indexWhere((d) => d.id == _doctor.id);
                    if (index != -1) dummyDoctors[index] = _doctor;
                  }
                },
              ),
            ]),
          ),

          const SizedBox(height: 24),

          // ---- Appointments Section ----
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Appointment Requests',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1A1A2E),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                      decoration: BoxDecoration(
                        color: const Color(0xFF0077B6).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        '${_getDoctorAppointments().length}',
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF0077B6),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                ..._buildAppointmentsList(),
              ],
            ),
          ),

          const SizedBox(height: 30),
        ]),
      ),
    );
  }

  Widget _buildMenuCard({required IconData icon, required String title, required String subtitle, required Color color, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity, margin: const EdgeInsets.only(bottom: 14), padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), boxShadow: [BoxShadow(color: color.withOpacity(0.08), blurRadius: 12, offset: const Offset(0, 4))]),
        child: Row(children: [
          Container(width: 52, height: 52, decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(14)), child: Icon(icon, color: color, size: 26)),
          const SizedBox(width: 16),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF1A1A2E))),
            const SizedBox(height: 2),
            Text(subtitle, style: TextStyle(fontSize: 12, color: Colors.grey.shade500)),
          ])),
          Icon(Icons.arrow_forward_ios_rounded, color: Colors.grey.shade300, size: 18),
        ]),
      ),
    );
  }

  void _showProfileBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
        height: MediaQuery.of(context).size.height * 0.7,
        decoration: const BoxDecoration(color: Colors.white, borderRadius: BorderRadius.only(topLeft: Radius.circular(24), topRight: Radius.circular(24))),
        child: Column(children: [
          const SizedBox(height: 12),
          Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.grey.shade300, borderRadius: BorderRadius.circular(2))),
          const SizedBox(height: 20),
          const Text('Your Profile', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF1A1A2E))),
          const SizedBox(height: 20),
          Expanded(child: SingleChildScrollView(padding: const EdgeInsets.symmetric(horizontal: 20), child: Column(children: [
            _buildProfileItem(Icons.person_outline, 'Name', _doctor.name),
            _buildProfileItem(Icons.email_outlined, 'Email', _doctor.email),
            _buildProfileItem(Icons.medical_services_outlined, 'Specialization', _doctor.specialization),
            _buildProfileItem(Icons.work_outline, 'Experience', _doctor.experience),
            _buildProfileItem(Icons.local_hospital_outlined, 'Hospital', _doctor.hospitalName),
            _buildProfileItem(Icons.phone_outlined, 'Phone', _doctor.phoneNumber),
            _buildProfileItem(Icons.circle, 'Status', _doctor.isAvailable ? 'Available' : 'Unavailable'),
            const SizedBox(height: 20),
          ]))),
        ]),
      ),
    );
  }

  Widget _buildProfileItem(IconData icon, String label, String value) {
    return Container(
      width: double.infinity, margin: const EdgeInsets.only(bottom: 10), padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(color: const Color(0xFFF5F9FC), borderRadius: BorderRadius.circular(12)),
      child: Row(children: [
        Icon(icon, color: const Color(0xFF0077B6), size: 20),
        const SizedBox(width: 12),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(label, style: TextStyle(fontSize: 11, color: Colors.grey.shade500)),
          Text(value, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Color(0xFF1A1A2E))),
        ])),
      ]),
    );
  }

  /// Builds list of appointment cards for the doctor
  List<Widget> _buildAppointmentsList() {
    final appointments = _getDoctorAppointments();

    if (appointments.isEmpty) {
      return [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 30),
          child: Column(
            children: [
              Icon(
                Icons.calendar_month,
                size: 48,
                color: Colors.grey.shade300,
              ),
              const SizedBox(height: 12),
              Text(
                'No appointments yet',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey.shade500,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ];
    }

    return appointments.map((appointment) {
      return _buildAppointmentCard(
        appointment: appointment,
        onApprove: () => _updateAppointmentStatus(
          appointment.id,
          'Approved',
        ),
        onReject: () => _updateAppointmentStatus(
          appointment.id,
          'Rejected',
        ),
      );
    }).toList();
  }

  /// Builds an appointment card with approve/reject buttons
  Widget _buildAppointmentCard({
    required AppointmentModel appointment,
    required VoidCallback onApprove,
    required VoidCallback onReject,
  }) {
    // Status color
    Color statusColor;
    Color statusBgColor;
    if (appointment.status == 'Approved') {
      statusColor = const Color(0xFF4CAF50);
      statusBgColor = const Color(0xFFE8F5E9);
    } else if (appointment.status == 'Rejected') {
      statusColor = const Color(0xFFE53935);
      statusBgColor = const Color(0xFFFFEBEE);
    } else {
      statusColor = const Color(0xFFFFB800);
      statusBgColor = const Color(0xFFFFF8E1);
    }

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: statusColor.withOpacity(0.3),
            width: 1.5,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header with Status Badge
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        // Patient Icon
                        Container(
                          width: 36,
                          height: 36,
                          decoration: BoxDecoration(
                            color: const Color(0xFF0077B6).withOpacity(0.15),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(
                            Icons.person,
                            color: Color(0xFF0077B6),
                            size: 18,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                appointment.patientName,
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF1A1A2E),
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 2),
                              Text(
                                'Age: ${appointment.age}',
                                style: TextStyle(
                                  fontSize: 11,
                                  color: Colors.grey.shade600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Status Badge
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4),
                    decoration: BoxDecoration(
                      color: statusBgColor,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: statusColor,
                        width: 0.8,
                      ),
                    ),
                    child: Text(
                      appointment.status,
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        color: statusColor,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 10),

              // Symptoms
              Row(
                children: [
                  Icon(
                    Icons.medical_services_outlined,
                    size: 14,
                    color: Colors.grey.shade600,
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      appointment.symptoms,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade700,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 8),

              // Date and Contact
              Row(
                children: [
                  Icon(
                    Icons.calendar_today,
                    size: 14,
                    color: Colors.grey.shade600,
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      appointment.appointmentDate,
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.grey.shade700,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Icon(
                    Icons.phone,
                    size: 14,
                    color: Colors.grey.shade600,
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      appointment.contactNumber,
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.grey.shade700,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              // Action Buttons (only for Pending)
              if (appointment.status == 'Pending')
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: onReject,
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          side: const BorderSide(
                            color: Color(0xFFE53935),
                            width: 1,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.close,
                              size: 14,
                              color: Color(0xFFE53935),
                            ),
                            SizedBox(width: 4),
                            Text(
                              'Reject',
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFFE53935),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: onApprove,
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          backgroundColor: const Color(0xFF4CAF50),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          elevation: 0,
                        ),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.check,
                              size: 14,
                              color: Colors.white,
                            ),
                            SizedBox(width: 4),
                            Text(
                              'Approve',
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}
