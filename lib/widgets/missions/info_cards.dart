import 'package:flutter/material.dart';

import '../../app/theme.dart';
import '../common/archive.dart';

/// Dossier snippets the student needs to combine.
class InfoCards extends StatelessWidget {
  const InfoCards({super.key, required this.cards});
  final List<String> cards;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.paperDark.withValues(alpha: 0.6),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.line),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const ArchiveLabel('Dossier'),
          const SizedBox(height: 10),
          for (final c in cards)
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(top: 3),
                    child: Icon(
                      Icons.description_outlined,
                      size: 18,
                      color: AppColors.olive,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(child: Text(c)),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
