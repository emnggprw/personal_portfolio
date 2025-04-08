import 'package:flutter/material.dart';

class AnimatedHeader extends StatefulWidget {
  final String title;

  const AnimatedHeader(this.title, {super.key});

  @override
  State<AnimatedHeader> createState() => _AnimatedHeaderState();
}

class _AnimatedHeaderState extends State<AnimatedHeader> with TickerProviderStateMixin {
  late AnimationController _entranceController;
  late AnimationController _idleController;

  late Animation<Offset> _slideAnimation;
  late Animation<double> _fadeAnimation;
  late Animation<double> _shadowPulse;
  late Animation<double> _lineWidth;

  @override
  void initState() {
    super.initState();

    _entranceController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );

    _idleController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.4),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _entranceController, curve: Curves.easeOutExpo));

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _entranceController, curve: Curves.easeInOut),
    );

    _shadowPulse = Tween<double>(begin: 0.0, end: 8.0).animate(
      CurvedAnimation(parent: _idleController, curve: Curves.easeInOut),
    );

    _lineWidth = Tween<double>(begin: 0, end: 60).animate(
      CurvedAnimation(parent: _entranceController, curve: Curves.easeOutBack),
    );

    _entranceController.forward().whenComplete(() {
      _idleController.repeat(reverse: true);
    });
  }

  @override
  void dispose() {
    _entranceController.dispose();
    _idleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    final isDark = brightness == Brightness.dark;

    final baseColor = isDark ? Colors.white : const Color(0xFF333333);
    final accentColor = isDark ? Colors.grey[300]! : const Color(0xFF99C1F1); // soft light blue
    final glowColor = isDark ? Colors.blueGrey : Colors.grey.withOpacity(0.4);

    return AnimatedBuilder(
      animation: Listenable.merge([_entranceController, _idleController]),
      builder: (context, _) {
        return FadeTransition(
          opacity: _fadeAnimation,
          child: SlideTransition(
            position: _slideAnimation,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.title,
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: baseColor,
                    shadows: [
                      Shadow(
                        color: glowColor,
                        blurRadius: _shadowPulse.value,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                Container(
                  height: 4,
                  width: _lineWidth.value,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4),
                    gradient: LinearGradient(
                      colors: [
                        accentColor.withOpacity(0.6),
                        accentColor,
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 12),
              ],
            ),
          ),
        );
      },
    );
  }
}
