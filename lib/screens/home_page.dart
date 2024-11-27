import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:curavisionai/screens/xray_page.dart';
import 'medication_page.dart';
import '../account_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'CuraVision AI',
          style: GoogleFonts.lato(), // Title on the left
        ),
        backgroundColor: Colors.blue[800],
        centerTitle: false, // Align title to the left
        actions: [
          GestureDetector(
            onTap: () {
              // Navigate to the Account Page
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => Scaffold(
                    appBar: AppBar(
                      title: Text(
                        'Account',
                        style: GoogleFonts.lato(),
                      ),
                      centerTitle: true,
                      backgroundColor: Colors.orange[800],
                    ),
                    body: const AccountPage(),
                  ),
                ),
              );
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Icon(
                Icons.account_circle,
                color: Colors.black, // Black account icon
              ),
            ),
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min, // Center widgets vertically
          children: [
            // X-Ray Analysis Section
            GestureDetector(
              onTap: () {
                // Navigate to the X-Ray Analysis Page
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Scaffold(
                      appBar: AppBar(
                        title: Text(
                          'X-Ray Analysis',
                          style: GoogleFonts.lato(),
                        ),
                        centerTitle: true,
                        backgroundColor: Colors.blue[800],
                      ),
                      body: const XRayPage(),
                    ),
                  ),
                );
              },
              child: Container(
                margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                padding: const EdgeInsets.all(16.0),
                width: double.infinity, // Make it take the full width
                decoration: BoxDecoration(
                  color: Colors.blue[100], // Light blue background for this section
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.radio, // Icon for X-Ray Analysis
                      size: 48,
                      color: Colors.blue[800],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'X-Ray Analysis',
                      style: GoogleFonts.lato(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue[800],
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'AI-powered diagnostics for skeletal anomalies.',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.lato(fontSize: 14, color: Colors.grey[700]),
                    ),
                  ],
                ),
              ),
            ),
            // Medication Checker Section
            GestureDetector(
              onTap: () {
                // Navigate to the Medication Checker Page
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Scaffold(
                      appBar: AppBar(
                        title: Text(
                          'Medication Checker',
                          style: GoogleFonts.lato(),
                        ),
                        centerTitle: true,
                        backgroundColor: Colors.green[800],
                      ),
                      body: const MedicationPage(),
                    ),
                  ),
                );
              },
              child: Container(
                margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                padding: const EdgeInsets.all(16.0),
                width: double.infinity, // Make it take the full width
                decoration: BoxDecoration(
                  color: Colors.green[100], // Light green background for this section
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.medication, // Icon for Medication Checker
                      size: 48,
                      color: Colors.green[800],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Medication Checker',
                      style: GoogleFonts.lato(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.green[800],
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Analyze medication interactions and find alternatives.',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.lato(fontSize: 14, color: Colors.grey[700]),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}