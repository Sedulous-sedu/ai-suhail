import 'package:flutter/material.dart';

// Custom painter for drawing a grid pattern
class GridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.15)
      ..strokeWidth = 0.5;

    // Draw horizontal lines
    double horizontalSpacing = 40;
    for (double y = 0; y < size.height; y += horizontalSpacing) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }

    // Draw vertical lines
    double verticalSpacing = 40;
    for (double x = 0; x < size.width; x += verticalSpacing) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }
  }

  @override
  bool shouldRepaint(GridPainter oldDelegate) => false;
}
