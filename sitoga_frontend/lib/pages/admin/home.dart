import 'package:flutter/material.dart';
import '/widgets/admin/bottom_navbar.dart';
import 'plant_manage.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Row(
          children: [
            IconButton(
              icon: Icon(Icons.menu, color: Colors.white),
              onPressed: () {},
            ),
            SizedBox(width: 8),
            Text("Hi Abby", style: TextStyle(color: Colors.white, fontSize: 20)),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Jumlah Tanaman", style: TextStyle(color: Colors.white, fontSize: 18)),
              SizedBox(height: 8),
              _buildInfoCard("Tanaman", "8", Icons.local_florist, Colors.green),

              SizedBox(height: 16),
              Text("Jumlah Pengguna", style: TextStyle(color: Colors.white, fontSize: 18)),
              SizedBox(height: 8),
              _buildInfoCard("Pengguna", "500", Icons.person, Colors.white),

              SizedBox(height: 16),
              Text("Menu", style: TextStyle(color: Colors.white, fontSize: 18)),
              SizedBox(height: 8),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => KelolaTanamanPage()),
                  );
                },
                child: _buildInfoCard("Kelola Tanaman", "", Icons.grid_view, Colors.blue),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavBar(
        selectedIndex: _selectedIndex,
        onTap: (index) {
          if (index == 1) {
            Navigator.pushReplacementNamed(context, '/managePlant'); // Pindah ke halaman Dashboard
          } else if (index == 2) {
            Navigator.pushReplacementNamed(context, '/logout'); // Pindah ke halaman Logout
          }
        },
      ),
    );
  }

  Widget _buildInfoCard(String title, String count, IconData icon, Color iconColor) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.black54,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.white),
      ),
      padding: EdgeInsets.all(16),
      child: Row(
        children: [
          Icon(icon, color: iconColor, size: 40),
          SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
              ),
              if (count.isNotEmpty)
                Text(
                  count,
                  style: TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
