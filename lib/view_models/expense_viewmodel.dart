import 'package:flutter/material.dart';
import 'package:kashew/models/expense_model.dart';
import 'package:kashew/database/repositories/expense_repository.dart';
import 'package:kashew/utils/constants.dart';

class ExpenseViewModel extends ChangeNotifier {

  ExpenseRepository expenseRepo = ExpenseRepository();
  List<ExpenseModel>? expenses;
  bool isExpenseLoading = false;
  bool isExpenseAdding = false;
  bool isError = false;
  String? errorTitle = "";
  String? errorAmount = "";

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

    ExpenseModel expense = ExpenseModel(title: title, amount: doubleAmount, dbDateTime: date.millisecondsSinceEpoch, categoryId: categoryId, topicId: topicId, note: note);
    return await addExpense(expense);
  }

  Future<int> addExpense(ExpenseModel expense) async {

    isExpenseAdding = true;
    notifyListeners();

    final id = await expenseRepo.insertExpense(expense);
    if (id > 0) {
      expenses ??= [];
      expense.id = id;
      expenses!.add(expense);
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

  Future<void> updateExpense(ExpenseModel expense) async {

    await expenseRepo.updateExpense(expense, expense.id!);
  }

  Future<void> deleteExpense(int expenseId) async {

    await expenseRepo.deleteExpense(expenseId);
  }

}