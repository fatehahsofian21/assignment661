import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'login.dart'; // Import the login.dart file

void main() async {
  WidgetsFlutterBinding
      .ensureInitialized(); // Ensure proper initialization for Firebase
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
      title: 'ChoreMaster',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const SplashScreen(), // Use SplashScreen as the starting page
    );
  }
}