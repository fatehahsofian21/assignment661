import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'login.dart'; // Import the login.dart file
import 'login2.dart'; // Import login2.dart
import 'mainpage.dart'; // Import mainpage.dart
import 'zawawi.dart'; // Import zawawi.dart
import 'atif.dart'; // Import atif.dart
import 'ahmad.dart'; // Import ahmad.dart
import 'success.dart'; // Import success.dart
import 'dashboard.dart'; // Import dashboard.dart

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
      // Set a valid initial route
      initialRoute: '/login',
      routes: {
        '/login': (context) => const SplashScreen(), // Route for login.dart
        '/login2': (context) => const LoginPage2(), // Route for login2.dart
        '/mainpage': (context) =>
            const MainPage(userName: 'User'), // Route for mainpage.dart
        '/zawawi': (context) => const ZawawiPage(), // Route for zawawi.dart
        '/atif': (context) => const AtifPage(), // Route for atif.dart
        '/ahmad': (context) => const AhmadPage(), // Route for ahmad.dart
        '/success': (context) => const SuccessPage(), // Add the success route
        '/dashboard': (context) =>
            const DashboardPage(userName: 'User'), // Add the DashboardPage route
      },
    );
  }
}
