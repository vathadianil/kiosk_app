import 'package:flutter/material.dart';
import 'dart:math';

class TimeElaspseContainerScreen extends StatefulWidget {
  const TimeElaspseContainerScreen({super.key});

  @override
  State<TimeElaspseContainerScreen> createState() =>
      _TimeElaspseContainerScreenState();
}

class _TimeElaspseContainerScreenState extends State<TimeElaspseContainerScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _sweepAnimation;

  @override
  void initState() {
    super.initState();

    // Initialize AnimationController for 3 minutes (180 seconds)
    _controller = AnimationController(
      duration: const Duration(seconds: 180), // 3 minutes
      vsync: this,
    );

    // Animate sweep angle from full circle (360 degrees) to 0
    _sweepAnimation = Tween<double>(
      begin: 360.0, // Full circle at the start
      end: 0.0, // No border at the end
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.linear,
    ));

    // Start the animation
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose(); // Clean up the controller
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _sweepAnimation,
      builder: (context, child) {
        return CustomPaint(
          size: const Size(100, 100),
          painter: CircleBorderPainter(sweepAngle: _sweepAnimation.value),
        );
      },
    );
  }
}

class CircleBorderPainter extends CustomPainter {
  final double sweepAngle;

  CircleBorderPainter({required this.sweepAngle});

  @override
  void paint(Canvas canvas, Size size) {
    final double strokeWidth = 8.0;
    final double radius = size.width / 2;

    // Define paint for the border
    final Paint paint = Paint()
      ..color = Colors.white // Border color
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    // Draw the circular border dynamically based on sweepAngle
    canvas.drawArc(
      Rect.fromCircle(
          center: Offset(radius, radius), radius: radius - strokeWidth / 2),
      -pi / 2, // Start from top
      sweepAngle * (pi / 180), // Sweep angle in radians
      false,
      paint,
    );
  }

  @override
  bool shouldRepaint(CircleBorderPainter oldDelegate) {
    return oldDelegate.sweepAngle != sweepAngle;
  }
}
