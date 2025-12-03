import 'package:flutter/material.dart';

class AlbumViewScreen extends StatelessWidget {
  const AlbumViewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff121212),
      body: SafeArea(
        child: Column(
          children: [

            // 🔙 Back Button
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
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    // 🎵 Large Album Art
                    Center(
                      child: Container(
                        width: 260,
                        height: 260,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          image: const DecorationImage(
                            image: NetworkImage(
                              "https://i.scdn.co/image/ab67616d0000b27306ad03c41e6de0569681b89f",
                            ),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    // 🎤 Album Title
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                        "1 (Remastered)",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),

                    const SizedBox(height: 8),

                    // 🧑‍🎤 Artist Name
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Row(
                        children: const [
                          CircleAvatar(
                            radius: 13,
                            backgroundImage: NetworkImage(
                                "https://i.scdn.co/image/ab6761610000e5eb35ddc4c4c596cbcac7e0e5aa"),
                          ),
                          SizedBox(width: 8),
                          Text(
                            "The Beatles",
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 15,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 6),

                    // 📝 Album Info
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                        "Album • 2000",
                        style: TextStyle(color: Colors.white54),
                      ),
                    ),

                    const SizedBox(height: 15),

                    // ❤️ ⬇️ ...   +   🎵 Green Play Button
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Row(
                        children: [
                          Icon(Icons.favorite_border, color: Colors.white, size: 28),
                          const SizedBox(width: 16),
                          Icon(Icons.download_for_offline, color: Colors.white, size: 28),
                          const SizedBox(width: 16),
                          Icon(Icons.more_vert, color: Colors.white, size: 28),
                          const Spacer(),

                          // 🟢 BIG PLAY BUTTON
                          Container(
                            height: 60,
                            width: 60,
                            decoration: const BoxDecoration(
                              color: Colors.green,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(Icons.play_arrow, size: 40),
                          )
                        ],
                      ),
                    ),

                    const SizedBox(height: 25),

                    // 🎼 TRACK LIST
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: 5,
                      itemBuilder: (context, index) {
                        return ListTile(
                          leading: const Icon(Icons.graphic_eq, color: Colors.green, size: 20),
                          title: Text(
                            "Track ${index + 1} - Remastered",
                            style: const TextStyle(color: Colors.white, fontSize: 15),
                          ),
                          subtitle: const Text(
                            "The Beatles",
                            style: TextStyle(color: Colors.white54, fontSize: 13),
                          ),
                          trailing: const Icon(Icons.more_vert, color: Colors.white),
                        );
                      },
                    ),

                    const SizedBox(height: 80),
                  ],
                ),
              ),
            ),

            // 🎶 MINI PLAYER (BOTTOM)
            Container(
              padding: const EdgeInsets.all(10),
              color: const Color(0xff1F1F1F),
              child: Row(
                children: [
                  // Small Album Art
                  Container(
                    height: 50,
                    width: 50,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(6),
                      image: const DecorationImage(
                        image: NetworkImage(
                          "https://i.scdn.co/image/ab67616d0000b27306ad03c41e6de0569681b89f",
                        ),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),

                  const SizedBox(width: 10),

                  // Song Info
                  const Expanded(
                    child: Text(
                      "From Me To You – Remastered",
                      style: TextStyle(color: Colors.white, fontSize: 15),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),

                  const SizedBox(width: 10),

                  // Play / Pause Button
                  const Icon(Icons.pause, color: Colors.white, size: 28),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
