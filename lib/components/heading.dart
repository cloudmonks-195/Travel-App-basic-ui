import 'package:flutter/material.dart';
import 'package:Viator/utils/styles.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Import Firebase Auth
import 'package:intl/intl.dart'; // Import for date formatting

class HeadingSection extends StatelessWidget {
  const HeadingSection({super.key});

  @override
  Widget build(BuildContext context) {
    // Get user info from FirebaseAuth
    final User? user = FirebaseAuth.instance.currentUser;
    final String email = user?.email ?? 'No email available';
    final String lastLogin = DateFormat('yyyy-MM-dd – HH:mm').format(
        DateTime.now()); // You may store this in a database during login

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Container(
              decoration: BoxDecoration(
                color: text,
                borderRadius: BorderRadius.circular(100),
                image: const DecorationImage(
                  image: AssetImage('assets/images/profile.png'),
                  fit: BoxFit.cover,
                ),
              ),
              height: 50,
              width: 50,
              child: Image.asset(
                'assets/images/profile.png',
                errorBuilder: (context, error, stackTrace) =>
                    const Icon(Icons.account_circle, size: 50),
              ),
            ),
            SizedBox(width: small),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Welcome', style: p1.copyWith(color: Colors.white)),
                Text('Wayfarer', style: heading3.copyWith(color: Colors.white)),
              ],
            ),
          ],
        ),
        GestureDetector(
          onTap: () {
            // Show the dialog with login details when the notification icon is clicked
            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: const Text('Login Information'),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Email: $email'),
                    const SizedBox(height: 10),
                    Text('Last Login: $lastLogin'),
                  ],
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text('Close'),
                  ),
                ],
              ),
            );
          },
          child: Icon(Icons.notifications, color: icon, size: 28),
        ),
      ],
    );
  }
}
