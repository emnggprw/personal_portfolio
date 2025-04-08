import 'package:flutter/material.dart';
import 'package:personal_portfrolio/widgets/animated_header.dart';

class ContactInfoPage extends StatelessWidget {
  const ContactInfoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            AnimatedHeader('Contact Me'),
            SizedBox(height: 10),
            Text(
              'Get in touch with me at: eko.mnggprw@gmail.com',
              style: TextStyle(fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }
}
