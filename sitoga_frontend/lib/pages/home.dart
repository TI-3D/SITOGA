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

  final List<Widget> _pages = [
    HomeScreen(),
    LibraryPage(),
    RecipePage(),
    ProfilePage(),
  ];

  void _onItemTapped(int index) {
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
          backgroundColor: Color(0XFF72BF78),
          automaticallyImplyLeading: false,
          titleTextStyle: TextStyle(
            color: Color(0XFF1A5319),
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        );
        break;
      case 1:
        appBar = AppBar(
          title: const Text("Library"),
          backgroundColor: Color(0XFF72BF78),
          automaticallyImplyLeading: false,
          titleTextStyle: TextStyle(
            color: Color(0XFF1A5319),
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        );
        break;
      case 2:
        appBar = AppBar(
          title: const Text("Recipe"),
          backgroundColor: Color(0XFF72BF78),
          automaticallyImplyLeading: false,
          titleTextStyle: TextStyle(
            color: Color(0XFF1A5319),
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        );
        break;
      case 3:
        appBar = AppBar(
          title: const Text("Profile"),
          backgroundColor: Color(0XFF72BF78),
          automaticallyImplyLeading: false,
          titleTextStyle: TextStyle(
            color: Color(0XFF1A5319),
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        );
        break;
      default:
        appBar = AppBar(
          title: const Text("Default"),
        );
    }

    return Scaffold(
      appBar: appBar,
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        backgroundColor: Color(0XFF72BF78),
        selectedItemColor: Color(0XFF1A5319),
        unselectedItemColor: Colors.white70,
        showUnselectedLabels: true,
        type: BottomNavigationBarType.fixed,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.grass), label: 'Library'),
          BottomNavigationBarItem(
            icon: ImageIcon(AssetImage("assets/icons/recipe_icon.png")),
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
        backgroundColor: Color(0XFF4CAF50),
        shape: CircleBorder(),
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
