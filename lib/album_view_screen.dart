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
            // 🔙 BACK BUTTON
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
                    // 🎵 ALBUM COVER
                    Center(
                      child: Container(
                        width: 260,
                        height: 260,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          image: const DecorationImage(
                            fit: BoxFit.cover,
                            image: NetworkImage(
                              "https://i.scdn.co/image/ab67616d0000b27306ad03c41e6de0569681b89f",
                            ),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    // 🎤 TITLE (TAP → ALBUM CONTROL)
                    GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, "/album_control");
                      },
                      child: const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16),
                        child: Text(
                          "1 (Remastered)",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 28,
                            fontWeight: FontWeight.w900,
                            letterSpacing: -0.3,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 7),

                    // 🧑‍🎤 ARTIST ROW
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Row(
                        children: const [
                          CircleAvatar(
                            radius: 13,
                            backgroundImage: NetworkImage(
                              "https://i.scdn.co/image/ab6761610000e5eb35ddc4c4c596cbcac7e0e5aa",
                            ),
                          ),
                          SizedBox(width: 8),
                          Text(
                            "The Beatles",
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 6),

                    // 📝 ALBUM INFO
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                        "Album • 2000",
                        style: TextStyle(
                          color: Colors.white54,
                          fontSize: 14,
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    // ❤️ ⬇️ ... | PLAY BUTTON
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Row(
                        children: [
                          Icon(Icons.favorite_border,
                              color: Colors.white, size: 27),
                          const SizedBox(width: 18),

                          Icon(Icons.download_for_offline_outlined,
                              color: Colors.white, size: 26),
                          const SizedBox(width: 18),

                          Icon(Icons.more_vert, color: Colors.white, size: 26),
                          const Spacer(),

                          // 🟢 GREEN PLAY BUTTON
                          Container(
                            height: 58,
                            width: 58,
                            decoration: const BoxDecoration(
                              color: Color(0xff1DB954),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(Icons.play_arrow,
                                size: 38, color: Colors.black),
                          )
                        ],
                      ),
                    ),

                    const SizedBox(height: 25),

                    // 🎼 TRACK LIST
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: 8,
                      itemBuilder: (context, index) {
                        return ListTile(
                          contentPadding:
                              const EdgeInsets.symmetric(horizontal: 16),
                          leading: index == 1
                              ? const Icon(Icons.graphic_eq,
                                  color: Color(0xff1DB954), size: 22)
                              : const SizedBox(width: 22),

                          title: Text(
                            "Song ${index + 1} (Remastered)",
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),

                          subtitle: const Text(
                            "The Beatles",
                            style:
                                TextStyle(color: Colors.white54, fontSize: 13),
                          ),

                          trailing:
                              const Icon(Icons.more_vert, color: Colors.white),
                        );
                      },
                    ),

                    const SizedBox(height: 90),
                  ],
                ),
              ),
            ),

            // 🎶 BOTTOM MINI-PLAYER
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              color: const Color(0xff1F1F1F),
              child: Row(
                children: [
                  // Small Album Art
                  Container(
                    height: 48,
                    width: 48,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(6),
                      image: const DecorationImage(
                        fit: BoxFit.cover,
                        image: NetworkImage(
                          "https://i.scdn.co/image/ab67616d0000b27306ad03c41e6de0569681b89f",
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(width: 12),

                  // Song Info
                  const Expanded(
                    child: Text(
                      "From Me To You – Remastered",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),

                  const SizedBox(width: 10),

                  const Icon(Icons.pause, color: Colors.white, size: 30),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
