import 'package:flutter/material.dart';

class TrackerPage extends StatelessWidget {
  final List<Map<String, dynamic>> childrenActivities;

  const TrackerPage({
    Key? key,
    required this.childrenActivities,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Activity Tracker"),
        backgroundColor: const Color.fromARGB(255, 238, 231, 155),
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
        child: ListView.builder(
          itemCount: childrenActivities.length,
          itemBuilder: (context, index) {
            final child = childrenActivities[index];
            final activities = child['activities'] as List<Map<String, String>>? ?? [];

            return Card(
              margin: const EdgeInsets.all(8.0),
              child: ExpansionTile(
                title: Text(
                  child['name'] ?? 'Unnamed Child',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                children: activities.map((activity) {
                  return _buildActivityTile(context, activity);
                }).toList(),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildActivityTile(BuildContext context, Map<String, String> activity) {
    String currentStatus = activity['status'] ?? 'Unknown';
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 5),
      child: ListTile(
        title: Text(activity['name'] ?? 'Unknown Activity'),
        subtitle: Text("Current Status: $currentStatus"),
        trailing: DropdownButton<String>(
          value: currentStatus,
          items: ['Ongoing', 'Done', 'Coming Soon']
              .map((status) => DropdownMenuItem(
                    value: status,
                    child: Text(status),
                  ))
              .toList(),
          onChanged: (newStatus) {
            if (newStatus != null) {
              activity['status'] = newStatus; // Update status dynamically
              (context as Element).markNeedsBuild(); // Refresh UI
            }
          },
        ),
      ),
    );
  }
}
