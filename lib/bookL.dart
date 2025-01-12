import 'package:flutter/material.dart';

class BookLPage extends StatefulWidget {
  const BookLPage({Key? key}) : super(key: key);

  @override
  _BookLPageState createState() => _BookLPageState();
}

class _BookLPageState extends State<BookLPage> {
  String filterStatus = "Completed"; // Default dropdown filter
  final List<Map<String, String>> bookings = [
    {"name": "Teha", "status": "Completed"},
    {"name": "Husna", "status": "Cancelled"},
    {"name": "Rai", "status": "Completed"},
    {"name": "Ali", "status": "Cancelled"},
  ];

  @override
  Widget build(BuildContext context) {
    List<Map<String, String>> filteredBookings = bookings
        .where((booking) => booking['status'] == filterStatus)
        .toList();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 19, 34, 48),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          "Booking History",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Dropdown for filtering
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Filter by:",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                DropdownButton<String>(
                  value: filterStatus,
                  onChanged: (String? newValue) {
                    setState(() {
                      filterStatus = newValue!;
                    });
                  },
                  items: <String>["Completed", "Cancelled"]
                      .map<DropdownMenuItem<String>>(
                          (String value) => DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              ))
                      .toList(),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // List of bookings
            Expanded(
              child: ListView.builder(
                itemCount: filteredBookings.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Container(
                      padding: const EdgeInsets.all(16.0),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 2,
                            blurRadius: 5,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            filteredBookings[index]["name"]!,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            "Status: ${filteredBookings[index]["status"]}",
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
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
