// lib/homepage.dart
import 'dart:io';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';
import 'notificationpage.dart';
import 'channel_detail.dart';
import 'feed.dart';
import 'createfeed.dart';
import 'models.dart';
import 'api_service.dart';

class HomePage extends StatefulWidget {
  final GlobalKey fabKey;
  final VoidCallback onShowStep4;

  final List<ChannelInfo> lastVisitedChannels;
  final Function(ChannelInfo) onChannelVisited;
  final VoidCallback onLoadMore;

  const HomePage({
    super.key,
    required this.fabKey,
    required this.onShowStep4,
    required this.lastVisitedChannels,
    required this.onChannelVisited,
    required this.onLoadMore,
  });

  @override
  State<HomePage> createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  // ... (Data _homeFeeds, _likedFeeds, _savedFeeds SAMA) ...
  final Map<int, bool> _likedFeeds = {};
  final Map<int, bool> _savedFeeds = {};
  final List<Map<String, dynamic>> _homeFeeds = [
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

  late TutorialCoachMark _tutorialSteps2and3;
  final GlobalKey _myChannelsKey = GlobalKey();
  final GlobalKey _firstFeedItemKey = GlobalKey();

  // ... (Fungsi addNewPost SAMA) ...
  void addNewPost(FeedPost post) {
    final int newId = _homeFeeds.fold<int>(
            0, (prev, map) => map['id'] > prev ? map['id'] : prev) +
        1;
    final newFeedMap = {
      'id': newId,
      'username': 'Anda',
      'imageUrl': 'https://randomuser.me/api/portraits/lego/1.jpg',
      'channel': post.channel,
      'subtitle': post.subChannel,
      'time': 'Baru saja',
      'content': post.caption,
      'comments': 0,
      'likes': 0,
      'hasImage': post.media != null,
    };
    setState(() {
      _homeFeeds.insert(0, newFeedMap);
    });
  }

  // ... (Kode tutorial _checkAndShowWalkthrough, dll. SAMA) ...
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkAndShowWalkthrough();
    });
  }

  void _checkAndShowWalkthrough() async {
    final prefs = await SharedPreferences.getInstance();
    bool hasCompleted = prefs.getBool('walkthrough_completed') ?? false;

    if (!hasCompleted && mounted) {
      _showWalkthroughStep1Dialog();
    }
  }

  void _showWalkthroughStep1Dialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.transparent,
      builder: (BuildContext dialogContext) {
        return Dialog.fullscreen(
          backgroundColor: Colors.black.withAlpha((255 * 0.7).round()),
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: _buildPopupCard(
                step: "Step 1/5",
                title: "Welcome to Reader-HUB!",
                content:
                    "Hello There. The one place for all your favorite book and fanfic discussions. Let us give you a quick tour.",
                onContinue: () {
                  Navigator.of(dialogContext).pop();
                  _showWalkthroughSteps2and3();
                },
                onSkip: () {
                  Navigator.of(dialogContext).pop();
                  _markWalkthroughAsDone();
                },
              ),
            ),
          ),
        );
      },
    );
  }

  void _showWalkthroughSteps2and3() {
    _tutorialSteps2and3 = TutorialCoachMark(
      targets: [
        TargetFocus(
          identify: "my-channels-key",
          keyTarget: _myChannelsKey,
          shape: ShapeLightFocus.RRect,
          radius: 8,
          contents: [
            TargetContent(
              align: ContentAlign.bottom,
              builder: (context, controller) {
                return _buildPopupCard(
                  step: "Step 2/5",
                  title: "Find Your Communities in Channels",
                  content:
                      "Think of a Channel as a home for any topic or fandom. Inside, you'll find more specific discussion spaces called sub-channels.",
                  onContinue: () => controller.next(),
                  onSkip: () => controller.skip(),
                );
              },
            ),
          ],
        ),
        TargetFocus(
          identify: "first-feed-item-key",
          keyTarget: _firstFeedItemKey,
          shape: ShapeLightFocus.RRect,
          radius: 8,
          contents: [
            TargetContent(
              align: ContentAlign.bottom,
              builder: (context, controller) {
                return _buildPopupCard(
                  step: "Step 3/5",
                  title: "And The Most Important, This Is Your Home Feed",
                  content:
                      "Here, you'll see the latest posts from all the Channels you follow. The more Channels you join, the livelier your feed becomes!",
                  onContinue: () => controller.next(),
                  onSkip: () => controller.skip(),
                );
              },
            ),
          ],
        ),
      ],
      colorShadow: Colors.black.withAlpha((255 * 0.7).round()),
      textSkip: "",
      onFinish: () {
        widget.onShowStep4();
      },
      onSkip: () {
        _markWalkthroughAsDone();
        return true;
      },
    );
    _tutorialSteps2and3.show(context: context);
  }

  void _markWalkthroughAsDone() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('walkthrough_completed', true);
  }

  @override
  Widget build(BuildContext context) {
    // ... (Fungsi build SAMA) ...

    if (_homeFeeds.isEmpty) {
      return Scaffold(
        backgroundColor: const Color(0xFFF8F9FA),
        body: SafeArea(
          child: Column(
            children: [
              _buildHeader(),
              const SizedBox(height: 10),
              Container(
                key: _myChannelsKey,
                child: _buildMyChannelsSection(),
              ),
              const SizedBox(height: 24),
              _buildChannelFeedHeader(),
              const Expanded(
                child: Center(
                  child: Text("Tidak ada feed untuk ditampilkan."),
                ),
              ),
            ],
          ),
        ),
      );
    }

    final firstFeed = _homeFeeds[0];
    final int firstId = firstFeed['id'] as int;
    final bool isFirstLiked = _likedFeeds[firstId] ?? false;
    final bool isFirstSaved = _savedFeeds[firstId] ?? false;

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
                    _buildHeader(),
                    const SizedBox(height: 10),
                    Container(
                      key: _myChannelsKey,
                      child: _buildMyChannelsSection(),
                    ),
                    const SizedBox(height: 24),
                    Column(
                      key: _firstFeedItemKey,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildChannelFeedHeader(),
                        FeedItem(
                          id: firstId,
                          username: firstFeed['username'] as String,
                          imageUrl: firstFeed['imageUrl'] as String,
                          channel: firstFeed['channel'] as String,
                          subtitle: firstFeed['subtitle'] as String,
                          time: firstFeed['time'] as String,
                          content: firstFeed['content'] as String,
                          comments: firstFeed['comments'] as int,
                          likes: firstFeed['likes'] as int,
                          hasImage: firstFeed['hasImage'] as bool,
                          isLiked: isFirstLiked,
                          isSaved: isFirstSaved,
                          avatarBuilder: buildAvatar, // Dari feed.dart
                          onLike: () {
                            setState(() {
                              _likedFeeds[firstId] = !isFirstLiked;
                            });
                          },
                          onSave: () {
                            setState(() {
                              _savedFeeds[firstId] = !isFirstSaved;
                            });
                          },
                        ),
                      ],
                    ),
                    _buildFeedListRemaining(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeedListRemaining() {
    // ... (Fungsi _buildFeedListRemaining SAMA) ...
    if (_homeFeeds.length <= 1) return Container();
    final remainingFeeds = _homeFeeds.sublist(1);
    return ListView.builder(
      itemCount: remainingFeeds.length,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        final feed = remainingFeeds[index];
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
          avatarBuilder: buildAvatar, // Dari feed.dart
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

  Widget _buildHeader() {
    // ... (Fungsi _buildHeader SAMA) ...
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

  // --- PERBAIKAN DI SINI ---
  // Direvisi total untuk menggunakan Row + Expanded

  Widget _buildMyChannelsSection() {
    return FutureBuilder<List<ChannelInfo>>(
      future: ApiService().getChannels(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('No channels found'));
        }

        final channels = snapshot.data!;
        const double itemSize = 60.0;

        // Take first 4 channels
        List<ChannelInfo?> channelsToShow = List.from(channels.take(4));
        while (channelsToShow.length < 4) {
          channelsToShow.add(null);
        }

        return Container(
          color: const Color(0xFFF8F9FA),
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
          child: SizedBox(
            height: itemSize + 30,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ...channelsToShow.map(
                  (channel) => Expanded(
                    child: channel != null
                        ? _buildChannelCircle(channel, itemSize)
                        : Container(),
                  ),
                ),
                Expanded(
                  child: _buildLoadMoreCircle(itemSize),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildChannelCircle(ChannelInfo channel, double size) {
    // Hapus Padding dari sini
    return GestureDetector(
      onTap: () => _openChannelDetail(channel),
      child: SizedBox(
        width: size,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              width: size,
              height: size,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.grey[300],
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withAlpha((255 * 0.1).round()),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: ClipOval(
                child: _buildChannelPfp(channel), // Gunakan helper PFP
              ),
            ),
            const SizedBox(height: 6),
            Text(
              channel.name,
              textAlign: TextAlign.center,
              maxLines: 1, // <-- Paksa 1 baris
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 11,
                color: Colors.grey[600],
                fontFamily: 'Poppins',
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoadMoreCircle(double size) {
    // Hapus Padding dari sini
    return GestureDetector(
      onTap: widget.onLoadMore,
      child: SizedBox(
        width: size,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              width: size,
              height: size,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Color(0xFF3B2C8D),
              ),
              child:
                  const Icon(Icons.more_horiz, color: Colors.white, size: 30),
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
      ),
    );
  }
  // -------------------------

  // Arahkan ke Halaman Detail Channel yang BARU
  void _openChannelDetail(ChannelInfo channel) {
    widget.onChannelVisited(channel);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ChannelDetailPage(
          channel: channel,
        ),
      ),
    );
  }

  Widget _buildChannelFeedHeader() {
    // ... (Kode _buildChannelFeedHeader SAMA) ...
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
}

// --- _buildPopupCard (SAMA) ---
Widget _buildPopupCard({
  required String step,
  required String title,
  required String content,
  required VoidCallback onContinue,
  required VoidCallback? onSkip,
  String continueText = "Continue",
}) {
  return Builder(builder: (context) {
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

// Helper PFP (disalin dari channel_detail.dart agar file ini mandiri)
Widget _buildChannelPfp(ChannelInfo channel) {
  if (channel.pfpPath == null || channel.pfpPath!.isEmpty) {
    return const Icon(Icons.group, size: 35, color: Colors.grey);
  }

  if (channel.isPfpNetwork) {
    return Image.network(
      channel.pfpPath!,
      fit: BoxFit.cover,
      errorBuilder: (c, e, s) => const Icon(Icons.group, size: 35),
    );
  } else if (channel.isPfpAsset) {
    return Image.asset(
      channel.pfpPath!,
      fit: BoxFit.cover,
      errorBuilder: (c, e, s) => const Icon(Icons.group, size: 35),
    );
  } else {
    return kIsWeb
        ? Image.network(
            channel.pfpPath!,
            fit: BoxFit.cover,
            errorBuilder: (c, e, s) => const Icon(Icons.group, size: 35),
          )
        : Image.file(
            File(channel.pfpPath!),
            fit: BoxFit.cover,
            errorBuilder: (c, e, s) => const Icon(Icons.group, size: 35),
          );
  }
}
