import 'package:flutter/material.dart';
import '../services/player_service.dart'; // ya state provider jahan currentUser & currentSong track ho

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final currentUser = PlayerService.currentUser; // account info
    final currentSong = PlayerService.currentSong; // currently playing song

    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        backgroundColor: const Color(0xFF121212),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Settings',
          style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: ListView(
        children: [
          const SizedBox(height: 16),
          _ProfileSection(username: currentUser?.name ?? "User"),
          const SizedBox(height: 16),
          _settingsTile('Account'),
          _settingsTile('Data Saver'),
          _settingsTile('Languages'),
          _settingsTile('Playback'),
          _settingsTile('Explicit Content'),
          _settingsTile('Devices'),
          _settingsTile('Car'),
          _settingsTile('Social'),
          _settingsTile('Voice Assistant & Apps'),
          _settingsTile('Audio Quality'),
          _settingsTile('Storage'),
          const SizedBox(height: 32),
        ],
      ),
      bottomNavigationBar: currentSong != null ? _BottomNowPlaying(song: currentSong) : null,
    );
  }

  Widget _settingsTile(String title) {
    return Column(
      children: [
        ListTile(
          title: Text(
            title,
            style: const TextStyle(color: Colors.white, fontSize: 16),
          ),
          trailing: const Icon(Icons.chevron_right, color: Colors.white70),
          onTap: () {},
        ),
        const Divider(color: Colors.white12, height: 1),
      ],
    );
  }
}

class _ProfileSection extends StatelessWidget {
  final String username;
  const _ProfileSection({required this.username});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const CircleAvatar(
        radius: 26,
        backgroundImage: AssetImage('assets/profile.png'),
      ),
      title: Text(
        username,
        style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w600),
      ),
      subtitle: const Text(
        'View Profile',
        style: TextStyle(color: Colors.white70, fontSize: 14),
      ),
      trailing: const Icon(Icons.chevron_right, color: Colors.white70),
      onTap: () {},
    );
  }
}

class _BottomNowPlaying extends StatelessWidget {
  final dynamic song;
  const _BottomNowPlaying({required this.song});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      color: const Color(0xFF1E1E1E),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            color: Colors.grey,
            child: song['cover'] != null ? Image.network(song['cover'], fit: BoxFit.cover) : null,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              '${song['title']} • ${song['artist']}',
              style: const TextStyle(color: Colors.white, fontSize: 14),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const Icon(Icons.bluetooth, color: Colors.greenAccent),
          const SizedBox(width: 12),
          IconButton(
            icon: const Icon(Icons.pause, color: Colors.white),
            onPressed: () {},
          ),
        ],
      ),
    );
  }
}
