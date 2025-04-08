import 'package:flutter/material.dart';
import 'package:personal_portfrolio/widgets/animated_header.dart';

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
            const SizedBox(height: 30),
            const AnimatedHeader('Welcome to My Portfolio!'),
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
