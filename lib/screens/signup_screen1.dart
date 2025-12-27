import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'signup_screen2.dart';

class Signup1Screen extends StatefulWidget {
  const Signup1Screen({super.key});

  @override
  State<Signup1Screen> createState() => _Signup1ScreenState();
}

class _Signup1ScreenState extends State<Signup1Screen> {
  final TextEditingController emailController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  bool isLoading = false;
  String? errorMessage;

  bool isValidEmail(String email) {
    final regex = RegExp(r'^[\w\.-]+@gmail\.com$');
    return regex.hasMatch(email);
  }

  Future<void> handleNext() async {
    final email = emailController.text.trim();

    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      await _auth.createUserWithEmailAndPassword(
        email: email,
        password: "TempPassword@123", // temporary
      );

      if (!mounted) return;

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => const Signup2Screen(),
        ),
      );
    } on FirebaseAuthException catch (e) {
      if (!mounted) return;

      setState(() {
        if (e.code == 'email-already-in-use') {
          errorMessage = "Email already registered";
        } else if (e.code == 'invalid-email') {
          errorMessage = "Invalid email address";
        } else {
          errorMessage = e.message;
        }
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        errorMessage = "Something went wrong";
      });
    }

    if (!mounted) return;
    setState(() => isLoading = false);
  }

  @override
  void initState() {
    super.initState();
    emailController.addListener(() => setState(() {}));
  }

  @override
  Widget build(BuildContext context) {
    final isButtonEnabled = isValidEmail(emailController.text);

    return Scaffold(
      backgroundColor: Colors.black,
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 30),

            GestureDetector(
              onTap: () => Navigator.pop(context),
              child: const Icon(Icons.arrow_back, color: Colors.white),
            ),

            const SizedBox(height: 40),

            const Center(
              child: Text(
                "Create account",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            const SizedBox(height: 40),

            const Text(
              "What's your email?",
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),

            const SizedBox(height: 10),

            TextField(
              controller: emailController,
              style: const TextStyle(color: Colors.white),
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.grey.shade800,
                hintText: "Email",
                hintStyle: const TextStyle(color: Colors.white54),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(6),
                  borderSide: BorderSide.none,
                ),
              ),
            ),

            if (errorMessage != null) ...[
              const SizedBox(height: 8),
              Text(
                errorMessage!,
                style: const TextStyle(color: Colors.redAccent),
              ),
            ],

            const SizedBox(height: 30),

            Center(
              child: ElevatedButton(
                onPressed:
                    isButtonEnabled && !isLoading ? handleNext : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      isButtonEnabled ? Colors.green : Colors.grey,
                  padding: const EdgeInsets.symmetric(
                      horizontal: 40, vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: isLoading
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Text(
                        "Next",
                        style:
                            TextStyle(color: Colors.white, fontSize: 16),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
