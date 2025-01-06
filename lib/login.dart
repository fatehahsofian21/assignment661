import 'package:flutter/material.dart';
import 'login2.dart'; // Import your login.dart file here

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background color
          Container(
            color: const Color.fromARGB(255, 11, 41, 65),
          ),
          // Circular decorations
          Positioned(
            top: 50,
            left: -30,
            child: CircleAvatar(
              radius: 60,
              backgroundColor: Colors.blue[200],
              child: const Icon(Icons.computer, size: 40, color: Colors.blue),
            ),
          ),
          Positioned(
            top: 150,
            right: -30,
            child: CircleAvatar(
              radius: 50,
              backgroundColor: Colors.green[200],
              child: const Icon(Icons.book, size: 40, color: Colors.green),
            ),
          ),
          const Positioned(
            bottom: 200,
            left: 10,
            child: CircleAvatar(
              radius: 30,
              backgroundColor: Colors.white,
              child: Icon(Icons.message, size: 25, color: Colors.orange),
            ),
          ),
          Positioned(
            bottom: 160,
            right: 10,
            child: CircleAvatar(
              radius: 30,
              backgroundColor: Colors.purple[100],
              child: const Icon(Icons.phone_android, size: 25, color: Colors.purple),
            ),
          ),
          // Main content
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // App Image
                Image.asset(
                  'assets/a.png', // Replace with your image path
                  height: 170,
                  fit: BoxFit.contain,
                ),
                const SizedBox(height: 10),
                // App Name
                const Text(
                  'LecturerMeet',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 20),
                // Updated Quote
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.0),
                  child: Text(
                    'Successful and unsuccessful people do not vary greatly in their abilities. They vary in their desires to reach their potential.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.white70,
                    ),
                  ),
                ),
                const SizedBox(height: 100),
                // Get Started Button
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) =>const LoginPage2()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 234, 209, 144),
                    minimumSize: const Size(200, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: const Text(
                    'Get Started',
                    style: TextStyle(
                      fontSize: 18,
                      color: Color.fromARGB(255, 30, 26, 26),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

void main() {
  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: SplashScreen(),
  ));
}
