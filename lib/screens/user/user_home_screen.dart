import 'package:flutter/material.dart';
import '../../models/doctor_model.dart';
import '../../data/dummy_data.dart';
import '../../widgets/doctor_card.dart';
import '../../widgets/section_title.dart';
import '../doctor/doctor_details_screen.dart';
import '../landing_page.dart';

/// User Home Screen - Shows list of doctors with search functionality
class UserHomeScreen extends StatefulWidget {
  final String userName;
  const UserHomeScreen({super.key, required this.userName});
  @override
  State<UserHomeScreen> createState() => _UserHomeScreenState();
}

class _UserHomeScreenState extends State<UserHomeScreen> {
  final _searchController = TextEditingController();
  List<DoctorModel> _filteredDoctors = [];

  @override
  void initState() {
    super.initState();
    _filteredDoctors = dummyDoctors;
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  /// Filters doctors by name or specialization
  void _filterDoctors(String query) {
    setState(() {
      if (query.isEmpty) {
        _filteredDoctors = dummyDoctors;
      } else {
        _filteredDoctors = dummyDoctors.where((d) =>
          d.name.toLowerCase().contains(query.toLowerCase()) ||
          d.specialization.toLowerCase().contains(query.toLowerCase())
        ).toList();
      }
    });
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
        title: const Text('Doctor Info App', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
        centerTitle: true,
        backgroundColor: const Color(0xFF0077B6),
        elevation: 0,
        automaticallyImplyLeading: false,
        actions: [
          IconButton(icon: const Icon(Icons.logout_rounded, color: Colors.white), onPressed: _showLogoutDialog),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Welcome Header
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
            decoration: const BoxDecoration(
              color: Color(0xFF0077B6),
              borderRadius: BorderRadius.only(bottomLeft: Radius.circular(24), bottomRight: Radius.circular(24)),
            ),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text('Hello, ${widget.userName}! 👋', style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white)),
              const SizedBox(height: 4),
              Text('Find the best doctors near you', style: TextStyle(fontSize: 14, color: Colors.white.withOpacity(0.85))),
              const SizedBox(height: 16),
              // Search Bar
              Container(
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 10, offset: const Offset(0, 4))]),
                child: TextField(
                  controller: _searchController,
                  onChanged: _filterDoctors,
                  decoration: InputDecoration(
                    hintText: 'Search doctors by name or specialization...',
                    hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 14),
                    prefixIcon: const Icon(Icons.search_rounded, color: Color(0xFF0077B6)),
                    suffixIcon: _searchController.text.isNotEmpty
                      ? IconButton(icon: const Icon(Icons.clear_rounded, color: Colors.grey), onPressed: () { _searchController.clear(); _filterDoctors(''); })
                      : null,
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  ),
                ),
              ),
            ]),
          ),

          const SizedBox(height: 8),
          SectionTitle(title: 'Available Doctors', subtitle: '${_filteredDoctors.length} doctors found'),

          // Doctor List
          Expanded(
            child: _filteredDoctors.isEmpty
              ? Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                  Icon(Icons.search_off_rounded, size: 60, color: Colors.grey.shade300),
                  const SizedBox(height: 12),
                  Text('No doctors found', style: TextStyle(fontSize: 16, color: Colors.grey.shade400)),
                ]))
              : ListView.builder(
                  padding: const EdgeInsets.only(bottom: 20),
                  itemCount: _filteredDoctors.length,
                  itemBuilder: (context, index) {
                    return DoctorCard(
                      doctor: _filteredDoctors[index],
                      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => DoctorDetailsScreen(doctor: _filteredDoctors[index]))),
                    );
                  },
                ),
          ),
        ],
      ),
    );
  }
}
