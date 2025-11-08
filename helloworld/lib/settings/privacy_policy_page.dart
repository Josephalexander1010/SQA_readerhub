// lib/settings/privacy_policy_page.dart
import 'package:flutter/material.dart';

class PrivacyPolicyPage extends StatelessWidget {
  const PrivacyPolicyPage({super.key});

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
                    'Privacy Policy',
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
                      """At Reader-HUB, we value your privacy and are committed to protecting your personal data.
This Privacy Policy explains how we collect, use, and safeguard information when you use our app.
By using Reader-HUB, you agree to the terms described in this policy.""",
                    ),
                    _SectionTitle('2. Information We Collect'),
                    _SectionBody(
                      """We collect only what’s necessary to make Reader-HUB work properly and safely:

• Account information: email, username, and password (securely encrypted).
• Activity data: posts, reactions, and interactions inside channels.
• Device data: anonymous technical info (app version, OS type, crash logs).

We do not collect your private messages, screenshots, or sensitive data.""",
                    ),
                    _SectionTitle('3. How We Use Your Information'),
                    _SectionBody(
                      """We use the collected information to:
• Provide and improve app functionality.
• Recommend relevant content and channels.
• Detect abuse, spam, or policy violations.
• Communicate updates, security notices, or app improvements.

Reader-HUB never sells your data to advertisers or third parties.""",
                    ),
                    _SectionTitle('4. Data Sharing and Security'),
                    _SectionBody(
                      """• Data is stored securely using encryption and trusted cloud services.
• Access to user data is restricted to authorized Reader-HUB team members only.
• We may share limited data with service providers (e.g., payment gateways, analytics) strictly for app operations.
• If required by law, we may disclose information to comply with legal obligations.""",
                    ),
                    _SectionTitle('5. Cookies and Tracking'),
                    _SectionBody(
                      """Reader-HUB uses minimal, privacy-friendly analytics to understand app performance.
We do not use third-party advertising cookies or trackers.""",
                    ),
                    _SectionTitle('6. Your Rights and Control'),
                    _SectionBody(
                      """You can:
• Update or delete your account anytime from Settings → Account.
• Request a copy or deletion of your data via support@readerhub.app.
• Opt out of notifications or personalized suggestions anytime in your app settings.""",
                    ),
                    _SectionTitle('7. Data Retention'),
                    _SectionBody(
                      """We retain your data only as long as your account is active or as required by law.
When deleted, your data is permanently removed from our servers within 30 days.""",
                    ),
                    _SectionTitle('8. Changes to This Policy'),
                    _SectionBody(
                      """We may update this Privacy Policy from time to time.
Updates will be announced in-app and take effect once posted.""",
                    ),
                    _SectionTitle('9. Contact Us'),
                    _SectionBody(
                      """For any questions about these Terms, contact us at:
📧 support@readerhub.app""",
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
