import 'package:flutter/material.dart';

class TrackViewScreen extends StatelessWidget {
  const TrackViewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          children: [
            // ---------- TOP BAR ----------
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: const Icon(Icons.keyboard_arrow_down,
                        size: 32, color: Colors.white),
                  ),
                  const Spacer(),
                  const Text(
                    "Now Playing",
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const Spacer(),
                  const Icon(Icons.more_vert, color: Colors.white)
                ],
              ),
            ),

            const SizedBox(height: 10),

            // ---------- ALBUM ART ----------
            Expanded(
              child: Center(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    width: 330,
                    height: 330,
                    decoration: const BoxDecoration(
                      color: Colors.grey,
                    ),
                    child: Image.network(
                      "https://i.scdn.co/image/ab67616d00001e0208dd3f0bcb7b4f31f27e5f1e",
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 10),

            // ---------- SONG TITLE + ARTIST ----------
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Blinding Lights",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 26,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "The Weeknd",
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.70), // FIXED
                      fontSize: 18,
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
                    max: 260,
                    value: 80,
                    onChanged: (_) {},
                    activeColor: Colors.white,
                    inactiveColor: Colors.white24,
                  ),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      Text(
                        "1:20",
                        style: TextStyle(color: Colors.white54, fontSize: 12),
                      ),
                      Text(
                        "4:20",
                        style: TextStyle(color: Colors.white54, fontSize: 12),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 25),

            // ---------- MUSIC CONTROLS ----------
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
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
                  Icon(Icons.repeat, color: Colors.white70, size: 28),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // ---------- BOTTOM FOOTER ----------
            Padding(
              padding: const EdgeInsets.only(bottom: 30),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(Icons.bluetooth_audio, color: Colors.green),
                  SizedBox(width: 8),
                  Text(
                    "JBL Speaker",
                    style: TextStyle(color: Colors.green),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
