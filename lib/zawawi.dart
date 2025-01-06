import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

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
            onPressed: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/success');
            },
            child: const Text('Yes'),
          ),
        ],
      ),
    );
  }

  Widget _buildColoredTitle(String title) {
    final colors = [
      Colors.red,
      Colors.orange,
      Colors.yellow,
      Colors.green,
      Colors.blue,
      Colors.indigo,
      Colors.purple
    ];

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: title.split('').asMap().entries.map((entry) {
        final index = entry.key;
        final letter = entry.value;
        return Text(
          letter,
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: colors[index % colors.length],
          ),
        );
      }).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(50),
        child: AppBar(
          backgroundColor: const Color.fromARGB(255, 19, 34, 48),
          elevation: 0,
          automaticallyImplyLeading: false,
          title: _buildColoredTitle("LecturerMeet"),
        ),
      ),
      body: Container(
        color: const Color.fromARGB(255, 42, 71, 90),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Profile Picture and Name
              const Row(
                children: [
                  CircleAvatar(
                    radius: 40,
                    backgroundImage: AssetImage('assets/k.jpg'),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Zawawi bin Ismail@Abdul Wahab",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          "Phone: 012-3456789",
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.white70,
                          ),
                        ),
                      ],
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
                    onPressed: () {
                      // Schedule functionality
                    },
                    child: const Text(
                      'Schedule',
                      style: TextStyle(color: Color.fromARGB(255, 96, 56, 8)),
                    ),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 224, 204, 161),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 10,
                      ),
                    ),
                    onPressed: () {
                      // Room functionality
                    },
                    child: const Text(
                      'Room',
                      style: TextStyle(color: Color.fromARGB(255, 96, 56, 8)),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              const Text(
                "Booking Date",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(255, 180, 180, 180),
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
                        border: Border.all(color: Colors.white),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        selectedDate != null
                            ? "${selectedDate!.toLocal()}".split(' ')[0]
                            : "Select Date",
                        style:
                            const TextStyle(fontSize: 16, color: Colors.white),
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
                    icon: const Icon(Icons.calendar_today, color: Colors.white),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              const Text(
                "Booking Time",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(255, 180, 180, 180),
                ),
              ),
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
                            : null,
                        child: Container(
                          margin: const EdgeInsets.all(4),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color:
                                slot['available'] ? Colors.green : Colors.red,
                            border: Border.all(
                              color: selectedTime == slot['time'] &&
                                      slot['available']
                                  ? Colors.black
                                  : Colors.grey,
                              width: 2,
                            ),
                            borderRadius: BorderRadius.circular(20),
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
                    }).toList(),
                  );
                }).toList(),
              ),
              const SizedBox(height: 16),
              const Text(
                "Venue",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(255, 180, 180, 180),
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: DropdownButton<String>(
                      value: selectedVenue,
                      isExpanded: true,
                      dropdownColor: const Color.fromARGB(255, 19, 34, 48),
                      items: ["Lecturer's Room", "Other"].map((value) {
                        return DropdownMenuItem(
                          value: value,
                          child: Text(value,
                              style: const TextStyle(color: Colors.white)),
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
                      filled: true,
                      fillColor: Colors.white,
                    ),
                  ),
                ),
              const SizedBox(height: 16),
              const Text(
                "Upload Photo",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(255, 180, 180, 180),
                ),
              ),
              const SizedBox(height: 8),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 224, 204, 161),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 10,
                  ),
                ),
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
                child: const Text(
                  "Upload Photo",
                  style: TextStyle(color: Color.fromARGB(255, 96, 56, 8)),
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
                  color: Color.fromARGB(255, 180, 180, 180),
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: remarkController,
                maxLines: 3,
                decoration: const InputDecoration(
                  hintText: "Add remark",
                  border: OutlineInputBorder(),
                  filled: true,
                  fillColor: Color.fromARGB(255, 197, 195, 196),
                ),
              ),
              const SizedBox(height: 16),
              Center(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 224, 204, 161),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 10,
                    ),
                  ),
                  onPressed: _showConfirmationDialog,
                  child: const Text(
                    "Confirm Booking",
                    style: TextStyle(color: Color.fromARGB(255, 96, 56, 8)),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: const Color.fromARGB(255, 19, 34, 48),
        selectedItemColor: const Color.fromARGB(255, 75, 153, 193),
        unselectedItemColor: Colors.grey,
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
          debugPrint("Selected tab: $index");
        },
      ),
    );
  }
}
