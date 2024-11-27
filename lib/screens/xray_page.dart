import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class XRayPage extends StatelessWidget {
  const XRayPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'X-Ray Analysis',
          style: GoogleFonts.lato(),
        ),
        centerTitle: true,
        backgroundColor: Colors.blue[800],
      ),
      body: Center(
        child: Text(
          'Welcome to the X-Ray Analysis Page',
          style: GoogleFonts.lato(fontSize: 18, color: Colors.grey[700]),
        ),
      ),
    );
  }
}