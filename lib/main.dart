import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart'; // Add this
import 'login.dart';
import 'login2.dart';
import 'mainpage.dart';
import 'zawawi.dart';
import 'atif.dart';
import 'ahmad.dart';
import 'success.dart';
import 'dashboard.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Firebase.initializeApp();
    await requestLocationPermission(); // Request location permission
  } catch (e) {
    debugPrint("Error initializing Firebase or permissions: $e");
  }
  runApp(const MyApp());
}

Future<void> requestLocationPermission() async {
  if (await Permission.location.request().isGranted) {
    print("Location permission granted.");
  } else {
    print("Location permission denied.");
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
      initialRoute: '/login',
      routes: {
        '/login': (context) => const SplashScreen(),
        '/login2': (context) => const LoginPage2(),
        '/mainpage': (context) => const MainPage(userName: 'User'),
        '/zawawi': (context) => const ZawawiPage(),
        '/atif': (context) => const AtifPage(),
        '/ahmad': (context) => const AhmadPage(),
        '/success': (context) => const SuccessPage(),
        '/dashboard': (context) => const DashboardPage(userName: 'User'),
      },
    );
  }
}
