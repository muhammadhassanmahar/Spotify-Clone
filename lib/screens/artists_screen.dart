import 'package:flutter/material.dart';
import 'home_screen.dart';
import '../services/api_service.dart';

/// =======================
/// ARTISTS SCREEN
/// =======================
class ArtistsScreen extends StatefulWidget {
  const ArtistsScreen({super.key});

  @override
  State<ArtistsScreen> createState() => _ArtistsScreenState();
}

class _ArtistsScreenState extends State<ArtistsScreen> {
  /// 🔹 BACKEND ARTISTS
  List<Map<String, dynamic>> artists = [];

  List<String> selected = [];
  String searchQuery = "";
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadArtists();
  }

  /// ----------------------------------
  /// LOAD ARTISTS FROM BACKEND
  /// ----------------------------------
  Future<void> _loadArtists() async {
    try {
      final data = await ApiService.getAllArtists();
      setState(() {
        artists = List<Map<String, dynamic>>.from(data);
        isLoading = false;
      });
    } catch (e) {
      setState(() => isLoading = false);
    }
  }

  /// Move to home if 3 artists selected
  void _checkSelection() {
    if (selected.length >= 3) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const HomeScreen()),
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final filteredArtists = artists
        .where((a) =>
            a["name"].toString().toLowerCase().contains(searchQuery.toLowerCase()))
        .toList();

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Choose 3 or more artists you like.",
          style: TextStyle(color: Colors.white, fontSize: 18),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          /// SEARCH
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.grey.shade900,
                borderRadius: BorderRadius.circular(8),
              ),
              child: TextField(
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  hintText: "Search",
                  hintStyle: TextStyle(color: Colors.white54),
                  border: InputBorder.none,
                  prefixIcon: Icon(Icons.search, color: Colors.white54),
                ),
                onChanged: (value) {
                  setState(() => searchQuery = value);
                },
              ),
            ),
          ),

          const SizedBox(height: 10),

          /// GRID
          Expanded(
            child: isLoading
                ? const Center(
                    child: CircularProgressIndicator(
                      color: Colors.greenAccent,
                    ),
                  )
                : GridView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      mainAxisSpacing: 18,
                      crossAxisSpacing: 18,
                      childAspectRatio: 0.75,
                    ),
                    itemCount: filteredArtists.length,
                    itemBuilder: (context, index) {
                      final artist = filteredArtists[index];
                      final String name = artist["name"];
                      final String imagePath = artist["image"] ?? "";

                      /// ✅ FIX: Ensure only one 'http://localhost:8000/' prefix
                      final String imageUrl = imagePath.isNotEmpty
                          ? ApiService.imageUrl(imagePath)
                          : "http://localhost:8000/uploads/default.png";

                      bool isSelected = selected.contains(name);

                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            isSelected
                                ? selected.remove(name)
                                : selected.add(name);
                            _checkSelection();
                          });
                        },
                        child: Column(
                          children: [
                            Stack(
                              children: [
                                /// Artist Image
                                Container(
                                  height: 85,
                                  width: 85,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    image: DecorationImage(
                                      image: NetworkImage(imageUrl),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),

                                /// Selection Overlay
                                if (isSelected)
                                  Container(
                                    height: 85,
                                    width: 85,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.black.withAlpha(130),
                                    ),
                                    child: const Icon(
                                      Icons.check_circle,
                                      color: Colors.greenAccent,
                                      size: 35,
                                    ),
                                  )
                              ],
                            ),

                            const SizedBox(height: 6),

                            Text(
                              name,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
