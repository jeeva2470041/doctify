import 'package:flutter/material.dart';
import '../../models/doctor_model.dart';
import '../../widgets/custom_textfield.dart';
import '../../widgets/custom_dropdown_field.dart';
import '../../widgets/custom_button.dart';
import '../../theme/app_colors.dart';

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

  final List<String> _specializations = [
    'Cardiologist',
    'Neurologist',
    'Dermatologist',
    'Orthopedic Surgeon',
    'Pediatrician',
    'General Physician',
    'Gastroenterologist',
    'Ophthalmologist',
  ];

  final List<String> _experiences = [
    '1 Year',
    '2 Years',
    '3 Years',
    '4 Years',
    '5 Years',
    '6 Years',
    '7 Years',
    '8 Years',
    '9 Years',
    '10 Years',
    '11 Years',
    '12 Years',
    '13 Years',
    '14 Years',
    '15 Years',
    '16 Years',
    '17 Years',
    '18 Years',
    '19 Years',
    '20+ Years',
  ];

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(
        text: widget.doctor.name.replaceFirst('Dr. ', ''));
    _specializationController =
        TextEditingController(text: widget.doctor.specialization);
    _experienceController =
        TextEditingController(text: widget.doctor.experience);
    _hospitalController =
        TextEditingController(text: widget.doctor.hospitalName);
    _phoneController =
        TextEditingController(text: widget.doctor.phoneNumber);
    _isAvailable = widget.doctor.isAvailable;

    // Dynamically insert current values if they are not in the lists to avoid assertion errors
    final initialSpecialization = widget.doctor.specialization;
    if (initialSpecialization.isNotEmpty && !_specializations.contains(initialSpecialization)) {
      _specializations.insert(0, initialSpecialization);
    }

    final initialExperience = widget.doctor.experience;
    if (initialExperience.isNotEmpty && !_experiences.contains(initialExperience)) {
      _experiences.insert(0, initialExperience);
    }
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
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Profile updated successfully!'),
          backgroundColor: AppColors.available,
          behavior: SnackBarBehavior.floating,
        ),
      );
      Navigator.pop(context, updatedDoctor);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Edit Profile'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_rounded),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              CustomTextField(
                  controller: _nameController,
                  hintText: 'Full Name',
                  prefixIcon: Icons.person_outline,
                  validator: (v) =>
                      (v == null || v.isEmpty) ? 'Required' : null),
              CustomDropdownField(
                  value: _specializationController.text,
                  hintText: 'Specialization',
                  prefixIcon: Icons.medical_services_outlined,
                  items: _specializations,
                  onChanged: (val) {
                    setState(() {
                      _specializationController.text = val ?? '';
                    });
                  },
                  validator: (v) =>
                      (v == null || v.isEmpty) ? 'Required' : null),
              CustomDropdownField(
                  value: _experienceController.text,
                  hintText: 'Experience',
                  prefixIcon: Icons.work_outline,
                  items: _experiences,
                  onChanged: (val) {
                    setState(() {
                      _experienceController.text = val ?? '';
                    });
                  },
                  validator: (v) =>
                      (v == null || v.isEmpty) ? 'Required' : null),
              CustomTextField(
                  controller: _hospitalController,
                  hintText: 'Hospital Name',
                  prefixIcon: Icons.local_hospital_outlined,
                  validator: (v) =>
                      (v == null || v.isEmpty) ? 'Required' : null),
              CustomTextField(
                  controller: _phoneController,
                  hintText: 'Phone Number',
                  prefixIcon: Icons.phone_outlined,
                  keyboardType: TextInputType.phone,
                  validator: (v) =>
                      (v == null || v.isEmpty) ? 'Required' : null),
              const SizedBox(height: 8),

              // Availability Toggle
              Container(
                decoration: BoxDecoration(
                  color: AppColors.cardBg,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.border),
                ),
                child: SwitchListTile(
                  title: Text(
                    'Available for Consultation',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  subtitle: Text(
                    _isAvailable
                        ? 'Patients can book appointments'
                        : 'Not accepting bookings',
                    style: TextStyle(
                      fontSize: 12,
                      color: _isAvailable
                          ? AppColors.available
                          : AppColors.textSecondary,
                    ),
                  ),
                  value: _isAvailable,
                  onChanged: (v) => setState(() => _isAvailable = v),
                  activeColor: AppColors.available,
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 16),
                ),
              ),

              const SizedBox(height: 20),

              CustomButton(
                text: 'Save Changes',
                onPressed: _handleSave,
                icon: Icons.save_rounded,
              ),
              CustomButton(
                text: 'Cancel',
                onPressed: () => Navigator.pop(context),
                isOutlined: true,
                icon: Icons.close_rounded,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
