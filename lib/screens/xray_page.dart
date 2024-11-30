import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'viewreportspage.dart';

class XRayPage extends StatelessWidget {
  const XRayPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: Colors.white, // Back button color (white)
        ),
        title: Text(
          'X-Ray Analysis',
          style: GoogleFonts.montserrat(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white, // Title color
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.blue[700], // Lighter blue for X-Ray Page
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header Section
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.blue[100], // Decorative light blue background
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(40),
                bottomRight: Radius.circular(40),
              ),
            ),
            child: Column(
              children: [
                Icon(
                  Icons.radio, // X-Ray icon
                  size: 80,
                  color: Colors.blue[700],
                ),
                const SizedBox(height: 16),
                Text(
                  'Welcome to X-Ray Analysis',
                  style: GoogleFonts.montserrat(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue[700],
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  'Upload your X-Rays for AI-powered diagnostics. Get instant insights into skeletal anomalies, posture issues, and more.',
                  style: GoogleFonts.lato(
                    fontSize: 16,
                    color: Colors.grey[700],
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Call-to-Action Section
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              children: [
                // Upload X-Ray Button
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 8.0), // Add vertical spacing
                  child: ElevatedButton.icon(
                    onPressed: () {
                      // TODO: Add functionality to upload X-Ray
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Upload X-Ray clicked')),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue[700],
                      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16), // Added padding
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12), // Rounded corners
                      ),
                    ),
                    icon: const Icon(Icons.upload_rounded, color: Colors.white),
                    label: Text(
                      'Upload X-Ray',
                      style: GoogleFonts.montserrat(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),

                // View Previous Reports Button
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 8.0), // Add vertical spacing
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ViewReportsPage(),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue[500],
                      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16), // Added padding
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12), // Rounded corners
                      ),
                    ),
                    icon: const Icon(Icons.history, color: Colors.white),
                    label: Text(
                      'View Previous Reports',
                      style: GoogleFonts.montserrat(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          const Spacer(),

          // Footer Section
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'CuraVision AI - Empowering Your Health',
              style: GoogleFonts.lato(
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: Colors.grey[600],
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}