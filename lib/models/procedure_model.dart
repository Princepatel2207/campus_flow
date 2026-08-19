class ProcedureModel {
  final String id;

  String title;
  String categoryId;
  String categoryName;
  String description;

  String processingTime;
  double fee;

  String office;
  String workingHours;

  List<String> requiredDocuments;
  List<String> steps;

  ProcedureModel({
    required this.id,
    required this.title,
    required this.categoryId,
    required this.categoryName,
    required this.description,
    required this.processingTime,
    required this.fee,
    required this.office,
    required this.workingHours,
    required this.requiredDocuments,
    required this.steps,
  });
}