import 'package:flutter/material.dart';
import 'package:spotify/screens/signup_screen4.dart';

class Signup3Screen extends StatefulWidget {
  const Signup3Screen({super.key});

  @override
  State<Signup3Screen> createState() => _Signup3ScreenState();
}

class _Signup3ScreenState extends State<Signup3Screen> {
  final TextEditingController genderController = TextEditingController();

  @override
  void initState() {
    super.initState();
    genderController.addListener(() {
      setState(() {}); // Refresh UI on typing
    });
  }

  @override
  void dispose() {
    genderController.dispose();
    super.dispose();
  }

  bool get isButtonEnabled {
    final gender = genderController.text.toLowerCase().trim();
    return gender == "male" || gender == "female";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: LayoutBuilder(
        builder: (context, constraints) {
          double width = constraints.maxWidth;
          double padding = width > 600 ? width * 0.2 : 20;

          return SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: padding, vertical: 40),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),
                  // Back Button
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: const Icon(Icons.arrow_back, color: Colors.white, size: 28),
                      ),
                    ],
                  ),
                  const SizedBox(height: 30),

                  // Heading
                  const Center(
                    child: Text(
                      "Create account",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),

                  // Subheading
                  const Text(
                    "What's your gender?",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 10),

                  // Gender Input
                  TextField(
                    controller: genderController,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.grey.shade800,
                      hintText: "Male or Female",
                      hintStyle: const TextStyle(color: Colors.white54),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(6),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 18),
                      suffixIcon: isButtonEnabled
                          ? const Icon(Icons.check, color: Colors.greenAccent)
                          : null,
                    ),
                  ),

                  const SizedBox(height: 8),
                  Text(
                    "Type 'Male' or 'Female' to continue.",
                    style: TextStyle(
                      color: isButtonEnabled ? Colors.greenAccent : Colors.white54,
                      fontSize: 12,
                    ),
                  ),

                  const SizedBox(height: 40),

                  // Next Button
                  Center(
                    child: ElevatedButton(
                      onPressed: isButtonEnabled
                          ? () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const SignupScreen4(),
                                ),
                              );
                            }
                          : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: isButtonEnabled ? Colors.green : Colors.grey.shade700,
                        disabledBackgroundColor: Colors.grey.shade700,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      child: const Text(
                        "Next",
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
