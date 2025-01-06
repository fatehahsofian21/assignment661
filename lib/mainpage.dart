import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

class MainPage extends StatefulWidget {
  final String userName; // Pass user name to the MainPage

  const MainPage({super.key, required this.userName});

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  String? selectedCourse = "Select a subject code";
  String searchQuery = ""; // Search query string
  late stt.SpeechToText _speech; // Speech-to-text instance
  bool _isListening = false; // Listening state
  List<String> recentSearches = [];
  List<Map<String, String>> lecturers = [];

  final List<Map<String, String>> allLecturers = [
    {
      "name": "Zawawi bin Ismail@Wahab",
      "phone": "012-3456789",
      "room": "101-A"
    },
    {
      "name": "Ahmad Nadzmi bin Fadzal",
      "phone": "011-2345678",
      "room": "102-B"
    },
    {
      "name": "Muhammad Atif bin Ramlan",
      "phone": "013-4567890",
      "room": "103-C"
    },
    {
      "name": "Siti Nurul Hayatie binti Ishak",
      "phone": "014-5678901",
      "room": "104-D"
    },
    {
      "name": "Dr. Najdah binti Abd Aziz",
      "phone": "015-6789012",
      "room": "105-E"
    },
  ];

  final Map<String, String> imageAssets = {
    "Zawawi bin Ismail@Wahab": "assets/k.jpg",
    "Ahmad Nadzmi bin Fadzal": "assets/i.jpg",
    "Muhammad Atif bin Ramlan": "assets/j.jpg",
    "Siti Nurul Hayatie binti Ishak": "assets/h.jpg",
    "Dr. Najdah binti Abd Aziz": "assets/g.jpg",
  };

  final Map<String, List<Map<String, String>>> lecturersByCourse = {
    "CSP600": [
      {
        "name": "Zawawi bin Ismail@Wahab",
        "phone": "012-3456789",
        "room": "101-A"
      },
      {
        "name": "Ahmad Nadzmi bin Fadzal",
        "phone": "011-2345678",
        "room": "102-B"
      },
      {
        "name": "Muhammad Atif bin Ramlan",
        "phone": "013-4567890",
        "room": "103-C"
      },
      {
        "name": "Siti Nurul Hayatie binti Ishak",
        "phone": "014-5678901",
        "room": "104-D"
      },
      {
        "name": "Dr. Najdah binti Abd Aziz",
        "phone": "015-6789012",
        "room": "105-E"
      },
    ],
    "CSC661": [
      {"name": "Wan Amirul Hakim", "phone": "016-7890123", "room": "106-F"},
      {"name": "Farhan bin Kamarul", "phone": "017-8901234", "room": "107-G"},
      {"name": "Noraini binti Hamid", "phone": "018-9012345", "room": "108-H"},
      {
        "name": "Fazrina binti Mohamad",
        "phone": "019-0123456",
        "room": "109-I"
      },
    ],
  };

  @override
  void initState() {
    super.initState();
    lecturers = allLecturers; // Initialize lecturers to include all lecturers
    _speech = stt.SpeechToText(); // Initialize speech-to-text
  }

  void _startListening() async {
    bool available = await _speech.initialize();
    if (available) {
      setState(() => _isListening = true);
      _speech.listen(onResult: (val) {
        setState(() {
          searchQuery = val.recognizedWords; // Update search query
          _filterLecturers();
        });
      });
    }
  }

  void _stopListening() {
    _speech.stop();
    setState(() => _isListening = false);
  }

  void _filterLecturers() {
    setState(() {
      lecturers = allLecturers
          .where((lecturer) => lecturer["name"]!
              .toLowerCase()
              .contains(searchQuery.toLowerCase()))
          .toList();

      if (searchQuery.isNotEmpty && !recentSearches.contains(searchQuery)) {
        recentSearches.add(searchQuery);
      }
    });
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
          title: _buildColoredTitle("LecturerMeet"), // Updated title
        ),
      ),
      body: Container(
        color: const Color.fromARGB(255, 42, 71, 90),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Search bar
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                controller: TextEditingController(text: searchQuery),
                onChanged: (value) {
                  setState(() {
                    searchQuery = value;
                    _filterLecturers();
                  });
                },
                decoration: InputDecoration(
                  prefixIcon:
                      const Icon(Icons.search, color: Colors.grey, size: 30),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _isListening ? Icons.mic : Icons.mic_none,
                      color: _isListening ? Colors.red : Colors.grey,
                    ),
                    onPressed: _isListening ? _stopListening : _startListening,
                  ),
                  hintText: "Search by lecturer name...",
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
                style: const TextStyle(fontSize: 18),
              ),
            ),
            // Course dropdown
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: DropdownButtonFormField<String>(
                value: selectedCourse,
                items: ["Select a subject code", ...lecturersByCourse.keys]
                    .map((String course) {
                  return DropdownMenuItem(
                    value: course,
                    child: Text(course, style: const TextStyle(fontSize: 18)),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    selectedCourse = newValue;
                    lecturers = lecturersByCourse[newValue] ?? allLecturers;
                    searchQuery = "";
                  });
                },
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
              child: Text(
                "Recent Search",
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
            ),
            // Lecturer cards
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                itemCount: lecturers.length,
                itemBuilder: (context, index) {
                  final lecturer = lecturers[index];
                  return GestureDetector(
                    onTap: () {
                      if (lecturer['name'] == "Zawawi bin Ismail@Wahab") {
                        Navigator.pushNamed(context, '/zawawi');
                      } else if (lecturer['name'] ==
                          "Ahmad Nadzmi bin Fadzal") {
                        Navigator.pushNamed(context, '/ahmad');
                      } else if (lecturer['name'] ==
                          "Muhammad Atif bin Ramlan") {
                        Navigator.pushNamed(context, '/atif');
                      }
                    },
                    child: Card(
                      margin: const EdgeInsets.only(bottom: 10.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Row(
                          children: [
                            // Picture placeholder
                            Container(
                              width: 60,
                              height: 60,
                              decoration: BoxDecoration(
                                color: Colors.grey[300],
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: imageAssets.containsKey(lecturer['name'])
                                  ? ClipRRect(
                                      borderRadius: BorderRadius.circular(12),
                                      child: Image.asset(
                                        imageAssets[lecturer['name']]!,
                                        fit: BoxFit.cover,
                                      ),
                                    )
                                  : const Icon(Icons.person,
                                      color: Colors.grey, size: 30),
                            ),
                            const SizedBox(width: 10),
                            // Lecturer details
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  lecturer['name']!,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                Text("Phone: ${lecturer['phone']}",
                                    style: const TextStyle(fontSize: 14)),
                                Text("Room No: ${lecturer['room']}",
                                    style: const TextStyle(fontSize: 14)),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
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
