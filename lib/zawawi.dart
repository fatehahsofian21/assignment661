import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'roomZ.dart';
import 'dart:typed_data';
import 'package:image/image.dart' as img;
import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';

Widget displayImage(String base64String) {
  Uint8List bytes = base64Decode(base64String);
  return Image.memory(bytes, fit: BoxFit.cover);
}

class ZawawiPage extends StatefulWidget {
  const ZawawiPage({super.key});

  @override
  State<ZawawiPage> createState() => _ZawawiPageState();
}

class _ZawawiPageState extends State<ZawawiPage> {
  DateTime? selectedDate;
  String selectedVenue = "Lecturer's Room";
  TextEditingController otherVenueController = TextEditingController();
  TextEditingController remarkController = TextEditingController();
  File? selectedImage;

  final picker = ImagePicker();
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

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

  String? selectedTime;

  Future<void> _pickImageFromCamera() async {
    final pickedFile = await picker.pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      setState(() {
        selectedImage = File(pickedFile.path);
      });
    }
  }

  Future<void> _pickImageFromGallery() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        selectedImage = File(pickedFile.path);
      });
    }
  }

  Future<void> _uploadBookingData() async {
    try {
      if (selectedDate == null ||
          selectedTime == null ||
          (selectedVenue == "Other" && otherVenueController.text.isEmpty) ||
          remarkController.text.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Please fill in all required information!"),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("User not logged in!"),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }
      final userId = user.uid;

      final bookingRef = firestore
          .collection('users')
          .doc(userId)
          .collection('bookings')
          .doc();
      final String documentId = bookingRef.id;

      Map<String, dynamic> bookingData = {
        'documentId': documentId,
        'bookingDate': selectedDate?.toIso8601String(),
        'bookingTime': selectedTime,
        'venue': selectedVenue == "Other"
            ? otherVenueController.text
            : selectedVenue,
        'remark':
            remarkController.text.isNotEmpty ? remarkController.text : null,
        'status': 'active',
        'timestamp': FieldValue.serverTimestamp(),
      };

      if (selectedImage != null) {
        final imageBytes = await selectedImage!.readAsBytes();
        final img.Image? originalImage = img.decodeImage(imageBytes);
        if (originalImage != null) {
          final img.Image resizedImage = img.copyResize(
            originalImage,
            width: 800,
            height: 600,
          );
          final Uint8List compressedBytes = Uint8List.fromList(
            img.encodeJpg(resizedImage, quality: 70),
          );
          final String base64Image = base64Encode(compressedBytes);
          bookingData['photoBase64'] = base64Image;
        }
      }

      await bookingRef.set(bookingData);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Booking successfully stored!"),
          backgroundColor: Colors.green,
        ),
      );

      setState(() {
        selectedDate = null;
        selectedTime = null;
        selectedVenue = "Lecturer's Room";
        otherVenueController.clear();
        remarkController.clear();
        selectedImage = null;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Failed to store booking: $e"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _showSchedulePopup() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          contentPadding: const EdgeInsets.all(0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          content: ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: Image.asset(
              'assets/q.jpg',
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return const Center(
                  child: Text("Failed to load image"),
                );
              },
            ),
          ),
        );
      },
    );
  }

  void _showConfirmationDialog() {
    if (selectedDate == null ||
        selectedTime == null ||
        (selectedVenue == "Other" && otherVenueController.text.isEmpty) ||
        remarkController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
              "Please fill in all required information before confirming."),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirm Booking'),
        content: const Text('Are you sure you want to confirm this booking?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              final navigatorContext = Navigator.of(context);
              Navigator.pop(context);
              await _uploadBookingData();
              navigatorContext.pushNamed('/success');
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
        backgroundColor: const Color.fromARGB(255, 19, 34, 48),
        elevation: 0,
        title:
            const Text("Zawawi Booking", style: TextStyle(color: Colors.white)),
      ),
      body: Container(
        color: const Color.fromARGB(255, 42, 71, 90),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 10),
              CircleAvatar(
                radius: 55,
                backgroundImage: const AssetImage('assets/k.jpg'),
              ),
              const SizedBox(height: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text(
                    "Zawawi bin Ismail@Abdul Wahab",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const Text(
                    "Phone: 012-3456789",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white70,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 224, 204, 161),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 10,
                      ),
                    ),
                    onPressed: _showSchedulePopup,
                    child: const Text(
                      'Schedule',
                      style: TextStyle(color: Color.fromARGB(255, 96, 56, 8)),
                    ),
                  ),
                  const SizedBox(width: 16),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 224, 204, 161),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 10,
                      ),
                    ),
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const RoomZPage(),
                      ),
                    ),
                    child: const Text(
                      'Room',
                      style: TextStyle(color: Color.fromARGB(255, 96, 56, 8)),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Container(
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
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Booking Date",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 42, 42, 42),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 12,
                            ),
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
                              lastDate: DateTime.now().add(
                                const Duration(days: 365),
                              ),
                            );
                            setState(() {
                              selectedDate = date;
                              if (selectedDate != null) {
                                // Dynamically update availability based on the selected day
                                scheduleAvailability =
                                    _generateScheduleBasedOnDay(
                                        selectedDate!.weekday);
                              }
                            });
                          },
                          icon: const Icon(Icons.calendar_today),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      "Booking Time",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 42, 42, 42),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      alignment: WrapAlignment.center,
                      spacing: 8.0,
                      runSpacing: 8.0,
                      children: scheduleAvailability.expand((row) {
                        return row.map((slot) {
                          return GestureDetector(
                            onTap: slot['available']
                                ? () {
                                    setState(() {
                                      selectedTime = slot['time'];
                                    });
                                  }
                                : null,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 8,
                              ),
                              decoration: BoxDecoration(
                                color: slot['available']
                                    ? Colors.green
                                    : Colors.red,
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  color: selectedTime == slot['time'] &&
                                          slot['available']
                                      ? Colors.black
                                      : Colors.grey,
                                  width: 2,
                                ),
                              ),
                              child: Text(
                                slot['time'],
                                style: TextStyle(
                                  color: slot['available']
                                      ? Colors.black
                                      : Colors.white,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          );
                        });
                      }).toList(),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      "Upload Photo",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 42, 42, 42),
                      ),
                    ),
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
                            ],
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey[300],
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 10,
                        ),
                      ),
                      child: const Text(
                        "Upload Photo",
                        style: TextStyle(color: Colors.black),
                      ),
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
                    const SizedBox(height: 16),
                    const Text(
                      "Remark",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 42, 42, 42),
                      ),
                    ),
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
                    Center(
                      child: ElevatedButton(
                        onPressed: _showConfirmationDialog,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.grey[300],
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 10,
                          ),
                        ),
                        child: const Text(
                          "Confirm Booking",
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<List<Map<String, dynamic>>> _generateScheduleBasedOnDay(int weekday) {
    // Generate dynamic availability based on the weekday
    switch (weekday) {
      case DateTime.monday:
        return [
          [
            {"time": "8:00 AM", "available": true},
            {"time": "9:15 AM", "available": true},
            {"time": "10:30 AM", "available": false},
            {"time": "11:45 AM", "available": true},
          ],
          [
            {"time": "12:00 PM", "available": false},
            {"time": "1:15 PM", "available": true},
            {"time": "2:30 PM", "available": true},
            {"time": "3:45 PM", "available": false},
          ],
          [
            {"time": "4:00 PM", "available": true},
            {"time": "5:00 PM", "available": false},
          ],
        ];
      case DateTime.tuesday:
        return [
          [
            {"time": "8:00 AM", "available": false},
            {"time": "9:15 AM", "available": true},
            {"time": "10:30 AM", "available": true},
            {"time": "11:45 AM", "available": false},
          ],
          [
            {"time": "12:00 PM", "available": true},
            {"time": "1:15 PM", "available": false},
            {"time": "2:30 PM", "available": true},
            {"time": "3:45 PM", "available": true},
          ],
          [
            {"time": "4:00 PM", "available": false},
            {"time": "5:00 PM", "available": true},
          ],
        ];
      // Customize other weekdays as needed
      default:
        return scheduleAvailability;
    }
  }
}
