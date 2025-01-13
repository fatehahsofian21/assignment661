import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CancelPage extends StatelessWidget {
  final Map<String, dynamic> bookingData;

  const CancelPage({Key? key, required this.bookingData}) : super(key: key);

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

  @override
  Widget build(BuildContext context) {
    final String venue = bookingData['venue'] ?? "N/A";
    final String date = bookingData['bookingDate'] ?? "N/A";
    final String time = bookingData['bookingTime'] ?? "N/A";
    final String day = _getDayFromDate(date);
    final String formattedDate = _formatDate(date);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 19, 34, 48),
        title: const Text("Cancelled Appointment"),
        elevation: 0,
      ),
      body: Container(
        color: const Color.fromARGB(255, 235, 218, 181),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const CircleAvatar(
                  radius: 60,
                  backgroundImage: AssetImage('assets/cancel_icon.png'),
                  backgroundColor: Colors.transparent,
                ),
                const SizedBox(height: 16),
                const Text(
                  "Appointment with Zawawi bin Ismail@Abdul Wahab",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
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
                  "Date: $formattedDate\nDay: $day\nTime: $time\nVenue: $venue",
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context); // Navigate back
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 224, 204, 161),
                  ),
                  child: const Text(
                    "Back to Booking",
                    style: TextStyle(color: Colors.black),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
