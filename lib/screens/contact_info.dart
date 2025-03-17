import 'package:flutter/material.dart';

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