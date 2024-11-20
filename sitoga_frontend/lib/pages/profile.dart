import 'package:flutter/material.dart';
import 'history.dart';
import 'favorites.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: 20),
          // Foto profil dan nama pengguna
          CircleAvatar(
            radius: 50,
            backgroundImage: AssetImage(
                'assets/flower.jpg'), // Tambahkan gambar profil di folder assets
          ),
          SizedBox(height: 10),
          Text(
            'User',
            style: TextStyle(
                color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
          ),
          Text(
            'User@gmail.com',
            style: TextStyle(color: Colors.grey, fontSize: 14),
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              // Aksi edit profil
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            child: Text('Edit Profile', style: TextStyle(color: Colors.white)),
          ),
          SizedBox(height: 30),
          // Daftar fitur
          Expanded(
            child: ListView(
              children: [
                ListTile(
                  leading: Icon(Icons.favorite, color: Colors.white),
                  title:
                      Text('Favorites', style: TextStyle(color: Colors.white)),
                  onTap: () {
                    // Navigasi ke halaman Favorites
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => FavoritePage(),
                      ),
                    );
                  },
                ),
                ListTile(
                  leading: Icon(Icons.history, color: Colors.white),
                  title: Text('History', style: TextStyle(color: Colors.white)),
                  onTap: () {
                    // Navigasi ke halaman History
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => HistoryPage(),
                      ),
                    );
                  },
                ),
                ListTile(
                  leading: Icon(Icons.logout, color: Colors.red),
                  title: Text('Log Out', style: TextStyle(color: Colors.red)),
                  onTap: () {
                    // Aksi logout
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
