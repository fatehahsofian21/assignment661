import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';

class UpcomingPage extends StatelessWidget {
  const UpcomingPage({Key? key}) : super(key: key);

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

  void _showReasonDialog(BuildContext context, String documentId,
      String formattedDate, String day, String venue) {
    final TextEditingController reasonController = TextEditingController();

    showDialog(
      context: context,
      barrierDismissible: false, // Prevent closing by tapping outside
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          backgroundColor:
              const Color.fromARGB(255, 255, 244, 230), // Cream color
          title: const Text(
            "Cancel Booking",
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    padding: const EdgeInsets.all(8),
                    child: Column(
                      children: [
                        Text(
                          formattedDate.split('/')[0],
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        Text(
                          day,
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Zawawi",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                        ),
                        Text(
                          "Venue: $venue",
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.black,
                          ),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
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
                  labelText: "Enter reason for cancellation",
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
                  _cancelBooking(context, documentId, venue, reason);
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

  void _cancelBooking(
      BuildContext context, String documentId, String venue, String reason) {
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
        .update({'status': 'cancelled', 'reason': reason}).then((_) {
      Navigator.pop(context); // Close the reason dialog
      _showCancellationSuccessDialog(context, venue);
    }).catchError((error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to cancel booking: $error")),
      );
    });
  }

  void _showCancellationSuccessDialog(BuildContext context, String venue) {
    showDialog(
      context: context,
      barrierDismissible: false, // Prevent closing by tapping outside
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          backgroundColor:
              const Color.fromARGB(255, 255, 244, 230), // Cream color
          title: const Text(
            "Cancellation Successful",
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
          ),
          content: Text(
            "Your booking at $venue has been successfully cancelled.",
            style: const TextStyle(fontSize: 16, color: Colors.black),
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context); // Close popup
                Navigator.popAndPushNamed(
                    context, '/booking'); // Navigate to booking
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 206, 206, 206),
              ),
              child: const Text("Done"),
            ),
          ],
        );
      },
    );
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
              color: Colors.white, // Changed to white
            ),
          ),
          elevation: 0,
          iconTheme: const IconThemeData(color: Colors.white), // White arrow
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

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 19, 34, 48),
        title: const Text(
          "Upcoming Appointment",
          style: TextStyle(
            color: Colors.white, // Changed to white
          ),
        ),
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white), // White arrow
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
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const CircleAvatar(
                      radius: 50,
                      backgroundImage: AssetImage('assets/profile.jpg'),
                      backgroundColor: Colors.transparent,
                    ),
                    const SizedBox(height: 16),
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
                      "You have an upcoming appointment with Zawawi bin Ismail@Abdul Wahab.",
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
                    const SizedBox(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color.fromARGB(
                                255, 206, 206, 206), // Changed to grey
                          ),
                          child: const Text("Back"),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            _showReasonDialog(
                                context, documentId, formattedDate, day, venue);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color.fromARGB(
                                255, 206, 206, 206), // Changed to grey
                          ),
                          child: const Text("Cancel Booking"),
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
