import 'package:flutter/material.dart';
import 'package:spotify/album_view_screen.dart';
import 'package:spotify/track_view_screen.dart';   

import 'screens/splash_screen.dart';
import 'screens/start_screen.dart';
import 'screens/home_screen.dart';
import 'screens/artists_screen.dart';
import 'screens/signup_screen1.dart';
import 'screens/signup_screen2.dart';
import 'screens/signup_screen3.dart';
import 'screens/search_screen.dart';
import 'screens/album_control_screen.dart';

void main() {
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

      // Default route
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
      },
    );
  }
}
