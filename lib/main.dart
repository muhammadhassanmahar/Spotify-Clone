import 'package:flutter/material.dart';
import 'screens/splash_screen.dart';
import 'screens/start_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Spotify',
      theme: ThemeData.dark(), // dark theme spotify look
      initialRoute: "/",
      routes: {
        "/": (context) => const SplashScreen(),
        "/start": (context) => const StartScreen(),
      },
    );
  }
}
