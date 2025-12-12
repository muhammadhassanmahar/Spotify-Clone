import 'package:flutter/material.dart';

class TrackViewScreen extends StatelessWidget {
  const TrackViewScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
                children: [
                  const Icon(Icons.expand_more, color: Colors.white),
                  GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, '/track_screen');
                    },
                    child: const Row(
                      children: [
                        Text('1(Remastered)',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w500)),
                        SizedBox(width: 4),
                        Icon(Icons.more_horiz, color: Colors.white)
                      ],
                    ),
                  ),
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
                    image: const DecorationImage(
                      image: AssetImage('assets/track_cover.png'),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            ),

            // Track Info
            const Text(
              'From Me to You - Mono / Remast',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 4),

            const Text(
              'The Beatles',
              style: TextStyle(color: Colors.white70, fontSize: 14),
            ),

            // Progress Bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: Column(
                children: [
                  Slider(
                    value: 38,
                    max: 118,
                    onChanged: (value) {},
                    activeColor: Colors.white,
                    inactiveColor: Colors.white24,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      Text('0:38', style: TextStyle(color: Colors.white70)),
                      Text('-1:18', style: TextStyle(color: Colors.white70))
                    ],
                  )
                ],
              ),
            ),

            // Controls
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Icon(Icons.shuffle, color: Colors.white),
                  Icon(Icons.skip_previous, color: Colors.white, size: 40),
                  Icon(Icons.pause_circle_filled,
                      color: Colors.white, size: 70),
                  Icon(Icons.skip_next, color: Colors.white, size: 40),
                  Icon(Icons.repeat, color: Colors.green),
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
              ),
            )
          ],
        ),
      ),
    );
  }
}
