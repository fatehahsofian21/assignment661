import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class RoomZPage extends StatefulWidget {
  const RoomZPage({super.key});

  @override
  State<RoomZPage> createState() => _RoomZPageState();
}

class _RoomZPageState extends State<RoomZPage> {
  late GoogleMapController _mapController;

  // Default location: UiTM Chendering
  final LatLng _initialLocation = const LatLng(5.2604756, 103.1656662);

  // Define bounds to limit the user's interaction to UiTM Chendering area
  final LatLngBounds _chenderingBounds = LatLngBounds(
    southwest: LatLng(5.2590, 103.1640), // Bottom-left corner
    northeast: LatLng(5.2620, 103.1670), // Top-right corner
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "UiTM Chendering Map",
          style: TextStyle(
            color:
                Color.fromARGB(255, 96, 56, 8), // Set the text color to white
          ),
        ),
        backgroundColor: const Color.fromARGB(255, 224, 204, 161),
      ),
      body: GoogleMap(
        initialCameraPosition: CameraPosition(
          target: _initialLocation,
          zoom: 17, // Adjust zoom level
        ),
        onMapCreated: (GoogleMapController controller) {
          _mapController = controller;
        },
        markers: {
          Marker(
            markerId: const MarkerId('lecturer_room'),
            position: _initialLocation,
            onTap: () {
              _showRoomDetails(context);
            },
            infoWindow: const InfoWindow(
              title: "Lecturer's Room",
              snippet: "Tap for details",
            ),
          ),
        },
        minMaxZoomPreference:
            const MinMaxZoomPreference(15, 18), // Restrict zoom
        cameraTargetBounds:
            CameraTargetBounds(_chenderingBounds), // Limit map bounds
      ),
    );
  }

  void _showRoomDetails(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Center(
                child: Text(
                  "Zawawi's Room Details",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Center(
                child: Image.asset(
                  'assets/room.jpg', // Replace with your image asset
                  height: 200,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(height: 16),
              Center(
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.center, // Center-align the text
                  children: [
                    const Text(
                      "Bilik Pensyarah 3",
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      "Level 2",
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Center(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 224, 204, 161),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 30,
                      vertical: 10,
                    ),
                  ),
                  onPressed: () {
                    _navigateToRoom(context);
                  },
                  child: const Text(
                    "Navigate Me",
                    style: TextStyle(color: Color.fromARGB(255, 96, 56, 8)),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _navigateToRoom(BuildContext context) {
    // Example: Navigate instructions based on user's starting point
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Choose Starting Point"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  _showNavigationSteps(context, "Kolej Kerawang");
                },
                child: const Text("Kolej Kerawang"),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  _showNavigationSteps(context, "EFEK Cafe");
                },
                child: const Text("EFEK Cafe"),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  _showNavigationSteps(context, "Cafe KakHa");
                },
                child: const Text("Cafe KakHa"),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showNavigationSteps(BuildContext context, String startingPoint) {
    final Map<String, List<String>> navigationSteps = {
      "Kolej Kerawang": [
        "Go straight and enter Blok Akademik until you see EFEK Cafe.",
        "Just straight through the hallway until you see Cafe KakHa at your right.",
        "Enter Blok Akademik, turn right and choose the first staircase and go to Level 2.",
        "Turn right, and your destination is on your right."
      ],
      "EFEK Cafe": [
        "Just straight through the hallway until you see Cafe KakHa at your right.",
        "Enter Blok Akademik, turn right and choose the first staircase and go to Level 2.",
        "Turn right, and your destination is on your right."
      ],
      "Cafe KakHa": [
        "Enter Blok Akademik, turn right and choose the first staircase and go to Level 2.",
        "Turn right, and your destination is on your right."
      ],
    };

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(Icons.directions_walk,
                      size: 40, color: Colors.grey),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      "Navigation from $startingPoint",
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: navigationSteps[startingPoint]!
                    .asMap()
                    .entries
                    .map((entry) {
                  final step = entry.value;
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(Icons.circle, size: 10, color: Colors.grey),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            step,
                            style: const TextStyle(
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
              const Divider(height: 20, thickness: 1),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Text(
                    "Destination: Lecturer's Room",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Icon(Icons.location_on, color: Colors.red),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
