import 'package:flutter/material.dart';

import '../../models/mission_model.dart';
import 'info_cards.dart';

class TextInputTask extends StatefulWidget {
  const TextInputTask({super.key, required this.task, required this.onSubmit});
  final MissionTask task;
  final ValueChanged<Object> onSubmit;

  @override
  State<TextInputTask> createState() => _TextInputTaskState();
}

class _TextInputTaskState extends State<TextInputTask> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _submit() {
    if (_controller.text.trim().isNotEmpty) widget.onSubmit(_controller.text);
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
        TextField(
          controller: _controller,
          textInputAction: TextInputAction.done,
          onSubmitted: (_) => _submit(),
          onChanged: (_) => setState(() {}),
          style: const TextStyle(fontSize: 20, letterSpacing: 1),
          decoration: const InputDecoration(hintText: 'Typ je antwoord'),
        ),
        const SizedBox(height: 12),
        FilledButton(
          onPressed: _controller.text.trim().isEmpty ? null : _submit,
          child: const Text('Controleer antwoord'),
        ),
      ],
    );
  }
}
