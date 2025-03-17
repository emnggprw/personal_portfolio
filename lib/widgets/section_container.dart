import 'package:flutter/material.dart';

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