import 'package:flutter/material.dart';

class ScannerOverlayPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    const cw = 260.0;
    const ch = 260.0;
    final cx = size.width / 2;
    final cy = size.height / 2;

    final cutout = RRect.fromRectAndRadius(
      Rect.fromCenter(center: Offset(cx, cy), width: cw, height: ch),
      const Radius.circular(14),
    );

    final path = Path()
      ..addRect(Rect.fromLTWH(0, 0, size.width, size.height))
      ..addRRect(cutout)
      ..fillType = PathFillType.evenOdd;

    canvas.drawPath(
      path,
      Paint()..color = Colors.black.withValues(alpha: 0.62),
    );
  }

  @override
  bool shouldRepaint(_) => false;
}
