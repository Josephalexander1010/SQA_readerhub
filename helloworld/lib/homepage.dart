import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: SafeArea(
        child: Column(
          children: [
            // Header
            _buildHeader(),

            // Content
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20),

                    // My Channels Section
                    _buildMyChannelsSection(),

                    const SizedBox(height: 24),

                    // Your Channel Feed Section
                    _buildChannelFeedHeader(),

                    const SizedBox(height: 12),

                    // Feed Items (dummy data - replace with backend)
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
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              const Text(
                'My Channels',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF5B4AE2),
                ),
              ),
              const SizedBox(width: 6),
              Icon(Icons.people_outline, color: Color(0xFF5B4AE2), size: 26),
            ],
          ),
          Stack(
            children: [
              Icon(
                Icons.notifications_outlined,
                color: Colors.grey[700],
                size: 28,
              ),
              Positioned(
                right: 0,
                top: 0,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: const BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle,
                  ),
                  constraints: const BoxConstraints(
                    minWidth: 18,
                    minHeight: 18,
                  ),
                  child: const Text(
                    '99+',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 8,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMyChannelsSection() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Column(
        children: [
          SizedBox(
            height: 90,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: [
                // Empty channel slots
                _buildEmptyChannelCircle(),
                _buildEmptyChannelCircle(),
                _buildEmptyChannelCircle(),
                _buildEmptyChannelCircle(),
                _buildLoadMoreCircle(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyChannelCircle() {
    return Padding(
      padding: const EdgeInsets.only(right: 12),
      child: Column(
        children: [
          Container(
            width: 65,
            height: 65,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.grey[200],
              border: Border.all(color: Colors.grey[300]!, width: 2),
            ),
          ),
          const SizedBox(height: 6),
          Text('', style: TextStyle(fontSize: 11, color: Colors.grey[600])),
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
              color: Color(0xFF5B4AE2),
            ),
            child: const Icon(Icons.more_horiz, color: Colors.white, size: 30),
          ),
          const SizedBox(height: 6),
          Text(
            'Load More...',
            style: TextStyle(fontSize: 11, color: Colors.grey[600]),
          ),
        ],
      ),
    );
  }

  Widget _buildChannelFeedHeader() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: const Text(
        'Your Channel Feed',
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Color(0xFF5B4AE2),
        ),
      ),
    );
  }

  Widget _buildFeedList() {
    // Sample feed data - replace with backend data
    return Column(
      children: [
        _buildFeedItem(
          username: '@Name',
          channel: 'Reading Club',
          subtitle: 'Read',
          time: '1m',
          content: 'What\'s happening?',
          comments: 95,
          likes: 1300,
        ),
        _buildFeedItem(
          username: '@Name',
          channel: 'Harry x Hermoi..',
          subtitle: 'Story of Greatn..',
          time: '1m',
          content: 'What\'s happening?',
          comments: 95,
          likes: 1300,
          isLiked: true,
        ),
        _buildFeedItem(
          username: '@Name',
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

  Widget _buildFeedItem({
    required String username,
    required String channel,
    required String subtitle,
    required String time,
    required String content,
    required int comments,
    required int likes,
    bool hasImage = false,
    bool isLiked = false,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 2),
      color: Colors.white,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              CircleAvatar(radius: 20, backgroundColor: Colors.grey[300]),
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
                          ),
                        ),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            '$channel → $subtitle',
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.grey[600],
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

          // Content
          Text(
            content,
            style: const TextStyle(fontSize: 15, color: Colors.black87),
          ),

          // Image
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

          // Actions
          Row(
            children: [
              Icon(
                Icons.chat_bubble_outline,
                color: Colors.grey[600],
                size: 20,
              ),
              const SizedBox(width: 6),
              Text(
                comments.toString(),
                style: TextStyle(fontSize: 13, color: Colors.grey[600]),
              ),
              const SizedBox(width: 24),
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
                ),
              ),
              const Spacer(),
              Icon(Icons.bookmark_border, color: Colors.grey[600], size: 20),
              const SizedBox(width: 16),
              Icon(Icons.ios_share, color: Colors.grey[600], size: 20),
            ],
          ),
        ],
      ),
    );
  }
}
