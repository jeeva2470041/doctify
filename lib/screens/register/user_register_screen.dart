import 'package:flutter/material.dart';
import '../../widgets/custom_textfield.dart';
import '../../widgets/custom_button.dart';
import '../../data/dummy_data.dart';
import '../../models/user_model.dart';
import '../user/user_home_layout.dart';

class UserRegisterScreen extends StatefulWidget {
  const UserRegisterScreen({super.key});
  @override
  State<UserRegisterScreen> createState() => _UserRegisterScreenState();
}

class _UserRegisterScreenState extends State<UserRegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;
  bool _isLoading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _handleRegister() {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);
      Future.delayed(const Duration(milliseconds: 800), () {
        final exists = registeredUsers.any((u) => u.email == _emailController.text.trim());
        if (exists && mounted) {
          setState(() => _isLoading = false);
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: const Text('Email already registered'), backgroundColor: Colors.redAccent, behavior: SnackBarBehavior.floating, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))));
          return;
        }
        final newUser = UserModel(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          name: _nameController.text.trim(),
          email: _emailController.text.trim(),
          password: _passwordController.text,
        );
        registeredUsers.add(newUser);
        if (mounted) {
          setState(() => _isLoading = false);
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: const Text('Registration successful!'), backgroundColor: const Color(0xFF4CAF50), behavior: SnackBarBehavior.floating, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))));
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => UserHomeLayout(user: newUser)));
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
                Center(child: Container(width: 80, height: 80, decoration: BoxDecoration(gradient: const LinearGradient(colors: [Color(0xFF00B4D8), Color(0xFF48CAE4)]), borderRadius: BorderRadius.circular(22), boxShadow: [BoxShadow(color: const Color(0xFF00B4D8).withOpacity(0.3), blurRadius: 15, offset: const Offset(0, 6))]), child: const Icon(Icons.person_add_rounded, size: 40, color: Colors.white))),
                const SizedBox(height: 30),
                const Center(child: Text('User Registration', style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Color(0xFF1A1A2E)))),
                const SizedBox(height: 6),
                Center(child: Text('Create your account', style: TextStyle(fontSize: 14, color: Colors.grey.shade500))),
                const SizedBox(height: 40),
                CustomTextField(controller: _nameController, hintText: 'Full Name', prefixIcon: Icons.person_outline, validator: (v) => (v == null || v.isEmpty) ? 'Please enter your name' : null),
                CustomTextField(controller: _emailController, hintText: 'Email Address', prefixIcon: Icons.email_outlined, keyboardType: TextInputType.emailAddress, validator: (v) { if (v == null || v.isEmpty) return 'Please enter email'; if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(v)) return 'Invalid email'; return null; }),
                CustomTextField(controller: _passwordController, hintText: 'Password', prefixIcon: Icons.lock_outline, obscureText: _obscurePassword, suffixIcon: IconButton(icon: Icon(_obscurePassword ? Icons.visibility_off_outlined : Icons.visibility_outlined, color: Colors.grey.shade400, size: 20), onPressed: () => setState(() => _obscurePassword = !_obscurePassword)), validator: (v) { if (v == null || v.isEmpty) return 'Please enter password'; if (v.length < 6) return 'Min 6 characters'; return null; }),
                const SizedBox(height: 24),
                CustomButton(text: 'Register', onPressed: _handleRegister, isLoading: _isLoading, icon: Icons.app_registration_rounded),
                const SizedBox(height: 20),
                Center(child: GestureDetector(onTap: () => Navigator.pop(context), child: RichText(text: TextSpan(text: 'Already have an account? ', style: TextStyle(color: Colors.grey.shade500, fontSize: 14), children: const [TextSpan(text: 'Login', style: TextStyle(color: Color(0xFF0077B6), fontWeight: FontWeight.bold))])))),
                const SizedBox(height: 30),
              ]),
            ),
          ),
        ),
      ),
    );
  }
}
