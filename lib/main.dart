import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

import 'firebase_options.dart';

import 'screens/album_view_screen.dart';
import 'screens/track_view_screen.dart';
import 'screens/track_screen.dart';
import 'screens/song_share_screen.dart';
import 'screens/library_screen.dart';
import 'screens/user_library_screen.dart';
import 'screens/settings_screen.dart';
import 'screens/splash_screen.dart';
import 'screens/start_screen.dart';
import 'screens/home_screen.dart';
import 'screens/artists_screen.dart';
import 'screens/signup_screen1.dart';
import 'screens/signup_screen2.dart';
import 'screens/signup_screen3.dart';
import 'screens/search_screen.dart';
import 'screens/album_control_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 🔥 FIREBASE INITIALIZE (WEB)
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Spotify Clone',
      theme: ThemeData.dark(),

      initialRoute: "/",

      routes: {
        "/": (context) => const SplashScreen(),
        "/start": (context) => const StartScreen(),

        "/signup1": (context) => const Signup1Screen(),
        "/signup2": (context) => const Signup2Screen(),
        "/signup3": (context) => const Signup3Screen(),

        "/artists": (context) => const ArtistsScreen(),
        "/home": (context) => const HomeScreen(),
        "/search": (context) => const SearchScreen(),

        "/album_view": (context) => const AlbumViewScreen(),
        "/album_control": (context) => const AlbumControlScreen(),

        "/track_view": (context) => const TrackViewScreen(),
        "/track_screen": (context) => const TrackScreen(),

        "/song_share": (context) => const SongShareScreen(),
        "/library": (context) => const LibraryScreen(),
        "/user_library": (context) => const UserLibraryScreen(),
        "/settings": (context) => const SettingsScreen(),
      },
    );
  }
}
