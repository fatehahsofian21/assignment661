import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'profile_page.dart'; // Import the profile page
import 'notification.dart'; // Import the notification page

class MainPage extends StatefulWidget {
  final String userName;

  const MainPage({super.key, required this.userName});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  late String userName;
  List<Map<String, dynamic>> children = [];
  late FlutterLocalNotificationsPlugin localNotifications;

  @override
  void initState() {
    super.initState();
    userName = widget.userName;
    initializeNotifications();
  }

  void initializeNotifications() {
    tz.initializeTimeZones();
    localNotifications = FlutterLocalNotificationsPlugin();

    const AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings initSettings =
        InitializationSettings(android: androidSettings);

    localNotifications.initialize(initSettings,
        onDidReceiveNotificationResponse: (details) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => NotificationPage()),
      );
    });
  }

  void scheduleNotification(String title, String body, DateTime scheduledTime) {
    localNotifications.zonedSchedule(
      0,
      title,
      body,
      tz.TZDateTime.from(scheduledTime, tz.local),
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'main_channel',
          'Main Channel',
          importance: Importance.high,
          priority: Priority.high,
        ),
      ),
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
    );
  }

  void _addChild() async {
    String childName = '';
    File? childPhoto;
    Map<String, TimeOfDay> activityTimes = {
      "Homework": const TimeOfDay(hour: 17, minute: 0),
      "Study": const TimeOfDay(hour: 19, minute: 0),
      "Sleep": const TimeOfDay(hour: 21, minute: 0),
      "Eat": const TimeOfDay(hour: 12, minute: 0),
      "Playtime": const TimeOfDay(hour: 15, minute: 0),
    };

    TextEditingController nameController = TextEditingController();

    await showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text("Add Child"),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: nameController,
                      decoration: const InputDecoration(
                        labelText: "Child's Name",
                        hintText: "Enter child's name",
                      ),
                    ),
                    const SizedBox(height: 10),
                    GestureDetector(
                      onTap: () async {
                        final ImagePicker picker = ImagePicker();
                        final XFile? pickedFile = await picker.pickImage(
                          source: ImageSource.gallery,
                        );

                        if (pickedFile != null) {
                          setState(() {
                            childPhoto = File(pickedFile.path);
                          });
                        }
                      },
                      child: Container(
                        width: double.infinity,
                        height: 150,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: Colors.grey.shade400),
                        ),
                        child: childPhoto == null
                            ? const Center(
                                child: Text(
                                  "Tap to add photo",
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontStyle: FontStyle.italic,
                                  ),
                                ),
                              )
                            : Image.file(childPhoto!, fit: BoxFit.cover),
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      "Activity Reminders:",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    ...activityTimes.keys.map((activity) {
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(activity),
                          TextButton(
                            onPressed: () async {
                              TimeOfDay? pickedTime = await showTimePicker(
                                context: context,
                                initialTime: activityTimes[activity]!,
                              );

                              if (pickedTime != null) {
                                setState(() {
                                  activityTimes[activity] = pickedTime;
                                });

                                // Schedule notifications
                                final now = DateTime.now();
                                final activityDateTime = DateTime(
                                  now.year,
                                  now.month,
                                  now.day,
                                  pickedTime.hour,
                                  pickedTime.minute,
                                );

                                scheduleNotification(
                                  "$activity Reminder",
                                  "$activity for $childName in 10 minutes!",
                                  activityDateTime.subtract(
                                      const Duration(minutes: 10)),
                                );

                                scheduleNotification(
                                  "$activity Reminder",
                                  "Time for $activity for $childName!",
                                  activityDateTime,
                                );
                              }
                            },
                            child: Text(
                              activityTimes[activity]!.format(context),
                              style: const TextStyle(color: Colors.green),
                            ),
                          ),
                        ],
                      );
                    }),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text("Cancel"),
                ),
                TextButton(
                  onPressed: () {
                    if (nameController.text.isNotEmpty && childPhoto != null) {
                      setState(() {
                        children.add({
                          "name": nameController.text,
                          "photo": childPhoto,
                          "activityTimes": activityTimes,
                          "dob": null,
                          "age": null,
                          "color": Colors.pink.shade100, // Default pastel color
                          "fontColor": Colors.black, // Default font color
                        });
                      });
                      Navigator.pop(context);
                    }
                  },
                  child: const Text("Save"),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _editChildDetails(int index) async {
    TextEditingController nameController =
        TextEditingController(text: children[index]["name"]);
    TextEditingController dobController =
        TextEditingController(text: children[index]["dob"]);
    TextEditingController ageController =
        TextEditingController(text: children[index]["age"]?.toString() ?? '');
    Color selectedColor = children[index]["color"];
    Color selectedFontColor = children[index]["fontColor"] ?? Colors.black; // Default to black
    Map<String, TimeOfDay> activityTimes = children[index]["activityTimes"];

    await showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text("Edit Child Details"),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: nameController,
                      decoration: const InputDecoration(
                        labelText: "Child's Name",
                        hintText: "Enter child's name",
                      ),
                    ),
                    TextField(
                      controller: dobController,
                      decoration: const InputDecoration(
                        labelText: "Date of Birth",
                        hintText: "Enter date of birth",
                      ),
                    ),
                    TextField(
                      controller: ageController,
                      decoration: const InputDecoration(
                        labelText: "Age",
                        hintText: "Enter age",
                      ),
                      keyboardType: TextInputType.number,
                    ),
                    const SizedBox(height: 10),
                    const Text("Edit Activity Times:"),
                    ...activityTimes.keys.map((activity) {
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(activity),
                          TextButton(
                            onPressed: () async {
                              TimeOfDay? pickedTime = await showTimePicker(
                                context: context,
                                initialTime: activityTimes[activity]!,
                              );

                              if (pickedTime != null) {
                                setState(() {
                                  activityTimes[activity] = pickedTime;
                                });
                              }
                            },
                            child: Text(
                              activityTimes[activity]!.format(context),
                              style: const TextStyle(color: Colors.green),
                            ),
                          ),
                        ],
                      );
                    }).toList(),
                    const SizedBox(height: 10),
                    const Text("Select Card Color:"),
                    Wrap(
                      spacing: 8,
                      children: [
                        Colors.pink.shade100,
                        Colors.blue.shade100,
                        Colors.green.shade100,
                        Colors.yellow.shade100,
                        Colors.orange.shade100,
                        Colors.purple.shade100,
                        Colors.teal.shade100,
                      ].map((color) {
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              selectedColor = color;
                            });
                          },
                          child: Container(
                            width: 30,
                            height: 30,
                            decoration: BoxDecoration(
                              color: color,
                              border: Border.all(
                                color: selectedColor == color
                                    ? Colors.black
                                    : Colors.transparent,
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 10),
                    const Text("Select Font Color:"),
                    Wrap(
                      spacing: 8,
                      children: [
                        Colors.black,
                        Colors.white,
                        Colors.green,
                        Colors.blue,
                        Colors.purple,
                        Colors.teal,
                      ].map((color) {
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              selectedFontColor = color;
                            });
                          },
                          child: Container(
                            width: 30,
                            height: 30,
                            decoration: BoxDecoration(
                              color: color,
                              border: Border.all(
                                color: selectedFontColor == color
                                    ? Colors.black
                                    : Colors.transparent,
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text("Cancel"),
                ),
                TextButton(
                  onPressed: () {
                    setState(() {
                      children[index]["name"] = nameController.text;
                      children[index]["dob"] = dobController.text;
                      children[index]["age"] = int.tryParse(ageController.text);
                      children[index]["color"] = selectedColor;
                      children[index]["fontColor"] = selectedFontColor;
                      children[index]["activityTimes"] = activityTimes;
                    });
                    Navigator.pop(context);
                  },
                  child: const Text("Save"),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _deleteChild(int index) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Delete Child"),
          content: const Text("Are you sure you want to delete this child?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  children.removeAt(index);
                });
                Navigator.pop(context);
              },
              child: const Text("Delete"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color.fromARGB(255, 238, 231, 155),
              Color.fromARGB(255, 208, 119, 119),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Column(
          children: [
            // Header Section
            Container(
              padding: const EdgeInsets.all(30),
              height: 180,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFFEA4C89), Color(0xFFF58BA1)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 15),
                      Text(
                        "Welcome Back",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        userName,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 28,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => NotificationPage(),
                        ),
                      );
                    },
                    child: Container(
                      width: 70,
                      height: 70,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                      ),
                      child: const Icon(
                        Icons.notifications_active,
                        size: 40,
                        color: Color(0xFFEA4C89),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Add Child Button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 70.0),
              child: GestureDetector(
                onTap: _addChild,
                child: Container(
                  height: 50,
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 235, 122, 186),
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.3),
                        blurRadius: 5,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      SizedBox(width: 6),
                      Text(
                        "Add Child",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Child Cards Section
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: children.asMap().entries.map((entry) {
                    int index = entry.key;
                    Map<String, dynamic> child = entry.value;

                    return GestureDetector(
                      onTap: () => _editChildDetails(index),
                      child: Container(
                        margin: const EdgeInsets.only(right: 15),
                        width: 180,
                        decoration: BoxDecoration(
                          color: child["color"],
                          borderRadius: BorderRadius.circular(15),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.3),
                              blurRadius: 5,
                              spreadRadius: 2,
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            Align(
                              alignment: Alignment.topRight,
                              child: PopupMenuButton<String>(
                                onSelected: (value) {
                                  if (value == "Edit") {
                                    _editChildDetails(index);
                                  } else if (value == "Delete") {
                                    _deleteChild(index);
                                  }
                                },
                                itemBuilder: (context) => [
                                  const PopupMenuItem<String>(
                                    value: "Edit",
                                    child: Text("Edit"),
                                  ),
                                  const PopupMenuItem<String>(
                                    value: "Delete",
                                    child: Text("Delete"),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 10),
                            Center(
                              child: ClipOval(
                                child: Image.file(
                                  child["photo"],
                                  width: 80,
                                  height: 80,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              "${child["name"]}'s",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 25,
                                fontWeight: FontWeight.bold,
                                color: child["fontColor"] ?? Colors.black, // Default to black
                              ),
                            ),
                            Text(
                              "Activity",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: child["fontColor"] ?? Colors.black, // Default to black
                              ),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              "Age: ${child["age"]?? "N/A"} years old",
                              style: TextStyle(
                                fontSize: 18,
                                color: child["fontColor"] ?? Colors.black, // Apply font color
                              ),
                            ),
                            const SizedBox(height: 5),
                            Text(
                              "DOB: ${child["dob"] ?? "N/A"}",
                              style: TextStyle(
                                fontSize: 18,
                                color: child["fontColor"] ?? Colors.black, // Apply font color
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
