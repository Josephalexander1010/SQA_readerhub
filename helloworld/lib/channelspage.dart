import 'package:flutter/material.dart';

class ChannelsPage extends StatelessWidget {
  const ChannelsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Container(
              color: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                children: [
                  const Icon(
                    Icons.hub_outlined,
                    color: Color(0xFF5B4AE2),
                    size: 26,
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    'My Channels',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF5B4AE2),
                    ),
                  ),
                  const Spacer(),
                  Icon(
                    Icons.add_circle_outline,
                    color: Colors.grey[700],
                    size: 28,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Content
            Expanded(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        color: const Color(0xFF5B4AE2).withValues(alpha: 0.1),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.hub_outlined,
                        size: 50,
                        color: Color(0xFF5B4AE2),
                      ),
                    ),
                    const SizedBox(height: 24),
                    const Text(
                      'No Channels Yet',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF2D2D2D),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Join or create channels to get started',
                      style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton.icon(
                      onPressed: () {
                        print('Create Channel');
                      },
                      icon: const Icon(Icons.add),
                      label: const Text('Create Channel'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF5B4AE2),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 12,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
