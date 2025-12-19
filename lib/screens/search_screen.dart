import 'package:flutter/material.dart';
import '../services/api_service.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<dynamic> songResults = [];
  List<dynamic> albumResults = [];
  bool isLoading = false;

  // 🔍 SEARCH FROM BACKEND
  Future<void> search(String query) async {
    if (query.trim().isEmpty) {
      if (mounted) {
        setState(() {
          songResults = [];
          albumResults = [];
        });
      }
      return;
    }

    if (mounted) {
      setState(() {
        isLoading = true;
      });
    }

    try {
      final List<dynamic> songs = await ApiService.searchSongs(query);
      final List<dynamic> albums = await ApiService.searchAlbums(query);

      if (mounted) {
        setState(() {
          songResults = songs;
          albumResults = albums;
        });
      }
    } catch (e) {
      debugPrint("Search error: $e");
      if (mounted) {
        setState(() {
          songResults = [];
          albumResults = [];
        });
      }
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
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
                        onChanged: search,
                        decoration: const InputDecoration(
                          prefixIcon: Icon(Icons.search, color: Colors.white54),
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
                      style: TextStyle(color: Colors.white70, fontSize: 16),
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
                    : (songResults.isEmpty && albumResults.isEmpty)
                        ? const Center(
                            child: Text(
                              'No results found',
                              style: TextStyle(
                                color: Colors.white54,
                                fontSize: 16,
                              ),
                            ),
                          )
                        : ListView(
                            physics: const BouncingScrollPhysics(),
                            children: [
                              // --- SONGS ---
                              for (var item in songResults)
                                _buildSongItem(item as Map<String, dynamic>),

                              // --- ALBUMS ---
                              for (var item in albumResults)
                                _buildAlbumItem(item as Map<String, dynamic>),
                            ],
                          ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSongItem(Map<String, dynamic> song) {
    final title = song['title']?.toString() ?? 'Unknown Song';
    final artist = song['artist_name']?.toString() ?? 'Unknown Artist';
    final imageUrl = (song['cover_image'] != null &&
            song['cover_image'].toString().isNotEmpty)
        ? ApiService.imageUrl(song['cover_image'].toString())
        : '';

    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(
          context,
          "/track_view",
          arguments: song,
        );
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(6),
              child: imageUrl.isNotEmpty
                  ? Image.network(
                      imageUrl,
                      width: 55,
                      height: 55,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Image.asset(
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
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 17,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    artist,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
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
  }

  Widget _buildAlbumItem(Map<String, dynamic> album) {
    final albumTitle = album['title']?.toString() ?? 'Unknown Album';
    final albumImage = (album['cover_image'] != null &&
            album['cover_image'].toString().isNotEmpty)
        ? ApiService.imageUrl(album['cover_image'].toString())
        : '';

    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(
          context,
          "/album_view",
          arguments: album,
        );
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(6),
              child: albumImage.isNotEmpty
                  ? Image.network(
                      albumImage,
                      width: 55,
                      height: 55,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Image.asset(
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
              child: Text(
                albumTitle,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 17,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
