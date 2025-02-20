import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Portfolio App',
      theme: ThemeData(
        brightness: Brightness.dark,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurpleAccent, brightness: Brightness.dark),
        useMaterial3: true,
        textTheme: const TextTheme(
          headlineLarge: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.white),
          bodyMedium: TextStyle(fontSize: 16, color: Colors.white70),
        ),
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  final List<Widget> _pages = const [
    AboutMePage(),
    ProjectsPage(),
    ContactInfoPage(),
  ];

  @override
  Widget build(BuildContext context) {
    final bool isDesktop = MediaQuery.of(context).size.width > 800;

    return Scaffold(
      drawer: isDesktop ? null : const DrawerMenu(),
      body: Row(
        children: [
          if (isDesktop)
            NavigationRailMenu(
              selectedIndex: _selectedIndex,
              onDestinationSelected: _onItemTapped,
            ),
          Expanded(child: _pages[_selectedIndex]),
        ],
      ),
      bottomNavigationBar: isDesktop
          ? null
          : BottomNavBar(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }
}

class DrawerMenu extends StatelessWidget {
  const DrawerMenu({super.key});

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
            onTap: () => Navigator.pop(context),
          ),
          ListTile(
            leading: const Icon(Icons.work),
            title: const Text('Projects'),
            onTap: () => Navigator.pop(context),
          ),
          ListTile(
            leading: const Icon(Icons.contact_mail),
            title: const Text('Contact Info'),
            onTap: () => Navigator.pop(context),
          ),
        ],
      ),
    );
  }
}

class NavigationRailMenu extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onDestinationSelected;

  const NavigationRailMenu({super.key, required this.selectedIndex, required this.onDestinationSelected});

  @override
  Widget build(BuildContext context) {
    return NavigationRail(
      selectedIndex: selectedIndex,
      onDestinationSelected: onDestinationSelected,
      labelType: NavigationRailLabelType.all,
      destinations: const [
        NavigationRailDestination(icon: Icon(Icons.person), label: Text('About Me')),
        NavigationRailDestination(icon: Icon(Icons.work), label: Text('Projects')),
        NavigationRailDestination(icon: Icon(Icons.contact_mail), label: Text('Contact Info')),
      ],
    );
  }
}

class AboutMePage extends StatelessWidget {
  const AboutMePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const CircleAvatar(
              radius: 60,
              backgroundImage: AssetImage('assets/profile.jpg'),
            ),
            const SizedBox(height: 20),
            Text('Welcome to My Portfolio!', style: Theme.of(context).textTheme.headlineLarge),
            const SizedBox(height: 10),
            const Text(
              'I am a passionate developer eager to share my projects and journey with you.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }
}

class ProjectsPage extends StatelessWidget {
  const ProjectsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> projects = [
      {'title': 'Project 1', 'description': 'Description for project 1.'},
      {'title': 'Project 2', 'description': 'Description for project 2.'},
      {'title': 'Project 3', 'description': 'Description for project 3.'},
      {'title': 'Project 4', 'description': 'Description for project 4.'},
      {'title': 'Project 5', 'description': 'Description for project 5.'},
    ];

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          childAspectRatio: 1.5,
        ),
        itemCount: projects.length,
        itemBuilder: (context, index) {
          final project = projects[index];
          return Card(
            color: Colors.deepPurple[700],
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    project['title']!,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(color: Colors.white),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    project['description']!,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class ContactInfoPage extends StatelessWidget {
  const ContactInfoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('Get in touch with me at: example@email.com', style: Theme.of(context).textTheme.headlineLarge),
    );
  }
}

class BottomNavBar extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onItemTapped;

  const BottomNavBar({super.key, required this.selectedIndex, required this.onItemTapped});

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: selectedIndex,
      onTap: onItemTapped,
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.person), label: 'About Me'),
        BottomNavigationBarItem(icon: Icon(Icons.work), label: 'Projects'),
        BottomNavigationBarItem(icon: Icon(Icons.contact_mail), label: 'Contact Info'),
      ],
    );
  }
}
