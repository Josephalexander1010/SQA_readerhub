// lib/subchannel_page.dart
import 'dart:io';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'feed.dart';
import 'models.dart';

// Definisi konstanta
const _kPurple = Color(0xFF3D2C8D);
const _kRed = Color(0xFFF23F42);
const _kBlack = Color(0xFF000000);

class SubChannelPage extends StatefulWidget {
  final String parentChannelName;
  final String subChannelName;
  final SubChannelPost? newPost;

  const SubChannelPage({
    super.key,
    required this.parentChannelName,
    required this.subChannelName,
    this.newPost,
  });

  @override
  State<SubChannelPage> createState() => _SubChannelPageState();
}

class _SubChannelPageState extends State<SubChannelPage> {
  final Map<int, bool> _likedFeeds = {};
  final Map<int, bool> _savedFeeds = {};

  late List<SubChannelPost> _allPosts;

  @override
  void initState() {
    super.initState();
    // Ambil data dari memori global
    _loadPosts();

    // Jika ada post baru dari navigasi, pastikan masuk list
    if (widget.newPost != null) {
      // Cek duplicate agar tidak double jika setState dipanggil
      if (!_allPosts.any((p) => p.id == widget.newPost!.id)) {
        _allPosts.insert(0, widget.newPost!);
      }
    }
  }

  void _loadPosts() {
    try {
      final channel =
          gAllChannels.firstWhere((c) => c.name == widget.parentChannelName);
      final sub = channel.subChannels
          .firstWhere((s) => s.name == widget.subChannelName);
      _allPosts = sub.posts; // Referensi ke list global
    } catch (e) {
      _allPosts = [];
    }
  }

  // --- FITUR HAPUS FEED ---
  void _deletePost(SubChannelPost post) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Delete Post"),
        content: const Text("Are you sure you want to delete this post?"),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx), child: const Text("Cancel")),
          TextButton(
            onPressed: () {
              setState(() {
                _allPosts.removeWhere((p) => p.id == post.id);
              });
              Navigator.pop(ctx);
            },
            child: const Text("Delete", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
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
              child: _allPosts.isEmpty
                  ? Center(
                      child: Padding(
                        padding: const EdgeInsets.all(32.0),
                        child: Text(
                          'Belum ada postingan di sub-channel ini.\nJadilah yang pertama memposting!',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.poppins(color: Colors.grey[600]),
                        ),
                      ),
                    )
                  : ListView.separated(
                      padding: const EdgeInsets.only(bottom: 16),
                      itemCount: _allPosts.length,
                      separatorBuilder: (_, __) => const Divider(height: 1),
                      itemBuilder: (context, index) =>
                          _buildPostCard(context, _allPosts[index]),
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
              widget.subChannelName,
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                color: _kPurple,
                fontSize: 22,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          const SizedBox(width: 48),
        ],
      ),
    );
  }

  String _formatLikes(int count) {
    if (count < 1000) return count.toString();
    return '${(count / 1000).toStringAsFixed(1)}K';
  }

  // Helper cek video
  bool _isVideo(String path) {
    final ext = path.toLowerCase();
    return ext.endsWith('.mp4') || ext.endsWith('.mov') || ext.endsWith('.avi');
  }

  Widget _buildPostCard(BuildContext context, SubChannelPost post) {
    final isLiked = _likedFeeds[post.id] ?? post.liked;
    final isSaved = _savedFeeds[post.id] ?? false;

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _networkAvatar(post.avatarUrl, radius: 22),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header & Tombol Delete
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Row(
                        children: [
                          Flexible(
                            child: Text(
                              post.authorName,
                              style: GoogleFonts.poppins(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700,
                                  color: _kBlack),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '· ${post.timeAgo}',
                            style: GoogleFonts.poppins(
                                fontSize: 12, color: Colors.grey[500]),
                          ),
                        ],
                      ),
                    ),
                    // TOMBOL HAPUS FEED
                    if (post.authorName ==
                        '@Anda') // Hanya bisa hapus post sendiri
                      GestureDetector(
                        onTap: () => _deletePost(post),
                        child: const Icon(Icons.more_horiz,
                            size: 20, color: Colors.grey),
                      ),
                  ],
                ),

                const SizedBox(height: 4),
                Text(
                  post.message,
                  style:
                      GoogleFonts.poppins(fontSize: 15, color: Colors.black87),
                ),

                // --- PERBAIKAN VIDEO CRASH ---
                if (post.hasImage && post.mediaPath != null) ...[
                  const SizedBox(height: 12),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: _buildMediaContent(post),
                  ),
                ],

                const SizedBox(height: 12),
                // Action Buttons
                Row(
                  children: [
                    if (post.commentsEnabled) ...[
                      GestureDetector(
                        onTap: () =>
                            showCommentsSheet(context, post.id, buildAvatar),
                        child: _iconStat(
                            icon: Icons.chat_bubble_outline,
                            label: '${post.comments}'),
                      ),
                      const SizedBox(width: 24),
                    ],
                    GestureDetector(
                      onTap: () =>
                          setState(() => _likedFeeds[post.id] = !isLiked),
                      child: _iconStat(
                          icon:
                              isLiked ? Icons.favorite : Icons.favorite_border,
                          label: _formatLikes(post.likes),
                          active: isLiked),
                    ),
                    const Spacer(),
                    if (post.savesEnabled) ...[
                      GestureDetector(
                        onTap: () =>
                            setState(() => _savedFeeds[post.id] = !isSaved),
                        child: Icon(
                            isSaved ? Icons.bookmark : Icons.bookmark_border,
                            color:
                                isSaved ? Colors.yellow[700] : Colors.grey[600],
                            size: 20),
                      ),
                      const SizedBox(width: 16),
                      GestureDetector(
                        onTap: () => showShareDialog(context, post.id),
                        child: Icon(Icons.share_outlined,
                            color: Colors.grey[600], size: 20),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // --- WIDGET BARU UNTUK MENANGANI VIDEO/GAMBAR ---
  Widget _buildMediaContent(SubChannelPost post) {
    // 1. Cek apakah ini Video
    if (_isVideo(post.mediaPath!)) {
      // Tampilkan Placeholder Video (Kotak Hitam + Play Icon)
      return Container(
        height: 200,
        width: double.infinity,
        color: Colors.black,
        child: const Center(
          child: Icon(Icons.play_circle_fill, color: Colors.white, size: 50),
        ),
      );
    }

    // 2. Jika Gambar Web
    if (post.isMediaNetwork) {
      return Image.network(
        post.mediaPath!,
        height: 200,
        width: double.infinity,
        fit: BoxFit.cover,
        errorBuilder: (c, e, s) => Container(height: 200, color: Colors.grey),
      );
    }

    // 3. Jika Gambar File Lokal (Mobile)
    return Image.file(
      File(post.mediaPath!),
      height: 200,
      width: double.infinity,
      fit: BoxFit.cover,
      errorBuilder: (c, e, s) => Container(height: 200, color: Colors.grey),
    );
  }

  Widget _iconStat(
      {required IconData icon, required String label, bool active = false}) {
    return Row(children: [
      Icon(icon, color: active ? _kRed : Colors.grey.shade600, size: 18),
      if (label.isNotEmpty) ...[
        const SizedBox(width: 4),
        Text(label,
            style: GoogleFonts.poppins(
                fontSize: 12, color: active ? _kRed : Colors.grey.shade600))
      ]
    ]);
  }

  Widget _networkAvatar(String imageUrl, {double radius = 24}) {
    // (Kode avatar sama seperti sebelumnya, disingkat biar muat)
    final bool isNetwork = imageUrl.startsWith('http');
    return CircleAvatar(
        radius: radius,
        backgroundColor: Colors.grey[300],
        child: ClipOval(
            child: isNetwork
                ? Image.network(imageUrl,
                    width: radius * 2, height: radius * 2, fit: BoxFit.cover)
                : Image.asset(imageUrl,
                    width: radius * 2, height: radius * 2, fit: BoxFit.cover)));
  }
}
