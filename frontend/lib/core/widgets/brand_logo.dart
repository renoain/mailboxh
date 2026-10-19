// Logo tiga lingkaran tumpang tindih.

import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_sizes.dart';

/// Menggambar logo oranye, hijau, dan biru dengan irisan gelap.
class BrandLogo extends StatelessWidget {
  const BrandLogo({this.diameter = AppSizes.logoDiameter, super.key});

  final double diameter;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: diameter * 2.44,
      height: diameter,
      child: CustomPaint(painter: _LogoPainter()),
    );
  }
}

class _LogoPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final double radius = size.height / 2;
    final double step = size.height * 0.72;
    Path circle(int index) => Path()
      ..addOval(
        Rect.fromCircle(
          center: Offset(radius + step * index, radius),
          radius: radius,
        ),
      );
    final Path orange = circle(0);
    final Path green = circle(1);
    final Path blue = circle(2);
    canvas.drawPath(orange, Paint()..color = AppColors.brandOrange);
    canvas.drawPath(green, Paint()..color = AppColors.brandGreen);
    canvas.drawPath(blue, Paint()..color = AppColors.brandBlue);
    final Paint overlap = Paint()..color = AppColors.bgDark;
    canvas.drawPath(
      Path.combine(PathOperation.intersect, orange, green),
      overlap,
    );
    canvas.drawPath(
      Path.combine(PathOperation.intersect, green, blue),
      overlap,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
