import 'package:flutter/material.dart';

class SongShareScreen extends StatelessWidget {
  const SongShareScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // ---------------- GET ARGUMENTS ----------------
    final args = ModalRoute.of(context)!.settings.arguments as Map<String, String>?;

    // Default values agar arguments nahi mile
    final String title = args?['title'] ?? "Unknown Song";
    final String artist = args?['artist'] ?? "Unknown Artist";
    final String image = args?['image'] ??
        "https://i.scdn.co/image/ab67616d00001e0208dd3f0bcb7b4f31f27e5f1e";

    final height = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        children: [
          // Close + Title
          Padding(
            padding: EdgeInsets.only(top: height * 0.06, left: 20, right: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: const Icon(Icons.close, color: Colors.white, size: 28),
                ),
                const Text(
                  "Share",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(width: 30),
              ],
            ),
          ),

          SizedBox(height: height * 0.05),

          // Album Art
          Container(
            height: height * 0.28,
            width: height * 0.28,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              image: DecorationImage(
                image: NetworkImage(image), // AssetImage -> NetworkImage
                fit: BoxFit.cover,
              ),
            ),
          ),

          SizedBox(height: height * 0.03),

          // Song title
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 22,
              height: 1.3,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),

          // Artist
          Text(
            artist,
            style: const TextStyle(
              fontSize: 16,
              color: Colors.grey,
            ),
          ),

          SizedBox(height: height * 0.05),

          // Share Icons Row
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Wrap(
              alignment: WrapAlignment.center,
              spacing: 30,
              runSpacing: 25,
              children: [
                _shareButton(Icons.link, "Copy Link"),
                _shareButton(Icons.share, "WhatsApp"),
                _shareButton(Icons.alternate_email, "Twitter"),
                _shareButton(Icons.message, "Messages"),
                _shareButton(Icons.more_horiz, "More"),
              ],
            ),
          ),

          const Spacer(),

          // Bottom Drag Bar
          Padding(
            padding: const EdgeInsets.only(bottom: 18),
            child: Container(
              height: 5,
              width: 80,
              decoration: BoxDecoration(
                color: Colors.grey.shade600,
                borderRadius: BorderRadius.circular(50),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _shareButton(IconData icon, String label) {
    return Column(
      children: [
        Container(
          height: 56,
          width: 56,
          decoration: const BoxDecoration(
            color: Color(0xFF2C2C2C),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: Colors.white, size: 28),
        ),
        const SizedBox(height: 6),
        Text(
          label,
          style: const TextStyle(color: Colors.white, fontSize: 13),
        ),
      ],
    );
  }
}
