import 'package:flutter/material.dart';
import 'homepage.dart';
import 'searchpage.dart';
import 'channelspage.dart';
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

  // List halaman yang akan ditampilkan (hanya 4 page, tidak ada CreatePage)
  final List<Widget> _pages = [
    const HomePage(),
    const SearchPage(),
    const ChannelsPage(),
    const ProfilePage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
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
                const SizedBox(width: 60), // Space untuk tombol tengah
                _buildNavItem(
                  Icons.hub_outlined,
                  Icons.hub,
                  2,
                ), // Index 2 untuk Channels
                _buildNavItem(
                  Icons.person_outline,
                  Icons.person,
                  3,
                ), // Index 3 untuk Profile
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showCreateMenu(context),
        backgroundColor: const Color(0xFF5B4AE2),
        child: const Icon(Icons.add, size: 32, color: Colors.white),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  void _showCreateMenu(BuildContext context) {
    showDialog(
      context: context,
      barrierColor: Colors.black.withValues(alpha: 0.3),
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
                    color: const Color(0xFF5B4AE2),
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.2),
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
                          // Navigate to Create Channel
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const CreateChannelPage(),
                            ),
                          );
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 16,
                          ),
                          child: Row(
                            children: [
                              const Text(
                                'Create\nChannel',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  height: 1.2,
                                ),
                              ),
                              const Spacer(),
                              const Icon(
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
                        color: Colors.white.withValues(alpha: 0.3),
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.pop(context);
                          // Navigate to Create Feeds
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const CreateFeedPage(),
                            ),
                          );
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 16,
                          ),
                          child: Row(
                            children: [
                              const Text(
                                'Create\nFeeds',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  height: 1.2,
                                ),
                              ),
                              const Spacer(),
                              const Icon(
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

  Widget _buildNavItem(IconData icon, IconData activeIcon, int index) {
    bool isSelected = _selectedIndex == index;
    return InkWell(
      onTap: () => _onItemTapped(index),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Icon(
          isSelected ? activeIcon : icon,
          color: isSelected ? const Color(0xFF5B4AE2) : Colors.grey,
          size: 28,
        ),
      ),
    );
  }
}

// CreatePage tidak digunakan lagi karena diganti dengan popup menu
