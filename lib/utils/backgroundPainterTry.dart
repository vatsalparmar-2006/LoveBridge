import 'package:flutter/material.dart';
import 'dart:ui';

class BackgroundPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final height = size.height;
    final width = size.width;

    // Main gradient background with a soft romantic feel
    final Paint mainPaint = Paint()
      ..shader = LinearGradient(
        colors: [
          Colors.pink.shade100,
          Colors.pink.shade300,
          Colors.purple.shade200,
        ],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ).createShader(Rect.fromLTWH(0, 0, width, height));

    // Draw base rectangle
    canvas.drawRect(Rect.fromLTWH(0, 0, width, height * 0.6), mainPaint);

    // Create wave paths with smoother transitions
    final Paint wave1Paint = Paint()
      ..color = Colors.white.withOpacity(0.2)
      ..style = PaintingStyle.fill;

    final Paint wave2Paint = Paint()
      ..color = Colors.pink.shade50.withOpacity(0.4)
      ..style = PaintingStyle.fill;

    // First smooth wave path
    Path wave1 = Path()
      ..moveTo(0, height * 0.5)
      ..quadraticBezierTo(
          width * 0.25, height * 0.4,
          width * 0.5, height * 0.5)
      ..quadraticBezierTo(
          width * 0.75, height * 0.6,
          width, height * 0.55)
      ..lineTo(width, height)
      ..lineTo(0, height)
      ..close();

    // Second smoother wave path
    Path wave2 = Path()
      ..moveTo(0, height * 0.45)
      ..quadraticBezierTo(
          width * 0.3, height * 0.4,
          width * 0.6, height * 0.5)
      ..quadraticBezierTo(
          width * 0.8, height * 0.55,
          width, height * 0.5)
      ..lineTo(width, height)
      ..lineTo(0, height)
      ..close();

    // Draw the wave paths
    canvas.drawPath(wave1, wave1Paint);
    canvas.drawPath(wave2, wave2Paint);
    canvas.drawPath(wave1, wave1Paint);
    canvas.drawPath(wave2, wave2Paint);

    // Add decorative heart icons, but more spread out for a subtle touch
    final heartPaint = Paint()
      ..color = Colors.white.withOpacity(0.2)
      ..style = PaintingStyle.fill;

    for (int i = 0; i < 5; i++) {
      canvas.drawCircle(
        Offset(width * 0.2 * (i + 1), height * 0.12),
        12,
        heartPaint,
      );
      canvas.drawCircle(
        Offset(width * 0.2 * (i + 1) + 18, height * 0.16),
        12,
        heartPaint,
      );
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
