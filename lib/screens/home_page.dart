import 'dart:math';
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

class _HomePageState extends State<HomePage> with SingleTickerProviderStateMixin {
  final ScrollController _scrollController = ScrollController();

  final GlobalKey aboutMeKey = GlobalKey();
  final GlobalKey projectsKey = GlobalKey();
  final GlobalKey contactKey = GlobalKey();

  int _selectedIndex = 0;

  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    )..repeat();

    _scrollController.addListener(() {
      double aboutMeOffset = aboutMeKey.currentContext?.findRenderObject()?.getTransformTo(null).getTranslation().y ?? 0;
      double projectsOffset = projectsKey.currentContext?.findRenderObject()?.getTransformTo(null).getTranslation().y ?? 0;
      double contactOffset = contactKey.currentContext?.findRenderObject()?.getTransformTo(null).getTranslation().y ?? 0;

      if (_scrollController.offset >= contactOffset - 100) {
        setState(() => _selectedIndex = 2);
      } else if (_scrollController.offset >= projectsOffset - 100) {
        setState(() => _selectedIndex = 1);
      } else if (_scrollController.offset >= aboutMeOffset - 100) {
        setState(() => _selectedIndex = 0);
      }
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _onItemTapped(int index) {
    setState(() => _selectedIndex = index);

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
      body: Stack(
        children: [
          AnimatedBuilder(
            animation: _animationController,
            builder: (context, child) {
              return CustomPaint(
                painter: BackgroundPainter(_animationController.value),
                size: MediaQuery.of(context).size,
              );
            },
          ),
          SingleChildScrollView(
            controller: _scrollController,
            child: Column(
              children: [
                SectionContainer(key: aboutMeKey, child: const AboutMePage()),
                SectionContainer(key: projectsKey, child: const ProjectsPage()),
                SectionContainer(key: contactKey, child: const ContactInfoPage()),
              ],
            ),
          ),
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

// Painter for animated wave background
class BackgroundPainter extends CustomPainter {
  final double animationValue;
  BackgroundPainter(this.animationValue);

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint();

    // Background gradient
    Rect rect = Rect.fromLTWH(0, 0, size.width, size.height);
    paint.shader = LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [Colors.deepPurple.shade900, Colors.indigo.shade900],
    ).createShader(rect);
    canvas.drawRect(rect, paint);

    // Wave parameters
    final wavePaint = Paint()
      ..color = Colors.white.withOpacity(0.1)
      ..style = PaintingStyle.fill;

    final path = Path();
    final waveHeight = 40.0;
    final waveSpeed = animationValue * 2 * pi;

    path.moveTo(0, size.height * 0.2);
    for (double i = 0; i <= size.width; i++) {
      double y = sin((i / size.width * 2 * pi) + waveSpeed) * waveHeight + size.height * 0.2;
      path.lineTo(i, y);
    }
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();

    canvas.drawPath(path, wavePaint);
  }

  @override
  bool shouldRepaint(covariant BackgroundPainter oldDelegate) {
    return oldDelegate.animationValue != animationValue;
  }
}
