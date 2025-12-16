import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import '../services/api_service.dart';

class TrackViewScreen extends StatefulWidget {
  const TrackViewScreen({super.key});

  @override
  State<TrackViewScreen> createState() => _TrackViewScreenState();
}

class _TrackViewScreenState extends State<TrackViewScreen> {
  final AudioPlayer _player = AudioPlayer();
  bool isPlaying = false;

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final song = ModalRoute.of(context)!.settings.arguments as Map;

    final String title = song['title'] ?? "Unknown Song";
    final String artist = song['artist_name'] ?? "Unknown Artist";
    final String audioUrl = ApiService.audioUrl(song['audio_url']);
    final String coverImage = ApiService.imageUrl(
      song['cover_image'] ?? "uploads/default.png",
    );

    return Scaffold(
      backgroundColor: const Color(0xFF6A1F1A),
      body: SafeArea(
        child: Column(
          children: [
            // Top Bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  BackButton(color: Colors.white),
                  Icon(Icons.more_horiz, color: Colors.white)
                ],
              ),
            ),

            // Album Art
            Padding(
              padding: const EdgeInsets.all(18.0),
              child: AspectRatio(
                aspectRatio: 1,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    image: DecorationImage(
                      image: NetworkImage(coverImage),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            ),

            // Track Info
            Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 4),

            Text(
              artist,
              style: const TextStyle(color: Colors.white70, fontSize: 14),
            ),

            // Progress Bar
            StreamBuilder<Duration>(
              stream: _player.positionStream,
              builder: (context, snapshot) {
                final position = snapshot.data ?? Duration.zero;
                final duration = _player.duration ?? Duration.zero;

                return Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                  child: Column(
                    children: [
                      Slider(
                        value: position.inSeconds.toDouble(),
                        max: duration.inSeconds.toDouble() + 1,
                        onChanged: (value) {
                          _player.seek(Duration(seconds: value.toInt()));
                        },
                        activeColor: Colors.white,
                        inactiveColor: Colors.white24,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            _formatTime(position),
                            style:
                                const TextStyle(color: Colors.white70),
                          ),
                          Text(
                            "-${_formatTime(duration - position)}",
                            style:
                                const TextStyle(color: Colors.white70),
                          )
                        ],
                      )
                    ],
                  ),
                );
              },
            ),

            // Controls
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 32, vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Icon(Icons.shuffle, color: Colors.white),

                  const Icon(Icons.skip_previous,
                      color: Colors.white, size: 40),

                  GestureDetector(
                    onTap: () async {
                      if (isPlaying) {
                        await _player.pause();
                      } else {
                        await _player.setUrl(audioUrl);
                        await _player.play();
                      }
                      setState(() => isPlaying = !isPlaying);
                    },
                    child: Icon(
                      isPlaying
                          ? Icons.pause_circle_filled
                          : Icons.play_circle_filled,
                      color: Colors.white,
                      size: 70,
                    ),
                  ),

                  const Icon(Icons.skip_next,
                      color: Colors.white, size: 40),

                  const Icon(Icons.repeat, color: Colors.green),
                ],
              ),
            ),

            const Spacer(),

            // Lyrics Button
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(color: Color(0xFFDA6A2A)),
              child: const Text(
                'Lyrics',
                style: TextStyle(color: Colors.white, fontSize: 18),
                textAlign: TextAlign.center,
              ),
            )
          ],
        ),
      ),
    );
  }

  String _formatTime(Duration d) {
    final minutes = d.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = d.inSeconds.remainder(60).toString().padLeft(2, '0');
    return "$minutes:$seconds";
  }
}
