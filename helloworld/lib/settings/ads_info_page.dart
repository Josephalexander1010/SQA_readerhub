import 'package:flutter/material.dart';

class AdsInfoPage extends StatelessWidget {
  const AdsInfoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // ===== HEADER WITH GRADIENT =====
            Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFF5B4AE2), Color(0xFF3B2C8D)],
                ),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.arrow_back, color: Colors.white, size: 24),
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    'Ads Info',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),

            // ===== CONTENT =====
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    _SectionTitle('1. About Ads on Reader-HUB'),
                    _SectionBody(
                      'Reader-HUB is a privacy-first platform. We do not show intrusive ads or sell your personal data to advertisers. '
                      'Our approach focuses on respecting user privacy while supporting creators and platform growth through optional, relevant promotions.',
                    ),
                    SizedBox(height: 20),
                    _SectionTitle('2. What You May See'),
                    _SectionBody(
                      'Occasionally, Reader-HUB may feature:\n'
                      '• Promoted channels or posts relevant to your reading interests.\n'
                      '• Non-targeted community promotions (e.g., featured authors or fandom events).\n'
                      '• Reader-HUB internal updates or feature highlights.\n\n'
                      'These are designed to enhance your experience — not track or manipulate it.',
                    ),
                    SizedBox(height: 20),
                    _SectionTitle('3. No Third-Party Tracking'),
                    _SectionBody(
                      'We do not use third-party ad networks, trackers, or cookies to serve personalized ads. '
                      'Reader-HUB’s ad delivery is handled internally, without sharing your data with external advertisers.',
                    ),
                    SizedBox(height: 20),
                    _SectionTitle('4. Supporting Creators'),
                    _SectionBody(
                      'Creators on Reader-HUB can choose to promote their channels or receive tips and boosts from readers. '
                      'These community-driven features help sustain creators without compromising anyone’s privacy.',
                    ),
                    SizedBox(height: 20),
                    _SectionTitle('5. Managing Ad Preferences'),
                    _SectionBody(
                      'You can manage your ad and promotion settings at any time:\n'
                      '• Go to Settings → Data & Privacy → Ad Preferences.\n'
                      '• Choose whether to see community promotions or sponsored channels.\n\n'
                      'Reader-HUB ensures you always have control over what appears in your feed.',
                    ),
                    SizedBox(height: 20),
                    _SectionTitle('6. Contact Us'),
                    _SectionBody(
                      'If you have questions or concerns about our ad policies, reach out to:\n'
                      '📧 support@readerhub.app',
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String text;
  const _SectionTitle(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: Color(0xFF2D2D2D),
      ),
    );
  }
}

class _SectionBody extends StatelessWidget {
  final String text;
  const _SectionBody(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 15,
        height: 1.6,
        color: Color(0xFF4A4A4A),
      ),
    );
  }
}
