import 'package:flutter/material.dart';
import '../../widgets/custom_textfield.dart';
import '../../widgets/custom_button.dart';
import '../../data/dummy_data.dart';
import '../register/doctor_register_screen.dart';
import '../doctor/doctor_dashboard_layout.dart';

class DoctorLoginScreen extends StatefulWidget {
  const DoctorLoginScreen({super.key});
  @override
  State<DoctorLoginScreen> createState() => _DoctorLoginScreenState();
}

class _DoctorLoginScreenState extends State<DoctorLoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _handleLogin() {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);
      Future.delayed(const Duration(milliseconds: 800), () {
        final doctor = dummyDoctors.where(
          (d) => d.email == _emailController.text.trim() && d.password == _passwordController.text,
        );
        if (doctor.isNotEmpty && mounted) {
          setState(() => _isLoading = false);
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => DoctorDashboardLayout(doctor: doctor.first)));
        } else if (mounted) {
          setState(() => _isLoading = false);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: const Text('Invalid email or password'), backgroundColor: Colors.redAccent, behavior: SnackBarBehavior.floating, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
          );
        }
      });
    }
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
                const SizedBox(height: 20),
                Center(child: Container(width: 80, height: 80, decoration: BoxDecoration(gradient: const LinearGradient(colors: [Color(0xFF0077B6), Color(0xFF00B4D8)]), borderRadius: BorderRadius.circular(22), boxShadow: [BoxShadow(color: const Color(0xFF0077B6).withOpacity(0.3), blurRadius: 15, offset: const Offset(0, 6))]), child: const Icon(Icons.medical_services_rounded, size: 40, color: Colors.white))),
                const SizedBox(height: 30),
                const Center(child: Text('Doctor Login', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Color(0xFF1A1A2E)))),
                const SizedBox(height: 8),
                Center(child: Text('Sign in to manage your profile', style: TextStyle(fontSize: 14, color: Colors.grey.shade500))),
                const SizedBox(height: 40),
                CustomTextField(controller: _emailController, hintText: 'Email Address', prefixIcon: Icons.email_outlined, keyboardType: TextInputType.emailAddress, validator: (v) { if (v == null || v.isEmpty) return 'Please enter your email'; if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(v)) return 'Please enter a valid email'; return null; }),
                CustomTextField(controller: _passwordController, hintText: 'Password', prefixIcon: Icons.lock_outline, obscureText: _obscurePassword, suffixIcon: IconButton(icon: Icon(_obscurePassword ? Icons.visibility_off_outlined : Icons.visibility_outlined, color: Colors.grey.shade400, size: 20), onPressed: () => setState(() => _obscurePassword = !_obscurePassword)), validator: (v) { if (v == null || v.isEmpty) return 'Please enter your password'; if (v.length < 6) return 'Password must be at least 6 characters'; return null; }),
                const SizedBox(height: 24),
                CustomButton(text: 'Login', onPressed: _handleLogin, isLoading: _isLoading, icon: Icons.login_rounded),
                const SizedBox(height: 20),
                Center(child: GestureDetector(onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const DoctorRegisterScreen())), child: RichText(text: TextSpan(text: "Don't have an account? ", style: TextStyle(color: Colors.grey.shade500, fontSize: 14), children: const [TextSpan(text: 'Register', style: TextStyle(color: Color(0xFF0077B6), fontWeight: FontWeight.bold))])))),
                const SizedBox(height: 20),
                Container(width: double.infinity, padding: const EdgeInsets.all(16), decoration: BoxDecoration(color: const Color(0xFFF0F8FF), borderRadius: BorderRadius.circular(12), border: Border.all(color: const Color(0xFF0077B6).withOpacity(0.2))),
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [const Row(children: [Icon(Icons.info_outline, size: 16, color: Color(0xFF0077B6)), SizedBox(width: 6), Text('Demo Credentials', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Color(0xFF0077B6)))]), const SizedBox(height: 8), Text('Email: priya@doctor.com\nPassword: 123456', style: TextStyle(fontSize: 12, color: Colors.grey.shade600, height: 1.5))])),
                const SizedBox(height: 30),
              ]),
            ),
          ),
        ),
      ),
    );
  }
}
