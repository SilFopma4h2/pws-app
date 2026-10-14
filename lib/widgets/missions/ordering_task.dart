import 'package:flutter/material.dart';

import '../../app/theme.dart';
import '../../models/mission_model.dart';
import 'info_cards.dart';

class OrderingTask extends StatefulWidget {
  const OrderingTask({super.key, required this.task, required this.onSubmit});
  final MissionTask task;
  final ValueChanged<Object> onSubmit;

  @override
  State<OrderingTask> createState() => _OrderingTaskState();
}

class _OrderingTaskState extends State<OrderingTask> {
  late final List<int> _order;

  @override
  void initState() {
    super.initState();
    final n = widget.task.items.length;
    // Deterministic shuffle that is never already correct.
    _order = [for (var i = 0; i < n; i++) (i * 3 + 1) % n];
    if (_order.toSet().length != n) {
      _order
        ..clear()
        ..addAll(List.generate(n, (i) => n - 1 - i));
    }
  }

  void _move(int from, int to) =>
      setState(() => _order.insert(to, _order.removeAt(from)));

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
        ReorderableListView(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          buildDefaultDragHandles: false,
          onReorderItem: _move,
          children: [
            for (var pos = 0; pos < _order.length; pos++)
              Padding(
                key: ValueKey('order-${_order[pos]}'),
                padding: const EdgeInsets.only(bottom: 8),
                child: Material(
                  color: AppColors.paperLight,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: const BorderSide(color: AppColors.line),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(12, 8, 4, 8),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 14,
                          backgroundColor: AppColors.green,
                          child: Text(
                            '${pos + 1}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 13,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(child: Text(t.items[_order[pos]])),
                        // Arrow buttons as an accessible alternative to dragging.
                        IconButton(
                          tooltip: 'Omhoog',
                          onPressed: pos == 0
                              ? null
                              : () => _move(pos, pos - 1),
                          icon: const Icon(Icons.arrow_upward),
                        ),
                        ReorderableDragStartListener(
                          index: pos,
                          child: const Padding(
                            padding: EdgeInsets.all(8),
                            child: Icon(
                              Icons.drag_handle,
                              semanticLabel: 'Slepen',
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(height: 6),
        FilledButton(
          onPressed: () => widget.onSubmit(List<int>.from(_order)),
          child: const Text('Controleer volgorde'),
        ),
      ],
    );
  }
}
