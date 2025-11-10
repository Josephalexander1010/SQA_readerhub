import 'package:flutter/material.dart';
import 'signup_page.dart';
import 'navbar.dart';
import 'forgot_password.dart'; // ensure this file exists (ForgotEmailPage)

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  static const Color primaryPurple = Color(0xFF3E2EA6);

  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailCtrl = TextEditingController();
  final TextEditingController _passCtrl = TextEditingController();

  bool _obscure = true;
  bool _remember = false;

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passCtrl.dispose();
    super.dispose();
  }

  void _trySignIn() {
    if (_formKey.currentState?.validate() ?? false) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const NavBar()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // ✅ latar belakang putih
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: constraints.maxHeight,
                ),
                child: IntrinsicHeight(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32.0),
                    child: Column(
                      mainAxisAlignment:
                          MainAxisAlignment.center, // ✅ tengah vertikal
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // Logo
                        Center(
                          child: Image.asset(
                            'assets/images/logo.png',
                            width: 110,
                            height: 110,
                            fit: BoxFit.contain,
                          ),
                        ),

                        const SizedBox(height: 30),

                        // Title
                        const Text(
                          'Login to Your Account',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: primaryPurple,
                            fontSize: 20,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 0.2,
                          ),
                        ),

                        const SizedBox(height: 26),

                        // Form
                        Form(
                          key: _formKey,
                          child: Column(
                            children: [
                              _buildInputField(
                                controller: _emailCtrl,
                                hintText: 'Enter email or username',
                                prefix: Icons.mail_outline,
                                validator: (v) {
                                  if (v == null || v.trim().isEmpty) {
                                    return 'Please enter email or username';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 16),
                              _buildInputField(
                                controller: _passCtrl,
                                hintText: 'Enter Password',
                                prefix: Icons.lock_outline,
                                obscureText: _obscure,
                                suffix: IconButton(
                                  onPressed: () =>
                                      setState(() => _obscure = !_obscure),
                                  icon: Icon(
                                    _obscure
                                        ? Icons.visibility_off
                                        : Icons.visibility,
                                    color: Colors.grey[700],
                                  ),
                                ),
                                validator: (v) {
                                  if (v == null || v.isEmpty) {
                                    return 'Please enter password';
                                  }
                                  return null;
                                },
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 12),

                        // Remember me + Forgot Password
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            GestureDetector(
                              onTap: () =>
                                  setState(() => _remember = !_remember),
                              child: Row(
                                children: [
                                  Container(
                                    width: 18,
                                    height: 18,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: primaryPurple,
                                        width: 1.5,
                                      ),
                                    ),
                                    child: _remember
                                        ? Center(
                                            child: Container(
                                              width: 8,
                                              height: 8,
                                              decoration: const BoxDecoration(
                                                color: primaryPurple,
                                                shape: BoxShape.circle,
                                              ),
                                            ),
                                          )
                                        : null,
                                  ),
                                  const SizedBox(width: 8),
                                  const Text(
                                    'Remember me',
                                    style: TextStyle(
                                      fontSize: 13.5,
                                      color: Colors.black87,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                // NAVIGATE to Forgot Password flow
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (_) => const ForgotEmailPage(),
                                  ),
                                );
                              },
                              child: const Text(
                                'Forgot Password?',
                                style: TextStyle(
                                  color: Colors.black54,
                                  fontSize: 13.5,
                                ),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 26),

                        // Sign In button
                        SizedBox(
                          width: double.infinity,
                          height: 48,
                          child: ElevatedButton(
                            onPressed: _trySignIn,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: primaryPurple,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                              elevation: 0,
                            ),
                            child: const Text(
                              'Sign In',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                                fontSize: 16,
                                letterSpacing: 0.3,
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 30),

                        // Sign Up link (navigasi ke SignupPage)
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              "Don't have an account? ",
                              style: TextStyle(
                                fontSize: 13.5,
                                color: Colors.black87,
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                // Navigasi ke halaman SignupPage
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                      builder: (_) => const SignupPage()),
                                );
                              },
                              child: const Text(
                                'Sign up',
                                style: TextStyle(
                                  color: Color(0xFFF5B400),
                                  fontWeight: FontWeight.w700,
                                  fontSize: 13.5,
                                ),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 30),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildInputField({
    required TextEditingController controller,
    required String hintText,
    required IconData prefix,
    Widget? suffix,
    bool obscureText = false,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      validator: validator,
      style: const TextStyle(fontSize: 14, color: Colors.black),
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: const TextStyle(color: Colors.black45, fontSize: 14),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        prefixIcon: Icon(prefix, color: Colors.black54, size: 20),
        suffixIcon: suffix,
        filled: true,
        fillColor: Colors.white,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Color(0xFF3E2EA6), width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Color(0xFF3E2EA6), width: 1.5),
        ),
      ),
    );
  }
}
