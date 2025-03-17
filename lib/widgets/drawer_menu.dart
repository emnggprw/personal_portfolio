import 'package:flutter/material.dart';

class DrawerMenu extends StatelessWidget {
  final Function(int) onItemTapped;

  const DrawerMenu({super.key, required this.onItemTapped});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(color: Colors.deepPurpleAccent),
            child: const Text('Menu', style: TextStyle(color: Colors.white, fontSize: 24)),
          ),
          ListTile(
            leading: const Icon(Icons.person),
            title: const Text('About Me'),
            onTap: () => onItemTapped(0),
          ),
          ListTile(
            leading: const Icon(Icons.work),
            title: const Text('Projects'),
            onTap: () => onItemTapped(1),
          ),
          ListTile(
            leading: const Icon(Icons.contact_mail),
            title: const Text('Contact Info'),
            onTap: () => onItemTapped(2),
          ),
        ],
      ),
    );
  }
}