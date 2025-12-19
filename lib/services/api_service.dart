import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class ApiService {
  // ------------------------------------
  // 🔥 AUTO BASE URL
  // ------------------------------------
  static String get baseUrl {
    if (kIsWeb) {
      return "http://localhost:8000";
    }
    if (Platform.isAndroid) {
      return "http://10.0.2.2:8000";
    }
    if (Platform.isIOS) {
      return "http://localhost:8000";
    }
    return "http://192.168.1.100:8000";
  }

  // ------------------------------------
  // 🛡 SAFE JSON LIST PARSER
  // ------------------------------------
  static List<dynamic> _safeList(dynamic body) {
    if (body is List) return body;
    debugPrint("❌ API returned non-list: $body");
    return [];
  }

  // ------------------------------------
  // 🎵 GET ALL SONGS
  // ------------------------------------
  static Future<List<dynamic>> getAllSongs() async {
    try {
      final response = await http.get(Uri.parse("$baseUrl/songs"));

      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        return _safeList(decoded);
      }
    } catch (e) {
      debugPrint("❌ getAllSongs error: $e");
    }
    return [];
  }

  // ------------------------------------
  // 🔍 SEARCH SONGS (FIXED)
  // ------------------------------------
  static Future<List<dynamic>> searchSongs(String query) async {
    if (query.trim().isEmpty) return [];

    try {
      final encodedQuery = Uri.encodeQueryComponent(query);
      final url = Uri.parse("$baseUrl/search/songs?query=$encodedQuery");

      final response = await http.get(url);

      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        return _safeList(decoded);
      }
    } catch (e) {
      debugPrint("❌ searchSongs error: $e");
    }

    return [];
  }

  // ------------------------------------
  // 🎤 GET ALL ARTISTS
  // ------------------------------------
  static Future<List<dynamic>> getAllArtists() async {
    try {
      final response = await http.get(Uri.parse("$baseUrl/artists"));

      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        return _safeList(decoded);
      }
    } catch (e) {
      debugPrint("❌ getAllArtists error: $e");
    }
    return [];
  }

  // ------------------------------------
  // 💚 GET LIKED SONGS
  // ------------------------------------
  static Future<List<dynamic>> getLikedSongs() async {
    try {
      final response = await http.get(Uri.parse("$baseUrl/songs/liked"));

      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        return _safeList(decoded);
      }
    } catch (e) {
      debugPrint("❌ getLikedSongs error: $e");
    }
    return [];
  }

  // ------------------------------------
  // 🎨 GET SELECTED ARTISTS
  // ------------------------------------
  static Future<List<dynamic>> getSelectedArtists() async {
    try {
      final response = await http.get(Uri.parse("$baseUrl/artists/selected"));

      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        return _safeList(decoded);
      }
    } catch (e) {
      debugPrint("❌ getSelectedArtists error: $e");
    }
    return [];
  }

  // ------------------------------------
  // 🔊 FULL AUDIO URL
  // ------------------------------------
  static String audioUrl(String path) {
    if (path.startsWith("http")) return path;
    return "$baseUrl/$path";
  }

  // ------------------------------------
  // 🖼 FULL IMAGE URL
  // ------------------------------------
  static String imageUrl(String path) {
    if (path.startsWith("http")) return path;
    return "$baseUrl/$path";
  }
}
