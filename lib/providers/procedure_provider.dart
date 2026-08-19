import 'package:flutter/foundation.dart';

import '../models/procedure_model.dart';

class ProcedureProvider extends ChangeNotifier {
  final List<ProcedureModel> _procedures = [];

  List<ProcedureModel> get procedures =>
      List.unmodifiable(_procedures);

  void addProcedure({
    required String title,
    required String categoryId,
    required String categoryName,
    required String description,
    required String processingTime,
    required double fee,
    required String office,
    required String workingHours,
    required List<String> requiredDocuments,
    required List<String> steps,
  }) {
    final procedure = ProcedureModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: title,
      categoryId: categoryId,
      categoryName: categoryName,
      description: description,
      processingTime: processingTime,
      fee: fee,
      office: office,
      workingHours: workingHours,
      requiredDocuments: List.from(requiredDocuments),
      steps: List.from(steps),
    );

    _procedures.add(procedure);

    notifyListeners();
  }

  void updateProcedure({
    required String id,
    required String title,
    required String categoryId,
    required String categoryName,
    required String description,
    required String processingTime,
    required double fee,
    required String office,
    required String workingHours,
    required List<String> requiredDocuments,
    required List<String> steps,
  }) {
    final index = _procedures.indexWhere(
          (procedure) => procedure.id == id,
    );

    if (index == -1) return;

    final procedure = _procedures[index];

    procedure.title = title;
    procedure.categoryId = categoryId;
    procedure.categoryName = categoryName;
    procedure.description = description;
    procedure.processingTime = processingTime;
    procedure.fee = fee;
    procedure.office = office;
    procedure.workingHours = workingHours;
    procedure.requiredDocuments =
        List.from(requiredDocuments);
    procedure.steps = List.from(steps);

    notifyListeners();
  }

  void deleteProcedure(String id) {
    _procedures.removeWhere(
          (procedure) => procedure.id == id,
    );

    notifyListeners();
  }
}