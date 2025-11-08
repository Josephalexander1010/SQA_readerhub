// lib/settings/settings_page.dart
import 'package:flutter/material.dart';
import 'terms_page.dart';
import 'privacy_policy_page.dart';
import 'about_page.dart';
import 'saved_page.dart';
import 'notifications_page.dart';
import 'ads_info_page.dart';
import 'account_settings_page.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: SafeArea(
        child: Column(
          children: [
            // Header with gradient
            Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFF5B4AE2), Color(0xFF3B2C8D)],
                ),
              ),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
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
                      'Settings',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Search bar
            Padding(
              padding: const EdgeInsets.all(16),
              child: Container(
                decoration: BoxDecoration(
                  color: const Color(0xFFF0F0F0),
                  borderRadius: BorderRadius.circular(25),
                ),
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Search',
                    hintStyle: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 16,
                    ),
                    prefixIcon: Icon(
                      Icons.search,
                      color: Colors.grey[600],
                    ),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 14,
                    ),
                  ),
                ),
              ),
            ),

            // Settings list
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                children: [
                  _buildSectionTitle('Account Settings'),
                  const SizedBox(height: 8),
                  _buildGroupedItems([
                    _buildListItem(
                      icon: Icons.person_outline,
                      title: 'Account',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const AccountSettingsPage()),
                              );
                      },
                      isFirst: true,
                    ),
                    _buildListItem(
                      icon: Icons.shield_outlined,
                      title: 'Data & Privacy',
                      onTap: () {
                        print('Data & Privacy tapped');
                      },
                    ),
                    _buildListItem(
                      icon: Icons.lock_outline,
                      title: 'Security and Account Access',
                      onTap: () {
                        print('Security tapped');
                      },
                      isLast: true,
                    ),
                  ]),

                  const SizedBox(height: 24),
                  _buildSectionTitle('How you use Reader-Hub'),
                  const SizedBox(height: 8),
                  _buildGroupedItems([
                    _buildListItem(
                      icon: Icons.bookmark_outline,
                      title: 'Saved',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => SavedPage()),
                        );
                      },
                      isFirst: true,
                    ),
                    _buildListItem(
                      icon: Icons.notifications_none,
                      title: 'Notifications',
                      onTap: () {
                         Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const NotificationsPage()),
                        );
                      },
                      isLast: true,
                    ),
                  ]),

                  const SizedBox(height: 24),
                  _buildSectionTitle('Additional Resources'),
                  const SizedBox(height: 8),
                  _buildGroupedItems([
                    _buildListItem(
                      icon: Icons.info_outline,
                      title: 'Ads Info',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const AdsInfoPage()),
                        );
                      },
                      isFirst: true,
                    ),

                    // Privacy Policy -> NAVIGATES
                    _buildListItem(
                      icon: Icons.privacy_tip_outlined,
                      title: 'Privacy Policy',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => PrivacyPolicyPage()),
                        );
                      },
                    ),

                    // Terms of Service -> NAVIGATES
                    _buildListItem(
                      icon: Icons.description_outlined,
                      title: 'Terms of Service',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => TermsPage()),
                        );
                      },
                    ),

                    _buildListItem(
                      icon: Icons.help_outline,
                      title: 'About',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => AboutPage()),
                        );
                      },
                      isLast: true,
                    ),
                  ]),

                  const SizedBox(height: 40),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 0, bottom: 0),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: Colors.grey[600],
        ),
      ),
    );
  }

  Widget _buildGroupedItems(List<Widget> items) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: items,
      ),
    );
  }

  Widget _buildListItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    bool isFirst = false,
    bool isLast = false,
  }) {
    return Container(
      decoration: BoxDecoration(
        border: !isLast
            ? Border(
                bottom: BorderSide(
                  color: Colors.grey[200]!,
                  width: 1,
                ),
              )
            : null,
      ),
      child: ListTile(
        leading: Icon(
          icon,
          color: const Color(0xFF3B2C8D),
          size: 24,
        ),
        title: Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Color(0xFF2D2D2D),
          ),
        ),
        trailing: Icon(
          Icons.chevron_right,
          color: Colors.grey[400],
          size: 24,
        ),
        onTap: onTap,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      ),
    );
  }
}