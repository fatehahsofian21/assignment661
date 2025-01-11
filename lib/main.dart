import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart'; // For permission handling
import 'login.dart';
import 'login2.dart';
import 'mainpage.dart';
import 'mainpageL.dart'; // Import MainPageL for lecturers
import 'zawawi.dart';
import 'atif.dart';
import 'ahmad.dart';
import 'success.dart';
import 'dashboard.dart';
import 'booking.dart';
import 'upcoming.dart';
import 'profileS.dart'; // Add ProfileSPage import

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
      initialRoute: '/login', // Set initial route to login page
      routes: {
        '/login': (context) => const SplashScreen(),
        '/login2': (context) => const LoginPage2(),
        '/mainpage': (context) =>
            const MainPage(userName: 'User'), // Pass userName to MainPage
        '/mainpageL': (context) => const MainPageL(), // Main page for lecturers
        '/zawawi': (context) => const ZawawiPage(),
        '/atif': (context) => const AtifPage(),
        '/success': (context) => const SuccessPage(),
        '/dashboard': (context) =>
            const DashboardPage(userName: 'User'), // Dashboard with username
        '/booking': (context) => const BookingPage(),
        '/upcoming': (context) => const UpcomingPage(),
        '/myaccount': (context) => const ProfileSPage(), // Route for My Account
      },
    );
  }
}
