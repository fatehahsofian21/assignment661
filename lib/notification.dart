import 'package:flutter/material.dart';
import 'dart:math';

class NotificationPage extends StatefulWidget {
  final List<Map<String, dynamic>> children;

  const NotificationPage({super.key, required this.children});

  @override
  _NotificationPageState createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  List<Map<String, String>> notifications = [];

  @override
  void initState() {
    super.initState();
    generateNotifications();
  }

  void generateNotifications() {
    notifications.clear();
    final now = DateTime.now();

    for (var child in widget.children) {
      final childName = child["name"] ?? "Child";
      final activityTimes = child["activityTimes"] as Map<String, TimeOfDay>;

      activityTimes.forEach((activity, time) {
        final activityTime = DateTime(
          now.year,
          now.month,
          now.day,
          time.hour,
          time.minute,
        );

        // Add a notification 5 minutes before the activity
        if (activityTime.isAfter(now)) {
          notifications.add({
            "title": "$activity Reminder",
            "body": "$childName's $activity starts in 5 minutes!",
          });

          // Add a notification for the exact activity time
          notifications.add({
            "title": "$activity Reminder",
            "body": "It's time for $childName's $activity!",
          });
        }
      });
    }

    // Randomize the order of notifications
    notifications.shuffle(Random());

    setState(() {}); // Refresh the UI
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Notifications"),
        backgroundColor: const Color(0xFFF58BA1),
      ),
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
        child: notifications.isEmpty
            ? const Center(
                child: Text(
                  "No notifications yet.",
                  style: TextStyle(fontSize: 18, color: Colors.grey),
                ),
              )
            : ListView.builder(
                itemCount: notifications.length,
                itemBuilder: (context, index) {
                  final notification = notifications[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(
                        horizontal: 16.0, vertical: 8.0),
                    child: ListTile(
                      leading: const Icon(
                        Icons.notifications,
                        color: Color.fromARGB(255, 234, 76, 137),
                      ),
                      title: Text(
                        notification["title"]!,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Text(notification["body"]!),
                    ),
                  );
                },
              ),
      ),
    );
  }
}
