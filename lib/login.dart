import 'package:flutter/material.dart';
import 'login2.dart'; // Import the second login page

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        color: const Color(0xFFF7F7F7), // Light background color
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Centered and Larger Image
            Image.asset(
              'assets/a.jpeg', // Ensure the image exists
              width: 350, // Adjust width
              height: 350, // Adjust height
              fit: BoxFit.cover, // Ensures the image fits proportionally
            ),
            const SizedBox(height: 40), // Space below the image
            // Title Text
            const Text(
              "ChoreMaster",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 36, // Larger font size
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(255, 8, 50, 117),
                fontFamily: 'Pacifico', // Optional stylish font
                letterSpacing: 2,
              ),
            ),
            const SizedBox(height: 10),
            // Subtitle Text
            const Text(
              "The Golden Rule of Parenting is do unto your children\nas you wish your parents had done unto you!",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14, // Smaller font size for subtitle
                fontWeight: FontWeight.w400,
                color: Color.fromARGB(255, 19, 19, 19),
                fontStyle: FontStyle.italic,
                height: 1.5,
                fontFamily: 'Roboto', // Clean readable font
              ),
            ),
            const SizedBox(height: 30), // Space below the subtitle
            // "Get Started" with Arrow Icon
            GestureDetector(
              onTap: () {
                // Navigate to the Login2 Page
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginPage2()),
                );
              },
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Get Started",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(width: 5), // Spacing between text and icon
                  Icon(
                    Icons.arrow_forward,
                    color: Colors.black,
                    size: 24,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
