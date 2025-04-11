import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:animated_text_kit/animated_text_kit.dart';

class AboutMePage extends StatelessWidget {
  const AboutMePage({super.key});

  final String _resumeUrl = 'https://drive.google.com/file/d/1puPfD8fUyYUawTkj1PapR2zF_9dwrH5a/view?usp=sharing';

  void _launchResume() async {
    final Uri url = Uri.parse(_resumeUrl);
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } else {
      throw 'Could not launch $_resumeUrl';
    }
  }

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
            AnimatedTextKit(
              animatedTexts: [
                TypewriterAnimatedText(
                  'Welcome to My Portfolio!',
                  textStyle: Theme.of(context).textTheme.headlineLarge,
                  speed: const Duration(milliseconds: 100),
                ),
              ],
              totalRepeatCount: 1,
              pause: const Duration(milliseconds: 1000),
              displayFullTextOnTap: true,
              stopPauseOnTap: true,
            ),
            const SizedBox(height: 10),
            const Text(
              "Hi! I'm a graduate in MSc Data Science with a heavy technical background of BSc Computer Science. I'm a proud and passionate programmer, data visualization enthusiast, and an Android developer.",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 20),
            Tooltip(
              message: 'Download Resume',
              waitDuration: const Duration(milliseconds: 300),
              child: ElevatedButton.icon(
                onPressed: _launchResume,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurpleAccent,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                ),
                icon: const Icon(Icons.download),
                label: const Text('Download Resume'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
