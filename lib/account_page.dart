import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AccountPage extends StatelessWidget {
  const AccountPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.white, // Change to white
        ),
        title: Text(
          'Account Information',
            style: GoogleFonts.raleway(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            )
        ),
        centerTitle: true,
        backgroundColor: Colors.orange[800], // Orange color for the Account page
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 40), // Space at the top
            // Profile Picture
            CircleAvatar(
              radius: 50, // Size of the avatar
              backgroundColor: Colors.orange[100],
              child: Icon(
                Icons.account_circle,
                size: 80,
                color: Colors.orange[800],
              ),
            ),
            const SizedBox(height: 20), // Space between avatar and text
            // User Name
            Text(
              'John Doe', // Replace with the actual user name
              style: GoogleFonts.lato(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 8),
            // User Email
            Text(
              'johndoe@example.com', // Replace with the actual email
              style: GoogleFonts.lato(
                fontSize: 16,
                color: Colors.grey[700],
              ),
            ),
            const SizedBox(height: 40), // Space before the button
            // Log Out Button
            ElevatedButton(
              onPressed: () {
                // Handle log out functionality
                Navigator.pop(context); // Navigate back to the home page
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange[800], // Button color
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8), // Rounded corners
                ),
              ),
              child: Text(
                'Log Out',
                style: GoogleFonts.lato(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white, // Text color
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}