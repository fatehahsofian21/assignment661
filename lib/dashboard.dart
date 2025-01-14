import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'profileS.dart';
import 'package:firebase_auth/firebase_auth.dart';

class DashboardPage extends StatefulWidget {
  final String userName;

  const DashboardPage({Key? key, required this.userName}) : super(key: key);

  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  String? userName;
  String? profilePicture;
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
  bool isLoading = true;
  String? firestoreName;

  @override
  void initState() {
    super.initState();
    fetchUserDataFromFirestore();
    fetchNotes().then((_) {
      setState(() {
        isLoading = false;
      });
    });
  }

  void fetchUserDataFromFirestore() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      try {
        final doc = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .get();
        setState(() {
          firestoreName = doc.data()?['name']?.split(' ')[0] ?? "User";
          profilePicture = doc.data()?['profilePicture'];
        });
      } catch (e) {
        debugPrint("Error fetching user data: $e");
      }
    }
  }

  Future<void> fetchNotes() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        throw Exception("User not logged in");
      }

      final userId = user.uid;

      final querySnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('events')
          .get();

      if (querySnapshot.docs.isNotEmpty) {
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
      }
    } catch (e) {
      debugPrint("Error fetching notes: $e");
    }
  }

  Future<void> addOrUpdateNoteInFirestore(int day, String note) async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        throw Exception("User not logged in");
      }

      final userId = user.uid;
      final eventDoc = FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
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
        backgroundColor: Colors.brown[300],
        textColor: Colors.white,
      );
    } catch (e) {
      debugPrint("Error adding/updating note: $e");
    }
  }

  Future<void> deleteNoteInFirestore(int day) async {
    bool? confirm = await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        backgroundColor: Colors.brown[50],
        title: const Text(
          'Delete Event',
          style: TextStyle(color: Colors.brown, fontWeight: FontWeight.bold),
        ),
        content: const Text(
          'Are you sure you want to delete this event?',
          style: TextStyle(color: Colors.black87),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text(
              'Cancel',
              style: TextStyle(color: Colors.grey),
            ),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text(
              'Delete',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );

    if (confirm == true) {
      try {
        final user = FirebaseAuth.instance.currentUser;
        if (user == null) {
          throw Exception("User not logged in");
        }

        final userId = user.uid;
        final eventDoc = FirebaseFirestore.instance
            .collection('users')
            .doc(userId)
            .collection('events')
            .doc('$day-${selectedDate.month}-${selectedDate.year}');

        await eventDoc.delete();

        setState(() {
          notes.remove(day);
        });

        Fluttertoast.showToast(
          msg: "Event successfully deleted",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          backgroundColor: Colors.brown[300],
          textColor: Colors.white,
        );
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
            CircleAvatar(
              backgroundImage: profilePicture != null
                  ? NetworkImage(profilePicture!)
                  : const AssetImage('assets/profile.jpg') as ImageProvider,
            ),
            const SizedBox(width: 10),
            Text(
              'Welcome ${firestoreName ?? "User"} !',
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
        decoration: BoxDecoration(
          image: DecorationImage(
            image: const AssetImage('assets/wallpaper.png'),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
              Colors.black.withOpacity(0.2), // Reduced transparency
              BlendMode.dstATop,
            ),
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
                          backgroundColor:
                              const Color.fromARGB(255, 182, 125, 206),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: const Center(
                          child: Padding(
                            padding: EdgeInsets.symmetric(vertical: 10.0),
                            child: Text(
                              '+ Make Appointment',
                              style:
                                  TextStyle(fontSize: 16, color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Container(
                        padding: const EdgeInsets.all(9),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: const Color.fromARGB(255, 210, 196, 216),
                        ),
                        child: Column(
                          children: [
                            Center(
                              child: Text(
                                '${months[selectedDate.month]} ${selectedDate.year}',
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
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
                                        color: const Color.fromARGB(
                                            255, 197, 154, 186),
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
                      const SizedBox(height: 25),
                      const Text(
                        "What's New",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 10),
                      SizedBox(
                        height: 120,
                        child: ListView(
                          scrollDirection: Axis.horizontal,
                          children: [
                            _buildImageBox('assets/d.jpg', Colors.orangeAccent),
                            const SizedBox(width: 10),
                            _buildImageBox('assets/e.jpg', Colors.greenAccent),
                            const SizedBox(width: 10),
                            _buildImageBox('assets/f.jpg', Colors.blueAccent),
                          ],
                        ),
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
        currentIndex: 0,
        backgroundColor: const Color.fromARGB(255, 19, 34, 48),
        selectedItemColor: const Color.fromARGB(255, 75, 153, 193),
        unselectedItemColor: Colors.grey,
        onTap: (index) {
          if (index == 0) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => DashboardPage(userName: widget.userName),
              ),
            );
          } else if (index == 1) {
            Navigator.pushNamed(context, '/booking');
          } else if (index == 2) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const ProfileSPage(),
              ),
            );
          }
        },
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

  Widget _buildImageBox(String imagePath, Color borderColor) {
    return Container(
      width: 120,
      decoration: BoxDecoration(
        color: borderColor,
        borderRadius: BorderRadius.circular(10),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Image.asset(
          imagePath,
          fit: BoxFit.cover,
        ),
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
              color: notes.containsKey(day) &&
                      selectedDate.month == currentMonth &&
                      selectedDate.year == currentYear
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
                    if (notes.containsKey(day) &&
                        selectedDate.month == currentMonth &&
                        selectedDate.year == currentYear)
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
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          backgroundColor: Colors.brown[50],
          title: Text(
            notes.containsKey(day) ? 'Edit Note ' : 'Add Note ',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Color.fromARGB(255, 96, 40, 113),
            ),
          ),
          content: TextField(
            onChanged: (value) => newNote = value,
            controller: TextEditingController(text: newNote),
            decoration: const InputDecoration(
              hintText: "Enter your note",
              border: OutlineInputBorder(),
            ),
          ),
          actions: [
            if (notes.containsKey(day))
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  deleteNoteInFirestore(day);
                },
                child: const Text(
                  'Delete',
                  style: TextStyle(color: Colors.red),
                ),
              ),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text(
                'Cancel',
                style: TextStyle(color: Color.fromARGB(255, 113, 112, 112)),
              ),
            ),
            TextButton(
              onPressed: () {
                if (newNote.isNotEmpty) {
                  addOrUpdateNoteInFirestore(day, newNote);
                }
                Navigator.pop(context);
              },
              child: Text(
                notes.containsKey(day) ? 'Update' : 'Save',
                style: const TextStyle(
                  color: Color.fromARGB(255, 96, 40, 113),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
