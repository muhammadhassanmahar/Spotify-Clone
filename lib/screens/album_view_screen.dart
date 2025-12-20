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
      final args =
          ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;

      if (args != null) {
        albumData = args;

        /// ✅ FIX 1: album id safe way
        final albumId =
            args['id']?.toString() ?? args['_id']?.toString() ?? '';

        if (albumId.isNotEmpty) {
          _fetchAlbumSongs(albumId);
        } else {
          debugPrint("❌ Album ID missing");
          setState(() => isLoading = false);
        }
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
      debugPrint("❌ Album songs fetch error: $e");
      setState(() {
        albumSongs = [];
      });
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final currentSong = PlayerService.currentSong;

    /// ✅ FIX 2: image url proper
    final albumCover = albumData?['cover_image'] != null &&
            albumData!['cover_image'].toString().isNotEmpty
        ? ApiService.imageUrl(albumData!['cover_image'])
        : "https://i.scdn.co/image/ab67616d0000b27306ad03c41e6de0569681b89f";

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
                  ? const Center(
                      child: CircularProgressIndicator(color: Colors.green))
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
                                  image: NetworkImage(albumCover),
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(height: 20),

                          // 🎤 ALBUM TITLE
                          Padding(
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

                          const SizedBox(height: 20),

                          // ▶ PLAY BUTTON
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Row(
                              children: [
                                const Spacer(),
                                GestureDetector(
                                  onTap: () {
                                    if (albumSongs.isNotEmpty) {
                                      /// ✅ FIX 3: play first song correctly
                                      PlayerService.instance.playSong(
                                        Song.fromJson(albumSongs.first),
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
                                        size: 22,
                                        color: Color(0xff1DB954))
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
                                  /// ✅ FIX 4: correct artist key
                                  song['artist_name'] ??
                                      song['artist'] ??
                                      'Unknown Artist',
                                  style: const TextStyle(
                                    color: Colors.white54,
                                    fontSize: 13,
                                  ),
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
                  Navigator.pushNamed(
                    context,
                    "/track_view",
                    arguments: currentSong,
                  );
                },
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  color: const Color(0xff1F1F1F),
                  child: Row(
                    children: [
                      Container(
                        height: 48,
                        width: 48,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(6),
                          image: DecorationImage(
                            fit: BoxFit.cover,
                            image: NetworkImage(
                              currentSong.cover ??
                                  albumData?['cover_image'] ??
                                  '',
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
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
                      IconButton(
                        icon: const Icon(Icons.pause,
                            color: Colors.white, size: 30),
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
