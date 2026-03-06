import 'package:flutter/material.dart';
import 'package:kashew/database/helper/database_helper.dart';
import 'package:kashew/models/category_model.dart';

class CategoryViewModel extends ChangeNotifier {

  final DatabaseHelper dbHelper = DatabaseHelper();
  List<CategoryModel>? categories;
  CategoryModel? selectedCategory;

  Future<void> loadCategories() async {

    if (categories != null) return;

    categories ??= await dbHelper.getCategories();
    selectedCategory = categories![0];
    notifyListeners();
  }

  void selectCategory(CategoryModel model) {

    selectedCategory = model;
    notifyListeners();
  }

}