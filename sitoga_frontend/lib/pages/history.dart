import 'package:flutter/material.dart';
import 'plant_detail.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({Key? key}) : super(key: key);

  @override
  _HistoryPageState createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  final List<Map<String, dynamic>> history = [
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
    return WillPopScope(
      onWillPop: () async {
        // Handle back press logic here, returning true allows popping
        ScaffoldMessenger.of(context).clearSnackBars();
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          leading: BackButton(),
          title: const Text('History'),
          backgroundColor: Color(0XFF72BF78),
        ),
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color(0XFF72BF78), // Hijau atas
                Color(0XFFFA0D683), // Hijau bawah
                Color(0XFFF1F8E8), // Warna terang di bawah
              ],
              stops: [0.01, 0.1, 1.0],
              begin: Alignment.topCenter,
              end: Alignment.center,
            ),
          ),
          child: history.isEmpty
              ? const Center(
                  child: Text(
                    'No history Added',
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                )
              : ListView.builder(
                  itemCount: history.length,
                  itemBuilder: (context, index) {
                    final plant = history[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      color: Color(0XFFDFF5D8), // Warna elemen kartu
                      child: ListTile(
                        leading: GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => PlantDetailPage(),
                              ),
                            );
                          },
                          child: Image.asset(
                            plant['image'],
                            fit: BoxFit.cover,
                            width: 60,
                            height: 60,
                          ),
                        ),
                        title: GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => PlantDetailPage(),
                              ),
                            );
                          },
                          child: Text(
                            plant['name'],
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Color(0XFF1A5319), // Warna teks hijau
                            ),
                          ),
                        ),
                        subtitle: Text(
                          plant['latinName'],
                          style: const TextStyle(
                            fontSize: 14,
                            fontStyle: FontStyle.italic,
                            color: Color(0XFF1A5319), // Warna teks hijau
                          ),
                        ),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () {
                            setState(() {
                              history.removeAt(index);
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
        ),
      ),
    );
  }
}
