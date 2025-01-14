import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class BookLPage extends StatefulWidget {
  const BookLPage({Key? key}) : super(key: key);

  @override
  State<BookLPage> createState() => _BookLPageState();
}

class _BookLPageState extends State<BookLPage> {
  String selectedStatus = "Upcoming"; // Default dropdown selection
  List<Map<String, dynamic>> bookings = [];
  bool isLoading = true; // Loading state indicator

  @override
  void initState() {
    super.initState();
    _loadBookings(); // Load bookings when page opens
  }

  Future<void> _loadBookings() async {
    try {
      // Fetch all user documents from 'users' collection
      final userSnapshot =
          await FirebaseFirestore.instance.collection('users').get();

      if (userSnapshot.docs.isNotEmpty) {
        // Fetch bookings from each user's 'bookings' subcollection
        final fetchedBookings =
            await _fetchAllBookings(userSnapshot.docs, selectedStatus);

        setState(() {
          bookings = fetchedBookings; // Update bookings list
          isLoading = false; // Stop loading
        });
      } else {
        debugPrint("No users found.");
        setState(() {
          bookings = [];
          isLoading = false;
        });
      }
    } catch (e) {
      debugPrint("Error loading bookings: $e");
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<List<Map<String, dynamic>>> _fetchAllBookings(
      List<QueryDocumentSnapshot> userDocs, String status) async {
    List<Map<String, dynamic>> allBookings = [];

    for (var userDoc in userDocs) {
      try {
        final userBookings = await FirebaseFirestore.instance
            .collection('users')
            .doc(userDoc.id)
            .collection('bookings')
            .where(
              'status',
              isEqualTo: status == "Upcoming"
                  ? "active"
                  : (status == "Cancelled" ? "cancelled" : "declined"),
            )
            .get();

        for (var booking in userBookings.docs) {
          allBookings.add(booking.data());
        }
      } catch (e) {
        debugPrint("Error fetching bookings for user ${userDoc.id}: $e");
      }
    }

    return allBookings;
  }

  String _formatDate(String? date) {
    if (date == null) return "N/A";
    try {
      final parsedDate = DateTime.parse(date);
      return DateFormat('dd MMM yyyy').format(parsedDate);
    } catch (e) {
      return "Invalid Date";
    }
  }

  String _getDayFromDate(String? dateString) {
    try {
      final date = DateTime.parse(dateString ?? "");
      const weekdays = [
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 19, 34, 48),
        title: const Text(
          "Booking History",
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
      ),
      body: Container(
        color: const Color.fromARGB(255, 42, 71, 90),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: DropdownButton<String>(
                  value: selectedStatus,
                  dropdownColor: const Color.fromARGB(255, 19, 34, 48),
                  style: const TextStyle(color: Colors.white),
                  items: ["Upcoming", "Cancelled", "Declined"].map((status) {
                    return DropdownMenuItem(
                      value: status,
                      child: Text(status),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedStatus = value!;
                      isLoading = true;
                    });
                    _loadBookings();
                  },
                ),
              ),
            ),
            Expanded(
              child: isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : bookings.isEmpty
                      ? Center(
                          child: Text(
                            "No $selectedStatus bookings available.",
                            style: const TextStyle(color: Colors.white),
                          ),
                        )
                      : ListView.builder(
                          itemCount: bookings.length,
                          itemBuilder: (context, index) {
                            final booking = bookings[index];
                            final formattedDate =
                                _formatDate(booking['bookingDate']);
                            final day = _getDayFromDate(booking['bookingDate']);

                            return Card(
                              color: Colors.white,
                              margin: const EdgeInsets.symmetric(
                                  horizontal: 16.0, vertical: 8.0),
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
                                  selectedStatus,
                                  style: TextStyle(
                                    color: selectedStatus == "Upcoming"
                                        ? Colors.green
                                        : (selectedStatus == "Cancelled"
                                            ? Colors.red
                                            : Colors.orange),
                                  ),
                                ),
                                onTap: () {
                                  if (selectedStatus == "Upcoming") {
                                    Navigator.pushNamed(
                                      context,
                                      '/upcomingL', // Navigate to UpcomingLPage
                                      arguments:
                                          booking, // Pass booking details as arguments
                                    );
                                  }
                                },
                              ),
                            );
                          },
                        ),
            ),
          ],
        ),
      ),
    );
  }
}
