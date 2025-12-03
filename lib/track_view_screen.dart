import 'package:flutter/material.dart';

class TrackViewScreen extends StatelessWidget {
  const TrackViewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF2C0F0F), // Spotify gradient look
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 10),

            // ---------- TOP BAR ----------
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      // NAVIGATE TO TRACK SCREEN
                      Navigator.pushNamed(context, "/track_screen");
                    },
                    child: const Icon(
                      Icons.keyboard_arrow_down,
                      size: 30,
                      color: Colors.white,
                    ),
                  ),
                  const Spacer(),
                  const Text(
                    "1 (Remastered)",
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const Spacer(),
                  const Icon(Icons.more_vert, color: Colors.white),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // ---------- ALBUM ART ----------
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.network(
                  "https://i.scdn.co/image/ab67616d00001e0208dd3f0bcb7b4f31f27e5f1e",
                  height: 330,
                  fit: BoxFit.cover,
                ),
              ),
            ),

            const SizedBox(height: 25),

            // ---------- SONG TITLE + ARTIST ----------
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "From Me to You - Mono / Remastered",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    "The Beatles",
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.70),
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),

            // ---------- PROGRESS BAR ----------
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 22),
              child: Column(
                children: [
                  Slider(
                    min: 0,
                    max: 200,
                    value: 38,
                    onChanged: (v) {},
                    activeColor: Colors.white,
                    inactiveColor: Colors.white24,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      Text(
                        "0:38",
                        style: TextStyle(color: Colors.white70, fontSize: 12),
                      ),
                      Text(
                        "-1:18",
                        style: TextStyle(color: Colors.white70, fontSize: 12),
                      ),
                    ],
                  )
                ],
              ),
            ),

            const SizedBox(height: 25),

            // ---------- MUSIC CONTROLS ----------
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: const [
                  Icon(Icons.shuffle, color: Colors.white70, size: 28),
                  Icon(Icons.skip_previous_rounded,
                      color: Colors.white, size: 42),
                  Icon(Icons.play_circle_fill_rounded,
                      color: Colors.white, size: 85),
                  Icon(Icons.skip_next_rounded,
                      color: Colors.white, size: 42),
                  Icon(Icons.repeat, color: Colors.green, size: 28),
                ],
              ),
            ),

            const SizedBox(height: 35),

            // ---------- DEVICE & SHARE ----------
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Row(
                children: const [
                  Icon(Icons.bluetooth_audio, color: Colors.green),
                  SizedBox(width: 8),
                  Text("BEATSPILL+",
                      style: TextStyle(color: Colors.green)),
                  Spacer(),
                  Icon(Icons.share, color: Colors.white),
                  SizedBox(width: 20),
                  Icon(Icons.format_list_bulleted, color: Colors.white),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // ---------- LYRICS BUTTON ----------
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 18),
              height: 55,
              decoration: BoxDecoration(
                color: const Color(0xFFB85C2F),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                children: const [
                  SizedBox(width: 15),
                  Text(
                    "Lyrics",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 17,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Spacer(),
                  Text(
                    "MORE",
                    style: TextStyle(color: Colors.white70),
                  ),
                  SizedBox(width: 10),
                  Icon(Icons.keyboard_arrow_up, color: Colors.white70),
                  SizedBox(width: 12),
                ],
              ),
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
