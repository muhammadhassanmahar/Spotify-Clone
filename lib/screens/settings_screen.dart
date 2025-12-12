import 'package:flutter/material.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
          _ProfileSection(),
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
      bottomNavigationBar: _BottomNowPlaying(),
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
        Divider(color: Colors.white12, height: 1),
      ],
    );
  }
}

class _ProfileSection extends StatelessWidget {
  const _ProfileSection();

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const CircleAvatar(
        radius: 26,
        backgroundImage: AssetImage('assets/profile.png'),
      ),
      title: const Text(
        'maya',
        style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w600),
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
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Text(
              'Easy • Troye Sivan',
              style: TextStyle(color: Colors.white, fontSize: 14),
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
