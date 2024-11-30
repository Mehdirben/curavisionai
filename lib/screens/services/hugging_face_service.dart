import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

class HuggingFaceService {
  final String apiKey = "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"; // Hugging Face API key
  final String modelId = "lxyuan/vit-xray-pneumonia-classification"; // Hugging Face model ID

  /// Analyze an X-ray image using the Hugging Face Inference API
  Future<List<dynamic>> analyzeXRay(File imageFile) async {
    final url = Uri.parse("https://api-inference.huggingface.co/models/$modelId");
    final headers = {
      "Authorization": "Bearer $apiKey", // Authorization header with API key
      "Content-Type": "application/octet-stream", // Send raw binary data
    };

    try {
      print("Image Path: ${imageFile.path}"); // Debugging: print file path

      // Read the file as bytes
      final imageBytes = await imageFile.readAsBytes();

      // Send the POST request with raw binary data
      final response = await http.post(
        url,
        headers: headers,
        body: imageBytes,
      );

      print("HTTP Status Code: ${response.statusCode}"); // Debugging: print status code
      print("Response Data: ${response.body}"); // Debugging: print raw response

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as List<dynamic>; // Parse the JSON response as a list
        print("Parsed Data: $data"); // Debugging: print parsed data
        return data; // Return the list of predictions
      } else {
        print("Error Response: ${response.reasonPhrase}"); // Debugging: print error
        if (response.statusCode == 400) {
          throw Exception("Invalid input. Please ensure the image is in a supported format.");
        } else if (response.statusCode == 500) {
          throw Exception("Server error. Please try again later.");
        }
        throw Exception("Unexpected error: ${response.reasonPhrase}");
      }
    } catch (e) {
      print("Exception: Failed to analyze X-ray - $e"); // Debugging: print exception
      throw Exception("Failed to analyze X-ray: $e");
    }
  }
}