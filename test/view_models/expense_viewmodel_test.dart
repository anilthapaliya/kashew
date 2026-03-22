import 'package:flutter_test/flutter_test.dart';
import 'package:kashew/view_models/expense_viewmodel.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:kashew/database/repositories/expense_repository.dart';
import 'package:kashew/models/expense_model.dart';
import 'package:kashew/models/expense_group_model.dart';
@GenerateMocks([ExpenseRepository, ExpenseModel, ExpenseGroup])
import 'expense_viewmodel_test.mocks.dart';

void main() {

  late ExpenseViewModel viewModel;
  late MockExpenseRepository mockRepo;
  bool notified = false;

  setUp(() {
    mockRepo = MockExpenseRepository();
    viewModel = ExpenseViewModel(expenseRepo: mockRepo);
    viewModel.addListener(() {
      notified = true;
    });
  });

  group("Expense Activities", () {

    group("loading recent expenses:", () {

      test("should load recent expenses.", () async {
        when(mockRepo.getRecentExpenses()).thenAnswer((_) async => [MockExpenseModel(), MockExpenseModel()]);
        await viewModel.loadRecentExpenses();
        expect(viewModel.recentExpenses, isA<List<ExpenseModel>>());
        expect(notified, true);
      });

      test("should load empty expenses.", () async {
        when(mockRepo.getRecentExpenses()).thenAnswer((_) async => []);
        await viewModel.loadRecentExpenses();
        expect(viewModel.recentExpenses!.length, 0);
        expect(notified, true);
      });
    });

    group("loading expenses:", () {

      test("should load expenses.", () async {
        final expense = MockExpenseModel();
        when(mockRepo.getExpensesById(any)).thenAnswer((_) async => [expense]);
        when(viewModel.groupExpensesByDate([MockExpenseModel()])).thenAnswer((_) => [MockExpenseGroup()]);
        when(expense.dbDateTime).thenReturn(DateTime.now().millisecondsSinceEpoch);
        await viewModel.loadExpenses(1);
        expect(viewModel.groupExpenses, isA<List<ExpenseGroup>>());
        expect(notified, true);
      });

      test("should not load expenses when no expenses found.", () async {
        final expense = MockExpenseModel();
        when(mockRepo.getExpensesById(any)).thenAnswer((_) async => []);
        await viewModel.loadExpenses(100);
        expect(viewModel.groupExpenses, null);
        expect(notified, true);
      });
    });

    group("", () {

    });
  });

}