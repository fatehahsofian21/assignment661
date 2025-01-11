import 'dart:async';
import 'package:flutter/material.dart';

class MainPageL extends StatefulWidget {
  const MainPageL({Key? key}) : super(key: key);

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

  @override
  void initState() {
    super.initState();
    Timer.periodic(const Duration(seconds: 3), (Timer timer) {
      if (_currentPage < images.length - 1) {
        _currentPage++;
      } else {
        _currentPage = 0;
      }

      _pageController.animateToPage(
        _currentPage,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 19, 34, 48),
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              "Welcome back!",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.notifications, color: Colors.white),
                  onPressed: () {},
                ),
                IconButton(
                  icon: const Icon(Icons.person, color: Colors.white),
                  onPressed: () {},
                ),
              ],
            ),
          ],
        ),
      ),
      body: Container(
        color:
            const Color.fromARGB(255, 235, 218, 181), // Soft pastel background
        child: Column(
          children: [
            // Image Carousel Section
            SizedBox(
              height: 200, // Adjust the height of the carousel
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

            // Today's Schedule Section
            Padding(
              padding: const EdgeInsets.all(16.0),
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
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      "Today's schedule",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      "DPP\n1:00",
                      style: TextStyle(fontSize: 16),
                    ),
                  ],
                ),
              ),
            ),

            // Upcoming Event Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
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
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Upcoming event",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      "Husna\nTeh\nRai",
                      style: TextStyle(fontSize: 16),
                    ),
                    Align(
                      alignment: Alignment.bottomRight,
                      child: TextButton(
                        onPressed: () {},
                        child: const Text(
                          "View more",
                          style: TextStyle(
                            color: Color.fromARGB(255, 19, 34, 48),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Bottom Navigation Bar Placeholder
            const Spacer(),
            BottomNavigationBar(
              backgroundColor: const Color.fromARGB(255, 19, 34, 48),
              selectedItemColor: const Color.fromARGB(255, 224, 204, 161),
              unselectedItemColor: Colors.white,
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
          ],
        ),
      ),
    );
  }
}
