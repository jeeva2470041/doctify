import 'package:flutter/material.dart';
import '../../models/doctor_model.dart';
import '../../widgets/custom_textfield.dart';
import '../../widgets/custom_button.dart';

/// Doctor Edit Screen - Allows doctors to update their profile
class DoctorEditScreen extends StatefulWidget {
  final DoctorModel doctor;
  const DoctorEditScreen({super.key, required this.doctor});
  @override
  State<DoctorEditScreen> createState() => _DoctorEditScreenState();
}

class _DoctorEditScreenState extends State<DoctorEditScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _specializationController;
  late TextEditingController _experienceController;
  late TextEditingController _hospitalController;
  late TextEditingController _phoneController;
  late bool _isAvailable;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.doctor.name.replaceFirst('Dr. ', ''));
    _specializationController = TextEditingController(text: widget.doctor.specialization);
    _experienceController = TextEditingController(text: widget.doctor.experience);
    _hospitalController = TextEditingController(text: widget.doctor.hospitalName);
    _phoneController = TextEditingController(text: widget.doctor.phoneNumber);
    _isAvailable = widget.doctor.isAvailable;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _specializationController.dispose();
    _experienceController.dispose();
    _hospitalController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  void _handleSave() {
    if (_formKey.currentState!.validate()) {
      final updatedDoctor = widget.doctor.copyWith(
        name: 'Dr. ${_nameController.text.trim()}',
        specialization: _specializationController.text.trim(),
        experience: _experienceController.text.trim(),
        hospitalName: _hospitalController.text.trim(),
        phoneNumber: _phoneController.text.trim(),
        isAvailable: _isAvailable,
      );
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: const Text('Profile updated successfully!'), backgroundColor: const Color(0xFF4CAF50), behavior: SnackBarBehavior.floating, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))));
      Navigator.pop(context, updatedDoctor);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F9FC),
      appBar: AppBar(
        title: const Text('Edit Profile', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
        centerTitle: true,
        backgroundColor: const Color(0xFF0077B6),
        elevation: 0,
        leading: IconButton(icon: const Icon(Icons.arrow_back_ios_rounded, color: Colors.white), onPressed: () => Navigator.pop(context)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(children: [
            CustomTextField(controller: _nameController, hintText: 'Full Name', prefixIcon: Icons.person_outline, validator: (v) => (v == null || v.isEmpty) ? 'Required' : null),
            CustomTextField(controller: _specializationController, hintText: 'Specialization', prefixIcon: Icons.medical_services_outlined, validator: (v) => (v == null || v.isEmpty) ? 'Required' : null),
            CustomTextField(controller: _experienceController, hintText: 'Experience', prefixIcon: Icons.work_outline, validator: (v) => (v == null || v.isEmpty) ? 'Required' : null),
            CustomTextField(controller: _hospitalController, hintText: 'Hospital Name', prefixIcon: Icons.local_hospital_outlined, validator: (v) => (v == null || v.isEmpty) ? 'Required' : null),
            CustomTextField(controller: _phoneController, hintText: 'Phone Number', prefixIcon: Icons.phone_outlined, keyboardType: TextInputType.phone, validator: (v) => (v == null || v.isEmpty) ? 'Required' : null),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              decoration: BoxDecoration(color: const Color(0xFFF0F4F8), borderRadius: BorderRadius.circular(14)),
              child: SwitchListTile(
                title: const Text('Available for Consultation', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
                value: _isAvailable,
                onChanged: (v) => setState(() => _isAvailable = v),
                activeColor: const Color(0xFF0077B6),
                contentPadding: EdgeInsets.zero,
              ),
            ),
            const SizedBox(height: 24),
            CustomButton(text: 'Save Changes', onPressed: _handleSave, icon: Icons.save_rounded),
            CustomButton(text: 'Cancel', onPressed: () => Navigator.pop(context), isOutlined: true, icon: Icons.close_rounded),
          ]),
        ),
      ),
    );
  }
}
