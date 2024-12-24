import 'dart:io'; // For File
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart'; // For importing profile picture

class ProfilePage extends StatefulWidget {
  final String userName;
  final String email;
  final String dateOfBirth;
  final String gender;

  const ProfilePage({
    super.key,
    required this.userName,
    required this.email,
    required this.dateOfBirth,
    required this.gender,
  });

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late String userName;
  late String email;
  late String dateOfBirth;
  late String gender;
  XFile? profileImage;

  @override
  void initState() {
    super.initState();
    userName = widget.userName;
    email = widget.email;
    dateOfBirth = widget.dateOfBirth;
    gender = widget.gender;
  }

  Future<void> _editField(String title, String initialValue, Function(String) onSave) async {
    TextEditingController controller = TextEditingController(text: initialValue);

    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Edit $title"),
          content: TextField(
            controller: controller,
            decoration: InputDecoration(
              labelText: title,
              border: const OutlineInputBorder(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                onSave(controller.text);
                Navigator.pop(context);
              },
              child: const Text("Save"),
            ),
          ],
        );
      },
    );
  }

  Future<void> _importProfileImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        profileImage = pickedFile;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFE4C4), // Nude background color
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 181, 93, 127),
        title: const Text("Profile"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context, {'userName': userName}); // Pass updated name back
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              const SizedBox(height: 20),
              // Profile Image with Edit Option
              Stack(
                alignment: Alignment.center,
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.pink.shade100,
                    backgroundImage: profileImage != null
                        ? FileImage(File(profileImage!.path))
                        : null,
                    child: profileImage == null
                        ? const Icon(
                            Icons.person,
                            size: 60,
                            color: Colors.white,
                          )
                        : null,
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: GestureDetector(
                      onTap: _importProfileImage,
                      child: const CircleAvatar(
                        radius: 15,
                        backgroundColor: Colors.white,
                        child: Icon(
                          Icons.edit,
                          size: 20,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              // Editable User Name
              GestureDetector(
                onTap: () => _editField("Name", userName, (newName) {
                  setState(() {
                    userName = newName;
                  });
                }),
                child: Text(
                  userName,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              // Editable Email
              GestureDetector(
                onTap: () => _editField("Email", email, (newEmail) {
                  setState(() {
                    email = newEmail;
                  });
                }),
                child: ListTile(
                  leading: const Icon(Icons.email),
                  title: const Text("Email"),
                  subtitle: Text(email),
                ),
              ),
              // Editable Date of Birth
              GestureDetector(
                onTap: () => _editField("Date of Birth", dateOfBirth, (newDOB) {
                  setState(() {
                    dateOfBirth = newDOB;
                  });
                }),
                child: ListTile(
                  leading: const Icon(Icons.cake),
                  title: const Text("Date of Birth"),
                  subtitle: Text(dateOfBirth),
                ),
              ),
              // Editable Gender
              GestureDetector(
                onTap: () => _editField("Gender", gender, (newGender) {
                  setState(() {
                    gender = newGender;
                  });
                }),
                child: ListTile(
                  leading: const Icon(Icons.person),
                  title: const Text("Gender"),
                  subtitle: Text(gender),
                ),
              ),
              const SizedBox(height: 30),
              // Log Out Button
              SizedBox(
                width: double.infinity, // Make the button wider
                child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.pop(context); // Log out or return to the previous screen
                  },
                  label: const Text(
                    "Log Out",
                    style: TextStyle(color: Color.fromARGB(255, 171, 0, 0), fontSize: 18), // Bigger font size
                  ),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14), // Make it taller
                    backgroundColor: const Color.fromARGB(255, 230, 123, 23), // Black background
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
