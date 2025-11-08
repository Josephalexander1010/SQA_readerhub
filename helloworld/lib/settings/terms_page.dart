import 'package:flutter/material.dart';

class TermsPage extends StatelessWidget {
  const TermsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // ===== HEADER =====
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
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: const Icon(
                      Icons.arrow_back,
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    'Terms of Service',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),

            // ===== BODY =====
            Expanded(
              child: SingleChildScrollView(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    _SectionTitle('1. Introduction'),
                    _SectionBody(
                      'Welcome to Reader-HUB, a community platform designed for readers and fanfic enthusiasts to discuss and share insights about books in a safe, private environment.\n\n'
                      'By using Reader-HUB, you agree to these Terms of Service. Please read them carefully.',
                    ),
                    _SectionTitle('2. Use of Service'),
                    _SectionBody(
                      'You must be at least 13 years old to use Reader-HUB.\n'
                      'You are responsible for any content you post and agree not to upload or share illegal, abusive, or copyrighted material without permission.\n'
                      'You agree not to attempt to copy, reverse engineer, or misuse the Reader-HUB platform.',
                    ),
                    _SectionTitle('3. Privacy & Safety'),
                    _SectionBody(
                      'Reader-HUB implements anti-screenshot and gated-sharing protection to preserve user privacy.\n'
                      'Any attempt to bypass these protections may lead to account suspension.\n'
                      'We collect minimal data necessary for account and app functionality (see our Privacy Policy for details).',
                    ),
                    _SectionTitle('4. User Content'),
                    _SectionBody(
                      'You retain ownership of your posts, comments, and creations.\n'
                      'By posting, you grant Reader-HUB a non-exclusive, worldwide license to display your content within the app.\n'
                      'Reader-HUB may remove content that violates community guidelines or laws.',
                    ),
                    _SectionTitle('5. Community Guidelines'),
                    _SectionBody(
                      'Respect other readers and creators.\n'
                      'Hate speech, harassment, or NSFW content is not allowed.\n'
                      'Moderators may enforce rules within channels and sub-channels.',
                    ),
                    _SectionTitle('6. Monetization & Payments'),
                    _SectionBody(
                      'Reader-HUB allows optional donations, tips, and paid channel boosts.\n'
                      'Payments are handled through secure third-party providers.\n'
                      'Reader-HUB is not responsible for refund policies of third-party payment systems.',
                    ),
                    _SectionTitle('7. Limitation of Liability'),
                    _SectionBody(
                      'Reader-HUB is provided “as is” without warranties.\n'
                      'We are not liable for content posted by users or any damages resulting from service interruptions.',
                    ),
                    _SectionTitle('8. Changes to These Terms'),
                    _SectionBody(
                      'We may update these Terms from time to time. Updates will be announced in-app and take effect immediately upon posting.',
                    ),
                    _SectionTitle('9. Contact Us'),
                    _SectionBody(
                      'For any questions about these Terms, contact us at:\nsupport@readerhub.app',
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

// ====== REUSABLE SECTION WIDGETS ======
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
