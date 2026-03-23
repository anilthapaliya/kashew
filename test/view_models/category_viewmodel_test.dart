import 'package:flutter_test/flutter_test.dart';
import 'package:kashew/models/category_model.dart';
import 'package:kashew/view_models/category_viewmodel.dart';
import 'package:mockito/annotations.dart';
import 'package:kashew/database/repositories/category_repository.dart';
import 'package:mockito/mockito.dart';
@GenerateMocks([CategoryRepository])
import 'category_viewmodel_test.mocks.dart';

void main() {

  late MockCategoryRepository mockRepo;
  late CategoryViewModel viewModel;
  int notifyCount = 0;

  setUp(() {
    notifyCount = 0;
    mockRepo = MockCategoryRepository();
    viewModel = CategoryViewModel(categoryRepo: mockRepo);

    viewModel.addListener(() {
      notifyCount++;
    });
  });

  group("Category Screen", () {

    test("should load categories.", () async {
      // Arrange
      final models = [CategoryModel(categoryName: "category-1"), CategoryModel(categoryName: "category-2")];
      when(mockRepo.getCategories()).thenAnswer((_) async => models);
      // Act
      await viewModel.loadCategories();
      // Assert
      expect(viewModel.categories, isA<List<CategoryModel>>());
      expect(viewModel.categories!.length, 2);
      expect(viewModel.selectedCategory, isNotNull);
      expect(notifyCount, greaterThan(0));
      verify(mockRepo.getCategories()).called(1);
    });

    test("should not load categories.", () async {
      final models = [CategoryModel(categoryName: "category-1"), CategoryModel(categoryName: "category-2")];
      viewModel.categories = models;
      await viewModel.loadCategories();
      verifyNever(mockRepo.getCategories());
      expect(viewModel.categories, models);
      expect(viewModel.selectedCategory, isNull);
      expect(notifyCount, equals(0));
    });
  });

}