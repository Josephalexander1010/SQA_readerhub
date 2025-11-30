import 'package:flutter/material.dart';
import 'login_page.dart';
import 'topic_selection_page.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  static const Color primaryPurple = Color(0xFF3E2EA6);

  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameCtrl = TextEditingController();
  final TextEditingController _emailCtrl = TextEditingController();
  final TextEditingController _passCtrl = TextEditingController();
  final TextEditingController _confirmCtrl = TextEditingController();

  bool _obscurePass = true;
  bool _obscureConfirm = true;

  @override
  void dispose() {
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _passCtrl.dispose();
    _confirmCtrl.dispose();
    super.dispose();
  }

  void _onNext() {
    if (_formKey.currentState?.validate() ?? false) {
      // push to verify step (Step 2)
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => SignupVerifyPage(email: _emailCtrl.text.trim()),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // header
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.of(context).pop(),
                    child: const Icon(Icons.arrow_back, color: Colors.black87),
                  ),
                  const Expanded(child: SizedBox()),
                  const Text(
                    'Step 1/3',
                    style: TextStyle(color: Colors.black54, fontSize: 13),
                  ),
                  const Expanded(child: SizedBox()),
                  const SizedBox(width: 24),
                ],
              ),
            ),

            Expanded(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: ConstrainedBox(
                      constraints:
                          BoxConstraints(minHeight: constraints.maxHeight),
                      child: IntrinsicHeight(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 28.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              // logo
                              Image.asset(
                                'assets/images/logo.png',
                                width: 140,
                                height: 140,
                                fit: BoxFit.contain,
                              ),
                              const SizedBox(height: 18),
                              const Text(
                                'Create Your Account',
                                style: TextStyle(
                                    color: primaryPurple,
                                    fontSize: 22,
                                    fontWeight: FontWeight.w800),
                              ),
                              const SizedBox(height: 20),

                              // form
                              Form(
                                key: _formKey,
                                child: Column(
                                  children: [
                                    _buildInputField(
                                        controller: _nameCtrl,
                                        hintText:
                                            'Input your name, e.g John Doe',
                                        prefix: Icons.person_outline,
                                        validator: (v) => v == null || v.isEmpty
                                            ? 'Please enter your name'
                                            : null),
                                    const SizedBox(height: 12),
                                    _buildInputField(
                                        controller: _emailCtrl,
                                        hintText:
                                            'Input your email, e.g John@gmail.com',
                                        prefix: Icons.mail_outline,
                                        validator: (v) => v == null || v.isEmpty
                                            ? 'Please enter your email'
                                            : null),
                                    const SizedBox(height: 12),
                                    _buildInputField(
                                        controller: _passCtrl,
                                        hintText: 'Input your password',
                                        prefix: Icons.lock_outline,
                                        obscureText: _obscurePass,
                                        suffix: IconButton(
                                          onPressed: () => setState(() =>
                                              _obscurePass = !_obscurePass),
                                          icon: Icon(
                                            _obscurePass
                                                ? Icons.visibility_off
                                                : Icons.visibility,
                                            color: Colors.grey[700],
                                          ),
                                        ),
                                        validator: (v) {
                                          if (v == null || v.isEmpty)
                                            return 'Please enter password';
                                          if (v.length < 4)
                                            return 'Password too short';
                                          return null;
                                        }),
                                    const SizedBox(height: 12),
                                    _buildInputField(
                                        controller: _confirmCtrl,
                                        hintText: 'Confirm your password',
                                        prefix: Icons.lock_outline,
                                        obscureText: _obscureConfirm,
                                        suffix: IconButton(
                                          onPressed: () => setState(() =>
                                              _obscureConfirm =
                                                  !_obscureConfirm),
                                          icon: Icon(
                                            _obscureConfirm
                                                ? Icons.visibility_off
                                                : Icons.visibility,
                                            color: Colors.grey[700],
                                          ),
                                        ),
                                        validator: (v) {
                                          if (v == null || v.isEmpty)
                                            return 'Please confirm password';
                                          if (v != _passCtrl.text)
                                            return 'Passwords do not match';
                                          return null;
                                        }),
                                  ],
                                ),
                              ),

                              const SizedBox(height: 26),

                              // Next
                              SizedBox(
                                width: double.infinity,
                                height: 48,
                                child: ElevatedButton(
                                  onPressed: _onNext,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: primaryPurple,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(28),
                                    ),
                                    elevation: 0,
                                  ),
                                  child: const Text('Next',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w700)),
                                ),
                              ),

                              const SizedBox(height: 18),

                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Text('Already have an account? ',
                                      style: TextStyle(color: Colors.black87)),
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.of(context).pushReplacement(
                                        MaterialPageRoute(
                                            builder: (_) => const LoginPage()),
                                      );
                                    },
                                    child: const Text('Sign In',
                                        style: TextStyle(
                                            color: Color(0xFFF5B400),
                                            fontWeight: FontWeight.w700)),
                                  ),
                                ],
                              ),

                              const SizedBox(height: 36),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
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
        hintStyle: const TextStyle(color: Colors.black45, fontSize: 13),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        prefixIcon: Icon(prefix, color: Colors.black54, size: 20),
        suffixIcon: suffix,
        filled: true,
        fillColor: Colors.white,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: primaryPurple, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: primaryPurple, width: 1.4),
        ),
      ),
    );
  }
}

/// ------------------ Step 2: Verify Email ------------------
/// UI: shows email, 4 boxes for code, resend link, verify button
class SignupVerifyPage extends StatefulWidget {
  final String email;
  const SignupVerifyPage({super.key, required this.email});

  @override
  State<SignupVerifyPage> createState() => _SignupVerifyPageState();
}

class _SignupVerifyPageState extends State<SignupVerifyPage> {
  static const Color primaryPurple = Color(0xFF3E2EA6);

  final List<TextEditingController> _digitCtrls =
      List.generate(4, (_) => TextEditingController());
  final List<FocusNode> _digitNodes = List.generate(4, (_) => FocusNode());

  @override
  void dispose() {
    for (var c in _digitCtrls) c.dispose();
    for (var n in _digitNodes) n.dispose();
    super.dispose();
  }

  String get code => _digitCtrls.map((c) => c.text).join();

  void _onVerify() {
    // front-end only: accept when 4 digits entered; otherwise show error
    if (code.length < 4 || code.contains('') && code.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please enter 4-digit code')));
      return;
    }

    // simulate success -> navigate to success screen
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const VerificationSuccessPage()),
    );
  }

  void _resend() {
    // just UI: show snackbar
    ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Verification code resent')));
    // optionally clear inputs:
    for (var c in _digitCtrls) c.clear();
    _digitNodes[0].requestFocus();
  }

  Widget _buildDigitBox(int idx) {
    return SizedBox(
      width: 64,
      height: 64,
      child: TextField(
        controller: _digitCtrls[idx],
        focusNode: _digitNodes[idx],
        textAlign: TextAlign.center,
        keyboardType: TextInputType.number,
        maxLength: 1,
        style: const TextStyle(
            fontSize: 26, fontWeight: FontWeight.w700, color: Colors.black87),
        decoration: InputDecoration(
          counterText: '',
          filled: true,
          fillColor: Colors.white,
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: primaryPurple, width: 2),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: primaryPurple, width: 2.2),
          ),
        ),
        onChanged: (v) {
          if (v.isNotEmpty) {
            if (idx + 1 < _digitCtrls.length) {
              _digitNodes[idx + 1].requestFocus();
            } else {
              _digitNodes[idx].unfocus();
            }
          } else {
            if (idx - 1 >= 0) _digitNodes[idx - 1].requestFocus();
          }
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      // header fixed
      body: SafeArea(
        child: Column(
          children: [
            // top header with back and step
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.of(context).pop(),
                    child: const Icon(Icons.arrow_back, color: Colors.black87),
                  ),
                  const Expanded(child: SizedBox()),
                  const Text('Step 2/3',
                      style: TextStyle(color: Colors.black54, fontSize: 13)),
                  const Expanded(child: SizedBox()),
                  const SizedBox(width: 24),
                ],
              ),
            ),

            const SizedBox(height: 12),

            Expanded(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: ConstrainedBox(
                      constraints:
                          BoxConstraints(minHeight: constraints.maxHeight),
                      child: IntrinsicHeight(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 28.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const SizedBox(height: 4),
                              const Text('Check your Inbox',
                                  style: TextStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.w800,
                                      color: primaryPurple)),
                              const SizedBox(height: 8),
                              const Text(
                                  'we have sent you a verification code by email',
                                  style: TextStyle(color: Colors.black54)),
                              const SizedBox(height: 18),

                              // email display
                              Text(
                                  widget.email.isEmpty
                                      ? 'your@email.com'
                                      : widget.email,
                                  style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w700)),

                              const SizedBox(height: 18),

                              // boxes
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: List.generate(
                                    4,
                                    (i) => Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 8.0),
                                          child: _buildDigitBox(i),
                                        )),
                              ),

                              const SizedBox(height: 12),

                              GestureDetector(
                                onTap: _resend,
                                child: const Text('Resend again',
                                    style: TextStyle(
                                        color: Color(0xFFDD2DFE),
                                        fontWeight: FontWeight.w700)),
                              ),

                              const SizedBox(height: 28),

                              SizedBox(
                                width: double.infinity,
                                height: 48,
                                child: ElevatedButton(
                                  onPressed: _onVerify,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: primaryPurple,
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(28)),
                                    elevation: 0,
                                  ),
                                  child: const Text('Verify Email',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w700)),
                                ),
                              ),

                              const SizedBox(height: 18),

                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Text('Already have an account? ',
                                      style: TextStyle(color: Colors.black87)),
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.of(context).pushReplacement(
                                          MaterialPageRoute(
                                              builder: (_) =>
                                                  const LoginPage()));
                                    },
                                    child: const Text('Sign in',
                                        style: TextStyle(
                                            color: Color(0xFFF5B400),
                                            fontWeight: FontWeight.w700)),
                                  ),
                                ],
                              ),

                              const SizedBox(height: 40),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// ------------------ Verification Success Screen ------------------
class VerificationSuccessPage extends StatelessWidget {
  const VerificationSuccessPage({super.key});
  static const Color primaryPurple = Color(0xFF3E2EA6);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // full purple overlay style similar to your example
      body: Container(
        width: double.infinity,
        height: double.infinity,
        color: primaryPurple,
        child: SafeArea(
          child: Column(
            children: [
              const SizedBox(height: 80),
              // big check icon (outlined)
              Center(
                child: Container(
                  width: 160,
                  height: 160,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.amber.shade200, width: 6),
                  ),
                  child: const Center(
                    child: Icon(Icons.check, size: 100, color: Colors.white),
                  ),
                ),
              ),
              const SizedBox(height: 40),
              const Text(
                'Verification\nSuccess',
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 34,
                    fontWeight: FontWeight.w800),
              ),
              const SizedBox(height: 28),
              // Continue button to main app
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                        builder: (_) => const TopicSelectionPage()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white.withOpacity(0.1),
                  elevation: 0,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(28)),
                ),
                child: const Text('Continue',
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                        fontSize: 16)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
