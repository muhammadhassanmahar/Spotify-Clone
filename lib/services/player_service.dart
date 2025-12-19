// File: player_service.dart
import 'package:flutter/foundation.dart';

class User {
  final String id;
  final String name;
  final String email;
  final String? imageUrl; // optional imageUrl

  User({
    required this.id,
    required this.name,
    required this.email,
    this.imageUrl, // optional
  });

  // Factory method to create user from JSON
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] ?? '',
      name: json['name'] ?? 'User',
      email: json['email'] ?? '',
      imageUrl: json['image'], // ✅ removed unnecessary '?? null'
    );
  }
}

class Song {
  final String id;
  final String title;
  final String artist;
  final String? cover;
  final String? audioUrl;

  Song({
    required this.id,
    required this.title,
    required this.artist,
    this.cover,
    this.audioUrl,
  });

  // Factory method to create song from JSON
  factory Song.fromJson(Map<String, dynamic> json) {
    return Song(
      id: json['id'] ?? '',
      title: json['title'] ?? 'Unknown',
      artist: json['artist'] ?? 'Unknown Artist',
      cover: json['cover_image'],
      audioUrl: json['audio_url'],
    );
  }
}

class PlayerService extends ChangeNotifier {
  // Singleton instance
  PlayerService._privateConstructor();
  static final PlayerService _instance = PlayerService._privateConstructor();
  static PlayerService get instance => _instance;

  // Current logged-in user
  static User? currentUser;

  // Currently playing song
  static Song? currentSong;

  // Play a song
  void playSong(Song song) {
    currentSong = song;
    notifyListeners();
  }

  // Pause song
  void pauseSong() {
    currentSong = null;
    notifyListeners();
  }

  // Set user
  void setUser(User user) {
    currentUser = user;
    notifyListeners();
  }

  // Check if song is playing
  bool get isPlaying => currentSong != null;
}
