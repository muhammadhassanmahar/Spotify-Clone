import 'package:flutter/material.dart';
import 'artists_screen.dart';   // <<--- ADD THIS IMPORT

class SignupScreen4 extends StatefulWidget {
  const SignupScreen4({super.key});

  @override
  State<SignupScreen4> createState() => _SignupScreen4State();
}

class _SignupScreen4State extends State<SignupScreen4> {
  String fullName = "";
  bool newsOffers = false;
  bool marketingData = false;

  @override
  Widget build(BuildContext context) {
    bool isButtonActive = fullName.trim().isNotEmpty;

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
            const SizedBox(height: 15),

            const Text(
              "What's your name?",
              style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 12),

            // TEXTFIELD
            Container(
              decoration: BoxDecoration(
                color: Colors.grey.shade900,
                borderRadius: BorderRadius.circular(6),
              ),
              child: TextField(
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: " ",
                  hintStyle: const TextStyle(color: Colors.white54),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 18),
                  suffixIcon: fullName.isNotEmpty
                      ? const Icon(Icons.check, color: Colors.white)
                      : null,
                ),
                onChanged: (value) {
                  setState(() => fullName = value);
                },
              ),
            ),

            const SizedBox(height: 8),
            const Text(
              "This appears on your Spotify profile",
              style: TextStyle(color: Colors.white54, fontSize: 11),
            ),

            const SizedBox(height: 20),
            Divider(color: Colors.grey.shade800),

            const SizedBox(height: 10),
            const Text(
              'By tapping on “Create account”, you agree to the Spotify Terms of Use.',
              style: TextStyle(color: Colors.white70, fontSize: 13),
            ),

            const SizedBox(height: 12),
            const Text("Terms of Use", style: TextStyle(color: Colors.greenAccent)),

            const SizedBox(height: 10),
            const Text(
              "To learn more about how Spotify collects, uses, shares and protects your personal data, please see the Spotify Privacy Policy.",
              style: TextStyle(color: Colors.white70, fontSize: 13),
            ),

            const SizedBox(height: 12),
            const Text("Privacy Policy", style: TextStyle(color: Colors.greenAccent)),

            const SizedBox(height: 25),

            // Checkbox 1
            Row(
              children: [
                Expanded(
                  child: Text(
                    "Please send me news and offers from Spotify.",
                    style: const TextStyle(color: Colors.white70, fontSize: 13),
                  ),
                ),
                Checkbox(
                  value: newsOffers,
                  onChanged: (v) => setState(() => newsOffers = v!),
                  side: const BorderSide(color: Colors.white54),
                )
              ],
            ),

            const SizedBox(height: 10),

            // Checkbox 2
            Row(
              children: [
                Expanded(
                  child: Text(
                    "Share my registration data with Spotify’s content providers for marketing purposes.",
                    style: const TextStyle(color: Colors.white70, fontSize: 13),
                  ),
                ),
                Checkbox(
                  value: marketingData,
                  onChanged: (v) => setState(() => marketingData = v!),
                  side: const BorderSide(color: Colors.white54),
                )
              ],
            ),

            const SizedBox(height: 50),

            // CREATE ACCOUNT BUTTON
            GestureDetector(
              onTap: isButtonActive
                  ? () {
                      // ★ NAVIGATE TO ARTISTS SCREEN ★
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
                padding: const EdgeInsets.symmetric(vertical: 15),
                decoration: BoxDecoration(
                  color: isButtonActive ? Colors.white : Colors.white24,
                  borderRadius: BorderRadius.circular(25),
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
