import 'package:flutter/material.dart';
import 'plant_detail.dart';

class LibraryPage extends StatefulWidget {
  @override
  _LibraryPageState createState() => _LibraryPageState();
}

class _LibraryPageState extends State<LibraryPage> {
  final TextEditingController _libraryController = TextEditingController();
  List<Map<String, String>> allPlants = [
    {"name": "Sirih", "image": "assets/toga_sirih.jpg"},
    {"name": "Belimbing Wuluh", "image": "assets/belimbing_wuluh.jpg"},
    {"name": "Jeruk Nipis", "image": "assets/jeruk_nipis.jpg"},
    {"name": "Nangka", "image": "assets/nangka.jpg"},
  ];
  List<Map<String, String>> displayedPlants = [];
  List<Map<String, String>> filteredPlants = [];

  bool showDropdown = false;

  @override
  void initState() {
    super.initState();
    displayedPlants = allPlants;
    _libraryController.addListener(_onSearchChanged);
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
          .where((plant) => plant["name"]!.toLowerCase().contains(searchQuery))
          .toList();
      showDropdown = searchQuery.isNotEmpty;
    });
  }

  void _selectPlant(String plantName) {
    setState(() {
      _libraryController.text = plantName;
      displayedPlants = allPlants
          .where((plant) =>
              plant["name"]!.toLowerCase() == plantName.toLowerCase())
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
                          plant["name"]!,
                          style: TextStyle(color: Colors.white),
                        ),
                        onTap: () => _selectPlant(plant["name"]!),
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
                  name: plant["name"]!,
                  imagePath: plant["image"]!,
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
                        image: AssetImage(imagePath),
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
