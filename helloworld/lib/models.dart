// lib/models.dart
import 'dart:io';
import 'package:flutter/foundation.dart' show kIsWeb;

// --- PERBAIKAN DI SINI ---
// 1. Hapus 'const'
// 2. Tambahkan List<SubChannelPost> posts
class SubChannelInfo {
  final String name;
  final List<SubChannelPost> posts; // Tempat simpan post

  SubChannelInfo({
    required this.name,
    List<SubChannelPost>? posts, // Opsional di constructor
  }) : posts = posts ?? []; // Default ke list kosong jika null
}
// -------------------------

// Model untuk Channel
class ChannelInfo {
  final String id;
  final String name;
  final String description;
  final String? pfpPath;
  final bool isPfpAsset;
  final bool isPfpNetwork;
  final List<SubChannelInfo> subChannels;

  bool isOwned;
  bool isFollowing;

  ChannelInfo({
    required this.id,
    required this.name,
    required this.description,
    this.pfpPath,
    this.isPfpAsset = false,
    this.isPfpNetwork = false,
    required this.subChannels,
    this.isOwned = true,
    this.isFollowing = true,
  });
}

// Model data untuk Postingan di Sub-Channel
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
  final int id;

  final String? mediaPath;
  final bool isMediaNetwork;
  final bool commentsEnabled;
  final bool savesEnabled;

  const SubChannelPost({
    required this.id,
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
    this.mediaPath,
    this.isMediaNetwork = false,
    this.commentsEnabled = true,
    this.savesEnabled = true,
  });
}

// --- Data Channel Awal ---
List<ChannelInfo> gAllChannels = [
  ChannelInfo(
    id: 'reader_hub',
    name: 'Reader-HUB',
    description:
        'Welcome to Reader-HUB! 🪄 This is the central channel for app announcements, updates, and general community discussions. Get started here!',
    pfpPath: 'assets/images/logo_reader_hub.png',
    isPfpAsset: true,
    isPfpNetwork: false,
    subChannels: [
      // Hapus const di sini
      SubChannelInfo(name: 'General'),
      SubChannelInfo(name: 'Announcements'),
    ],
    isOwned: false,
    isFollowing: true,
  ),
];

List<ChannelInfo> gLastVisitedChannels = [];
