import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class ApiService {
  // ------------------------------------
  // 🔥 AUTO BASE URL
  // ------------------------------------
  static String get baseUrl {
    // Web
    if (kIsWeb) {
      return "http://localhost:8000";
    }

    // Android Emulator
    if (Platform.isAndroid) {
      return "http://10.0.2.2:8000";
    }

    // iOS Simulator
    if (Platform.isIOS) {
      return "http://localhost:8000";
    }

    // Real Device (change IP if needed)
    return "http://192.168.1.100:8000";
  }

  // ------------------------------------
  // 🎵 GET ALL SONGS
  // ------------------------------------
  static Future<List<dynamic>> getAllSongs() async {
    final url = Uri.parse("$baseUrl/songs");
    final response = await http.get(url);

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception("Failed to load songs");
    }
  }

  // ------------------------------------
  // 🎵 GET SONG BY ID
  // ------------------------------------
  static Future<Map<String, dynamic>> getSongById(String songId) async {
    final url = Uri.parse("$baseUrl/songs/$songId");
    final response = await http.get(url);

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception("Failed to load song");
    }
  }

  // ------------------------------------
  // 🔍 SEARCH SONGS
  // ------------------------------------
  static Future<List<dynamic>> searchSongs(String query) async {
    if (query.trim().isEmpty) return [];

    final encodedQuery = Uri.encodeQueryComponent(query);
    final url = Uri.parse("$baseUrl/search/songs?query=$encodedQuery");

    final response = await http.get(url);

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception("Search failed");
    }
  }

  // ------------------------------------
  // 🎤 GET ALL ARTISTS
  // ------------------------------------
  static Future<List<dynamic>> getAllArtists() async {
    final url = Uri.parse("$baseUrl/artists");
    final response = await http.get(url);

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception("Failed to load artists");
    }
  }

  // ------------------------------------
  // 🔊 FULL AUDIO URL
  // ------------------------------------
  static String audioUrl(String path) {
    if (path.startsWith("http")) {
      return path; // Already full URL
    }
    return "$baseUrl/$path";
  }

  // ------------------------------------
  // 🖼 FULL IMAGE URL
  // ------------------------------------
  static String imageUrl(String path) {
    if (path.startsWith("http")) {
      return path; // Already full URL
    }
    return "$baseUrl/$path";
  }
}
