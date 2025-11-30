// lib/navbar.dart
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';
import 'models.dart';
import 'homepage.dart';
import 'searchpage.dart';
import 'my_channel_collection.dart';
import 'profilepage.dart';
import 'createfeed.dart';
import 'createchannel.dart';

class NavBar extends StatefulWidget {
  const NavBar({super.key});

  @override
  State<NavBar> createState() => _NavBarState();
}

class _NavBarState extends State<NavBar> {
  int _selectedIndex = 0;
  final PageController _pageController = PageController();
  final GlobalKey _fabKey = GlobalKey();
  final GlobalKey<HomePageState> _homePageKey = GlobalKey<HomePageState>();

  @override
  void initState() {
    super.initState();
    // Inisialisasi lastVisited dari data global saat aplikasi mulai
    gLastVisitedChannels = gAllChannels.take(4).toList();
  }

  // --- LOGIKA STATE UTAMA ---

  // 1. Callback saat channel diklik (dikunjungi)
  void _handleChannelVisited(ChannelInfo channel) {
    setState(() {
      // Hapus jika sudah ada agar tidak duplikat, lalu masukkan ke depan
      gLastVisitedChannels.removeWhere((c) => c.id == channel.id);
      gLastVisitedChannels.insert(0, channel);

      // Batasi hanya 4 item (+1 Load More nanti di UI)
      if (gLastVisitedChannels.length > 4) {
        gLastVisitedChannels = gLastVisitedChannels.sublist(0, 4);
      }
    });
  }

  // 2. Callback saat channel dihapus (Long Press di Collection)
  void _handleDeleteChannel(ChannelInfo channel) {
    setState(() {
      // Hapus dari daftar utama
      gAllChannels.removeWhere((c) => c.id == channel.id);
      // Hapus juga dari history kunjungan
      gLastVisitedChannels.removeWhere((c) => c.id == channel.id);
    });

    // Tampilkan snackbar konfirmasi
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Channel '${channel.name}' deleted"),
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  // 3. Navigasi ke Create Channel
  void _navigateToCreateChannel() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const CreateChannelPage()),
    );

    if (result == true) {
      // Refresh daftar channel dari API
      setState(() {
        // Kita bisa memicu reload di MyChannelCollectionPage jika menggunakan FutureBuilder
        // atau kita bisa memuat ulang data global di sini jika kita ingin cache-nya update
        // Untuk saat ini, kita biarkan MyChannelCollectionPage memuat ulang sendiri karena dia pakai FutureBuilder
        // Tapi kita perlu update gLastVisitedChannels jika kita ingin channel baru muncul di sana
        // Namun karena API create tidak mengembalikan objek channel lengkap, kita mungkin perlu fetch ulang
        // atau biarkan user menemukannya di list.

        // Opsi terbaik: Pindah ke tab Collection dan biarkan ia refresh
      });

      _onItemTapped(2);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text("Channel created! Pull to refresh collection.")),
        );
      }
    }
  }

  // 4. Navigasi ke Create Feed
  void _navigateToCreateFeed() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const CreateFeedPage()),
    );

    if (result != null && result is FeedPost) {
      _homePageKey.currentState?.addNewPost(result);
      if (_selectedIndex != 0) {
        _onItemTapped(0);
      }
      debugPrint('Postingan baru diterima: ${result.caption}');
    }
  }
  // --------------------------

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    _pageController.jumpToPage(index);
  }

  // --- UI BUILDER ---
  @override
  Widget build(BuildContext context) {
    // Kita membangun list pages di sini agar selalu mendapat state terbaru
    // saat setState dipanggil
    final List<Widget> pages = [
      HomePage(
        key: _homePageKey,
        fabKey: _fabKey,
        onShowStep4: _showWalkthroughStep4,
        lastVisitedChannels: gLastVisitedChannels, // Data terbaru
        onChannelVisited: _handleChannelVisited,
        onLoadMore: () => _onItemTapped(2),
      ),
      const SearchPage(),
      MyChannelCollectionPage(
        onChannelVisited: _handleChannelVisited,
        onChannelDeleted:
            _handleDeleteChannel, // <-- Fungsi delete diteruskan ke sini
      ),
      const ProfilePage(),
    ];

    return Scaffold(
      body: PageView(
        controller: _pageController,
        physics: const NeverScrollableScrollPhysics(),
        children: pages,
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha((255 * 0.1).round()),
              blurRadius: 10,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: BottomAppBar(
          shape: const CircularNotchedRectangle(),
          notchMargin: 8,
          color: Colors.white,
          child: SizedBox(
            height: 60,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildNavItem(Icons.home_outlined, Icons.home, 0),
                _buildNavItem(Icons.search, Icons.search, 1),
                const SizedBox(width: 60),
                _buildNavItem(Icons.hub_outlined, Icons.hub, 2),
                _buildNavItem(Icons.person_outline, Icons.person, 3),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        key: _fabKey,
        heroTag: 'navbarFAB', // Tag unik untuk mencegah error Hero
        onPressed: () => _showCreateMenu(context),
        backgroundColor: const Color(0xFF3B2C8D),
        child: const Icon(Icons.add, size: 32, color: Colors.white),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  // --- MENU POPUP (+ Button) ---
  void _showCreateMenu(BuildContext context) {
    showDialog(
      context: context,
      barrierColor: Colors.black.withAlpha((255 * 0.3).round()),
      builder: (BuildContext context) {
        return Stack(
          children: [
            Positioned(
              bottom: 100,
              right: 20,
              child: Material(
                color: Colors.transparent,
                child: Container(
                  width: 200,
                  decoration: BoxDecoration(
                    color: const Color(0xFF3B2C8D),
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withAlpha((255 * 0.2).round()),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      InkWell(
                        onTap: () {
                          Navigator.pop(context);
                          _navigateToCreateChannel();
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 16,
                          ),
                          child: const Row(
                            children: [
                              Text(
                                'Create\nChannel',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  height: 1.2,
                                  fontFamily: 'Poppins',
                                ),
                              ),
                              Spacer(),
                              Icon(
                                Icons.hub_outlined,
                                color: Colors.white,
                                size: 24,
                              ),
                            ],
                          ),
                        ),
                      ),
                      Container(
                        height: 1,
                        margin: const EdgeInsets.symmetric(horizontal: 20),
                        color: Colors.white.withAlpha((255 * 0.3).round()),
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.pop(context);
                          _navigateToCreateFeed();
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 16,
                          ),
                          child: const Row(
                            children: [
                              Text(
                                'Create\nFeeds',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  height: 1.2,
                                  fontFamily: 'Poppins',
                                ),
                              ),
                              Spacer(),
                              Icon(
                                Icons.edit_outlined,
                                color: Colors.white,
                                size: 24,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  // --- NAVIGATION ITEM ---
  Widget _buildNavItem(IconData icon, IconData activeIcon, int index) {
    bool isSelected = _selectedIndex == index;
    return InkWell(
      onTap: () => _onItemTapped(index),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Icon(
          isSelected ? activeIcon : icon,
          color: isSelected ? const Color(0xFF3B2C8D) : Colors.grey,
          size: 28,
        ),
      ),
    );
  }

  // --- TUTORIAL COACH MARK ---
  void _showWalkthroughStep4() {
    TutorialCoachMark(
      targets: [_createFabTarget()],
      colorShadow: Colors.black.withAlpha((255 * 0.7).round()),
      textSkip: "",
      onFinish: () async {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setBool('walkthrough_step_5_pending', true);
        _onItemTapped(1);
      },
      onSkip: () {
        _markWalkthroughAsDone();
        return true;
      },
    ).show(context: context);
  }

  TargetFocus _createFabTarget() {
    return TargetFocus(
      identify: "fab-key",
      keyTarget: _fabKey,
      shape: ShapeLightFocus.Circle,
      contents: [
        TargetContent(
          align: ContentAlign.top,
          builder: (context, controller) {
            return _buildPopupCard(
              step: "Step 4/5",
              title: "Create Channel or Feeds?",
              content:
                  "Want a dedicated space for your book club or a niche topic? You can make your own Channel or Feeds by press this (+) button!",
              onContinue: () {
                controller.next();
              },
              onSkip: () {
                controller.skip();
              },
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
}

// --- TUTORIAL WIDGET ---
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
