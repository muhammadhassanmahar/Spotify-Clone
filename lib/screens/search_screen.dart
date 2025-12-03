import 'package:flutter/material.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});   // ← FIXED (added key)

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
      'image': 'https://i.imgur.com/aR3zJ4U.png'
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

              // Search bar
              Row(
                children: [
                  Expanded(
                    child: Container(
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

                  const SizedBox(width: 10),

                  const Text(
                    'Cancel',
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  )
                ],
              ),

              const SizedBox(height: 25),

              const Text(
                'Recent searches',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 15),

              // Recent list
              Expanded(
                child: ListView.builder(
                  itemCount: recentSearches.length,
                  itemBuilder: (context, index) {
                    final item = recentSearches[index];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 18),
                      child: Row(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(6),
                            child: Image.network(
                              item['image']!,
                              width: 55,
                              height: 55,
                              fit: BoxFit.cover,
                            ),
                          ),

                          const SizedBox(width: 12),

                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item['name']!,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 17,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(height: 3),
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
