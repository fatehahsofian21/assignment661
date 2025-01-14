import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';

class UpcomingLPage extends StatelessWidget {
  const UpcomingLPage({Key? key}) : super(key: key);

  Future<String> _getUserName() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();
      return userDoc.data()?['name'] ?? "User";
    }
    return "User";
  }

  String _getDayFromDate(String dateString) {
    try {
      DateTime date = DateTime.parse(dateString);
      List<String> weekdays = [
        "Monday",
        "Tuesday",
        "Wednesday",
        "Thursday",
        "Friday",
        "Saturday",
        "Sunday"
      ];
      return weekdays[date.weekday - 1];
    } catch (e) {
      return "Invalid Date";
    }
  }

  String _formatDate(String dateString) {
    try {
      DateTime date = DateTime.parse(dateString);
      return DateFormat("dd/MM/yy").format(date);
    } catch (e) {
      return "Invalid Date";
    }
  }

  Uint8List? _decodeBase64(String base64String) {
    try {
      return base64Decode(base64String);
    } catch (e) {
      debugPrint("Failed to decode Base64 string: $e");
      return null;
    }
  }

  void _showDocumentDialog(BuildContext context, Uint8List imageBytes) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.memory(imageBytes, fit: BoxFit.cover),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Close"),
            ),
          ],
        ),
      ),
    );
  }

  void _showDeclineDialog(BuildContext context, String documentId, String venue) {
    final TextEditingController reasonController = TextEditingController();

    showDialog(
      context: context,
      barrierDismissible: false, // Prevent closing by tapping outside
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          backgroundColor: const Color.fromARGB(255, 255, 244, 230), // Cream color
          title: const Text(
            "Decline Booking",
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                "Reason:",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: reasonController,
                decoration: const InputDecoration(
                  labelText: "Enter reason for declining",
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              style: TextButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 206, 206, 206),
                foregroundColor: const Color.fromARGB(255, 127, 79, 141),
              ),
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () {
                final reason = reasonController.text.trim();
                if (reason.isNotEmpty) {
                  _declineBooking(context, documentId, venue, reason);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Reason cannot be empty.")),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 206, 206, 206),
              ),
              child: const Text("Submit"),
            ),
          ],
        );
      },
    );
  }

  void _declineBooking(BuildContext context, String documentId, String venue, String reason) {
    if (documentId.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Invalid Booking ID")),
      );
      return;
    }

    FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser?.uid)
        .collection('bookings')
        .doc(documentId)
        .update({'status': 'declined', 'reason': reason}).then((_) {
      Navigator.pop(context); // Close the reason dialog
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Booking at $venue has been declined.")),
      );
    }).catchError((error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to decline booking: $error")),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic>? bookingData =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;

    if (bookingData == null) {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: const Color.fromARGB(255, 19, 34, 48),
          title: const Text(
            "Upcoming Appointment",
            style: TextStyle(
              color: Colors.white,
            ),
          ),
          elevation: 0,
          iconTheme: const IconThemeData(color: Colors.white),
        ),
        body: const Center(
          child: Text("No booking details available."),
        ),
      );
    }

    final String documentId = bookingData['documentId'] ?? '';
    final String venue = bookingData['venue'] ?? "N/A";
    final String date = bookingData['bookingDate'] ?? "N/A";
    final String day = _getDayFromDate(date);
    final String formattedDate = _formatDate(date);
    final String photoBase64 = bookingData['photoBase64'] ?? "";

    Uint8List? decodedImage = _decodeBase64(photoBase64);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 19, 34, 48),
        title: const Text(
          "Upcoming Appointment",
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: FutureBuilder<String>(
        future: _getUserName(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final userName = snapshot.data ?? "User";

          return Container(
            color: const Color.fromARGB(255, 235, 218, 181),
            child: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20),
                    ClipOval(
                      child: Image.asset(
                        'assets/k.jpg',
                        height: 100,
                        width: 100,
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      "Hi, $userName!",
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      "You have an upcoming appointment.",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      "Booking Details:",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "Date: $formattedDate\nDay: $day\nVenue: $venue",
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: decodedImage != null
                          ? () => _showDocumentDialog(context, decodedImage)
                          : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(255, 206, 206, 206),
                      ),
                      child: const Text("View Document"),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            _showDeclineDialog(context, documentId, venue);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color.fromARGB(255, 255, 94, 94),
                          ),
                          child: const Text("Decline"),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            FirebaseFirestore.instance
                                .collection('users')
                                .doc(FirebaseAuth.instance.currentUser?.uid)
                                .collection('bookings')
                                .doc(documentId)
                                .update({'status': 'completed'});
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text("Booking marked as completed.")),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color.fromARGB(255, 89, 178, 89),
                          ),
                          child: const Text("Done"),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
