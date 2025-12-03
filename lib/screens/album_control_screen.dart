import 'package:flutter/material.dart';

class AlbumControlScreen extends StatelessWidget {
  const AlbumControlScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 20),

              /// ---- Album Cover ----
              Center(
                child: Container(
                  width: 180,
                  height: 180,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    image: const DecorationImage(
                      fit: BoxFit.cover,
                      image: AssetImage("assets/images/album.jpg"), // CHANGE IMAGE
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              /// ---- Album Title ----
              const Text(
                "1(Remastered)",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 5),

              const Text(
                "The Beatles",
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),

              const SizedBox(height: 30),

              /// ---- OPTIONS LIST ----
              buildOption(Icons.favorite_border, "Like", () {
                debugPrint("Liked");
              }),
              buildOption(Icons.person_outline, "View artist", () {
                debugPrint("View Artist");
              }),
              buildOption(Icons.share_outlined, "Share", () {
                debugPrint("Share");
              }),
              buildOption(Icons.favorite_outline, "Like all songs", () {
                debugPrint("Like All Songs");
              }),
              buildOption(Icons.playlist_add_outlined, "Add to playlist", () {
                debugPrint("Add to playlist");
              }),
              buildOption(Icons.queue_music_outlined, "Add to queue", () {
                debugPrint("Add to queue");
              }),
              buildOption(Icons.radio, "Go to radio", () {
                debugPrint("Go to radio");
              }),

              const SizedBox(height: 40),

              /// ---- CLOSE BUTTON ----
              GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: const Padding(
                  padding: EdgeInsets.all(15),
                  child: Text(
                    "Close",
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white70,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  /// ------------- OPTION ROW WIDGET -------------
  Widget buildOption(IconData icon, String text, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 15),
        child: Row(
          children: [
            Icon(icon, size: 28, color: Colors.white70),
            const SizedBox(width: 20),
            Text(
              text,
              style: const TextStyle(fontSize: 18, color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}
