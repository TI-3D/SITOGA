import 'package:flutter/material.dart';
import 'plant_detail.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class LibraryPage extends StatefulWidget {
  @override
  _LibraryPageState createState() => _LibraryPageState();
}

class _LibraryPageState extends State<LibraryPage> {
  Future<List<Map<String, dynamic>>> fetchPlants() async {
    final response =
        await http.get(Uri.parse('http://127.0.0.1:8000/db/plants'));

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      print(response.body);
      return data
          .map((plant) => {
                "plant_name": plant["plant_name"], // Sesuaikan key ini
                "image": plant["image_path"],
                "description": plant["description"],
              })
          .toList();
    } else {
      print('Error: ${response.statusCode}');
      throw Exception('Failed to load plants');
    }
  }

  final TextEditingController _libraryController = TextEditingController();
  List<Map<String, dynamic>> allPlants = [];
  List<Map<String, dynamic>> displayedPlants = [];
  List<Map<String, dynamic>> filteredPlants = [];
  bool showDropdown = false;

  @override
  void initState() {
    super.initState();
    _fetchAndSetPlants();
    _libraryController.addListener(_onSearchChanged);
  }

  void _fetchAndSetPlants() async {
    try {
      final plants = await fetchPlants();
      setState(() {
        allPlants = plants;
        displayedPlants = allPlants;
      });
    } catch (error) {
      print('Error fetching plants: $error');
    }
  }

  @override
  void dispose() {
    _libraryController.removeListener(_onSearchChanged);
    _libraryController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    setState(() {
      String searchQuery = _libraryController.text.toLowerCase();
      filteredPlants = allPlants
          .where((plant) =>
              (plant["plant_name"] ?? '').toLowerCase().contains(searchQuery))
          .toList();
      showDropdown = searchQuery.isNotEmpty;
    });
  }

  void _selectPlant(String plantName) {
    setState(() {
      _libraryController.text = plantName;
      displayedPlants = allPlants
          .where((plant) =>
              (plant["plant_name"] ?? '').toLowerCase() ==
              plantName.toLowerCase())
          .toList();
      showDropdown = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black, // Latar belakang hitam
      padding: EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Search Bar with Dropdown
          Stack(
            children: [
              TextField(
                controller: _libraryController,
                decoration: InputDecoration(
                  hintText: "Search",
                  hintStyle: TextStyle(color: Colors.grey),
                  prefixIcon: Icon(Icons.search, color: Colors.white),
                  filled: true,
                  fillColor: Colors.grey[800],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide: BorderSide.none,
                  ),
                ),
                style: TextStyle(color: Colors.white),
              ),
              if (showDropdown)
                Container(
                  margin: EdgeInsets.only(top: 50),
                  decoration: BoxDecoration(
                    color: Colors.grey[800],
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: ListView.builder(
                    padding: EdgeInsets.zero,
                    itemCount: filteredPlants.length,
                    itemBuilder: (context, index) {
                      final plant = filteredPlants[index];
                      return ListTile(
                        title: Text(
                          plant["plant_name"] ?? '',
                          style: TextStyle(color: Colors.white),
                        ),
                        onTap: () => _selectPlant(plant["plant_name"] ?? ''),
                      );
                    },
                    shrinkWrap: true,
                  ),
                ),
            ],
          ),
          SizedBox(height: 16),

          // Display Plants
          Expanded(
            child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 8,
                crossAxisSpacing: 8,
                childAspectRatio: 0.8, // Sedikit diperpendek
              ),
              itemCount: displayedPlants.length,
              itemBuilder: (context, index) {
                final plant = displayedPlants[index];
                return PlantCard(
                  name: plant["plant_name"] ?? '',
                  imagePath: plant["image"] ?? '',
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class PlantCard extends StatelessWidget {
  final String name;
  final String imagePath;

  const PlantCard({
    Key? key,
    required this.name,
    required this.imagePath,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => PlantDetailPage(),
              ),
            );
          },
          child: Container(
            width: MediaQuery.of(context).size.width * 0.4,
            height: 140, // Lebih pendek
            decoration: BoxDecoration(
              color: Colors.grey[850],
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Container(
                    width: double.infinity,
                    height: 100, // Tinggi gambar tetap
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: imagePath.isNotEmpty
                            ? NetworkImage(imagePath)
                            : AssetImage('assets/placeholder.png')
                                as ImageProvider,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 8), // Tambahkan jarak antara gambar dan teks
                Text(
                  name,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center, // Tetap di tengah
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
