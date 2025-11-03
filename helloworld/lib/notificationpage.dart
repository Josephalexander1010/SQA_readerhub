import 'package:flutter/material.dart';

class NotificationPage extends StatelessWidget {
  const NotificationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // 1. Set background color
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        // 1. Set appbar color
        backgroundColor: const Color(0xFFF8F9FA),
        elevation: 1, // Kasih sedikit shadow tipis
        shadowColor: Colors.grey[200],
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.grey[800]),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'Notifications',
          style: TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.w600,
            // 6. Set font family
            fontFamily: 'Poppins',
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSectionHeader('Today'),
              _buildNotificationItem(
                username: 'Jane Smith',
                action: 'liked your post.',
                time: '1h ago',
                imageUrl:
                    'assets/post_image_1.png', // Ganti dengan path asset kamu
              ),
              _buildNotificationItem(
                username: 'John Doe',
                action: 'started following you.',
                time: '3h ago',
              ),
              _buildNotificationItem(
                username: 'Reading Club',
                action: 'posted a new story.',
                time: '5h ago',
                imageUrl:
                    'assets/post_image_2.png', // Ganti dengan path asset kamu
              ),
              const SizedBox(height: 24),
              _buildSectionHeader('This Week'),
              _buildNotificationItem(
                username: 'Mike Johnson',
                action: 'commented: "Great insight!"',
                time: '2d ago',
              ),
              _buildNotificationItem(
                username: 'Sarah Wilson',
                action: 'liked your comment.',
                time: '3d ago',
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10.0),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.black87,
          fontFamily: 'Poppins',
        ),
      ),
    );
  }

  Widget _buildNotificationItem({
    required String username,
    required String action,
    required String time,
    String? imageUrl,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 22,
            backgroundColor: Colors.grey[300],
            // child: Icon(Icons.person), // Placeholder
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RichText(
                  text: TextSpan(
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.black87,
                      fontFamily: 'Poppins',
                    ),
                    children: [
                      TextSpan(
                        text: '$username ',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      TextSpan(text: action),
                    ],
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  time,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                    fontFamily: 'Poppins',
                  ),
                ),
              ],
            ),
          ),
          if (imageUrl != null) ...[
            const SizedBox(width: 12),
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Container(
                width: 50,
                height: 50,
                color: Colors.grey[200],
                // child: Image.asset(imageUrl, fit: BoxFit.cover), // Aktifkan jika punya asset
                child: Icon(Icons.image_outlined, color: Colors.grey[400]),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
