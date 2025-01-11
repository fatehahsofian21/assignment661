import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class BookingPage extends StatefulWidget {
  const BookingPage({Key? key}) : super(key: key);

  @override
  State<BookingPage> createState() => _BookingPageState();
}

class _BookingPageState extends State<BookingPage> {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  // Dropdown selection state
  String selectedStatus = 'Completed';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(50),
        child: AppBar(
          backgroundColor: const Color.fromARGB(255, 19, 34, 48),
          elevation: 0,
          automaticallyImplyLeading: false,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () => Navigator.pushNamed(context, '/mainpage'),
              ),
              const Text(
                "My Booking",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(width: 48),
            ],
          ),
        ),
      ),
      body: Container(
        color: const Color.fromARGB(255, 42, 71, 90),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Upcoming Section
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                "Upcoming",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            Expanded(
              child: _buildBookingsList('Upcoming'),
            ),

            // Dropdown for Completed and Cancelled
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                "Select Booking Type",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: DropdownButton<String>(
                value: selectedStatus,
                dropdownColor: const Color.fromARGB(255, 42, 71, 90),
                iconEnabledColor: Colors.white,
                style: const TextStyle(color: Colors.white),
                items: const [
                  DropdownMenuItem(
                    value: 'Completed',
                    child: Text("Completed",
                        style: TextStyle(color: Colors.white)),
                  ),
                  DropdownMenuItem(
                    value: 'Cancelled',
                    child: Text("Cancelled",
                        style: TextStyle(color: Colors.white)),
                  ),
                ],
                onChanged: (value) {
                  setState(() {
                    selectedStatus = value!;
                  });
                },
              ),
            ),
            Expanded(
              child: _buildBookingsList(selectedStatus),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: const Color.fromARGB(255, 19, 34, 48),
        selectedItemColor: const Color.fromARGB(255, 75, 153, 193),
        unselectedItemColor: Colors.grey,
        currentIndex: 1, // Highlight My Booking
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.check_circle),
            label: "My Booking",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: "My Account",
          ),
        ],
        onTap: (index) {
          if (index == 0) {
            Navigator.pushNamed(context, '/mainpage');
          } else if (index == 2) {
            Navigator.pushNamed(context, '/myaccount');
          }
        },
      ),
    );
  }

  /// Builds a list of bookings filtered by status
  Widget _buildBookingsList(String status) {
    return StreamBuilder<QuerySnapshot>(
      stream: firestore
          .collection('bookings')
          .where('status', isEqualTo: status)
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
            final data = bookings[index].data() as Map<String, dynamic>;
            return Card(
              color: Colors.white,
              margin:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
              child: ListTile(
                title: Text("Date: ${data['bookingDate']}"),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Time: ${data['bookingTime']}"),
                    if (data.containsKey('reason') && status == 'Cancelled')
                      Text("Reason: ${data['reason']}"),
                  ],
                ),
                trailing: Text("Venue: ${data['venue']}"),
              ),
            );
          },
        );
      },
    );
  }
}
