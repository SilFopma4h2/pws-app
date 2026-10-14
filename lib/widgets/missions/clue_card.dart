import 'package:flutter/material.dart';

import '../../app/theme.dart';
import '../../models/clue_model.dart';
import '../common/archive.dart';

class ClueCard extends StatelessWidget {
  const ClueCard({super.key, required this.clue, this.compact = false});
  final ClueModel clue;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(compact ? 12 : 18),
      decoration: BoxDecoration(
        color: AppColors.paperLight,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.olive, width: 1.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Icon(clue.type.icon, size: 18, color: AppColors.olive),
              const SizedBox(width: 6),
              Flexible(child: ArchiveLabel(clue.type.label)),
            ],
          ),
          SizedBox(height: compact ? 8 : 12),
          Text(
            clue.value,
            style: TextStyle(
              fontFamily: AppFonts.stamp,
              fontSize: compact ? 20 : 30,
              color: AppColors.green,
              letterSpacing: 1.5,
            ),
          ),
          const SizedBox(height: 4),
          Text(clue.title, style: const TextStyle(fontWeight: FontWeight.w700)),
          if (!compact) ...[const SizedBox(height: 6), Text(clue.description)],
        ],
      ),
    );
  }
}

/// Placeholder for a clue that has not been found yet.
class LockedClueCard extends StatelessWidget {
  const LockedClueCard({super.key, required this.hint});
  final String hint;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.paperDark.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.line),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          const Row(
            children: [
              Icon(Icons.lock_outline, size: 18, color: AppColors.muted),
              SizedBox(width: 6),
              Text(
                'Nog niet ontdekt',
                style: TextStyle(color: AppColors.muted),
              ),
            ],
          ),
          const SizedBox(height: 8),
          const Text(
            '? ? ?',
            style: TextStyle(
              fontFamily: AppFonts.stamp,
              fontSize: 20,
              color: AppColors.muted,
            ),
          ),
          const SizedBox(height: 4),
          Text(hint, style: const TextStyle(color: AppColors.muted)),
        ],
      ),
    );
  }
}
