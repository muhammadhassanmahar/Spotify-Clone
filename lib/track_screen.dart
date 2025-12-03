import 'package:flutter/material.dart';

class TrackScreen extends StatelessWidget {
  const TrackScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
                    const Color(0xFF7A2E2E).withValues(alpha: .95),
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
                      "https://i.scdn.co/image/ab67616d00001e0208dd3f0bcb7b4f31f27e5f1e",
                      width: coverSize,
                      height: coverSize,
                      fit: BoxFit.cover,
                    ),
                  ),

                  const SizedBox(height: 20),

                  /// Title
                  const Text(
                    "1 (Remastered)",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                    ),
                    textAlign: TextAlign.center,
                  ),

                  const SizedBox(height: 5),

                  /// Artist
                  Text(
                    "The Beatles",
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.70),
                      fontSize: 16,
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
                    option(Icons.share, "Share"),
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
