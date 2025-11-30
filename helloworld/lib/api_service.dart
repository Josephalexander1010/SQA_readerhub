import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart'; // kIsWeb
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'models.dart';

class ApiService {
  // Gunakan 10.0.2.2 untuk Android Emulator, localhost untuk iOS/Web/Windows
  static String get baseUrl {
    if (kIsWeb) {
      return 'http://localhost:8000/api';
    } else if (Platform.isAndroid) {
      return 'http://10.0.2.2:8000/api';
    } else {
      return 'http://localhost:8000/api';
    }
  }

  final _storage = const FlutterSecureStorage();

  Future<String?> getToken() async {
    return await _storage.read(key: 'access_token');
  }

  Future<void> saveToken(String token) async {
    await _storage.write(key: 'access_token', value: token);
  }

  Future<void> logout() async {
    await _storage.delete(key: 'access_token');
  }

  // --- Auth ---

  Future<Map<String, dynamic>> login(String username, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/auth/login/'),
      body: {'username': username, 'password': password},
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      await saveToken(data['access']);
      return data;
    } else {
      throw Exception('Failed to login: ${response.body}');
    }
  }

  Future<Map<String, dynamic>> register(
      String username, String email, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/auth/register/'),
      body: {'username': username, 'email': email, 'password': password},
    );

    if (response.statusCode == 201) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to register: ${response.body}');
    }
  }

  // --- Channels ---

  Future<List<ChannelInfo>> getChannels() async {
    final token = await getToken();
    debugPrint('getChannels Token: $token');
    final response = await http.get(
      Uri.parse('$baseUrl/user/channels/'),
      headers: {'Authorization': 'Bearer $token'},
    );

    debugPrint(
        'getChannels Response: ${response.statusCode} - ${response.body}');

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => ChannelInfo.fromJson(json)).toList();
    } else {
      throw Exception(
          'Failed to load channels: ${response.statusCode} - ${response.body}');
    }
  }

  Future<void> createChannel(
      String name, String description, File? avatar) async {
    final token = await getToken();
    var request =
        http.MultipartRequest('POST', Uri.parse('$baseUrl/channels/'));
    request.headers['Authorization'] = 'Bearer $token';
    request.fields['name'] = name;
    request.fields['description'] = description;

    if (avatar != null) {
      request.files
          .add(await http.MultipartFile.fromPath('avatar', avatar.path));
    }

    final response = await request.send();
    if (response.statusCode != 201) {
      throw Exception('Failed to create channel');
    }
  }

  Future<List<ChannelInfo>> searchChannels(String query) async {
    final token = await getToken();
    final response = await http.get(
      Uri.parse('$baseUrl/channels/?search=$query'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => ChannelInfo.fromJson(json)).toList();
    } else {
      throw Exception('Failed to search channels: ${response.body}');
    }
  }

  // --- Profile ---

  Future<Map<String, dynamic>> getProfile() async {
    final token = await getToken();
    final response = await http.get(
      Uri.parse('$baseUrl/user/profile/'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load profile: ${response.body}');
    }
  }

  Future<Map<String, dynamic>> updateProfile({
    String? name,
    String? username,
    String? about,
    String? phone,
  }) async {
    final token = await getToken();
    final response = await http.patch(
      Uri.parse('$baseUrl/user/profile/'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        if (name != null)
          'first_name':
              name, // Mapping 'name' to 'first_name' for now, or use a separate display_name field if available
        if (username != null) 'username': username,
        if (about != null) 'about': about,
        if (phone != null) 'phone': phone,
      }),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to update profile: ${response.body}');
    }
  }
}
