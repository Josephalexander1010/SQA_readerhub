// lib/specific_channel_page.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'feed.dart';
import 'models.dart'; // <-- Impor model BARU

// Definisi konstanta
const _kPurple = Color(0xFF3D2C8D);
const _kRed = Color(0xFFF23F42);
const _kBlack = Color(0xFF000000);

// --- PERBAIKAN DI SINI ---
// Hapus class SubChannelInfo dari sini
// Hapus juga class SubChannelPost dari sini
// -------------------------

// Halaman Feed Sub-Channel
class SpecificChannelPage extends StatefulWidget {
  // Ubah nama parameter agar lebih jelas
  final String title;
  final String description;
  final String avatarUrl;
  final List<SubChannelInfo>
      initialSubChannels; // <-- Gunakan model dari models.dart

  const SpecificChannelPage({
    super.key,
    required this.title,
    required this.description,
    required this.avatarUrl,
    required this.initialSubChannels,
  });

  @override
  State<SpecificChannelPage> createState() => _SpecificChannelPageState();
}

class _SpecificChannelPageState extends State<SpecificChannelPage> {
  // State untuk Like dan Save
  final Map<int, bool> _likedFeeds = {};
  final Map<int, bool> _savedFeeds = {};

  // Ambil data demo dari file feed.dart
  // (Anda mungkin ingin mengganti ini dengan data yang lebih relevan nanti)
  final List<Map<String, dynamic>> _demoPosts = [
    {
      'id': 10,
      'authorName': '@Name',
      'avatarUrl': 'https://randomuser.me/api/portraits/men/32.jpg',
      'channel': 'Reading Club',
      'subChannel': 'Subchannel',
      'timeAgo': '1m',
      'message': 'What\'s happening?',
      'comments': 95,
      'likes': 1300,
      'liked': false,
      'hasImage': false,
    },
    {
      'id': 11,
      'authorName': '@Name',
      'avatarUrl': 'https://randomuser.me/api/portraits/men/46.jpg',
      'channel': 'Harry Potter',
      'subChannel': 'Harry x Hermoine',
      'timeAgo': '1m',
      'message': 'What\'s happening?',
      'comments': 95,
      'likes': 1300,
      'liked': true,
      'hasImage': false,
    },
    {
      'id': 12,
      'authorName': '@Name',
      'avatarUrl': 'https://randomuser.me/api/portraits/women/44.jpg',
      'channel': 'Reading FC',
      'subChannel': 'Story Of Greatness',
      'timeAgo': '1m',
      'message': 'What\'s happening?',
      'comments': 95,
      'likes': 1300,
      'liked': false,
      'hasImage': true,
    },
  ];

  String _formatLikes(int count) {
    if (count < 1000) {
      return count.toString();
    } else {
      double likesInK = count / 1000;
      return '${likesInK.toStringAsFixed(1)}K';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(context),
            const Divider(height: 1),
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.only(bottom: 16),
                itemCount: _demoPosts.length,
                separatorBuilder: (_, __) => const Divider(height: 1),
                itemBuilder: (context, index) =>
                    _buildPostCard(context, _demoPosts[index]),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 8, 12, 8),
      child: Row(
        children: [
          IconButton(
            onPressed: () => Navigator.of(context).pop(),
            icon: const Icon(Icons.arrow_back, color: _kBlack),
          ),
          Expanded(
            child: Text(
              widget.title, // Gunakan title dari widget
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                color: _kPurple,
                fontSize: 22,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          const SizedBox(width: 48), // Placeholder
        ],
      ),
    );
  }

  // Widget untuk menampilkan postingan
  Widget _buildPostCard(BuildContext context, Map<String, dynamic> post) {
    final int id = post['id'];
    final bool isLiked = _likedFeeds[id] ?? (post['liked'] as bool? ?? false);
    final bool isSaved = _savedFeeds[id] ?? false;

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _networkAvatar(post['avatarUrl'], radius: 22),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      post['authorName'],
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: _kBlack,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        '${post['channel']} → ${post['subChannel']}',
                        style: GoogleFonts.poppins(
                          fontSize: 13,
                          color: Colors.grey[600],
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '· ${post['timeAgo']}',
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        color: Colors.grey[500],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  post['message'],
                  style: GoogleFonts.poppins(
                    fontSize: 15,
                    color: Colors.black87,
                  ),
                ),
                if (post['hasImage'] as bool? ?? false) ...[
                  const SizedBox(height: 12),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      height: 200,
                      width: double.infinity,
                      color: Colors.black,
                      child: Center(
                        child: Icon(
                          Icons.image_outlined,
                          color: Colors.white.withAlpha((255 * 0.3).round()),
                          size: 48,
                        ),
                      ),
                    ),
                  ),
                ],
                const SizedBox(height: 12),
                Row(
                  children: [
                    GestureDetector(
                      onTap: () => showCommentsSheet(
                        context,
                        id,
                        buildAvatar, // Menggunakan buildAvatar dari feed.dart
                      ),
                      child: _iconStat(
                        icon: Icons.chat_bubble_outline,
                        label: '${post['comments']}',
                      ),
                    ),
                    const SizedBox(width: 24),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          _likedFeeds[id] = !isLiked;
                        });
                      },
                      child: _iconStat(
                        icon: isLiked ? Icons.favorite : Icons.favorite_border,
                        label: _formatLikes(post['likes']),
                        active: isLiked,
                      ),
                    ),
                    const Spacer(),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          _savedFeeds[id] = !isSaved;
                        });
                      },
                      child: Icon(
                        isSaved ? Icons.bookmark : Icons.bookmark_border,
                        color: isSaved ? Colors.yellow[700] : Colors.grey[600],
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 16),
                    GestureDetector(
                      onTap: () => showShareDialog(context, id),
                      child: Icon(
                        Icons.share_outlined,
                        color: Colors.grey[600],
                        size: 20,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Icon(
            Icons.no_photography_outlined,
            size: 20,
            color: const Color(0xFF526470),
          ),
        ],
      ),
    );
  }

  Widget _iconStat({
    required IconData icon,
    required String label,
    bool active = false,
  }) {
    return Row(
      children: [
        Icon(
          icon,
          color: active ? _kRed : Colors.grey.shade600,
          size: 18,
        ),
        if (label.isNotEmpty) ...[
          const SizedBox(width: 4),
          Text(
            label,
            style: GoogleFonts.poppins(
              fontSize: 12,
              color: active ? _kRed : Colors.grey.shade600,
            ),
          ),
        ],
      ],
    );
  }

  Widget _networkAvatar(String imageUrl, {double radius = 24}) {
    // ... (Kode _networkAvatar SAMA) ...
    final bool isNetwork =
        imageUrl.startsWith('http://') || imageUrl.startsWith('https://');

    return CircleAvatar(
      radius: radius,
      backgroundColor: Colors.grey[300],
      child: ClipOval(
        child: isNetwork
            ? Image.network(
                imageUrl,
                width: radius * 2,
                height: radius * 2,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Icon(
                  Icons.person,
                  color: Colors.grey[600],
                  size: radius,
                ),
                loadingBuilder: (context, child, progress) {
                  if (progress == null) return child;
                  return Center(
                    child: SizedBox(
                      width: radius,
                      height: radius,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        value: progress.expectedTotalBytes != null
                            ? progress.cumulativeBytesLoaded /
                                progress.expectedTotalBytes!
                            : null,
                      ),
                    ),
                  );
                },
              )
            : Image.asset(
                imageUrl,
                width: radius * 2,
                height: radius * 2,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Icon(
                  Icons.person,
                  color: Colors.grey[600],
                  size: radius,
                ),
              ),
      ),
    );
  }
}
