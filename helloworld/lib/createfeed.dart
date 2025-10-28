import 'package:flutter/material.dart';

class CreateFeedPage extends StatelessWidget {
  const CreateFeedPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFF5B4AE2),
        foregroundColor: Colors.white,
        title: const Text(
          'Create Feed',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          TextButton(
            onPressed: () {
              // Handle post
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Feed posted successfully!'),
                  backgroundColor: Color(0xFF5B4AE2),
                ),
              );
              Navigator.pop(context);
            },
            child: const Text(
              'Post',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // User Info
            Row(
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundColor: Colors.grey[300],
                  child: const Icon(Icons.person, color: Colors.white),
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      '@username',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      'Post to channel',
                      style: TextStyle(color: Colors.grey[600], fontSize: 12),
                    ),
                  ],
                ),
              ],
            ),

            const SizedBox(height: 24),

            // Channel Selection
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.hub_outlined,
                    color: Color(0xFF5B4AE2),
                    size: 20,
                  ),
                  const SizedBox(width: 12),
                  const Text(
                    'Select Channel',
                    style: TextStyle(
                      color: Color(0xFF5B4AE2),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const Spacer(),
                  Icon(Icons.arrow_drop_down, color: Colors.grey[600]),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Content Input
            TextField(
              maxLines: 8,
              decoration: InputDecoration(
                hintText: "What's happening?",
                hintStyle: TextStyle(color: Colors.grey[400], fontSize: 18),
                border: InputBorder.none,
              ),
              style: const TextStyle(fontSize: 16),
            ),

            const SizedBox(height: 24),

            // Media Upload Options
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  _buildMediaOption(
                    Icons.image_outlined,
                    'Add Image',
                    () => print('Add Image'),
                  ),
                  const SizedBox(height: 12),
                  _buildMediaOption(
                    Icons.videocam_outlined,
                    'Add Video',
                    () => print('Add Video'),
                  ),
                  const SizedBox(height: 12),
                  _buildMediaOption(
                    Icons.link,
                    'Add Link',
                    () => print('Add Link'),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Poll Option
            OutlinedButton.icon(
              onPressed: () => print('Create Poll'),
              icon: const Icon(Icons.poll_outlined),
              label: const Text('Create Poll'),
              style: OutlinedButton.styleFrom(
                foregroundColor: const Color(0xFF5B4AE2),
                side: const BorderSide(color: Color(0xFF5B4AE2)),
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMediaOption(IconData icon, String label, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Row(
        children: [
          Icon(icon, color: const Color(0xFF5B4AE2), size: 24),
          const SizedBox(width: 12),
          Text(
            label,
            style: const TextStyle(fontSize: 16, color: Color(0xFF2D2D2D)),
          ),
          const Spacer(),
          Icon(Icons.chevron_right, color: Colors.grey[400]),
        ],
      ),
    );
  }
}
