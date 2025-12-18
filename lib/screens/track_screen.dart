import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import '../services/api_service.dart';

class TrackScreen extends StatefulWidget {
  const TrackScreen({super.key});

  @override
  State<TrackScreen> createState() => _TrackScreenState();
}

class _TrackScreenState extends State<TrackScreen> {
  late final AudioPlayer _player;

  bool isPlaying = false;
  int currentIndex = 0;
  List<dynamic> songs = [];
  String? currentAudioUrl;
  bool _dataLoaded = false;

  @override
  void initState() {
    super.initState();
    _player = AudioPlayer();

    _player.playerStateStream.listen((state) {
      if (!mounted) return;
      setState(() {
        isPlaying = state.playing;
      });
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_dataLoaded) return;

    final args = ModalRoute.of(context)?.settings.arguments;

    if (args is Map<String, dynamic>) {
      songs = List<dynamic>.from(args['songs'] ?? []);
      currentIndex =
          args['index'] is int ? args['index'] as int : 0;

      if (songs.isNotEmpty && currentIndex < songs.length) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          playSongByIndex(currentIndex);
        });
      }
    }

    _dataLoaded = true;
  }

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }

  Future<void> playSongByIndex(int index) async {
    if (songs.isEmpty || index < 0 || index >= songs.length) return;

    final song = songs[index] as Map<String, dynamic>;
    final audioPath = song['audio']?.toString() ?? '';

    if (audioPath.isEmpty) {
      debugPrint("❌ Audio path missing");
      return;
    }

    final audioUrl = ApiService.audioUrl(audioPath);

    try {
      currentIndex = index;

      if (currentAudioUrl != audioUrl) {
        currentAudioUrl = audioUrl;
        await _player.setUrl(audioUrl);
      }

      await _player.play();
    } catch (e) {
      debugPrint("❌ Play error: $e");
    }
  }

  void togglePlayPause() {
    _player.playing ? _player.pause() : _player.play();
  }

  void playNext() {
    if (currentIndex < songs.length - 1) {
      playSongByIndex(currentIndex + 1);
    }
  }

  void playPrevious() {
    if (currentIndex > 0) {
      playSongByIndex(currentIndex - 1);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (songs.isEmpty || currentIndex >= songs.length) {
      return _error("Song not found");
    }

    final song = songs[currentIndex] as Map<String, dynamic>;

    final String title =
        song['title']?.toString().isNotEmpty == true
            ? song['title'].toString()
            : "Unknown Song";

    final String artist =
        song['artist_name']?.toString().isNotEmpty == true
            ? song['artist_name'].toString()
            : "Unknown Artist";

    final String coverPath =
        song['cover_image']?.toString() ?? '';

    final String? imageUrl =
        coverPath.isNotEmpty ? ApiService.imageUrl(coverPath) : null;

    final w = MediaQuery.of(context).size.width;
    final coverSize = w > 600 ? w * 0.3 : w * 0.55;

    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 12),
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.center,
                  colors: [
                    const Color(0xFF7A2E2E)
                        .withValues(alpha: 0.95),
                    Colors.transparent,
                  ],
                ),
              ),
              child: Column(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(6),
                    child: imageUrl != null
                        ? Image.network(
                            imageUrl,
                            width: coverSize,
                            height: coverSize,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) =>
                                _fallbackCover(coverSize),
                          )
                        : _fallbackCover(coverSize),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 5),
                  Text(
                    artist,
                    style:
                        const TextStyle(color: Colors.white70),
                  ),
                  const SizedBox(height: 22),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.skip_previous,
                            color: Colors.white),
                        iconSize: 40,
                        onPressed: playPrevious,
                      ),
                      GestureDetector(
                        onTap: togglePlayPause,
                        child: Container(
                          padding:
                              const EdgeInsets.all(20),
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white24,
                          ),
                          child: Icon(
                            isPlaying
                                ? Icons.pause
                                : Icons.play_arrow,
                            color: Colors.white,
                            size: 42,
                          ),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.skip_next,
                            color: Colors.white),
                        iconSize: 40,
                        onPressed: playNext,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _fallbackCover(double size) {
    return Container(
      width: size,
      height: size,
      color: Colors.grey,
      child: const Icon(
        Icons.music_note,
        color: Colors.white,
        size: 40,
      ),
    );
  }

  Widget _error(String msg) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Text(
          msg,
          style: const TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}
