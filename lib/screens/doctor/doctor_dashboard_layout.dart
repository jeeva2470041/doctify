/// ============================================================
/// Doctor Dashboard Layout - Main navigation with Bottom Navigation Bar
/// ============================================================
/// Main layout for logged-in doctors with 3 tabs:
/// Home, Appointments, Profile
/// ============================================================

import 'package:flutter/material.dart';
import '../../models/doctor_model.dart';
import '../../theme/app_colors.dart';
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
  int _selectedIndex = 0;
  late DoctorModel _doctor;

  @override
  void initState() {
    super.initState();
    _doctor = widget.doctor;
  }

  void _onTabSelected(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _updateDoctorProfile(DoctorModel updatedDoctor) {
    setState(() {
      _doctor = updatedDoctor;
    });
  }

  @override
  Widget build(BuildContext context) {
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
      bottomNavigationBar: _buildBottomNavBar(),
    );
  }

  Widget _buildBottomNavBar() {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).bottomNavigationBarTheme.backgroundColor ?? Theme.of(context).colorScheme.surface,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.10),
            blurRadius: 16,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
        child: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: _onTabSelected,
          elevation: 0,
          type: BottomNavigationBarType.fixed,
          backgroundColor: Theme.of(context).bottomNavigationBarTheme.backgroundColor ?? Theme.of(context).colorScheme.surface,
          selectedItemColor: AppColors.primary,
          unselectedItemColor: const Color(0xFF8E8E93),
          selectedFontSize: 12,
          unselectedFontSize: 11,
          selectedLabelStyle: const TextStyle(fontWeight: FontWeight.w600),
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined),
              activeIcon: Icon(Icons.home_rounded),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.calendar_month_outlined),
              activeIcon: Icon(Icons.calendar_month_rounded),
              label: 'Appointments',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_outline_rounded),
              activeIcon: Icon(Icons.person_rounded),
              label: 'Profile',
            ),
          ],
        ),
      ),
    );
  }
}
