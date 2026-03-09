import 'package:kashew/database/helper/database_helper.dart';
import 'package:kashew/models/expense_model.dart';

class ExpenseRepository {

  final DatabaseHelper dbHelper = DatabaseHelper.dbHelper;

  Future<int> insertExpense(ExpenseModel expense) async {

    return dbHelper.insert(ExpenseModel.tableExpenses, expense.toMap());
  }

  Future<List<ExpenseModel>> getAllExpenses() async {

    final List<Map<String, dynamic>> maps = await dbHelper.query(ExpenseModel.tableExpenses);
    return List.generate(maps.length, (i) {
      return ExpenseModel.fromMap(maps[i]);
    });
  }

  Future<List<ExpenseModel>> getExpensesById(int topicId) async {

    final List<Map<String, dynamic>> maps = await dbHelper.query(ExpenseModel.tableExpenses,
        where: '${ExpenseModel.colTopicId} = ?', whereArgs: [topicId]);
    return List.generate(maps.length, (i) {
      return ExpenseModel.fromMap(maps[i]);
    });
  }

  Future<List<ExpenseModel>> getRecentExpenses() async {

    final List<Map<String, dynamic>> maps = await dbHelper.query(ExpenseModel.tableExpenses,
        orderBy: '${ExpenseModel.colDateTime} DESC', limit: 10);
    return List.generate(maps.length, (i) {
      return ExpenseModel.fromMap(maps[i]);
    });
  }

  Future<int> updateExpense(ExpenseModel expense, int expenseId) async {
    
    return await dbHelper.update(ExpenseModel.tableExpenses, expense.toMap(), '${ExpenseModel.colId} = ?', [expenseId]);
  }

  Future<int> deleteExpense(int expenseId) async {

    return await dbHelper.delete(ExpenseModel.tableExpenses, '${ExpenseModel.colId} = ?', [expenseId]);
  }
  
}