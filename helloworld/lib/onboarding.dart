import 'package:flutter/material.dart';
import 'login_page.dart'; // <- gunakan LoginPage setelah onboarding selesai

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _page = 0;

  final List<_OnboardPageData> pages = [
    _OnboardPageData(
      title: 'Safe & Structured\nDiscussions',
      description:
          'Dive into deep conversations, neatly organized by Channels and Sub-channels. Your content remains private and protected.',
      icon: Icons.forum_rounded,
      imageAsset: 'assets/images/carousel1.png',
    ),
    _OnboardPageData(
      title: 'Highlighting &\nCommunity Discover',
      description:
          'Easily search for channels, topics, authors, or even your favorite quotes. Never miss out on the discussions trending in your community.',
      icon: Icons.search_rounded,
      imageAsset: 'assets/images/carousel2.png',
    ),
    _OnboardPageData(
      title: 'Connect with\nYour Community',
      description:
          'Join fellow readers, writers, and fans. Build your profile, share your contributions, stay engaged with notification in every interaction.',
      icon: Icons.people_rounded,
      imageAsset: 'assets/images/carousel3.png',
    ),
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onGetStarted() {
    // <-- ganti target ke LoginPage
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const LoginPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView.builder(
        controller: _pageController,
        itemCount: pages.length,
        onPageChanged: (index) => setState(() => _page = index),
        itemBuilder: (context, index) {
          final p = pages[index];
          return Stack(
            children: [
              // Background image
              Positioned.fill(
                child: Image.asset(
                  p.imageAsset,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, st) =>
                      Container(color: Colors.grey.shade300),
                ),
              ),

              // Overlay gradient
              Positioned.fill(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.black.withOpacity(0.45),
                        Colors.black.withOpacity(0.15),
                      ],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                ),
              ),

              // Bottom white card
              Positioned(
                left: 16,
                right: 16,
                bottom: 28,
                child: _BottomCard(
                  title: p.title,
                  description: p.description,
                  icon: p.icon,
                  isLast: index == pages.length - 1,
                  pageIndex: _page,
                  pagesCount: pages.length,
                  onGetStarted: _onGetStarted,
                  onNextPage: () {
                    if (index < pages.length - 1) {
                      _pageController.nextPage(
                        duration: const Duration(milliseconds: 400),
                        curve: Curves.easeInOut,
                      );
                    }
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _OnboardPageData {
  final String title;
  final String description;
  final IconData icon;
  final String imageAsset;

  _OnboardPageData({
    required this.title,
    required this.description,
    required this.icon,
    required this.imageAsset,
  });
}

class _BottomCard extends StatelessWidget {
  final String title;
  final String description;
  final IconData icon;
  final bool isLast;
  final int pageIndex;
  final int pagesCount;
  final VoidCallback onGetStarted;
  final VoidCallback onNextPage;

  const _BottomCard({
    required this.title,
    required this.description,
    required this.icon,
    required this.isLast,
    required this.pageIndex,
    required this.pagesCount,
    required this.onGetStarted,
    required this.onNextPage,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 8,
      borderRadius: BorderRadius.circular(24),
      child: Container(
        padding: const EdgeInsets.fromLTRB(20, 18, 20, 18),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Title row
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: const Color(0xFF5B4AE2).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(icon, color: const Color(0xFF5B4AE2), size: 26),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      height: 1.05,
                    ),
                  ),
                )
              ],
            ),
            const SizedBox(height: 12),

            // Description
            Text(
              description,
              style: const TextStyle(
                fontSize: 13,
                color: Colors.black87,
                height: 1.4,
              ),
            ),

            const SizedBox(height: 14),

            // Dots + Button (only on last page show Get Started)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Page indicator dots
                Row(
                  children: List.generate(pagesCount, (i) {
                    final active = i == pageIndex;
                    return AnimatedContainer(
                      duration: const Duration(milliseconds: 250),
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      width: active ? 18 : 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color:
                            active ? const Color(0xFF5B4AE2) : Colors.grey[300],
                        borderRadius: BorderRadius.circular(8),
                      ),
                    );
                  }),
                ),

                // Only show Get Started on last page
                if (isLast)
                  ElevatedButton(
                    onPressed: onGetStarted,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF5B4AE2),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24),
                      ),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 18, vertical: 12),
                      elevation: 0,
                    ),
                    child: const Text(
                      'Get Started',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  )
                else
                  // keep empty space so layout doesn't jump when button appears
                  const SizedBox(width: 94),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
