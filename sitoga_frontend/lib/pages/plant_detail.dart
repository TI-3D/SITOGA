import 'package:flutter/material.dart';

class PlantDetailPage extends StatelessWidget {
  final String plantName = 'Ginkgo';
  final String latinName = 'Ginkgo biloba';
  final String description = 'Ginkgo biloba, also known as the maidenhair tree, is a large tree with fan-shaped leaves. '
      'It is one of the oldest living tree species in the world, dating back more than 200 million years. '
      'It is native to China, where its seeds have been used for centuries in traditional Chinese medicine to help improve cognitive health and treat asthma, bronchitis, and kidney and bladder disorders. '
      'Ginkgo biloba is also used as an herbal supplement extracted from ginkgo biloba tree leaves to help improve memory, brain function, and blood flow. '
      'In ipsum diam orci morbi ultricies massa amet. Aenean urna phasellus eget '
      'vestibulum, vulputate dui auctor sed est. Lorem ipsum dolor sit amet, consectetur '
      'adipiscing elit. Turpis dictum egestas dolor egestas.';
  final String plantImage = 'assets/flower.jpg';
  final List<String> benefits = [
    'Meningkatkan kesehatan otak',
    'Meningkatkan sirkulasi darah',
    'Membantu pengobatan penyakit Alzheimer',
    'Mengurangi kecemasan dan stres',
    'Menjaga kesehatan mata'
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black.withOpacity(0.8),
        title: Text('Know about Plants'),
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
          // Background gambar tanaman dengan overlay semi-transparan
          Positioned.fill(
            child: Stack(
              children: [
                Image.asset(
                  plantImage,
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: MediaQuery.of(context).size.height * 0.25,
                ),
                Container(
                  color: Colors.black.withOpacity(0.6), // Overlay semi-transparan
                ),
              ],
            ),
          ),
          // Konten di atas background
          SafeArea(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(height: MediaQuery.of(context).size.height * 0.12),
                  // Gambar tanaman di tengah halaman
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12.0),
                      border: Border.all(color: Colors.white, width: 2.0),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12.0),
                      child: Image.asset(
                        plantImage,
                        width: 180,
                        height: 180,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  SizedBox(height: 16),
                  // Nama tanaman dan nama latin
                  Text(
                    plantName,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    latinName,
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 18,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                  SizedBox(height: 16),
                  // Deskripsi tanaman
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Text(
                      description,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  SizedBox(height: 24),
                  // Manfaat tanaman
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Manfaat',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 12),
                        // Daftar manfaat
                        ...benefits.map((benefit) => Padding(
                          padding: const EdgeInsets.only(bottom: 8.0),
                          child: Row(
                            children: [
                              Icon(Icons.check, color: Colors.green, size: 20),
                              SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  benefit,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )),
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
