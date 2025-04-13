import 'package:flutter/material.dart';
import 'package:personal_portfrolio/widgets/animated_header.dart';

class ContactInfoPage extends StatelessWidget {
  const ContactInfoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: const [
            AnimatedHeader('Contact Me'),
            SizedBox(height: 10),
            Text(
              'Get in touch with me at: eko.mnggprw@gmail.com',
              style: TextStyle(fontSize: 18),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
