import 'package:flutter/material.dart';

import '../../app/theme.dart';
import '../../models/mission_model.dart';
import '../common/location_image.dart';
import 'info_cards.dart';

/// Multiple choice, true/false, image observation and information
/// combination. Multi-select when the task has more than one correct answer.
class ChoiceTask extends StatefulWidget {
  const ChoiceTask({super.key, required this.task, required this.onSubmit});
  final MissionTask task;
  final ValueChanged<Object> onSubmit;

  @override
  State<ChoiceTask> createState() => _ChoiceTaskState();
}

class _ChoiceTaskState extends State<ChoiceTask> {
  final Set<int> _selected = {};

  void _toggle(int i) => setState(() {
    if (widget.task.allowsMultiple) {
      _selected.contains(i) ? _selected.remove(i) : _selected.add(i);
    } else {
      _selected
        ..clear()
        ..add(i);
    }
  });

  @override
  Widget build(BuildContext context) {
    final t = widget.task;
    final multi = t.allowsMultiple;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (t.imageAsset != null) ...[
          LocationImage(
            asset: t.imageAsset,
            label: 'Historische afbeelding',
            height: 210,
          ),
          if (t.imageCaption != null)
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Text(
                t.imageCaption!,
                style: const TextStyle(
                  fontStyle: FontStyle.italic,
                  color: AppColors.muted,
                ),
              ),
            ),
          const SizedBox(height: 16),
        ],
        if (t.infoCards.isNotEmpty) ...[
          InfoCards(cards: t.infoCards),
          const SizedBox(height: 16),
        ],
        Text(t.prompt, style: Theme.of(context).textTheme.titleMedium),
        if (multi)
          const Padding(
            padding: EdgeInsets.only(top: 4),
            child: Text(
              'Je kunt meerdere antwoorden kiezen.',
              style: TextStyle(color: AppColors.muted),
            ),
          ),
        const SizedBox(height: 12),
        for (var i = 0; i < t.options.length; i++)
          Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: OptionTile(
              text: t.options[i],
              selected: _selected.contains(i),
              multi: multi,
              onTap: () => _toggle(i),
            ),
          ),
        const SizedBox(height: 6),
        FilledButton(
          onPressed: _selected.isEmpty
              ? null
              : () => widget.onSubmit(Set<int>.from(_selected)),
          child: const Text('Controleer antwoord'),
        ),
      ],
    );
  }
}

class OptionTile extends StatelessWidget {
  const OptionTile({
    super.key,
    required this.text,
    required this.selected,
    required this.onTap,
    this.multi = false,
  });

  final String text;
  final bool selected;
  final bool multi;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final icon = multi
        ? (selected ? Icons.check_box : Icons.check_box_outline_blank)
        : (selected
              ? Icons.radio_button_checked
              : Icons.radio_button_unchecked);
    return Semantics(
      selected: selected,
      button: true,
      child: Material(
        color: selected
            ? AppColors.olive.withValues(alpha: 0.14)
            : AppColors.paperLight,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(
            color: selected ? AppColors.green : AppColors.line,
            width: selected ? 2 : 1,
          ),
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: onTap,
          child: ConstrainedBox(
            constraints: const BoxConstraints(minHeight: 56),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              child: Row(
                children: [
                  Icon(
                    icon,
                    color: selected ? AppColors.green : AppColors.muted,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(text, style: const TextStyle(fontSize: 16)),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
