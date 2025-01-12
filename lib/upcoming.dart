import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart'; // For formatting date

class UpcomingPage extends StatelessWidget {
  const UpcomingPage({Key? key}) : super(key: key);

  String _getUserName() {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null && user.email != null) {
      return user.email!.split('@')[0]; // Extract username from email
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
      return DateFormat("d MMM").format(date); // Example: "15 Jan"
    } catch (e) {
      return "Invalid Date";
    }
  }

  void _showCancellationSuccessDialog(
    BuildContext context,
    String bookingId,
    String formattedDate,
    String day,
    String venue,
    String reason,
  ) {
    FirebaseFirestore.instance
        .collection('bookings')
        .doc(bookingId)
        .update({'status': 'Cancelled'}).then((_) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text(
              "Cancellation Successful",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
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
                            formattedDate.split(' ')[0], // Day number
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            day, // Day name
                            style: const TextStyle(
                              fontSize: 16,
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
                            "Zawawi bin Ismail@Abdul Wahab",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                          ),
                          Text(
                            "Venue: $venue",
                            style: const TextStyle(fontSize: 14),
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
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  reason.isNotEmpty ? reason : 'No reason provided.',
                  style: const TextStyle(fontSize: 14),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 3,
                ),
              ],
            ),
            actions: [
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 224, 204, 161),
                ),
                onPressed: () {
                  Navigator.pop(context); // Close dialog
                  Navigator.pushNamed(
                      context, '/booking'); // Navigate back to booking
                },
                child: const Text(
                  "Done",
                  style: TextStyle(
                    color: Color.fromARGB(255, 96, 56, 8),
                    fontSize: 16,
                  ),
                ),
              ),
            ],
          );
        },
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
          title: const Text("Upcoming Appointment"),
          elevation: 0,
        ),
        body: const Center(
          child: Text("No booking details available."),
        ),
      );
    }

    final String bookingId = bookingData['id'];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 19, 34, 48),
        title: const Text("Upcoming Appointment"),
        elevation: 0,
      ),
      body: FutureBuilder<DocumentSnapshot>(
        future: FirebaseFirestore.instance
            .collection('bookings')
            .doc(bookingId)
            .get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || !snapshot.data!.exists) {
            return const Center(
              child: Text("Booking details not found."),
            );
          }

          final bookingDetails = snapshot.data!.data() as Map<String, dynamic>?;

          if (bookingDetails == null) {
            return const Center(
              child: Text("Failed to fetch booking details."),
            );
          }

          final String date = bookingDetails['bookingDate'] ?? 'N/A';
          final String formattedDate = _formatDate(date);
          final String day = _getDayFromDate(date);
          final String venue = bookingDetails['venue'] ?? 'N/A';
          final String remark = bookingDetails['remark'] ?? 'N/A';

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
                      "Hello, ${_getUserName()}!",
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      "You have an upcoming appointment\nwith Zawawi bin Ismail@Abdul Wahab.",
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
                      "Date: $formattedDate\nDay: $day\nVenue: $venue\nRemark: $remark",
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
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                const Color.fromARGB(255, 224, 204, 161),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 30,
                              vertical: 10,
                            ),
                          ),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: const Text(
                            "Back",
                            style: TextStyle(
                              color: Color.fromARGB(255, 96, 56, 8),
                              fontSize: 16,
                            ),
                          ),
                        ),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                const Color.fromARGB(255, 224, 204, 161),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 30,
                              vertical: 10,
                            ),
                          ),
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                final TextEditingController reasonController =
                                    TextEditingController();
                                return AlertDialog(
                                  title: const Text(
                                    "Cancel Appointment",
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  content: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      TextField(
                                        controller: reasonController,
                                        decoration: const InputDecoration(
                                          labelText: "Reason:",
                                          border: OutlineInputBorder(),
                                        ),
                                        maxLines: 3,
                                      ),
                                    ],
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.pop(context); // Close dialog
                                      },
                                      child: const Text("No"),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        final reason =
                                            reasonController.text.trim();
                                        if (reason.isNotEmpty) {
                                          _showCancellationSuccessDialog(
                                              context,
                                              bookingId,
                                              formattedDate,
                                              day,
                                              venue,
                                              reason);
                                        }
                                      },
                                      child: const Text("Yes"),
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                          child: const Text(
                            "Cancel Booking",
                            style: TextStyle(
                              color: Color.fromARGB(255, 96, 56, 8),
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ],
                    )
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
