import 'package:kashew/models/expense_model.dart';

class ExpenseGroup {

  DateTime date;
  List<ExpenseModel> expenses;

  ExpenseGroup({required this.date, required this.expenses});

}