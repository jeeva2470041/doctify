/// ============================================================
/// Home Tab Screen - Doctor List with Search and Filters
/// ============================================================
/// Main tab displaying doctors with search, categories,
/// and collapsible AppBar. Uses AppColors throughout.
/// ============================================================

import 'package:flutter/material.dart';
import '../../models/user_model.dart';
import '../../models/doctor_model.dart';
import '../../data/dummy_data.dart';
import '../../theme/app_colors.dart';
import '../../widgets/doctor_info_bottom_sheet.dart';
import '../../widgets/notifications_bottom_sheet.dart';

class HomeTab extends StatefulWidget {
  final UserModel user;
  final Function(String) onToggleFavorite;
  final VoidCallback onNavigateToAi;

  const HomeTab({
    super.key,
    required this.user,
    required this.onToggleFavorite,
    required this.onNavigateToAi,
  });

  @override
  State<HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  late TextEditingController _searchController;
  String? _selectedCategory;

  final List<String> _categories = [
    'All',
    'Cardiologist',
    'Neurologist',
    'Dermatologist',
    'Orthopedic Surgeon',
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

  List<DoctorModel> _getFilteredDoctors() {
    List<DoctorModel> filtered = List.from(dummyDoctors);

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
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          // ---- Sliver AppBar ----
          SliverAppBar(
            expandedHeight: 160,
            floating: true,
            snap: true,
            elevation: 0,
            scrolledUnderElevation: 0,
            backgroundColor: AppColors.primary,
            flexibleSpace: FlexibleSpaceBar(
              titlePadding:
                  const EdgeInsets.only(left: 20, bottom: 16, right: 60),
              title: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Hello, ${widget.user.name.split(' ').first} 👋',
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  const Text(
                    'Find Your Doctor',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
              centerTitle: false,
              collapseMode: CollapseMode.parallax,
              background: Container(
                decoration: const BoxDecoration(
                  gradient: AppColors.primaryGradient,
                ),
              ),
            ),
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 12),
                child: Stack(
                  alignment: Alignment.topRight,
                  children: [
                    IconButton(
                      icon: const Icon(
                        Icons.notifications_outlined,
                        color: Colors.white,
                        size: 26,
                      ),
                      onPressed: () {
                        showModalBottomSheet(
                          context: context,
                          backgroundColor: Colors.transparent,
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
                    // Notification badge
                    if (userNotifications.any((n) => !n.isRead))
                      Positioned(
                        top: 8,
                        right: 8,
                        child: Container(
                          width: 9,
                          height: 9,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppColors.busy,
                            border:
                                Border.all(color: AppColors.primary, width: 1.5),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),

          // ---- Search Bar ----
          SliverToBoxAdapter(
            child: Container(
              decoration: const BoxDecoration(
                gradient: AppColors.primaryGradient,
              ),
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.cardBg,
                  borderRadius: BorderRadius.circular(14),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.08),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: TextField(
                  controller: _searchController,
                  onChanged: (value) => setState(() {}),
                  style: TextStyle(
                    fontSize: 14,
                    color: AppColors.textPrimary,
                  ),
                  decoration: InputDecoration(
                    hintText: 'Search doctor or specialization...',
                    hintStyle: TextStyle(
                      color: AppColors.textHint,
                      fontSize: 14,
                    ),
                    prefixIcon: Icon(
                      Icons.search_rounded,
                      color: AppColors.primary,
                      size: 22,
                    ),
                    filled: true,
                    fillColor: Colors.transparent,
                    border: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  ),
                ),
              ),
            ),
          ),

          // ---- AI promo banner ----
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
              child: Container(
                decoration: BoxDecoration(
                  gradient: AppColors.primaryGradient,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary.withOpacity(0.20),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Stack(
                     children: [
                       // Background design element
                       Positioned(
                         right: -10,
                         bottom: -10,
                         child: Icon(
                           Icons.psychology,
                           size: 110,
                           color: Colors.white.withOpacity(0.12),
                         ),
                       ),
                       Padding(
                         padding: const EdgeInsets.all(16.0),
                         child: Column(
                           crossAxisAlignment: CrossAxisAlignment.start,
                           children: [
                             Row(
                               children: [
                                 Container(
                                   padding: const EdgeInsets.all(6),
                                   decoration: BoxDecoration(
                                     color: Colors.white.withOpacity(0.2),
                                     shape: BoxShape.circle,
                                   ),
                                   child: const Icon(
                                     Icons.auto_awesome,
                                     color: Colors.white,
                                     size: 16,
                                   ),
                                 ),
                                 const SizedBox(width: 8),
                                 const Text(
                                   'AI Symptom Checker',
                                   style: TextStyle(
                                     color: Colors.white,
                                     fontSize: 14,
                                     fontWeight: FontWeight.bold,
                                   ),
                                 ),
                               ],
                             ),
                             const SizedBox(height: 8),
                             const Text(
                               'Unsure which specialist you need?\nDescribe symptoms to find doctors & recommended consultation lengths.',
                               style: TextStyle(
                                 color: Colors.white70,
                                 fontSize: 12,
                                 height: 1.4,
                               ),
                             ),
                             const SizedBox(height: 12),
                             ElevatedButton.icon(
                               onPressed: widget.onNavigateToAi,
                               icon: const Icon(Icons.chat_bubble_outline, size: 14, color: AppColors.primary),
                               label: const Text(
                                 'Consult Dockify AI',
                                 style: TextStyle(
                                   fontSize: 11.5,
                                   fontWeight: FontWeight.bold,
                                   color: AppColors.primary,
                                 ),
                               ),
                               style: ElevatedButton.styleFrom(
                                 backgroundColor: Colors.white,
                                 elevation: 0,
                                 padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                                 shape: RoundedRectangleBorder(
                                   borderRadius: BorderRadius.circular(10),
                                 ),
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
          ),

          // ---- Favorites Horizontal List ----
          if (widget.user.favoriteDoctorIds.isNotEmpty)
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Favorite Doctors',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 10),
                    SizedBox(
                      height: 84,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: widget.user.favoriteDoctorIds.length,
                        itemBuilder: (context, index) {
                          final docId = widget.user.favoriteDoctorIds[index];
                          // Find doctor in dummyDoctors
                          final doctor = dummyDoctors.firstWhere(
                            (d) => d.id == docId,
                            orElse: () => dummyDoctors.first,
                          );
                          return Padding(
                            padding: const EdgeInsets.only(right: 14),
                            child: GestureDetector(
                              onTap: () {
                                showModalBottomSheet(
                                  context: context,
                                  builder: (context) => DoctorInfoBottomSheet(
                                    doctor: doctor,
                                    isFavorite: true,
                                    onToggleFavorite: widget.onToggleFavorite,
                                  ),
                                  isScrollControlled: true,
                                  useSafeArea: true,
                                  backgroundColor: Colors.transparent,
                                );
                              },
                              child: Column(
                                children: [
                                  Container(
                                    width: 50,
                                    height: 50,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      gradient: AppColors.primaryGradient,
                                      border: Border.all(
                                        color: AppColors.primary.withOpacity(0.3),
                                        width: 1.5,
                                      ),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.06),
                                          blurRadius: 6,
                                          offset: const Offset(0, 2),
                                        ),
                                      ],
                                    ),
                                    child: Center(
                                      child: Text(
                                        doctor.name.replaceFirst('Dr. ', '').isEmpty
                                            ? 'D'
                                            : doctor.name.replaceFirst('Dr. ', '')[0].toUpperCase(),
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  SizedBox(
                                    width: 70,
                                    child: Text(
                                      doctor.name,
                                      style: TextStyle(
                                        fontSize: 11,
                                        fontWeight: FontWeight.w500,
                                        color: AppColors.textPrimary,
                                      ),
                                      textAlign: TextAlign.center,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),

          // ---- Category Chips ----
          SliverToBoxAdapter(
            child: Container(
              color: AppColors.background,
              padding: const EdgeInsets.fromLTRB(16, 14, 16, 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Specializations',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: _categories.map((category) {
                        final isSelected = _selectedCategory == category;
                        return Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                _selectedCategory = category;
                              });
                            },
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 8),
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? AppColors.primary
                                    : AppColors.cardBg,
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  color: isSelected
                                      ? AppColors.primary
                                      : AppColors.border,
                                  width: 1,
                                ),
                                boxShadow: isSelected
                                    ? [
                                        BoxShadow(
                                          color: AppColors.primary
                                              .withOpacity(0.25),
                                          blurRadius: 8,
                                          offset: const Offset(0, 3),
                                        ),
                                      ]
                                    : null,
                              ),
                              child: Text(
                                category,
                                style: TextStyle(
                                  color: isSelected
                                      ? Colors.white
                                      : AppColors.textSecondary,
                                  fontWeight: isSelected
                                      ? FontWeight.w600
                                      : FontWeight.w500,
                                  fontSize: 13,
                                ),
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // ---- Section Title ----
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    filteredDoctors.isEmpty
                        ? 'No Results'
                        : '${filteredDoctors.length} Doctors Found',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ],
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
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        color: AppColors.background,
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: Icon(
                        Icons.search_off_rounded,
                        size: 40,
                        color: AppColors.textHint,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'No doctors found',
                      style: TextStyle(
                        fontSize: 16,
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Try a different search or category',
                      style: TextStyle(
                        fontSize: 13,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            )
          else
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
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

  Widget _buildDoctorCard(DoctorModel doctor, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            showModalBottomSheet(
              context: context,
              builder: (context) => DoctorInfoBottomSheet(
                doctor: doctor,
                isFavorite: widget.user.favoriteDoctorIds.contains(doctor.id),
                onToggleFavorite: widget.onToggleFavorite,
              ),
              isScrollControlled: true,
              useSafeArea: true,
              backgroundColor: Colors.transparent,
            );
          },
          borderRadius: BorderRadius.circular(16),
          child: Container(
            padding: const EdgeInsets.all(14),
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
            child: Row(
              children: [
                // Avatar
                Container(
                  width: 54,
                  height: 54,
                  decoration: BoxDecoration(
                    gradient: AppColors.primaryGradient,
                    borderRadius: BorderRadius.circular(14),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primary.withOpacity(0.22),
                        blurRadius: 8,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Center(
                    child: Text(
                      doctor.name.replaceFirst('Dr. ', '').isEmpty
                          ? 'D'
                          : doctor.name.replaceFirst('Dr. ', '')[0].toUpperCase(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),

                const SizedBox(width: 12),

                // Doctor Info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              doctor.name,
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                                color: AppColors.textPrimary,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              widget.onToggleFavorite(doctor.id);
                            },
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                              child: Icon(
                                widget.user.favoriteDoctorIds.contains(doctor.id)
                                    ? Icons.favorite_rounded
                                    : Icons.favorite_outline_rounded,
                                color: widget.user.favoriteDoctorIds.contains(doctor.id)
                                    ? AppColors.busy
                                    : AppColors.textHint,
                                size: 20,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 3),
                      Row(
                        children: [
                          Icon(Icons.medical_services_outlined,
                              size: 12, color: AppColors.textSecondary),
                          const SizedBox(width: 4),
                          Flexible(
                            child: Text(
                              doctor.specialization,
                              style: TextStyle(
                                fontSize: 12,
                                color: AppColors.textSecondary,
                                fontWeight: FontWeight.w500,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 3),
                      Row(
                        children: [
                          const Icon(Icons.star_rounded,
                              size: 12, color: Color(0xFFFF9500)),
                          const SizedBox(width: 2),
                          Text(
                            doctor.rating.toString(),
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Icon(Icons.work_outline,
                              size: 11, color: AppColors.textSecondary),
                          const SizedBox(width: 3),
                          Flexible(
                            child: Text(
                              doctor.experience,
                              style: TextStyle(
                                fontSize: 11,
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

                // Availability Badge
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: doctor.isAvailable
                        ? AppColors.availableBg
                        : AppColors.busyBg,
                    borderRadius: BorderRadius.circular(20),
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
                              ? AppColors.available
                              : AppColors.busy,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        doctor.isAvailable ? 'Free' : 'Busy',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          color: doctor.isAvailable
                              ? AppColors.available
                              : AppColors.busy,
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
