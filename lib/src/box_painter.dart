// Custom Painter for Scan Box
import 'package:flutter/material.dart';

class QrScanBoxPainter extends CustomPainter {
  final Color boxLineColor;
  final double animationValue;

  QrScanBoxPainter({required this.boxLineColor, required this.animationValue});

  @override
  void paint(Canvas canvas, Size size) {
    // Draw box border
    final paint =
        Paint()
          ..color = boxLineColor
          ..strokeWidth = 1.0
          ..style = PaintingStyle.stroke;

    final path = Path()..addRect(Rect.fromLTWH(0, 0, size.width, size.height));

    canvas.drawPath(path, paint);

    // Draw animated scan line
    final scanLinePaint =
        Paint()
          ..color = boxLineColor.withValues(alpha: 0.8)
          ..strokeWidth = 4.0
          ..shader = LinearGradient(
            colors: [Colors.transparent, boxLineColor, Colors.transparent],
            stops: const [0.0, 0.5, 1.0],
          ).createShader(Rect.fromLTWH(0, 0, size.width, 5));

    // Calculate scan line position (0 to 1 maps to top to bottom)
    final scanLineY = size.height * animationValue;
    canvas.drawLine(
      Offset(0, scanLineY),
      Offset(size.width, scanLineY),
      scanLinePaint,
    );

    // Draw glowing corner markers
    final cornerPaint =
        Paint()
          ..color = boxLineColor
          ..strokeWidth = 5.0
          ..style = PaintingStyle.stroke
          ..shader = RadialGradient(
            colors: [boxLineColor, boxLineColor.withValues(alpha: 0.6)],
            radius: 0.5,
          ).createShader(Rect.fromLTWH(0, 0, 20, 20));
    const cornerLength = 25.0;

    // Top-left
    canvas.drawLine(Offset(0, 0), Offset(cornerLength, 0), cornerPaint);
    canvas.drawLine(Offset(0, 0), Offset(0, cornerLength), cornerPaint);
    // Top-right
    canvas.drawLine(
      Offset(size.width - cornerLength, 0),
      Offset(size.width, 0),
      cornerPaint,
    );
    canvas.drawLine(
      Offset(size.width, 0),
      Offset(size.width, cornerLength),
      cornerPaint,
    );
    // Bottom-left
    canvas.drawLine(
      Offset(0, size.height - cornerLength),
      Offset(0, size.height),
      cornerPaint,
    );
    canvas.drawLine(
      Offset(0, size.height),
      Offset(cornerLength, size.height),
      cornerPaint,
    );
    // Bottom-right
    canvas.drawLine(
      Offset(size.width - cornerLength, size.height),
      Offset(size.width, size.height),
      cornerPaint,
    );
    canvas.drawLine(
      Offset(size.width, size.height - cornerLength),
      Offset(size.width, size.height),
      cornerPaint,
    );
  }

  @override
  bool shouldRepaint(covariant QrScanBoxPainter oldDelegate) {
    return oldDelegate.animationValue != animationValue ||
        oldDelegate.boxLineColor != boxLineColor;
  }
}
