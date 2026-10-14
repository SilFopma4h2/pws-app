import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/providers.dart';

/// Returns [Duration.zero] when the OS or the in-app setting asks for
/// reduced motion. Call from build methods.
Duration motion(
  BuildContext context,
  WidgetRef ref, [
  Duration d = const Duration(milliseconds: 450),
]) {
  final reduce =
      MediaQuery.of(context).disableAnimations ||
      ref.watch(progressProvider.select((p) => p.reduceMotion));
  return reduce ? Duration.zero : d;
}
