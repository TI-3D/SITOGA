import 'package:flutter/material.dart';
import '/widgets/admin/bottom_navbar.dart';

class EditTanamanPage extends StatelessWidget {
  const EditTanamanPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text("Edit Tanaman", style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Container(
                padding: EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: Colors.grey[900],
                  borderRadius: BorderRadius.circular(15.0),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildTextField("Nama Tanaman", initialValue: "Coleus"),
                    SizedBox(height: 16),
                    _buildTextField("Nama Ilmiah Tanaman", initialValue: "Coleus"),
                    SizedBox(height: 16),
                    _buildTextField("Deskripsi", initialValue: "Coleus adalah..."),
                    SizedBox(height: 16),
                    _buildTextField("Manfaat Kesehatan", initialValue: "Coleus"),
                    SizedBox(height: 16),
                    _buildTextField("Gambar"),
                  ],
                ),
              ),
            ),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    padding: EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text("Batal", style: TextStyle(fontSize: 18)),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    padding: EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                  ),
                  onPressed: () {
                    // logika untuk mengedit data
                  },
                  child: Text("Edit", style: TextStyle(fontSize: 18)),
                ),
              ],
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavBar(
        selectedIndex: 1,
        onTap: (index) {
          // Logika navigasi
          if (index == 0) {
            Navigator.pushNamed(context, '/home'); // Sesuaikan rute halaman utama
          }
        },
      ),
    );
  }

  Widget _buildTextField(String label, {String? initialValue}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 8),
        TextField(
          controller: TextEditingController(text: initialValue),
          style: TextStyle(color: Colors.white),
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.grey[800],
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide.none,
            ),
          ),
        ),
      ],
    );
  }
}
