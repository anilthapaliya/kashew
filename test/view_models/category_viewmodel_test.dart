import 'package:flutter_test/flutter_test.dart';
import 'package:kashew/models/category_model.dart';
import 'package:kashew/view_models/category_viewmodel.dart';
import 'package:mockito/annotations.dart';
import 'package:kashew/database/repositories/category_repository.dart';
import 'package:mockito/mockito.dart';
@GenerateMocks([CategoryRepository, CategoryModel])
import 'category_viewmodel_test.mocks.dart';

void main() {

  late MockCategoryRepository mockRepo;
  late CategoryViewModel viewModel;
  bool notified = false;

  setUp(() {
    mockRepo = MockCategoryRepository();
    viewModel = CategoryViewModel(categoryRepo: mockRepo);

    viewModel.addListener(() {
      notified = true;
    });
  });

  group("Category Screen", () {

    test("should load categories.", () async {
      // Arrange
      when(mockRepo.getCategories()).thenAnswer((_) async => [MockCategoryModel(), MockCategoryModel()]);
      // Act
      await viewModel.loadCategories();
      // Assert
      expect(viewModel.categories, isA<List<CategoryModel>>());
      expect(viewModel.selectedCategory, isA<CategoryModel>());
      expect(notified, true);
    });

    test("should not load categories.", () async {
      when(mockRepo.getCategories()).thenAnswer((_) async => [MockCategoryModel()]);
      viewModel.categories = [MockCategoryModel()];
      await viewModel.loadCategories();
      verifyNever(mockRepo.getCategories());
      expect(viewModel.selectedCategory, null);
      expect(notified, false);
    });
  });

}