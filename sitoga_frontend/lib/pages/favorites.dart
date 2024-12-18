import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../config/config.dart';
import 'plant_detail.dart';

class FavoritePage extends StatefulWidget {
  const FavoritePage({Key? key}) : super(key: key);

  @override
  _FavoritePageState createState() => _FavoritePageState();
}

class _FavoritePageState extends State<FavoritePage> {
  List<Map<String, dynamic>> favorites = [];
  bool isLoading = true;
  int? userId; // ID pengguna untuk data favorit

  @override
  void initState() {
    super.initState();
    _getUserId();
  }

  // Ambil user_id dari SharedPreferences
  Future<void> _getUserId() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    int? storedUserId = prefs.getInt('user_id');
    
    if (storedUserId != null) {
      setState(() {
        userId = storedUserId;
      });
      _fetchFavoritePlants(); // Ambil data favorit jika ada userId
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
        body: {'user_id': userId.toString(), 'limit': '10'}, // Ganti limit sesuai kebutuhan
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);

        if (responseData['status'] == 'success') {
          setState(() {
            favorites = List<Map<String, dynamic>>.from(responseData['data']);
          });
        } else {
          print('Gagal mengambil data favorit: ${responseData['detail']}');
        }
      } else {
        print('Error: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching favorite plants: $e');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  // Fungsi untuk menghapus favorit dari backend
  Future<void> _removeFavorite(int plantId) async {
    if (userId == null) {
      print("User ID tidak ditemukan.");
      return;
    }

    try {
      final response = await http.delete(
        Uri.parse('${AppConfig.baseUrl}/favorite/favorite/delete'),
        body: {
          'user_id': userId.toString(),
          'plant_id': plantId.toString(),
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);

        if (responseData['status'] == 'success') {
          print('Favorite berhasil dihapus');
        } else {
          print('Gagal menghapus favorit: ${responseData['detail']}');
        }
      } else {
        print('Error: ${response.statusCode}');
      }
    } catch (e) {
      print('Error removing favorite: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        ScaffoldMessenger.of(context).clearSnackBars();
        return true; // Mengizinkan pop (navigasi kembali)
      },
      child: Scaffold(
        appBar: AppBar(
          leading: BackButton(),
          title: const Text('Favorites'),
          backgroundColor: Color(0XFF72BF78),
        ),
        body: isLoading
            ? const Center(child: CircularProgressIndicator())
            : Container(
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
                child: favorites.isEmpty
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
                            color: Color(0XFFDFF5D8), // Warna elemen kartu
                            child: ListTile(
                              leading: GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => PlantDetailPage(
                                        plantData: plant,
                                      ),
                                    ),
                                  );
                                },
                                child: Image.network(
                                  plant['image_path'] ?? 'assets/placeholder.jpg',
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
                                      builder: (context) => PlantDetailPage(
                                        plantData: plant,
                                      ),
                                    ),
                                  );
                                },
                                child: Text(
                                  plant['plant_name'] ?? "Tanaman Tanpa Nama",
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0XFF1A5319),
                                  ),
                                ),
                              ),
                              subtitle: Text(
                                plant['nama_latin'] ?? 'Nama Latin',
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontStyle: FontStyle.italic,
                                  color: Color(0XFF1A5319),
                                ),
                              ),
                              trailing: IconButton(
                                icon: const Icon(Icons.delete, color: Colors.red),
                                onPressed: () async {
                                  final plant = favorites[index];
                                  int plantId = plant['plant_id']; // Mengambil ID tanaman

                                  // Menghapus favorit dari backend
                                  await _removeFavorite(plantId);

                                  // Menghapus tanaman dari daftar lokal
                                  setState(() {
                                    favorites.removeAt(index);
                                  });

                                  // Menampilkan pesan di layar
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text('${plant['plant_name']} removed from favorites!'),
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
