import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/theme.dart';
import '../../models/quiz_model.dart';
import '../../models/route_model.dart';
import '../../providers/providers.dart';
import '../../utils/motion.dart';
import '../../widgets/common/archive.dart';
import '../../widgets/common/page_body.dart';
import '../../widgets/missions/choice_task.dart';

/// Pre-knowledge quiz ('pre') and final quiz ('post'). No grades.
class QuizScreen extends ConsumerStatefulWidget {
  const QuizScreen({super.key, required this.quizId});
  final String quizId;

  @override
  ConsumerState<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends ConsumerState<QuizScreen> {
  final Map<String, int> _answers = {};
  int _index = -1; // -1 = intro screen
  bool _done = false;

  RouteModel get _route => ref.read(selectedRouteProvider)!;
  Quiz get _quiz => _isPre ? _route.preQuiz : _route.postQuiz;
  bool get _isPre => widget.quizId == 'pre';

  void _finish() {
    ref
        .read(progressProvider.notifier)
        .saveQuiz(
          QuizResult(
            quizId: _quiz.id,
            answers: Map.of(_answers),
            completedAt: DateTime.now(),
          ),
        );
    setState(() => _done = true);
  }

  void _leave() {
    if (_isPre) {
      context.go('/route');
    } else {
      context.go('/complete');
    }
  }

  @override
  Widget build(BuildContext context) {
    final quiz = _quiz;
    final Widget body;
    if (_done) {
      body = _isPre ? _preDone() : _postDone();
    } else if (_index < 0) {
      body = _intro(quiz);
    } else {
      body = _question(quiz.questions[_index]);
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(_isPre ? 'Voorkennis' : 'Eindquiz'),
        actions: [
          if (!_done)
            TextButton(onPressed: _leave, child: const Text('Overslaan')),
        ],
      ),
      body: AnimatedSwitcher(
        duration: motion(context, ref, const Duration(milliseconds: 250)),
        child: KeyedSubtree(key: ValueKey('$_index$_done'), child: body),
      ),
    );
  }

  Widget _intro(Quiz quiz) => PageBody(
    children: [
      const ArchiveLabel('Geen toets'),
      const SizedBox(height: 12),
      Text(quiz.title, style: Theme.of(context).textTheme.headlineSmall),
      const SizedBox(height: 12),
      Text(quiz.intro, style: Theme.of(context).textTheme.bodyLarge),
      const SizedBox(height: 8),
      Text(
        '${quiz.questions.length} korte vragen.',
        style: const TextStyle(color: AppColors.muted),
      ),
      const SizedBox(height: 24),
      FilledButton(
        onPressed: () => setState(() => _index = 0),
        child: const Text('Begin'),
      ),
    ],
  );

  Widget _question(QuizQuestion q) {
    final total = _quiz.questions.length;
    final selected = _answers[q.id];
    return PageBody(
      children: [
        Text(
          'Vraag ${_index + 1} van $total',
          style: const TextStyle(color: AppColors.muted),
        ),
        const SizedBox(height: 6),
        LinearProgressIndicator(
          value: (_index + 1) / total,
          color: AppColors.olive,
          backgroundColor: AppColors.paperDark,
          minHeight: 6,
          borderRadius: BorderRadius.circular(3),
        ),
        const SizedBox(height: 20),
        Text(q.question, style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 16),
        for (var i = 0; i < q.options.length; i++)
          Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: OptionTile(
              text: q.options[i],
              selected: selected == i,
              onTap: () => setState(() => _answers[q.id] = i),
            ),
          ),
        const SizedBox(height: 8),
        Row(
          children: [
            if (_index > 0)
              Expanded(
                child: OutlinedButton(
                  onPressed: () => setState(() => _index--),
                  child: const Text('Vorige'),
                ),
              ),
            if (_index > 0) const SizedBox(width: 12),
            Expanded(
              child: FilledButton(
                onPressed: selected == null
                    ? null
                    : () => _index == total - 1
                          ? _finish()
                          : setState(() => _index++),
                child: Text(_index == total - 1 ? 'Afronden' : 'Volgende'),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _preDone() => PageBody(
    children: [
      const SizedBox(height: 24),
      const Icon(Icons.check_circle_outline, size: 56, color: AppColors.olive),
      const SizedBox(height: 16),
      Text(
        'Bedankt!',
        textAlign: TextAlign.center,
        style: Theme.of(context).textTheme.headlineSmall,
      ),
      const SizedBox(height: 8),
      const Text(
        'Jullie antwoorden zijn bewaard. Aan het einde van de route zien '
        'jullie wat je onderweg hebt ontdekt.',
        textAlign: TextAlign.center,
      ),
      const SizedBox(height: 24),
      FilledButton(onPressed: _leave, child: const Text('Naar de route')),
    ],
  );

  Widget _postDone() {
    final progress = ref.read(progressProvider);
    final pre = progress.preQuiz;
    final post = progress.postQuiz;
    final now = post?.correctCount(_route.postQuiz) ?? 0;
    final before = pre?.correctCount(_route.preQuiz);
    final group = progress.isGroup;
    final String message;
    if (before == null) {
      message = group
          ? 'Jullie kennen nu veel verbanden binnen Operatie Market Garden.'
          : 'Je kent nu veel verbanden binnen Operatie Market Garden.';
    } else if (now > before) {
      message = group
          ? 'Jullie kennen nu meer verbanden binnen Operatie Market Garden dan aan het begin.'
          : 'Je kent nu meer verbanden binnen Operatie Market Garden dan aan het begin.';
    } else {
      message = group
          ? 'Jullie wisten vooraf al veel. Onderweg hebben jullie die kennis aan echte plekken gekoppeld.'
          : 'Je wist vooraf al veel. Onderweg heb je die kennis aan echte plekken gekoppeld.';
    }

    return PageBody(
      children: [
        const SizedBox(height: 16),
        const Icon(Icons.insights_outlined, size: 56, color: AppColors.olive),
        const SizedBox(height: 12),
        Text(
          message,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SectionTitle('De verbanden op een rij'),
        for (final q in _route.postQuiz.questions)
          Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: DossierCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    q.question,
                    style: const TextStyle(fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 4),
                  Text(q.options[q.correctIndex]),
                ],
              ),
            ),
          ),
        const SizedBox(height: 16),
        FilledButton(onPressed: _leave, child: const Text('Afronden')),
      ],
    );
  }
}
