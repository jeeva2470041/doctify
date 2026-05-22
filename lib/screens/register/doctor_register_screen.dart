import 'package:flutter/material.dart';
import '../../widgets/custom_textfield.dart';
import '../../widgets/custom_dropdown_field.dart';
import '../../widgets/custom_button.dart';
import '../../data/dummy_data.dart';
import '../../models/doctor_model.dart';
import '../../theme/app_colors.dart';
import '../doctor/doctor_dashboard_layout.dart';

class DoctorRegisterScreen extends StatefulWidget {
  const DoctorRegisterScreen({super.key});
  @override
  State<DoctorRegisterScreen> createState() => _DoctorRegisterScreenState();
}

class _DoctorRegisterScreenState extends State<DoctorRegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _specializationController = TextEditingController();
  final _experienceController = TextEditingController();
  final _hospitalController = TextEditingController();
  final _phoneController = TextEditingController();
  final _imageUrlController = TextEditingController();
  bool _isAvailable = true;
  bool _obscurePassword = true;
  bool _isLoading = false;

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
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _specializationController.dispose();
    _experienceController.dispose();
    _hospitalController.dispose();
    _phoneController.dispose();
    _imageUrlController.dispose();
    super.dispose();
  }

  void _handleRegister() {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);
      Future.delayed(const Duration(milliseconds: 800), () {
        final exists = dummyDoctors
            .any((d) => d.email == _emailController.text.trim());
        if (exists && mounted) {
          setState(() => _isLoading = false);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text('Email already registered'),
              backgroundColor: AppColors.busy,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
            ),
          );
          return;
        }
        final newDoctor = DoctorModel(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          name: 'Dr. ${_nameController.text.trim()}',
          email: _emailController.text.trim(),
          password: _passwordController.text,
          specialization: _specializationController.text.trim(),
          experience: _experienceController.text.trim(),
          hospitalName: _hospitalController.text.trim(),
          phoneNumber: _phoneController.text.trim(),
          isAvailable: _isAvailable,
          profileImageUrl: _imageUrlController.text.trim(),
        );
        dummyDoctors.add(newDoctor);
        if (mounted) {
          setState(() => _isLoading = false);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text('Registration successful!'),
              backgroundColor: AppColors.available,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
            ),
          );
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (_) => DoctorDashboardLayout(doctor: newDoctor)),
          );
        }
      });
    }
  }

  void _handleReset() {
    _nameController.clear();
    _emailController.clear();
    _passwordController.clear();
    _specializationController.clear();
    _experienceController.clear();
    _hospitalController.clear();
    _phoneController.clear();
    _imageUrlController.clear();
    setState(() => _isAvailable = true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      resizeToAvoidBottomInset: true,
      body: Column(
        children: [
          // ---- Gradient Header ----
          Container(
            width: double.infinity,
            decoration: const BoxDecoration(
              gradient: AppColors.primaryGradientV,
            ),
            child: SafeArea(
              bottom: false,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 28),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        width: 38,
                        height: 38,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.20),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(
                          Icons.arrow_back_ios_rounded,
                          color: Colors.white,
                          size: 18,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        Container(
                          width: 52,
                          height: 52,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.20),
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: const Icon(Icons.medical_services_rounded,
                              size: 26, color: Colors.white),
                        ),
                        const SizedBox(width: 14),
                        const Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Doctor Registration',
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            Text(
                              'Create your doctor profile',
                              style: TextStyle(
                                  fontSize: 13, color: Colors.white70),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),

          // ---- Form Section ----
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(24, 24, 24, 24),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    CustomTextField(
                      controller: _nameController,
                      hintText: 'Full Name',
                      prefixIcon: Icons.person_outline,
                      validator: (v) => (v == null || v.isEmpty)
                          ? 'Please enter your name'
                          : null,
                    ),
                    CustomTextField(
                      controller: _emailController,
                      hintText: 'Email Address',
                      prefixIcon: Icons.email_outlined,
                      keyboardType: TextInputType.emailAddress,
                      validator: (v) {
                        if (v == null || v.isEmpty) return 'Please enter email';
                        if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                            .hasMatch(v)) return 'Invalid email';
                        return null;
                      },
                    ),
                    CustomTextField(
                      controller: _passwordController,
                      hintText: 'Password',
                      prefixIcon: Icons.lock_outline,
                      obscureText: _obscurePassword,
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscurePassword
                              ? Icons.visibility_off_outlined
                              : Icons.visibility_outlined,
                          color: AppColors.textHint,
                          size: 20,
                        ),
                        onPressed: () => setState(
                            () => _obscurePassword = !_obscurePassword),
                      ),
                      validator: (v) {
                        if (v == null || v.isEmpty)
                          return 'Please enter password';
                        if (v.length < 6) return 'Min 6 characters';
                        return null;
                      },
                    ),
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
                      validator: (v) => (v == null || v.isEmpty)
                          ? 'Please select specialization'
                          : null,
                    ),
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
                      validator: (v) => (v == null || v.isEmpty)
                          ? 'Please select experience'
                          : null,
                    ),
                    CustomTextField(
                      controller: _hospitalController,
                      hintText: 'Hospital Name',
                      prefixIcon: Icons.local_hospital_outlined,
                      validator: (v) => (v == null || v.isEmpty)
                          ? 'Please enter hospital name'
                          : null,
                    ),
                    CustomTextField(
                      controller: _phoneController,
                      hintText: 'Phone Number',
                      prefixIcon: Icons.phone_outlined,
                      keyboardType: TextInputType.phone,
                      validator: (v) => (v == null || v.isEmpty)
                          ? 'Please enter phone number'
                          : null,
                    ),
                    CustomTextField(
                      controller: _imageUrlController,
                      hintText: 'Profile Image URL (optional)',
                      prefixIcon: Icons.image_outlined,
                    ),

                    const SizedBox(height: 4),

                    // ---- Availability Toggle ----
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

                    const SizedBox(height: 16),

                    CustomButton(
                      text: 'Register',
                      onPressed: _handleRegister,
                      isLoading: _isLoading,
                      icon: Icons.app_registration_rounded,
                    ),
                    CustomButton(
                      text: 'Reset',
                      onPressed: _handleReset,
                      isOutlined: true,
                      icon: Icons.refresh_rounded,
                    ),

                    const SizedBox(height: 8),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
