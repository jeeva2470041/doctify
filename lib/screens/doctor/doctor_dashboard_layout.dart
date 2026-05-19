/// ============================================================
/// Doctor Dashboard Layout - Main navigation with Bottom Navigation Bar
/// ============================================================
/// Main layout for logged-in doctors with 3 tabs:
/// Home, Appointments, Profile
/// ============================================================

import 'package:flutter/material.dart';
import '../../models/doctor_model.dart';
import 'doctor_home_tab.dart';
import 'doctor_appointments_tab.dart';
import 'doctor_profile_tab.dart';

class DoctorDashboardLayout extends StatefulWidget {
  final DoctorModel doctor;

  const DoctorDashboardLayout({
    super.key,
    required this.doctor,
  });

  @override
  State<DoctorDashboardLayout> createState() => _DoctorDashboardLayoutState();
}

class _DoctorDashboardLayoutState extends State<DoctorDashboardLayout> {
  // Currently selected tab index
  int _selectedIndex = 0;

  // Late initialization to allow state updates
  late DoctorModel _doctor;

  @override
  void initState() {
    super.initState();
    _doctor = widget.doctor;
  }

  /// Handle bottom navigation bar tab selection
  void _onTabSelected(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  /// Update doctor profile
  void _updateDoctorProfile(DoctorModel updatedDoctor) {
    setState(() {
      _doctor = updatedDoctor;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Define the screens for each tab
    final List<Widget> screens = [
      DoctorHomeTab(doctor: _doctor),
      DoctorAppointmentsTab(doctor: _doctor),
      DoctorProfileTab(
        doctor: _doctor,
        onDoctorUpdated: _updateDoctorProfile,
      ),
    ];

    return Scaffold(
      body: screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onTabSelected,
        elevation: 8,
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        selectedItemColor: const Color(0xFF0077B6),
        unselectedItemColor: Colors.grey.shade400,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_month),
            label: 'Appointments',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
