import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'services/hugging_face_service.dart'; // Import the Hugging Face service

class XRayPage extends StatefulWidget {
  const XRayPage({Key? key}) : super(key: key);

  @override
  State<XRayPage> createState() => _XRayPageState();
}

class _XRayPageState extends State<XRayPage> {
  File? _image; // Selected image file
  String? _result; // Analysis result to display
  bool _isLoading = false; // Loading spinner state

  final ImagePicker _picker = ImagePicker(); // Image picker instance
  final HuggingFaceService huggingFaceService = HuggingFaceService(); // Hugging Face service instance

  /// Pick an image from the gallery
  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path); // Store the selected image
        _result = null; // Reset the result
      });
    }
  }

  /// Analyze the selected X-ray image
  Future<void> _analyzeImage() async {
    if (_image == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please select an X-ray image.")),
      );
      return;
    }

    // Validate file format
    final extension = _image!.path.split('.').last.toLowerCase();
    if (!["jpg", "jpeg", "png"].contains(extension)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Unsupported file format. Please select a JPG or PNG image.")),
      );
      return;
    }

    setState(() {
      _isLoading = true; // Show loading indicator
      _result = null; // Clear existing result
    });

    try {
      // Call the Hugging Face API
      final analysisResult = await huggingFaceService.analyzeXRay(_image!);

      // Parse and display the predictions
      setState(() {
        _result = _formatPredictions(analysisResult); // Format predictions
      });
    } catch (e) {
      setState(() {
        _result = "Error: $e"; // Display error message
      });
    } finally {
      setState(() {
        _isLoading = false; // Hide loading spinner
      });
    }
  }

  /// Format the predictions into a readable result
  String _formatPredictions(List<dynamic> predictions) {
    return predictions.map((prediction) {
      final label = prediction['label'];
      final score = (prediction['score'] * 100).toStringAsFixed(2); // Convert score to percentage
      return "$label: $score%";
    }).join("\n"); // Join the predictions with newlines
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("X-Ray Analysis"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (_image != null)
              Image.file(_image!, height: 300, fit: BoxFit.contain) // Display the selected image
            else
              const Center(child: Text("No image selected.")), // Placeholder for no image
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _pickImage, // Trigger the image picker
              child: const Text("Select X-Ray Image"),
            ),
            const SizedBox(height: 20),
            if (_isLoading)
              const Center(child: CircularProgressIndicator()) // Show spinner while loading
            else
              ElevatedButton(
                onPressed: _analyzeImage, // Trigger analysis
                child: const Text("Analyze X-Ray"),
              ),
            const SizedBox(height: 20),
            if (_result != null)
              Text(
                "Result:\n$_result", // Display formatted result
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
          ],
        ),
      ),
    );
  }
}