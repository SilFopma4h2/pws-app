import 'package:flutter/material.dart';

import '../../app/theme.dart';
import '../../models/mission_model.dart';
import 'info_cards.dart';

/// Each left item gets a dropdown with the (alphabetically sorted) right items.
class MatchingTask extends StatefulWidget {
  const MatchingTask({super.key, required this.task, required this.onSubmit});
  final MissionTask task;
  final ValueChanged<Object> onSubmit;

  @override
  State<MatchingTask> createState() => _MatchingTaskState();
}

class _MatchingTaskState extends State<MatchingTask> {
  final Map<int, int> _choice = {};
  late final List<int> _rightOrder;

  @override
  void initState() {
    super.initState();
    final pairs = widget.task.pairs;
    _rightOrder = List.generate(pairs.length, (i) => i)
      ..sort((a, b) => pairs[a].right.compareTo(pairs[b].right));
  }

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
        for (var i = 0; i < t.pairs.length; i++)
          Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.paperLight,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.line),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    t.pairs[i].left,
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 8),
                  DropdownButtonFormField<int>(
                    initialValue: _choice[i],
                    isExpanded: true,
                    decoration: const InputDecoration(
                      labelText: 'Kies…',
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 10,
                      ),
                    ),
                    items: [
                      for (final r in _rightOrder)
                        DropdownMenuItem(
                          value: r,
                          child: Text(
                            t.pairs[r].right,
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                    ],
                    onChanged: (v) => setState(() {
                      if (v != null) _choice[i] = v;
                    }),
                  ),
                ],
              ),
            ),
          ),
        FilledButton(
          onPressed: _choice.length < t.pairs.length
              ? null
              : () => widget.onSubmit(Map<int, int>.from(_choice)),
          child: const Text('Controleer koppelingen'),
        ),
      ],
    );
  }
}
