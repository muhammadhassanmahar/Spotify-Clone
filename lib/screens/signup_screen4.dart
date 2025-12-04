import 'package:flutter/material.dart';
import 'artists_screen.dart';

class SignupScreen4 extends StatefulWidget {
  const SignupScreen4({super.key});

  @override
  State<SignupScreen4> createState() => _SignupScreen4State();
}

class _SignupScreen4State extends State<SignupScreen4> {
  String fullName = "";
  bool newsOffers = false;
  bool marketingData = false;

  bool get isButtonActive => fullName.trim().isNotEmpty && newsOffers && marketingData;

  @override
  Widget build(BuildContext context) {
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
          "Create account",
          style: TextStyle(color: Colors.white, fontSize: 18),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: ListView(
          children: [
            const SizedBox(height: 20),
            const Text(
              "What's your name?",
              style: TextStyle(
                  color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),

            // NAME TEXTFIELD
            Container(
              decoration: BoxDecoration(
                color: Colors.grey.shade900,
                borderRadius: BorderRadius.circular(6),
              ),
              child: TextField(
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: "Enter your name",
                  hintStyle: const TextStyle(color: Colors.white54),
                  border: InputBorder.none,
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 15, vertical: 18),
                  suffixIcon: fullName.isNotEmpty
                      ? const Icon(Icons.check_circle, color: Colors.greenAccent)
                      : null,
                ),
                onChanged: (value) => setState(() => fullName = value),
              ),
            ),

            const SizedBox(height: 8),
            const Text(
              "This appears on your Spotify profile",
              style: TextStyle(color: Colors.white54, fontSize: 11),
            ),

            const SizedBox(height: 20),
            Divider(color: Colors.grey.shade800),
            const SizedBox(height: 12),

            // TERMS INFO
            const Text(
              'By tapping on “Create account”, you agree to the Spotify Terms of Use.',
              style: TextStyle(color: Colors.white70, fontSize: 13),
            ),
            const SizedBox(height: 6),
            const Text("Terms of Use", style: TextStyle(color: Colors.greenAccent)),
            const SizedBox(height: 6),
            const Text(
              "To learn more about how Spotify collects, uses, shares and protects your personal data, please see the Spotify Privacy Policy.",
              style: TextStyle(color: Colors.white70, fontSize: 13),
            ),
            const SizedBox(height: 6),
            const Text("Privacy Policy", style: TextStyle(color: Colors.greenAccent)),

            const SizedBox(height: 25),

            // CHECKBOX 1 - Circular
            Row(
              children: [
                GestureDetector(
                  onTap: () => setState(() => newsOffers = !newsOffers),
                  child: Container(
                    width: 22,
                    height: 22,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white54),
                      color: newsOffers ? Colors.green : Colors.transparent,
                    ),
                    child: newsOffers
                        ? const Icon(Icons.check, size: 16, color: Colors.white)
                        : null,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    "Please send me news and offers from Spotify.",
                    style: const TextStyle(color: Colors.white70, fontSize: 13),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // CHECKBOX 2 - Circular
            Row(
              children: [
                GestureDetector(
                  onTap: () => setState(() => marketingData = !marketingData),
                  child: Container(
                    width: 22,
                    height: 22,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white54),
                      color: marketingData ? Colors.green : Colors.transparent,
                    ),
                    child: marketingData
                        ? const Icon(Icons.check, size: 16, color: Colors.white)
                        : null,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    "Share my registration data with Spotify’s content providers for marketing purposes.",
                    style: const TextStyle(color: Colors.white70, fontSize: 13),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 40),

            // CREATE ACCOUNT BUTTON
            GestureDetector(
              onTap: isButtonActive
                  ? () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const ArtistsScreen(),
                        ),
                      );
                    }
                  : null,
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 16),
                decoration: BoxDecoration(
                  color: isButtonActive ? Colors.greenAccent : Colors.white24,
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Center(
                  child: Text(
                    "Create an account",
                    style: TextStyle(
                      color: isButtonActive ? Colors.black : Colors.white54,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
