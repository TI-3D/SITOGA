import 'package:flutter/material.dart';
import 'library.dart';
import 'home_screen.dart';
import 'scan.dart';
import 'recipe.dart';
import 'profile.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  // Halaman yang akan dituju berdasarkan item yang dipilih
  final List<Widget> _pages = [
    HomeScreen(), // HomePage
    LibraryPage(), // LibraryPage
    RecipePage(), // RecipePage
    ProfilePage(), // ProfilePage
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
          title: const Text("Home"),
          backgroundColor: Colors.black,
          automaticallyImplyLeading: false,
        );
        break;
      case 1:
        appBar = AppBar(
          title: const Text("Library"),
          backgroundColor: Colors.black,
          automaticallyImplyLeading: false,
        );
        break;
      case 2:
        appBar = AppBar(
          title: const Text("Recipe"),
          backgroundColor: Colors.black,
          automaticallyImplyLeading: false,
        );
        break;
      case 3:
        appBar = AppBar(
          title: const Text("Profile"),
          backgroundColor: Colors.black,
          automaticallyImplyLeading: false,
        );
        break;
      default:
        appBar = AppBar(
          title: const Text("Default"),
        );
    }

    return Scaffold(
      appBar: appBar, // Menampilkan AppBar yang sesuai dengan halaman
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        backgroundColor: Colors.black,
        selectedItemColor: Colors.green,
        unselectedItemColor: Colors.white,
        showUnselectedLabels: false,
        type: BottomNavigationBarType.fixed,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
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
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => CameraScannerPage()),
          );
        },
        backgroundColor: Colors.green,
        child: Image.asset(
          "assets/icons/scan_icon.png",
          width: 24,
          height: 24,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
