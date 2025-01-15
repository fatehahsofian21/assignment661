import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'login2.dart';
import 'mainpage.dart';
import 'mainpageL.dart';
import 'dashboard.dart';
import 'profileS.dart';
import 'zawawi.dart';
import 'success.dart';
import 'booking.dart';
import 'upcoming.dart';
import 'cancel.dart';
import 'upcomingL.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Firebase.initializeApp(); // Initialize Firebase
    await requestLocationPermission(); // Handle location permissions
    await setupFCM(); // Setup Firebase Cloud Messaging
  } catch (e) {
    debugPrint("Error initializing Firebase or permissions: $e");
  }
  runApp(const MyApp());
}

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

Future<void> setupFCM() async {
  FirebaseMessaging messaging = FirebaseMessaging.instance;

  // Request permission for notifications
  NotificationSettings settings = await messaging.requestPermission(
    alert: true,
    badge: true,
    sound: true,
  );

  if (settings.authorizationStatus == AuthorizationStatus.authorized) {
    debugPrint("Notification permission granted.");

    // Get the device token
    String? token = await messaging.getToken();
    if (token != null) {
      debugPrint("FCM Device Token: $token");
    } else {
      debugPrint("Failed to retrieve FCM token.");
    }
  } else if (settings.authorizationStatus == AuthorizationStatus.provisional) {
    debugPrint("Provisional notification permission granted.");
  } else {
    debugPrint("Notification permission denied.");
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
      home: const SplashScreen(), // Set SplashScreen as the first screen
      routes: {
        '/login2': (context) => const LoginPage2(),
        '/mainpage': (context) => MainPage(
              userName: ModalRoute.of(context)?.settings.arguments as String? ?? 'User',
            ),
        '/mainpageL': (context) => MainPageL(
              email: ModalRoute.of(context)?.settings.arguments as String? ?? 'example@domain.com',
            ),
        '/dashboard': (context) => DashboardPage(
              userName: ModalRoute.of(context)?.settings.arguments as String? ?? 'User',
            ),
        '/myaccount': (context) => const ProfileSPage(),
        '/zawawi': (context) => const ZawawiPage(),
        '/success': (context) => const SuccessPage(),
        '/booking': (context) => const BookingPage(),
        '/upcoming': (context) => const UpcomingPage(),
        '/upcomingL': (context) => const UpcomingLPage(),
        '/cancel': (context) {
          final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
          if (args == null) {
            return Scaffold(
              appBar: AppBar(
                title: const Text('Error'),
              ),
              body: const Center(
                child: Text('No booking data available.'),
              ),
            );
          }
          return CancelPage(bookingData: args);
        },
      },
    );
  }
}

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Future.delayed(const Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginPage2()),
      );
    });

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
                      MaterialPageRoute(builder: (context) => const LoginPage2()),
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
