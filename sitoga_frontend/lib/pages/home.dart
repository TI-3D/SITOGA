import 'package:flutter/material.dart';
import 'library.dart';
import 'home_screen.dart';
import 'scan.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  // Halaman yang akan dituju berdasarkan item yang dipilih
  final List<Widget> _pages = [
    HomeScreen(), // HomePage
    HomeScreen(), // GridPage
    LibraryPage(), // LibraryPage
    LibraryPage(), // RecipePage
  ];

  void _onItemTapped(int index) {
    // Navigasi ke halaman yang sesuai
    if (index != _selectedIndex) {
      setState(() {
        _selectedIndex = index;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // AppBar yang berbeda berdasarkan halaman yang aktif
    AppBar appBar;
    switch (_selectedIndex) {
      case 0:
        appBar = AppBar(
          title: Text("Home Page"), // AppBar khusus untuk halaman HomePage
          backgroundColor: Colors.black,
        );
        break;
      case 1:
        appBar = AppBar(
          title: Text("Grid Page"), // AppBar khusus untuk halaman GridPage
          backgroundColor: Colors.black,
        );
        break;
      case 2:
        appBar = AppBar(
          title: Text("Library"), // AppBar khusus untuk halaman Library
          backgroundColor: Colors.black,
        );
        break;
      case 3:
        appBar = AppBar(
          title: Text("Recipe"), // AppBar khusus untuk halaman RecipePage
          backgroundColor: Colors.black,
        );
        break;
      default:
        appBar = AppBar(
          title: Text("Hi Abby"), // Default AppBar
        );
    }

    return Scaffold(
      appBar: appBar, // Menampilkan AppBar yang sesuai dengan halaman
      body: _pages[
          _selectedIndex], // Menampilkan halaman sesuai dengan index yang dipilih
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        backgroundColor: Colors.black,
        selectedItemColor: Colors.green,
        unselectedItemColor: Colors.white,
        showUnselectedLabels: false,
        type: BottomNavigationBarType.fixed,
        onTap: _onItemTapped, // Menambahkan fungsi _onItemTapped ke onTap
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.grid_view), label: 'Grid'),
          BottomNavigationBarItem(
            icon: ImageIcon(
              AssetImage("assets/icons/library_icon.png"),
            ),
            label: 'Library',
          ),
          BottomNavigationBarItem(
            icon: ImageIcon(
              AssetImage("assets/icons/recipe_icon.png"),
            ),
            label: 'Recipe',
          ),
        ],
      ),
      // Menambahkan FloatingActionButton untuk navigasi ke halaman ScanningPage
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    CameraScannerPage()), // Pindah ke halaman Scanning
          );
        },
        backgroundColor: Colors.green,
        child: Image.asset(
          "assets/icons/scan_icon.png",
          width: 24, // Adjust size as needed
          height: 24,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
