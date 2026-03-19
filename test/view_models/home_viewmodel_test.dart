import 'package:kashew/database/repositories/home_repository.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kashew/view_models/home_viewmodel.dart';
import 'package:kashew/utils/constants.dart';
import 'package:kashew/models/expense_model.dart';

@GenerateMocks([HomeRepository])
import 'home_viewmodel_test.mocks.dart';

void main() {

  late HomeViewModel viewModel;
  late MockHomeRepository mockRepo;
  bool notified = false;

  setUp(() {
    mockRepo = MockHomeRepository();
    viewModel = HomeViewModel(homeRepo: mockRepo);

    viewModel.addListener(() {
      notified = true;
    });
  });

  group("Home Screen", () {

    test("should set values and notify listeners.", () async {
      // Arrange
      when(mockRepo.getTotalMonthlyExpense(any, any)).thenAnswer((_) async => 200.0);
      when(mockRepo.getTopCategory(any, any)).thenAnswer((_) async => {
        ExpenseModel.colCategoryId: 152,
        Constants.dataCategory: "Food",
        Constants.dataTotal: 100.0
      });

      // Act
     await viewModel.loadStats();

     // Assert
      expect(viewModel.totalMonthlyExpense, 200.0);
      expect(viewModel.categoryId, 152);
      expect(viewModel.topCategory, "Food");
      expect(viewModel.topCategoryAmount, 100.0);
      expect(notified, true);
    });

    test("should handle null top category.", () async {

      when(mockRepo.getTotalMonthlyExpense(any, any)).thenAnswer((_) async => 159.9);
      when(mockRepo.getTopCategory(any, any)).thenAnswer((_) async => null);

      await viewModel.loadStats();

      expect(viewModel.totalMonthlyExpense, 159.9);
      expect(viewModel.categoryId, null);
      expect(viewModel.topCategory, null);
      expect(viewModel.topCategoryAmount, null);
      expect(notified, true);
    });

    test("should call repository methods.", () async {
      when(mockRepo.getTotalMonthlyExpense(any, any)).thenAnswer((_) async => 0.0);
      when(mockRepo.getTopCategory(any, any)).thenAnswer((_) async => null);

      await viewModel.loadStats();

      verify(mockRepo.getTotalMonthlyExpense(any, any)).called(1);
      verify(mockRepo.getTopCategory(any, any)).called(1);
    });
  });

}