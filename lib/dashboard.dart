import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class DashboardPage extends StatefulWidget {
  final String userName;

  const DashboardPage({Key? key, required this.userName}) : super(key: key);

  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  final Map<int, String> months = {
    1: 'January',
    2: 'February',
    3: 'March',
    4: 'April',
    5: 'May',
    6: 'June',
    7: 'July',
    8: 'August',
    9: 'September',
    10: 'October',
    11: 'November',
    12: 'December',
  };

  DateTime selectedDate = DateTime.now();
  Map<int, String> notes = {};
  final List<Color> pastelColors = [
    Colors.pink.shade100,
    Colors.blue.shade100,
    Colors.green.shade100,
    Colors.purple.shade100,
    Colors.orange.shade100,
    Colors.yellow.shade100,
    Colors.teal.shade100,
    Colors.red.shade100,
  ];

  @override
  void initState() {
    super.initState();
    fetchNotes();
  }

  /// Fetch notes from Firestore
  Future<void> fetchNotes() async {
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('events')
          .doc('${selectedDate.month}-${selectedDate.year}')
          .get();

      if (snapshot.exists) {
        final data = snapshot.data() as Map<String, dynamic>;
        setState(() {
          notes = data
              .map((key, value) => MapEntry(int.parse(key), value.toString()));
        });
      }
    } catch (e) {
      debugPrint("Error fetching notes: $e");
    }
  }

  /// Add or update a note in Firestore
  Future<void> addOrUpdateNoteInFirestore(int day, String note) async {
    try {
      final docRef = FirebaseFirestore.instance
          .collection('events')
          .doc('${selectedDate.month}-${selectedDate.year}');

      final snapshot = await docRef.get();

      if (snapshot.exists) {
        await docRef.update({'$day': note});
      } else {
        await docRef.set({'$day': note});
      }

      setState(() {
        notes[day] = note;
      });

      Fluttertoast.showToast(
        msg: "Event saved successfully",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        backgroundColor: Colors.green,
        textColor: Colors.white,
      );
    } catch (e) {
      debugPrint("Error adding/updating note: $e");
    }
  }

  /// Delete a note from Firestore
  Future<void> deleteNoteInFirestore(int day) async {
    bool? confirm = await showDialog(
      context: context,
      barrierDismissible: false, // Prevent dismissing by clicking outside
      builder: (context) => AlertDialog(
        title: const Text('Delete Event'),
        content: const Text('Are you sure you want to delete this event?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirm == true) {
      try {
        final docRef = FirebaseFirestore.instance
            .collection('events')
            .doc('${selectedDate.month}-${selectedDate.year}');

        final snapshot = await docRef.get();

        if (snapshot.exists) {
          final data = snapshot.data() as Map<String, dynamic>;
          data.remove('$day');
          if (data.isEmpty) {
            await docRef.delete();
          } else {
            await docRef.set(data);
          }

          setState(() {
            notes.remove(day);
          });

          Fluttertoast.showToast(
            msg: "Event successfully deleted",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            backgroundColor: Colors.green,
            textColor: Colors.white,
          );
        }
      } catch (e) {
        debugPrint("Error deleting note: $e");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final int currentMonth = selectedDate.month;
    final int currentYear = selectedDate.year;
    final int daysInMonth = DateTime(currentYear, currentMonth + 1, 0).day;
    final int firstWeekday = DateTime(currentYear, currentMonth, 1).weekday;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 19, 34, 48),
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            const CircleAvatar(
              child: Text('W'),
            ),
            const SizedBox(width: 10),
            Text(
              'Welcome ${widget.userName}',
              style: const TextStyle(fontSize: 18, color: Colors.white),
            ),
          ],
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.notifications, color: Colors.white),
          ),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color.fromARGB(255, 42, 71, 90),
              Color.fromARGB(255, 19, 34, 48),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          Navigator.pushNamed(context, '/mainpage');
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blueAccent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: const Center(
                          child: Padding(
                            padding: EdgeInsets.symmetric(vertical: 12.0),
                            child: Text(
                              '+ Make Appointment',
                              style:
                                  TextStyle(fontSize: 18, color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.grey.shade200,
                        ),
                        child: Column(
                          children: [
                            Text(
                              '${months[currentMonth]} $currentYear',
                              style: const TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 10),
                            Table(
                              border: TableBorder.all(color: Colors.grey),
                              children: [
                                TableRow(
                                  children: [
                                    for (String day in [
                                      'Mon',
                                      'Tue',
                                      'Wed',
                                      'Thu',
                                      'Fri',
                                      'Sat',
                                      'Sun'
                                    ])
                                      Container(
                                        padding: const EdgeInsets.all(8),
                                        color: Colors.blueAccent,
                                        child: Center(
                                          child: Text(
                                            day,
                                            style: const TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                                ..._buildCalendarRows(daysInMonth, firstWeekday,
                                    currentMonth, currentYear),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 25),
                      const Text(
                        "What's New",
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          Expanded(
                            child: Container(
                              height: 100,
                              decoration: BoxDecoration(
                                color: Colors.orangeAccent,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: const Center(
                                child: Text(
                                  'New Event',
                                  style:
                                      TextStyle(fontSize: 18, color: Colors.white),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Container(
                              height: 100,
                              decoration: BoxDecoration(
                                color: Colors.greenAccent,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: const Center(
                                child: Text(
                                  'New Event',
                                  style:
                                      TextStyle(fontSize: 18, color: Colors.white),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: const Color.fromARGB(255, 19, 34, 48),
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.check_circle),
            label: 'My Booking',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'My Acc',
          ),
        ],
      ),
    );
  }

  List<TableRow> _buildCalendarRows(
      int daysInMonth, int firstWeekday, int currentMonth, int currentYear) {
    List<TableRow> rows = [];
    List<Widget> cells = [];

    for (int i = 1; i < firstWeekday; i++) {
      cells.add(Container());
    }

    for (int day = 1; day <= daysInMonth; day++) {
      cells.add(
        GestureDetector(
          onTap: () => _onDateSelected(day),
          child: Container(
            height: 50,
            decoration: BoxDecoration(
              color: notes.containsKey(day)
                  ? pastelColors[day % pastelColors.length]
                  : Colors.transparent,
              shape: BoxShape.rectangle,
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                if (DateTime.now().day == day &&
                    DateTime.now().month == currentMonth &&
                    DateTime.now().year == currentYear)
                  Container(
                    height: 40,
                    width: 40,
                    decoration: const BoxDecoration(
                      color: Colors.blue,
                      shape: BoxShape.circle,
                    ),
                  ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      day.toString(),
                      style: const TextStyle(fontSize: 16),
                    ),
                    if (notes.containsKey(day))
                      const Text(
                        'Event',
                        style: TextStyle(fontSize: 10, color: Colors.red),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ),
      );

      if (cells.length == 7) {
        rows.add(TableRow(children: cells));
        cells = [];
      }
    }

    if (cells.isNotEmpty) {
      for (int i = cells.length; i < 7; i++) {
        cells.add(Container());
      }
      rows.add(TableRow(children: cells));
    }

    return rows;
  }

  void _onDateSelected(int day) {
    String newNote = notes[day] ?? "";
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          title: Text(notes.containsKey(day)
              ? 'Edit Note for $day'
              : 'Add Note for $day'),
          content: TextField(
            onChanged: (value) => newNote = value,
            controller: TextEditingController(text: newNote),
            decoration: const InputDecoration(hintText: "Enter your note"),
          ),
          actions: [
            if (notes.containsKey(day))
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  deleteNoteInFirestore(day);
                },
                child:
                    const Text('Delete', style: TextStyle(color: Colors.red)),
              ),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                if (newNote.isNotEmpty) {
                  addOrUpdateNoteInFirestore(day, newNote);
                }
                Navigator.pop(context);
              },
              child: Text(notes.containsKey(day) ? 'Update' : 'Save'),
            ),
          ],
        );
      },
    );
  }
}