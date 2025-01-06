import 'package:flutter/material.dart';

class AhmadPage extends StatelessWidget {
  const AhmadPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Ahmad's Profile"),
      ),
      body: const Center(
        child: Text(
          "Welcome to Ahmad's Profile",
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}
