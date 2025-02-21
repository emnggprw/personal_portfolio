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
  final ScrollController _scrollController = ScrollController();

  final GlobalKey aboutMeKey = GlobalKey();
  final GlobalKey projectsKey = GlobalKey();
  final GlobalKey contactKey = GlobalKey();

  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    final targetKey = [aboutMeKey, projectsKey, contactKey][index];
    Scrollable.ensureVisible(
      targetKey.currentContext!,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool isDesktop = MediaQuery.of(context).size.width > 800;

    return Scaffold(
      drawer: isDesktop ? null : DrawerMenu(onItemTapped: _onItemTapped),
      body: SingleChildScrollView(
        controller: _scrollController,
        child: Column(
          children: [
            SectionContainer(key: aboutMeKey, child: const AboutMePage()),
            SectionContainer(key: projectsKey, child: const ProjectsPage()),
            SectionContainer(key: contactKey, child: const ContactInfoPage()),
          ],
        ),
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

class SectionContainer extends StatelessWidget {
  final Widget child;

  const SectionContainer({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 40.0, horizontal: 16.0),
      child: child,
    );
  }
}

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
              "Hi! I'm a passionate developer who loves creating amazing applications. Explore my projects and feel free to reach out! This portfolio showcases my work and interests.",
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
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('My Projects', style: Theme.of(context).textTheme.headlineLarge),
            const SizedBox(height: 20),
            LayoutBuilder(
              builder: (context, constraints) {
                int crossAxisCount = constraints.maxWidth > 1000
                    ? 3
                    : constraints.maxWidth > 600
                    ? 2
                    : 1;
                return GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: crossAxisCount,
                    crossAxisSpacing: 24,
                    mainAxisSpacing: 24,
                    childAspectRatio: 0.85, // Adjusted for thumbnails and tags
                  ),
                  itemCount: projects.length,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    final project = projects[index];
                    return ProjectCard(
                      title: project['title']!,
                      description: project['description']!,
                      imageUrl: project['imageUrl']!,
                      techStack: project['techStack']!,
                      projectUrl: project['projectUrl']!,
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class ProjectCard extends StatefulWidget {
  final String title;
  final String description;
  final String imageUrl;
  final List<String> techStack;
  final String projectUrl;

  const ProjectCard({
    super.key,
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.techStack,
    required this.projectUrl,
  });

  @override
  _ProjectCardState createState() => _ProjectCardState();
}

class _ProjectCardState extends State<ProjectCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        transform: _isHovered
            ? (Matrix4.identity()..translate(0, -5, 0)..scale(1.05))
            : Matrix4.identity(),
        decoration: BoxDecoration(
          boxShadow: _isHovered
              ? [BoxShadow(color: Colors.blueAccent.withOpacity(0.4), blurRadius: 20, spreadRadius: 5)]
              : [],
          borderRadius: BorderRadius.circular(12),
        ),
        child: Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Project Thumbnail
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    widget.imageUrl,
                    height: 150,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(height: 10),
                // Project Title
                Text(widget.title, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                const SizedBox(height: 5),
                // Project Description
                Text(widget.description, style: const TextStyle(fontSize: 16)),
                const SizedBox(height: 10),
                // Tech Stack Tags
                Wrap(
                  spacing: 8.0,
                  children: widget.techStack
                      .map((tag) => Chip(
                    label: Text(tag),
                    backgroundColor: Colors.blue.shade100,
                  ))
                      .toList(),
                ),
                const Spacer(),
                // View Project Button
                Align(
                  alignment: Alignment.bottomRight,
                  child: ElevatedButton(
                    onPressed: () => _launchURL(widget.projectUrl),
                    child: const Text('View Project'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _launchURL(String url) {
    // Dummy function for project link. Replace with actual URL launcher.
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Opening: $url')),
    );
  }
}

final List<Map<String, dynamic>> projects = [
  {
    'title': 'Chat App',
    'description': 'A real-time chat app with secure messaging and user-friendly interface.',
    'imageUrl': 'https://via.placeholder.com/300x150',
    'techStack': ['Flutter', 'Firebase', 'Dart'],
    'projectUrl': 'https://example.com/chat-app',
  },
  {
    'title': 'AI Image Generator',
    'description': 'Generate stunning images based on text prompts using AI.',
    'imageUrl': 'https://via.placeholder.com/300x150',
    'techStack': ['Flutter', 'Python', 'OpenAI API'],
    'projectUrl': 'https://example.com/ai-image-generator',
  },
  {
    'title': 'TV Show Scheduler App',
    'description': 'Track and schedule your favorite TV shows easily.',
    'imageUrl': 'https://via.placeholder.com/300x150',
    'techStack': ['Flutter', 'REST API', 'SQLite'],
    'projectUrl': 'https://example.com/tv-show-scheduler',
  },
  {
    'title': 'Map App',
    'description': 'Interactive map application with custom pins and navigation.',
    'imageUrl': 'https://via.placeholder.com/300x150',
    'techStack': ['Flutter', 'Google Maps API'],
    'projectUrl': 'https://example.com/map-app',
  },
  {
    'title': 'Employee Management App',
    'description': 'Manage employee data, schedules, and tasks efficiently.',
    'imageUrl': 'https://via.placeholder.com/300x150',
    'techStack': ['Flutter', 'Firebase', 'Cloud Firestore'],
    'projectUrl': 'https://example.com/employee-management-app',
  },
  {
    'title': 'AI Assistant App',
    'description': 'Virtual assistant for task automation and quick answers.',
    'imageUrl': 'https://via.placeholder.com/300x150',
    'techStack': ['Flutter', 'Dart', 'AI SDK'],
    'projectUrl': 'https://example.com/ai-assistant-app',
  },
];


class ContactInfoPage extends StatelessWidget {
  const ContactInfoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Contact Me', style: Theme.of(context).textTheme.headlineLarge),
            const SizedBox(height: 10),
            const Text('Get in touch with me at: example@email.com', style: TextStyle(fontSize: 18)),
          ],
        ),
      ),
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
