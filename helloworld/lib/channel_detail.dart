// lib/channel_detail.dart
import 'dart:io';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'models.dart';
import 'subchannel_page.dart';
import 'createfeed.dart';

class ChannelDetailPage extends StatefulWidget {
  final ChannelInfo channel;
  final VoidCallback? onFollowStateChanged;

  const ChannelDetailPage(
      {super.key, required this.channel, this.onFollowStateChanged});

  @override
  State<ChannelDetailPage> createState() => _ChannelDetailPageState();
}

class _ChannelDetailPageState extends State<ChannelDetailPage> {
  late List<SubChannelInfo> _currentSubChannels;

  @override
  void initState() {
    super.initState();
    _currentSubChannels = widget.channel.subChannels; // Referensi langsung
  }

  // --- FITUR HAPUS SUB-CHANNEL ---
  void _deleteSubChannel(SubChannelInfo sub) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Delete Sub-Channel"),
        content: Text("Delete '${sub.name}'? All posts inside will be lost."),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx), child: const Text("Cancel")),
          TextButton(
            onPressed: () {
              setState(() {
                // Hapus dari list global
                widget.channel.subChannels.remove(sub);
              });
              Navigator.pop(ctx);
            },
            child: const Text("Delete", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  // ... (Fungsi _toggleFollow, _navigateToCreateFeed, _showCreateSubChannelDialog SAMA PERSIS) ...
  void _toggleFollow() {
    setState(() {
      widget.channel.isFollowing = !widget.channel.isFollowing;
      if (widget.channel.isFollowing) {
        if (!gAllChannels.contains(widget.channel))
          gAllChannels.add(widget.channel);
      } else {
        gAllChannels.removeWhere((c) => c.id == widget.channel.id);
        gLastVisitedChannels.removeWhere((c) => c.id == widget.channel.id);
      }
    });
    if (widget.onFollowStateChanged != null) widget.onFollowStateChanged!();
  }

  void _navigateToCreateFeed() {
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => const CreateFeedPage()));
  }

  void _showCreateSubChannelDialog() {
    // (Kode dialog sama seperti sebelumnya, singkat saja di sini)
    final TextEditingController subChannelController = TextEditingController();
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text("Create Sub-Channel"),
            content: TextField(
                controller: subChannelController,
                decoration:
                    const InputDecoration(hintText: "Sub-Channel Name")),
            actions: [
              TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text("Cancel")),
              ElevatedButton(
                  onPressed: () {
                    _addNewSubChannel(subChannelController.text);
                    Navigator.pop(context);
                  },
                  child: const Text("Create"))
            ],
          );
        });
  }

  void _addNewSubChannel(String name) {
    if (name.isEmpty) return;
    setState(() {
      widget.channel.subChannels.add(SubChannelInfo(name: name));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF4A3F8F)),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _buildReferenceHeader(),
            const SizedBox(height: 20),
            const Divider(thickness: 1, height: 1),
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 24, 24, 8),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text('Sub Channel',
                    style: GoogleFonts.poppins(
                        fontSize: 16, fontWeight: FontWeight.bold)),
              ),
            ),
            _buildSubChannelList(context),
          ],
        ),
      ),
      floatingActionButton: widget.channel.isOwned
          ? FloatingActionButton(
              heroTag: 'channelDetailFAB',
              onPressed: _showCreateSubChannelDialog,
              backgroundColor: const Color(0xFF3B2C8D),
              tooltip: 'Create Sub-Channel',
              child: const Icon(Icons.add, color: Colors.white),
            )
          : null,
    );
  }

  // ... (Widget _buildReferenceHeader SAMA PERSIS) ...
  Widget _buildReferenceHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Column(
        children: [
          Stack(
            alignment: Alignment.topCenter,
            children: [
              Align(
                  alignment: Alignment.centerRight,
                  child: Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.grey[200],
                          border:
                              Border.all(color: Colors.grey[300]!, width: 1)),
                      child:
                          ClipOval(child: _buildChannelPfp(widget.channel)))),
              Padding(
                  padding: const EdgeInsets.only(top: 10, left: 60, right: 60),
                  child: Text(widget.channel.name,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.poppins(
                          color: const Color(0xFF3B2C8D),
                          fontSize: 24,
                          fontWeight: FontWeight.w700))),
            ],
          ),
          const SizedBox(height: 12),
          if (!widget.channel.isOwned)
            GestureDetector(
                onTap: _toggleFollow,
                child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 32, vertical: 8),
                    decoration: BoxDecoration(
                        color: widget.channel.isFollowing
                            ? Colors.white
                            : const Color(0xFF3B2C8D),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: const Color(0xFF3B2C8D))),
                    child: Text(
                        widget.channel.isFollowing ? 'Following' : 'Follow',
                        style: GoogleFonts.poppins(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: widget.channel.isFollowing
                                ? const Color(0xFF3B2C8D)
                                : Colors.white)))),
          const SizedBox(height: 20),
          Text(widget.channel.description,
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                  fontSize: 14, color: Colors.black54, height: 1.5)),
        ],
      ),
    );
  }

  Widget _buildSubChannelList(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: widget.channel.subChannels.length,
      itemBuilder: (context, index) {
        final subChannel = widget.channel.subChannels[index];
        return ListTile(
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 24, vertical: 0),
          leading: CircleAvatar(
              backgroundColor: const Color(0xFF3B2C8D),
              radius: 18,
              child: Text(
                  subChannel.name.isNotEmpty
                      ? subChannel.name[0].toUpperCase()
                      : '#',
                  style: const TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold))),
          title: Text(subChannel.name,
              style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.black87)),

          // --- TAMBAHKAN LONG PRESS UNTUK DELETE ---
          onLongPress: widget.channel.isOwned
              ? () =>
                  _deleteSubChannel(subChannel) // Hanya pemilik yg bisa hapus
              : null,
          // ---------------------------------------

          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => SubChannelPage(
                        parentChannelName: widget.channel.name,
                        subChannelName: subChannel.name)));
          },
        );
      },
    );
  }
}

// Helper PFP (Sama)
Widget _buildChannelPfp(ChannelInfo channel) {
  // (Kode sama seperti sebelumnya)
  if (channel.pfpPath == null)
    return const Icon(Icons.group, color: Colors.grey);
  if (channel.isPfpNetwork)
    return Image.network(channel.pfpPath!, fit: BoxFit.cover);
  return kIsWeb
      ? Image.network(channel.pfpPath!, fit: BoxFit.cover)
      : Image.file(File(channel.pfpPath!), fit: BoxFit.cover);
}
