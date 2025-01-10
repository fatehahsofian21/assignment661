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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("UiTM Chendering Map"),
        backgroundColor: Colors.teal,
      ),
      body: GoogleMap(
        initialCameraPosition: CameraPosition(
          target: _initialLocation,
          zoom: 15, // Adjust zoom level
        ),
        onMapCreated: (GoogleMapController controller) {
          _mapController = controller;
        },
        markers: {
          Marker(
            markerId: const MarkerId('uitm_chendering'),
            position: _initialLocation,
            infoWindow: const InfoWindow(
              title: "UiTM Chendering",
              snippet: "Lecturer's Room Location",
            ),
          ),
        },
      ),
    );
  }
}
