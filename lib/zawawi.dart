import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ZawawiPage extends StatefulWidget {
  const ZawawiPage({super.key});

  @override
  State<ZawawiPage> createState() => _ZawawiPageState();
}

class _ZawawiPageState extends State<ZawawiPage> {
  DateTime? selectedDate; // For the calendar
  String selectedVenue = "Lecturer's Room"; // Default venue
  TextEditingController otherVenueController =
      TextEditingController(); // For other venue
  TextEditingController remarkController =
      TextEditingController(); // For remark
  File? selectedImage;
  File? selectedFile;

  final picker = ImagePicker();

  Future<void> _pickImageFromCamera() async {
    final pickedFile = await picker.pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      setState(() {
        selectedImage = File(pickedFile.path);
        selectedFile = null; // Clear selected file
      });
    }
  }

  Future<void> _pickImageFromGallery() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        selectedImage = File(pickedFile.path);
        selectedFile = null; // Clear selected file
      });
    }
  }

  List<List<Map<String, dynamic>>> scheduleAvailability = [
    [
      {"time": "8:00 AM", "available": true},
      {"time": "9:15 AM", "available": false},
      {"time": "10:30 AM", "available": true},
      {"time": "11:45 AM", "available": false},
    ],
    [
      {"time": "12:00 PM", "available": true},
      {"time": "1:15 PM", "available": true},
      {"time": "2:30 PM", "available": false},
      {"time": "3:45 PM", "available": true},
    ],
    [
      {"time": "4:00 PM", "available": true},
      {"time": "5:00 PM", "available": false},
    ]
  ];

  String? selectedTime; // To store the selected time slot

  void _showConfirmationDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirm Booking'),
        content: const Text('Are you sure you want to confirm this booking?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context), // Close dialog
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Close dialog
              Navigator.pushNamed(
                  context, '/success'); // Navigate to success page
            },
            child: const Text('Yes'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Zawawi's Booking"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Profile Picture and Name
            const Row(
              children: [
                CircleAvatar(
                  radius: 40,
                  backgroundImage:
                      AssetImage('assets/k.jpg'), // Lecturer's photo
                ),
                SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Zawawi bin Ismail@Abdul Wahab",
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text("Phone: 012-3456789",
                          style: TextStyle(fontSize: 14)),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            // Schedule and Room Buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    // Schedule functionality
                  },
                  child: const Text('Schedule'),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () {
                    // Room functionality
                  },
                  child: const Text('Room'),
                ),
              ],
            ),
            const SizedBox(height: 16),
            // Booking Date
            const Text("Booking Date",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      selectedDate != null
                          ? "${selectedDate!.toLocal()}".split(' ')[0]
                          : "Select Date",
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () async {
                    DateTime? date = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime.now(),
                      lastDate: DateTime.now().add(const Duration(days: 365)),
                    );
                    setState(() {
                      selectedDate = date;
                    });
                                    },
                  icon: const Icon(Icons.calendar_today),
                ),
              ],
            ),
            const SizedBox(height: 16),
            // Booking Time Availability
            const Text("Booking Time",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Column(
              children: scheduleAvailability.map((row) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: row.map((slot) {
                    return GestureDetector(
                      onTap: slot['available']
                          ? () {
                              setState(() {
                                selectedTime = slot['time'];
                              });
                            }
                          : null, // Disable tap if unavailable
                      child: Container(
                        margin: const EdgeInsets.all(4),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 8),
                        decoration: BoxDecoration(
                          color: slot['available'] ? Colors.green : Colors.red,
                          border: Border.all(
                            color: selectedTime == slot['time'] &&
                                    slot['available']
                                ? Colors.black
                                : Colors.grey,
                            width: 2,
                          ),
                          borderRadius: BorderRadius.circular(20), // Oval shape
                        ),
                        child: Text(
                          slot['time'],
                          style: TextStyle(
                            color:
                                slot['available'] ? Colors.black : Colors.white,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                );
              }).toList(),
            ),
            const SizedBox(height: 16),
            // Venue Selection
            const Text("Venue",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: DropdownButton<String>(
                    value: selectedVenue,
                    isExpanded: true,
                    items: ["Lecturer's Room", "Other"].map((value) {
                      return DropdownMenuItem(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedVenue = value!;
                      });
                    },
                  ),
                ),
              ],
            ),
            if (selectedVenue == "Other")
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: TextField(
                  controller: otherVenueController,
                  decoration: const InputDecoration(
                    hintText: "Enter venue",
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
            const SizedBox(height: 16),
            // Upload Photo
            const Text("Upload Photo",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: () {
                showModalBottomSheet(
                  context: context,
                  builder: (context) => Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ListTile(
                        leading: const Icon(Icons.camera_alt),
                        title: const Text("Camera"),
                        onTap: () {
                          Navigator.pop(context);
                          _pickImageFromCamera();
                        },
                      ),
                      ListTile(
                        leading: const Icon(Icons.photo),
                        title: const Text("Gallery"),
                        onTap: () {
                          Navigator.pop(context);
                          _pickImageFromGallery();
                        },
                      ),
                      const ListTile(
                        leading: Icon(Icons.file_present),
                        title: Text("File"),
                      ),
                    ],
                  ),
                );
              },
              child: const Text("Upload Photo"),
            ),
            if (selectedImage != null)
              Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: Image.file(
                  selectedImage!,
                  height: 200,
                  fit: BoxFit.cover,
                ),
              ),
            if (selectedFile != null)
              Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: Text("Selected File: ${selectedFile!.path}"),
              ),
            const SizedBox(height: 16),
            // Remark
            const Text("Remark",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            TextField(
              controller: remarkController,
              maxLines: 3,
              decoration: const InputDecoration(
                hintText: "Add remark",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            // Confirm Booking Button
            Center(
              child: ElevatedButton(
                onPressed: _showConfirmationDialog,
                child: const Text("Confirm Booking"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
