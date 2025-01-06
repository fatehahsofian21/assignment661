import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'login.dart'; // Import the login.dart file
import 'login2.dart'; // Import login2.dart
import 'mainpage.dart'; // Import mainpage.dart
import 'zawawi.dart'; // Import zawawi.dart
import 'atif.dart'; // Import atif.dart
import 'ahmad.dart'; // Import ahmad.dart

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Ensure proper initialization for Firebase
  try {
    await Firebase.initializeApp(); // Initialize Firebase
  } catch (e) {
    debugPrint("Error initializing Firebase: $e");
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, // Remove the debug banner
      title: 'LecturerMeet', // Update app name here if needed
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      initialRoute: '/login', // Set a valid initial route
      routes: {
        '/login': (context) => const SplashScreen(), // Login page route
        '/login2': (context) => const LoginPage2(), // Add login2 route
        '/mainpage': (context) => const MainPage(userName: 'User'), // Add mainpage route
        '/zawawi': (context) => const ZawawiPage(), // Route for zawawi.dart
        '/atif': (context) => const AtifPage(), // Route for atif.dart
        '/ahmad': (context) => const AhmadPage(), // Route for ahmad.dart
      },
      onUnknownRoute: (settings) => MaterialPageRoute(
        builder: (context) => const Scaffold(
          body: Center(child: Text("Page Not Found")),
        ),
      ),
    );
  }
}
