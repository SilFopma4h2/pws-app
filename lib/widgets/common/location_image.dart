import 'package:flutter/material.dart';

import '../../app/theme.dart';
import '../map/historic_map_painter.dart';

/// Shows an asset image, or a tidy archive-style placeholder when the file
/// is missing. Never a broken-image icon.
class LocationImage extends StatelessWidget {
  const LocationImage({
    super.key,
    required this.asset,
    this.label,
    this.height = 200,
    this.borderRadius = 14,
  });

  final String? asset;
  final String? label;
  final double height;
  final double borderRadius;

  @override
  Widget build(BuildContext context) {
    final placeholder = _Placeholder(label: label);
    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: SizedBox(
        height: height,
        width: double.infinity,
        child: asset == null
            ? placeholder
            : Image.asset(
                asset!,
                fit: BoxFit.cover,
                semanticLabel: label,
                errorBuilder: (_, _, _) => placeholder,
              ),
      ),
    );
  }
}

class _Placeholder extends StatelessWidget {
  const _Placeholder({this.label});
  final String? label;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: label == null ? 'Afbeelding volgt' : 'Afbeelding volgt: $label',
      child: Stack(
        fit: StackFit.expand,
        children: [
          const ColoredBox(color: AppColors.paperDark),
          const CustomPaint(painter: HistoricMapPainter(faint: true)),
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.photo_camera_back_outlined,
                  size: 36,
                  color: AppColors.muted,
                ),
                const SizedBox(height: 6),
                Text(
                  label ?? 'Afbeelding volgt',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontFamily: AppFonts.stamp,
                    color: AppColors.muted,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
