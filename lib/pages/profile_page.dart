import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:Viator/pages/login_screen.dart';
import 'editprofilepage.dart'; // Import EditProfilePage

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  User? user;
  String? username;
  String? description;
  String? contact;

  @override
  void initState() {
    super.initState();
    // Fetch the current user data on initial load
    _fetchUserData();
  }

  // Method to fetch user data
  void _fetchUserData() {
    setState(() {
      user = FirebaseAuth.instance.currentUser;
      username = user?.displayName;
      description = 'Lorem ipsum'; // Replace with your Firestore data
      contact = '123-456-7890'; // Replace with your Firestore data
    });
  }

  // Logout function
  Future<void> _logout(BuildContext context) async {
    try {
      await FirebaseAuth.instance.signOut(); // Sign out the user
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) =>
                const LoginScreen()), // Navigate to login screen
      );
    } catch (e) {
      print('Error logging out: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error logging out. Please try again.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (user == null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Profile'),
        ),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        backgroundColor: Colors.blue,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color.fromARGB(255, 212, 20, 90), // Start color
              Color.fromARGB(255, 251, 176, 59), // End color
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          // Centering the content
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center, // Vertically center
              crossAxisAlignment:
                  CrossAxisAlignment.center, // Horizontally center
              children: [
                // Profile Picture
                const CircleAvatar(
                  radius: 60,
                  backgroundImage: AssetImage('assets/avatar2.png'),
                  // Placeholder image
                ),
                const SizedBox(height: 20),
                // Display Name
                Text(
                  username ?? 'User', // Display updated username
                  style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
                const SizedBox(height: 5),
                // Email (Fetched from Firebase Authentication)
                Text(
                  user?.email ?? 'No email available', // Display email
                  style: const TextStyle(fontSize: 18, color: Colors.white70),
                ),
                const SizedBox(height: 20),
                // Bio or Description (You can store this info in Firestore)
                Text(
                  description ?? 'No description available',
                  style: const TextStyle(fontSize: 16, color: Colors.white),
                ),
                const SizedBox(height: 20),
                // Contact Number
                Text(
                  contact ?? 'No contact available',
                  style: const TextStyle(fontSize: 16, color: Colors.white),
                ),
                const SizedBox(height: 30),
                // Edit Profile Button
                ElevatedButton(
                  onPressed: () async {
                    // Navigate to EditProfilePage and await the returned updated data
                    final updatedData = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const EditProfilePage(),
                      ),
                    );

                    // If there's updated data, update the UI
                    if (updatedData != null) {
                      setState(() {
                        username = updatedData['username'];
                        description = updatedData['description'];
                        contact = updatedData['contact'];
                      });
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 50, vertical: 15),
                    textStyle: const TextStyle(fontSize: 18),
                  ),
                  child: const Text('Edit Profile'),
                ),
                const SizedBox(height: 20),
                // Logout Button
                ElevatedButton(
                  onPressed: () => _logout(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 50, vertical: 15),
                    textStyle: const TextStyle(fontSize: 18),
                  ),
                  child: const Text('Logout'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
