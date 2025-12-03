import 'package:flutter/material.dart';
import 'screens/splash_screen.dart';
import 'screens/start_screen.dart';
import 'screens/home_screen.dart';
import 'screens/artists_screen.dart';
import 'screens/signup_screen1.dart';
import 'screens/signup_screen2.dart';
import 'screens/signup_screen3.dart';
import 'screens/search_screen.dart';  // ⭐ ADD THIS

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
      },
    );
  }
}
