import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import '../services/api_service.dart';

class TrackScreen extends StatefulWidget {
  const TrackScreen({super.key});

  @override
  State<TrackScreen> createState() => _TrackScreenState();
}

class _TrackScreenState extends State<TrackScreen> {
  late AudioPlayer _player;
  bool isPlaying = false;
  String? currentAudioUrl;

  @override
  void initState() {
    super.initState();
    _player = AudioPlayer();

    // Listen to player state to update icon when song ends or pauses
    _player.playerStateStream.listen((state) {
      setState(() {
        isPlaying = state.playing;
      });
    });
  }

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }

  Future<void> playAudio(String url) async {
    try {
      if (currentAudioUrl != url) {
        currentAudioUrl = url;
        await _player.setUrl(url);
      }

      if (_player.playing) {
        await _player.pause();
      } else {
        await _player.play();
      }
    } catch (e, stackTrace) {
      debugPrint("❌ Error playing audio: $e");
      debugPrintStack(stackTrace: stackTrace);
    }
  }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>?;

    final String title = args?['title'] ?? "Unknown Song";
    final String artist = args?['artist_name'] ?? "Unknown Artist";
    final String image = args?['cover_image'] != null
        ? ApiService.imageUrl(args!['cover_image'])
        : "https://i.scdn.co/image/ab67616d00001e0208dd3f0bcb7b4f31f27e5f1e";
    final String audio = args?['audio'] != null
        ? ApiService.audioUrl(args!['audio'])
        : "";

    final mq = MediaQuery.of(context);
    final w = mq.size.width;
    final isWide = w >= 600;
    double coverSize = isWide ? w * 0.30 : w * 0.55;

    return Scaffold(
      backgroundColor: const Color(0xff000000),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 12),

            // ---------- TOP GRADIENT + TITLE ----------
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.center,
                  colors: [
                    const Color(0xFF7A2E2E).withOpacity(0.95),
                    Colors.transparent,
                  ],
                ),
              ),
              child: Column(
                children: [
                  /// Album cover
                  ClipRRect(
                    borderRadius: BorderRadius.circular(6),
                    child: Image.network(
                      image,
                      width: coverSize,
                      height: coverSize,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          width: coverSize,
                          height: coverSize,
                          color: Colors.grey,
                          child: const Icon(Icons.music_note, color: Colors.white, size: 50),
                        );
                      },
                    ),
                  ),

                  const SizedBox(height: 20),

                  /// Title
                  Text(
                    title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                    ),
                    textAlign: TextAlign.center,
                  ),

                  const SizedBox(height: 5),

                  /// Artist
                  Text(
                    artist,
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.70),
                      fontSize: 16,
                    ),
                  ),

                  const SizedBox(height: 18),

                  /// Play / Pause Button
                  GestureDetector(
                    onTap: () {
                      if (audio.isNotEmpty) {
                        playAudio(audio);
                      }
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white24,
                        shape: BoxShape.circle,
                      ),
                      padding: const EdgeInsets.all(20),
                      child: Icon(
                        isPlaying ? Icons.pause : Icons.play_arrow,
                        color: Colors.white,
                        size: 40,
                      ),
                    ),
                  ),

                  const SizedBox(height: 18),
                ],
              ),
            ),

            // ---------- OPTIONS LIST ----------
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: w * 0.06),
                child: Column(
                  children: [
                    option(Icons.favorite_border, "Like"),
                    option(Icons.remove_circle_outline, "Hide song"),
                    option(Icons.playlist_add, "Add to playlist"),
                    option(Icons.queue_music, "Add to queue"),
                    InkWell(
                      onTap: () => Navigator.pushNamed(
                        context,
                        "/song_share",
                        arguments: {
                          "title": title,
                          "artist_name": artist,
                          "cover_image": image,
                        },
                      ),
                      child: option(Icons.share, "Share"),
                    ),
                    option(Icons.radio, "Go to radio"),
                    InkWell(
                      onTap: () => Navigator.pushNamed(context, "/album_view"),
                      child: option(Icons.album_outlined, "View album"),
                    ),
                    InkWell(
                      onTap: () => Navigator.pushNamed(context, "/artists"),
                      child: option(Icons.person_outline, "View artist"),
                    ),
                    option(Icons.info_outline, "Song credits"),
                    option(Icons.nightlight_round, "Sleep timer"),
                    const SizedBox(height: 35),
                    Container(
                      width: 60,
                      height: 4,
                      decoration: BoxDecoration(
                        color: Colors.white24,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                    const SizedBox(height: 18),
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: const Text(
                        "Close",
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 17,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// ---- OPTION ROW ----
  Widget option(IconData icon, String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 14),
      child: Row(
        children: [
          Icon(icon, color: Colors.white70, size: 26),
          const SizedBox(width: 14),
          Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 17,
            ),
          ),
        ],
      ),
    );
  }
}
