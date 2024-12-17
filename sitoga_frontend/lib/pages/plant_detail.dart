import 'package:flutter/material.dart';

class PlantDetailPage extends StatelessWidget {
  final Map<String, dynamic> plantData;

  const PlantDetailPage({Key? key, required this.plantData}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String plantName = plantData['plant_name'] ?? 'Tanaman Tidak Diketahui';
    String description = plantData['description'] ?? 'Tidak ada deskripsi tersedia.';
    String plantImage = plantData['image'] ?? 'assets/placeholder.jpg';

    return Scaffold(
      appBar: AppBar(
        title: Text('Detail Tanaman'),
        backgroundColor: Color(0XFF72BF78),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color(0XFF72BF78),
                    Color(0XFFFA0D683),
                    Color(0XFFF1F8E8),
                  ],
                  stops: [0.01, 0.1, 1.0],
                  begin: Alignment.topCenter,
                  end: Alignment.center,
                ),
              ),
            ),
          ),
          SafeArea(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(height: MediaQuery.of(context).size.height * 0.12),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12.0),
                      border: Border.all(color: Colors.white, width: 2.0),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12.0),
                      child: Image.network(
                        plantImage,
                        width: 180,
                        height: 180,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Image.asset(
                            'assets/placeholder.jpg',
                            width: 180,
                            height: 180,
                            fit: BoxFit.cover,
                          );
                        },
                      ),
                    ),
                  ),
                  SizedBox(height: 16),
                  Text(
                    plantName,
                    style: TextStyle(
                      color: Color(0XFF1A5319),
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 16),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Text(
                      description,
                      textAlign: TextAlign.justify,
                      style: TextStyle(
                        color: Color(0XFF1A5319),
                        fontSize: 16,
                      ),
                    ),
                  ),
                  SizedBox(height: 220),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
