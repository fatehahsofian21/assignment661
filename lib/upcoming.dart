import 'package:flutter/material.dart';

class UpcomingPage extends StatelessWidget {
  const UpcomingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final TextEditingController reasonController =
        TextEditingController(); // Controller for input

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 19, 34, 48),
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () => Navigator.pop(context),
            ),
            const SizedBox(width: 48),
          ],
        ),
      ),
      body: Container(
        color: const Color.fromARGB(255, 235, 218, 181),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const CircleAvatar(
                  radius: 50,
                  backgroundImage: AssetImage('assets/profile.jpg'),
                  backgroundColor: Colors.transparent,
                ),
                const SizedBox(height: 16),
                const Text(
                  "Hi Husna Firzanah!",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  "You have an upcoming appointment\nwith SIR AHMAD NADZMI.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  "Booking Details:",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  "Date: 15/10/22\nDay: Tuesday\nVenue: Bilik Pensyarah 3\nRemark: Jangan lambat sir",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            const Color.fromARGB(255, 224, 204, 161),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 30,
                          vertical: 10,
                        ),
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text(
                        "Back",
                        style: TextStyle(
                          color: Color.fromARGB(255, 96, 56, 8),
                          fontSize: 16,
                        ),
                      ),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            const Color.fromARGB(255, 224, 204, 161),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 30,
                          vertical: 10,
                        ),
                      ),
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: const Text(
                                "Cancel Appointment",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  TextField(
                                    controller: reasonController,
                                    decoration: const InputDecoration(
                                      labelText: "Reason:",
                                      border: OutlineInputBorder(),
                                    ),
                                    maxLines: 3,
                                  ),
                                  const SizedBox(height: 16),
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color.fromARGB(
                                          255, 224, 204, 161),
                                    ),
                                    onPressed: () {
                                      Navigator.pop(context); // Close dialog
                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            title: const Text(
                                              "Confirmation",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            content: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                GestureDetector(
                                                  onTap: () {
                                                    showDialog(
                                                      context: context,
                                                      builder: (BuildContext
                                                          context) {
                                                        return AlertDialog(
                                                          title: const Text(
                                                            "Appointment Details",
                                                            style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                          ),
                                                          content: Column(
                                                            mainAxisSize:
                                                                MainAxisSize
                                                                    .min,
                                                            children: [
                                                              Row(
                                                                children: [
                                                                  Container(
                                                                    decoration:
                                                                        BoxDecoration(
                                                                      border: Border.all(
                                                                          color:
                                                                              Colors.black),
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              5),
                                                                    ),
                                                                    padding:
                                                                        const EdgeInsets
                                                                            .all(
                                                                            8),
                                                                    child:
                                                                        Column(
                                                                      children: const [
                                                                        Text(
                                                                          "15",
                                                                          style:
                                                                              TextStyle(
                                                                            fontSize:
                                                                                16,
                                                                            fontWeight:
                                                                                FontWeight.bold,
                                                                            color:
                                                                                Colors.black,
                                                                          ),
                                                                        ),
                                                                        Text(
                                                                          "Selasa",
                                                                          style:
                                                                              TextStyle(
                                                                            fontSize:
                                                                                16,
                                                                            color:
                                                                                Colors.black,
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                  const SizedBox(
                                                                      width:
                                                                          10),
                                                                  Column(
                                                                    crossAxisAlignment:
                                                                        CrossAxisAlignment
                                                                            .start,
                                                                    children: [
                                                                      const Text(
                                                                        "Sir Ahmad",
                                                                        style:
                                                                            TextStyle(
                                                                          fontSize:
                                                                              18,
                                                                          fontWeight:
                                                                              FontWeight.bold,
                                                                          color:
                                                                              Colors.black,
                                                                        ),
                                                                      ),
                                                                      const Text(
                                                                        "Venue: CUPO",
                                                                        style:
                                                                            TextStyle(
                                                                          fontSize:
                                                                              16,
                                                                          color:
                                                                              Colors.black,
                                                                        ),
                                                                      ),
                                                                      Text(
                                                                        "Reason: ${reasonController.text}",
                                                                        style:
                                                                            const TextStyle(
                                                                          fontSize:
                                                                              16,
                                                                          color:
                                                                              Colors.black,
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ],
                                                              ),
                                                              const SizedBox(
                                                                  height: 16),
                                                              ElevatedButton(
                                                                style: ElevatedButton
                                                                    .styleFrom(
                                                                  backgroundColor:
                                                                      const Color
                                                                          .fromARGB(
                                                                          255,
                                                                          224,
                                                                          204,
                                                                          161),
                                                                ),
                                                                onPressed: () {
                                                                  Navigator.pop(
                                                                      context); // Close enlarged view
                                                                  Navigator.pushNamed(
                                                                      context,
                                                                      '/booking'); // Navigate to booking.dart
                                                                },
                                                                child:
                                                                    const Text(
                                                                  "Done",
                                                                  style:
                                                                      TextStyle(
                                                                    color: Color
                                                                        .fromARGB(
                                                                            255,
                                                                            96,
                                                                            56,
                                                                            8),
                                                                    fontSize:
                                                                        16,
                                                                  ),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        );
                                                      },
                                                    );
                                                  },
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: const [
                                                      Text(
                                                        "View More",
                                                        style: TextStyle(
                                                            fontSize: 14,
                                                            color: Colors.blue),
                                                      ),
                                                      Icon(
                                                        Icons.arrow_forward,
                                                        color: Colors.blue,
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                            actions: [
                                              TextButton(
                                                onPressed: () {
                                                  Navigator.pop(
                                                      context); // Close confirmation
                                                },
                                                child: const Text(
                                                  "OK",
                                                  style: TextStyle(
                                                    color: Color.fromARGB(
                                                        255, 96, 56, 8),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          );
                                        },
                                      );
                                    },
                                    child: const Text(
                                      "Submit",
                                      style: TextStyle(
                                        color: Color.fromARGB(255, 96, 56, 8),
                                        fontSize: 16,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        );
                      },
                      child: const Text(
                        "Cancel Booking",
                        style: TextStyle(
                          color: Color.fromARGB(255, 96, 56, 8),
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
