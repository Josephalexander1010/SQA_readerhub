// lib/searchpage.dart (REVISI: Tombol Notifikasi Dihapus)
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:carousel_slider_plus/carousel_slider_plus.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';
import 'search_results_page.dart';
// import 'notificationpage.dart'; // <-- Tidak lagi dibutuhkan
import 'feed.dart'; // <-- IMPORT FILE BARU

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

  // State dan Data untuk Feed
  final Map<int, bool> _likedFeeds = {};
  final Map<int, bool> _savedFeeds = {};
  final List<Map<String, dynamic>> _searchFeeds = [
    {
      'id': 0,
      'username': 'John Doe',
      'imageUrl': 'https://randomuser.me/api/portraits/men/32.jpg',
      'channel': 'Reading Club',
      'subtitle': 'Read',
      'time': '1m',
      'content': 'What\'s happening?',
      'comments': 95,
      'likes': 1300,
      'hasImage': false,
    },
    {
      'id': 1,
      'username': 'Jane Smith',
      'imageUrl': 'https://randomuser.me/api/portraits/women/44.jpg',
      'channel': 'Harry x Hermoi..',
      'subtitle': 'Story of Greatn..',
      'time': '1m',
      'content': 'What\'s happening?',
      'comments': 95,
      'likes': 1300,
      'hasImage': false,
    },
    {
      'id': 2,
      'username': 'Mike Johnson',
      'imageUrl': 'https://randomuser.me/api/portraits/men/46.jpg',
      'channel': 'Reading FC',
      'subtitle': 'Story Of Greatn..',
      'time': '1m',
      'content': 'What\'s happening?',
      'comments': 95,
      'likes': 1300,
      'hasImage': true,
    }
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkAndShowWalkthroughStep5();
    });
  }

  void _checkAndShowWalkthroughStep5() async {
    // ... (Kode tutorial Anda tetap sama) ...
    final prefs = await SharedPreferences.getInstance();
    bool needsStep5 = prefs.getBool('walkthrough_step_5_pending') ?? false;

    if (needsStep5 && mounted) {
      _tutorialCoachMark = TutorialCoachMark(
        targets: [_createSearchTarget()],
        colorShadow: Colors.black.withAlpha((255 * 0.7).round()),
        textSkip: "",
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
    // ... (Kode tutorial Anda tetap sama) ...
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
    // ... (Kode tutorial Anda tetap sama) ...
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('walkthrough_completed', true);
    await prefs.setBool('walkthrough_step_5_pending', false);
  }

  // _buildFeedList menggunakan FeedItem dari feed.dart
  Widget _buildFeedList() {
    return ListView.builder(
      itemCount: _searchFeeds.length,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        final feed = _searchFeeds[index];
        final int id = feed['id'] as int;
        final bool isLiked = _likedFeeds[id] ?? false;
        final bool isSaved = _savedFeeds[id] ?? false;

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
          isLiked: isLiked,
          isSaved: isSaved,
          avatarBuilder: buildAvatar,
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
    );
  }

  Widget _buildChannelFeedHeader() {
    // ... (Kode Anda tetap sama) ...
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
              _buildHeader(), // <-- Header yang sudah dimodifikasi
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
  // PERUBAHAN DI SINI: Ikon Notifikasi Dihapus
  // =======================================================
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
                'Search Page',
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF3B2C8D),
                  fontFamily: 'Poppins',
                ),
              ),
              const SizedBox(width: 6),
              Icon(Icons.search, color: Color(0xFF3B2C8D), size: 28),
            ],
          ),
          // GestureDetector dan Icon Notifikasi YANG ADA DI SINI SEBELUMNYA
          // SEKARANG SUDAH DIHAPUS.
        ],
      ),
    );
  }
  // =======================================================
  // AKHIR PERUBAHAN
  // =======================================================

  Widget _buildSearchBar() {
    // ... (Kode Anda tetap sama) ...
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
    // ... (Kode Anda tetap sama) ...
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
    // ... (Kode Anda tetap sama) ...
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

// Widget _buildPopupCard tetap sama
Widget _buildPopupCard({
  required String step,
  required String title,
  required String content,
  required VoidCallback onContinue,
  required VoidCallback? onSkip,
  String continueText = "Continue",
}) {
  return Builder(builder: (context) {
    // ... (Kode Anda tetap sama) ...
    final screenHeight = MediaQuery.of(context).size.height;

    return Material(
      color: Colors.transparent,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        constraints: BoxConstraints(
          maxWidth: 500,
          maxHeight: screenHeight * 0.7,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: ListView(
          shrinkWrap: true,
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
