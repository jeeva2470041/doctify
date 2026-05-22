/// ============================================================
/// User Home Layout - Main navigation with Bottom Navigation Bar
/// ============================================================
/// Main layout for logged-in users with 3 tabs:
/// Home, My Bookings, Profile
/// ============================================================

import 'package:flutter/material.dart';
import '../../models/user_model.dart';
import '../../theme/app_colors.dart';
import 'home_tab.dart';
import 'my_bookings_tab.dart';
import 'favorites_tab.dart';
import 'profile_tab.dart';
import 'ai_assistant_tab.dart';

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
  int _selectedIndex = 0;
  late UserModel _user;

  @override
  void initState() {
    super.initState();
    _user = widget.user;
  }

  void _onTabSelected(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _updateUserProfile(UserModel updatedUser) {
    setState(() {
      _user = updatedUser;
    });
  }

  void _toggleFavorite(String doctorId) {
    setState(() {
      final isFav = _user.favoriteDoctorIds.contains(doctorId);
      final newFavs = List<String>.from(_user.favoriteDoctorIds);
      if (isFav) {
        newFavs.remove(doctorId);
      } else {
        newFavs.add(doctorId);
      }
      _user = _user.copyWith(favoriteDoctorIds: newFavs);
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> screens = [
      HomeTab(
        user: _user,
        onToggleFavorite: _toggleFavorite,
        onNavigateToAi: () => _onTabSelected(1),
      ),
      AiAssistantTab(user: _user),
      MyBookingsTab(user: _user),
      FavoritesTab(
        user: _user,
        onToggleFavorite: _toggleFavorite,
      ),
      ProfileTab(
        user: _user,
        onUserUpdated: _updateUserProfile,
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
              icon: Icon(Icons.psychology_outlined),
              activeIcon: Icon(Icons.psychology_rounded),
              label: 'AI Consult',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.calendar_month_outlined),
              activeIcon: Icon(Icons.calendar_month_rounded),
              label: 'Bookings',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.favorite_outline_rounded),
              activeIcon: Icon(Icons.favorite_rounded),
              label: 'Favorites',
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
