// lib/createfeed.dart
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

import 'models.dart';
import 'subchannel_page.dart';

// ... (FeedPost class tetap sama) ...
class FeedPost {
  final String channel;
  final String subChannel;
  final String caption;
  final File? media;
  final bool commentsEnabled;
  final bool savesEnabled;

  FeedPost({
    required this.channel,
    required this.subChannel,
    required this.caption,
    required this.commentsEnabled,
    required this.savesEnabled,
    this.media,
  });
}

class CreateFeedPage extends StatefulWidget {
  const CreateFeedPage({super.key});

  @override
  State<CreateFeedPage> createState() => _CreateFeedPageState();
}

class _CreateFeedPageState extends State<CreateFeedPage> {
  // ... (Controller dan variabel state tetap sama) ...
  final TextEditingController _captionController = TextEditingController();
  final ImagePicker _picker = ImagePicker();

  ChannelInfo? _selectedChannelInfo;
  SubChannelInfo? _selectedSubChannelInfo;

  XFile? _pickedFile;
  String? _pickedFileType;

  bool _isPostButtonEnabled = false;
  bool _commentsEnabled = true;
  bool _savesEnabled = true;

  @override
  void initState() {
    super.initState();
    _captionController.addListener(_validateForm);
  }

  @override
  void dispose() {
    _captionController.removeListener(_validateForm);
    _captionController.dispose();
    super.dispose();
  }

  void _validateForm() {
    final bool isFormValid = _selectedChannelInfo != null &&
        _selectedSubChannelInfo != null &&
        _captionController.text.isNotEmpty;

    if (_isPostButtonEnabled != isFormValid) {
      setState(() {
        _isPostButtonEnabled = isFormValid;
      });
    }
  }

  void _submitPost() {
    if (!_isPostButtonEnabled) return;

    // --- PERBAIKAN DI SINI: Ambil avatar dari Channel yang dipilih ---
    // Kita gunakan pfpPath dari _selectedChannelInfo.
    // Jika entah kenapa null (seharusnya tidak), pakai placeholder aman.
    String authorAvatarUrl = _selectedChannelInfo?.pfpPath ??
        'https://randomuser.me/api/portraits/lego/1.jpg';
    // ----------------------------------------------------------------

    final newPost = FeedPost(
      channel: _selectedChannelInfo!.name,
      subChannel: _selectedSubChannelInfo!.name,
      caption: _captionController.text,
      media: _pickedFile != null ? File(_pickedFile!.path) : null,
      commentsEnabled: _commentsEnabled,
      savesEnabled: _savesEnabled,
    );

    final newSubChannelPost = SubChannelPost(
      id: DateTime.now().millisecondsSinceEpoch,
      // Kita gunakan nama channel sebagai authorName agar konsisten
      authorName: _selectedChannelInfo!.name,
      // GUNAKAN AVATAR URL YANG SUDAH KITA AMBIL TADI
      avatarUrl: authorAvatarUrl,
      channel: newPost.channel,
      subChannel: newPost.subChannel,
      timeAgo: 'Baru saja',
      message: newPost.caption,
      hasImage: newPost.media != null,
      commentsEnabled: newPost.commentsEnabled,
      savesEnabled: newPost.savesEnabled,
      mediaPath: _pickedFile?.path,
      isMediaNetwork: kIsWeb,
    );

    // SIMPAN KE GLOBAL (Seperti sebelumnya)
    final targetChannel = gAllChannels.firstWhere(
      (c) => c.name == newPost.channel,
      orElse: () => gAllChannels[0],
    );

    final targetSubChannel = targetChannel.subChannels.firstWhere(
      (s) => s.name == newPost.subChannel,
      orElse: () => targetChannel.subChannels[0],
    );

    targetSubChannel.posts.insert(0, newSubChannelPost);

    // Navigasi
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => SubChannelPage(
          parentChannelName: newSubChannelPost.channel,
          subChannelName: newSubChannelPost.subChannel,
          newPost: newSubChannelPost,
        ),
      ),
    );
  }

  // ... (Method _pickMedia, _processMedia, _showErrorSnackbar tetap sama) ...
  Future<void> _pickMedia() async {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return SafeArea(
          child: Wrap(
            children: <Widget>[
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Pilih Gambar (Maks 5MB)'),
                onTap: () {
                  Navigator.pop(context);
                  _processMedia(ImageSource.gallery, 'image');
                },
              ),
              ListTile(
                leading: const Icon(Icons.videocam),
                title: const Text('Pilih Video (Maks 20MB)'),
                onTap: () {
                  Navigator.pop(context);
                  _processMedia(ImageSource.gallery, 'video');
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _processMedia(ImageSource source, String type) async {
    try {
      final XFile? file;
      if (type == 'image') {
        file = await _picker.pickImage(source: source);
      } else {
        file = await _picker.pickVideo(source: source);
      }

      if (file == null) return;

      final int fileSize = await file.length();
      final double fileSizeMB = fileSize / (1024 * 1024);

      if (type == 'image' && fileSizeMB > 5) {
        _showErrorSnackbar('Ukuran gambar melebihi 5MB');
        return;
      }
      if (type == 'video' && fileSizeMB > 20) {
        _showErrorSnackbar('Ukuran video melebihi 20MB');
        return;
      }

      setState(() {
        _pickedFile = file;
        _pickedFileType = type;
      });
    } catch (e) {
      _showErrorSnackbar('Gagal mengambil media: $e');
    }
  }

  void _showErrorSnackbar(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // ... (Bagian UI BUILD tetap sama persis seperti sebelumnya) ...
    // Gunakan UI yang sudah Anda miliki, tidak ada perubahan di sini.
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: const Text(
                      'Cancel',
                      style:
                          TextStyle(fontSize: 15, fontWeight: FontWeight.w400),
                    ),
                  ),
                  GestureDetector(
                    onTap: _isPostButtonEnabled ? _submitPost : null,
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 24, vertical: 8),
                      decoration: BoxDecoration(
                        color: _isPostButtonEnabled
                            ? const Color(0xFF3B2C8D)
                            : const Color(0xFFB8B3D4)
                                .withAlpha((255 * 0.5).round()),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Text(
                        'Post',
                        style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                            color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const Divider(height: 1, thickness: 1, color: Color(0xFFE5E5E5)),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // CHANNEL DROPDOWN
                    RichText(
                      text: const TextSpan(
                        style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: Colors.black),
                        children: [
                          TextSpan(text: 'Select Your Channel'),
                          TextSpan(
                              text: '*', style: TextStyle(color: Colors.black))
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                    Container(
                      height: 48,
                      padding: const EdgeInsets.symmetric(horizontal: 14),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: const Color(0xFFE0E0E0)),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<ChannelInfo>(
                          isExpanded: true,
                          hint: const Text('Choose Here',
                              style: TextStyle(
                                  color: Color(0xFFA0A0A0), fontSize: 15)),
                          value: _selectedChannelInfo,
                          icon: const Icon(Icons.keyboard_arrow_down,
                              color: Colors.black),
                          // Filter hanya channel milik sendiri
                          items: gAllChannels
                              .where((c) => c.isOwned)
                              .map((ChannelInfo channel) {
                            return DropdownMenuItem<ChannelInfo>(
                              value: channel,
                              child: Text(channel.name,
                                  style: const TextStyle(fontSize: 15)),
                            );
                          }).toList(),
                          onChanged: (ChannelInfo? newValue) {
                            setState(() {
                              _selectedChannelInfo = newValue;
                              _selectedSubChannelInfo = null;
                            });
                            _validateForm();
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    // SUB-CHANNEL DROPDOWN
                    RichText(
                      text: const TextSpan(
                        style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: Colors.black),
                        children: [
                          TextSpan(text: 'Select Your Sub-Channel'),
                          TextSpan(
                              text: '*', style: TextStyle(color: Colors.black))
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                    Container(
                      height: 48,
                      padding: const EdgeInsets.symmetric(horizontal: 14),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: const Color(0xFFE0E0E0)),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<SubChannelInfo>(
                          isExpanded: true,
                          hint: const Text('Choose Here',
                              style: TextStyle(
                                  color: Color(0xFFA0A0A0), fontSize: 15)),
                          disabledHint: const Text('Select a Channel first',
                              style: TextStyle(color: Colors.grey)),
                          value: _selectedSubChannelInfo,
                          icon: const Icon(Icons.keyboard_arrow_down,
                              color: Colors.black),
                          items: _selectedChannelInfo == null
                              ? []
                              : _selectedChannelInfo!.subChannels
                                  .map((SubChannelInfo sub) {
                                  return DropdownMenuItem<SubChannelInfo>(
                                    value: sub,
                                    child: Text(sub.name,
                                        style: const TextStyle(fontSize: 15)),
                                  );
                                }).toList(),
                          onChanged: _selectedChannelInfo == null
                              ? null
                              : (SubChannelInfo? newValue) {
                                  setState(() {
                                    _selectedSubChannelInfo = newValue;
                                  });
                                  _validateForm();
                                },
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    // CAPTION
                    RichText(
                      text: const TextSpan(
                        style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: Colors.black),
                        children: [
                          TextSpan(text: 'Caption '),
                          TextSpan(
                              text: '(max 1000 character)',
                              style: TextStyle(
                                  fontWeight: FontWeight.w400,
                                  fontSize: 13,
                                  color: Colors.black54))
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                    Container(
                      height: 180,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: const Color(0xFFE0E0E0)),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: TextField(
                        controller: _captionController,
                        maxLength: 1000,
                        maxLines: null,
                        expands: true,
                        textAlignVertical: TextAlignVertical.top,
                        style: const TextStyle(fontSize: 15),
                        decoration: const InputDecoration(
                          hintText: 'Enter your Caption here',
                          hintStyle:
                              TextStyle(color: Color(0xFFA0A0A0), fontSize: 15),
                          counterText: '',
                          contentPadding: EdgeInsets.all(14),
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    // IMAGE PREVIEW (jika ada)
                    if (_pickedFile != null) ...[
                      Text('Media Terpilih: ${_pickedFile!.name}',
                          style: const TextStyle(
                              color: Colors.green,
                              fontWeight: FontWeight.w500)),
                      const SizedBox(height: 12),
                      _pickedFileType == 'image'
                          ? _buildImagePreview()
                          : _buildVideoPreview(),
                    ],
                    const SizedBox(height: 16),
                    // Action Icons
                    Row(
                      children: [
                        _buildIconButton(Icons.image_outlined,
                            onTap: _pickMedia),
                        const SizedBox(width: 20),
                        _buildToggleIconButton(
                            isEnabled: _commentsEnabled,
                            enabledIcon: Icons.chat_bubble_outline,
                            disabledIcon: Icons.comments_disabled_outlined,
                            onTap: () => setState(
                                () => _commentsEnabled = !_commentsEnabled)),
                        const SizedBox(width: 20),
                        _buildToggleIconButton(
                            isEnabled: _savesEnabled,
                            enabledIcon: Icons.bookmark_add_outlined,
                            disabledIcon: Icons.bookmark_remove_outlined,
                            onTap: () =>
                                setState(() => _savesEnabled = !_savesEnabled)),
                      ],
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

  // ... (Helper Widgets: _buildImagePreview, _buildVideoPreview, _buildIconButton, dll SAMA PERSIS) ...
  Widget _buildImagePreview() {
    return Stack(alignment: Alignment.topRight, children: [
      ClipRRect(
          borderRadius: BorderRadius.circular(12.0),
          child: kIsWeb
              ? Image.network(_pickedFile!.path,
                  width: double.infinity, height: 200, fit: BoxFit.cover)
              : Image.file(File(_pickedFile!.path),
                  width: double.infinity, height: 200, fit: BoxFit.cover)),
      GestureDetector(
          onTap: () => setState(() {
                _pickedFile = null;
                _pickedFileType = null;
              }),
          child: Container(
              margin: const EdgeInsets.all(8),
              decoration: const BoxDecoration(
                  color: Colors.black54, shape: BoxShape.circle),
              child: const Icon(Icons.close, color: Colors.white, size: 20)))
    ]);
  }

  Widget _buildVideoPreview() {
    return Container(
        width: double.infinity,
        height: 200,
        decoration: BoxDecoration(
            color: Colors.grey[200], borderRadius: BorderRadius.circular(12.0)),
        child: Center(
            child: Icon(Icons.videocam_outlined,
                color: Colors.grey[600], size: 60)));
  }

  Widget _buildIconButton(IconData icon, {required VoidCallback onTap}) {
    return GestureDetector(
        onTap: onTap,
        child: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
                border: Border.all(color: const Color(0xFFE0E0E0)),
                borderRadius: BorderRadius.circular(8)),
            child: Icon(icon, size: 22, color: Colors.black87)));
  }

  Widget _buildToggleIconButton(
      {required bool isEnabled,
      required IconData enabledIcon,
      required IconData disabledIcon,
      required VoidCallback onTap}) {
    return GestureDetector(
        onTap: onTap,
        child: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
                border: Border.all(color: const Color(0xFFE0E0E0)),
                borderRadius: BorderRadius.circular(8)),
            child: Icon(isEnabled ? enabledIcon : disabledIcon,
                size: 22, color: isEnabled ? Colors.black87 : Colors.grey)));
  }
}
