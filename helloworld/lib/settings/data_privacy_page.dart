// lib/settings/data_privacy_page.dart
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DataPrivacyPage extends StatefulWidget {
  const DataPrivacyPage({super.key});

  @override
  State<DataPrivacyPage> createState() => _DataPrivacyPageState();
}

class _DataPrivacyPageState extends State<DataPrivacyPage> {
  static const Color primaryPurple = Color(0xFF5B4AE2);
  static const Color darkPurple = Color(0xFF3B2C8D);

  // Preference keys
  static const String _kUseToImprove = 'dp_use_to_improve';
  static const String _kPersonalizeExperience = 'dp_personalize_experience';
  static const String _kUseActivityForSponsored = 'dp_activity_for_sponsored';
  static const String _kThirdPartyPersonalize = 'dp_third_party_personalize';

  bool _loading = true;
  bool _useToImprove = true;
  bool _personalizeExperience = true;
  bool _useActivityForSponsored = true;
  bool _thirdPartyPersonalize = true;

  @override
  void initState() {
    super.initState();
    _loadPrefs();
  }

  Future<void> _loadPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _useToImprove = prefs.getBool(_kUseToImprove) ?? true;
      _personalizeExperience = prefs.getBool(_kPersonalizeExperience) ?? true;
      _useActivityForSponsored = prefs.getBool(_kUseActivityForSponsored) ?? true;
      _thirdPartyPersonalize = prefs.getBool(_kThirdPartyPersonalize) ?? true;
      _loading = false;
    });
  }

  Future<void> _setPref(String key, bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(key, value);
  }

  Widget _buildToggleCard({
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 6, offset: const Offset(0, 2))],
      ),
      child: Row(
        children: [
          // icon circle
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: primaryPurple.withOpacity(0.12),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Center(
              child: Icon(Icons.shield, color: primaryPurple, size: 20),
            ),
          ),

          const SizedBox(width: 12),

          // text
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: Color(0xFF2D2D2D))),
                const SizedBox(height: 6),
                Text(subtitle, style: TextStyle(fontSize: 13, color: Colors.grey[600], height: 1.3)),
                const SizedBox(height: 8),
                GestureDetector(
                  onTap: () {
                    // Optional: show more details modal
                    _showLearnMore(title);
                  },
                  child: Text('Learn more', style: TextStyle(fontSize: 13, color: primaryPurple, fontWeight: FontWeight.w600)),
                ),
              ],
            ),
          ),

          // switch
          const SizedBox(width: 12),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: Colors.white,
            activeTrackColor: primaryPurple,
            inactiveTrackColor: Colors.grey.shade300,
            inactiveThumbColor: Colors.white,
          ),
        ],
      ),
    );
  }

  void _showLearnMore(String title) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(title),
        content: const Text(
          'More details about this setting. This is a placeholder — replace with actual policy copy or link to web view if needed.',
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Close')),
        ],
      ),
    );
  }

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
            // header
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              decoration: const BoxDecoration(
                gradient: LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [primaryPurple, darkPurple]),
              ),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                  ),
                  const SizedBox(width: 8),
                  const Text('Data & Privacy', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w700)),
                  const Spacer(),
                  // optional small help icon
                  IconButton(
                    onPressed: () => _showLearnMore('Data & Privacy'),
                    icon: const Icon(Icons.info_outline, color: Colors.white),
                  )
                ],
              ),
            ),

            // body
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 20),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      // short intro
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(14),
                        margin: const EdgeInsets.only(bottom: 12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.grey.shade200),
                          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 6, offset: const Offset(0, 2))],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Text('Reader-HUB uses certain data to improve your experience. Choose what you want to share below.', style: TextStyle(fontSize: 14, color: Color(0xFF4A4A4A), height: 1.3)),
                          ],
                        ),
                      ),

                      // toggles (matching screenshot order)
                      _buildToggleCard(
                        title: 'Use data to improve Reader-HUB',
                        subtitle: 'Allows us to use and process your information to understand and improve our services.',
                        value: _useToImprove,
                        onChanged: (v) {
                          setState(() => _useToImprove = v);
                          _setPref(_kUseToImprove, v);
                        },
                      ),

                      _buildToggleCard(
                        title: 'Use data to personalize my Reader-HUB experience',
                        subtitle: 'We may use your activity and interactions to show relevant channels and recommendations.',
                        value: _personalizeExperience,
                        onChanged: (v) {
                          setState(() => _personalizeExperience = v);
                          _setPref(_kPersonalizeExperience, v);
                        },
                      ),

                      _buildToggleCard(
                        title: 'Use my Reader-HUB activity to personalize Sponsored Content',
                        subtitle: 'Use activity such as channels you follow or posts you engage with to personalize sponsored content.',
                        value: _useActivityForSponsored,
                        onChanged: (v) {
                          setState(() => _useActivityForSponsored = v);
                          _setPref(_kUseActivityForSponsored, v);
                        },
                      ),

                      _buildToggleCard(
                        title: 'Use third-party data to personalize Sponsored Content',
                        subtitle: 'Allow data from advertisers and partners to be used to tailor sponsored content to you.',
                        value: _thirdPartyPersonalize,
                        onChanged: (v) {
                          setState(() => _thirdPartyPersonalize = v);
                          _setPref(_kThirdPartyPersonalize, v);
                        },
                      ),

                      const SizedBox(height: 30),

                      // Save / Reset row
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton(
                              onPressed: () async {
                                // reset to defaults (all true)
                                setState(() {
                                  _useToImprove = true;
                                  _personalizeExperience = true;
                                  _useActivityForSponsored = true;
                                  _thirdPartyPersonalize = true;
                                });
                                await _setPref(_kUseToImprove, true);
                                await _setPref(_kPersonalizeExperience, true);
                                await _setPref(_kUseActivityForSponsored, true);
                                await _setPref(_kThirdPartyPersonalize, true);
                                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Preferences reset to defaults')));
                              },
                              style: OutlinedButton.styleFrom(
                                side: BorderSide(color: Colors.grey.shade300),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                padding: const EdgeInsets.symmetric(vertical: 14),
                              ),
                              child: const Text('Reset to defaults', style: TextStyle(fontWeight: FontWeight.w600)),
                            ),
                          ),
                          const SizedBox(width: 12),
                          ElevatedButton(
                            onPressed: () {
                              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Preferences saved')));
                              // already persisted on change; this is a convenience action
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: primaryPurple,
                              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                            ),
                            child: const Text('Save', style: TextStyle(fontWeight: FontWeight.w700, color: Colors.white)),
                          ),
                        ],
                      ),

                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
