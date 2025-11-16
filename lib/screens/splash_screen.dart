import 'package:flutter/material.dart';
import 'dart:async';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
    super.initState();

    // few seconds ke baad next screen
    Timer(const Duration(seconds: 3), () {
      Navigator.pushReplacementNamed(context, "/start");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black, // spotify style
      body: Center(
        child: Image.asset(
          "assets/images/spotify_logo.png",   // tum yahan apna logo add karoge
          width: 140,
        ),
      ),
    );
  }
}
