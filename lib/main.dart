import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart'; // For permission handling
import 'login2.dart';
import 'mainpage.dart';
import 'mainpageL.dart'; // Import MainPageL for lecturers
import 'dashboard.dart';
import 'profileS.dart'; // Add ProfileSPage import
import 'zawawi.dart'; // Import ZawawiPage

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Firebase.initializeApp(); // Initialize Firebase
    await requestLocationPermission(); // Request location permission
  } catch (e) {
    debugPrint("Error initializing Firebase or permissions: $e");
  }
  runApp(const MyApp());
}

/// Request Location Permission
Future<void> requestLocationPermission() async {
  if (await Permission.location.request().isGranted) {
    debugPrint("Location permission granted.");
  } else if (await Permission.location.isPermanentlyDenied) {
    debugPrint("Location permission permanently denied. Open settings.");
    await openAppSettings();
  } else {
    debugPrint("Location permission denied.");
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'LecturerMeet',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const AuthWrapper(), // Add AuthWrapper as the initial screen
      routes: {
        '/login2': (context) => const LoginPage2(),
        '/mainpage': (context) => MainPage(
              userName: ModalRoute.of(context)?.settings.arguments as String? ??
                  'User', // Dynamically fetch userName
            ),
        '/mainpageL': (context) => MainPageL(
              email: ModalRoute.of(context)?.settings.arguments as String? ??
                  'example@domain.com', // Dynamically fetch email
            ),
        '/dashboard': (context) {
          final args = ModalRoute.of(context)?.settings.arguments as String?;
          return DashboardPage(
            userName: args ?? 'User', // Use the argument or fallback to 'User'
          );
        },
        '/myaccount': (context) => const ProfileSPage(), // Route for My Account
        '/zawawi': (context) => const ZawawiPage(), // Define ZawawiPage route
      },
    );
  }
}

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(), // Listen to auth state
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
              child: CircularProgressIndicator()); // Loading state
        } else if (snapshot.hasData) {
          // User is logged in
          final user = FirebaseAuth.instance.currentUser;
          final email = user?.email ?? '';
          if (email.contains('@lecturer.uitm.edu.my')) {
            return MainPageL(email: email); // Redirect to Lecturer MainPage
          } else if (email.contains('@student.uitm.edu.my')) {
            final userName = email.split('@')[0];
            return DashboardPage(
                userName: userName); // Redirect to Student Dashboard
          } else {
            return const LoginPage2(); // Fallback in case of unexpected email
          }
        } else {
          // User is logged out
          return const LoginPage2();
        }
      },
    );
  }
}
