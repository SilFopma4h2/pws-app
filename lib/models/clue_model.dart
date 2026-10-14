import 'package:flutter/material.dart';

enum ClueType {
  letter('Letter', Icons.text_fields),
  number('Nummer', Icons.pin_outlined),
  mapFragment('Kaartfragment', Icons.map_outlined),
  name('Naam', Icons.person_outline),
  historicalFact('Historisch feit', Icons.lightbulb_outline),
  document('Document', Icons.description_outlined),
  symbol('Symbool', Icons.emergency_outlined),
  timelineFragment('Tijdlijnfragment', Icons.timeline);

  const ClueType(this.label, this.icon);
  final String label;
  final IconData icon;
}

class ClueModel {
  const ClueModel({
    required this.id,
    required this.type,
    required this.title,
    required this.value,
    required this.description,
  });

  final String id;
  final ClueType type;
  final String title;

  /// De kern van de aanwijzing, groot weergegeven (bijv. "18 SEPT" of "RIJN").
  final String value;
  final String description;
}
