// lib/settings/about_page.dart
import 'package:flutter/material.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFF5B4AE2), Color(0xFF3B2C8D)],
                ),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF5B4AE2).withOpacity(0.3),
                    blurRadius: 20,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.arrow_back, color: Colors.white, size: 24),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        'About Reader-HUB',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          letterSpacing: 0.5,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Connecting readers and writers',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.white70,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Body
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    _SectionCard(
                      icon: Icons.auto_stories_outlined,
                      iconColor: Color(0xFF5B4AE2),
                      title: '1. What is Reader-HUB?',
                      body: 'Reader-HUB is a digital community platform built for readers, writers, and fanfic enthusiasts to connect, discuss, and share their love for stories — all in a safe, focused space.\n\n'
                          'We combine the discussion power of forums with the creativity of social feeds, letting you explore conversations about your favorite books and fandoms without the clutter or noise of traditional social media.',
                    ),
                    SizedBox(height: 16),
                    _SectionCard(
                      icon: Icons.flag_outlined,
                      iconColor: Color(0xFF00BCD4),
                      title: '2. Our Mission',
                      body: 'To create a privacy-first, discussion-driven community where book lovers can share insights, express creativity, and connect through meaningful, topic-based discussions.\n\n'
                          'We believe your reading interests deserve a home that feels both inspiring and secure.',
                    ),
                    SizedBox(height: 16),
                    _SectionCard(
                      icon: Icons.stars_outlined,
                      iconColor: Color(0xFF4CAF50),
                      title: '3. Key Features',
                      body: '• 📚 Channels & Sub-Channels — Organized by genre, title, or fandom.\n'
                          '• 🔒 Privacy by Design — Anti-screenshot and gated-sharing features protect your discussions.\n'
                          '• 🧠 Smart Search — Quickly find trending topics, tags, or creators related to your interests.\n'
                          '• 🏷️ Community Badges — Recognize active contributors and moderators.\n'
                          '• 💬 Creator-Friendly — Support your favorite authors and communities through tips and boosts.',
                    ),
                    SizedBox(height: 16),
                    _SectionCard(
                      icon: Icons.groups_outlined,
                      iconColor: Color(0xFFFF9800),
                      title: '4. Our Team',
                      body: 'Reader-HUB was created by a group of passionate readers and digital creatives who wanted a safer, smarter way to enjoy online book discussions.\n\n'
                          'We are constantly improving Reader-HUB with your feedback — because this platform belongs to the community that builds it.',
                    ),
                    SizedBox(height: 16),
                    _SectionCard(
                      icon: Icons.mail_outline,
                      iconColor: Color(0xFF9C27B0),
                      title: '5. Contact Us',
                      body: 'We would love to hear from you!\n\n'
                          '📧 support@readerhub.app\n',
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

// ====== REUSABLE SECTION CARD WIDGET ======
class _SectionCard extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final String body;

  const _SectionCard({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.body,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: iconColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    icon,
                    color: iconColor,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF2D2D2D),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              body,
              style: TextStyle(
                fontSize: 15,
                height: 1.7,
                color: const Color(0xFF2D2D2D).withOpacity(0.8),
              ),
            ),
          ],
        ),
      ),
    );
  }
}