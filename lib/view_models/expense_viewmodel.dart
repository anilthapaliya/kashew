import 'package:flutter/material.dart';
import 'package:kashew/models/expense_model.dart';
import 'package:kashew/database/repositories/expense_repository.dart';

class ExpenseViewModel extends ChangeNotifier {

  ExpenseRepository expenseRepo = ExpenseRepository();
  List<ExpenseModel>? expenses;
  bool isExpenseLoading = false;
  bool isExpenseAdding = false;
  bool isError = false;
  String? errorMessage = "";

  Future<void> loadRecentExpenses() async {

    isExpenseLoading = true;
    notifyListeners();
    expenses =  await expenseRepo.getRecentExpenses();
    isExpenseLoading = false;
    notifyListeners();
  }

  Future<void> loadExpenses(int topicId) async {

    isExpenseLoading = true;
    notifyListeners();
    expenses = await expenseRepo.getExpensesById(topicId);
    isExpenseLoading = false;
    notifyListeners();
  }

  Future<void> addExpense(ExpenseModel expense) async {

    isExpenseAdding = true;
    notifyListeners();

    final id = await expenseRepo.insertExpense(expense);
    if (id > 0) {
      expense.id = id;
      expenses!.add(expense);
    }

    isExpenseAdding = false;
    notifyListeners();
  }

  Future<void> updateExpense(ExpenseModel expense) async {

    await expenseRepo.updateExpense(expense, expense.id!);
  }

  Future<void> deleteExpense(int expenseId) async {

    await expenseRepo.deleteExpense(expenseId);
  }

}