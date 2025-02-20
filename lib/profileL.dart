import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProfileLPage extends StatefulWidget {
  const ProfileLPage({Key? key}) : super(key: key);

  @override
  State<ProfileLPage> createState() => _ProfileLPageState();
}

class _ProfileLPageState extends State<ProfileLPage> {
  bool isEditMode = false;

  // Controllers for text fields
  final TextEditingController nameController = TextEditingController();
  final TextEditingController departmentController =
      TextEditingController(text: "Computer Science Department");
  final TextEditingController designationController =
      TextEditingController(text: "Senior Lecturer");
  final TextEditingController campusController =
      TextEditingController(text: "UiTM Kampus Kuala Terengganu (Cendering)");
  final TextEditingController phoneController =
      TextEditingController(text: "+60123456789");
  String email = "";
  String firstName = "";
  String matricNumber = "";

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      try {
        DocumentSnapshot<Map<String, dynamic>> userDoc = await FirebaseFirestore
            .instance
            .collection('users')
            .doc(user.uid)
            .get();

        if (userDoc.exists) {
          final data = userDoc.data();
          setState(() {
            email = data?['email'] ?? "lecturer@example.com";
            firstName = (data?['name'] ?? "Lecturer Name").split(" ")[0];
            matricNumber = email.split("@")[0];
            nameController.text = firstName;
          });
        }
      } catch (e) {
        debugPrint("Error loading user data: $e");
      }
    }
  }

  Future<void> _logout() async {
    final bool? confirm = await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text("Logout Confirmation"),
        content: const Text("Are you sure you want to log out?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false), // Cancel logout
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true), // Confirm logout
            child: const Text(
              "Logout",
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );

    if (confirm == true) {
      await FirebaseAuth.instance.signOut();
      Navigator.pushReplacementNamed(context, '/login2'); // Navigate to login2
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 9, 42, 70),
        elevation: 0,
        automaticallyImplyLeading: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          "My Profile",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Profile Header Section
            Container(
              padding:
                  const EdgeInsets.symmetric(vertical: 10, horizontal: 140),
              decoration: const BoxDecoration(
                color: Color.fromARGB(255, 13, 49, 76),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
              ),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 55,
                    backgroundColor: Colors.white,
                    child: const CircleAvatar(
                      radius: 40,
                      backgroundImage: AssetImage('assets/k.jpg'),
                    ),
                  ),
                  const SizedBox(height: 10),
                  if (!isEditMode)
                    Text(
                      firstName,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  if (isEditMode)
                    _buildEditableTextField(nameController, isBold: true),
                  const SizedBox(height: 10),
                  Text(
                    matricNumber,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 13,
                      color: Colors.white70,
                    ),
                  ),
                ],
              ),
            ),
            // Details Section
            Container(
              color: const Color(0xFFF5F5F5),
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildInfoTile("Department", departmentController),
                  _buildInfoTile("Designation", designationController),
                  _buildInfoTile("Campus", campusController),
                  _buildInfoTile("Email", TextEditingController(text: email)),
                  _buildInfoTile("Phone Number", phoneController),
                  const SizedBox(height: 70),
                  Center(
                    child: isEditMode
                        ? ElevatedButton(
                            onPressed: () {
                              setState(() {
                                isEditMode = false;
                              });
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content:
                                      Text("Profile updated successfully!"),
                                  backgroundColor: Colors.green,
                                ),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 30,
                                vertical: 10,
                              ),
                            ),
                            child: const Text(
                              "Save",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 16),
                            ),
                          )
                        : ElevatedButton(
                            onPressed: () {
                              setState(() {
                                isEditMode = true;
                              });
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  const Color.fromARGB(255, 185, 185, 185),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 30,
                                vertical: 10,
                              ),
                            ),
                            child: const Text(
                              "Edit Profile",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 16),
                            ),
                          ),
                  ),
                  const SizedBox(height: 20),
                  Center(
                    child: ElevatedButton(
                      onPressed: _logout,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 30,
                          vertical: 10,
                        ),
                      ),
                      child: const Text(
                        "Logout",
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoTile(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 4,
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ),
          Expanded(
            flex: 6,
            child: isEditMode
                ? _buildEditableTextField(controller)
                : Text(
                    controller.text,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.black,
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildEditableTextField(TextEditingController controller,
      {bool isBold = false}) {
    return TextField(
      controller: controller,
      style: TextStyle(
        fontSize: 14,
        fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
        color: Colors.black,
      ),
      decoration: const InputDecoration(
        isDense: true,
        contentPadding: EdgeInsets.symmetric(vertical: 6),
        border: UnderlineInputBorder(),
      ),
    );
  }
}
