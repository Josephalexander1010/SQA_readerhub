import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'notificationpage.dart'; // <-- IMPORT HALAMAN BARU

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // Track like and save states for each feed item
  final Map<int, bool> _likedFeeds = {};
  final Map<int, bool> _savedFeeds = {};

  // Daftar URL Gambar untuk Feed
  final List<String> _feedImageUrls = [
    'https://randomuser.me/api/portraits/men/32.jpg', // John Doe
    'https://randomuser.me/api/portraits/women/44.jpg', // Jane Smith
    'https://randomuser.me/api/portraits/men/46.jpg', // Mike Johnson
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 10),
                    _buildHeader(), // Header sekarang di dalam
                    // PERUBAHAN: Jarak didekatkan (dari 20 ke 10)
                    const SizedBox(height: 10),
                    _buildMyChannelsSection(),
                    const SizedBox(height: 24),
                    _buildChannelFeedHeader(),
                    _buildFeedList(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      color: const Color(0xFFF8F9FA),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              const Text(
                'My Channels',
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF3B2C8D),
                  fontFamily: 'Poppins',
                ),
              ),
              const SizedBox(width: 6),
              Icon(Icons.hub, color: Color(0xFF3B2C8D), size: 28),
            ],
          ),
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const NotificationPage(),
                ),
              );
            },
            child: Icon(
              Icons.notifications_outlined,
              color: Colors.grey[700],
              size: 28,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMyChannelsSection() {
    return Container(
      color: const Color(0xFFF8F9FA),
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Column(
        children: [
          SizedBox(
            height: 90,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: [_buildLoadMoreCircle()],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadMoreCircle() {
    return Padding(
      padding: const EdgeInsets.only(right: 12),
      child: Column(
        children: [
          Container(
            width: 65,
            height: 65,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Color(0xFF3B2C8D),
            ),
            child: const Icon(Icons.more_horiz, color: Colors.white, size: 30),
          ),
          const SizedBox(height: 6),
          Text(
            'Load More...',
            style: TextStyle(
              fontSize: 11,
              color: Colors.grey[600],
              fontFamily: 'Poppins',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChannelFeedHeader() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0xFFF8F9FA),
        border: Border(
          bottom: BorderSide(color: Colors.grey[300]!, width: 1.0),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: const Text(
          'Your Channel Feed',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Color(0xFF3B2C8D),
            fontFamily: 'Poppins',
          ),
        ),
      ),
    );
  }

  Widget _buildFeedList() {
    return Column(
      children: [
        _buildFeedItem(
          id: 0,
          username: 'John Doe',
          imageUrl: _feedImageUrls[0],
          channel: 'Reading Club',
          subtitle: 'Read',
          time: '1m',
          content: 'What\'s happening?',
          comments: 95,
          likes: 1300,
        ),
        _buildFeedItem(
          id: 1,
          username: 'Jane Smith',
          imageUrl: _feedImageUrls[1],
          channel: 'Harry x Hermoi..',
          subtitle: 'Story of Greatn..',
          time: '1m',
          content: 'What\'s happening?',
          comments: 95,
          likes: 1300,
        ),
        _buildFeedItem(
          id: 2,
          username: 'Mike Johnson',
          imageUrl: _feedImageUrls[2],
          channel: 'Reading FC',
          subtitle: 'Story Of Greatn..',
          time: '1m',
          content: 'What\'s happening?',
          comments: 95,
          likes: 1300,
          hasImage: true,
        ),
      ],
    );
  }

  Widget _buildAvatar(String imageUrl, {double radius = 20}) {
    return CircleAvatar(
      radius: radius,
      backgroundColor: Colors.grey[300], // Warna fallback
      child: ClipOval(
        child: Image.network(
          imageUrl,
          fit: BoxFit.cover,
          width: radius * 2,
          height: radius * 2,
          // Ini akan menampilkan icon 'person' jika gambar gagal di-load
          errorBuilder: (context, error, stackTrace) {
            return Icon(
              Icons.person,
              color: Colors.grey[600],
              size: radius * 1.2,
            );
          },
          // Ini menampilkan loading indicator saat gambar sedang diambil
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) return child; // Gambar selesai
            return Center(
              child: CircularProgressIndicator(
                strokeWidth: 2,
                value: loadingProgress.expectedTotalBytes != null
                    ? loadingProgress.cumulativeBytesLoaded /
                          loadingProgress.expectedTotalBytes!
                    : null,
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildFeedItem({
    required int id,
    required String username,
    required String imageUrl,
    required String channel,
    required String subtitle,
    required String time,
    required String content,
    required int comments,
    required int likes,
    bool hasImage = false,
  }) {
    final isLiked = _likedFeeds[id] ?? false;
    final isSaved = _savedFeeds[id] ?? false;

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
              _buildAvatar(imageUrl, radius: 20),
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
              Icon(Icons.more_horiz, color: Colors.grey[600], size: 20),
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
            Container(
              width: double.infinity,
              height: 220,
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: Icon(
                  Icons.image_outlined,
                  color: Colors.white.withOpacity(0.3),
                  size: 60,
                ),
              ),
            ),
          ],
          const SizedBox(height: 12),
          Row(
            children: [
              GestureDetector(
                onTap: () => _showCommentsSheet(context, id),
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
                onTap: () {
                  setState(() {
                    _likedFeeds[id] = !isLiked;
                  });
                },
                child: Row(
                  children: [
                    Icon(
                      isLiked ? Icons.favorite : Icons.favorite_border,
                      color: isLiked ? Colors.red : Colors.grey[600],
                      size: 20,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      '${(likes / 1000).toStringAsFixed(1)}k',
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
                onTap: () => _showShareDialog(context, id),
                child: Icon(Icons.ios_share, color: Colors.grey[600], size: 20),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showCommentsSheet(BuildContext context, int feedId) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => CommentsSheet(
        feedId: feedId,
        buildAvatar: _buildAvatar, // Meneruskan fungsi buildAvatar
      ),
    );
  }

  void _showShareDialog(BuildContext context, int feedId) {
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
              const Text(
                'Share Post',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Poppins',
                ),
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: SelectableText(
                  link,
                  style: const TextStyle(fontSize: 14, fontFamily: 'Poppins'),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text(
                      'Cancel',
                      style: TextStyle(fontFamily: 'Poppins'),
                    ),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: () {
                      Clipboard.setData(ClipboardData(text: link));
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Link copied!')),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF3B2C8D),
                    ),
                    child: const Text(
                      'Copy Link',
                      style: TextStyle(fontFamily: 'Poppins'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// =====================================================================
// CommentsSheet Class
// =====================================================================

class CommentsSheet extends StatefulWidget {
  final int feedId;
  final Widget Function(String, {double radius}) buildAvatar;

  const CommentsSheet({
    super.key,
    required this.feedId,
    required this.buildAvatar,
  });

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
      replies: [],
    ),
    Comment(
      id: 2,
      username: 'Mike Brown',
      imageUrl: 'https://randomuser.me/api/portraits/men/18.jpg',
      time: '12 jam',
      content: '🔥🔥🔥🔥',
      likes: 1,
      replies: [],
    ),
    Comment(
      id: 3,
      username: 'Emma Davis',
      imageUrl: 'https://randomuser.me/api/portraits/women/50.jpg',
      time: '22 jam',
      content: '🔥🔥🔥🔥🔥',
      likes: 1,
      replies: [],
    ),
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
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          // Handle bar
          Container(
            margin: const EdgeInsets.only(top: 12, bottom: 8),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const Text(
            'Komentar',
            style: TextStyle(
              color: Colors.black87,
              fontSize: 16,
              fontWeight: FontWeight.w600,
              fontFamily: 'Poppins',
            ),
          ),
          Divider(color: Colors.grey[300]),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: _comments.length,
              itemBuilder: (context, index) {
                return _buildCommentItem(_comments[index]);
              },
            ),
          ),
          _buildCommentInput(),
        ],
      ),
    );
  }

  Widget _buildCommentItem(Comment comment) {
    final isLiked = _likedComments[comment.id] ?? false;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              widget.buildAvatar(comment.imageUrl, radius: 18),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          comment.username,
                          style: const TextStyle(
                            color: Colors.black87,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                            fontFamily: 'Poppins',
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          comment.time,
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 13,
                            fontFamily: 'Poppins',
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      comment.content,
                      style: const TextStyle(
                        color: Colors.black87,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              _replyingToId = comment.id;
                              _commentController.text = '@${comment.username} ';
                            });
                          },
                          child: Text(
                            'Balas',
                            style: TextStyle(
                              color: Colors.grey[700],
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              fontFamily: 'Poppins',
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Column(
                children: [
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _likedComments[comment.id] = !isLiked;
                      });
                    },
                    child: Icon(
                      isLiked ? Icons.favorite : Icons.favorite_border,
                      color: isLiked ? Colors.red : Colors.grey[600],
                      size: 18,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    comment.likes.toString(),
                    style: TextStyle(color: Colors.grey[600], fontSize: 12),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCommentInput() {
    return Container(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Colors.grey[300]!)),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            widget.buildAvatar(currentUserImageUrl, radius: 16),
            const SizedBox(width: 12),
            Expanded(
              child: TextField(
                controller: _commentController,
                style: const TextStyle(
                  color: Colors.black87,
                  fontFamily: 'Poppins',
                ),
                decoration: InputDecoration(
                  hintText: 'Bergabung dengan percakapan...',
                  hintStyle: TextStyle(
                    color: Colors.grey[600],
                    fontFamily: 'Poppins',
                  ),
                  border: InputBorder.none,
                ),
              ),
            ),
            IconButton(
              onPressed: () {
                if (_commentController.text.isNotEmpty) {
                  // Add comment logic here
                  _commentController.clear();
                  setState(() {
                    _replyingToId = null;
                  });
                }
              },
              icon: const Icon(Icons.send, color: Color(0xFF3B2C8D)),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }
}

// =====================================================================
// Comment Model
// =====================================================================

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
