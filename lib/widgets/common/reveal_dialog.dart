import 'package:flutter/material.dart';

import '../../app/theme.dart';
import 'archive.dart';

/// Calm fade/scale reveal, used for "Locatie ontdekt" and
/// "Nieuwe aanwijzing ontdekt". [duration] is zero for reduced motion.
Future<void> showReveal(
  BuildContext context, {
  required String label,
  required String title,
  required Widget body,
  required Duration duration,
  String buttonText = 'Verder',
  IconData icon = Icons.travel_explore,
}) {
  return showGeneralDialog<void>(
    context: context,
    barrierDismissible: false,
    barrierColor: Colors.black54,
    transitionDuration: duration,
    pageBuilder: (context, _, _) => Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 440),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Material(
            color: AppColors.paper,
            borderRadius: BorderRadius.circular(18),
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(icon, size: 44, color: AppColors.green),
                  const SizedBox(height: 12),
                  Stamp(label, color: AppColors.olive),
                  const SizedBox(height: 16),
                  Text(
                    title,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 16),
                  body,
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton(
                      autofocus: true,
                      onPressed: () => Navigator.of(context).pop(),
                      child: Text(buttonText),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    ),
    transitionBuilder: (context, anim, _, child) {
      final curved = CurvedAnimation(parent: anim, curve: Curves.easeOutCubic);
      return FadeTransition(
        opacity: curved,
        child: ScaleTransition(
          scale: Tween(begin: 0.94, end: 1.0).animate(curved),
          child: child,
        ),
      );
    },
  );
}
