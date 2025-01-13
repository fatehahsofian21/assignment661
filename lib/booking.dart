import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';

class BookingPage extends StatefulWidget {
  const BookingPage({Key? key}) : super(key: key);

  @override
  State<BookingPage> createState() => _BookingPageState();
}

class _BookingPageState extends State<BookingPage> {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  String selectedStatus = "Upcoming"; // Default dropdown selection

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 19, 34, 48),
        title: const Text(
          "My Booking",
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
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: DropdownButton<String>(
                  value: selectedStatus,
                  dropdownColor: const Color.fromARGB(255, 19, 34, 48),
                  style: const TextStyle(color: Colors.white),
                  items: ["Upcoming", "Cancelled", "Completed"].map((status) {
                    return DropdownMenuItem(
                      value: status,
                      child: Text(status),
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
            Expanded(
              child: _buildBookingsList(selectedStatus),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBookingsList(String status) {
    final String? userId = FirebaseAuth.instance.currentUser?.uid;

    if (userId == null) {
      return const Center(
        child: Text(
          "No user logged in.",
          style: TextStyle(color: Colors.white),
        ),
      );
    }

    String firestoreStatus = _mapStatusToFirestore(status);

    return StreamBuilder<QuerySnapshot>(
      stream: firestore
          .collection('users')
          .doc(userId)
          .collection('bookings')
          .where('status', isEqualTo: firestoreStatus)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return Center(
            child: Text(
              "No $status bookings.",
              style: const TextStyle(color: Colors.white),
            ),
          );
        }

        final bookings = snapshot.data!.docs;

        return ListView.builder(
          itemCount: bookings.length,
          itemBuilder: (context, index) {
            final doc = bookings[index];
            final data = doc.data() as Map<String, dynamic>;

            // Parse and format date
            String formattedDate = _formatDate(data['bookingDate']);
            String bookingId = doc.id;

            return Dismissible(
              key: Key(bookingId),
              direction: status == "Cancelled"
                  ? DismissDirection.endToStart
                  : DismissDirection.none, // Swipe left for "Cancelled"
              background: Container(
                color: Colors.red,
                alignment: Alignment.centerRight,
                padding: const EdgeInsets.only(right: 20.0),
                child: const Icon(Icons.delete, color: Colors.white),
              ),
              confirmDismiss: status == "Cancelled"
                  ? (direction) =>
                      _showDeleteConfirmation(context, bookingId, data)
                  : null,
              child: Card(
                color: Colors.white,
                margin:
                    const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: ListTile(
                  title: Text("Date: $formattedDate"),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Time: ${data['bookingTime']}"),
                      Text("Venue: ${data['venue']}"),
                    ],
                  ),
                  trailing: Text("Status: ${data['status']}"),
                  onTap: () {
                    if (status == "Cancelled") {
                      Navigator.pushNamed(
                        context,
                        '/cancel',
                        arguments: {
                          'documentId': bookingId,
                          'venue': data['venue'],
                          'bookingDate': data['bookingDate'],
                          'bookingTime': data['bookingTime'],
                          'reason': data['reason'],
                        },
                      );
                    } else if (status == "Upcoming") {
                      Navigator.pushNamed(
                        context,
                        '/upcoming',
                        arguments: {
                          'documentId': bookingId,
                          'venue': data['venue'],
                          'bookingDate': data['bookingDate'],
                          'bookingTime': data['bookingTime'],
                        },
                      );
                    }
                  },
                ),
              ),
            );
          },
        );
      },
    );
  }

  String _formatDate(String? date) {
    if (date == null) return "N/A";
    try {
      DateTime parsedDate = DateTime.parse(date);
      return DateFormat('dd MMM yyyy').format(parsedDate);
    } catch (e) {
      return "Invalid Date";
    }
  }

  String _mapStatusToFirestore(String status) {
    switch (status) {
      case "Upcoming":
        return "active";
      case "Cancelled":
        return "cancelled";
      case "Completed":
        return "completed";
      default:
        return "active";
    }
  }

  Future<bool> _showDeleteConfirmation(
      BuildContext context, String bookingId, Map<String, dynamic> data) async {
    return await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text("Delete Booking"),
            content: Text(
                "Are you sure you want to delete the booking on ${_formatDate(data['bookingDate'])}?"),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text("No"),
              ),
              TextButton(
                onPressed: () async {
                  await firestore
                      .collection('users')
                      .doc(FirebaseAuth.instance.currentUser?.uid)
                      .collection('bookings')
                      .doc(bookingId)
                      .delete();
                  Navigator.pop(context, true); // Confirm deletion
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text("Booking deleted successfully.")),
                  );
                },
                child: const Text("Yes"),
              ),
            ],
          ),
        ) ??
        false;
  }
}
