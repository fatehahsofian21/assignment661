import 'package:flutter/material.dart';
import 'package:intl/intl.dart';


class BookLPage extends StatefulWidget {
  const BookLPage({Key? key}) : super(key: key);

  @override
  State<BookLPage> createState() => _BookLPageState();
}

class _BookLPageState extends State<BookLPage> {
  String selectedStatus = "Upcoming"; // Default dropdown selection

  // Mock booking data
  final List<Map<String, dynamic>> mockBookings = [
    {
      "bookingDate": "2025-01-15",
      "bookingTime": "10:00 AM",
      "status": "active",
      "venue": "Lecture Room A",
      "remark": "Bring laptop",
    },
    {
      "bookingDate": "2025-01-16",
      "bookingTime": "02:00 PM",
      "status": "cancelled",
      "venue": "Hall 2",
      "remark": "Cancelled due to maintenance",
    },
    {
      "bookingDate": "2025-01-17",
      "bookingTime": "09:00 AM",
      "status": "active",
      "venue": "Lecture Room B",
      "remark": "Presentation Day",
    },
    {
      "bookingDate": "2025-01-18",
      "bookingTime": "11:00 AM",
      "status": "cancelled",
      "venue": "Hall 3",
      "remark": "Cancelled due to weather",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 19, 34, 48),
        title: const Text(
          "Booking History",
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Container(
        color: const Color.fromARGB(255, 42, 71, 90),
        child: Column(
          children: [
            // Dropdown to filter bookings by status
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: DropdownButton<String>(
                  value: selectedStatus,
                  dropdownColor: const Color.fromARGB(255, 19, 34, 48),
                  style: const TextStyle(color: Colors.white),
                  items: ["Upcoming", "Cancelled"].map((status) {
                    return DropdownMenuItem(
                      value: status,
                      child: Text(
                        status,
                      ),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedStatus = value!;
                    });
                  },
                ),
              ),
            ),
            // Booking list
            Expanded(
              child: _buildBookingsList(selectedStatus),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBookingsList(String status) {
    // Map the status to mock data filtering
    final filteredBookings = mockBookings
        .where((booking) =>
            booking['status'] == (status == "Upcoming" ? "active" : "cancelled"))
        .toList();

    if (filteredBookings.isEmpty) {
      return Center(
        child: Text(
          "No $status bookings available.",
          style: const TextStyle(color: Colors.white),
        ),
      );
    }

    return ListView.builder(
      itemCount: filteredBookings.length,
      itemBuilder: (context, index) {
        final booking = filteredBookings[index];
        String formattedDate = _formatDate(booking['bookingDate']);
        String day = _getDayFromDate(booking['bookingDate']);

        return Card(
          color: Colors.white,
          margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: ListTile(
            title: Text("Date: $formattedDate ($day)"),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Time: ${booking['bookingTime']}"),
                Text("Venue: ${booking['venue']}"),
                Text("Remark: ${booking['remark']}"),
              ],
            ),
            trailing: Text(
              status,
              style: TextStyle(
                color: status == "Upcoming" ? Colors.green : Colors.red,
              ),
            ),
          ),
        );
      },
    );
  }

  String _formatDate(String? date) {
    if (date == null) return "N/A";
    try {
      final DateTime parsedDate = DateTime.parse(date);
      return DateFormat('dd MMM yyyy').format(parsedDate);
    } catch (e) {
      return "Invalid Date";
    }
  }

  String _getDayFromDate(String? dateString) {
    try {
      DateTime date = DateTime.parse(dateString ?? "");
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
}
