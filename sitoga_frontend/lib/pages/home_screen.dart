import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../config/config.dart';
import 'dart:convert';
import 'plant_detail.dart'; // Import halaman detail tanaman

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String? username;
  int? userId; // ID pengguna untuk data favorit
  bool isLoading = true;
  List<Map<String, dynamic>> todayPlants = [];
  List<Map<String, dynamic>> favoritePlants = []; // Tambahan untuk favorit

  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
    _fetchTodayPlants();
  }

  // Cek status login dan ambil user data
  Future<void> _checkLoginStatus() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? storedUsername = prefs.getString('username');
    int? storedUserId = prefs.getInt('user_id'); // Ambil user_id

    setState(() {
      username = storedUsername;
      userId = storedUserId;
    });

    if (userId != null) {
      _fetchFavoritePlants(); // Ambil data favorit jika login
    }

    setState(() {
      isLoading = false;
    });
  }

  // Ambil data tanaman hari ini
  Future<void> _fetchTodayPlants() async {
    try {
      final response =
          await http.get(Uri.parse('${AppConfig.baseUrl}/db/plants?limit=2'));

      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        setState(() {
          todayPlants = List<Map<String, dynamic>>.from(data);
        });
      } else {
        print('Error: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching today plants: $e');
    }
  }

  // Ambil data tanaman favorit
  Future<void> _fetchFavoritePlants() async {
    if (userId == null) {
      print("User ID tidak ditemukan.");
      return;
    }

    try {
      final response = await http.post(
        Uri.parse('${AppConfig.baseUrl}/favorite/favorites'),
        body: {'user_id': userId.toString(), 'limit': '5'},
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);

        if (responseData['status'] == 'success') {
          setState(() {
            favoritePlants = List<Map<String, dynamic>>.from(responseData['data']);
          });
        } else {
          print('Gagal mengambil data favorit: ${responseData['detail']}');
        }
      } else {
        print('Error: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching favorite plants: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color(0XFF72BF78),
                    Color(0XFFA0D683),
                    Color(0XFFF1F8E8),
                  ],
                  stops: [0.01, 0.1, 1.0],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
              padding: EdgeInsets.all(16.0),
              child: ListView(
                children: [
                  _buildHeader(),
                  SizedBox(height: 10),
                  _buildSectionTitle("Pilihan Hari Ini"),
                  _buildPlantList(todayPlants),
                  if (userId != null) ...[
                    SizedBox(height: 10),
                    _buildSectionTitle("Tanaman Favorit Anda"),
                    _buildPlantList(favoritePlants),
                  ],
                ],
              ),
            ),
    );
  }

  Widget _buildHeader() {
    return Stack(
      children: [
        Container(
          height: 150,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            image: DecorationImage(
              image: AssetImage("assets/nangka.jpg"),
              fit: BoxFit.cover,
              colorFilter: ColorFilter.mode(
                  Colors.black.withOpacity(0.7), BlendMode.darken),
            ),
          ),
        ),
        Positioned(
          top: 16,
          left: 16,
          child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              username != null ? "Hi $username" : "Hi Guest",
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 60),
            if (username == null) // Jika pengguna adalah tamu
              InkWell(
                onTap: () {
                  // Navigasi ke halaman login
                  Navigator.pushNamed(context, '/login');
                },
                child: Text(
                  "Login",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
          ],
        ),
        ),
      ],
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 10),
      child: Text(
        title,
        style: TextStyle(
          color: Color(0XFF1A5319),
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildPlantList(List<Map<String, dynamic>> plants) {
    return Container(
      height: 280,
      child: plants.isEmpty
          ? Center(child: Text("Tidak ada data."))
          : ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: plants.length,
              itemBuilder: (context, index) {
                final plant = plants[index];
                return InkWell(
                  onTap: () {
                    // Navigasi ke halaman detail tanaman
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PlantDetailPage(
                          plantData: plant,
                        ),
                      ),
                    );
                  },
                  child: newPlantCard(
                    plant['plant_name'] ?? "Tanaman",
                    plant['description'] ?? "Deskripsi tanaman.",
                    plant['image_path'] ?? "assets/placeholder.jpg",
                  ),
                );
              },
            ),
    );
  }

  Widget newPlantCard(String name, String description, String imageUrl) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.5,
      margin: EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 1,
            blurRadius: 5,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
            child: Image.network(
              imageUrl,
              height: 120,
              width: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Image.asset(
                  "assets/placeholder.jpg",
                  height: 120,
                  width: double.infinity,
                  fit: BoxFit.cover,
                );
              },
            ),
          ),
          SizedBox(height: 8),
          Text(
            name,
            style: TextStyle(
              color: Color(0XFF1A5319),
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          SizedBox(height: 4),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Text(
              description,
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey, fontSize: 14),
              maxLines: 4,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          SizedBox(height: 8),
        ],
      ),
    );
  }
}
