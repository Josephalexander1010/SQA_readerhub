import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({super.key});

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

enum ReactionMode { all, direct, never }

class _NotificationsPageState extends State<NotificationsPage> {
  static const String _kPushEnabledKey = 'notifications_push_enabled';
  static const String _kPersonalizedKey = 'notifications_personalized';
  static const String _kReaderHubKey = 'notifications_reader_hub';
  static const String _kMessageEveryKey = 'notifications_every_message';
  static const String _kReactionKey = 'notifications_reaction_mode';

  bool _pushEnabled = true; // legacy - kept for backward compatibility
  bool _personalized = true; // legacy
  bool _loading = true;

  // New settings
  bool _readerHub = true;
  bool _notifyEveryMessage = false;
  ReactionMode _reactionMode = ReactionMode.all;

  @override
  void initState() {
    super.initState();
    _loadPrefs();
  }

  Future<void> _loadPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _pushEnabled = prefs.getBool(_kPushEnabledKey) ?? true;
      _personalized = prefs.getBool(_kPersonalizedKey) ?? true;
      _readerHub = prefs.getBool(_kReaderHubKey) ?? true;
      _notifyEveryMessage = prefs.getBool(_kMessageEveryKey) ?? false;

      final r = prefs.getInt(_kReactionKey);
      if (r != null) {
        _reactionMode = ReactionMode.values[r.clamp(0, ReactionMode.values.length - 1)];
      } else {
        _reactionMode = ReactionMode.all;
      }

      _loading = false;
    });
  }

  Future<void> _setPushEnabled(bool v) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_kPushEnabledKey, v);
    setState(() => _pushEnabled = v);
    // TODO: register/unregister push token with backend or plugin
  }

  Future<void> _setPersonalized(bool v) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_kPersonalizedKey, v);
    setState(() => _personalized = v);
    // TODO: update personalization preference on backend
  }

  Future<void> _setReaderHub(bool v) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_kReaderHubKey, v);
    setState(() => _readerHub = v);
    // TODO: enable/disable in-app Reader Hub notifications
  }

  Future<void> _setNotifyEveryMessage(bool v) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_kMessageEveryKey, v);
    setState(() => _notifyEveryMessage = v);
    // TODO: inform convo/message service about "notify every message" preference
  }

  Future<void> _setReactionMode(ReactionMode mode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_kReactionKey, mode.index);
    setState(() => _reactionMode = mode);
    // TODO: update reaction notification preference on backend
  }

  // Discord-like pill container
  Widget _pill({required Widget child}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE3E5E8)),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: child,
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(
        backgroundColor: Color(0xFFF2F3F5),
        body: SafeArea(child: Center(child: CircularProgressIndicator())),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF2F3F5),
      body: SafeArea(
        child: Column(
          children: [
            // header with gradient
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
                    'Notifications',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),

            // content
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                children: [
                  // In-app / System sections separated like Discord
                  const Padding(
                    padding: EdgeInsets.only(bottom: 8.0),
                    child: Text('In-app notifications', style: TextStyle(color: Color(0xFF4E5058), fontWeight: FontWeight.w600)),
                  ),

                  _pill(
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: const [
                              Text('Get notifications within Reader Hub', style: TextStyle(fontWeight: FontWeight.w600, color: Color(0xFF060607))),
                              SizedBox(height: 4),
                              Text('Show notification badges and messages inside the Reader Hub.', style: TextStyle(color: Color(0xFF4E5058), fontSize: 13)),
                            ],
                          ),
                        ),
                        Switch(
                          value: _readerHub,
                          onChanged: _setReaderHub,
                          activeColor: const Color(0xFF5865F2),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 12),

                  const Padding(
                    padding: EdgeInsets.only(top: 6.0, bottom: 8.0),
                    child: Text('System notifications', style: TextStyle(color: Color(0xFF4E5058), fontWeight: FontWeight.w600)),
                  ),

                  // Example of a navigable row (keeps existing behavior unchanged)
                  _pill(
                    child: ListTile(
                      contentPadding: EdgeInsets.zero,
                      dense: true,
                      title: const Text('Get notifications outside of Reader Hub', style: TextStyle(color: Color(0xFF060607), fontWeight: FontWeight.w600)),
                      subtitle: const Text('Configure push & system notification settings.', style: TextStyle(color: Color(0xFF4E5058), fontSize: 13)),
                      trailing: const Icon(Icons.chevron_right, color: Color(0xFF4E5058)),
                      onTap: () {}, // keep behavior - currently a placeholder
                    ),
                  ),

                  const SizedBox(height: 12),

                  _pill(
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: const [
                              Text('Notify on every new message in conversations', style: TextStyle(fontWeight: FontWeight.w600, color: Color(0xFF060607))),
                              SizedBox(height: 4),
                              Text('Receive a notification for every incoming message in conversations.', style: TextStyle(color: Color(0xFF4E5058), fontSize: 13)),
                            ],
                          ),
                        ),
                        Switch(
                          value: _notifyEveryMessage,
                          onChanged: _setNotifyEveryMessage,
                          activeColor: const Color(0xFF5865F2),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 18),

                  const Padding(
                    padding: EdgeInsets.only(bottom: 8.0),
                    child: Text('Other notifications', style: TextStyle(color: Color(0xFF4E5058), fontWeight: FontWeight.w600)),
                  ),

                  _pill(
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: const [
                            Text('Get notifications when your friends stream', style: TextStyle(fontWeight: FontWeight.w600, color: Color(0xFF060607))),
                            SizedBox(height: 4),
                            Text('Be notified when a friend starts streaming.', style: TextStyle(color: Color(0xFF4E5058), fontSize: 13)),
                          ]),
                        ),
                        // placeholder toggle for stream notifications - kept as a visual element
                        Switch(value: true, onChanged: (_) {}, activeColor: const Color(0xFF5865F2)),
                      ],
                    ),
                  ),

                  const SizedBox(height: 18),

                  const Padding(
                    padding: EdgeInsets.only(bottom: 8.0),
                    child: Text('Reaction notifications', style: TextStyle(color: Color(0xFF4E5058), fontWeight: FontWeight.w600)),
                  ),

                  _pill(
                    child: Column(
                      children: [
                        RadioListTile<ReactionMode>(
                          contentPadding: EdgeInsets.zero,
                          title: const Text('All messages', style: TextStyle(color: Color(0xFF060607), fontWeight: FontWeight.w600)),
                          subtitle: const Text('Notify when anyone reacts to any message.', style: TextStyle(color: Color(0xFF4E5058), fontSize: 13)),
                          value: ReactionMode.all,
                          groupValue: _reactionMode,
                          onChanged: (v) => v != null ? _setReactionMode(v) : null,
                          activeColor: const Color(0xFF5865F2),
                        ),
                        RadioListTile<ReactionMode>(
                          contentPadding: EdgeInsets.zero,
                          title: const Text('Only direct messages', style: TextStyle(color: Color(0xFF060607), fontWeight: FontWeight.w600)),
                          subtitle: const Text('Notify only for reactions on messages sent directly to you.', style: TextStyle(color: Color(0xFF4E5058), fontSize: 13)),
                          value: ReactionMode.direct,
                          groupValue: _reactionMode,
                          onChanged: (v) => v != null ? _setReactionMode(v) : null,
                          activeColor: const Color(0xFF5865F2),
                        ),
                        RadioListTile<ReactionMode>(
                          contentPadding: EdgeInsets.zero,
                          title: const Text('Never', style: TextStyle(color: Color(0xFF060607), fontWeight: FontWeight.w600)),
                          subtitle: const Text('Never send reaction notifications.', style: TextStyle(color: Color(0xFF4E5058), fontSize: 13)),
                          value: ReactionMode.never,
                          groupValue: _reactionMode,
                          onChanged: (v) => v != null ? _setReactionMode(v) : null,
                          activeColor: const Color(0xFF5865F2),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 18),

                  // legacy personalization option kept but styled
                  _pill(
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: const [
                            Text('Personalized suggestions', style: TextStyle(fontWeight: FontWeight.w600, color: Color(0xFF060607))),
                            SizedBox(height: 4),
                            Text('Receive suggestions and recommended content based on your activity.', style: TextStyle(color: Color(0xFF4E5058), fontSize: 13)),
                          ]),
                        ),
                        Switch(value: _personalized, onChanged: _setPersonalized, activeColor: const Color(0xFF5865F2)),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 4.0),
                    child: Text(
                      "Tip: Changes are saved locally. Connect to your account or backend to sync preferences across devices.",
                      style: TextStyle(fontSize: 12, color: Color(0xFF747F8D)),
                    ),
                  ),

                  const SizedBox(height: 24),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}