import 'package:flutter/material.dart';
import 'package:visibility_detector/visibility_detector.dart';

class SectionContainer extends StatefulWidget {
  final Widget child;

  const SectionContainer({super.key, required this.child});

  @override
  State<SectionContainer> createState() => _SectionContainerState();
}

class _SectionContainerState extends State<SectionContainer> with SingleTickerProviderStateMixin {
  bool _visible = false;

  @override
  Widget build(BuildContext context) {
    return VisibilityDetector(
      key: Key(widget.child.toString()), // Using a stable key instead of UniqueKey
      onVisibilityChanged: (info) {
        if (info.visibleFraction > 0.1 && !_visible) {
          _updateVisibility(true);
        } else if (info.visibleFraction <= 0.1 && _visible) {
          _updateVisibility(false);
        }
      },
      child: AnimatedOpacity(
        opacity: _visible ? 1.0 : 0.0,
        duration: const Duration(milliseconds: 800),
        curve: Curves.easeInOut,
        child: AnimatedSlide(
          offset: _visible ? Offset.zero : const Offset(0, 0.1),
          duration: const Duration(milliseconds: 800),
          curve: Curves.easeInOut,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 40.0, horizontal: 16.0),
            child: widget.child,
          ),
        ),
      ),
    );
  }

  void _updateVisibility(bool visible) {
    if (_visible != visible) {
      setState(() {
        _visible = visible;
      });
    }
  }
}
