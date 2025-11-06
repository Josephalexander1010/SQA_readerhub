// lib/search_results_page.dart (REVISI TOTAL)
import 'package:flutter/material.dart';

// Model untuk data pencarian
class RecentSearch {
  final int id;
  final String title;
  final String? subtitle;
  final String? imageUrl;
  final bool isVerified;

  RecentSearch({
    required this.id,
    required this.title,
    this.subtitle,
    this.imageUrl,
    this.isVerified = false,
  });
}

class SearchResultsPage extends StatefulWidget {
  const SearchResultsPage({super.key});

  @override
  State<SearchResultsPage> createState() => _SearchResultsPageState();
}

class _SearchResultsPageState extends State<SearchResultsPage> {
  // Controller untuk mengelola teks di search bar
  final TextEditingController _searchController = TextEditingController();

  // Warna utama dari homepage
  static const Color primaryColor = Color(0xFF3B2C8D);

  // Data dummy untuk daftar "Recent"
  List<RecentSearch> _recentSearches = [
    RecentSearch(
      id: 1,
      title: 'Crypto King',
      subtitle: '@CryptoKing4...',
      imageUrl:
          'https://pbs.twimg.com/profile_images/1783515085956718592/Q-8e-GGr_400x400.jpg',
      isVerified: true,
    ),
    RecentSearch(
      id: 2,
      title: 'berita viral',
    ),
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  // Fungsi untuk menampilkan popup konfirmasi hapus
  void _showDeleteConfirmation(BuildContext context, RecentSearch item) {
    showDialog(
      context: context,
      barrierColor: Colors.black.withAlpha((255 * 0.3).round()),
      builder: (BuildContext dialogContext) {
        return Dialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Remove from history?',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  "This search will be removed from your recent history.",
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    color: Colors.grey[700],
                    fontSize: 14,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () {
                        Navigator.pop(dialogContext); // Tutup dialog
                      },
                      child: const Text(
                        "Cancel",
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          color: Colors.grey,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton(
                      onPressed: () {
                        // Logika untuk hapus item
                        setState(() {
                          _recentSearches.removeWhere((s) => s.id == item.id);
                        });
                        Navigator.pop(dialogContext); // Tutup dialog
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            Colors.red, // Kasih warna merah untuk bahaya
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text(
                        "Remove",
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Ubah background ke warna terang
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        // Ubah AppBar jadi terang
        backgroundColor: Colors.white,
        elevation: 1,
        // Ubah ikon kembali jadi gelap
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: TextField(
          controller: _searchController,
          autofocus: true,
          // Ubah style teks jadi gelap
          style: const TextStyle(
            color: Colors.black87,
            fontSize: 18,
            fontFamily: 'Poppins',
          ),
          decoration: InputDecoration(
            // Ganti hint text
            hintText: 'Search ReaderHub',
            hintStyle: const TextStyle(
              color: Colors.grey,
              fontSize: 18,
              fontFamily: 'Poppins',
            ),
            border: InputBorder.none,
            // Tambah tombol X untuk clear teks
            suffixIcon: IconButton(
              icon: const Icon(Icons.close, color: Colors.black54),
              onPressed: () {
                _searchController.clear();
              },
            ),
          ),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Tambah margin atas di sini
          Padding(
            padding:
                const EdgeInsets.only(left: 16, right: 16, top: 20, bottom: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Ganti teks dan warna font
                const Text(
                  'Recent',
                  style: TextStyle(
                    color: primaryColor,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Poppins',
                  ),
                ),
                // Tombol "X" untuk hapus semua
                GestureDetector(
                  onTap: () {
                    setState(() {
                      _recentSearches.clear();
                    });
                  },
                  child: const Icon(Icons.close, color: primaryColor, size: 20),
                ),
              ],
            ),
          ),
          // Tampilkan daftar "Recent"
          Expanded(
            child: ListView.builder(
              itemCount: _recentSearches.length,
              itemBuilder: (context, index) {
                final item = _recentSearches[index];
                return _buildRecentSearchItem(item);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecentSearchItem(RecentSearch item) {
    return GestureDetector(
      // Tambah onLongPress
      onLongPress: () {
        _showDeleteConfirmation(context, item);
      },
      child: ListTile(
        leading: item.imageUrl != null
            ? CircleAvatar(
                radius: 20,
                backgroundImage: NetworkImage(item.imageUrl!),
              )
            // Ganti ikon jadi gelap
            : Icon(Icons.search, color: Colors.grey[600]),
        title: Row(
          children: [
            Text(
              item.title,
              style: const TextStyle(
                // Ganti font jadi gelap
                color: Colors.black87,
                fontWeight: FontWeight.w600,
                fontFamily: 'Poppins',
              ),
            ),
            if (item.isVerified)
              const Padding(
                padding: EdgeInsets.only(left: 4.0),
                child: Icon(Icons.verified, color: Colors.blue, size: 16),
              ),
          ],
        ),
        subtitle: item.subtitle != null
            ? Text(
                item.subtitle!,
                style:
                    const TextStyle(color: Colors.grey, fontFamily: 'Poppins'),
              )
            : null,
        // Ganti ikon jadi gelap
        trailing: Icon(Icons.north_west, color: Colors.grey[600], size: 20),
        onTap: () {
          // Logika saat item pencarian di-tap
        },
      ),
    );
  }
}
