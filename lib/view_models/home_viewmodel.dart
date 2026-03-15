import 'package:flutter/material.dart';
import 'package:kashew/database/repositories/home_repository.dart';
import 'package:kashew/models/expense_model.dart';
import 'package:kashew/utils/constants.dart';

class HomeViewModel extends ChangeNotifier {

  HomeRepository homeRepo = HomeRepository();
  DateTime today = DateTime.now();
  late DateTime monthStart;
  late DateTime nextMonthStart;
  double? totalMonthlyExpense;
  int? categoryId;
  String? topCategory;
  double? topCategoryAmount;

  HomeViewModel() {

    monthStart = DateTime(today.year, today.month, 1);
    nextMonthStart = DateTime(today.year, today.month + 1, 1);
  }

  void loadStats() async {

    totalMonthlyExpense = await homeRepo.getTotalMonthlyExpense(
        monthStart.millisecondsSinceEpoch, nextMonthStart.millisecondsSinceEpoch);
    Map<String, dynamic>? data = await homeRepo.getTopCategory(
        monthStart.millisecondsSinceEpoch, nextMonthStart.millisecondsSinceEpoch);
    if (data != null) {
      categoryId = data[ExpenseModel.colCategoryId];
      topCategory = data[Constants.dataCategory];
      topCategoryAmount = data[Constants.dataTotal];
    }

    notifyListeners();
  }

}