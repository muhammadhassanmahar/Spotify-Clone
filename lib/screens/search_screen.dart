import 'package:flutter/material.dart';
import '../services/api_service.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<dynamic> results = [];
  bool isLoading = false;

  // 🔍 SEARCH FROM BACKEND
  Future<void> searchSongs(String query) async {
    if (query.trim().isEmpty) {
      if (mounted) setState(() => results = []);
      return;
    }

    if (mounted) setState(() => isLoading = true);

    try {
      final List<dynamic> data =
          await ApiService.searchSongs(query);

      if (mounted) {
        setState(() {
          results = data;
        });
      }
    } catch (e) {
      debugPrint("Search error: $e");
      if (mounted) setState(() => results = []);
    } finally {
      if (mounted) setState(() => isLoading = false);
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

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

              // 🔍 SEARCH BAR
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
                      child: TextField(
                        controller: _searchController,
                        style: const TextStyle(color: Colors.white),
                        onChanged: searchSongs,
                        decoration: const InputDecoration(
                          prefixIcon:
                              Icon(Icons.search, color: Colors.white54),
                          hintText: 'Search',
                          hintStyle: TextStyle(color: Colors.white54),
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: const Text(
                      'Cancel',
                      style:
                          TextStyle(color: Colors.white70, fontSize: 16),
                    ),
                  )
                ],
              ),

              const SizedBox(height: 24),

              const Text(
                'Search results',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                ),
              ),

              const SizedBox(height: 16),

              // 🔄 RESULTS
              Expanded(
                child: isLoading
                    ? const Center(
                        child: CircularProgressIndicator(
                          color: Colors.green,
                        ),
                      )
                    : results.isEmpty
                        ? const Center(
                            child: Text(
                              'No results found',
                              style: TextStyle(
                                color: Colors.white54,
                                fontSize: 16,
                              ),
                            ),
                          )
                        : ListView.builder(
                            physics: const BouncingScrollPhysics(),
                            itemCount: results.length,
                            itemBuilder: (context, index) {
                              final Map<String, dynamic> song =
                                  results[index] as Map<String, dynamic>;

                              final String title =
                                  song['title']?.toString() ??
                                      'Unknown Song';

                              final String artist =
                                  song['artist_name']?.toString() ??
                                      'Unknown Artist';

                              // ✅ SAFE IMAGE URL (IMPORTANT FIX)
                              final String imageUrl =
                                  (song['cover_image'] != null &&
                                          song['cover_image']
                                              .toString()
                                              .isNotEmpty)
                                      ? ApiService.imageUrl(
                                          song['cover_image'].toString())
                                      : '';

                              return GestureDetector(
                                onTap: () {
                                  // 🔥 FIXED: Full song object pass kar rahe
                                  Navigator.pushNamed(
                                    context,
                                    "/track_view",
                                    arguments: song, // ✅ FULL SONG
                                  );
                                },
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 8),
                                  child: Row(
                                    children: [
                                      ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(6),
                                        child: imageUrl.isNotEmpty
                                            ? Image.network(
                                                imageUrl,
                                                width: 55,
                                                height: 55,
                                                fit: BoxFit.cover,
                                                errorBuilder:
                                                    (_, __, ___) =>
                                                        Image.asset(
                                                  'assets/images/default.png',
                                                  width: 55,
                                                  height: 55,
                                                  fit: BoxFit.cover,
                                                ),
                                              )
                                            : Image.asset(
                                                'assets/images/default.png',
                                                width: 55,
                                                height: 55,
                                                fit: BoxFit.cover,
                                              ),
                                      ),
                                      const SizedBox(width: 14),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              title,
                                              maxLines: 1,
                                              overflow:
                                                  TextOverflow.ellipsis,
                                              style: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 17,
                                                fontWeight:
                                                    FontWeight.w600,
                                              ),
                                            ),
                                            const SizedBox(height: 4),
                                            Text(
                                              artist,
                                              maxLines: 1,
                                              overflow:
                                                  TextOverflow.ellipsis,
                                              style: const TextStyle(
                                                color: Colors.white54,
                                                fontSize: 14,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
