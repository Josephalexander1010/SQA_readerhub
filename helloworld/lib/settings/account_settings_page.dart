//lib/settings/account_settings_page.dart
import 'package:flutter/material.dart';
import '../api_service.dart';
import 'change_password_page.dart';
import 'change_username_page.dart';
import 'change_email_page.dart';
import '../edit_profile_page.dart';

class AccountSettingsPage extends StatefulWidget {
  const AccountSettingsPage({super.key});

  @override
  State<AccountSettingsPage> createState() => _AccountSettingsPageState();
}

class _AccountSettingsPageState extends State<AccountSettingsPage> {
  static const Color primaryPurple = Color(0xFF5B4AE2);
  static const Color darkPurple = Color(0xFF3B2C8D);

  bool _loading = true;
  String _username = '';
  String _displayName = '';
  String _email = '';
  String _phone = '';
  String _about = '';

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    setState(() => _loading = true);
    try {
      final data = await ApiService().getProfile();
      setState(() {
        _username = data['username'] ?? '';
        String firstName = data['first_name'] ?? '';
        if (firstName.trim().isEmpty) {
          _displayName = _username;
        } else {
          _displayName = firstName;
        }
        _email = data['email'] ?? '';
        _phone = data['phone'] ?? '';
        _about = data['about'] ?? '';
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to load profile: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
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
                  colors: [primaryPurple, darkPurple],
                ),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.arrow_back,
                        color: Colors.white, size: 24),
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    'Account',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),

            // ===== BODY =====
            Expanded(
              child: ListView(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
                children: [
                  // Account Information
                  _sectionTitle('Account Information'),
                  const SizedBox(height: 8),
                  _groupCard(
                    children: [
                      _buildRow(
                        label: 'Username',
                        value: _username,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ChangeUsernamePage(
                                  currentUsername: _username),
                            ),
                          ).then((_) => _loadProfile());
                        },
                      ),
                      _divider(),
                      _buildRow(
                        label: 'Display Name',
                        value: _displayName,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => EditProfilePage(
                                initialName: _displayName,
                                initialUsername: '@$_username',
                                initialAbout: _about,
                              ),
                            ),
                          ).then((_) => _loadProfile());
                        },
                      ),
                      _divider(),
                      _buildRow(
                        label: 'Email',
                        value: _email,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  ChangeEmailPage(currentEmail: _email),
                            ),
                          ).then((_) => _loadProfile());
                        },
                      ),
                      _divider(),
                      _buildRow(
                        label: 'Phone',
                        value: _phone.isEmpty ? 'Tap to add phone' : _phone,
                        valueColor: _phone.isEmpty ? Colors.blue : null,
                        onTap: () {
                          _showPhoneDialog();
                        },
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  // How you sign in
                  _sectionTitle('How you sign into your account'),
                  const SizedBox(height: 8),
                  _groupCard(
                    children: [
                      _buildRow(
                        label: 'Password',
                        value: '',
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    const ChangePasswordPage()),
                          );
                        },
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  // Account management
                  _sectionTitle('Account Management'),
                  const SizedBox(height: 8),
                  _groupCard(
                    children: [
                      _buildRow(
                          label: 'Disable Account',
                          value: '',
                          valueColor: Colors.red,
                          onTap: () {}),
                      _divider(),
                      _buildRow(
                        label: 'Delete Account',
                        value: '',
                        valueColor: Colors.red,
                        icon: Icons.delete_outline,
                        iconColor: Colors.red,
                        onTap: () => _confirmDelete(context),
                      ),
                    ],
                  ),

                  const SizedBox(height: 32),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showPhoneDialog() {
    final TextEditingController phoneCtrl = TextEditingController(text: _phone);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Update Phone'),
        content: TextField(
          controller: phoneCtrl,
          keyboardType: TextInputType.phone,
          decoration: const InputDecoration(hintText: 'Enter phone number'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              await _updatePhone(phoneCtrl.text);
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  Future<void> _updatePhone(String newPhone) async {
    setState(() => _loading = true);
    try {
      await ApiService().updateProfile(phone: newPhone);
      await _loadProfile();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Phone number updated')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to update phone: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  // ===== COMPONENTS =====

  Widget _sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 6),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w600,
          color: Colors.grey[700],
        ),
      ),
    );
  }

  Widget _groupCard({required List<Widget> children}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          )
        ],
      ),
      child: Column(children: children),
    );
  }

  Widget _buildRow({
    required String label,
    required String value,
    required VoidCallback onTap,
    Color? valueColor,
    IconData? icon,
    Color? iconColor,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: iconColor ?? const Color(0xFF2D2D2D),
              ),
            ),
            Row(
              children: [
                if (value.isNotEmpty)
                  Text(
                    value,
                    style: TextStyle(
                      fontSize: 14,
                      color: valueColor ?? Colors.grey[600],
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                const SizedBox(width: 8),
                Icon(icon ?? Icons.chevron_right,
                    color: iconColor ?? Colors.grey, size: 22),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _divider() => Divider(height: 1, color: Colors.grey[200]);

  void _confirmDelete(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: const Text('Delete account'),
          content: const Text(
            'Are you sure you want to permanently delete your account? This cannot be undone.',
          ),
          actions: [
            TextButton(
                onPressed: () => Navigator.pop(ctx),
                child: const Text('Cancel')),
            TextButton(
              onPressed: () {
                Navigator.pop(ctx);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Account deleted (demo)')),
                );
              },
              child: const Text('Delete', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }
}
