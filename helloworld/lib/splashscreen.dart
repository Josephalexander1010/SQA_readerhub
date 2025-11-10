import 'dart:async';
import 'package:flutter/material.dart';
import 'onboarding.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // Navigate to NavBar after 2.2 seconds
    Timer(const Duration(milliseconds: 2200), () {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const OnboardingScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          // gradient light blue -> deep purple (mirip contoh)
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF4DA6FF), Color(0xFF3A2E8C)],
          ),
        ),
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: size.height * 0.06),

              // White circular logo container
              Container(
                width: size.width * 0.34,
                height: size.width * 0.34,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Image.asset(
                    'assets/images/logo.png', // pastikan nama file sama
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) {
                      // fallback kalau asset nggak ketemu (bantu debug)
                      return const Icon(Icons.image_not_supported,
                          size: 48, color: Colors.grey);
                    },
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // App name below the logo, white text
              const Text(
                'Reader-HUB',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.6,
                ),
              ),

              const SizedBox(height: 6),
              const Opacity(
                opacity: 0.9,
                child: Text(
                  '', // kosongkan subtitle jika tak perlu
                  style: TextStyle(color: Colors.white70, fontSize: 14),
                ),
              ),

              SizedBox(height: size.height * 0.22),
            ],
          ),
        ),
      ),
    );
  }
}
