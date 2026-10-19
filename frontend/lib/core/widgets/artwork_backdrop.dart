// Gambar artwork latar dengan pudar ke warna latar di sisi bawah.

import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

/// Menampilkan artwork penuh lebar yang memudar ke bawah.
class ArtworkBackdrop extends StatelessWidget {
  const ArtworkBackdrop({required this.asset, required this.height, super.key});

  final String asset;
  final double height;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: double.infinity,
      child: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            asset,
            fit: BoxFit.cover,
            alignment: Alignment.topCenter,
            errorBuilder: (BuildContext context, Object error,
                    StackTrace? stackTrace) =>
                const ColoredBox(color: AppColors.panelDark),
          ),
          DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  AppColors.bgDark.withValues(alpha: 0),
                  AppColors.bgDark,
                ],
                stops: const [0.6, 1],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
