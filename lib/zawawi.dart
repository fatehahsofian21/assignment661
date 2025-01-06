import 'package:flutter/material.dart';

class ZawawiPage extends StatelessWidget {
  const ZawawiPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Zawawi's Profile"),
      ),
      body: const Center(
        child: Text(
          "Welcome to Zawawi's Profile",
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}
