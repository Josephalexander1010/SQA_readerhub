
// lib/models.dart
import 'dart:io';
import 'package:flutter/foundation.dart' show kIsWeb;

class SubChannelInfo {
  final String name;
  final List<SubChannelPost> posts;

  SubChannelInfo({
    required this.name,
    List<SubChannelPost>? posts,
  }) : posts = posts ?? [];

  factory SubChannelInfo.fromJson(Map<String, dynamic> json) {
    return SubChannelInfo(
      name: json['name'],
      // Posts will be loaded separately or can be nested if backend supports it
    );
  }
}

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

  factory ChannelInfo.fromJson(Map<String, dynamic> json) {
    var subChannelsList = json['sub_channels'] as List;
    List<SubChannelInfo> subChannels = subChannelsList.map((i) => SubChannelInfo.fromJson(i)).toList();

    return ChannelInfo(
      id: json['id'].toString(),
      name: json['name'],
      description: json['description'],
      pfpPath: json['avatar'], // Backend returns 'avatar' URL
      isPfpNetwork: json['avatar'] != null,
      isPfpAsset: false,
      subChannels: subChannels,
      isOwned: json['is_owned'] ?? false,
      isFollowing: json['is_following'] ?? false,
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

  factory SubChannelPost.fromJson(Map<String, dynamic> json) {
    return SubChannelPost(
      id: json['id'],
      authorName: json['author']['username'],
      avatarUrl: json['author']['profile_picture'] ?? '', // Handle null
      channel: json['channel_name'],
      subChannel: json['sub_channel_name'],
      timeAgo: 'Just now', // Calculate based on created_at
      message: json['content'],
      hasImage: json['media_type'] == 'image',
      mediaPath: json['media'],
      isMediaNetwork: true,
      likes: json['likes_count'],
      liked: json['liked'],
    );
  }
}

List<ChannelInfo> gAllChannels = []; // Empty default, will load from API

List<ChannelInfo> gLastVisitedChannels = [];
