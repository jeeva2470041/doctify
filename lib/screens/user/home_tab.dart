/// ============================================================
/// Home Tab Screen - Doctor List with Search and Filters
/// ============================================================
/// Main tab displaying doctors with search, categories,
/// and collapsible AppBar. Uses SliverAppBar for scrolling.
/// ============================================================

import 'package:flutter/material.dart';
import '../../models/user_model.dart';
import '../../models/doctor_model.dart';
import '../../data/dummy_data.dart';
import '../../widgets/doctor_info_bottom_sheet.dart';
import '../../widgets/notifications_bottom_sheet.dart';

class HomeTab extends StatefulWidget {
  final UserModel user;

  const HomeTab({
    super.key,
    required this.user,
  });

  @override
  State<HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  // Search controller
  late TextEditingController _searchController;

  // Selected category filter
  String? _selectedCategory;

  // List of available specializations (categories)
  final List<String> _categories = [
    'All',
    'Cardiologist',
    'Neurologist',
    'Dermatologist',
    'Orthopedic',
    'Pediatrician',
  ];

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    _selectedCategory = 'All';
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  /// Filter doctors based on search and category
  List<DoctorModel> _getFilteredDoctors() {
    List<DoctorModel> filtered = List.from(dummyDoctors);

    // Filter by search query
    if (_searchController.text.isNotEmpty) {
      filtered = filtered.where((doctor) {
        return doctor.name
                .toLowerCase()
                .contains(_searchController.text.toLowerCase()) ||
            doctor.specialization
                .toLowerCase()
                .contains(_searchController.text.toLowerCase());
      }).toList();
    }

    // Filter by category
    if (_selectedCategory != null && _selectedCategory != 'All') {
      filtered = filtered
          .where((doctor) => doctor.specialization == _selectedCategory)
          .toList();
    }

    return filtered;
  }

  @override
  Widget build(BuildContext context) {
    final filteredDoctors = _getFilteredDoctors();

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // ---- Sliver AppBar ----
          SliverAppBar(
            expandedHeight: 140,
            floating: true,
            snap: true,
            elevation: 0,
            backgroundColor: const Color(0xFF0077B6),
            flexibleSpace: FlexibleSpaceBar(
              title: const Text(
                'Find Your Doctor',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              centerTitle: true,
              collapseMode: CollapseMode.parallax,
            ),
            actions: [
              Padding(
                padding: const EdgeInsets.all(12),
                child: Center(
                  child: Stack(
                    children: [
                      IconButton(
                        icon: const Icon(
                          Icons.notifications_outlined,
                          color: Colors.white,
                        ),
                        onPressed: () {
                          showModalBottomSheet(
                            context: context,
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(24),
                                topRight: Radius.circular(24),
                              ),
                            ),
                            builder: (context) =>
                                const NotificationsBottomSheet(),
                          );
                        },
                      ),
                      // Notification badge - only show if unread exists
                      if (userNotifications
                          .any((n) => !n.isRead))
                        Positioned(
                          top: 8,
                          right: 8,
                          child: Container(
                            width: 8,
                            height: 8,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: Color(0xFFE53935),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ],
          ),

          // ---- Search Bar (in a sliver) ----
          SliverToBoxAdapter(
            child: Container(
              color: const Color(0xFF0077B6),
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
              child: TextField(
                controller: _searchController,
                onChanged: (value) => setState(() {}),
                decoration: InputDecoration(
                  hintText: 'Search doctor or specialization',
                  hintStyle: TextStyle(color: Colors.grey.shade400),
                  prefixIcon: const Icon(
                    Icons.search,
                    color: Color(0xFF0077B6),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.symmetric(vertical: 12),
                ),
              ),
            ),
          ),

          // ---- Category Chips (in a sliver) ----
          SliverToBoxAdapter(
            child: Container(
              color: const Color(0xFFF5F9FF),
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: _categories.map((category) {
                    final isSelected = _selectedCategory == category;
                    return Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: FilterChip(
                        label: Text(category),
                        selected: isSelected,
                        onSelected: (selected) {
                          setState(() {
                            _selectedCategory = selected ? category : 'All';
                          });
                        },
                        backgroundColor: Colors.white,
                        selectedColor: const Color(0xFF0077B6).withOpacity(0.2),
                        side: BorderSide(
                          color: isSelected
                              ? const Color(0xFF0077B6)
                              : Colors.grey.shade300,
                          width: isSelected ? 2 : 1,
                        ),
                        labelStyle: TextStyle(
                          color: isSelected
                              ? const Color(0xFF0077B6)
                              : Colors.grey.shade700,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
          ),

          // ---- Doctor List ----
          if (filteredDoctors.isEmpty)
            SliverFillRemaining(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.medical_services_outlined,
                      size: 64,
                      color: Colors.grey.shade300,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'No doctors found',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey.shade500,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            )
          else
            SliverPadding(
              padding: const EdgeInsets.all(16),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final doctor = filteredDoctors[index];
                    return _buildDoctorCard(doctor, context);
                  },
                  childCount: filteredDoctors.length,
                ),
              ),
            ),
        ],
      ),
    );
  }

  /// Build a doctor card
  Widget _buildDoctorCard(DoctorModel doctor, BuildContext context) {
    return GestureDetector(
      onTap: () {
        showModalBottomSheet(
          context: context,
          builder: (context) => DoctorInfoBottomSheet(doctor: doctor),
          isScrollControlled: true,
          useSafeArea: true,
        );
      },
      child: Card(
        margin: const EdgeInsets.only(bottom: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 2,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            gradient: const LinearGradient(
              colors: [Colors.white, Color(0xFFF8FBFF)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                // ---- Avatar ----
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF0077B6), Color(0xFF00B4D8)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(12),
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
                      doctor.name
                          .replaceFirst('Dr. ', '')
                          .isEmpty
                          ? 'D'
                          : doctor.name.replaceFirst('Dr. ', '')[0]
                              .toUpperCase(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),

                const SizedBox(width: 12),

                // ---- Doctor Info ----
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Name
                      Text(
                        doctor.name,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1A1A2E),
                        ),
                      ),
                      const SizedBox(height: 4),

                      // Specialization
                      Row(
                        children: [
                          Icon(
                            Icons.medical_services_outlined,
                            size: 13,
                            color: Colors.grey.shade500,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            doctor.specialization,
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey.shade600,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),

                      // Experience & Rating
                      Row(
                        children: [
                          Icon(
                            Icons.star,
                            size: 12,
                            color: const Color(0xFFFFB800),
                          ),
                          const SizedBox(width: 2),
                          Text(
                            doctor.rating.toString(),
                            style: const TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF1A1A2E),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Icon(
                            Icons.work_outline,
                            size: 12,
                            color: Colors.grey.shade500,
                          ),
                          const SizedBox(width: 2),
                          Text(
                            doctor.experience,
                            style: TextStyle(
                              fontSize: 11,
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // ---- Availability Badge ----
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: doctor.isAvailable
                        ? const Color(0xFFE8F5E9)
                        : const Color(0xFFFFEBEE),
                    borderRadius: BorderRadius.circular(16),
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
                      Container(
                        width: 6,
                        height: 6,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: doctor.isAvailable
                              ? const Color(0xFF4CAF50)
                              : const Color(0xFFE53935),
                        ),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        doctor.isAvailable ? 'Free' : 'Busy',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          color: doctor.isAvailable
                              ? const Color(0xFF2E7D32)
                              : const Color(0xFFC62828),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
