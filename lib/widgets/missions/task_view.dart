import 'package:flutter/material.dart';

import '../../models/mission_model.dart';
import 'choice_task.dart';
import 'map_task.dart';
import 'matching_task.dart';
import 'ordering_task.dart';
import 'text_input_task.dart';

/// Picks the right widget for a task type.
class TaskView extends StatelessWidget {
  const TaskView({super.key, required this.task, required this.onSubmit});
  final MissionTask task;
  final ValueChanged<Object> onSubmit;

  @override
  Widget build(BuildContext context) {
    switch (task.type) {
      case MissionType.ordering:
        return OrderingTask(task: task, onSubmit: onSubmit);
      case MissionType.matching:
        return MatchingTask(task: task, onSubmit: onSubmit);
      case MissionType.textInput:
        return TextInputTask(task: task, onSubmit: onSubmit);
      case MissionType.mapQuestion:
        return MapTask(task: task, onSubmit: onSubmit);
      case MissionType.multipleChoice:
      case MissionType.trueFalse:
      case MissionType.imageObservation:
      case MissionType.informationCombination:
        return ChoiceTask(task: task, onSubmit: onSubmit);
    }
  }
}
