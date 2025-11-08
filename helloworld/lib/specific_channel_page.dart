import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

const _kPurple = Color(0xFF3D2C8D);
const _kRed = Color(0xFFF23F42);
const _kBlack = Color(0xFF000000);
const _kWhite = Color(0xFFFFFFFF);

class SubChannelInfo {
  final String name;
  final int unreadCount;

  const SubChannelInfo({
    required this.name,
    this.unreadCount = 0,
  });

  String get initials {
    final trimmed = name.trim();
    if (trimmed.isEmpty) return '?';
    return trimmed.substring(0, 1).toUpperCase();
  }

  SubChannelInfo copyWith({String? name, int? unreadCount}) {
    return SubChannelInfo(
      name: name ?? this.name,
      unreadCount: unreadCount ?? this.unreadCount,
    );
  }
}

class SpecificChannelPage extends StatefulWidget {
  final String title;
  final String description;
  final String avatarUrl;
  final List<SubChannelInfo> initialSubChannels;

  const SpecificChannelPage({
    super.key,
    required this.title,
    required this.description,
    required this.avatarUrl,
    this.initialSubChannels = const [],
  });

  @override
  State<SpecificChannelPage> createState() => _SpecificChannelPageState();
}

class _SpecificChannelPageState extends State<SpecificChannelPage> {
  final TextEditingController _subChannelController = TextEditingController();
  final String _guidePrefsKey = 'specific_channel_guide_completed';
  final GlobalKey _addButtonKey = GlobalKey();

  late List<SubChannelInfo> _subChannels;

  Offset? _getAddButtonTopLeft() {
    final renderBox =
        _addButtonKey.currentContext?.findRenderObject() as RenderBox?;
    if (renderBox == null) return null;

    final offset = renderBox.localToGlobal(Offset.zero);
    return offset; // langsung top-left
  }

  @override
  void initState() {
    super.initState();
    _subChannels = List.of(widget.initialSubChannels);
    WidgetsBinding.instance.addPostFrameCallback((_) => _maybeShowGuide());
  }

  Future<void> _maybeShowGuide() async {
    final prefs = await SharedPreferences.getInstance();
    final hasCompleted = prefs.getBool(_guidePrefsKey) ?? false;
    if (!hasCompleted && mounted) {
      await _showGuideDialog();
      await prefs.setBool(_guidePrefsKey, true);
    }
  }

  Future<void> _showGuideDialog() {
    final buttonOffset = _getAddButtonTopLeft();
    if (buttonOffset == null) {
      return Future.value();
    }

    return showGeneralDialog(
      context: context,
      barrierDismissible: false,
      barrierLabel: 'Guide',
      barrierColor: Colors.black.withValues(alpha: 0.6),
      transitionDuration: const Duration(milliseconds: 350),
      pageBuilder: (dialogContext, _, __) {
        return Material(
          color: Colors.transparent,
          child: Stack(
            fit: StackFit.expand,
            children: [
              // ⬇️ top-left sama persis dengan tombol plus asli
              Positioned(
                left: buttonOffset.dx,
                top: buttonOffset.dy,
                child: _buildFloatingPlusIndicator(),
              ),

              SafeArea(
                child: Align(
                  alignment: const Alignment(0, -0.15),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(24, 24, 24, 40),
                    child: _buildGuidePopupCard(
                      dialogContext,
                      step: 'Step 1/1',
                      title: 'Create Sub-Channel',
                      content:
                          'To make the Sub-Channel in your own channel, press the (+) button to bring your creativity to feeds.',
                      primaryLabel: 'Done',
                      onPrimary: () => Navigator.of(dialogContext).pop(),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }


  Widget _buildFloatingPlusIndicator() {
    return Container(
      width: 44,
      height: 44,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: _kWhite,
        border: Border.all(color: Colors.black12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.15),
            blurRadius: 10,          // ⬅️ samakan dengan yang bawah
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: const Icon(Icons.add, color: _kBlack),
    );
  }


  @override
  void dispose() {
    _subChannelController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F5F7),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(vertical: 24),
          child: Align(
            alignment: Alignment.topCenter,
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 640),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildTopBar(context),
                    const SizedBox(height: 18),
                    _buildChannelIntroCard(),
                    const SizedBox(height: 28),
                    _buildSubChannelHeader(),
                    const SizedBox(height: 18),
                    _subChannels.isEmpty
                        ? _buildEmptySubChannelState()
                        : ListView.separated(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: _subChannels.length,
                            separatorBuilder: (_, __) =>
                                const SizedBox(height: 16),
                            itemBuilder: (context, index) {
                              final subChannel = _subChannels[index];
                              return _buildSubChannelTile(subChannel);
                            },
                          ),
                    const SizedBox(height: 80),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTopBar(BuildContext context) {
    return Row(
      children: [
        IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: const Icon(Icons.arrow_back, color: _kBlack, size: 26),
        ),
        Expanded(
          child: Text(
            widget.title,
            style: GoogleFonts.poppins(
              fontSize: 24,
              fontWeight: FontWeight.w700,
              color: _kPurple,
            ),
          ),
        ),
        Container(
          padding: const EdgeInsets.all(2),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.08),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: _networkAvatar(widget.avatarUrl, radius: 28),
        ),
      ],
    );
  }

  Widget _buildChannelIntroCard() {
    return Container(
      decoration: BoxDecoration(
        color: _kWhite,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 18,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.description,
            style: GoogleFonts.poppins(
              fontSize: 15,
              height: 1.5,
              color: Colors.grey[800],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSubChannelHeader() {
    return Row(
      children: [
        Text(
          'Sub Channel',
          style: GoogleFonts.poppins(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: _kBlack,
          ),
        ),
        const Spacer(),
        _buildAddSubChannelButton(),
      ],
    );
  }

  Widget _buildAddSubChannelButton() {
    return InkWell(
        key: _addButtonKey, // ⬅️ penting
        onTap: _showCreateSubChannelDialog,
        borderRadius: BorderRadius.circular(32),
        child: Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: _kWhite,
            border: Border.all(color: Colors.black12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.15),
                blurRadius: 10,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: const Icon(Icons.add, color: _kBlack),
        ),
      );
  }


  Widget _buildSubChannelTile(SubChannelInfo subChannel) {
    return Container(
      decoration: BoxDecoration(
        color: _kWhite,
        borderRadius: BorderRadius.circular(42),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 14,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(42),
        child: InkWell(
          borderRadius: BorderRadius.circular(42),
          onTap: () => _openSubChannel(subChannel),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 24,
                  backgroundColor: _kPurple,
                  child: Text(
                    subChannel.initials,
                    style: GoogleFonts.poppins(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: _kWhite,
                    ),
                  ),
                ),
                const SizedBox(width: 18),
                Expanded(
                  child: Text(
                    subChannel.name,
                    style: GoogleFonts.poppins(
                      fontSize: 17,
                      fontWeight: FontWeight.w600,
                      color: _kBlack,
                    ),
                  ),
                ),
                if (subChannel.unreadCount > 0)
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: _kRed,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      '${subChannel.unreadCount}',
                      style: GoogleFonts.poppins(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: _kWhite,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEmptySubChannelState() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
      decoration: BoxDecoration(
        color: _kWhite,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        children: [
          Icon(Icons.forum_outlined, color: Colors.grey[400], size: 48),
          const SizedBox(height: 12),
          Text(
            'No Sub-Channels yet',
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Create one to start a focused discussion.',
            style: GoogleFonts.poppins(
              fontSize: 13,
              color: Colors.grey[500],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGuidePopupCard(
    BuildContext context, {
    required String step,
    required String title,
    required String content,
    required String primaryLabel,
    required VoidCallback onPrimary,
  }) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Material(
      color: Colors.transparent,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 22),
        constraints: BoxConstraints(
          maxWidth: 420,
          maxHeight: screenHeight * 0.7,
        ),
        decoration: BoxDecoration(
          color: _kWhite,
          borderRadius: BorderRadius.circular(18),
        ),
        child: ListView(
          shrinkWrap: true,
          children: [
            Text(
              step,
              style: GoogleFonts.poppins(
                color: _kPurple,
                fontWeight: FontWeight.w600,
                fontSize: 12,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              title,
              style: GoogleFonts.poppins(
                color: _kBlack,
                fontWeight: FontWeight.w700,
                fontSize: 18,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              content,
              style: GoogleFonts.poppins(
                color: Colors.grey[700],
                height: 1.4,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 20),
            Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton(
                onPressed: onPrimary,
                style: ElevatedButton.styleFrom(
                  backgroundColor: _kPurple,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text(
                  primaryLabel,
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }


  void _showCreateSubChannelDialog() {
    _subChannelController.clear();
    String? errorText;

    showGeneralDialog(
      context: context,
      barrierDismissible: false,
      barrierLabel: 'Create Sub-Channel',
      barrierColor: Colors.black.withValues(alpha: 0.6),
      transitionDuration: const Duration(milliseconds: 200),
      pageBuilder: (dialogContext, _, __) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Material(
              color: Colors.transparent,
              child: SafeArea(
                child: Center(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 28,
                      ),
                      decoration: BoxDecoration(
                        color: _kWhite,
                        borderRadius: BorderRadius.circular(28),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Create Sub-Channel',
                            style: GoogleFonts.poppins(
                              fontSize: 22,
                              fontWeight: FontWeight.w700,
                              color: _kPurple,
                            ),
                          ),
                          const SizedBox(height: 18),
                          Text(
                            'Sub-Channel Name* (max 25 characters)',
                            style: GoogleFonts.poppins(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: _kBlack,
                            ),
                          ),
                          const SizedBox(height: 10),
                          TextField(
                            controller: _subChannelController,
                            maxLength: 25,
                            inputFormatters: [
                              LengthLimitingTextInputFormatter(25),
                            ],
                            decoration: InputDecoration(
                              counterText: '',
                              hintText: 'Enter your Sub-Channel Name',
                              hintStyle: GoogleFonts.poppins(
                                color: Colors.grey[500],
                              ),
                              errorText: errorText,
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 18,
                                vertical: 16,
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(18),
                                borderSide:
                                    const BorderSide(color: _kPurple, width: 2),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(18),
                                borderSide: BorderSide(
                                  color: Colors.grey.shade300,
                                  width: 1.2,
                                ),
                              ),
                              errorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(18),
                                borderSide:
                                    const BorderSide(color: _kRed, width: 1.5),
                              ),
                            ),
                            style: GoogleFonts.poppins(fontSize: 15),
                          ),
                          const SizedBox(height: 26),
                          Row(
                            children: [
                              Expanded(
                                child: OutlinedButton(
                                  onPressed: () =>
                                      Navigator.of(dialogContext).pop(),
                                  style: OutlinedButton.styleFrom(
                                    side: const BorderSide(
                                        color: _kRed, width: 1.5),
                                    foregroundColor: _kRed,
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 14,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                  ),
                                  child: Text(
                                    'Cancel',
                                    style: GoogleFonts.poppins(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 18),
                              Expanded(
                                child: ElevatedButton(
                                  onPressed: () {
                                    final value =
                                        _subChannelController.text.trim();
                                    if (value.isEmpty) {
                                      setModalState(
                                        () => errorText =
                                            'Sub-Channel name cannot be empty',
                                      );
                                      return;
                                    }

                                    setState(() {
                                      _subChannels.add(
                                        SubChannelInfo(name: value),
                                      );
                                    });
                                    Navigator.of(dialogContext).pop();
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: _kPurple,
                                    foregroundColor: Colors.white,
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 14,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        'Create',
                                        style: GoogleFonts.poppins(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      const Icon(Icons.arrow_forward, size: 18),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  void _openSubChannel(SubChannelInfo subChannel) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => SubChannelDetailPage(
          parentChannelName: widget.title,
          subChannelName: subChannel.name,
        ),
      ),
    );
  }
}

class SubChannelPost {
  final String authorName;
  final String avatarUrl;
  final String channel;
  final String subChannel;
  final String timeAgo;
  final String message;
  final bool hasImage;
  final int comments;
  final int likes;
  final bool liked;

  const SubChannelPost({
    required this.authorName,
    required this.avatarUrl,
    required this.channel,
    required this.subChannel,
    required this.timeAgo,
    required this.message,
    this.hasImage = false,
    this.comments = 0,
    this.likes = 0,
    this.liked = false,
  });

  static const demoPosts = [
    SubChannelPost(
      authorName: '@Name',
      avatarUrl: 'https://randomuser.me/api/portraits/men/32.jpg',
      channel: 'Reading Club',
      subChannel: 'Subchannel',
      timeAgo: '1m',
      message: 'What\'s happening?',
      comments: 95,
      likes: 1300,
    ),
    SubChannelPost(
      authorName: '@Name',
      avatarUrl: 'https://randomuser.me/api/portraits/men/46.jpg',
      channel: 'Harry Potter',
      subChannel: 'Harry x Hermoine',
      timeAgo: '1m',
      message: 'What\'s happening?',
      liked: true,
      comments: 95,
      likes: 1300,
    ),
    SubChannelPost(
      authorName: '@Name',
      avatarUrl: 'https://randomuser.me/api/portraits/women/44.jpg',
      channel: 'Reading FC',
      subChannel: 'Story Of Greatness',
      timeAgo: '1m',
      message: 'What\'s happening?',
      hasImage: true,
      comments: 95,
      likes: 1300,
    ),
  ];
}

class SubChannelDetailPage extends StatelessWidget {
  final String parentChannelName;
  final String subChannelName;
  final List<SubChannelPost> posts;

  const SubChannelDetailPage({
    super.key,
    required this.parentChannelName,
    required this.subChannelName,
    this.posts = SubChannelPost.demoPosts,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // biar flat kayak X
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(context),
            const Divider(height: 1),
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.only(bottom: 16),
                itemCount: posts.length,
                separatorBuilder: (_, __) => const Divider(height: 1),
                itemBuilder: (context, index) =>
                    _buildPostCard(context, posts[index]),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 8, 12, 8),
      child: Row(
        children: [
          IconButton(
            onPressed: () => Navigator.of(context).pop(),
            icon: const Icon(Icons.arrow_back, color: _kBlack),
          ),
          Expanded(
            child: Text(
              subChannelName,
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                color: _kPurple,
                fontSize: 22,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPostCard(BuildContext context, SubChannelPost post) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // avatar kiri
          _networkAvatar(post.avatarUrl, radius: 22),
          const SizedBox(width: 10),

          // isi utama
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // baris atas: nama, channel, waktu
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      post.authorName,
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: _kBlack,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        '${post.channel} → ${post.subChannel}',
                        style: GoogleFonts.poppins(
                          fontSize: 13,
                          color: Colors.grey[600],
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '· ${post.timeAgo}',
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        color: Colors.grey[500],
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 4),

                // teks postingan
                Text(
                  post.message,
                  style: GoogleFonts.poppins(
                    fontSize: 15,
                    color: Colors.black87,
                  ),
                ),

                // gambar (kalau ada)
                if (post.hasImage) ...[
                  const SizedBox(height: 12),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      height: 200,
                      width: double.infinity,
                      color: Colors.black,
                      child: Center(
                        child: Icon(
                          Icons.image_outlined,
                          color: Colors.white.withValues(alpha: 0.3),
                          size: 48,
                        ),
                      ),
                    ),
                  ),
                ],

                const SizedBox(height: 12),

                // row icon: reply, like, bookmark, share
                Row(
                  children: [
                    _iconStat(
                      icon: Icons.chat_bubble_outline,
                      label: '${post.comments}',
                    ),
                    const SizedBox(width: 24),
                    _iconStat(
                      icon: post.liked ? Icons.favorite : Icons.favorite_border,
                      label: '${(post.likes / 1000).toStringAsFixed(1)}K',
                      active: post.liked,
                    ),
                    const Spacer(),
                    Icon(Icons.bookmark_border,
                        color: Colors.grey[600], size: 20),
                    const SizedBox(width: 16),
                    Icon(Icons.share_outlined,
                        color: Colors.grey[600], size: 20),
                  ],
                ),

              ],
            ),
          ),

          const SizedBox(width: 8),

          // icon kanan atas: hanya muncul kalau post tidak punya image
          if (!post.hasImage) ...[
            const SizedBox(width: 8),
            Icon(
              Icons.no_photography_outlined, // kamera disabled
              size: 20,
              color: const Color(0xFF526470), // abu-abu kebiruan, mirip contohmu
            ),
          ],
        ],
      ),
    );
  }


Widget _iconStat({
  required IconData icon,
  required String label,
  bool active = false,
}) {
  return Row(
    children: [
      Icon(
        icon,
        color: active ? _kRed : Colors.grey.shade600,
        size: 18,
      ),
      if (label.isNotEmpty) ...[
        const SizedBox(width: 4),
        Text(
          label,
          style: GoogleFonts.poppins(
            fontSize: 12,
            color: active ? _kRed : Colors.grey.shade600,
          ),
        ),
      ],
    ],
  );
}
}

Widget _networkAvatar(String imageUrl, {double radius = 24}) {
  return CircleAvatar(
    radius: radius,
    backgroundColor: Colors.grey[300],
    child: ClipOval(
      child: Image.network(
        imageUrl,
        width: radius * 2,
        height: radius * 2,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => Icon(
          Icons.person,
          color: Colors.grey[600],
          size: radius,
        ),
        loadingBuilder: (context, child, progress) {
          if (progress == null) return child;
          return Center(
            child: SizedBox(
              width: radius,
              height: radius,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                value: progress.expectedTotalBytes != null
                    ? progress.cumulativeBytesLoaded /
                        progress.expectedTotalBytes!
                    : null,
              ),
            ),
          );
        },
      ),
    ),
  );
}
