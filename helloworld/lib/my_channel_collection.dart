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
  // --- CALLBACK BARU ---
  final Function(ChannelInfo)? onChannelDeleted;

  const MyChannelCollectionPage({
    super.key,
    required this.allChannels,
    required this.onChannelVisited,
    this.onChannelDeleted,
  });

  // Fungsi Hapus Channel
  void _confirmDeleteChannel(BuildContext context, ChannelInfo channel) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Delete Channel"),
        content: Text("Delete '${channel.name}'? This cannot be undone."),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx), child: const Text("Cancel")),
          TextButton(
            onPressed: () {
              // Panggil callback ke navbar
              if (onChannelDeleted != null) onChannelDeleted!(channel);
              Navigator.pop(ctx);
            },
            child: const Text("Delete", style: TextStyle(color: Colors.red)),
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
        title: Text('My Channel Collection',
            style: GoogleFonts.poppins(
                color: const Color(0xFF3B2C8D),
                fontSize: 22,
                fontWeight: FontWeight.w700)),
        centerTitle: true,
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: allChannels.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 5,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: 0.75),
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
                builder: (context) => ChannelDetailPage(channel: channel)));
      },
      // --- FITUR HAPUS CHANNEL (Long Press) ---
      onLongPress: () {
        // Hanya bisa hapus jika milik sendiri
        if (channel.isOwned) {
          _confirmDeleteChannel(context, channel);
        }
      },
      // ----------------------------------------
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          AspectRatio(
            aspectRatio: 1,
            child: Container(
              decoration: BoxDecoration(
                  color: const Color(0xFFD9D9D9),
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.grey[300]!, width: 1)),
              child: ClipOval(child: _buildChannelPfp(channel)),
            ),
          ),
          const SizedBox(height: 4),
          Text(channel.name,
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.poppins(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: Colors.black87)),
        ],
      ),
    );
  }

  // Helper PFP (Sama)
  Widget _buildChannelPfp(ChannelInfo channel) {
    if (channel.pfpPath == null)
      return const Icon(Icons.group, color: Colors.grey);
    if (channel.isPfpNetwork)
      return Image.network(channel.pfpPath!, fit: BoxFit.cover);
    return kIsWeb
        ? Image.network(channel.pfpPath!, fit: BoxFit.cover)
        : Image.file(File(channel.pfpPath!), fit: BoxFit.cover);
  }
}
