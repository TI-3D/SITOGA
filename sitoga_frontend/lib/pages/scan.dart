// import 'package:camera/camera.dart';
// import 'package:flutter/material.dart';

// class CameraScannerPage extends StatefulWidget {
//   @override
//   _CameraScannerPageState createState() => _CameraScannerPageState();
// }

// class _CameraScannerPageState extends State<CameraScannerPage>
//     with SingleTickerProviderStateMixin {
//   late CameraController _cameraController;
//   bool _isCameraInitialized = false;

//   @override
//   void initState() {
//     super.initState();
//     _initializeCamera();
//   }

//   Future<void> _initializeCamera() async {
//     final cameras = await availableCameras();
//     final firstCamera = cameras.first;
//     _cameraController = CameraController(
//       firstCamera,
//       ResolutionPreset.high,
//     );

//     await _cameraController.initialize();

//     setState(() {
//       _isCameraInitialized = true;
//     });
//   }

//   @override
//   void dispose() {
//     _cameraController.dispose();
//     super.dispose();
//   }

//   Future<void> _takePicture() async {
//     try {
//       final image = await _cameraController.takePicture();
//       print("Image taken: ${image.path}");
//       // Tambahkan logika untuk menyimpan atau menampilkan foto di sini.
//     } catch (e) {
//       print("Error while taking picture: $e");
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Stack(
//         children: [
//           // Tampilan kamera
//           if (_isCameraInitialized)
//             Positioned.fill(
//               child: CameraPreview(_cameraController),
//             )
//           else
//             Center(child: CircularProgressIndicator()),

//           // Teks "Scanner" dan tombol kembali di bagian atas layar
//           Positioned(
//             top: 40,
//             left: 0,
//             right: 0,
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 IconButton(
//                   icon: Icon(Icons.arrow_back, color: Colors.white),
//                   onPressed: () {
//                     Navigator.pop(context);
//                   },
//                 ),
//                 Text(
//                   'Scanner',
//                   style: TextStyle(
//                     color: Colors.white,
//                     fontSize: 28,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//                 SizedBox(width: 48), // Placeholder for the back button
//               ],
//             ),
//           ),

//           // Bingkai melengkung di sekitar area kamera (tidak menyertakan seluruh area)
//           Center(
//             child: Container(
//               width: MediaQuery.of(context).size.width * 0.8,
//               height: MediaQuery.of(context).size.height * 0.5,
//               decoration: BoxDecoration(
//                 border: Border.all(color: Colors.white, width: 3),
//                 borderRadius: BorderRadius.circular(20),
//               ),
//             ),
//           ),

//           // Tombol Capture di bagian bawah
//           Positioned(
//             bottom: 50,
//             left: 0,
//             right: 0,
//             child: Center(
//               child: ElevatedButton(
//                 onPressed: _takePicture,
//                 style: ElevatedButton.styleFrom(
//                   shape: CircleBorder(),
//                   padding: EdgeInsets.all(20),
//                   backgroundColor: Colors.green,
//                 ),
//                 child: Icon(
//                   Icons.camera_alt,
//                   color: Colors.white,
//                   size: 30,
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class CameraScannerPage extends StatefulWidget {
  @override
  _CameraScannerPageState createState() => _CameraScannerPageState();
}

class _CameraScannerPageState extends State<CameraScannerPage>
    with SingleTickerProviderStateMixin {
  late CameraController _cameraController;
  late final ImagePicker _picker = ImagePicker();
  bool _isCameraInitialized = false;
  String _selectedOption = "Camera"; // Default option

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    final cameras = await availableCameras();
    final firstCamera = cameras.first;
    _cameraController = CameraController(
      firstCamera,
      ResolutionPreset.high,
    );

    await _cameraController.initialize();

    setState(() {
      _isCameraInitialized = true;
    });
  }

  @override
  void dispose() {
    _cameraController.dispose();
    super.dispose();
  }

  Future<void> _takePicture() async {
    try {
      final image = await _cameraController.takePicture();
      print("Image taken: ${image.path}");
      // Add logic to process or display the captured image
    } catch (e) {
      print("Error while taking picture: $e");
    }
  }

  Future<void> _getImageFromGallery() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      // Add logic to process or display the uploaded image from gallery
      print("Image selected from gallery: ${pickedFile.path}");
    }
  }

  void _handleOptionChange(String value) {
    setState(() {
      _selectedOption = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text("Scanner")),
      ),
      body: Column(
        children: [
          // Segmented Control to switch between Camera and Gallery
          Container(
            padding: EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () => _handleOptionChange("Camera"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _selectedOption == "Camera" ? Colors.green : Colors.grey,
                  ),
                  child: Text("Camera"),
                ),
                SizedBox(width: 16.0),
                ElevatedButton(
                  onPressed: () => _handleOptionChange("Gallery"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _selectedOption == "Gallery" ? Colors.green : Colors.grey,
                  ),
                  child: Text("Gallery"),
                ),
              ],
            ),
          ),

          // Tampilan kamera (conditionally shown)
          if (_selectedOption == "Camera" && _isCameraInitialized)
            Expanded(
              child: CameraPreview(_cameraController),
            ),

          // Center progress indicator while initializing camera
          if (!_isCameraInitialized)
            Center(child: CircularProgressIndicator()),

          // Tombol Capture (conditionally shown)
          if (_selectedOption == "Camera")
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton(
                onPressed: _takePicture,
                style: ElevatedButton.styleFrom(
                  shape: CircleBorder(),
                  padding: EdgeInsets.all(20),
                  backgroundColor: Colors.green,
                ),
                child: Icon(
                  Icons.camera_alt,
                  color: Colors.white,
                  size: 30,
                ),
              ),
            ),

          // Logika untuk memilih gambar dari galeri jika dipilih
          if (_selectedOption == "Gallery")
            Expanded(
              child: Center(
                child: ElevatedButton(
                  onPressed: _getImageFromGallery,
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.all(15),
                    backgroundColor: Colors.blue,
                  ),
                  child: Text(
                    "Select Image from Gallery",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
