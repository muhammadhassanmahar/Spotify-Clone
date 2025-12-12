import 'package:flutter/material.dart';

class LibraryScreen extends StatelessWidget {
  const LibraryScreen({super.key});

  static const backgroundColor = Color(0xFF121212);
  static const accentText = Colors.white;
  static const mutedText = Color(0xFF9A9A9A);

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context);
    final width = mq.size.width;
    final isLarge = width > 420;
    final sidePadding = isLarge ? 20.0 : 16.0;
    final avatarSize = isLarge ? 48.0 : 40.0;

    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            // Top area: avatar, title, plus
            Padding(
              padding: EdgeInsets.symmetric(horizontal: sidePadding, vertical: 14),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: avatarSize / 2,
                    backgroundImage: NetworkImage(
                        'https://i.pravatar.cc/300'), // replace with your asset or url
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Your Library',
                      style: TextStyle(
                        color: accentText,
                        fontSize: isLarge ? 26 : 22,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.add, color: Colors.white),
                  ),
                ],
              ),
            ),

            // Chips (Playlists, Artists, Albums, Podcasts & shows)
            SizedBox(
              height: 48,
              child: ListView(
                padding: EdgeInsets.symmetric(horizontal: sidePadding),
                scrollDirection: Axis.horizontal,
                children: [
                  _outlineChip('Playlists'),
                  const SizedBox(width: 10),
                  _outlineChip('Artists'),
                  const SizedBox(width: 10),
                  _outlineChip('Albums'),
                  const SizedBox(width: 10),
                  _outlineChip('Podcasts & shows'),
                ],
              ),
            ),

            const SizedBox(height: 8),

            // Recently played header row
            Padding(
              padding: EdgeInsets.symmetric(horizontal: sidePadding),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(Icons.swap_vert, color: mutedText, size: 18),
                      const SizedBox(width: 8),
                      Text('Recently played', style: TextStyle(color: mutedText)),
                    ],
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.grid_view, color: Colors.white),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 8),

            // Content list
            Expanded(
              child: ListView(
                padding: EdgeInsets.symmetric(horizontal: sidePadding),
                children: [
                  _likedSongsTile(isLarge),
                  const SizedBox(height: 12),
                  _simpleItem(
                    title: 'New Episodes',
                    subtitle: 'Updated 2 days ago',
                    imageUrl: 'https://picsum.photos/200/200?1',
                    square: true,
                  ),
                  const SizedBox(height: 12),
                  _simpleItem(
                    title: 'Lolo Zouaï',
                    subtitle: 'Artist',
                    imageUrl: 'https://picsum.photos/200/200?2',
                    square: false,
                  ),
                  const SizedBox(height: 12),
                  _simpleItem(
                    title: 'Lana Del Rey',
                    subtitle: 'Artist',
                    imageUrl: 'https://picsum.photos/200/200?3',
                    square: false,
                  ),
                  const SizedBox(height: 12),
                  _simpleItem(
                    title: 'Front Left',
                    subtitle: 'Playlist • Spotify',
                    imageUrl: 'https://picsum.photos/200/200?4',
                    square: true,
                  ),
                  const SizedBox(height: 12),
                  _simpleItem(
                    title: 'Marvin Gaye',
                    subtitle: 'Artist',
                    imageUrl: 'https://picsum.photos/200/200?5',
                    square: false,
                  ),
                  const SizedBox(height: 12),
                  _simpleItem(
                    title: 'Les',
                    subtitle: 'Song • Childish Gambino',
                    imageUrl: 'https://picsum.photos/200/200?6',
                    square: true,
                  ),
                  const SizedBox(height: 48), // space before bottom nav
                ],
              ),
            ),

            // Bottom navigation imitation
            Container(
              padding: EdgeInsets.symmetric(vertical: 10),
              color: backgroundColor,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _bottomNavItem(Icons.home, 'Home', active: false),
                  _bottomNavItem(Icons.search, 'Search', active: false),
                  _bottomNavItem(Icons.library_music, 'Your Library', active: true),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _outlineChip(String label) {
    return OutlinedButton(
      onPressed: () {},
      style: OutlinedButton.styleFrom(
        foregroundColor: Colors.white,
        side: const BorderSide(color: Color(0xFF2E2E2E)),
        shape: const StadiumBorder(),
        padding: const EdgeInsets.symmetric(horizontal: 16),
      ),
      child: Text(label, style: const TextStyle(fontSize: 14)),
    );
  }

  Widget _likedSongsTile(bool isLarge) {
    return GestureDetector(
      onTap: () {},
      child: Row(
        children: [
          // gradient square with heart
          Container(
            width: isLarge ? 64 : 56,
            height: isLarge ? 64 : 56,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFF6D28D9), Color(0xFF06B6D4)],
              ),
            ),
            child: const Center(
              child: Icon(Icons.favorite, color: Colors.white),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text('Liked Songs', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                SizedBox(height: 6),
                Text('Playlist • 58 songs', style: TextStyle(color: Color(0xFF9A9A9A), fontSize: 13)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _simpleItem({required String title, required String subtitle, required String imageUrl, bool square = false}) {
    return GestureDetector(
      onTap: () {},
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(square ? 8 : 40),
            child: Image.network(
              imageUrl,
              width: 56,
              height: 56,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                const SizedBox(height: 6),
                Text(subtitle, style: const TextStyle(color: Color(0xFF9A9A9A), fontSize: 13)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _bottomNavItem(IconData icon, String label, {bool active = false}) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: active ? Colors.white : const Color(0xFF9A9A9A)),
        const SizedBox(height: 4),
        Text(label, style: TextStyle(color: active ? Colors.white : const Color(0xFF9A9A9A), fontSize: 11)),
      ],
    );
  }
}
