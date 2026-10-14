import 'package:flutter/material.dart';

import '../../app/theme.dart';
import '../../models/mission_model.dart';
import '../map/historic_map_painter.dart';
import 'choice_task.dart';
import 'info_cards.dart';

/// Map question on a schematic (offline) map. Points can be tapped on the
/// map or chosen in the list below it.
class MapTask extends StatefulWidget {
  const MapTask({super.key, required this.task, required this.onSubmit});
  final MissionTask task;
  final ValueChanged<Object> onSubmit;

  @override
  State<MapTask> createState() => _MapTaskState();
}

class _MapTaskState extends State<MapTask> {
  int? _selected;

  @override
  Widget build(BuildContext context) {
    final t = widget.task;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (t.infoCards.isNotEmpty) ...[
          InfoCards(cards: t.infoCards),
          const SizedBox(height: 16),
        ],
        Text(t.prompt, style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 12),
        AspectRatio(
          aspectRatio: 4 / 3,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(14),
            child: LayoutBuilder(
              builder: (context, c) {
                final w = c.maxWidth, h = c.maxHeight;
                return Stack(
                  children: [
                    const Positioned.fill(
                      child: ColoredBox(color: AppColors.paperLight),
                    ),
                    const Positioned.fill(
                      child: CustomPaint(painter: HistoricMapPainter()),
                    ),
                    for (final l in t.mapLabels)
                      Positioned(
                        left: l.x * w - 60,
                        top: l.y * h - 10,
                        width: 120,
                        child: Text(
                          l.text,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontFamily: AppFonts.stamp,
                            fontSize: l.text == l.text.toUpperCase() ? 15 : 13,
                            color: l.text == 'Rijn'
                                ? const Color(0xFF3D5A66)
                                : AppColors.anthracite,
                          ),
                        ),
                      ),
                    for (var i = 0; i < t.mapPoints.length; i++)
                      Positioned(
                        left: t.mapPoints[i].x * w - 24,
                        top: t.mapPoints[i].y * h - 24,
                        child: _MapPin(
                          label: t.mapPoints[i].label,
                          selected: _selected == i,
                          onTap: () => setState(() => _selected = i),
                        ),
                      ),
                    const Positioned(
                      right: 8,
                      top: 8,
                      child: Icon(
                        Icons.navigation,
                        size: 20,
                        semanticLabel: 'Noorden',
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
        const SizedBox(height: 12),
        for (var i = 0; i < t.options.length; i++)
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: OptionTile(
              text: t.options[i],
              selected: _selected == i,
              onTap: () => setState(() => _selected = i),
            ),
          ),
        const SizedBox(height: 6),
        FilledButton(
          onPressed: _selected == null
              ? null
              : () => widget.onSubmit({_selected!}),
          child: const Text('Controleer antwoord'),
        ),
      ],
    );
  }
}

class _MapPin extends StatelessWidget {
  const _MapPin({
    required this.label,
    required this.selected,
    required this.onTap,
  });
  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      selected: selected,
      label: 'Punt $label',
      child: GestureDetector(
        onTap: onTap,
        child: SizedBox(
          width: 48,
          height: 48,
          child: Center(
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: selected ? 40 : 34,
              height: selected ? 40 : 34,
              decoration: BoxDecoration(
                color: selected ? AppColors.red : AppColors.green,
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 2.5),
                boxShadow: const [
                  BoxShadow(blurRadius: 4, color: Colors.black26),
                ],
              ),
              alignment: Alignment.center,
              child: Text(
                label,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
