import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../app/theme.dart';

/// Small typewriter label, like a file tab in an archive.
class ArchiveLabel extends StatelessWidget {
  const ArchiveLabel(this.text, {super.key, this.color = AppColors.olive});
  final String text;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        border: Border.all(color: color, width: 1.2),
        borderRadius: BorderRadius.circular(3),
      ),
      child: Text(
        text.toUpperCase(),
        style: TextStyle(
          fontFamily: AppFonts.stamp,
          fontSize: 12.5,
          letterSpacing: 1.2,
          color: color,
        ),
      ),
    );
  }
}

/// Slightly rotated rubber stamp (e.g. "VOLTOOID").
class Stamp extends StatelessWidget {
  const Stamp(this.text, {super.key, this.color = AppColors.red});
  final String text;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Transform.rotate(
      angle: -6 * math.pi / 180,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        decoration: BoxDecoration(
          border: Border.all(color: color, width: 2),
          borderRadius: BorderRadius.circular(4),
        ),
        child: Text(
          text.toUpperCase(),
          style: TextStyle(
            fontFamily: AppFonts.stamp,
            fontSize: 15,
            letterSpacing: 2,
            color: color,
          ),
        ),
      ),
    );
  }
}

/// Paper "dossier" card with a coloured left edge.
class DossierCard extends StatelessWidget {
  const DossierCard({
    super.key,
    required this.child,
    this.accent = AppColors.olive,
    this.padding = const EdgeInsets.all(16),
    this.onTap,
  });

  final Widget child;
  final Color accent;
  final EdgeInsets padding;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.paperLight,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
        side: const BorderSide(color: AppColors.line),
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            border: Border(left: BorderSide(color: accent, width: 5)),
          ),
          padding: padding,
          child: child,
        ),
      ),
    );
  }
}

class SectionTitle extends StatelessWidget {
  const SectionTitle(this.text, {super.key});
  final String text;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(top: 24, bottom: 10),
    child: Semantics(
      header: true,
      child: Text(text, style: Theme.of(context).textTheme.titleLarge),
    ),
  );
}

/// Shown at the top of screens where the user may be outside.
class SafetyNote extends StatelessWidget {
  const SafetyNote({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.olive.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(10),
      ),
      child: const Row(
        children: [
          Icon(Icons.pan_tool_outlined, size: 22, color: AppColors.olive),
          SizedBox(width: 10),
          Expanded(
            child: Text(
              'Gebruik je telefoon alleen wanneer je veilig stilstaat.',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }
}
