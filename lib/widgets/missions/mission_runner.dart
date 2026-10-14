import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/theme.dart';
import '../../models/mission_model.dart';
import '../../utils/motion.dart';
import '../common/archive.dart';
import '../common/page_body.dart';
import 'task_view.dart';

enum _Feedback { none, wrong, correct }

/// Runs the tasks of any mission one by one: answer → feedback/hints →
/// next task. Calls [onFinished] after the last task.
/// Unlimited attempts, no timers, no points.
class MissionRunner extends ConsumerStatefulWidget {
  const MissionRunner({
    super.key,
    required this.mission,
    required this.onFinished,
    this.header,
  });

  final Mission mission;
  final Future<void> Function() onFinished;
  final Widget? header;

  @override
  ConsumerState<MissionRunner> createState() => _MissionRunnerState();
}

class _MissionRunnerState extends ConsumerState<MissionRunner> {
  int _index = 0;
  _Feedback _feedback = _Feedback.none;
  int _hintsShown = 0;
  bool _finishing = false;

  bool get _respectful => widget.mission.tone == MissionTone.respectful;

  void _onSubmit(Object answer) {
    final ok = widget.mission.tasks[_index].isCorrect(answer);
    setState(() => _feedback = ok ? _Feedback.correct : _Feedback.wrong);
  }

  Future<void> _next() async {
    if (_index < widget.mission.tasks.length - 1) {
      setState(() {
        _index++;
        _feedback = _Feedback.none;
        _hintsShown = 0;
      });
    } else {
      setState(() => _finishing = true);
      await widget.onFinished();
      if (mounted) setState(() => _finishing = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final mission = widget.mission;
    final task = mission.tasks[_index];
    final total = mission.tasks.length;
    final isLast = _index == total - 1;

    return PageBody(
      key: ValueKey(_index),
      children: [
        if (_index == 0 && widget.header != null) ...[
          widget.header!,
          const SizedBox(height: 16),
        ],
        Row(
          children: [
            Expanded(
              child: Align(
                alignment: Alignment.centerLeft,
                child: ArchiveLabel('Opdracht ${_index + 1} van $total'),
              ),
            ),
            for (var i = 0; i < total; i++)
              AnimatedContainer(
                duration: motion(
                  context,
                  ref,
                  const Duration(milliseconds: 300),
                ),
                margin: const EdgeInsets.only(left: 4),
                width: i == _index ? 18 : 8,
                height: 8,
                decoration: BoxDecoration(
                  color: i <= _index ? AppColors.olive : AppColors.line,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
          ],
        ),
        const SizedBox(height: 16),
        AbsorbPointer(
          absorbing: _feedback == _Feedback.correct,
          child: TaskView(
            key: ValueKey(task.id),
            task: task,
            onSubmit: _onSubmit,
          ),
        ),
        const SizedBox(height: 16),
        AnimatedSwitcher(
          duration: motion(context, ref, const Duration(milliseconds: 300)),
          child: switch (_feedback) {
            _Feedback.none => const SizedBox.shrink(key: ValueKey('none')),
            _Feedback.wrong => _WrongPanel(
              key: ValueKey('wrong$_hintsShown'),
              feedback: task.wrongFeedback,
              hints: task.hints.take(_hintsShown).toList(),
              canShowHint: _hintsShown < task.hints.length,
              onHint: () => setState(() => _hintsShown++),
            ),
            _Feedback.correct => _CorrectPanel(
              key: const ValueKey('correct'),
              title: _respectful ? 'Klopt.' : 'Goed gezien!',
              explanation: task.explanation,
              buttonText: isLast ? 'Missie afronden' : 'Volgende opdracht',
              busy: _finishing,
              onNext: _next,
            ),
          },
        ),
      ],
    );
  }
}

class _WrongPanel extends StatelessWidget {
  const _WrongPanel({
    super.key,
    required this.feedback,
    required this.hints,
    required this.canShowHint,
    required this.onHint,
  });

  final String feedback;
  final List<String> hints;
  final bool canShowHint;
  final VoidCallback onHint;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      liveRegion: true,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFFF5E6C8),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFFD9BE86)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Icon(Icons.lightbulb_outline, color: Color(0xFF7A5A1C)),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Nog niet helemaal.',
                    style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Text(feedback),
            for (final h in hints)
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Hint: ',
                      style: TextStyle(fontWeight: FontWeight.w700),
                    ),
                    Expanded(child: Text(h)),
                  ],
                ),
              ),
            const SizedBox(height: 4),
            if (canShowHint)
              Align(
                alignment: Alignment.centerLeft,
                child: TextButton.icon(
                  onPressed: onHint,
                  icon: const Icon(Icons.tips_and_updates_outlined),
                  label: Text(hints.isEmpty ? 'Toon een hint' : 'Nog een hint'),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _CorrectPanel extends StatelessWidget {
  const _CorrectPanel({
    super.key,
    required this.title,
    required this.explanation,
    required this.buttonText,
    required this.busy,
    required this.onNext,
  });

  final String title;
  final String explanation;
  final String buttonText;
  final bool busy;
  final VoidCallback onNext;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      liveRegion: true,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.green.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.green.withValues(alpha: 0.4)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                const Icon(Icons.check_circle_outline, color: AppColors.green),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
            if (explanation.isNotEmpty) ...[
              const SizedBox(height: 6),
              Text(explanation),
            ],
            const SizedBox(height: 14),
            FilledButton(
              autofocus: true,
              onPressed: busy ? null : onNext,
              child: Text(buttonText),
            ),
          ],
        ),
      ),
    );
  }
}
