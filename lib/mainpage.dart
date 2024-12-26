import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'notification.dart'; // Import the notification page
import 'profile_page.dart'; // Import the profile page

class MainPage extends StatefulWidget {
  final String userName;

  const MainPage({super.key, required this.userName});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  late String userName;
  List<Map<String, dynamic>> children = [];
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    userName = widget.userName;
  }

  void _onItemTapped(int index) {
    if (index == 1) {
      // Navigate to ProfilePage
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ProfilePage(
            userName: userName,
            email: "user@example.com", // Replace with actual email
            dateOfBirth: "1990-01-01", // Replace with actual DOB
            gender: "Female", // Replace with actual gender
          ),
        ),
      );
    } else {
      setState(() {
        _selectedIndex = index;
      });
    }
  }

  void _addChild({Map<String, dynamic>? existingChild}) async {
    String childName = existingChild?["name"] ?? '';
    File? childPhoto = existingChild?["photo"];
    String dob = existingChild?["dob"] ?? '';
    int? age = existingChild?["age"];
    Color cardColor = existingChild?["color"] ?? Colors.pink.shade100;
    Color fontColor = existingChild?["fontColor"] ?? Colors.black;
    Map<String, TimeOfDay> activityTimes = existingChild?["activityTimes"] ??
        {
          "Study": const TimeOfDay(hour: 17, minute: 0),
          "Playtime": const TimeOfDay(hour: 15, minute: 0),
          "Eat": const TimeOfDay(hour: 12, minute: 0),
          "Homework": const TimeOfDay(hour: 19, minute: 0),
          "Sleep": const TimeOfDay(hour: 21, minute: 0),
        };

    TextEditingController nameController =
        TextEditingController(text: childName);
    TextEditingController dobController = TextEditingController(text: dob);

    await showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text(existingChild == null ? "Add Child" : "Edit Child"),
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
                    TextField(
                      controller: dobController,
                      decoration: const InputDecoration(
                        labelText: "Date of Birth (YYYY-MM-DD)",
                        hintText: "Enter DOB",
                      ),
                      onTap: () async {
                        DateTime? pickedDate = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(2000),
                          lastDate: DateTime.now(),
                        );
                        if (pickedDate != null) {
                          setState(() {
                            dob =
                                "${pickedDate.year}-${pickedDate.month.toString().padLeft(2, '0')}-${pickedDate.day.toString().padLeft(2, '0')}";
                            dobController.text = dob;
                            age = DateTime.now().year - pickedDate.year;
                          });
                        }
                      },
                    ),
                    const SizedBox(height: 10),
                    GestureDetector(
                      onTap: () async {
                        final ImagePicker picker = ImagePicker();
                        await showModalBottomSheet(
                          context: context,
                          builder: (context) {
                            return Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                ListTile(
                                  leading: const Icon(Icons.photo),
                                  title: const Text("Pick from Gallery"),
                                  onTap: () async {
                                    final XFile? pickedFile =
                                        await picker.pickImage(
                                      source: ImageSource.gallery,
                                    );
                                    if (pickedFile != null) {
                                      setState(() {
                                        childPhoto = File(pickedFile.path);
                                      });
                                    }
                                    Navigator.pop(context);
                                  },
                                ),
                                ListTile(
                                  leading: const Icon(Icons.camera),
                                  title: const Text("Take a Photo"),
                                  onTap: () async {
                                    final XFile? pickedFile =
                                        await picker.pickImage(
                                      source: ImageSource.camera,
                                    );
                                    if (pickedFile != null) {
                                      setState(() {
                                        childPhoto = File(pickedFile.path);
                                      });
                                    }
                                    Navigator.pop(context);
                                  },
                                ),
                              ],
                            );
                          },
                        );
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
                        Colors.brown.shade100,
                      ].map((color) {
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              cardColor = color;
                            });
                          },
                          child: Container(
                            width: 30,
                            height: 30,
                            decoration: BoxDecoration(
                              color: color,
                              border: Border.all(
                                color: cardColor == color
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
                        Colors.orange,
                        Colors.brown,
                      ].map((color) {
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              fontColor = color;
                            });
                          },
                          child: Container(
                            width: 30,
                            height: 30,
                            decoration: BoxDecoration(
                              color: color,
                              border: Border.all(
                                color: fontColor == color
                                    ? Colors.black
                                    : Colors.transparent,
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      "Activity Times:",
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
                              }
                            },
                            child: Text(
                              activityTimes[activity]!.format(context),
                              style: const TextStyle(color: Colors.blue),
                            ),
                          ),
                        ],
                      );
                    }).toList(),
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
                    if (nameController.text.isNotEmpty &&
                        dob.isNotEmpty &&
                        childPhoto != null) {
                      setState(() {
                        if (existingChild == null) {
                          children.add({
                            "name": nameController.text,
                            "photo": childPhoto,
                            "dob": dob,
                            "age": age,
                            "activityTimes": activityTimes,
                            "color": cardColor,
                            "fontColor": fontColor,
                          });
                        } else {
                          existingChild["name"] = nameController.text;
                          existingChild["photo"] = childPhoto;
                          existingChild["dob"] = dob;
                          existingChild["age"] = age;
                          existingChild["activityTimes"] = activityTimes;
                          existingChild["color"] = cardColor;
                          existingChild["fontColor"] = fontColor;
                        }
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
                      const Text(
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
                          builder: (context) =>
                              NotificationPage(children: children),
                        ),
                      );
                    },
                    child: Container(
                      width: 80,
                      height: 80,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Color.fromARGB(255, 245, 209, 209),
                      ),
                      child: const Icon(
                        Icons.notifications_active,
                        size: 50,
                        color: Color.fromARGB(255, 234, 76, 137),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            // Add Child Button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 70.0),
              child: GestureDetector(
                onTap: () => _addChild(),
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
                  child: const Center(
                    child: Text(
                      "Add Child",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),
            // Child Cards Section
            SizedBox(
              height: 300, // Ensure consistent card height
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: children.map((child) {
                  return Stack(
                    children: [
                      GestureDetector(
                        onTap: () => _addChild(existingChild: child),
                        child: Container(
                          margin: const EdgeInsets.all(10),
                          width: 180, // Ensure consistent card width
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
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              ClipOval(
                                child: Image.file(
                                  child["photo"],
                                  width: 100,
                                  height: 100,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              const SizedBox(height: 10),
                              Text(
                                "${child["name"]}'s",
                                style: TextStyle(
                                  fontSize: 25,
                                  fontWeight: FontWeight.bold,
                                  color: child["fontColor"],
                                ),
                              ),
                              Text(
                                "Age: ${child["age"] ?? "N/A"}",
                                style: TextStyle(
                                  fontSize: 18,
                                  color: child["fontColor"],
                                ),
                              ),
                              Text(
                                "DOB: ${child["dob"]}",
                                style: TextStyle(
                                  fontSize: 16,
                                  color: child["fontColor"],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Positioned(
                        top: 10,
                        right: 10,
                        child: PopupMenuButton<String>(
                          onSelected: (value) {
                            if (value == "Delete") {
                              showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    title: const Text("Delete Child"),
                                    content: const Text(
                                        "Are you sure you want to delete this child?"),
                                    actions: [
                                      TextButton(
                                        onPressed: () =>
                                            Navigator.pop(context),
                                        child: const Text("No"),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          setState(() {
                                            children.remove(child);
                                          });
                                          Navigator.pop(context);
                                        },
                                        child: const Text("Yes"),
                                      ),
                                    ],
                                  );
                                },
                              );
                            }
                          },
                          itemBuilder: (context) => [
                            const PopupMenuItem<String>(
                              value: "Delete",
                              child: Text("Delete"),
                            ),
                          ],
                          icon: const Icon(Icons.more_vert),
                        ),
                      ),
                    ],
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: const Color.fromARGB(255, 235, 152, 184),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.pink,
        unselectedItemColor: const Color.fromARGB(255, 71, 70, 70),
        onTap: _onItemTapped,
      ),
    );
  }
}
