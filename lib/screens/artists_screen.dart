import 'package:flutter/material.dart';

class ArtistsScreen extends StatefulWidget {
  const ArtistsScreen({super.key});

  @override
  State<ArtistsScreen> createState() => _ArtistsScreenState();
}

class _ArtistsScreenState extends State<ArtistsScreen> {
  List<Map<String, String>> artists = [
    {"name": "Atif Aslam", "image": "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSr56e1bxG_jBugtpSTYySjcUNoQscfckgjarkH76i6KQsixXXktSZVxRqaeItdRizL4lEXoIYdWZykQNjhfuw66GjeP0Dr2KONyU70B9TI&s=10"},
    {"name": "Talha Anjum", "image": "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSpUYio4hR_n08bjgno7vewfgSis9MvCTP2AP0KNWUB1Ekz5rC5a8MlCOHJIIoXrVmdFMBf7eFyhXPtBtUOvE7tFBdWSue-VBhFMhMmNgF3Hg&s=10"},
    {"name": "Black Pink", "image": "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQRUBzXijfn4BzWwzQdmh4dHXgIbwPstWtyzA1Npt23yt7qJNEUTQmbcO9ZAtDPBOJPJcjSx9w21KKJjJIOLY5KIlNts1JzJWPRmBkMijG_nA&s=10"},
    {"name": "Subh", "image": "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTIILVQH-M1uvVs1SiNoDAVjT9-gaui8oYdTlfqma5X4a14C8dlBUcRdG9OcKcKsux78bEY-jFOPvGQaD94PaUmYzNb_inSWGExroJkTTP5ew&s=10"},
    {"name": "Sonu Nigam", "image": "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQkQI3s6guNDH48JjEw5_nCX1pTq8bSYuxrQyjouzCKSjBjoq3LhDNyQ5pROIv__ai4XNtMM4YgQtlLbpbBnNhTPJ3SKGVN4sE8LjJ1CpXQ&s=10"},
    {"name": "Drake", "image": "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRCXK08MAeSBI5x_PtWgjtOAQQBSPOZaz3I0yQ9qURiY7KIrxaGMjsucAj74wRL4e2MuhBfMIK1tmrc3EwgMFmPYmuDSHqn6WKPdDoXOaaaMA&s=10"},
    {"name": "KK", "image": "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTuaPp8q9b9JEKwCskFDdXsWrXcTplZF6PhHQ&s"},
    {"name": "Anny Marie", "image": "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRiIZdwn1qdRu2_T1_El4T2IINeZvZ_bJV0sQ&s"},
    {"name": "Talwinder", "image": "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTfBumMzb1Nq1NDrpCdtIsZH45Sbxry4ua3rw&s"},
    {"name": "Amrinder Gill", "image": "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcReXYzzIzA_owIlg8YH95JkymGboTjRc8erow&s"},
    {"name": "Bilal Saeed", "image": "https://cdn-images.dzcdn.net/images/artist/3b780adc271cec61f23f38ddffd67ffa/1900x1900-000000-80-0-0.jpg"},
    {"name": "Sidhu Moose Wala", "image": "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQKQw4N0kdAQYkdtyOwmjfkCyVQnnZ7EWxF6A&s"},
  ];

  List<String> selected = [];
  String searchQuery = "";

  @override
  Widget build(BuildContext context) {
    // Filter search results
    List filteredArtists = artists
        .where((a) =>
            a["name"]!.toLowerCase().contains(searchQuery.toLowerCase()))
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
          // SEARCH BAR
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

          // ARTISTS GRID
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                mainAxisSpacing: 18,
                crossAxisSpacing: 18,
                childAspectRatio: 0.75,
              ),
              itemCount: filteredArtists.length,
              itemBuilder: (context, index) {
                String name = filteredArtists[index]["name"];
                String image = filteredArtists[index]["image"];

                bool isSelected = selected.contains(name);

                return GestureDetector(
                  onTap: () {
                    setState(() {
                      if (isSelected) {
                        selected.remove(name);
                      } else {
                        selected.add(name);
                      }
                    });
                  },
                  child: Column(
                    children: [
                      Stack(
                        children: [
                          // Artist Image
                          Container(
                            height: 85,
                            width: 85,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              image: DecorationImage(
                                image: NetworkImage(image),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),

                          // Selection overlay
                          if (isSelected)
                            Container(
                              height: 85,
                              width: 85,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.black.withOpacity(0.5),
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

      // BOTTOM BUTTON (visible only when 3+ selected)
      bottomNavigationBar: selected.length >= 3
          ? Container(
              padding: const EdgeInsets.all(15),
              decoration: const BoxDecoration(color: Colors.black),
              child: GestureDetector(
                onTap: () {
                  // NEXT SCREEN
                  // Navigator.pushNamed(context, '/next');
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  decoration: BoxDecoration(
                    color: Colors.greenAccent,
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: const Center(
                    child: Text(
                      "Continue",
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ),
            )
          : null,
    );
  }
}
