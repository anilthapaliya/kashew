import 'package:flutter/material.dart';
import 'package:kashew/database/repositories/category_repository.dart';
import 'package:kashew/models/category_model.dart';

class CategoryViewModel extends ChangeNotifier {

  final CategoryRepository categoryRepo = CategoryRepository();
  List<CategoryModel>? categories;
  CategoryModel? selectedCategory;

  Future<void> loadCategories() async {

    if (categories != null) return;

    categories ??= await categoryRepo.getCategories();
    selectedCategory = categories![0];
    notifyListeners();
  }

  void selectCategory(CategoryModel model) {

    selectedCategory = model;
    notifyListeners();
  }

  void selectCategoryById(int categoryId) {

    if (categories != null) {
      selectedCategory = categories!.firstWhere((cat) => cat.id == categoryId);
      notifyListeners();
    }
  }

  IconData getIconByCategoryId(int categoryId) {

    if (categories != null) {
      final cat = categories!.firstWhere((cat) => cat.id == categoryId);
      return cat.icon;
    }

    return Icons.help;
  }

}