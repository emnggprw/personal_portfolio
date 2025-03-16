import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Portfolio App',
      debugShowCheckedModeBanner: false,
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

  @override
  void initState() {
    super.initState();

    // Add a listener to the scroll controller to track scrolling.
    _scrollController.addListener(() {
      // Get the vertical offset of the 'About Me' section relative to the screen.
      double aboutMeOffset = aboutMeKey.currentContext?.findRenderObject()?.getTransformTo(null).getTranslation().y ?? 0;

      // Get the vertical offset of the 'Projects' section relative to the screen.
      double projectsOffset = projectsKey.currentContext?.findRenderObject()?.getTransformTo(null).getTranslation().y ?? 0;

      // Get the vertical offset of the 'Contact' section relative to the screen.
      double contactOffset = contactKey.currentContext?.findRenderObject()?.getTransformTo(null).getTranslation().y ?? 0;

      // Update the selected index based on the current scroll position.
      if (_scrollController.offset >= contactOffset - 100) {
        setState(() {
          _selectedIndex = 2; // Highlight "Contact" when scrolled near its section.
        });
      } else if (_scrollController.offset >= projectsOffset - 100) {
        setState(() {
          _selectedIndex = 1; // Highlight "Projects" when scrolled near its section.
        });
      } else if (_scrollController.offset >= aboutMeOffset - 100) {
        setState(() {
          _selectedIndex = 0; // Highlight "About Me" when scrolled near its section.
        });
      }
    });
  }


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
              backgroundImage: AssetImage('assets/images/profile_picture.png'),
            ),
            const SizedBox(height: 20),
            Text('Welcome to My Portfolio!', style: Theme.of(context).textTheme.headlineLarge),
            const SizedBox(height: 10),
            const Text(
              "Hi! I'm a graduate in MSc Data Science with a heavy technical background of BSc Computer Science. I'm a proud and passionate programmer, data visualization enthusiast, and an Android developer.",
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
        child: SingleChildScrollView(
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
                      childAspectRatio: 0.85,
                    ),
                    itemCount: projects.length,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      final project = projects[index];
                      return ProjectCard(
                        title: project['title']!,
                        description: project['description']!,
                        assetImagePath: project['assetImagePath']!,
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
      ),
    );
  }
}

class ProjectCard extends StatefulWidget {
  final String title;
  final String description;
  final String assetImagePath;
  final List<String> techStack;
  final String projectUrl;

  const ProjectCard({
    super.key,
    required this.title,
    required this.description,
    required this.assetImagePath,
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
                AspectRatio(
                  aspectRatio: 16 / 9,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      transform: _isHovered
                          ? (Matrix4.identity()..scale(1.1))
                          : Matrix4.identity(),
                      child: Image.asset(
                        widget.assetImagePath,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Text(widget.title, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                const SizedBox(height: 5),
                Expanded(
                  child: Text(
                  widget.description,
                    style: const TextStyle(fontSize: 16),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 3,
                  ),
                ),
                const SizedBox(height: 10),
                Wrap(
                  spacing: 8.0,
                  children: widget.techStack
                      .map((tag) => Chip(
                    label: Text(tag, style: const TextStyle(fontSize: 12)),
                    backgroundColor: Colors.deepPurpleAccent,
                  ))
                      .toList(),
                ),
                const SizedBox(height: 10),
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

  Future<void> _launchURL(String url, {bool isNewTab = true}) async {
    await launchUrl(
      Uri.parse(url),
      webOnlyWindowName: isNewTab ? '_blank' : '_self',
    );
  }
}

final List<Map<String, dynamic>> projects = [
  {
    'title': 'Chat App',
    'description': 'A real-time chat app with secure messaging and user-friendly interface.',
    'assetImagePath': 'assets/images/chat_app.png',
    'techStack': ['Flutter', 'Firebase', 'Dart'],
    'projectUrl': 'https://github.com/emnggprw/',
  },
  {
    'title': 'AI Image Generator',
    'description': 'Generate stunning images based on text prompts using AI.',
    'assetImagePath': 'assets/images/ai_image_generator.png',
    'techStack': ['Flutter', 'Python', 'OpenAI API'],
    'projectUrl': 'https://github.com/emnggprw/',
  },
  {
    'title': 'TV Show Scheduler App',
    'description': 'Track and schedule your favorite TV shows easily.',
    'assetImagePath': 'assets/images/tv_show_scheduler.png',
    'techStack': ['Flutter', 'REST API', 'SQLite'],
    'projectUrl': 'https://github.com/emnggprw/',
  },
  {
    'title': 'Map App',
    'description': 'Interactive map application with custom pins and navigation.',
    'assetImagePath': 'assets/images/map_app.png',
    'techStack': ['Flutter', 'Google Maps API'],
    'projectUrl': 'https://github.com/emnggprw/',
  },
  {
    'title': 'Employee Management App',
    'description': 'Manage employee data, schedules, and tasks efficiently.',
    'assetImagePath': 'assets/images/employee_management.png',
    'techStack': ['Flutter', 'Firebase', 'Cloud Firestore'],
    'projectUrl': 'https://github.com/emnggprw/',
  },
  {
    'title': 'AI Assistant App',
    'description': 'Virtual assistant for task automation and quick answers.',
    'assetImagePath': 'assets/images/ai_assistant.png',
    'techStack': ['Flutter', 'Dart', 'AI SDK'],
    'projectUrl': 'https://github.com/emnggprw/',
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
            const Text('Get in touch with me at: eko.mnggprw@gmail.com', style: TextStyle(fontSize: 18)),
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


