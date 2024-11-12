import 'package:flutter/material.dart';

class BottomNavBar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onTap;

  const BottomNavBar({
    Key? key,
    required this.selectedIndex,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      backgroundColor: Colors.black54,
      currentIndex: selectedIndex,
      onTap: onTap,
      items: [
        BottomNavigationBarItem(
          icon: Icon(Icons.home, color: selectedIndex == 0 ? Colors.green : Colors.white),
          label: '',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.grid_view, color: selectedIndex == 1 ? Colors.green : Colors.white),
          label: '',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.exit_to_app, color: selectedIndex == 2 ? Colors.green : Colors.white),
          label: '',
        ),
      ],
    );
  }
}
