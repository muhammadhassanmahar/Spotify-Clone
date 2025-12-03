import 'package:flutter/material.dart';

class AlbumViewScreen extends StatelessWidget {
  const AlbumViewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

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
                    // 🎵 ALBUM COVER (RESPONSIVE)
                    Center(
                      child: Container(
                        width: width * 0.65,
                        height: width * 0.65,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
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

                    // 🎤 TITLE
                    GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, "/albumControl");
                      },
                      child: const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16),
                        child: Text(
                          "1 (Remastered)",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 8),

                    // 🧑‍🎤 ARTIST ROW
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Row(
                        children: const [
                          CircleAvatar(
                            radius: 14,
                            backgroundImage: NetworkImage(
                              "https://i.scdn.co/image/ab6761610000e5eb35ddc4c4c596cbcac7e0e5aa",
                            ),
                          ),
                          SizedBox(width: 8),
                          Text(
                            "The Beatles",
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 6),

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

                    // ❤️ ⬇️ ... + PLAY BUTTON
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Row(
                        children: [
                          const Icon(Icons.favorite_border,
                              color: Colors.white, size: 28),
                          const SizedBox(width: 18),

                          const Icon(Icons.download_for_offline_outlined,
                              color: Colors.white, size: 27),
                          const SizedBox(width: 18),

                          const Icon(Icons.more_vert,
                              color: Colors.white, size: 28),
                          const Spacer(),

                          // 🟢 PLAY BUTTON
                          Container(
                            height: 60,
                            width: 60,
                            decoration: const BoxDecoration(
                              color: Color(0xff1DB954),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(Icons.play_arrow,
                                size: 40, color: Colors.black),
                          )
                        ],
                      ),
                    ),

                    const SizedBox(height: 30),

                    // 🎼 TRACK LIST
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: 8,
                      itemBuilder: (context, index) {
                        final bool isSecond = index == 1;

                        return InkWell(
                          onTap: () {
                            // 👉 SECOND SONG OPENS TRACK VIEW SCREEN
                            if (isSecond) {
                              Navigator.pushNamed(context, "/trackView");
                            }
                          },
                          child: ListTile(
                            contentPadding:
                                const EdgeInsets.symmetric(horizontal: 16),

                            leading: isSecond
                                ? const Icon(Icons.graphic_eq,
                                    size: 22, color: Color(0xff1DB954))
                                : const SizedBox(width: 22),

                            title: Text(
                              index == 1
                                  ? "From Me To You – Remastered"
                                  : "Song ${index + 1} (Remastered)",
                              style: const TextStyle(
                                fontWeight: FontWeight.w500,
                                color: Colors.white,
                                fontSize: 16,
                              ),
                            ),

                            subtitle: const Text(
                              "The Beatles",
                              style: TextStyle(
                                color: Colors.white54,
                                fontSize: 13,
                              ),
                            ),

                            trailing: const Icon(Icons.more_vert,
                                color: Colors.white),
                          ),
                        );
                      },
                    ),

                    const SizedBox(height: 90),
                  ],
                ),
              ),
            ),

            // 🎶 MINI PLAYER
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              color: const Color(0xff1F1F1F),
              child: Row(
                children: [
                  // Thumbnail
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

                  // Song
                  const Expanded(
                    child: Text(
                      "From Me To You – Remastered",
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                      ),
                    ),
                  ),

                  const SizedBox(width: 12),

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
