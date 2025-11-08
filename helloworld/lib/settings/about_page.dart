// lib/settings/about_page.dart
import 'package:flutter/material.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Header
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
                    'About Reader-HUB',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),

            // Body
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    _SectionTitle('1. What is Reader-HUB?'),
                    _SectionBody(
                      'Reader-HUB is a digital community platform built for readers, writers, and fanfic enthusiasts to connect, discuss, and share their love for stories — all in a safe, focused space.\n\n'
                      'We combine the discussion power of forums with the creativity of social feeds, letting you explore conversations about your favorite books and fandoms without the clutter or noise of traditional social media.',
                    ),
                    _SectionTitle('2. Our Mission'),
                    _SectionBody(
                      'To create a privacy-first, discussion-driven community where book lovers can share insights, express creativity, and connect through meaningful, topic-based discussions.\n\n'
                      'We believe your reading interests deserve a home that feels both inspiring and secure.',
                    ),
                    _SectionTitle('3. Key Features'),
                    _SectionBody(
                      '• 📚 Channels & Sub-Channels — Organized by genre, title, or fandom.\n'
                      '• 🔒 Privacy by Design — Anti-screenshot and gated-sharing features protect your discussions.\n'
                      '• 🧠 Smart Search — Quickly find trending topics, tags, or creators related to your interests.\n'
                      '• 🏷️ Community Badges — Recognize active contributors and moderators.\n'
                      '• 💬 Creator-Friendly — Support your favorite authors and communities through tips and boosts.',
                    ),
                    _SectionTitle('4. Our Team'),
                    _SectionBody(
                      'Reader-HUB was created by a group of passionate readers and digital creatives who wanted a safer, smarter way to enjoy online book discussions.\n\n'
                      'We’re constantly improving Reader-HUB with your feedback — because this platform belongs to the community that builds it.',
                    ),
                    _SectionTitle('5. Contact Us'),
                    _SectionBody(
                      'We’d love to hear from you!\n\n'
                      '📧 support@readerhub.app\n'
                      '🌐 www.readerhub.app',
                    ),
                    SizedBox(height: 30),
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

// small reusable widgets (same style as other pages)
class _SectionTitle extends StatelessWidget {
  final String text;
  const _SectionTitle(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 16, bottom: 8),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Color(0xFF3B2C8D),
        ),
      ),
    );
  }
}

class _SectionBody extends StatelessWidget {
  final String text;
  const _SectionBody(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 15,
          height: 1.6,
          color: Color(0xFF2D2D2D),
        ),
      ),
    );
  }
}
