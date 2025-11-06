// lib/walkthrough/walkthrough_widget.dart
import 'package:flutter/material.dart';

class WalkthroughWidget extends StatefulWidget {
  final VoidCallback onFinish;

  const WalkthroughWidget({super.key, required this.onFinish});

  @override
  State<WalkthroughWidget> createState() => _WalkthroughWidgetState();
}

class _WalkthroughWidgetState extends State<WalkthroughWidget> {
  int _currentStep = 1;

  // Style yang diambil dari homepage.dart
  static const Color primaryColor = Color(0xFF3B2C8D);
  static const String fontFam = 'Poppins';

  void _nextStep() {
    if (_currentStep == 5) {
      widget.onFinish();
    } else {
      setState(() {
        _currentStep++;
      });
    }
  }

  void _skip() {
    widget.onFinish();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          Colors.transparent, // Penting agar background hitam terlihat
      body: Stack(children: [_buildStepContent(_currentStep)]),
    );
  }

  Widget _buildStepContent(int step) {
    switch (step) {
      case 1:
        return _buildStep1();
      case 2:
        return _buildStep2();
      case 3:
        return _buildStep3();
      case 4:
        return _buildStep4();
      case 5:
        return _buildStep5();
      default:
        return Container();
    }
  }

  // Step 1: Welcome
  Widget _buildStep1() {
    return Positioned(
      top: MediaQuery.of(context).size.height * 0.25,
      left: 20,
      right: 20,
      child: _buildPopupCard(
        step: "Step 1/5",
        title: "Welcome to Reader-HUB!",
        content:
            "Hello There. The one place for all your favorite book and fanfic discussions. Let us give you a quick tour.",
        onContinue: _nextStep,
        onSkip: _skip,
      ),
    );
  }

  // Step 2: Find Communities
  Widget _buildStep2() {
    return Positioned(
      top: 100, // Sesuaikan posisi
      left: 20,
      right: 20,
      child: _buildPopupCard(
        step: "Step 2/5",
        title: "Find Your Communities in Channels",
        content:
            "Think of a Channel as a home for any topic or fandom. Inside, you'll find more specific discussion spaces called sub-channels.",
        onContinue: _nextStep,
        onSkip: _skip,
      ),
    );
  }

  // Step 3: Home Feed
  Widget _buildStep3() {
    return Positioned(
      top: MediaQuery.of(context).size.height * 0.5, // Pindah ke tengah
      left: 20,
      right: 20,
      child: _buildPopupCard(
        step: "Step 3/5",
        title: "And The Most Important, This Is Your Home Feed",
        content:
            "Here, you'll see the latest posts from all the Channels you follow. The more Channels you join, the livelier your feed becomes!",
        onContinue: _nextStep,
        onSkip: _skip,
      ),
    );
  }

  // Step 4: Create
  Widget _buildStep4() {
    return Positioned(
      bottom: 100, // Dekat tombol FAB
      left: 20,
      right: 20,
      child: _buildPopupCard(
        step: "Step 4/5",
        title: "Create Channel or Feeds?",
        content:
            "Want a dedicated space for your book club or a niche topic? You can make your own Channel or Feeds by press this (+) button!",
        onContinue: _nextStep,
        onSkip: _skip,
      ),
    );
  }

  // Step 5: Explore
  Widget _buildStep5() {
    return Positioned(
      top: 150, // Dekat search bar
      left: 20,
      right: 20,
      child: _buildPopupCard(
        step: "Step 5/5",
        title: "You're All Set To Explore",
        content:
            "To get started, use the Search feature to find your first Channel and join the conversation. Enjoy!",
        onContinue: _nextStep,
        onSkip: null, // Sembunyikan Skip di step terakhir
        continueText: "Done",
      ),
    );
  }

  Widget _buildPopupCard({
    required String step,
    required String title,
    required String content,
    required VoidCallback onContinue,
    required VoidCallback? onSkip,
    String continueText = "Continue",
  }) {
    return Material(
      color: Colors.transparent,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              step,
              style: const TextStyle(
                fontFamily: fontFam,
                color: primaryColor,
                fontWeight: FontWeight.w600,
                fontSize: 12,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              title,
              style: const TextStyle(
                fontFamily: fontFam,
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              content,
              style: TextStyle(
                fontFamily: fontFam,
                color: Colors.grey[700],
                fontSize: 14,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                if (onSkip != null)
                  TextButton(
                    onPressed: onSkip,
                    child: const Text(
                      "Skip",
                      style: TextStyle(
                        fontFamily: fontFam,
                        color: Colors.grey,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: onContinue,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(
                    continueText,
                    style: const TextStyle(
                      fontFamily: fontFam,
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
