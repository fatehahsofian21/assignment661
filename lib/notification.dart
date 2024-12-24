import 'package:flutter/material.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({super.key});

  @override
  _NotificationPageState createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  // List to hold triggered notifications
  List<Map<String, String>> notifications = [];

  @override
  void initState() {
    super.initState();
    // Simulating retrieving notifications from a backend or local storage
    fetchNotifications();
  }

  void fetchNotifications() {
    // Example data: replace this with actual notification retrieval logic
    notifications = [
      {"title": "Study Reminder", "body": "Time to study!"},
      {"title": "Homework Reminder", "body": "10 minutes until homework."},
      {"title": "Playtime Reminder", "body": "Time for playtime!"},
    ];
    setState(() {}); // Update the UI
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Notifications"),
      ),
      body: notifications.isEmpty
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
                      color: Colors.blue,
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
    );
  }
}
