import 'package:flutter/material.dart';

class TermsPage extends StatelessWidget {
  const TermsPage({super.key});

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
                        'Terms of Service',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          letterSpacing: 0.5,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Please read carefully',
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
                      icon: Icons.info_outline,
                      iconColor: Color(0xFF5B4AE2),
                      title: '1. Introduction',
                      body: 'Welcome to Reader-HUB, a community platform designed for readers and fanfic enthusiasts to discuss and share insights about books in a safe, private environment.\n\n'
                          'By using Reader-HUB, you agree to these Terms of Service. Please read them carefully.',
                    ),
                    SizedBox(height: 16),
                    _SectionCard(
                      icon: Icons.phone_android_outlined,
                      iconColor: Color(0xFF00BCD4),
                      title: '2. Use of Service',
                      body: '• You must be at least 13 years old to use Reader-HUB.\n'
                          '• You are responsible for any content you post and agree not to upload or share illegal, abusive, or copyrighted material without permission.\n'
                          '• You agree not to attempt to copy, reverse engineer, or misuse the Reader-HUB platform.',
                    ),
                    SizedBox(height: 16),
                    _SectionCard(
                      icon: Icons.security_outlined,
                      iconColor: Color(0xFF4CAF50),
                      title: '3. Privacy & Safety',
                      body: '• Reader-HUB implements anti-screenshot and gated-sharing protection to preserve user privacy.\n'
                          '• Any attempt to bypass these protections may lead to account suspension.\n'
                          '• We collect minimal data necessary for account and app functionality (see our Privacy Policy for details).',
                    ),
                    SizedBox(height: 16),
                    _SectionCard(
                      icon: Icons.edit_outlined,
                      iconColor: Color(0xFFFF9800),
                      title: '4. User Content',
                      body: '• You retain ownership of your posts, comments, and creations.\n'
                          '• By posting, you grant Reader-HUB a non-exclusive, worldwide license to display your content within the app.\n'
                          '• Reader-HUB may remove content that violates community guidelines or laws.',
                    ),
                    SizedBox(height: 16),
                    _SectionCard(
                      icon: Icons.groups_outlined,
                      iconColor: Color(0xFF9C27B0),
                      title: '5. Community Guidelines',
                      body: '• Respect other readers and creators.\n'
                          '• Hate speech, harassment, or NSFW content is not allowed.\n'
                          '• Moderators may enforce rules within channels and sub-channels.',
                    ),
                    SizedBox(height: 16),
                    _SectionCard(
                      icon: Icons.payment_outlined,
                      iconColor: Color(0xFFE91E63),
                      title: '6. Monetization & Payments',
                      body: '• Reader-HUB allows optional donations, tips, and paid channel boosts.\n'
                          '• Payments are handled through secure third-party providers.\n'
                          '• Reader-HUB is not responsible for refund policies of third-party payment systems.',
                    ),
                    SizedBox(height: 16),
                    _SectionCard(
                      icon: Icons.shield_outlined,
                      iconColor: Color(0xFFFF5722),
                      title: '7. Limitation of Liability',
                      body: 'Reader-HUB is provided "as is" without warranties.\n\n'
                          'We are not liable for content posted by users or any damages resulting from service interruptions.',
                    ),
                    SizedBox(height: 16),
                    _SectionCard(
                      icon: Icons.update_outlined,
                      iconColor: Color(0xFF607D8B),
                      title: '8. Changes to These Terms',
                      body: 'We may update these Terms from time to time. Updates will be announced in-app and take effect immediately upon posting.',
                    ),
                    SizedBox(height: 16),
                    _SectionCard(
                      icon: Icons.mail_outline,
                      iconColor: Color(0xFF3F51B5),
                      title: '9. Contact Us',
                      body: 'For any questions about these Terms, contact us at:\n\n📧 support@readerhub.app',
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