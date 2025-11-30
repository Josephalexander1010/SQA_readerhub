// lib/settings/content_social_page.dart
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ContentSocialPage extends StatefulWidget {
  const ContentSocialPage({super.key});

  @override
  State<ContentSocialPage> createState() => _ContentSocialPageState();
}

class _ContentSocialPageState extends State<ContentSocialPage> {
  static const Color primaryPurple = Color(0xFF5B4AE2);
  static const Color darkPurple = Color(0xFF3B2C8D);

  // Preference keys
  static const String _kDmSpamOption = 'cs_dm_spam_option'; // int enum 0/1/2
  static const String _kAgeRestricted = 'cs_age_restricted'; // bool
  static const String _kFriendEveryone = 'cs_friend_everyone';
  static const String _kFriendFoF = 'cs_friend_fof';
  static const String _kFriendServer = 'cs_friend_server';

  bool _loading = true;

  // Existing state
  int _dmSpamOption = 1; // 0 = Filter all, 1 = Filter from non-friends, 2 = Do not filter
  bool _ageRestricted = false;

  // Friend-request toggles
  bool _friendEveryone = true;
  bool _friendFoF = true;
  bool _friendServer = true;

  // Mock blocked/ignored lists
  final List<String> _blockedAccounts = ['badguy123'];
  final List<String> _ignoredAccounts = <String>[];

  @override
  void initState() {
    super.initState();
    _loadPrefs();
  }

  Future<void> _loadPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final dm = prefs.getInt(_kDmSpamOption) ?? 1;
    final age = prefs.getBool(_kAgeRestricted) ?? false;
    final fe = prefs.getBool(_kFriendEveryone) ?? true;
    final ff = prefs.getBool(_kFriendFoF) ?? true;
    final fs = prefs.getBool(_kFriendServer) ?? true;

    if (!mounted) return;
    setState(() {
      _dmSpamOption = dm;
      _ageRestricted = age;
      _friendEveryone = fe;
      _friendFoF = ff;
      _friendServer = fs;
      _loading = false;
    });
  }

  Future<void> _setBoolPref(String key, bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(key, value);
  }

  Future<void> _setIntPref(String key, int value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(key, value);
  }

  Widget _sectionTitle(String title) => Padding(
        padding: const EdgeInsets.only(left: 4, bottom: 6),
        child: Text(title,
            style: TextStyle(
                fontSize: 13, fontWeight: FontWeight.w600, color: Colors.grey[700])),
      );

  Widget _card({required List<Widget> children}) => Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
                color: Colors.black.withOpacity(0.03),
                blurRadius: 8,
                offset: const Offset(0, 2))
          ],
        ),
        child: Column(children: children),
      );

  Widget _divider() => Divider(height: 1, color: Colors.grey[200]);

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(child: Center(child: CircularProgressIndicator())),
      );
    }

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // HEADER (purple gradient)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [primaryPurple, darkPurple]),
              ),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                  ),
                  const SizedBox(width: 8),
                  const Text('Content & Social',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w700)),
                ],
              ),
            ),

            // BODY
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
                children: [
                  // ----- FRIEND REQUESTS -----
                  _sectionTitle('Friend requests'),
                  const SizedBox(height: 8),
                  _card(
                    children: [
                      _friendToggleRow(
                        label: 'Everyone',
                        subtitle: 'Anyone can send you a friend request',
                        value: _friendEveryone,
                        onChanged: (v) async {
                          if (!mounted) return;
                          setState(() => _friendEveryone = v);
                          await _setBoolPref(_kFriendEveryone, v);
                        },
                      ),
                      _divider(),
                      _friendToggleRow(
                        label: 'Friends of Friends',
                        subtitle: 'Friend requests from friends of people you know',
                        value: _friendFoF,
                        onChanged: (v) async {
                          if (!mounted) return;
                          setState(() => _friendFoF = v);
                          await _setBoolPref(_kFriendFoF, v);
                        },
                      ),
                      _divider(),
                      _friendToggleRow(
                        label: 'Server Members',
                        subtitle: 'Allow people from the same communities to send requests',
                        value: _friendServer,
                        onChanged: (v) async {
                          if (!mounted) return;
                          setState(() => _friendServer = v);
                          await _setBoolPref(_kFriendServer, v);
                        },
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  // ----- BLOCKED / IGNORED -----
                  _sectionTitle("Accounts you've blocked or ignored"),
                  const SizedBox(height: 8),
                  _card(
                    children: [
                      ListTile(
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        leading: Container(
                          width: 42,
                          height: 42,
                          decoration: BoxDecoration(
                              color: primaryPurple.withOpacity(0.12),
                              borderRadius: BorderRadius.circular(10)),
                          child: const Icon(Icons.block, color: primaryPurple),
                        ),
                        title: const Text('Blocked accounts',
                            style: TextStyle(fontWeight: FontWeight.w600)),
                        subtitle: Text(
                            '${_blockedAccounts.length} account${_blockedAccounts.length == 1 ? '' : 's'}',
                            style: TextStyle(color: Colors.grey[600])),
                        trailing: const Icon(Icons.chevron_right, color: Colors.grey),
                        onTap: () => _openBlockedList(),
                      ),
                      _divider(),
                      ListTile(
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        leading: Container(
                          width: 42,
                          height: 42,
                          decoration: BoxDecoration(
                              color: primaryPurple.withOpacity(0.12),
                              borderRadius: BorderRadius.circular(10)),
                          child: const Icon(Icons.visibility_off, color: primaryPurple),
                        ),
                        title: const Text('Ignored accounts',
                            style: TextStyle(fontWeight: FontWeight.w600)),
                        subtitle: Text(
                            '${_ignoredAccounts.length} account${_ignoredAccounts.length == 1 ? '' : 's'}',
                            style: TextStyle(color: Colors.grey[600])),
                        trailing: const Icon(Icons.chevron_right, color: Colors.grey),
                        onTap: () => _openIgnoredList(),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  // ----- DIRECT MESSAGE SPAM -----
                  _sectionTitle('Direct Message spam'),
                  const SizedBox(height: 8),
                  _card(
                    children: [
                      _dmRadioOption(
                        value: 0,
                        title: 'Filter all',
                        subtitle: 'All DMs will be filtered for spam',
                      ),
                      _divider(),
                      _dmRadioOption(
                        value: 1,
                        title: 'Filter from non-friends',
                        subtitle: 'DMs from non-friends will be filtered for spam',
                      ),
                      _divider(),
                      _dmRadioOption(
                        value: 2,
                        title: 'Do not filter',
                        subtitle: 'DMs will not be filtered for spam',
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  // ----- AGE-RESTRICTED COMMANDS -----
                  _sectionTitle('Age-restricted commands'),
                  const SizedBox(height: 8),
                  _card(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        child: Row(
                          children: [
                            Expanded(
                              child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text('Enable age-restricted commands',
                                        style: TextStyle(fontWeight: FontWeight.w600)),
                                    const SizedBox(height: 6),
                                    Text('Allow users 18+ to access certain commands.',
                                        style: TextStyle(color: Colors.grey[600])),
                                  ]),
                            ),
                            Switch(
                              value: _ageRestricted,
                              onChanged: (v) async {
                                if (!mounted) return;
                                setState(() => _ageRestricted = v);
                                await _setBoolPref(_kAgeRestricted, v);
                                if (!mounted) return;
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                      content: Text(v
                                          ? 'Age-restricted commands enabled (mock)'
                                          : 'Age-restricted commands disabled (mock)')),
                                );
                              },
                              activeColor: primaryPurple,
                            ),
                          ],
                        ),
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

  Widget _friendToggleRow({
    required String label,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          Expanded(
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
                  const SizedBox(height: 6),
                  Text(subtitle, style: TextStyle(color: Colors.grey[600])),
                ]),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: primaryPurple,
          ),
        ],
      ),
    );
  }

  Widget _dmRadioOption({
    required int value,
    required String title,
    required String subtitle,
  }) {
    return InkWell(
      onTap: () async {
        if (!mounted) return;
        setState(() => _dmSpamOption = value);
        await _setIntPref(_kDmSpamOption, value);
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            Expanded(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
                    const SizedBox(height: 6),
                    Text(subtitle, style: TextStyle(color: Colors.grey[600])),
                  ]),
            ),
            Radio<int>(
              value: value,
              groupValue: _dmSpamOption,
              onChanged: (v) async {
                if (v == null || !mounted) return;
                setState(() => _dmSpamOption = v);
                await _setIntPref(_kDmSpamOption, v);
              },
              activeColor: primaryPurple,
            ),
          ],
        ),
      ),
    );
  }

  void _openBlockedList() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Blocked accounts'),
        content: SingleChildScrollView(
          child: ListBody(
            children: _blockedAccounts.isEmpty
                ? [const Text('You have not blocked any accounts.')]
                : _blockedAccounts
                    .map((b) => ListTile(title: Text(b)))
                    .toList(),
          ),
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx), child: const Text('Close'))
        ],
      ),
    );
  }

  void _openIgnoredList() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Ignored accounts'),
        content: SingleChildScrollView(
          child: ListBody(
            children: _ignoredAccounts.isEmpty
                ? [const Text('You have not ignored any accounts.')]
                : _ignoredAccounts
                    .map((b) => ListTile(title: Text(b)))
                    .toList(),
          ),
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx), child: const Text('Close'))
        ],
      ),
    );
  }
}