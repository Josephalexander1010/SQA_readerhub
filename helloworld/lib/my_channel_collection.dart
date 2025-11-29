// lib/my_channel_collection.dart
import 'dart:io';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'models.dart';
import 'channel_detail.dart';

class MyChannelCollectionPage extends StatelessWidget {
  final List<ChannelInfo> allChannels;
  final Function(ChannelInfo) onChannelVisited;
  final Function(ChannelInfo)? onChannelDeleted;

  const MyChannelCollectionPage({
    super.key,
    required this.allChannels,
    required this.onChannelVisited,
    this.onChannelDeleted,
  });

  void _confirmDeleteChannel(BuildContext context, ChannelInfo channel) {
    final bool isMyChannel = channel.isOwned;
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(isMyChannel ? "Delete Channel" : "Unfollow Channel"),
        content: Text(isMyChannel
            ? "Delete '${channel.name}'? This cannot be undone."
            : "Unfollow '${channel.name}'? It will be removed from your collection."),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx), child: const Text("Cancel")),
          TextButton(
            onPressed: () {
              if (onChannelDeleted != null) {
                onChannelDeleted!(channel);
              }
              Navigator.pop(ctx);
            },
            child: Text(isMyChannel ? "Delete" : "Unfollow",
                style: const TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Text(
          'My Channel Collection',
          style: GoogleFonts.poppins(
            color: const Color(0xFF3B2C8D),
            fontSize: 22,
            fontWeight: FontWeight.w700,
          ),
        ),
        centerTitle: true,
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: allChannels.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 5,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: 0.75,
        ),
        itemBuilder: (context, index) {
          final channel = allChannels[index];
          return _buildChannelCircle(context, channel);
        },
      ),
    );
  }

  Widget _buildChannelCircle(BuildContext context, ChannelInfo channel) {
    return GestureDetector(
      onTap: () {
        onChannelVisited(channel);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ChannelDetailPage(channel: channel),
          ),
        );
      },
      onLongPress: () => _confirmDeleteChannel(context, channel),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          AspectRatio(
            aspectRatio: 1,
            child: Container(
              decoration: BoxDecoration(
                color: const Color(0xFFD9D9D9),
                shape: BoxShape.circle,
                border: Border.all(color: Colors.grey[300]!, width: 1),
              ),
              child: ClipOval(
                child: _buildChannelPfp(channel),
              ),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            channel.name,
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.poppins(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }

  // --- PERBAIKAN LOGIKA PFP ---
  Widget _buildChannelPfp(ChannelInfo channel) {
    final path = channel.pfpPath;

    // 1. Jika tidak ada gambar -> Icon Default
    if (path == null || path.isEmpty) {
      return const Icon(Icons.group, size: 35, color: Colors.grey);
    }

    // 2. Jika path dimulai dengan 'http' atau 'blob:' (Web) -> NetworkImage
    if (path.startsWith('http') || path.startsWith('blob:')) {
      return Image.network(
        path,
        fit: BoxFit.cover,
        errorBuilder: (c, e, s) => const Icon(Icons.group, size: 35),
      );
    }

    // 3. Jika path dimulai dengan 'assets/' -> AssetImage
    else if (path.startsWith('assets/')) {
      return Image.asset(
        path,
        fit: BoxFit.cover,
        errorBuilder: (c, e, s) => const Icon(Icons.group, size: 35),
      );
    }

    // 4. Sisanya (File lokal di Mobile) -> Image.file
    else {
      if (kIsWeb) {
        // Fallback untuk web jika path aneh (seharusnya tidak masuk sini jika blob)
        return Image.network(
          path,
          fit: BoxFit.cover,
          errorBuilder: (c, e, s) => const Icon(Icons.group, size: 35),
        );
      } else {
        return Image.file(
          File(path),
          fit: BoxFit.cover,
          errorBuilder: (c, e, s) => const Icon(Icons.group, size: 35),
        );
      }
    }
  }
  // ---------------------------
}
