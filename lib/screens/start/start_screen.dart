import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/theme.dart';
import '../../config/app_config.dart';
import '../../providers/providers.dart';
import '../../utils/motion.dart';
import '../../widgets/common/archive.dart';
import '../../widgets/map/historic_map_painter.dart';

class StartScreen extends ConsumerWidget {
  const StartScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final progress = ref.watch(progressProvider);
    final resume = progress.routeId != null;
    final text = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: AppColors.green,
      body: Stack(
        children: [
          const Positioned.fill(
            child: CustomPaint(
              painter: HistoricMapPainter(lineColor: Colors.white),
            ),
          ),
          // Subtle overlay so text stays readable.
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    AppColors.green.withValues(alpha: 0.35),
                    AppColors.green.withValues(alpha: 0.92),
                  ],
                ),
              ),
            ),
          ),
          SafeArea(
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 560),
                child: TweenAnimationBuilder<double>(
                  tween: Tween(begin: 0, end: 1),
                  duration: motion(
                    context,
                    ref,
                    const Duration(milliseconds: 800),
                  ),
                  builder: (context, v, child) => Opacity(
                    opacity: v,
                    child: Transform.translate(
                      offset: Offset(0, 16 * (1 - v)),
                      child: child,
                    ),
                  ),
                  child: ListView(
                    shrinkWrap: true,
                    padding: const EdgeInsets.all(24),
                    children: [
                      const Align(
                        alignment: Alignment.centerLeft,
                        child: ArchiveLabel(
                          'Arnhem · Oosterbeek · Driel · 1944',
                          color: AppColors.paper,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        AppConfig.appTitle,
                        style: text.displaySmall?.copyWith(
                          color: Colors.white,
                          letterSpacing: 1,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        AppConfig.appSubtitle,
                        style: text.titleLarge?.copyWith(
                          color: AppColors.paper,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 24),
                      Text(
                        'September 1944. Een gewaagd plan moet de oorlog '
                        'versnellen. Fiets naar de echte plekken, onderzoek '
                        'wat er gebeurde en reconstrueer het verhaal van '
                        'Operatie Market Garden.',
                        style: text.bodyLarge?.copyWith(color: Colors.white),
                      ),
                      const SizedBox(height: 24),
                      const Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: [
                          _Feature(Icons.place_outlined, 'Echte locaties'),
                          _Feature(Icons.search, 'Onderzoeksmissies'),
                          _Feature(Icons.folder_open_outlined, 'Aanwijzingen'),
                          _Feature(Icons.flag_outlined, 'Eindmissie'),
                        ],
                      ),
                      const SizedBox(height: 32),
                      FilledButton.icon(
                        style: FilledButton.styleFrom(
                          backgroundColor: AppColors.paper,
                          foregroundColor: AppColors.green,
                        ),
                        onPressed: () =>
                            context.go(resume ? '/route' : '/safety'),
                        icon: const Icon(Icons.arrow_forward),
                        label: Text(
                          resume ? 'Verder met de missie' : 'Start de missie',
                        ),
                      ),
                      if (resume) ...[
                        const SizedBox(height: 8),
                        TextButton(
                          style: TextButton.styleFrom(
                            foregroundColor: AppColors.paper,
                          ),
                          onPressed: () => context.go('/intro'),
                          child: const Text('Bekijk de introductie opnieuw'),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Feature extends StatelessWidget {
  const _Feature(this.icon, this.label);
  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.white38),
        borderRadius: BorderRadius.circular(30),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 18, color: AppColors.paper),
          const SizedBox(width: 6),
          Text(label, style: const TextStyle(color: Colors.white)),
        ],
      ),
    );
  }
}
