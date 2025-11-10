// lib/forgot_password.dart
import 'package:flutter/material.dart';
import 'login_page.dart';

const Color primaryPurple = Color(0xFF3E2EA6);

/// Step 1: Input email to receive verification code
class ForgotEmailPage extends StatefulWidget {
  const ForgotEmailPage({super.key});

  @override
  State<ForgotEmailPage> createState() => _ForgotEmailPageState();
}

class _ForgotEmailPageState extends State<ForgotEmailPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailCtrl = TextEditingController();

  @override
  void dispose() {
    _emailCtrl.dispose();
    super.dispose();
  }

  void _onNext() {
    if (_formKey.currentState?.validate() ?? false) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => ForgotVerifyPage(email: _emailCtrl.text.trim()),
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
            // top header fixed
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
                  const Text('Forgot Password',
                      style: TextStyle(color: Colors.black54)),
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
                              // big icon (mail)
                              Container(
                                width: 120,
                                height: 120,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: primaryPurple.withOpacity(0.08),
                                ),
                                child: const Center(
                                  child: Icon(Icons.mark_email_unread_outlined,
                                      size: 56, color: primaryPurple),
                                ),
                              ),

                              const SizedBox(height: 20),
                              const Text(
                                'Forgot Password',
                                style: TextStyle(
                                    color: primaryPurple,
                                    fontSize: 22,
                                    fontWeight: FontWeight.w800),
                              ),

                              const SizedBox(height: 12),
                              const Text(
                                'Please input your email address to\nreceive your verification code',
                                textAlign: TextAlign.center,
                                style: TextStyle(color: Colors.black54),
                              ),

                              const SizedBox(height: 20),

                              Form(
                                key: _formKey,
                                child: Column(
                                  children: [
                                    TextFormField(
                                      controller: _emailCtrl,
                                      keyboardType: TextInputType.emailAddress,
                                      validator: (v) {
                                        if (v == null || v.trim().isEmpty) {
                                          return 'Please enter your registered email address';
                                        }
                                        // simple email check
                                        if (!v.contains('@') ||
                                            !v.contains('.')) {
                                          return 'Enter a valid email';
                                        }
                                        return null;
                                      },
                                      decoration: InputDecoration(
                                        hintText:
                                            'Enter your registered email address',
                                        prefixIcon: const Icon(
                                            Icons.email_outlined,
                                            color: Colors.black54),
                                        filled: true,
                                        fillColor: Colors.white,
                                        contentPadding:
                                            const EdgeInsets.symmetric(
                                                horizontal: 14, vertical: 14),
                                        enabledBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(12),
                                          borderSide: const BorderSide(
                                              color: primaryPurple, width: 1),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(12),
                                          borderSide: const BorderSide(
                                              color: primaryPurple, width: 1.4),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 18),
                                    SizedBox(
                                      width: double.infinity,
                                      height: 46,
                                      child: ElevatedButton(
                                        onPressed: _onNext,
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: primaryPurple,
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(28)),
                                          elevation: 0,
                                        ),
                                        child: const Text('Next',
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.w700)),
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              const SizedBox(height: 28),
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

/// Step 2: Verify code (4 digits) - frontend-only
class ForgotVerifyPage extends StatefulWidget {
  final String email;
  const ForgotVerifyPage({super.key, required this.email});

  @override
  State<ForgotVerifyPage> createState() => _ForgotVerifyPageState();
}

class _ForgotVerifyPageState extends State<ForgotVerifyPage> {
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
    if (code.length < 4) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please enter the 4-digit code')));
      return;
    }
    // success (frontend only) -> go to reset password
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => const ResetPasswordPage()),
    );
  }

  void _resend() {
    ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Verification code resent')));
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
      // header
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12),
              child: Row(
                children: [
                  GestureDetector(
                      onTap: () => Navigator.of(context).pop(),
                      child: const Icon(Icons.arrow_back)),
                  const Expanded(child: SizedBox()),
                  const Text('Step 2/2',
                      style: TextStyle(color: Colors.black54)),
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
                              const Text('Check your Inbox',
                                  style: TextStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.w800,
                                      color: primaryPurple)),
                              const SizedBox(height: 10),
                              const Text(
                                  'Please enter the 4 digit code sent to your email',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(color: Colors.black54)),
                              const SizedBox(height: 12),
                              Text(
                                  widget.email.isEmpty
                                      ? 'your@email.com'
                                      : widget.email,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w700)),
                              const SizedBox(height: 18),
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
                                  child: const Text('Resend Code',
                                      style: TextStyle(
                                          color: Color(0xFFDD2DFE),
                                          fontWeight: FontWeight.w700))),
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
                                  child: const Text('Verify Code',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w700)),
                                ),
                              ),
                              const SizedBox(height: 20),
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

/// Step 3: Reset Password
class ResetPasswordPage extends StatefulWidget {
  const ResetPasswordPage({super.key});

  @override
  State<ResetPasswordPage> createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<ResetPasswordPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _passCtrl = TextEditingController();
  final TextEditingController _confirmCtrl = TextEditingController();
  bool _obscurePass = true;
  bool _obscureConfirm = true;

  @override
  void dispose() {
    _passCtrl.dispose();
    _confirmCtrl.dispose();
    super.dispose();
  }

  void _onReset() {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    // simulate success
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const ResetSuccessPage()),
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
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12),
              child: Row(
                children: [
                  GestureDetector(
                      onTap: () => Navigator.of(context).pop(),
                      child: const Icon(Icons.arrow_back)),
                  const Expanded(child: SizedBox()),
                  const Text('Reset Password',
                      style: TextStyle(color: Colors.black54)),
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
                              Container(
                                width: 120,
                                height: 120,
                                decoration: BoxDecoration(
                                  color: primaryPurple.withOpacity(0.08),
                                  shape: BoxShape.circle,
                                ),
                                child: const Center(
                                    child: Icon(Icons.lock_outline,
                                        size: 56, color: primaryPurple)),
                              ),
                              const SizedBox(height: 18),
                              const Text('Reset Password',
                                  style: TextStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.w800,
                                      color: primaryPurple)),
                              const SizedBox(height: 12),
                              const Text('Enter your new password below',
                                  style: TextStyle(color: Colors.black54)),
                              const SizedBox(height: 18),
                              Form(
                                key: _formKey,
                                child: Column(
                                  children: [
                                    TextFormField(
                                      controller: _passCtrl,
                                      obscureText: _obscurePass,
                                      validator: (v) {
                                        if (v == null || v.isEmpty)
                                          return 'Please enter password';
                                        if (v.length < 4)
                                          return 'Password too short';
                                        return null;
                                      },
                                      decoration: InputDecoration(
                                        hintText: 'Enter password',
                                        prefixIcon: const Icon(
                                            Icons.lock_outline,
                                            color: Colors.black54),
                                        suffixIcon: IconButton(
                                          onPressed: () => setState(() =>
                                              _obscurePass = !_obscurePass),
                                          icon: Icon(_obscurePass
                                              ? Icons.visibility_off
                                              : Icons.visibility),
                                        ),
                                        filled: true,
                                        fillColor: Colors.white,
                                        contentPadding:
                                            const EdgeInsets.symmetric(
                                                horizontal: 14, vertical: 14),
                                        enabledBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(12),
                                          borderSide: const BorderSide(
                                              color: primaryPurple, width: 1),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(12),
                                          borderSide: const BorderSide(
                                              color: primaryPurple, width: 1.4),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 12),
                                    TextFormField(
                                      controller: _confirmCtrl,
                                      obscureText: _obscureConfirm,
                                      validator: (v) {
                                        if (v == null || v.isEmpty)
                                          return 'Please confirm password';
                                        if (v != _passCtrl.text)
                                          return 'Passwords do not match';
                                        return null;
                                      },
                                      decoration: InputDecoration(
                                        hintText: 'Confirm password',
                                        prefixIcon: const Icon(
                                            Icons.lock_outline,
                                            color: Colors.black54),
                                        suffixIcon: IconButton(
                                          onPressed: () => setState(() =>
                                              _obscureConfirm =
                                                  !_obscureConfirm),
                                          icon: Icon(_obscureConfirm
                                              ? Icons.visibility_off
                                              : Icons.visibility),
                                        ),
                                        filled: true,
                                        fillColor: Colors.white,
                                        contentPadding:
                                            const EdgeInsets.symmetric(
                                                horizontal: 14, vertical: 14),
                                        enabledBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(12),
                                          borderSide: const BorderSide(
                                              color: primaryPurple, width: 1),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(12),
                                          borderSide: const BorderSide(
                                              color: primaryPurple, width: 1.4),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 20),
                                    SizedBox(
                                      width: double.infinity,
                                      height: 46,
                                      child: ElevatedButton(
                                        onPressed: _onReset,
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: primaryPurple,
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(28)),
                                          elevation: 0,
                                        ),
                                        child: const Text('Reset Password',
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.w700)),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 24),
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

/// Reset successful screen (full purple)
class ResetSuccessPage extends StatelessWidget {
  const ResetSuccessPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: primaryPurple,
        width: double.infinity,
        height: double.infinity,
        child: SafeArea(
          child: Column(
            children: [
              const SizedBox(height: 80),
              Center(
                child: Container(
                  width: 160,
                  height: 160,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.amber.shade200, width: 6),
                  ),
                  child: const Center(
                      child: Icon(Icons.check, size: 100, color: Colors.white)),
                ),
              ),
              const SizedBox(height: 40),
              const Text(
                'RESET\nSUCCESSFUL',
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 34,
                    fontWeight: FontWeight.w800),
              ),
              const SizedBox(height: 28),
              ElevatedButton(
                onPressed: () {
                  // go back to login page
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (_) => const LoginPage()),
                    (route) => false,
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white.withOpacity(0.12),
                  elevation: 0,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(28)),
                ),
                child: const Text('Back to Login',
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.w700)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
