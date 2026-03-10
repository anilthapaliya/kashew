import 'package:flutter/material.dart';
import 'package:kashew/models/expense_model.dart';
import 'package:kashew/database/repositories/expense_repository.dart';
import 'package:kashew/utils/common_utils.dart';
import 'package:kashew/utils/constants.dart';

class ExpenseViewModel extends ChangeNotifier {

  ExpenseRepository expenseRepo = ExpenseRepository();
  int? _currentTopicId;
  List<ExpenseModel>? expenses;
  bool isExpenseLoading = false;
  bool isExpenseAdding = false;
  bool isError = false;
  String? errorTitle = "";
  String? errorAmount = "";

  void setCurrentTopicId(int topicId) {
    _currentTopicId = topicId;
  }

  Future<void> loadRecentExpenses() async {

    isExpenseLoading = true;
    notifyListeners();
    expenses = await expenseRepo.getRecentExpenses();
    isExpenseLoading = false;
    notifyListeners();
  }

  Future<void> loadExpenses(int topicId) async {

    isExpenseLoading = true;
    notifyListeners();

    final list = await expenseRepo.getExpensesById(topicId);
    if (list.isNotEmpty) expenses = list.toList();
    isExpenseLoading = false;
    notifyListeners();
  }

  Future<int> addExpenseByValue(String title, String amount, DateTime date, String note, int categoryId, int topicId) async {

    if (title.isEmpty) {
      isError = true;
      errorTitle = Constants.errExpenseTitle;
      notifyListeners();
      return Constants.failure;
    }

    double doubleAmount;
    try {
      doubleAmount = double.parse(amount).toDouble();
      if (doubleAmount <= 0 || doubleAmount > Constants.maxAmountThreshold) throw Exception();
    } on Exception {
      doubleAmount = 0;
      isError = true;
      errorAmount = Constants.errExpenseAmount;
      notifyListeners();
      return Constants.failure;
    }

    ExpenseModel expense = ExpenseModel(title: CommonUtils.capitalizeFirst(title), amount: doubleAmount, dbDateTime: date.millisecondsSinceEpoch, categoryId: categoryId, topicId: topicId, note: CommonUtils.capitalizeFirst(note));
    return await addExpense(expense);
  }

  Future<int> addExpense(ExpenseModel expense) async {

    isExpenseAdding = true;
    notifyListeners();

    final id = await expenseRepo.insertExpense(expense);
    if (id > 0) {
      if (_currentTopicId == expense.topicId) {
        expenses ??= [];
        expense.id = id;
        expenses!.add(expense);
      }

      isError = false;
      isExpenseAdding = false;
      notifyListeners();
      return Constants.success;
    }

    isError = false;
    isExpenseAdding = false;
    notifyListeners();
    return Constants.failure;
  }

  Future<int> updateExpenseByValue(int expenseId, String title, String amount, DateTime date, String note, int categoryId, int topicId) async {

    if (title.isEmpty) {
      isError = true;
      errorTitle = Constants.errExpenseTitle;
      notifyListeners();
      return Constants.failure;
    }

    double doubleAmount;
    try {
      doubleAmount = double.parse(amount).toDouble();
      if (doubleAmount <= 0 || doubleAmount > Constants.maxAmountThreshold) throw Exception();
    } on Exception {
      doubleAmount = 0;
      isError = true;
      errorAmount = Constants.errExpenseAmount;
      notifyListeners();
      return Constants.failure;
    }

    ExpenseModel expense = ExpenseModel(id: expenseId, title: CommonUtils.capitalizeFirst(title), amount: doubleAmount, dbDateTime: date.millisecondsSinceEpoch, categoryId: categoryId, topicId: topicId, note: CommonUtils.capitalizeFirst(note));
    return await updateExpense(expense);
  }

  Future<int> updateExpense(ExpenseModel expense) async {

    int count = await expenseRepo.updateExpense(expense, expense.id!);
    if (count > 0) {
      int index = expenses!.indexWhere((i) => i.id == expense.id);
      if (index != -1) expenses![index] = expense;
      isError = false;
      notifyListeners();
      return Constants.success;
    }

    isError = false;
    notifyListeners();
    return Constants.failure;
  }

  Future<int> deleteExpense(int expenseId) async {

    int result = await expenseRepo.deleteExpense(expenseId);

    if (result > 0) {
      int index = expenses!.indexWhere((i) => i.id == expenseId);
      if (index != -1) expenses!.removeAt(index);
      notifyListeners();
      return Constants.success;
    }

    return Constants.failure;
  }

}