import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart'; // Import for FCM
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
    await Firebase.initializeApp(); // Ensure Firebase initializes
    await requestLocationPermission(); // Handle permissions
    await setupFCM(); // Setup FCM and get the device token
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
      home: const AuthWrapper(),
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

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (snapshot.hasError) {
          return const Scaffold(
            body: Center(child: Text("An error occurred. Please try again.")),
          );
        }

        if (snapshot.hasData) {
          final user = snapshot.data;
          final email = user?.email ?? '';

          if (email.contains('@lecturer.uitm.edu.my')) {
            return MainPageL(email: email);
          } else if (email.contains('@student.uitm.edu.my')) {
            final userName = email.split('@')[0];
            return DashboardPage(userName: userName);
          }
        }

        return const LoginPage2(); // Default to login if no user is found
      },
    );
  }
}
