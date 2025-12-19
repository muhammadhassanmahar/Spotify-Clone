import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import '../services/api_service.dart';

class SongShareScreen extends StatelessWidget {
  const SongShareScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final song =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;

    if (song == null) {
      return const Scaffold(
        backgroundColor: Colors.black,
        body: Center(
          child: Text('Song not found',
              style: TextStyle(color: Colors.white)),
        ),
      );
    }

    final title = song['title'] ?? 'Unknown Song';
    final artist = song['artist_name'] ?? 'Unknown Artist';

    final coverPath = song['cover_image']?.toString() ?? '';
    final imageUrl =
        coverPath.isNotEmpty ? ApiService.imageUrl(coverPath) : null;

    // 🔗 SONG LINK (example)
    final songLink = "https://yourapp.com/song/${song['id'] ?? ''}";

    final height = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(
                top: height * 0.06, left: 20, right: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: const Icon(Icons.close, color: Colors.white),
                ),
                const Text("Share",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w600)),
                const SizedBox(width: 30),
              ],
            ),
          ),

          SizedBox(height: height * 0.05),

          Container(
            height: height * 0.28,
            width: height * 0.28,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              image: DecorationImage(
                image: imageUrl != null
                    ? NetworkImage(imageUrl)
                    : const AssetImage('assets/images/default.png')
                        as ImageProvider,
                fit: BoxFit.cover,
              ),
            ),
          ),

          SizedBox(height: height * 0.03),

          Text(title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold)),

          Text(artist,
              style: const TextStyle(color: Colors.grey, fontSize: 16)),

          SizedBox(height: height * 0.05),

          Wrap(
            alignment: WrapAlignment.center,
            spacing: 30,
            runSpacing: 25,
            children: [
              _btn("assets/icons/link.png", "Copy Link",
                  () => SharePlus.instance.share(ShareParams(text: songLink))),
              _btn("assets/icons/whatsapp.png", "WhatsApp",
                  () => _open("https://wa.me/?text=$songLink")),
              _btn("assets/icons/twitter.png", "Twitter",
                  () => _open("https://twitter.com/intent/tweet?text=$songLink")),
              _btn("assets/icons/message.png", "Messages",
                  () => SharePlus.instance.share(ShareParams(text: songLink))),
              _btn("assets/icons/more.png", "More",
                  () => SharePlus.instance.share(ShareParams(text: songLink))),
            ],
          ),

          const Spacer(),

          Padding(
            padding: const EdgeInsets.only(bottom: 18),
            child: Container(
              height: 5,
              width: 80,
              decoration: BoxDecoration(
                color: Colors.grey.shade600,
                borderRadius: BorderRadius.circular(50),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _btn(String assetPath, String label, VoidCallback onTap) {
    return Column(
      children: [
        GestureDetector(
          onTap: onTap,
          child: Container(
            height: 56,
            width: 56,
            decoration: const BoxDecoration(
              color: Color(0xFF2C2C2C),
              shape: BoxShape.circle,
            ),
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Image.asset(assetPath, fit: BoxFit.contain),
            ),
          ),
        ),
        const SizedBox(height: 6),
        Text(label,
            style: const TextStyle(color: Colors.white, fontSize: 13)),
      ],
    );
  }

  static Future<void> _open(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }
}
