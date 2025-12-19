import 'package:flutter/material.dart';
import '../services/player_service.dart';
import '../services/api_service.dart';

class AlbumViewScreen extends StatefulWidget {
  const AlbumViewScreen({super.key});

  @override
  State<AlbumViewScreen> createState() => _AlbumViewScreenState();
}

class _AlbumViewScreenState extends State<AlbumViewScreen> {
  List<dynamic> albumSongs = [];
  Map<String, dynamic>? albumData;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
      if (args != null) {
        albumData = args;
        _fetchAlbumSongs(args['id']?.toString() ?? '');
      }
    });
  }

  Future<void> _fetchAlbumSongs(String albumId) async {
    setState(() => isLoading = true);
    try {
      final songs = await ApiService.getAlbumSongs(albumId);
      setState(() {
        albumSongs = songs;
      });
    } catch (e) {
      debugPrint("Album songs fetch error: $e");
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final currentSong = PlayerService.currentSong;

    return Scaffold(
      backgroundColor: const Color(0xff121212),
      body: SafeArea(
        child: Column(
          children: [
            // 🔙 BACK BUTTON
            Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: () => Navigator.pop(context),
                ),
                const Spacer(),
              ],
            ),

            Expanded(
              child: isLoading
                  ? const Center(child: CircularProgressIndicator(color: Colors.green))
                  : SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // 🎵 ALBUM COVER
                          Center(
                            child: Container(
                              width: width * 0.65,
                              height: width * 0.65,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                image: DecorationImage(
                                  fit: BoxFit.cover,
                                  image: NetworkImage(
                                    albumData?['cover_image'] ??
                                        "https://i.scdn.co/image/ab67616d0000b27306ad03c41e6de0569681b89f",
                                  ),
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(height: 20),

                          // 🎤 ALBUM TITLE
                          GestureDetector(
                            onTap: () {
                              Navigator.pushNamed(context, "/album_control");
                            },
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 16),
                              child: Text(
                                albumData?['title'] ?? "Unknown Album",
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 30,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(height: 8),

                          // ARTIST ROW
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Row(
                              children: [
                                CircleAvatar(
                                  radius: 14,
                                  backgroundImage: NetworkImage(
                                    albumData?['artist_image'] ??
                                        "https://i.scdn.co/image/ab6761610000e5eb35ddc4c4c596cbcac7e0e5aa",
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  albumData?['artist'] ?? "Unknown Artist",
                                  style: const TextStyle(
                                    color: Colors.white70,
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 6),

                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Text(
                              "Album • ${albumData?['year'] ?? 'Unknown'}",
                              style: const TextStyle(
                                color: Colors.white54,
                                fontSize: 14,
                              ),
                            ),
                          ),

                          const SizedBox(height: 20),

                          // ❤️ ⬇️ ... + PLAY BUTTON
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Row(
                              children: [
                                const Icon(Icons.favorite_border,
                                    color: Colors.white, size: 28),
                                const SizedBox(width: 18),
                                const Icon(Icons.download_for_offline_outlined,
                                    color: Colors.white, size: 27),
                                const SizedBox(width: 18),
                                GestureDetector(
                                  onTap: () {
                                    Navigator.pushNamed(context, "/album_control");
                                  },
                                  child: const Icon(Icons.more_vert,
                                      color: Colors.white, size: 28),
                                ),
                                const Spacer(),
                                // PLAY BUTTON
                                GestureDetector(
                                  onTap: () {
                                    if (albumSongs.isNotEmpty) {
                                      PlayerService.instance.playSong(
                                        Song.fromJson(albumSongs[0]),
                                      );
                                      setState(() {});
                                    }
                                  },
                                  child: Container(
                                    height: 60,
                                    width: 60,
                                    decoration: const BoxDecoration(
                                      color: Color(0xff1DB954),
                                      shape: BoxShape.circle,
                                    ),
                                    child: const Icon(Icons.play_arrow,
                                        size: 40, color: Colors.black),
                                  ),
                                )
                              ],
                            ),
                          ),

                          const SizedBox(height: 30),

                          // 🎼 TRACK LIST
                          ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: albumSongs.length,
                            itemBuilder: (context, index) {
                              final song = albumSongs[index];
                              final isPlaying = currentSong != null &&
                                  currentSong.id == song['id'];
                              return ListTile(
                                contentPadding:
                                    const EdgeInsets.symmetric(horizontal: 16),
                                leading: isPlaying
                                    ? const Icon(Icons.graphic_eq,
                                        size: 22, color: Color(0xff1DB954))
                                    : const SizedBox(width: 22),
                                title: Text(
                                  song['title'] ?? 'Unknown',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    color: isPlaying
                                        ? const Color(0xff1DB954)
                                        : Colors.white,
                                    fontSize: 16,
                                  ),
                                ),
                                subtitle: Text(
                                  song['artist'] ?? 'Unknown Artist',
                                  style: const TextStyle(
                                    color: Colors.white54,
                                    fontSize: 13,
                                  ),
                                ),
                                trailing: GestureDetector(
                                  onTap: () {
                                    Navigator.pushNamed(context, "/album_control");
                                  },
                                  child: const Icon(Icons.more_vert,
                                      color: Colors.white),
                                ),
                                onTap: () {
                                  PlayerService.instance
                                      .playSong(Song.fromJson(song));
                                  setState(() {});
                                },
                              );
                            },
                          ),

                          const SizedBox(height: 90),
                        ],
                      ),
                    ),
            ),

            // 🎶 MINI PLAYER
            if (currentSong != null)
              GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, "/track_view",
                      arguments: currentSong);
                },
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  color: const Color(0xff1F1F1F),
                  child: Row(
                    children: [
                      // Thumbnail
                      Container(
                        height: 48,
                        width: 48,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(6),
                          image: DecorationImage(
                            fit: BoxFit.cover,
                            image: NetworkImage(
                              currentSong.cover ?? albumData?['cover_image'] ?? '',
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      // Song
                      Expanded(
                        child: Text(
                          currentSong.title,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      IconButton(
                        icon: const Icon(Icons.pause, color: Colors.white, size: 30),
                        onPressed: () {
                          PlayerService.instance.pauseSong();
                          setState(() {});
                        },
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
