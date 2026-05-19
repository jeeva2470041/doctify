import 'package:flutter/material.dart';
import '../../widgets/custom_textfield.dart';
import '../../widgets/custom_button.dart';
import '../../data/dummy_data.dart';
import '../../models/doctor_model.dart';
import '../doctor/doctor_dashboard.dart';

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
        // Check if email already exists
        final exists = dummyDoctors.any((d) => d.email == _emailController.text.trim());
        if (exists && mounted) {
          setState(() => _isLoading = false);
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: const Text('Email already registered'), backgroundColor: Colors.redAccent, behavior: SnackBarBehavior.floating, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))));
          return;
        }
        // Create new doctor and add to list
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
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: const Text('Registration successful!'), backgroundColor: const Color(0xFF4CAF50), behavior: SnackBarBehavior.floating, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))));
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => DoctorDashboard(doctor: newDoctor)));
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
      resizeToAvoidBottomInset: true,
      body: Container(
        width: double.infinity, height: double.infinity,
        decoration: const BoxDecoration(gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [Color(0xFFE8F4FD), Colors.white])),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Form(
              key: _formKey,
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                const SizedBox(height: 20),
                IconButton(onPressed: () => Navigator.pop(context), icon: const Icon(Icons.arrow_back_ios_rounded), color: const Color(0xFF1A1A2E)),
                const SizedBox(height: 10),
                const Center(child: Text('Doctor Registration', style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Color(0xFF1A1A2E)))),
                const SizedBox(height: 6),
                Center(child: Text('Create your doctor profile', style: TextStyle(fontSize: 14, color: Colors.grey.shade500))),
                const SizedBox(height: 30),
                CustomTextField(controller: _nameController, hintText: 'Full Name', prefixIcon: Icons.person_outline, validator: (v) => (v == null || v.isEmpty) ? 'Please enter your name' : null),
                CustomTextField(controller: _emailController, hintText: 'Email Address', prefixIcon: Icons.email_outlined, keyboardType: TextInputType.emailAddress, validator: (v) { if (v == null || v.isEmpty) return 'Please enter email'; if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(v)) return 'Invalid email'; return null; }),
                CustomTextField(controller: _passwordController, hintText: 'Password', prefixIcon: Icons.lock_outline, obscureText: _obscurePassword, suffixIcon: IconButton(icon: Icon(_obscurePassword ? Icons.visibility_off_outlined : Icons.visibility_outlined, color: Colors.grey.shade400, size: 20), onPressed: () => setState(() => _obscurePassword = !_obscurePassword)), validator: (v) { if (v == null || v.isEmpty) return 'Please enter password'; if (v.length < 6) return 'Min 6 characters'; return null; }),
                CustomTextField(controller: _specializationController, hintText: 'Specialization', prefixIcon: Icons.medical_services_outlined, validator: (v) => (v == null || v.isEmpty) ? 'Please enter specialization' : null),
                CustomTextField(controller: _experienceController, hintText: 'Experience (e.g., 5 Years)', prefixIcon: Icons.work_outline, validator: (v) => (v == null || v.isEmpty) ? 'Please enter experience' : null),
                CustomTextField(controller: _hospitalController, hintText: 'Hospital Name', prefixIcon: Icons.local_hospital_outlined, validator: (v) => (v == null || v.isEmpty) ? 'Please enter hospital name' : null),
                CustomTextField(controller: _phoneController, hintText: 'Phone Number', prefixIcon: Icons.phone_outlined, keyboardType: TextInputType.phone, validator: (v) => (v == null || v.isEmpty) ? 'Please enter phone number' : null),
                CustomTextField(controller: _imageUrlController, hintText: 'Profile Image URL (optional)', prefixIcon: Icons.image_outlined),
                const SizedBox(height: 8),
                // Availability Toggle
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
                CustomButton(text: 'Register', onPressed: _handleRegister, isLoading: _isLoading, icon: Icons.app_registration_rounded),
                CustomButton(text: 'Reset', onPressed: _handleReset, isOutlined: true, icon: Icons.refresh_rounded),
                const SizedBox(height: 30),
              ]),
            ),
          ),
        ),
      ),
    );
  }
}
