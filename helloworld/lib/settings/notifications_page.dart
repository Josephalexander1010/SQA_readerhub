// lib/settings/notifications_page.dart
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({super.key});

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  static const String _kPushEnabledKey = 'notifications_push_enabled';
  static const String _kPersonalizedKey = 'notifications_personalized';

  bool _pushEnabled = true;
  bool _personalized = true;
  bool _loading = true;

  // simple mock notifications list (in real app load from backend)
  List<_MockNotification> _notifications = [
    _MockNotification(id: '1', title: 'Welcome to Reader-HUB!', body: 'Thanks for joining Reader-HUB — explore Channels to start conversations.'),
    _MockNotification(id: '2', title: 'New reply in "Harry Potter"', body: 'Someone replied to your comment in the Harry Potter channel.'),
    _MockNotification(id: '3', title: 'Channel Boost received', body: 'Your channel received a boost! Check it out.'),
  ];

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

  void _markAllRead() {
    setState(() {
      for (var n in _notifications) n.read = true;
    });
  }

  void _toggleRead(String id) {
    setState(() {
      final n = _notifications.firstWhere((x) => x.id == id);
      n.read = !n.read;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(child: Center(child: CircularProgressIndicator())),
      );
    }

    final unreadCount = _notifications.where((n) => !n.read).length;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // header
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
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                  const Spacer(),
                  if (unreadCount > 0)
                    Text(
                      '$unreadCount',
                      style: const TextStyle(fontSize: 14, color: Colors.white70),
                    ),
                ],
              ),
            ),

            // toggles
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              child: Column(
                children: [
                  _buildToggleRow(
                    title: 'App notifications',
                    subtitle: 'Receive general app notifications (push & in-app).',
                    value: _pushEnabled,
                    onChanged: _setPushEnabled,
                  ),
                  const SizedBox(height: 8),
                  _buildToggleRow(
                    title: 'Personalized suggestions',
                    subtitle: 'Receive suggestions and recommended content based on your activity.',
                    value: _personalized,
                    onChanged: _setPersonalized,
                  ),
                ],
              ),
            ),

            // actions row
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  OutlinedButton.icon(
                    onPressed: _markAllRead,
                    icon: const Icon(Icons.mark_email_read),
                    label: const Text('Mark all read'),
                  ),
                  const SizedBox(width: 12),
                  TextButton(
                    onPressed: () {
                      // open notification settings in system? left as TODO
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Open system notification settings (TODO)')));
                    },
                    child: const Text('System settings'),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 8),

            // notifications list
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
                itemCount: _notifications.length,
                separatorBuilder: (_, __) => const Divider(height: 1),
                itemBuilder: (context, index) {
                  final n = _notifications[index];
                  return ListTile(
                    tileColor: n.read ? null : Colors.grey[50],
                    leading: CircleAvatar(
                      backgroundColor: n.read ? Colors.grey[300] : const Color(0xFF5B4AE2),
                      child: Icon(n.read ? Icons.notifications_none : Icons.notifications, color: Colors.white),
                    ),
                    title: Text(n.title, style: TextStyle(fontWeight: n.read ? FontWeight.w500 : FontWeight.bold)),
                    subtitle: Text(n.body, maxLines: 2, overflow: TextOverflow.ellipsis),
                    trailing: IconButton(
                      icon: Icon(n.read ? Icons.check_circle_outline : Icons.brightness_1, color: n.read ? Colors.grey : const Color(0xFF5B4AE2), size: 18),
                      onPressed: () => _toggleRead(n.id),
                    ),
                    onTap: () {
                      // In a real app you'd open the related content; here we mark read and show details
                      _toggleRead(n.id);
                      showDialog(
                        context: context,
                        builder: (_) {
                          return AlertDialog(
                            title: Text(n.title),
                            content: Text(n.body),
                            actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text('Close'))],
                          );
                        },
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildToggleRow({required String title, required String subtitle, required bool value, required ValueChanged<bool> onChanged}) {
    return Row(
      children: [
        Expanded(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
            const SizedBox(height: 4),
            Text(subtitle, style: TextStyle(fontSize: 13, color: Colors.grey[600])),
          ]),
        ),
        Switch(value: value, onChanged: onChanged, activeColor: const Color(0xFF5B4AE2)),
      ],
    );
  }
}

class _MockNotification {
  final String id;
  final String title;
  final String body;
  bool read;

  _MockNotification({required this.id, required this.title, required this.body, this.read = false});
}
