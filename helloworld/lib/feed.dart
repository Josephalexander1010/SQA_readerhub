// lib/feed.dart
import 'dart:io'; // <-- PENTING: Tambahkan ini untuk membaca File
import 'package:flutter/foundation.dart'
    show kIsWeb; // <-- PENTING: Untuk cek web
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// ... (Class Comment dan Class FeedItem SAMA PERSIS, tidak perlu diubah) ...
class Comment {
  final int id;
  final String username;
  final String imageUrl;
  final String time;
  final String content;
  final int likes;
  final List<Comment> replies;

  Comment({
    required this.id,
    required this.username,
    required this.imageUrl,
    required this.time,
    required this.content,
    required this.likes,
    required this.replies,
  });
}

class FeedItem extends StatelessWidget {
  final int id;
  final String username;
  final String imageUrl;
  final String channel;
  final String subtitle;
  final String time;
  final String content;
  final int comments;
  final int likes;
  final bool hasImage;
  final bool isLiked;
  final bool isSaved;
  final VoidCallback onLike;
  final VoidCallback onSave;
  final Widget Function(String, {double radius}) avatarBuilder;
  final Widget Function()? mediaBuilder;

  const FeedItem({
    super.key,
    required this.id,
    required this.username,
    required this.imageUrl,
    required this.channel,
    required this.subtitle,
    required this.time,
    required this.content,
    required this.comments,
    required this.likes,
    this.hasImage = false,
    required this.isLiked,
    required this.isSaved,
    required this.onLike,
    required this.onSave,
    required this.avatarBuilder,
    this.mediaBuilder,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF8F9FA),
        border: Border(
          bottom: BorderSide(color: Colors.grey[300]!, width: 1.0),
        ),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              avatarBuilder(imageUrl, radius: 20),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          username,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                            color: Colors.black,
                            fontFamily: 'Poppins',
                          ),
                        ),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            '$channel → $subtitle',
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.grey[600],
                              fontFamily: 'Poppins',
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '· $time',
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.grey[500],
                            fontFamily: 'Poppins',
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
                color: const Color(0xFF526470),
                size: 20,
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            content,
            style: const TextStyle(
              fontSize: 15,
              color: Colors.black87,
              fontFamily: 'Poppins',
            ),
          ),
          if (hasImage) ...[
            const SizedBox(height: 12),
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: mediaBuilder != null
                  ? mediaBuilder!()
                  : Container(
                      width: double.infinity,
                      height: 220,
                      color: Colors.black,
                      child: const Center(
                        child: Icon(
                          Icons.image_outlined,
                          color: Colors.white54,
                          size: 60,
                        ),
                      ),
                    ),
            ),
          ],
          const SizedBox(height: 12),
          Row(
            children: [
              GestureDetector(
                onTap: () => showCommentsSheet(context, id, avatarBuilder),
                child: Row(
                  children: [
                    Icon(
                      Icons.chat_bubble_outline,
                      color: Colors.grey[600],
                      size: 20,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      comments.toString(),
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey[600],
                        fontFamily: 'Poppins',
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 24),
              GestureDetector(
                onTap: onLike,
                child: Row(
                  children: [
                    Icon(
                      isLiked ? Icons.favorite : Icons.favorite_border,
                      color: isLiked ? Colors.red : Colors.grey[600],
                      size: 20,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      likes < 1000
                          ? likes.toString()
                          : '${(likes / 1000).toStringAsFixed(1)}K',
                      style: TextStyle(
                        fontSize: 13,
                        color: isLiked ? Colors.red : Colors.grey[600],
                        fontFamily: 'Poppins',
                      ),
                    ),
                  ],
                ),
              ),
              const Spacer(),
              GestureDetector(
                onTap: onSave,
                child: Icon(
                  isSaved ? Icons.bookmark : Icons.bookmark_border,
                  color: isSaved ? Colors.yellow[700] : Colors.grey[600],
                  size: 20,
                ),
              ),
              const SizedBox(width: 16),
              GestureDetector(
                onTap: () => showShareDialog(context, id),
                child: Icon(Icons.ios_share, color: Colors.grey[600], size: 20),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ... (Fungsi Helper showCommentsSheet, showShareDialog, CommentsSheet SAMA PERSIS) ...
// ... (Salin bagian komentar dan dialog dari kode sebelumnya di sini) ...

void showCommentsSheet(BuildContext context, int feedId,
    Widget Function(String, {double radius}) avatarBuilder) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) => CommentsSheet(
      feedId: feedId,
      buildAvatar: avatarBuilder,
    ),
  );
}

void showShareDialog(BuildContext context, int feedId) {
  final link =
      'https://www.readerhub.com/p/DQhHINKCX0F/?igsh=MXJrcnRkYXU2bHQyOA==';
  showDialog(
    context: context,
    builder: (context) => Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Share Post',
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Poppins')),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(8)),
              child: SelectableText(link,
                  style: const TextStyle(fontSize: 14, fontFamily: 'Poppins')),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Cancel',
                        style: TextStyle(fontFamily: 'Poppins'))),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () {
                    Clipboard.setData(ClipboardData(text: link));
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Link copied!')));
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF3B2C8D)),
                  child: const Text('Copy Link',
                      style: TextStyle(fontFamily: 'Poppins')),
                ),
              ],
            ),
          ],
        ),
      ),
    ),
  );
}

class CommentsSheet extends StatefulWidget {
  final int feedId;
  final Widget Function(String, {double radius}) buildAvatar;
  const CommentsSheet(
      {super.key, required this.feedId, required this.buildAvatar});
  @override
  State<CommentsSheet> createState() => _CommentsSheetState();
}

class _CommentsSheetState extends State<CommentsSheet> {
  final TextEditingController _commentController = TextEditingController();
  final List<Comment> _comments = [
    Comment(
        id: 1,
        username: 'Sarah Wilson',
        imageUrl: 'https://randomuser.me/api/portraits/women/31.jpg',
        time: '22 jam',
        content: 'Vote ulang ga lu 👍😊',
        likes: 436,
        replies: [])
  ];
  final Map<int, bool> _likedComments = {};
  int? _replyingToId;
  final String currentUserImageUrl =
      'https://randomuser.me/api/portraits/women/9.jpg';

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.85,
      decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      child: Column(children: [
        Container(
            margin: const EdgeInsets.only(top: 12, bottom: 8),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2))),
        const Text('Komentar',
            style: TextStyle(
                color: Colors.black87,
                fontSize: 16,
                fontWeight: FontWeight.w600,
                fontFamily: 'Poppins')),
        Divider(color: Colors.grey[300]),
        Expanded(
            child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: _comments.length,
                itemBuilder: (context, index) =>
                    _buildCommentItem(_comments[index]))),
        _buildCommentInput(),
      ]),
    );
  }

  Widget _buildCommentItem(Comment comment) {
    /* ... kode item komentar sama ... */ return Container();
  } // (Disingkat agar muat, gunakan kode lama)

  Widget _buildCommentInput() {
    return Container();
  } // (Disingkat agar muat, gunakan kode lama)

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }
}

// --- PERBAIKAN UTAMA ADA DI SINI ---
Widget buildAvatar(String imageUrl, {double radius = 20}) {
  // 1. Jika URL kosong atau null
  if (imageUrl.isEmpty) {
    return CircleAvatar(
      radius: radius,
      backgroundColor: Colors.grey[300],
      child: Icon(Icons.person, color: Colors.grey[600], size: radius * 1.2),
    );
  }

  // 2. Tentukan jenis gambar: Network, Asset, atau File
  ImageProvider imageProvider;

  if (imageUrl.startsWith('http')) {
    // Gambar dari Internet
    imageProvider = NetworkImage(imageUrl);
  } else if (imageUrl.startsWith('assets/')) {
    // Gambar dari Assets
    imageProvider = AssetImage(imageUrl);
  } else {
    // Gambar dari File Lokal (paling penting untuk fitur Create Channel)
    if (kIsWeb) {
      imageProvider = NetworkImage(imageUrl); // Web pakai blob url
    } else {
      imageProvider = FileImage(File(imageUrl)); // Mobile pakai File
    }
  }

  return CircleAvatar(
    radius: radius,
    backgroundColor: Colors.grey[300],
    backgroundImage: imageProvider,
    // Handler error jika gambar gagal dimuat
    onBackgroundImageError: (_, __) {
      // Fallback jika error (tidak perlu melakukan apa-apa,
      // backgroundImage akan kosong dan background color akan muncul)
    },
    child: null, // Kita pakai backgroundImage, jadi child null
  );
}
