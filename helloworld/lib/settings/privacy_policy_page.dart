import 'package:flutter/material.dart';

class PrivacyPolicyPage extends StatelessWidget {
  const PrivacyPolicyPage({super.key});

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
                        'Privacy Policy',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          letterSpacing: 0.5,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Your privacy matters to us',
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
                      icon: Icons.privacy_tip_outlined,
                      iconColor: Color(0xFF5B4AE2),
                      title: '1. Introduction',
                      body: 'At Reader-HUB, we value your privacy and are committed to protecting your personal data.\n\n'
                          'This Privacy Policy explains how we collect, use, and safeguard information when you use our app.\n\n'
                          'By using Reader-HUB, you agree to the terms described in this policy.',
                    ),
                    SizedBox(height: 16),
                    _SectionCard(
                      icon: Icons.data_usage_outlined,
                      iconColor: Color(0xFF00BCD4),
                      title: '2. Information We Collect',
                      body: 'We collect only what\'s necessary to make Reader-HUB work properly and safely:\n\n'
                          '• Account information: email, username, and password (securely encrypted).\n'
                          '• Activity data: posts, reactions, and interactions inside channels.\n'
                          '• Device data: anonymous technical info (app version, OS type, crash logs).\n\n'
                          'We do not collect your private messages, screenshots, or sensitive data.',
                    ),
                    SizedBox(height: 16),
                    _SectionCard(
                      icon: Icons.settings_suggest_outlined,
                      iconColor: Color(0xFF4CAF50),
                      title: '3. How We Use Your Information',
                      body: 'We use the collected information to:\n\n'
                          '• Provide and improve app functionality.\n'
                          '• Recommend relevant content and channels.\n'
                          '• Detect abuse, spam, or policy violations.\n'
                          '• Communicate updates, security notices, or app improvements.\n\n'
                          'Reader-HUB never sells your data to advertisers or third parties.',
                    ),
                    SizedBox(height: 16),
                    _SectionCard(
                      icon: Icons.shield_outlined,
                      iconColor: Color(0xFFFF9800),
                      title: '4. Data Sharing and Security',
                      body: '• Data is stored securely using encryption and trusted cloud services.\n'
                          '• Access to user data is restricted to authorized Reader-HUB team members only.\n'
                          '• We may share limited data with service providers (e.g., payment gateways, analytics) strictly for app operations.\n'
                          '• If required by law, we may disclose information to comply with legal obligations.',
                    ),
                    SizedBox(height: 16),
                    _SectionCard(
                      icon: Icons.cookie_outlined,
                      iconColor: Color(0xFF9C27B0),
                      title: '5. Cookies and Tracking',
                      body: 'Reader-HUB uses minimal, privacy-friendly analytics to understand app performance.\n\n'
                          'We do not use third-party advertising cookies or trackers.',
                    ),
                    SizedBox(height: 16),
                    _SectionCard(
                      icon: Icons.verified_user_outlined,
                      iconColor: Color(0xFFE91E63),
                      title: '6. Your Rights and Control',
                      body: 'You can:\n\n'
                          '• Update or delete your account anytime from Settings → Account.\n'
                          '• Request a copy or deletion of your data via support@readerhub.app.\n'
                          '• Opt out of notifications or personalized suggestions anytime in your app settings.',
                    ),
                    SizedBox(height: 16),
                    _SectionCard(
                      icon: Icons.schedule_outlined,
                      iconColor: Color(0xFFFF5722),
                      title: '7. Data Retention',
                      body: 'We retain your data only as long as your account is active or as required by law.\n\n'
                          'When deleted, your data is permanently removed from our servers within 30 days.',
                    ),
                    SizedBox(height: 16),
                    _SectionCard(
                      icon: Icons.update_outlined,
                      iconColor: Color(0xFF607D8B),
                      title: '8. Changes to This Policy',
                      body: 'We may update this Privacy Policy from time to time.\n\n'
                          'Updates will be announced in-app and take effect once posted.',
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