import 'package:flutter/material.dart';

class AtifPage extends StatelessWidget {
  const AtifPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Atif's Profile"),
      ),
      body: const Center(
        child: Text(
          "Welcome to Atif's Profile",
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}
