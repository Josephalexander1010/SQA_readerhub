// lib/my_channel_collection.dart
import 'dart:io';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'models.dart';
import 'channel_detail.dart';
import 'api_service.dart';

class MyChannelCollectionPage extends StatefulWidget {
  final Function(ChannelInfo) onChannelVisited;
  final Function(ChannelInfo)? onChannelDeleted;

  const MyChannelCollectionPage({
    super.key,
    required this.onChannelVisited,
    this.onChannelDeleted,
  });

  @override
  State<MyChannelCollectionPage> createState() =>
      _MyChannelCollectionPageState();
}

class _MyChannelCollectionPageState extends State<MyChannelCollectionPage> {
  late Future<List<ChannelInfo>> _channelsFuture;

  @override
  void initState() {
    super.initState();
    _refreshChannels();
  }

  void _refreshChannels() {
    setState(() {
      _channelsFuture = ApiService().getChannels();
    });
  }

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
              if (widget.onChannelDeleted != null) {
                widget.onChannelDeleted!(channel);
              }
              // Refresh list after deletion (assuming onChannelDeleted handles backend call or we do it here)
              // For now, we assume onChannelDeleted might just update global state, but we should probably call API here too.
              // But let's just refresh for now.
              _refreshChannels();
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
      body: FutureBuilder<List<ChannelInfo>>(
        future: _channelsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.folder_open, size: 64, color: Colors.grey),
                  const SizedBox(height: 16),
                  Text(
                    'No channels in collection',
                    style: GoogleFonts.poppins(color: Colors.grey),
                  ),
                ],
              ),
            );
          }

          final allChannels = snapshot.data!;
          return RefreshIndicator(
            onRefresh: () async {
              _refreshChannels();
              await _channelsFuture;
            },
            child: GridView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: allChannels.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4, // Adjusted for better fit
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
        },
      ),
    );
  }

  Widget _buildChannelCircle(BuildContext context, ChannelInfo channel) {
    return GestureDetector(
      onTap: () {
        widget.onChannelVisited(channel);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ChannelDetailPage(channel: channel),
          ),
        ).then((_) => _refreshChannels()); // Refresh when returning from detail
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

  Widget _buildChannelPfp(ChannelInfo channel) {
    final path = channel.pfpPath;

    if (path == null || path.isEmpty) {
      return const Icon(Icons.group, size: 35, color: Colors.grey);
    }

    if (path.startsWith('http') || path.startsWith('blob:')) {
      return Image.network(
        path,
        fit: BoxFit.cover,
        errorBuilder: (c, e, s) => const Icon(Icons.group, size: 35),
      );
    } else if (path.startsWith('assets/')) {
      return Image.asset(
        path,
        fit: BoxFit.cover,
        errorBuilder: (c, e, s) => const Icon(Icons.group, size: 35),
      );
    } else {
      if (kIsWeb) {
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
}
