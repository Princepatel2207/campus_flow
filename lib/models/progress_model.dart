import 'package:flutter/foundation.dart';

class ProgressModel {
  final String userId;
  final String procedureId;

  // Stores whether each step is completed.
  List<bool> completedSteps;

  ProgressModel({
    required this.userId,
    required this.procedureId,
    required int totalSteps,
  }) : completedSteps = List<bool>.filled(
    totalSteps,
    false,
  );

  int get completedCount {
    return completedSteps
        .where((completed) => completed)
        .length;
  }

  int get totalSteps {
    return completedSteps.length;
  }

  double get progress {
    if (totalSteps == 0) {
      return 0;
    }

    return completedCount / totalSteps;
  }

  int get percentage {
    return (progress * 100).round();
  }

  bool get isCompleted {
    return totalSteps > 0 &&
        completedCount == totalSteps;
  }

  void toggleStep(int index) {
    if (index < 0 ||
        index >= completedSteps.length) {
      return;
    }

    completedSteps[index] =
    !completedSteps[index];
  }
}