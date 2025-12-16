import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  // ⚠️ Apna backend URL yahan set karo
  // Android emulator: http://10.0.2.2:8000
  // Real device / web: http://YOUR_IP:8000
  static const String baseUrl = "http://10.0.2.2:8000";

  // ------------------------------------
  // GET ALL SONGS
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
  // GET SONG BY ID
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
  // SEARCH SONGS
  // ------------------------------------
  static Future<List<dynamic>> searchSongs(String query) async {
    final url = Uri.parse("$baseUrl/search?q=$query");

    final response = await http.get(url);

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception("Search failed");
    }
  }

  // ------------------------------------
  // FULL AUDIO URL HELPER
  // ------------------------------------
  static String audioUrl(String path) {
    // backend se jo audio_url aaye usko full URL bana dega
    return "$baseUrl/$path";
  }

  // ------------------------------------
  // COVER IMAGE URL
  // ------------------------------------
  static String imageUrl(String path) {
    return "$baseUrl/$path";
  }
}
