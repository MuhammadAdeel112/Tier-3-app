import 'package:flutter/material.dart';

class FBRQRCodePainter extends CustomPainter {
  final Color color;
  
  const FBRQRCodePainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;
      
    final double unit = size.width / 7;

    // 1. Top-Left corner block
    canvas.drawRect(Rect.fromLTWH(0, 0, unit * 3, unit * 3), paint);
    canvas.drawRect(Rect.fromLTWH(unit * 0.45, unit * 0.45, unit * 2.1, unit * 2.1), Paint()..color = Colors.white);
    canvas.drawRect(Rect.fromLTWH(unit * 0.9, unit * 0.9, unit * 1.2, unit * 1.2), paint);

    // 2. Top-Right corner block
    canvas.drawRect(Rect.fromLTWH(unit * 4, 0, unit * 3, unit * 3), paint);
    canvas.drawRect(Rect.fromLTWH(unit * 4.45, unit * 0.45, unit * 2.1, unit * 2.1), Paint()..color = Colors.white);
    canvas.drawRect(Rect.fromLTWH(unit * 4.9, unit * 0.9, unit * 1.2, unit * 1.2), paint);

    // 3. Bottom-Left corner block
    canvas.drawRect(Rect.fromLTWH(0, unit * 4, unit * 3, unit * 3), paint);
    canvas.drawRect(Rect.fromLTWH(unit * 0.45, unit * 4.45, unit * 2.1, unit * 2.1), Paint()..color = Colors.white);
    canvas.drawRect(Rect.fromLTWH(unit * 0.9, unit * 4.9, unit * 1.2, unit * 1.2), paint);

    // 4. Scattered bits (Simulated QR patterns)
    canvas.drawRect(Rect.fromLTWH(unit * 3.1, unit * 3.1, unit * 0.8, unit * 0.8), paint);
    canvas.drawRect(Rect.fromLTWH(unit * 4.2, unit * 3.1, unit * 0.8, unit * 0.8), paint);
    
    canvas.drawRect(Rect.fromLTWH(unit * 3.1, unit * 4.2, unit * 0.8, unit * 0.8), paint);
    canvas.drawRect(Rect.fromLTWH(unit * 5.3, unit * 4.2, unit * 0.8, unit * 0.8), paint);
    
    canvas.drawRect(Rect.fromLTWH(unit * 4.2, unit * 5.3, unit * 0.8, unit * 0.8), paint);
    canvas.drawRect(Rect.fromLTWH(unit * 6.0, unit * 5.3, unit * 0.8, unit * 0.8), paint);
    
    canvas.drawRect(Rect.fromLTWH(unit * 5.3, unit * 6.0, unit * 0.8, unit * 0.8), paint);
    canvas.drawRect(Rect.fromLTWH(unit * 3.1, unit * 6.0, unit * 0.8, unit * 0.8), paint);
    
    canvas.drawRect(Rect.fromLTWH(unit * 5.1, unit * 5.1, unit * 0.5, unit * 0.5), paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
