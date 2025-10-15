import 'dart:io';
import 'dart:convert'; // Required for base64Encode and jsonEncode
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:image/image.dart' as img_lib; // For image resizing/compression

class GradingPage extends StatefulWidget {
  @override
  _GradingPageState createState() => _GradingPageState();
}

class _GradingPageState extends State<GradingPage> {
  File? _selectedImage;
  String _grade = '';
  String _message = '';
  bool _isLoading = false;

  final ImagePicker _picker = ImagePicker();
  // !! IMPORTANT: REPLACED WITH YOUR ACTUAL CLOUD RUN SERVICE URL !!
  // Your service URL is: https://tuna-grading-service-509076102075.asia-southeast2.run.app
  final String cloudRunBaseUrl =
      'https://tuna-grading-service-509076102075.asia-southeast2.run.app';
  final String predictEndpoint =
      '/predict'; // The specific endpoint for prediction

  // Custom colors for UI elements
  Color buttonBackgroundColor = Colors.blue;
  Color buttonTextColor = Colors.white;
  Color appBarColor = Colors.blue;
  Color appBarTextColor = Colors.white;

  Future<void> _sendImageToApi(File imageFile) async {
    setState(() {
      _isLoading = true;
      _grade = '';
      _message = 'Sending image for grading...';
    });

    final stopwatch = Stopwatch()..start(); // Start timing

    try {
      // Read image bytes
      List<int> imageBytes = await imageFile.readAsBytes();

      // --- OPTIONAL BUT HIGHLY RECOMMENDED: Resize/Compress Image ---
      // This will reduce the size of data sent over the network,
      // making the request faster and potentially more reliable.
      img_lib.Image? originalImage = img_lib.decodeImage(
        Uint8List.fromList(imageBytes),
      );
      if (originalImage == null) {
        throw Exception("Could not decode image for pre-processing.");
      }

      // Resize the image to a reasonable size before sending.
      // The backend will handle the final 480x480 resize for the model.
      // Example: Resize to max width of 800 pixels.
      img_lib.Image resizedImage = img_lib.copyResize(
        originalImage,
        width: 800,
      );

      // Encode to JPEG with a quality setting to compress
      List<int> processedBytes = img_lib.encodeJpg(
        resizedImage,
        quality: 75,
      ); // Quality 0-100

      // Encode processed image bytes to base64
      String base64Image = base64Encode(processedBytes);

      // Construct the JSON request body
      final Map<String, dynamic> requestBody = {
        "image_base64": base64Image, // Key matches what app.py expects
      };

      // Send the POST request with a JSON body
      final response = await http.post(
        Uri.parse(cloudRunBaseUrl + predictEndpoint),
        headers: {
          "Content-Type": "application/json", // Crucial: Tell server it's JSON
          "Accept": "application/json",
        },
        body: jsonEncode(requestBody), // Encode the map to a JSON string
      );

      stopwatch.stop(); // Stop timing

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          _grade = data['grade'] ?? '-';
          double confidenceValue =
              (data['confidence'] ?? 0.0).toDouble(); // Get confidence
          // Format confidence as a percentage
          _message =
              "Confidence: ${confidenceValue.toStringAsFixed(2)}%\n"
              "Grading completed in ${stopwatch.elapsed.inSeconds} seconds.";
        });
      } else {
        setState(() {
          _grade = '-';
          _message =
              'API request failed: ${response.statusCode}\n${response.body}';
        });
        print('Server error: ${response.statusCode}, Body: ${response.body}');
      }
    } catch (e) {
      stopwatch.stop(); // Ensure we stop in case of error
      setState(() {
        _grade = '-';
        _message = 'Error sending image: $e';
      });
      print('Exception during prediction: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await _picker.pickImage(source: source);
    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
        _grade = '';
        _message = 'Image selected. Press "Grade" to continue.';
      });
    } else {
      setState(() {
        _message = 'No image selected.';
      });
    }
  }

  void _showImageSourceSelector() {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog.adaptive(
            title: Text("Select Image Source"),
            content: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: Icon(
                        Icons.camera_alt_outlined,
                        size: 50,
                        color: Colors.black,
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                        _pickImage(ImageSource.camera);
                      },
                    ),
                    Text("Camera"),
                  ],
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: Icon(Icons.image, size: 50, color: Colors.black),
                      onPressed: () {
                        Navigator.pop(context);
                        _pickImage(ImageSource.gallery);
                      },
                    ),
                    Text("Gallery"),
                  ],
                ),
              ],
            ),
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Grading Page',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: appBarTextColor,
          ),
        ),
        centerTitle: true,
        backgroundColor: appBarColor,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: _showImageSourceSelector,
                child: Container(
                  width: 350,
                  height: 250,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.blue, width: 2),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(28),
                    child:
                        _selectedImage == null
                            ? Center(
                              child: Text(
                                "Upload a picture",
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 18,
                                  fontStyle: FontStyle.italic,
                                ),
                              ),
                            )
                            : Image.file(_selectedImage!, fit: BoxFit.cover),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              _isLoading
                  ? CircularProgressIndicator()
                  : Column(
                    children: [
                      ElevatedButton(
                        onPressed:
                            _selectedImage == null
                                ? null
                                : () => _sendImageToApi(_selectedImage!),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: buttonBackgroundColor,
                          foregroundColor: buttonTextColor,
                          padding: EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 12,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        child: Text(
                          'Grade',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        ' $_grade', // Display the predicted grade
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        _message, // This now includes confidence and timing
                        style: TextStyle(fontSize: 18),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
            ],
          ),
        ),
      ),
    );
  }
}
