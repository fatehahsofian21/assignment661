import 'dart:async';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'bookL.dart';
import 'profileL.dart';

class MainPageL extends StatefulWidget {
  final String email;
  const MainPageL({Key? key, required this.email}) : super(key: key);

  @override
  _MainPageLState createState() => _MainPageLState();
}

class _MainPageLState extends State<MainPageL> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<String> images = [
    'assets/1.jpg',
    'assets/2.jpg',
    'assets/3.jpg',
  ];

  String firstName = "Lecturer";

  DateTime selectedDate = DateTime.now();
  Map<int, String> notes = {};
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
    _loadLecturerData();
    fetchNotes();
    Timer.periodic(const Duration(seconds: 3), (Timer timer) {
      if (_currentPage < images.length - 1) {
        _currentPage++;
      } else {
        _currentPage = 0;
      }

      if (_pageController.hasClients) {
        _pageController.animateToPage(
          _currentPage,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  Future<void> _loadLecturerData() async {
    try {
      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .where('email', isEqualTo: widget.email)
          .get();

      if (userDoc.docs.isNotEmpty) {
        final data = userDoc.docs.first.data();
        setState(() {
          firstName = data['firstName'] ?? "Lecturer";
        });
      } else {
        debugPrint("User with email ${widget.email} not found.");
      }
    } catch (e) {
      debugPrint("Error loading lecturer data: $e");
    }
  }

  Future<void> fetchNotes() async {
    try {
      final querySnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.email) // Using email as document ID
          .collection('events')
          .get();

      setState(() {
        notes = {};
        for (var doc in querySnapshot.docs) {
          final data = doc.data();
          final day = int.tryParse(data['day']?.toString() ?? '');
          final note = data['note']?.toString() ?? '';

          if (day != null && note.isNotEmpty) {
            notes[day] = note;
          }
        }
      });
    } catch (e) {
      debugPrint("Error fetching notes: $e");
    }
  }

  Future<void> addOrUpdateNoteInFirestore(int day, String note) async {
    try {
      final eventDoc = FirebaseFirestore.instance
          .collection('users')
          .doc(widget.email) // Using email as document ID
          .collection('events')
          .doc('$day-${selectedDate.month}-${selectedDate.year}');

      await eventDoc.set({
        'day': day,
        'month': selectedDate.month,
        'year': selectedDate.year,
        'note': note,
      });

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

  Future<void> deleteNoteInFirestore(int day) async {
    try {
      final eventDoc = FirebaseFirestore.instance
          .collection('users')
          .doc(widget.email)
          .collection('events')
          .doc('$day-${selectedDate.month}-${selectedDate.year}');

      await eventDoc.delete();

      setState(() {
        notes.remove(day);
      });

      Fluttertoast.showToast(
        msg: "Event deleted successfully",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        backgroundColor: Colors.green,
        textColor: Colors.white,
      );
    } catch (e) {
      debugPrint("Error deleting note: $e");
    }
  }

  void _onDateSelected(int day) {
    String newNote = notes[day] ?? "";
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          title: Text(notes.containsKey(day) ? 'Edit Note' : 'Add Note'),
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
                      color: Color.fromARGB(255, 181, 178, 178),
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

  @override
  Widget build(BuildContext context) {
    final int currentMonth = selectedDate.month;
    final int currentYear = selectedDate.year;
    final int daysInMonth = DateTime(currentYear, currentMonth + 1, 0).day;
    final int firstWeekday = DateTime(currentYear, currentMonth, 1).weekday;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 19, 34, 48),
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            CircleAvatar(
              radius: 20,
              backgroundColor: Colors.white,
              backgroundImage: const AssetImage('assets/k.jpg'),
            ),
            const SizedBox(width: 10),
            Text(
              "Welcome!",
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
      body: Container(
        color: const Color.fromARGB(255, 235, 218, 181),
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Image Carousel Section
              SizedBox(
                height: 200,
                child: PageView.builder(
                  controller: _pageController,
                  itemCount: images.length,
                  itemBuilder: (context, index) {
                    return Image.asset(
                      images[index],
                      fit: BoxFit.cover,
                    );
                  },
                ),
              ),
              // Calendar Section
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 16.0, vertical: 16.0),
                child: Container(
                  padding: const EdgeInsets.all(16.0),
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
                  child: Column(
                    children: [
                      Text(
                        '${months[currentMonth]} $currentYear',
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Table(
                        border: TableBorder.all(
                          color: const Color.fromARGB(255, 0, 0, 0),
                        ),
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
                                  color:
                                      const Color.fromARGB(255, 197, 154, 186),
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
                          ..._buildCalendarRows(
                            daysInMonth,
                            firstWeekday,
                            currentMonth,
                            currentYear,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: const Color.fromARGB(255, 19, 34, 48),
        selectedItemColor: const Color.fromARGB(255, 224, 204, 161),
        unselectedItemColor: Colors.white,
        onTap: (index) {
          if (index == 1) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const BookLPage()),
            );
          } else if (index == 2) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const ProfileLPage()),
            );
          }
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history),
            label: "Booking History",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: "My Acc",
          ),
        ],
      ),
    );
  }
}
