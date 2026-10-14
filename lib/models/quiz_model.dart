class QuizQuestion {
  const QuizQuestion({
    required this.id,
    required this.question,
    required this.options,
    required this.correctIndex,
    this.explanation,
  });

  /// Gelijke id's in voor- en eindquiz worden met elkaar vergeleken.
  final String id;
  final String question;
  final List<String> options;
  final int correctIndex;
  final String? explanation;
}

class Quiz {
  const Quiz({
    required this.id,
    required this.title,
    required this.intro,
    required this.questions,
  });

  final String id;
  final String title;
  final String intro;
  final List<QuizQuestion> questions;
}

/// Opgeslagen antwoorden. Bewust simpel en JSON-baar, zodat het later
/// naar CSV geëxporteerd kan worden.
class QuizResult {
  const QuizResult({
    required this.quizId,
    required this.answers,
    required this.completedAt,
  });

  final String quizId;

  /// questionId -> gekozen optie-index.
  final Map<String, int> answers;
  final DateTime completedAt;

  int correctCount(Quiz quiz) =>
      quiz.questions.where((q) => answers[q.id] == q.correctIndex).length;

  Map<String, dynamic> toJson() => {
    'quizId': quizId,
    'answers': answers,
    'completedAt': completedAt.toIso8601String(),
  };

  factory QuizResult.fromJson(Map<String, dynamic> json) => QuizResult(
    quizId: json['quizId'] as String,
    answers: (json['answers'] as Map).map(
      (k, v) => MapEntry(k as String, v as int),
    ),
    completedAt: DateTime.parse(json['completedAt'] as String),
  );
}
