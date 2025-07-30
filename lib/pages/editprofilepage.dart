import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _contactController = TextEditingController();

  // A method to update profile information
  Future<void> _updateProfile(BuildContext context) async {
    User? user = FirebaseAuth.instance.currentUser;

    if (_usernameController.text.isEmpty || _contactController.text.isEmpty) {
      // Show error if fields are empty
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in all the fields')),
      );
      return;
    }

    try {
      // Update the display name on Firebase Authentication
      await user
          ?.updateDisplayName(_usernameController.text); // Update username

      // Optionally, store other information like description and contact in Firestore
      String description = _descriptionController.text;
      String contact = _contactController.text;

      // You can save this in Firestore if needed
      // Firestore.instance.collection('users').doc(user.uid).set({
      //   'description': description,
      //   'contact': contact,
      // });

      // After successful update, show a success message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profile updated successfully')),
      );

      // Return the updated data back to ProfilePage
      Navigator.pop(context, {
        'username': _usernameController.text,
        'description': description,
        'contact': contact,
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error updating profile')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Profile'),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            // Username field
            const Text(
              'Username',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _usernameController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Enter your username',
              ),
            ),
            const SizedBox(height: 20),

            // Description field
            const Text(
              'Description',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _descriptionController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Enter a brief description about yourself',
              ),
            ),
            const SizedBox(height: 20),

            // Contact number field
            const Text(
              'Contact Number',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _contactController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Enter your contact number',
              ),
              keyboardType: TextInputType.phone,
            ),
            const SizedBox(height: 30),

            // Update Button
            ElevatedButton(
              onPressed: () {
                // Call the method to update the profile and pass updated data back
                _updateProfile(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
              child: const Text(
                'Update Profile',
                style: TextStyle(fontSize: 18),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
