import 'package:flutter/material.dart';

import 'dart:io';

class MainPage2 extends StatefulWidget {
  const MainPage2({super.key});

  @override
  State<MainPage2> createState() => _MainPage2State();
}

class _MainPage2State extends State<MainPage2> {
  List<Map<String, dynamic>> children = [];

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
                    // Name Input
                    TextField(
                      controller: nameController,
                      decoration: const InputDecoration(
                        labelText: "Child's Name",
                        hintText: "Enter child's name",
                      ),
                    ),
                    const SizedBox(height: 10),

                    // Add/Take Picture
                    GestureDetector(
                      child: Container(
                        width: double.infinity,
                        height: 150,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: Colors.grey.shade400,
                          ),
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
                            : Image.file(
                                childPhoto,
                                fit: BoxFit.cover,
                              ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Activity Reminders
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
                    Navigator.pop(context); // Close the dialog
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
                        });
                      });
                      Navigator.pop(context); // Close the dialog
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
      backgroundColor: const Color(0xFFFFF5E1), // Cream background color
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            const SizedBox(height: 30),

            // Child Cards Section
            Expanded(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 15,
                  mainAxisSpacing: 15,
                ),
                itemCount: children.length + 1,
                itemBuilder: (context, index) {
                  if (index == children.length) {
                    return GestureDetector(
                      onTap: _addChild,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
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
                            Icon(
                              Icons.add_circle_outline,
                              size: 50,
                              color: Colors.grey.shade600,
                            ),
                            const SizedBox(height: 10),
                            const Text(
                              "Add Child",
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.black,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }

                  final child = children[index];
                  return Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
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
                            width: 80,
                            height: 80,
                            fit: BoxFit.cover,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          child["name"],
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
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
