import 'package:flutter/material.dart';
import 'package:kashew/models/expense_group_model.dart';
import 'package:kashew/models/expense_model.dart';
import 'package:kashew/database/repositories/expense_repository.dart';
import 'package:kashew/utils/common_utils.dart';
import 'package:kashew/utils/constants.dart';

class ExpenseViewModel extends ChangeNotifier {

  ExpenseRepository expenseRepo = ExpenseRepository();
  int? _currentTopicId;
  List<ExpenseGroup>? groupExpenses;
  List<ExpenseModel>? recentExpenses;
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
    recentExpenses = await expenseRepo.getRecentExpenses();
    isExpenseLoading = false;
    notifyListeners();
  }

  Future<void> loadExpenses(int topicId) async {

    isExpenseLoading = true;
    notifyListeners();
    List<ExpenseModel>? expenses;

    final list = await expenseRepo.getExpensesById(topicId);
    if (list.isNotEmpty) {
      expenses = list.toList();
      groupExpenses = groupExpensesByDate(expenses);
    }

    isExpenseLoading = false;
    notifyListeners();
  }

  List<ExpenseGroup> groupExpensesByDate(List<ExpenseModel> expenses) {

    Map<String, List<ExpenseModel>> grouped = {};
    for (var expense in expenses) {
      DateTime date = DateTime.fromMillisecondsSinceEpoch(expense.dbDateTime);
      String key = "${date.year}-${date.month.toString().padLeft(2,'0')}-${date.day.toString().padLeft(2,'0')}";

      if (!grouped.containsKey(key)) {
        grouped[key] = [];
      }
      grouped[key]!.add(expense);
    }

    List<ExpenseGroup> groups = [];
    grouped.forEach((key, value) {
      DateTime date = DateTime.parse(key);
      groups.add(ExpenseGroup(date: date, expenses: value));
    });

    groups.sort((a, b) => b.date.compareTo(a.date));

    return groups;
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
        expense.id = id;
        addExpenseLocally(expense);
        await loadRecentExpenses();
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
      /*int index = expenses!.indexWhere((i) => i.id == expense.id);
      if (index != -1) expenses![index] = expense;*/
      updateExpenseLocally(expense);
      isError = false;
      notifyListeners();
      await loadRecentExpenses();
      return Constants.success;
    }

    isError = false;
    notifyListeners();
    return Constants.failure;
  }

  Future<int> deleteExpense(int expenseId) async {

    int result = await expenseRepo.deleteExpense(expenseId);

    if (result > 0) {
      deleteExpenseLocally(expenseId);
      notifyListeners();
      await loadRecentExpenses();
      return Constants.success;
    }

    return Constants.failure;
  }

  double getTotalExpenses(int topicId) {

    if (groupExpenses == null) return 0.0;
    return groupExpenses!.fold(0.0, (sum, e) => sum + getTotalExpensesByTopicId(e.expenses, topicId));
  }

  double getTotalExpensesByTopicId(List<ExpenseModel> expenses, int topicId) {

    return expenses.where((e) => e.topicId == topicId)
        .fold(0.0, (sum, e) => sum + e.amount);
  }

  void addExpenseLocally(ExpenseModel expense) {

    groupExpenses ??= [];

    DateTime expDate = DateTime.fromMillisecondsSinceEpoch(expense.dbDateTime);
    // Normalize date (remove time)
    DateTime date = DateTime(expDate.year, expDate.month, expDate.day);

    int index = groupExpenses!.indexWhere(
          (g) => g.date.year == date.year &&
          g.date.month == date.month &&
          g.date.day == date.day);

    if (index != -1) {
      // If group exists, add newest on top
      groupExpenses![index].expenses.insert(0, expense);
    }
    else {
      // Create new group and keep latest group on top
      int insertIndex = groupExpenses!.indexWhere((g) => g.date.isBefore(date));

      if (insertIndex == -1) {
        groupExpenses!.add(ExpenseGroup(date: date, expenses: [expense]));
      } else {
        groupExpenses!.insert(insertIndex, ExpenseGroup(date: date, expenses: [expense]));
      }
    }
  }

  void updateExpenseLocally(ExpenseModel updatedExpense) {

    if (groupExpenses == null) return;

    for (int i = 0; i < groupExpenses!.length; i++) {
      var group = groupExpenses![i];
      int index = group.expenses.indexWhere((e) => e.id == updatedExpense.id);

      if (index != -1) {
        group.expenses.removeAt(index);
        if (group.expenses.isEmpty) groupExpenses!.removeAt(i);

        addExpenseLocally(updatedExpense);

        return;
      }
    }
  }

  void deleteExpenseLocally(int expenseId) {

    if (groupExpenses == null) return;

    for (var group in groupExpenses!) {
      int index = group.expenses.indexWhere((e) => e.id == expenseId);

      if (index != -1) {
        group.expenses.removeAt(index);
        return;
      }
    }
  }

}