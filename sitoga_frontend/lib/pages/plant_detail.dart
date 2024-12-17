import 'package:flutter/material.dart';

class PlantDetailPage extends StatelessWidget {
  final Map<String, dynamic> plantData;

  const PlantDetailPage({Key? key, required this.plantData}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String plantName = plantData['plant_name'] ?? 'Tanaman Tidak Diketahui';
    String latinName = plantData['latin_name'] ?? 'SITOGA';
    String description = plantData['description'] ?? 'Tidak ada deskripsi tersedia.';
    String plantImage = plantData['image'] ?? 'assets/placeholder.jpg'; 
    List<String> benefits = plantData['benefits'] ?? []; 

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
                  SizedBox(height: 8),
                  Text(
                    latinName,
                    style: TextStyle(
                      color: Color(0XFF1A5319),
                      fontSize: 18,
                      fontStyle: FontStyle.italic,
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
                  SizedBox(height: 24),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Manfaat',
                          style: TextStyle(
                            color: Color(0XFF1A5319),
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 12),
                        if (benefits.isEmpty)
                          Text('Tidak ada informasi manfaat untuk tanaman ini.'),
                        for (var benefit in benefits)
                          Padding(
                            padding: const EdgeInsets.only(bottom: 8.0),
                            child: Row(
                              children: [
                                Icon(Icons.check, color: Colors.green, size: 20),
                                SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    benefit,
                                    style: TextStyle(
                                      color: Color(0XFF1A5319),
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}