// lib/notificationpage.dart (Perbaikan AppBar)
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'feed.dart'; // <-- Menggunakan file feed.dart yang sudah direfaktor

class NotificationPage extends StatefulWidget {
  const NotificationPage({super.key});

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  // State untuk like/save tetap di halaman ini
  final Map<int, bool> _likedFeeds = {};
  final Map<int, bool> _savedFeeds = {};

  // Data mock tetap di halaman ini
  final List<Map<String, dynamic>> _notificationFeeds = [
    {
      'id': 20,
      'username': 'Jane Smith',
      'imageUrl': 'https://randomuser.me/api/portraits/women/31.jpg',
      'channel': 'Harry Potter',
      'subtitle': 'Harry x Hermoi..',
      'time': '1h',
      'content': 'Saya suka sekali dengan cerita ini! 🔥',
      'comments': 12,
      'likes': 150,
      'hasImage': false,
    },
    {
      'id': 21,
      'username': 'Reading Club',
      'imageUrl': 'https://randomuser.me/api/portraits/men/18.jpg',
      'channel': 'Reading Club',
      'subtitle': 'General',
      'time': '5h',
      'content': 'Jangan lupa event mingguan kita malam ini!',
      'comments': 95,
      'likes': 1300,
      'hasImage': true,
    },
    {
      'id': 22,
      'username': 'Mike Johnson',
      'imageUrl': 'https://randomuser.me/api/portraits/men/46.jpg',
      'channel': 'Book Lovers',
      'subtitle': 'Review',
      'time': '2d',
      'content': 'Baru selesai baca buku A, ini review saya...',
      'comments': 40,
      'likes': 320,
      'hasImage': false,
    }
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF8F9FA),
        elevation: 1,
        shadowColor: Colors.grey[200],
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.grey[800]),
          onPressed: () => Navigator.of(context).pop(),
        ),

        // =======================================================
        // PERUBAHAN GAYA APPBAR SESUAI PERMINTAAN
        // =======================================================
        centerTitle: false, // Membuat title rata kiri
        titleSpacing: 0, // Menghilangkan spasi default antara leading dan title
        title: Row(
          children: [
            const Text(
              'Notifications',
              style: TextStyle(
                fontSize: 26, // Ukuran font dari homepage.dart
                fontWeight: FontWeight.bold, // Font weight dari homepage.dart
                color: Color(0xFF3B2C8D), // Warna dari homepage.dart
                fontFamily: 'Poppins',
              ),
            ),
            const SizedBox(width: 6),
            Icon(
              Icons.notifications_outlined, // Ikon yang relevan
              color: Color(0xFF3B2C8D), // Warna yang sama
              size: 28, // Ukuran yang sama
            ),
          ],
        ),
        // =======================================================
        // AKHIR PERUBAHAN
        // =======================================================
      ),
      body: ListView.builder(
        itemCount: _notificationFeeds.length,
        itemBuilder: (context, index) {
          final feed = _notificationFeeds[index];
          final int id = feed['id'] as int;
          final bool isLiked = _likedFeeds[id] ?? false;
          final bool isSaved = _savedFeeds[id] ?? false;

          // Panggil widget FeedItem dari feed.dart
          return FeedItem(
            id: id,
            username: feed['username'] as String,
            imageUrl: feed['imageUrl'] as String,
            channel: feed['channel'] as String,
            subtitle: feed['subtitle'] as String,
            time: feed['time'] as String,
            content: feed['content'] as String,
            comments: feed['comments'] as int,
            likes: feed['likes'] as int,
            hasImage: feed['hasImage'] as bool,

            // Teruskan state
            isLiked: isLiked,
            isSaved: isSaved,

            // Teruskan fungsi buildAvatar global dari feed.dart
            avatarBuilder: buildAvatar,

            // Buat callback untuk mengubah state
            onLike: () {
              setState(() {
                _likedFeeds[id] = !isLiked;
              });
            },
            onSave: () {
              setState(() {
                _savedFeeds[id] = !isSaved;
              });
            },
          );
        },
      ),
    );
  }
}
