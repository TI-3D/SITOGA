import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'dart:typed_data';
import 'dart:convert';
import 'package:flutter/foundation.dart' show kIsWeb;
import '../config/config.dart';
import 'plant_detail.dart';

class PredictionResultDialog extends StatelessWidget {
  final Map<String, dynamic> result;

  const PredictionResultDialog({Key? key, required this.result}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      backgroundColor: Color(0XFFA0D683),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Prediction Result',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0XFF1A5319),
              ),
            ),
            SizedBox(height: 15),
            Text(
              'Plant: ${result['plant_name']}',
              style: TextStyle(fontSize: 16, color: Color(0XFF1A5319)),
            ),
            Text(
              'Confidence: ${(result['confidence'] * 100).toStringAsFixed(1)}%',
              style: TextStyle(fontSize: 16, color: Color(0XFF1A5319)),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 241, 89, 78),
                  ),
                  onPressed: () => Navigator.pop(context),
                  child: Text('Close'),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0XFF72BF78),
                  ),
                  onPressed: () {
                    Navigator.pop(context); // Close dialog
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PlantDetailPage(plantData: result),
                      ),
                    );
                  },
                  child: Text(
                    'View Details',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class CameraScannerPage extends StatefulWidget {
  @override
  _CameraScannerPageState createState() => _CameraScannerPageState();
}

class _CameraScannerPageState extends State<CameraScannerPage> {
  File? _imageFile;
  Uint8List? _webImage;
  final ImagePicker _picker = ImagePicker();
  bool _isLoading = false;
  String? _errorMessage;

  double? _predictionResult;

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
      if (kIsWeb) {
        final bytes = await pickedFile.readAsBytes();
        setState(() {
          _webImage = bytes;
          _imageFile = null;
          _predictionResult = null;
          _errorMessage = null;
        });
      } else {
        setState(() {
          _imageFile = File(pickedFile.path);
          _webImage = null;
          _predictionResult = null;
          _errorMessage = null;
        });
      }
    }
  }

  Future<void> _getImageFromFile() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['jpg', 'jpeg', 'png'],
        withData: true, // Important for web
      );

      if (result != null) {
        if (kIsWeb) {
          setState(() {
            _webImage = result.files.first.bytes;
            _imageFile = null;
            _predictionResult = null;
            _errorMessage = null;
          });
        } else {
          setState(() {
            _imageFile = File(result.files.single.path!);
            _webImage = null;
            _predictionResult = null;
            _errorMessage = null;
          });
        }
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Error picking file: ${e.toString()}';
      });
    }
  }

  Future<void> _predictImage() async {
    if (_imageFile == null && _webImage == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please select an image first')),
      );
      return;
    }

    // Show loading dialog
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(),
                SizedBox(height: 15),
                Text('Please wait...\nProcessing your image'),
              ],
            ),
          ),
        );
      },
    );

    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      int? userId = prefs.getInt('user_id');

      if (userId == null) {
        throw Exception('User not logged in');
      }

      var request = http.MultipartRequest(
        'POST', 
        Uri.parse('${AppConfig.baseUrl}/predict/predict')
      );

      request.fields['user_id'] = userId.toString();

      if (kIsWeb && _webImage != null) {
        request.files.add(
          http.MultipartFile.fromBytes(
            'file',
            _webImage!,
            filename: 'image.jpg',
          )
        );
      } else if (!kIsWeb && _imageFile != null) {
        request.files.add(
          await http.MultipartFile.fromPath(
            'file',
            _imageFile!.path
          )
        );
      }

      var response = await request.send();
      var responseBody = await response.stream.bytesToString();

      // Close loading dialog
      Navigator.pop(context);

      if (response.statusCode == 200) {
        var jsonResponse = json.decode(responseBody);
        var result = jsonResponse['data'];

        // Show result dialog
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return PredictionResultDialog(result: result);
          },
        );
      } else {
        print('Response body: $responseBody');
        throw Exception('Failed to predict image: ${response.statusCode}');
      }
    } catch (e) {
      // Close loading dialog if still showing
      Navigator.pop(context);
      
      setState(() {
        _errorMessage = 'Error: ${e.toString()}';
      });
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to process image: ${e.toString()}')),
      );
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
              if (_imageFile != null || _webImage != null)
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
                    child: _webImage != null
                      ? Image.memory(
                          _webImage!,
                          fit: BoxFit.cover,
                        )
                      : Image.file(
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
                      icon: Icons.folder,
                      label: 'Browse',
                      onPressed: _getImageFromFile,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
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