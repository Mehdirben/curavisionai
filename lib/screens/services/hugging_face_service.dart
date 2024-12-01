import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

class HuggingFaceService {
  final String apiKey = "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"; // Hugging Face API key
  final String xrayModelId = "lxyuan/vit-xray-pneumonia-classification"; // X-Ray model ID
  final String mixtralModelId = "mistralai/Mixtral-8x7B-Instruct-v0.1"; // Text generation model ID

  /// Analyze an X-ray image using the Hugging Face Inference API
  Future<List<dynamic>> analyzeXRay(File imageFile) async {
    final url = Uri.parse("https://api-inference.huggingface.co/models/$xrayModelId");
    final headers = {
      "Authorization": "Bearer $apiKey", // Authorization header with API key
      "Content-Type": "application/octet-stream", // Send raw binary data
    };

    try {
      print("Analyzing X-Ray with model: $xrayModelId");

      // Read the file as bytes
      final imageBytes = await imageFile.readAsBytes();

      // Send the POST request with raw binary data
      final response = await http.post(
        url,
        headers: headers,
        body: imageBytes,
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as List<dynamic>; // Parse the JSON response as a list
        return data; // Return the list of predictions
      } else {
        throw Exception("X-Ray model error: ${response.reasonPhrase}");
      }
    } catch (e) {
      throw Exception("Failed to analyze X-ray: $e");
    }
  }

  /// Generate a description using the Mixtral model based on the X-ray analysis percentage
  Future<String> generateDescriptionUsingModel(List<dynamic> predictions) async {
    if (predictions.isEmpty) {
      return "No significant results were found. Please try again with a different X-Ray image.";
    }

    final prediction = predictions[0]; // Use the top prediction result
    final label = prediction['label'];
    final score = (prediction['score'] * 100).toDouble(); // Convert to percentage

    final url = Uri.parse("https://api-inference.huggingface.co/models/$mixtralModelId");
    final headers = {
      "Authorization": "Bearer $apiKey", // Authorization header with API key
      "Content-Type": "application/json", // Send JSON data
    };

    // Construct the prompt for the Mixtral model
    final prompt = label.toLowerCase() == "pneumonia"
        ? "An X-ray analysis indicates a $score% likelihood of pneumonia. Briefly explain what pneumonia is and recommend whether the patient should consult a doctor based on this likelihood."
        : "An X-ray analysis indicates a $score% likelihood of $label. Briefly explain what this condition is and recommend whether the patient should consult a doctor based on this likelihood.";

    final body = jsonEncode({
      "inputs": prompt,
      "parameters": { // Limit the response length
        "temperature": 0.7, // Control randomness
      },
    });

    try {
      final response = await http.post(
        url,
        headers: headers,
        body: body,
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as List<dynamic>;
        if (data.isNotEmpty && data[0]["generated_text"] != null) {
          String generatedText = data[0]["generated_text"].trim();

          // Ensure prompt is excluded from the result
          if (generatedText.contains(prompt)) {
            generatedText = generatedText.replaceFirst(prompt, "").trim();
          }

          return generatedText;
        } else {
          throw Exception("Unexpected response format from Mixtral model.");
        }
      } else {
        throw Exception("Mixtral model error: ${response.reasonPhrase}");
      }
    } catch (e) {
      return "Unable to generate a detailed description at this time.";
    }
  }
}
