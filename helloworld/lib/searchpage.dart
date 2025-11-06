// lib/searchpage.dart (Perbaikan textSkip, _buildHeader, & _buildPopupCard)
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:carousel_slider_plus/carousel_slider_plus.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';
import 'search_results_page.dart';
import 'notificationpage.dart';

// ... (Seluruh kode duplikat CommentsSheet dan Comment TETAP SAMA) ...
// ... (Salin sisa kode Anda dari file asli) ...
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
        replies: []),
    Comment(
        id: 2,
        username: 'Mike Brown',
        imageUrl: 'https://randomuser.me/api/portraits/men/18.jpg',
        time: '12 jam',
        content: '🔥🔥🔥🔥',
        likes: 1,
        replies: []),
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
                  itemBuilder: (context, index) {
                    return _buildCommentItem(_comments[index]);
                  })),
          _buildCommentInput()
        ]));
  }

  Widget _buildCommentItem(Comment comment) {
    final isLiked = _likedComments[comment.id] ?? false;
    return Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
            widget.buildAvatar(comment.imageUrl, radius: 18),
            const SizedBox(width: 12),
            Expanded(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                  Row(children: [
                    Text(comment.username,
                        style: const TextStyle(
                            color: Colors.black87,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                            fontFamily: 'Poppins')),
                    const SizedBox(width: 8),
                    Text(comment.time,
                        style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 13,
                            fontFamily: 'Poppins'))
                  ]),
                  const SizedBox(height: 4),
                  Text(comment.content,
                      style:
                          const TextStyle(color: Colors.black87, fontSize: 14)),
                  const SizedBox(height: 8),
                  Row(children: [
                    GestureDetector(
                        onTap: () {
                          setState(() {
                            _replyingToId = comment.id;
                            _commentController.text = '@${comment.username} ';
                          });
                        },
                        child: Text('Balas',
                            style: TextStyle(
                                color: Colors.grey[700],
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                fontFamily: 'Poppins')))
                  ])
                ])),
            Column(children: [
              GestureDetector(
                  onTap: () {
                    setState(() {
                      _likedComments[comment.id] = !isLiked;
                    });
                  },
                  child: Icon(isLiked ? Icons.favorite : Icons.favorite_border,
                      color: isLiked ? Colors.red : Colors.grey[600],
                      size: 18)),
              const SizedBox(height: 4),
              Text(comment.likes.toString(),
                  style: TextStyle(color: Colors.grey[600], fontSize: 12))
            ])
          ])
        ]));
  }

  Widget _buildCommentInput() {
    return Container(
        padding:
            EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        decoration: BoxDecoration(
            color: Colors.white,
            border: Border(top: BorderSide(color: Colors.grey[300]!))),
        child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(children: [
              widget.buildAvatar(currentUserImageUrl, radius: 16),
              const SizedBox(width: 12),
              Expanded(
                  child: TextField(
                      controller: _commentController,
                      style: const TextStyle(
                          color: Colors.black87, fontFamily: 'Poppins'),
                      decoration: InputDecoration(
                          hintText: 'Bergabung dengan percakapan...',
                          hintStyle: TextStyle(
                              color: Colors.grey[600], fontFamily: 'Poppins'),
                          border: InputBorder.none))),
              IconButton(
                  onPressed: () {
                    if (_commentController.text.isNotEmpty) {
                      _commentController.clear();
                      setState(() {
                        _replyingToId = null;
                      });
                    }
                  },
                  icon: const Icon(Icons.send, color: Color(0xFF3B2C8D)))
            ])));
  }

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }
}

class Comment {
  final int id;
  final String username;
  final String imageUrl;
  final String time;
  final String content;
  final int likes;
  final List<Comment> replies;
  Comment(
      {required this.id,
      required this.username,
      required this.imageUrl,
      required this.time,
      required this.content,
      required this.likes,
      required this.replies});
}
// Akhir duplikat kelas

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  int _carouselIndex = 0;
  final CarouselSliderController _carouselController =
      CarouselSliderController();

  final GlobalKey _searchBarKey = GlobalKey();
  late TutorialCoachMark _tutorialCoachMark;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkAndShowWalkthroughStep5();
    });
  }

  void _checkAndShowWalkthroughStep5() async {
    final prefs = await SharedPreferences.getInstance();
    bool needsStep5 = prefs.getBool('walkthrough_step_5_pending') ?? false;

    if (needsStep5 && mounted) {
      _tutorialCoachMark = TutorialCoachMark(
        targets: [_createSearchTarget()],
        colorShadow: Colors.black.withAlpha((255 * 0.7).round()),
        // =======================================================
        // PERBAIKAN DI SINI: Menghapus tombol "DONE" di pojok
        textSkip: "",
        // =======================================================
        onFinish: () {
          _markWalkthroughAsDone();
        },
        onSkip: () {
          _markWalkthroughAsDone();
          return true;
        },
      );
      _tutorialCoachMark.show(context: context);
    }
  }

  TargetFocus _createSearchTarget() {
    return TargetFocus(
      identify: "search-bar-key",
      keyTarget: _searchBarKey,
      shape: ShapeLightFocus.RRect,
      radius: 30,
      contents: [
        TargetContent(
          align: ContentAlign.bottom,
          builder: (context, controller) {
            return _buildPopupCard(
              step: "Step 5/5",
              title: "You're All Set To Explore",
              content:
                  "To get started, use the Search feature to find your first Channel and join the conversation. Enjoy!",
              onContinue: () => controller.next(),
              onSkip: null,
              continueText: "Done",
            );
          },
        ),
      ],
    );
  }

  void _markWalkthroughAsDone() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('walkthrough_completed', true);
    await prefs.setBool('walkthrough_step_5_pending', false);
  }

  // ... (Sisa kode _buildFeedList, _buildFeedItem, dll. TETAP SAMA) ...
  // ... (Salin sisa kode Anda dari file asli) ...
  final Map<int, bool> _likedFeeds = {};
  final Map<int, bool> _savedFeeds = {};
  final List<String> _feedImageUrls = [
    'https://randomuser.me/api/portraits/men/32.jpg', // John Doe
    'https://randomuser.me/api/portraits/women/44.jpg', // Jane Smith
    'https://randomuser.me/api/portraits/men/46.jpg', // Mike Johnson
  ];

  Widget _buildAvatar(String imageUrl, {double radius = 20}) {
    return CircleAvatar(
        radius: radius,
        backgroundColor: Colors.grey[300],
        child: ClipOval(
            child: Image.network(imageUrl,
                fit: BoxFit.cover,
                width: radius * 2,
                height: radius * 2, errorBuilder: (context, error, stackTrace) {
          return Icon(Icons.person,
              color: Colors.grey[600], size: radius * 1.2);
        }, loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return Center(
              child: CircularProgressIndicator(
                  strokeWidth: 2,
                  value: loadingProgress.expectedTotalBytes != null
                      ? loadingProgress.cumulativeBytesLoaded /
                          loadingProgress.expectedTotalBytes!
                      : null));
        })));
  }

  void _showCommentsSheet(BuildContext context, int feedId) {
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (context) =>
            CommentsSheet(feedId: feedId, buildAvatar: _buildAvatar));
  }

  void _showShareDialog(BuildContext context, int feedId) {
    final link =
        'https://www.readerhub.com/p/DQhHINKCX0F/?igsh=MXJrcnRkYXU2bHQyOA==';
    showDialog(
        context: context,
        builder: (context) => Dialog(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(mainAxisSize: MainAxisSize.min, children: [
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
                          style: const TextStyle(
                              fontSize: 14, fontFamily: 'Poppins'))),
                  const SizedBox(height: 16),
                  Row(mainAxisAlignment: MainAxisAlignment.end, children: [
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
                            style: TextStyle(fontFamily: 'Poppins')))
                  ])
                ]))));
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
                bottom: BorderSide(color: Colors.grey[300]!, width: 1.0))),
        padding: const EdgeInsets.all(16),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [
            _buildAvatar(imageUrl, radius: 20),
            const SizedBox(width: 10),
            Expanded(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                  Row(children: [
                    Text(username,
                        style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                            color: Colors.black,
                            fontFamily: 'Poppins')),
                    const SizedBox(width: 4),
                    Expanded(
                        child: Text('$channel → $subtitle',
                            style: TextStyle(
                                fontSize: 13,
                                color: Colors.grey[600],
                                fontFamily: 'Poppins'),
                            overflow: TextOverflow.ellipsis)),
                    const SizedBox(width: 4),
                    Text('· $time',
                        style: TextStyle(
                            fontSize: 13,
                            color: Colors.grey[500],
                            fontFamily: 'Poppins'))
                  ])
                ])),
            const SizedBox(width: 8),
            Icon(Icons.more_horiz, color: Colors.grey[600], size: 20)
          ]),
          const SizedBox(height: 10),
          Text(content,
              style: const TextStyle(
                  fontSize: 15, color: Colors.black87, fontFamily: 'Poppins')),
          if (hasImage) ...[
            const SizedBox(height: 12),
            Container(
                width: double.infinity,
                height: 220,
                decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(12)),
                child: Center(
                    child: Icon(Icons.image_outlined,
                        color: Colors.white.withAlpha((255 * 0.3).round()),
                        size: 60)))
          ],
          const SizedBox(height: 12),
          Row(children: [
            GestureDetector(
                onTap: () => _showCommentsSheet(context, id),
                child: Row(children: [
                  Icon(Icons.chat_bubble_outline,
                      color: Colors.grey[600], size: 20),
                  const SizedBox(width: 6),
                  Text(comments.toString(),
                      style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey[600],
                          fontFamily: 'Poppins'))
                ])),
            const SizedBox(width: 24),
            GestureDetector(
                onTap: () {
                  setState(() {
                    _likedFeeds[id] = !isLiked;
                  });
                },
                child: Row(children: [
                  Icon(isLiked ? Icons.favorite : Icons.favorite_border,
                      color: isLiked ? Colors.red : Colors.grey[600], size: 20),
                  const SizedBox(width: 6),
                  Text('${(likes / 1000).toStringAsFixed(1)}k',
                      style: TextStyle(
                          fontSize: 13,
                          color: isLiked ? Colors.red : Colors.grey[600],
                          fontFamily: 'Poppins'))
                ])),
            const Spacer(),
            GestureDetector(
                onTap: () {
                  setState(() {
                    _savedFeeds[id] = !isSaved;
                  });
                },
                child: Icon(isSaved ? Icons.bookmark : Icons.bookmark_border,
                    color: isSaved ? Colors.yellow[700] : Colors.grey[600],
                    size: 20)),
            const SizedBox(width: 16),
            GestureDetector(
                onTap: () => _showShareDialog(context, id),
                child: Icon(Icons.ios_share, color: Colors.grey[600], size: 20))
          ])
        ]));
  }

  Widget _buildFeedList() {
    return Column(children: [
      _buildFeedItem(
          id: 0,
          username: 'John Doe',
          imageUrl: _feedImageUrls[0],
          channel: 'Reading Club',
          subtitle: 'Read',
          time: '1m',
          content: 'What\'s happening?',
          comments: 95,
          likes: 1300),
      _buildFeedItem(
          id: 1,
          username: 'Jane Smith',
          imageUrl: _feedImageUrls[1],
          channel: 'Harry x Hermoi..',
          subtitle: 'Story of Greatn..',
          time: '1m',
          content: 'What\'s happening?',
          comments: 95,
          likes: 1300),
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
          hasImage: true)
    ]);
  }

  Widget _buildChannelFeedHeader() {
    return Container(
        width: double.infinity,
        decoration: BoxDecoration(
            color: const Color(0xFFF8F9FA),
            border: Border(
                bottom: BorderSide(color: Colors.grey[300]!, width: 1.0))),
        child: const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Text('Your Channel Feed',
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF3B2C8D),
                    fontFamily: 'Poppins'))));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(), // <-- PANGGIL FUNGSI HEADER BARU
              Container(
                key: _searchBarKey,
                child: _buildSearchBar(),
              ),
              const SizedBox(height: 20),
              _buildCarousel(),
              const SizedBox(height: 24),
              _buildChannelFeedHeader(),
              _buildFeedList(),
            ],
          ),
        ),
      ),
    );
  }

  // =======================================================
  // PERBAIKAN DI SINI: Memastikan style font sama persis
  // =======================================================
  Widget _buildHeader() {
    return Container(
      color: const Color(0xFFF8F9FA),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            // Tambahkan Row di sini agar ikon bisa ditambahkan
            children: [
              const Text(
                'Search Page', // Teks diubah
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF3B2C8D),
                  fontFamily: 'Poppins',
                ),
              ),
              const SizedBox(width: 6), // Beri jarak
              Icon(Icons.search, color: Color(0xFF3B2C8D), size: 28), // Ikon
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

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const SearchResultsPage()),
          );
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(30),
            border: Border.all(color: Colors.grey[300]!),
          ),
          child: Row(
            children: [
              Icon(Icons.search, color: Colors.grey[600]),
              const SizedBox(width: 10),
              Text(
                'Search',
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 16,
                  fontFamily: 'Poppins',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCarousel() {
    final List<Widget> carouselItems = [
      _buildCarouselItem(
        'https://images.unsplash.com/photo-1542751371-adc38448a05e?q=80&w=2070&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%DD%3D',
        'https://randomuser.me/api/portraits/men/1.jpg',
        'https://randomuser.me/api/portraits/men/2.jpg',
        '@Budi Reading Club → SubChannel',
        'Two players on a game duel',
      ),
      _buildCarouselItem(
        'https://images.unsplash.com/photo-1511882150382-421056c89033?q=80&w=2071&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%D%D',
        'https://randomuser.me/api/portraits/women/3.jpg',
        'https://randomuser.me/api/portraits/men/4.jpg',
        '@BookWorms → General',
        'Weekly Reading Discussion',
      ),
    ];

    return Column(
      children: [
        CarouselSlider(
          items: carouselItems,
          controller: _carouselController,
          options: CarouselOptions(
            height: 200,
            autoPlay: true,
            enlargeCenterPage: true,
            aspectRatio: 16 / 9,
            viewportFraction: 0.85,
            onPageChanged: (index, reason) {
              setState(() {
                _carouselIndex = index;
              });
            },
          ),
        ),
        const SizedBox(height: 12),
        AnimatedSmoothIndicator(
          activeIndex: _carouselIndex,
          count: carouselItems.length,
          effect: const WormEffect(
            dotHeight: 8,
            dotWidth: 8,
            activeDotColor: Color(0xFF3B2C8D),
            dotColor: Colors.grey,
          ),
        ),
      ],
    );
  }

  Widget _buildCarouselItem(String backgroundUrl, String avatar1Url,
      String avatar2Url, String channel, String title) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        image: DecorationImage(
          image: NetworkImage(backgroundUrl),
          fit: BoxFit.cover,
        ),
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
            colors: [
              Colors.black.withAlpha((255 * 0.8).round()),
              Colors.transparent,
            ],
          ),
        ),
        child: Stack(
          children: [
            Positioned(
              left: 16,
              bottom: 16,
              child: CircleAvatar(
                radius: 30,
                backgroundImage: NetworkImage(avatar1Url),
              ),
            ),
            Positioned(
              right: 16,
              bottom: 16,
              child: CircleAvatar(
                radius: 30,
                backgroundImage: NetworkImage(avatar2Url),
              ),
            ),
            Positioned(
              bottom: 16,
              left: 86,
              right: 86,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    channel,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 12,
                      fontFamily: 'Poppins',
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    title,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Poppins',
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ===================================================================
// PERBAIKAN RESPONSIVE: Menggunakan ListView dan max-height
// ===================================================================
Widget _buildPopupCard({
  required String step,
  required String title,
  required String content,
  required VoidCallback onContinue,
  required VoidCallback? onSkip,
  String continueText = "Continue",
}) {
  return Builder(builder: (context) {
    // Dapatkan tinggi layar
    final screenHeight = MediaQuery.of(context).size.height;

    return Material(
      color: Colors.transparent,
      child: Container(
        // Padding internal yang lebih kecil
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        // Batasi tinggi popup agar bisa di-scroll jika konten terlalu panjang
        constraints: BoxConstraints(
          maxWidth: 500, // Lebar maks
          maxHeight: screenHeight * 0.7, // Maks 70% tinggi layar
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        // GANTI Column -> ListView agar bisa scroll jika overflow
        child: ListView(
          shrinkWrap: true, // Ambil ruang secukupnya
          children: [
            Text(
              step,
              style: const TextStyle(
                fontFamily: 'Poppins',
                color: Color(0xFF3B2C8D),
                fontWeight: FontWeight.w600,
                fontSize: 12,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              title,
              style: const TextStyle(
                fontFamily: 'Poppins',
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              content,
              style: TextStyle(
                fontFamily: 'Poppins',
                color: Colors.grey[700],
                fontSize: 14,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 20),
            // Tombol tetap menggunakan Wrap
            Wrap(
              alignment: WrapAlignment.end,
              spacing: 8.0,
              runSpacing: 4.0,
              children: [
                if (onSkip != null)
                  TextButton(
                    onPressed: onSkip,
                    child: const Text(
                      "Skip",
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        color: Colors.grey,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ElevatedButton(
                  onPressed: onContinue,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF3B2C8D),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(
                    continueText,
                    style: const TextStyle(
                      fontFamily: 'Poppins',
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  });
}
