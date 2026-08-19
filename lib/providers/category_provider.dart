import 'package:flutter/foundation.dart';

import '../models/category_model.dart';

class CategoryProvider extends ChangeNotifier {
  final List<CategoryModel> _categories = [];

  List<CategoryModel> get categories => List.unmodifiable(_categories);

  void addCategory({
    required String name,
    required String description,
  }) {
    final category = CategoryModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: name,
      description: description,
    );

    _categories.add(category);

    notifyListeners();
  }

  void updateCategory({
    required String id,
    required String name,
    required String description,
  }) {
    final index = _categories.indexWhere(
          (category) => category.id == id,
    );

    if (index == -1) return;

    _categories[index].name = name;
    _categories[index].description = description;

    notifyListeners();
  }

  void deleteCategory(String id) {
    _categories.removeWhere(
          (category) => category.id == id,
    );

    notifyListeners();
  }
}