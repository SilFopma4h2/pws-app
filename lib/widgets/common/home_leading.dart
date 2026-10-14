import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// AppBar leading for detail pages: normal back button when possible,
/// otherwise a button to the route overview. Prevents dead-end screens.
Widget? homeLeading(BuildContext context) => context.canPop()
    ? null
    : IconButton(
        tooltip: 'Naar de route',
        icon: const Icon(Icons.home_outlined),
        onPressed: () => context.go('/route'),
      );
