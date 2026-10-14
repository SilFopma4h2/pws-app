enum MissionType {
  multipleChoice,
  trueFalse,
  ordering,
  matching,
  textInput,
  mapQuestion,
  imageObservation,
  informationCombination,
}

/// Respectful missions (e.g. the cemetery) get calm feedback without
/// celebration effects.
enum MissionTone { normal, respectful }

/// A tappable point on the schematic map. x/y are 0..1 of the map size.
class MapPoint {
  const MapPoint(this.label, this.x, this.y);
  final String label;
  final double x;
  final double y;
}

/// A fixed text label on the schematic map (town names etc.).
class MapLabel {
  const MapLabel(this.text, this.x, this.y);
  final String text;
  final double x;
  final double y;
}

class MatchPair {
  const MatchPair(this.left, this.right);
  final String left;
  final String right;
}

/// One task inside a mission. Which fields are used depends on [type]:
/// - multipleChoice / trueFalse / imageObservation / informationCombination
///   / mapQuestion: [options] + [correctIndices]
/// - ordering: [items] in the CORRECT order (the app shuffles them)
/// - matching: [pairs] with the correct combinations
/// - textInput: [acceptedAnswers]
class MissionTask {
  const MissionTask({
    required this.id,
    required this.type,
    required this.prompt,
    this.options = const [],
    this.correctIndices = const {},
    this.items = const [],
    this.pairs = const [],
    this.acceptedAnswers = const [],
    this.hints = const [],
    this.wrongFeedback = 'Nog niet helemaal. Lees de uitleg nog eens goed.',
    this.explanation = '',
    this.infoCards = const [],
    this.imageAsset,
    this.imageCaption,
    this.mapPoints = const [],
    this.mapLabels = const [],
  });

  final String id;
  final MissionType type;
  final String prompt;
  final List<String> options;
  final Set<int> correctIndices;
  final List<String> items;
  final List<MatchPair> pairs;
  final List<String> acceptedAnswers;
  final List<String> hints;
  final String wrongFeedback;

  /// Shown after a correct answer: why it is correct.
  final String explanation;

  /// Short "dossier" snippets shown above the question.
  final List<String> infoCards;
  final String? imageAsset;
  final String? imageCaption;
  final List<MapPoint> mapPoints;
  final List<MapLabel> mapLabels;

  bool get allowsMultiple => correctIndices.length > 1;

  /// Answer formats:
  /// - choice types / mapQuestion: Set&lt;int&gt;
  /// - ordering: List&lt;int&gt; of original item indices in the chosen order
  /// - matching: Map&lt;int, int&gt; left index -> right index
  /// - textInput: String
  bool isCorrect(Object answer) {
    switch (type) {
      case MissionType.ordering:
        final order = answer as List<int>;
        if (order.length != items.length) return false;
        for (var i = 0; i < order.length; i++) {
          if (order[i] != i) return false;
        }
        return true;
      case MissionType.matching:
        final map = answer as Map<int, int>;
        if (map.length != pairs.length) return false;
        return map.entries.every((e) => e.key == e.value);
      case MissionType.textInput:
        final given = normalize(answer as String);
        return acceptedAnswers.any((a) => normalize(a) == given);
      case MissionType.multipleChoice:
      case MissionType.trueFalse:
      case MissionType.mapQuestion:
      case MissionType.imageObservation:
      case MissionType.informationCombination:
        final chosen = answer as Set<int>;
        return chosen.length == correctIndices.length &&
            chosen.containsAll(correctIndices);
    }
  }

  static String normalize(String s) {
    const accents = {
      'á': 'a',
      'à': 'a',
      'ä': 'a',
      'é': 'e',
      'è': 'e',
      'ë': 'e',
      'ï': 'i',
      'í': 'i',
      'ó': 'o',
      'ö': 'o',
      'ú': 'u',
      'ü': 'u',
    };
    var out = s.trim().toLowerCase();
    accents.forEach((k, v) => out = out.replaceAll(k, v));
    return out.replaceAll(RegExp(r'[^a-z0-9]'), '');
  }
}

class Mission {
  const Mission({
    required this.id,
    required this.title,
    required this.intro,
    required this.tasks,
    required this.completionText,
    required this.keyInsight,
    this.clueId,
    this.tone = MissionTone.normal,
  });

  final String id;
  final String title;
  final String intro;
  final List<MissionTask> tasks;

  /// Shown when the whole mission is finished.
  final String completionText;

  /// One-sentence "belangrijke kennis" for the mission book.
  final String keyInsight;
  final String? clueId;
  final MissionTone tone;
}
