import 'package:flutter/material.dart';

import '../../app/theme.dart';
import '../../models/progress_model.dart';

/// Label, colour and icon per status. Icons differ too, so status is never
/// shown by colour alone.
extension LocationStatusStyle on LocationStatus {
  String get label => switch (this) {
    LocationStatus.locked => 'Vergrendeld',
    LocationStatus.available => 'Beschikbaar',
    LocationStatus.discovered => 'Huidige missie',
    LocationStatus.completed => 'Voltooid',
  };

  Color get color => switch (this) {
    LocationStatus.locked => const Color(0xFF8A8579),
    LocationStatus.available => AppColors.olive,
    LocationStatus.discovered => AppColors.red,
    LocationStatus.completed => AppColors.green,
  };

  IconData get icon => switch (this) {
    LocationStatus.locked => Icons.lock_outline,
    LocationStatus.available => Icons.place_outlined,
    LocationStatus.discovered => Icons.explore,
    LocationStatus.completed => Icons.check,
  };
}
