import 'package:flutter/material.dart';
import 'package:personal_portfrolio/screens/about_me_page.dart';
import 'package:personal_portfrolio/screens/contact_info.dart';
import 'package:personal_portfrolio/screens/projects_page.dart';
import 'package:personal_portfrolio/widgets/bottom_nav_bar.dart';
import 'package:personal_portfrolio/widgets/drawer_menu.dart';
import 'package:personal_portfrolio/widgets/section_container.dart';

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