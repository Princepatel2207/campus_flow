import 'package:flutter/foundation.dart';

import '../models/progress_model.dart';
import '../models/procedure_model.dart';

class ProgressProvider extends ChangeNotifier {
  final Map<String, ProgressModel> _progress = {};

  String _progressKey(
      String userId,
      String procedureId,
      ) {
    return '$userId-$procedureId';
  }

  ProgressModel? getProgress({
    required String userId,
    required String procedureId,
  }) {
    final key = _progressKey(
      userId,
      procedureId,
    );

    return _progress[key];
  }

  ProgressModel startProcedure({
    required String userId,
    required ProcedureModel procedure,
  }) {
    final key = _progressKey(
      userId,
      procedure.id,
    );

    if (!_progress.containsKey(key)) {
      _progress[key] = ProgressModel(
        userId: userId,
        procedureId: procedure.id,
        totalSteps: procedure.steps.length,
      );

      notifyListeners();
    }

    return _progress[key]!;
  }

  void toggleStep({
    required String userId,
    required String procedureId,
    required int stepIndex,
  }) {
    final key = _progressKey(
      userId,
      procedureId,
    );

    final progress = _progress[key];

    if (progress == null) {
      return;
    }

    progress.toggleStep(stepIndex);

    notifyListeners();
  }

  void resetProgress({
    required String userId,
    required String procedureId,
  }) {
    final key = _progressKey(
      userId,
      procedureId,
    );

    _progress.remove(key);

    notifyListeners();
  }
}