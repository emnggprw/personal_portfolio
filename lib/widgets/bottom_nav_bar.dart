import 'package:flutter/material.dart';

class BottomNavBar extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onItemTapped;

  const BottomNavBar({super.key, required this.selectedIndex, required this.onItemTapped});

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: selectedIndex,
      onTap: onItemTapped,
      selectedItemColor: Colors.deepPurpleAccent,  // Color when selected
      unselectedItemColor: Colors.white70,        // Color when unselected
      items: [
        BottomNavigationBarItem(
          icon: Icon(Icons.person),
          label: 'About Me',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.work),
          label: 'Projects',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.contact_mail),
          label: 'Contact Info',
        ),
      ],
      selectedLabelStyle: TextStyle(
        fontWeight: FontWeight.bold, // Bold when selected
      ),
      unselectedLabelStyle: TextStyle(
        fontWeight: FontWeight.normal, // Normal when not selected
      ),
    );
  }
}