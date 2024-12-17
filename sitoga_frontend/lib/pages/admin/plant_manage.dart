import 'package:flutter/material.dart';
import '/widgets/admin/bottom_navbar.dart';
import '/widgets/admin/plant_delete_notif.dart';

class KelolaTanamanPage extends StatelessWidget {
  const KelolaTanamanPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text("Data Tanaman TOGA", style: TextStyle(color: Colors.white, fontSize: 24)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildTanamanCard(context, "Yarrow", "assets/flower.jpg"),
            SizedBox(height: 16),
            _buildTanamanCard(context, "Coleus", "assets/toga_sirih.jpg"),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // aksi untuk menambah tanaman
        },
        backgroundColor: Colors.blue,
        child: Icon(Icons.add, color: Colors.white),
      ),
      bottomNavigationBar: BottomNavBar(
        selectedIndex: 1,
        onTap: (index) {
          if (index == 0) {
            Navigator.pushReplacementNamed(context, '/');
          } else if (index == 2) {
            Navigator.pushReplacementNamed(context, '/logout');
          }
        },
      ),
    );
  }

  Widget _buildTanamanCard(BuildContext context, String title, String imagePath) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.black54,
        borderRadius: BorderRadius.circular(10),
      ),
      padding: EdgeInsets.all(8),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.asset(
              imagePath,
              width: 80,
              height: 80,
              fit: BoxFit.cover,
            ),
          ),
          SizedBox(width: 16),
          Expanded(
            child: Text(
              title,
              style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          IconButton(
            icon: Icon(Icons.visibility, color: Colors.blue),
            onPressed: () {
              // aksi untuk melihat detail tanaman
            },
          ),
          IconButton(
            icon: Icon(Icons.edit, color: Colors.yellow),
            onPressed: () {
              // aksi untuk mengedit tanaman
            },
          ),
          IconButton(
            icon: Icon(Icons.delete, color: Colors.red),
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) => HapusTanamanDialog(
                  tanamanName: title,
                  onDelete: () {
                    // aksi untuk menghapus tanaman dari database atau daftar
                  },
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
