import 'package:flutter/material.dart';
import 'mainpage2.dart'; // Import the MainPage2

class MainPage extends StatelessWidget {
  const MainPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF5E1), // Cream color background
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Circle Avatar with Accessories
            Stack(
              alignment: Alignment.center,
              children: [
                // Left Accessory
                Positioned(
                  left: -40,
                  child: Icon(
                    Icons.wb_sunny_rounded,
                    size: 40,
                    color: Colors.amber.shade400,
                  ),
                ),
                // Right Accessory
                const Positioned(
                  right: -40,
                  child: Icon(
                    Icons.favorite_rounded,
                    size: 40,
                    color: Colors.redAccent,
                  ),
                ),
                // Circular Image
                Container(
                  width: 150,
                  height: 150,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.2),
                        blurRadius: 8,
                        spreadRadius: 2,
                        offset: const Offset(0, 4), // Shadow position
                      ),
                    ],
                    image: const DecorationImage(
                      image: AssetImage('assets/c.png'), // Path to your image
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 30),
            // Welcome Text with Stylish Font
            const Text(
              "Welcome to ChoreMaster",
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: Colors.black,
                fontFamily: 'RobotoSlab', // Modern slab serif font
                letterSpacing: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            // Add Your First Child Text
            const Text(
              "Add your first child.\nFor first-time users:",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w400,
                color: Colors.grey,
                fontFamily: 'OpenSans', // Clean sans-serif font
                letterSpacing: 1.2,
                height: 1.4, // Line height for better readability
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            // Get Started Button
            GestureDetector(
              onTap: () {
                // Navigate to MainPage2
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const MainPage2()),
                );
              },
              child: Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 15, horizontal: 30),
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 219, 131, 90),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.3),
                      spreadRadius: 2,
                      blurRadius: 5,
                    ),
                  ],
                ),
                child: const Text(
                  "Get Started",
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      // Bottom Navigation Bar
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people),
            label: 'Child List',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
        selectedItemColor: const Color.fromARGB(255, 219, 131, 90),
        unselectedItemColor: Colors.grey,
        showUnselectedLabels: true,
      ),
    );
  }
}
