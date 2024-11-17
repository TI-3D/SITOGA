import 'package:flutter/material.dart';
import 'plant_detail.dart'; // Halaman detail tanaman

class FavoritePage extends StatefulWidget {
  const FavoritePage({Key? key}) : super(key: key);

  @override
  _FavoritePageState createState() => _FavoritePageState();
}

class _FavoritePageState extends State<FavoritePage> {
  // Data dummy untuk tanaman favorit
  final List<Map<String, dynamic>> favorites = [
    {
      'name': 'Ginkgo',
      'latinName': 'Ginkgo biloba',
      'description':
          'Ginkgo biloba, also known as the maidenhair tree, is a large tree with fan-shaped leaves. '
          'It is one of the oldest living tree species in the world, dating back more than 200 million years. '
          'It is native to China, where its seeds have been used for centuries in traditional Chinese medicine.',
      'image': 'assets/flower.jpg',
      'benefits': [
        'Meningkatkan kesehatan otak',
        'Meningkatkan sirkulasi darah',
        'Membantu pengobatan penyakit Alzheimer',
        'Mengurangi kecemasan dan stres',
        'Menjaga kesehatan mata',
      ]
    },
    {
      'name': 'Yarrow',
      'latinName': 'Achillea millefolium',
      'description':
          'Yarrow is a flowering plant in the family Asteraceae, native to temperate regions of the Northern Hemisphere. '
          'It is often grown as a garden plant and has been used traditionally for its medicinal properties.',
      'image': 'assets/nangka.jpg',
      'benefits': [
        'Meningkatkan sistem kekebalan tubuh',
        'Membantu penyembuhan luka',
        'Mengurangi gejala flu',
        'Meredakan peradangan',
      ]
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Favorites'),
        centerTitle: true,
        backgroundColor: Colors.green,
      ),
      body: favorites.isEmpty
          ? const Center(
              child: Text(
                'No Favorites Added',
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),
            )
          : ListView.builder(
              itemCount: favorites.length,
              itemBuilder: (context, index) {
                final plant = favorites[index];
                return Card(
                  margin: const EdgeInsets.symmetric(
                      horizontal: 16, vertical: 8),
                  child: ListTile(
                    leading: GestureDetector(
                      onTap: () {
                        // Navigasi ke halaman detail tanaman
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => PlantDetailPage(),
                          ),
                        );
                      },
                      child: Image.asset(
                        plant['image'], // Gambar tanaman
                        fit: BoxFit.cover,
                        width: 60,
                        height: 60,
                      ),
                    ),
                    title: GestureDetector(
                      onTap: () {
                        // Navigasi ke halaman detail tanaman
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => PlantDetailPage(),
                          ),
                        );
                      },
                      child: Text(
                        plant['name'], // Nama tanaman
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    subtitle: Text(
                      plant['latinName'], // Nama latin
                      style: const TextStyle(
                          fontSize: 14, fontStyle: FontStyle.italic),
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () {
                        setState(() {
                          // Hapus tanaman dari daftar
                          favorites.removeAt(index);
                        });
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('${plant['name']} removed!'),
                          ),
                        );
                      },
                    ),
                  ),
                );
              },
            ),
    );
  }
}
