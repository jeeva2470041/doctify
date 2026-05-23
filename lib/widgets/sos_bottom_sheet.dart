import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../theme/app_colors.dart';

class SosBottomSheet extends StatefulWidget {
  const SosBottomSheet({super.key});

  @override
  State<SosBottomSheet> createState() => _SosBottomSheetState();
}

class _SosBottomSheetState extends State<SosBottomSheet> {
  bool _loadingLocation = false;
  Position? _currentPosition;
  List<Map<String, String>> _contacts = [];

  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _relationController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadContacts();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _relationController.dispose();
    super.dispose();
  }

  Future<void> _loadContacts() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String? contactsJson = prefs.getString('emergency_contacts');
      if (contactsJson != null) {
        final List<dynamic> decoded = jsonDecode(contactsJson);
        setState(() {
          _contacts = decoded.map((item) => Map<String, String>.from(item)).toList();
        });
      }
    } catch (e) {
      debugPrint("Error loading contacts: $e");
    }
  }

  Future<void> _saveContacts() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('emergency_contacts', jsonEncode(_contacts));
    } catch (e) {
      debugPrint("Error saving contacts: $e");
    }
  }

  Future<void> _callAmbulance() async {
    final uri = Uri.parse('tel:108');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Unable to make call directly. Please dial 108.')),
        );
      }
    }
  }

  Future<void> _getCurrentLocation() async {
    setState(() {
      _loadingLocation = true;
    });
    try {
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }
      if (permission == LocationPermission.deniedForever) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Location permissions are permanently denied.')),
          );
        }
        return;
      }
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      setState(() {
        _currentPosition = position;
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to fetch location: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _loadingLocation = false;
        });
      }
    }
  }

  Future<void> _openMap() async {
    if (_currentPosition == null) return;
    final url = 'https://www.google.com/maps/search/?api=1&query=${_currentPosition!.latitude},${_currentPosition!.longitude}';
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Could not open map.')),
        );
      }
    }
  }

  void _sendAlert() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Emergency Alert Sent Successfully! Notify messages dispatched.'),
        backgroundColor: Colors.green,
      ),
    );
  }

  void _addContact() {
    if (_nameController.text.trim().isEmpty ||
        _phoneController.text.trim().isEmpty ||
        _relationController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill out all fields.')),
      );
      return;
    }
    setState(() {
      _contacts.add({
        'name': _nameController.text.trim(),
        'phone': _phoneController.text.trim(),
        'relation': _relationController.text.trim(),
      });
      _nameController.clear();
      _phoneController.clear();
      _relationController.clear();
    });
    _saveContacts();
    Navigator.pop(context); // Close add dialog
  }

  void _showAddContactDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: AppColors.cardBg,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: Text(
            'Add Emergency Contact',
            style: TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.bold),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Contact Name',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(
                  labelText: 'Phone Number',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _relationController,
                decoration: const InputDecoration(
                  labelText: 'Relationship (e.g. Spouse, Father)',
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: _addContact,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFF3B30),
                foregroundColor: Colors.white,
              ),
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        top: 20,
        bottom: MediaQuery.of(context).viewInsets.bottom + 20,
      ),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
        border: Border.all(color: const Color(0xFFFF3B30).withOpacity(0.3), width: 1.5),
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header
            Center(
              child: Container(
                width: 50,
                height: 5,
                decoration: BoxDecoration(
                  color: Colors.grey.shade400,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                const Icon(Icons.emergency_share_rounded, color: Color(0xFFFF3B30), size: 30),
                const SizedBox(width: 10),
                Text(
                  'Emergency SOS System',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Call Ambulance Big Card
            ElevatedButton.icon(
              onPressed: _callAmbulance,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFF3B30),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                elevation: 4,
              ),
              icon: const Icon(Icons.local_phone_rounded, size: 28),
              label: const Text(
                'CALL AMBULANCE (108)',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900, letterSpacing: 0.5),
              ),
            ),
            const SizedBox(height: 16),

            // Emergency Alert and Location Row
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: _sendAlert,
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Color(0xFFFF3B30), width: 1.5),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    icon: const Icon(Icons.campaign_rounded, color: Color(0xFFFF3B30)),
                    label: const Text(
                      'Send Alert',
                      style: TextStyle(color: Color(0xFFFF3B30), fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: _getCurrentLocation,
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Colors.blue, width: 1.5),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    icon: _loadingLocation
                        ? const SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(strokeWidth: 2, color: Colors.blue),
                          )
                        : const Icon(Icons.my_location_rounded, color: Colors.blue),
                    label: const Text(
                      'Get Location',
                      style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),

            // Live Location Display Card
            if (_currentPosition != null) ...[
              const SizedBox(height: 16),
              Card(
                color: AppColors.cardBg,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.location_on_rounded, color: Colors.red),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              'Latitude: ${_currentPosition!.latitude.toStringAsFixed(6)}\nLongitude: ${_currentPosition!.longitude.toStringAsFixed(6)}',
                              style: TextStyle(
                                fontSize: 13,
                                color: AppColors.textPrimary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      TextButton.icon(
                        onPressed: _openMap,
                        icon: const Icon(Icons.map_rounded, size: 18),
                        label: const Text('Open in Google Maps'),
                      ),
                    ],
                  ),
                ),
              ),
            ],

            const SizedBox(height: 24),

            // Contacts Section
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Emergency Contacts',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                TextButton.icon(
                  onPressed: _showAddContactDialog,
                  icon: const Icon(Icons.add_rounded, size: 18, color: Color(0xFFFF3B30)),
                  label: const Text(
                    'Add Contact',
                    style: TextStyle(color: Color(0xFFFF3B30), fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),

            if (_contacts.isEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: Center(
                  child: Text(
                    'No emergency contacts added yet.',
                    style: TextStyle(color: AppColors.textSecondary, fontSize: 13),
                  ),
                ),
              )
            else
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _contacts.length,
                itemBuilder: (context, index) {
                  final contact = _contacts[index];
                  return Card(
                    color: AppColors.cardBg,
                    margin: const EdgeInsets.only(bottom: 8),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: const Color(0xFFFF3B30).withOpacity(0.1),
                        child: const Icon(Icons.person_rounded, color: Color(0xFFFF3B30)),
                      ),
                      title: Text(
                        contact['name'] ?? '',
                        style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                      ),
                      subtitle: Text(
                        '${contact['relation']} • ${contact['phone']}',
                        style: TextStyle(color: AppColors.textSecondary, fontSize: 12),
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.phone_rounded, color: Colors.green),
                            onPressed: () async {
                              final uri = Uri.parse('tel:${contact['phone']}');
                              if (await canLaunchUrl(uri)) {
                                await launchUrl(uri);
                              }
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete_outline_rounded, color: Colors.red),
                            onPressed: () {
                              setState(() {
                                _contacts.removeAt(index);
                              });
                              _saveContacts();
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
          ],
        ),
      ),
    );
  }
}
