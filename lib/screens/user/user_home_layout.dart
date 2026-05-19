/// ============================================================
/// User Home Layout - Main navigation with Bottom Navigation Bar
/// ============================================================
/// Main layout for logged-in users with 3 tabs:
/// Home, My Bookings, Profile
/// ============================================================

import 'package:flutter/material.dart';
import '../../models/user_model.dart';
import 'home_tab.dart';
import 'my_bookings_tab.dart';
import 'profile_tab.dart';

class UserHomeLayout extends StatefulWidget {
  final UserModel user;

  const UserHomeLayout({
    super.key,
    required this.user,
  });

  @override
  State<UserHomeLayout> createState() => _UserHomeLayoutState();
}

class _UserHomeLayoutState extends State<UserHomeLayout> {
  // Currently selected tab index
  int _selectedIndex = 0;

  // Late initialization to allow state updates
  late UserModel _user;

  @override
  void initState() {
    super.initState();
    _user = widget.user;
  }

  /// Handle bottom navigation bar tab selection
  void _onTabSelected(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  /// Update user profile
  void _updateUserProfile(UserModel updatedUser) {
    setState(() {
      _user = updatedUser;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Define the screens for each tab
    final List<Widget> screens = [
      HomeTab(user: _user),
      MyBookingsTab(user: _user),
      ProfileTab(
        user: _user,
        onUserUpdated: _updateUserProfile,
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
            label: 'Bookings',
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
