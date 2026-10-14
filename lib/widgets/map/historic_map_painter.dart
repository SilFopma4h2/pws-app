import 'package:flutter/material.dart';

import '../../app/theme.dart';

/// River centre line in 0..1 coordinates (west → east). Shared with the
/// schematic map so tappable points line up with the drawn river.
const List<Offset> riverPath = [
  Offset(0, 0.62),
  Offset(0.25, 0.66),
  Offset(0.5, 0.60),
  Offset(0.75, 0.58),
  Offset(1, 0.55),
];

/// Draws an old-map style background: grid, contour lines and the Rhine.
class HistoricMapPainter extends CustomPainter {
  const HistoricMapPainter({
    this.faint = false,
    this.lineColor = AppColors.anthracite,
  });

  final bool faint;
  final Color lineColor;

  @override
  void paint(Canvas canvas, Size size) {
    final a = faint ? 0.35 : 1.0;
    final grid = Paint()
      ..color = lineColor.withValues(alpha: 0.08 * a)
      ..strokeWidth = 1;
    const step = 32.0;
    for (var x = 0.0; x < size.width; x += step) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), grid);
    }
    for (var y = 0.0; y < size.height; y += step) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), grid);
    }

    // Contour lines (Veluwe hills north of the river).
    final contour = Paint()
      ..color = AppColors.olive.withValues(alpha: 0.22 * a)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2;
    for (var i = 0; i < 4; i++) {
      final r = Rect.fromCenter(
        center: Offset(size.width * 0.3, size.height * 0.12),
        width: size.width * (0.35 + i * 0.16),
        height: size.height * (0.18 + i * 0.1),
      );
      canvas.drawOval(r, contour);
    }

    // River band.
    final path = Path();
    final pts = riverPath
        .map((o) => Offset(o.dx * size.width, o.dy * size.height))
        .toList();
    path.moveTo(pts.first.dx, pts.first.dy);
    for (var i = 1; i < pts.length; i++) {
      final prev = pts[i - 1];
      final cur = pts[i];
      final mid = Offset((prev.dx + cur.dx) / 2, (prev.dy + cur.dy) / 2);
      path.quadraticBezierTo(prev.dx, prev.dy, mid.dx, mid.dy);
    }
    path.lineTo(pts.last.dx, pts.last.dy);
    canvas.drawPath(
      path,
      Paint()
        ..color = AppColors.river.withValues(alpha: 0.55 * a)
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round
        ..strokeWidth = (size.height * 0.045).clamp(6, 22),
    );
    canvas.drawPath(
      path,
      Paint()
        ..color = AppColors.river.withValues(alpha: 0.9 * a)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.2,
    );
  }

  @override
  bool shouldRepaint(covariant HistoricMapPainter old) =>
      old.faint != faint || old.lineColor != lineColor;
}
