import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'dart:convert';
import '../config/config.dart';

class CameraScannerPage extends StatefulWidget {
  @override
  _CameraScannerPageState createState() => _CameraScannerPageState();
}

class _CameraScannerPageState extends State<CameraScannerPage> {
  File? _imageFile;
  final ImagePicker _picker = ImagePicker();
  bool _isLoading = false;
  String? _errorMessage;

  int? _predictionResult;


  // Colors
  final Color primaryTextColor = Color(0XFF1A5319);
  final Color buttonGreen = Color(0XFF72BF78);
  final Color lightGreen = Color(0XFFF1F8E8);
  final Color mediumGreen = Color(0XFFA0D683);

  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  Future<void> _checkLoginStatus() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? username = prefs.getString('username');

    if (username == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Login Required'),
              content: Text('Please log in to use this feature.'),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.pop(context);
                  },
                  child: Text('Cancel'),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.pushReplacementNamed(context, '/login');
                  },
                  child: Text('Login'),
                ),
              ],
            );
          },
        );
      });
    }
  }

  Future<void> _getImageFromCamera() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
        _predictionResult = null;
        _errorMessage = null;
      });
    }
  }

  Future<void> _getImageFromGallery() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
        _predictionResult = null;
        _errorMessage = null;
      });
    }
  }

  Future<void> _predictImage() async {
    if (_imageFile == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please select an image first')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
      _predictionResult = null;
    });

    try {
      // Get user ID from shared preferences
      final SharedPreferences prefs = await SharedPreferences.getInstance();

      int? userId = prefs.getInt('user_id');


      if (userId == null) {
        throw Exception('User not logged in');
      }

      // Create multipart request
      var request = http.MultipartRequest(
        'POST', 
        Uri.parse('${AppConfig.baseUrl}/predict/predict')
      );

      // Add user ID to request

      request.fields['user_id'] = userId.toString();


      // Add image file to request
      request.files.add(
        await http.MultipartFile.fromPath(
          'image', 
          _imageFile!.path
        )
      );

      // Send the request
      var response = await request.send();

      // Read and handle the response
      var responseBody = await response.stream.bytesToString();

      setState(() {
        _isLoading = false;
      });

      if (response.statusCode == 200) {
        // Parse the JSON response
        var jsonResponse = json.decode(responseBody);
        setState(() {
          _predictionResult = jsonResponse['prediction'] ?? 'No prediction available';
        });
      } else {
        throw Exception('Failed to predict image: ${response.statusCode}');
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = 'Error: ${e.toString()}';
      });
    }
  }

  Widget _buildScanButton({
    required IconData icon,
    required String label,
    required VoidCallback onPressed,
  }) {
    return ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
        backgroundColor: buttonGreen,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      ),
      onPressed: onPressed,
      icon: Icon(icon, color: Colors.white),
      label: Text(
        label,
        style: TextStyle(
          color: Colors.white,
          fontSize: 14,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Scan Image"),
        backgroundColor: buttonGreen,
        titleTextStyle: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 20,
        ),
      ),
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              buttonGreen,
              mediumGreen,
              lightGreen,
            ],
            stops: [0.01, 0.1, 1.0],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (_imageFile != null)
                Container(
                  height: 200,
                  margin: const EdgeInsets.only(bottom: 20),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 10,
                        offset: Offset(0, 5),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: Image.file(
                      _imageFile!,
                      fit: BoxFit.cover,
                    ),
                  ),
                )
              else
                Container(
                  height: 200,
                  margin: const EdgeInsets.only(bottom: 20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(
                      color: mediumGreen,
                      width: 1,
                    ),
                  ),
                  child: Center(
                    child: Text(
                      'No image selected',
                      style: TextStyle(
                        color: primaryTextColor,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              Row(
                children: [
                  Expanded(
                    child: _buildScanButton(
                      icon: Icons.camera_alt,
                      label: 'Camera',
                      onPressed: _getImageFromCamera,
                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: _buildScanButton(
                      icon: Icons.photo_library,
                      label: 'Gallery',
                      onPressed: _getImageFromGallery,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              // Predict button with loading and error handling
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: buttonGreen,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 15),
                ),
                onPressed: _isLoading ? null : _predictImage,
                child: _isLoading 
                  ? CircularProgressIndicator(color: Colors.white)
                  : Text(
                      'Predict',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
              ),
              
              // Display prediction result or error
              if (_errorMessage != null)
                Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: Text(
                    _errorMessage!,
                    style: TextStyle(color: Colors.red, fontSize: 16),
                    textAlign: TextAlign.center,
                  ),
                ),
              if (_predictionResult != null)
                Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: Text(
                    'Prediction: $_predictionResult',
                    style: TextStyle(
                      color: primaryTextColor,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}