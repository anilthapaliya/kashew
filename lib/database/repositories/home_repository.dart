import '../helper/database_helper.dart';

class HomeRepository {

  final DatabaseHelper dbHelper = DatabaseHelper.dbHelper;

  Future<double> getTotalMonthlyExpense(int start, int end) async {

    double total = await dbHelper.totalExpenseOfTheMonth(start, end);
    return total;
  }

  Future<Map<String, dynamic>?> getTopCategory(int start, int end) async {

    Map<String, dynamic>? data = await dbHelper.getTopCategory(start, end);
    return data;
  }

}