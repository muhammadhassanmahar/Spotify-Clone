import 'package:flutter/material.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});

  final List<Map<String, String>> recentSearches = const [
    {
      'name': 'FKA twigs',
      'type': 'Artist',
      'image': 'https://i.imgur.com/7Qp3g5O.png'
    },
    {
      'name': 'Hozier',
      'type': 'Artist',
      'image': 'https://i.imgur.com/JrPfe8H.png'
    },
    {
      'name': 'Grimes',
      'type': 'Artist',
      'image': 'https://i.imgur.com/K9XWwQX.png'
    },
    {
      'name': '1 (Remastered)',
      'type': 'Album • The Beatles',
      'image': 'https://i.imgur.com/aR3zJ4U.png',
      'navigate': 'album_view'
    },
    {
      'name': 'HAYES',
      'type': 'Artist',
      'image': 'https://i.imgur.com/3z8Q2yM.png'
    },
    {
      'name': 'Led Zeppelin',
      'type': 'Artist',
      'image': 'https://i.imgur.com/Wp8H9kP.png'
    },
    {
      'name': 'Les',
      'type': 'Song • Childish Gambino',
      'image': 'https://i.imgur.com/ga7tP0a.jpeg'
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10),

              // 🔍 Search bar
              Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 45,
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      decoration: BoxDecoration(
                        color: Colors.grey[900],
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const TextField(
                        style: TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.search, color: Colors.white54),
                          hintText: 'Search',
                          hintStyle: TextStyle(color: Colors.white54),
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Text(
                    'Cancel',
                    style: TextStyle(color: Colors.white70, fontSize: 16),
                  )
                ],
              ),

              const SizedBox(height: 28),

              const Text(
                'Recent searches',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                ),
              ),

              const SizedBox(height: 18),

              // LIST
              Expanded(
                child: ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  itemCount: recentSearches.length,
                  itemBuilder: (context, index) {
                    final item = recentSearches[index];

                    return GestureDetector(
                      onTap: () {
                        if (item['navigate'] == 'album_view') {
                          Navigator.pushNamed(context, "/album_view");
                        }
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: Row(
                          children: [
                            // IMAGE
                            ClipRRect(
                              borderRadius: BorderRadius.circular(6),
                              child: Image.network(
                                item['image']!,
                                width: 55,
                                height: 55,
                                fit: BoxFit.cover,
                              ),
                            ),

                            const SizedBox(width: 14),

                            // TEXTS
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  item['name']!,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 17,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  item['type']!,
                                  style: const TextStyle(
                                    color: Colors.white54,
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
