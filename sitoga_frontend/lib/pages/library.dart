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
    try {
      final response = await http.get(Uri.parse('http://127.0.0.1:8000/db/plants/'));

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((plant) => {
          "plant_name": plant["plant_name"],
          "image": plant["image_path"],
          "description": plant["description"],
        }).toList();
      } else {
        throw Exception('Failed to load plants, status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching plants: $e');
      throw Exception('Error fetching plants: $e');
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

      if (searchQuery.isEmpty) {
        // Jika kolom pencarian kosong, tampilkan semua tanaman
        displayedPlants = allPlants;
        showDropdown = false;
      } else {
        // Jika ada teks pencarian, filter berdasarkan nama tanaman
        filteredPlants = allPlants
            .where((plant) =>
                (plant["plant_name"] ?? '').toLowerCase().contains(searchQuery))
            .toList();
        displayedPlants = filteredPlants;
        showDropdown = true;
      }
    });
  }

  void _selectPlant(String plantName) {
    setState(() {
      _libraryController.text = plantName;
      displayedPlants = allPlants
          .where((plant) =>
              (plant["plant_name"] ?? '').toLowerCase() == plantName.toLowerCase())
          .toList();
      showDropdown = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0XFF72BF78), // Green top
              Color(0XFFA0D683), // Green middle
              Color(0XFFF1F8E8), // Green bottom
            ],
            stops: [0.01, 0.1, 1.0],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
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
                    hintStyle: TextStyle(color: Color(0XFF1A5319)),
                    prefixIcon: Icon(Icons.search, color: Color(0XFF1A5319)),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  style: TextStyle(color: Color(0XFF1A5319)),
                ),
                if (showDropdown)
                  Container(
                    margin: EdgeInsets.only(top: 50),
                    decoration: BoxDecoration(
                      color: Colors.white,
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
                            style: TextStyle(color: Color(0XFF1A5319)),
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
                  childAspectRatio: 0.9, // Slightly adjusted aspect ratio
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
            height: 140, // Reduced height
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2), // Warna shadow
                  spreadRadius: 2, // Jarak sebar shadow
                  blurRadius: 8, // Blur effect
                  offset: Offset(0, 4), // Posisi shadow
                ),
              ],
            ),
            child: Column(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Container(
                    width: double.infinity,
                    height: 160, // Fixed image height
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: imagePath.isNotEmpty
                            ? NetworkImage(imagePath)
                            : AssetImage('assets/placeholder.jpg')
                                as ImageProvider,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 25), // Added space between image and text
                Text(
                  name,
                  style: TextStyle(
                    color: Color(0XFF1A5319), // Green text for plant name
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center, // Centered text
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
