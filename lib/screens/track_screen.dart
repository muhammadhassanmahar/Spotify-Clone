import 'package:flutter/material.dart';
import '../services/api_service.dart';

class TrackScreen extends StatelessWidget {
  const TrackScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    // 🔥 SAME SONG DATA FROM TRACK VIEW
    final song =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;

    final String title =
        song?['title']?.toString().isNotEmpty == true
            ? song!['title']
            : 'Unknown Song';

    final String artist =
        song?['artist_name']?.toString().isNotEmpty == true
            ? song!['artist_name']
            : 'Unknown Artist';

    final String coverPath = song?['cover_image']?.toString() ?? '';

    final String? coverImage =
        coverPath.isNotEmpty ? ApiService.imageUrl(coverPath) : null;

    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 12),

            // 🎵 ALBUM ART (UI SAME)
            Center(
              child: Container(
                width: size.width * 0.55,
                height: size.width * 0.55,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4),
                  image: DecorationImage(
                    fit: BoxFit.cover,
                    image: coverImage != null
                        ? NetworkImage(coverImage)
                        : const AssetImage(
                            'assets/images/default.png',
                          ) as ImageProvider,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 24),

            // 🎶 SONG TITLE
            Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 4),

            // 👤 ARTIST
            Text(
              artist,
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 16,
              ),
            ),

            const SizedBox(height: 24),

            // ⚙ OPTIONS (UNCHANGED)
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                children: [
                  _option(Icons.favorite_border, 'Like'),
                  _option(Icons.visibility_off_outlined, 'Hide song'),
                  _option(Icons.playlist_add, 'Add to playlist'),
                  _option(Icons.queue_music, 'Add to queue'),

                  // ✅ SHARE → SONG SHARE SCREEN WITH SAME SONG
                  ListTile(
                    leading:
                        const Icon(Icons.share, color: Colors.white70),
                    title: const Text(
                      'Share',
                      style: TextStyle(color: Colors.white),
                    ),
                    onTap: () {
                      Navigator.pushNamed(
                        context,
                        '/song_share',
                        arguments: song, // 🔥 SAME SONG
                      );
                    },
                  ),

                  _option(Icons.radio, 'Go to radio'),
                  _option(Icons.album, 'View album'),
                  _option(Icons.person, 'View artist'),
                  _option(Icons.info_outline, 'Song credits'),
                  _option(Icons.nightlight_round, 'Sleep timer'),
                ],
              ),
            ),

            const SizedBox(height: 8),

            GestureDetector(
              onTap: () => Navigator.pop(context),
              child: const Text(
                'Close',
                style:
                    TextStyle(color: Colors.white70, fontSize: 16),
              ),
            ),

            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }

  static Widget _option(IconData icon, String title) {
    return ListTile(
      leading: Icon(icon, color: Colors.white70),
      title:
          Text(title, style: const TextStyle(color: Colors.white))),
      onTap: () {},
    );
  }
}
