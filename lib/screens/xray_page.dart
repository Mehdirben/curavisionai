import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'services/hugging_face_service.dart';

class XRayPage extends StatefulWidget {
  const XRayPage({super.key});

  @override
  State<XRayPage> createState() => _XRayPageState();
}

class _XRayPageState extends State<XRayPage> {
  File? _image; // Selected image file
  String? _result; // Analysis result to display
  bool _isLoading = false; // Loading state

  final ImagePicker _picker = ImagePicker(); // Instance of ImagePicker
  final HuggingFaceService huggingFaceService = HuggingFaceService(); // Instance of HuggingFaceService

  /// Pick an image from the gallery
  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path); // Store the selected image
        _result = null; // Reset previous result
      });
      _analyzeImage(); // Automatically analyze the image after selection
    }
  }

  /// Analyze the selected X-ray image
  Future<void> _analyzeImage() async {
    if (_image == null) return;

    setState(() {
      _isLoading = true; // Show loading spinner
      _result = null; // Clear previous result
    });

    try {
      // Call Hugging Face API for X-ray analysis
      final analysisResult = await huggingFaceService.analyzeXRay(_image!);

      // Generate the description using the Mixtral model
      print("Calling Mixtral model for detailed explanation...");
      final description = await huggingFaceService.generateDescriptionUsingModel(analysisResult);

      setState(() {
        _result = description; // Display the result
      });
    } catch (e) {
      setState(() {
        _result = "Error: $e"; // Show error message
      });
    } finally {
      setState(() {
        _isLoading = false; // Hide loading spinner
      });
    }
  }

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
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  // Header Section
                  Container(
                    padding: const EdgeInsets.all(20),
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
                          Icons.radio,
                          size: 80,
                          color: Colors.blue[700], // X-Ray icon
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Welcome to X-Ray Analysis',
                          style: GoogleFonts.montserrat(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue[700],
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 7),
                        Text(
                          'Upload your X-Rays for AI-powered diagnostics.',
                          style: GoogleFonts.lato(
                            fontSize: 16,
                            color: Colors.grey[700],
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Upload Button
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0),
                    child: ElevatedButton.icon(
                      onPressed: _pickImage, // Trigger the image picker
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

                  const SizedBox(height: 16),

                  // Display Selected Image
                  if (_image != null)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24.0),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12), // Rounded corners
                        child: Image.file(
                          _image!,
                          height: 300,
                          fit: BoxFit.cover, // Scale image to fit
                        ),
                      ),
                    ),

                  // Loading Spinner or Result Section
                  if (_isLoading) ...[
                    const SizedBox(height: 16),
                    const Center(child: CircularProgressIndicator()), // Show spinner while analyzing
                  ] else if (_result != null) ...[
                    const SizedBox(height: 16),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.grey[100], // Background for result box
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.blue[300]!), // Border for the result container
                        ),
                        child: Text(
                          "Analysis Result:\n\n$_result", // Display formatted result
                          style: GoogleFonts.lato(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.blue[700],
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ],

                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),

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