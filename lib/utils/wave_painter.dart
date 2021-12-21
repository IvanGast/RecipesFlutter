import 'package:flutter/material.dart';

class WavePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = new Paint()
      ..style = PaintingStyle.fill
      ..isAntiAlias = true
      ..color = Colors.amber;

    Offset topLeft = Offset(0, 0);
    Offset bottomLeft = Offset(0, size.height * 0.5);
    Offset topRight = Offset(size.width, 0);
    Offset bottomRight = Offset(size.width, size.height * 0.5);

    Path path = Path()
    ..moveTo(topLeft.dx, topLeft.dy)
    ..lineTo(bottomLeft.dx, bottomLeft.dy)
    ..quadraticBezierTo(size.width / 2, bottomLeft.dy + 80, bottomRight.dx, bottomRight.dy)
    ..lineTo(topRight.dx, topRight.dy)
    ..close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}