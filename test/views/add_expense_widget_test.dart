import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kashew/l10n/app_localizations.dart';
import 'package:kashew/models/category_model.dart';
import 'package:kashew/models/topic_model.dart';
import 'package:kashew/utils/responsive.dart';
import 'package:kashew/view_models/category_viewmodel.dart';
import 'package:kashew/view_models/expense_viewmodel.dart';
import 'package:kashew/view_models/topic_viewmodel.dart';
import 'package:kashew/view_models/home_viewmodel.dart';
import 'package:kashew/views/widgets/add_expense_widget.dart';
import 'package:kashew/utils/constants.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';
import 'add_expense_widget_test.mocks.dart';
@GenerateMocks([])
@GenerateNiceMocks([
  MockSpec<ExpenseViewModel>(), MockSpec<CategoryViewModel>(),
  MockSpec<TopicViewModel>(), MockSpec<HomeViewModel>()])

void main() {

  late MockExpenseViewModel mockExpenseVM;
  late MockCategoryViewModel mockCategoryVM;
  late MockTopicViewModel mockTopicVM;
  late MockHomeViewModel mockHomeVM;

  setUp(() {
    mockExpenseVM = MockExpenseViewModel();
    mockCategoryVM = MockCategoryViewModel();
    mockTopicVM = MockTopicViewModel();
    mockHomeVM = MockHomeViewModel();

    when(mockCategoryVM.categories).thenReturn([
      CategoryModel(categoryName: 'Category1'), CategoryModel(categoryName: 'Category2'),
      CategoryModel(categoryName: 'Category3'), CategoryModel(categoryName: 'Category4'),
    ]);
    when(mockExpenseVM.isError).thenReturn(false);
    when(mockCategoryVM.selectedCategory).thenReturn(CategoryModel(id: 1, categoryName: 'Category1'));
    when(mockExpenseVM.isExpenseAdding).thenReturn(false);
    when(mockExpenseVM.errorTitle).thenReturn(null);
    when(mockExpenseVM.errorAmount).thenReturn(null);
    TopicModel topic = TopicModel(id: 1, name: 'Random', dbDateTime: DateTime.now().millisecondsSinceEpoch, lastUpdated: DateTime.now().millisecondsSinceEpoch);
    topic.currency = 'USD';
    when(mockTopicVM.selectedTopic).thenReturn(topic);
  });

  group("Add Expense UI", () {

    testWidgets("should load fine", (tester) async {

      await tester.pumpWidget(_getMaterialApp(mockExpenseVM, mockCategoryVM, mockTopicVM, mockHomeVM));
      await tester.pumpAndSettle();

      expect(find.byKey(const Key("header")), findsOneWidget);
    });

    testWidgets("add button should be present", (tester) async {
      await tester.pumpWidget(_getMaterialApp(mockExpenseVM, mockCategoryVM, mockTopicVM, mockHomeVM));
      await tester.pumpAndSettle();

      expect(find.byKey(const Key('add-expense-button')), findsOneWidget);
    });

    testWidgets("empty fields and click on add button should not work", (tester) async {

      when(mockExpenseVM.addExpenseByValue(any, any, any, any, any, any, any, any)).thenAnswer((_) async => Constants.failure);
      await tester.pumpWidget(_getMaterialApp(mockExpenseVM, mockCategoryVM, mockTopicVM, mockHomeVM));
      await tester.pumpAndSettle();

      final button = find.byKey(const Key('add-expense-button'));
      expect(button, findsOneWidget);
      await tester.ensureVisible(button);
      await tester.tap(button);
      await tester.pumpAndSettle();
      verify(mockExpenseVM.addExpenseByValue(any, any, any, any, any, 'USD', any, any)).called(1);
      verifyNever(mockTopicVM.updateLastUpdated(any));
    });

    testWidgets("filled fields and click on add button should work", (tester) async {

      when(mockExpenseVM.addExpenseByValue(any, any, any, any, any, any, any, any)).thenAnswer((_) async => Constants.success);
      await tester.pumpWidget(_getMaterialApp(mockExpenseVM, mockCategoryVM, mockTopicVM, mockHomeVM));

      await tester.enterText(find.byKey(const Key('title-text-field')), 'random-title');
      await tester.enterText(find.byKey(const Key('amount-text-field')), '5');
      await tester.enterText(find.byKey(const Key('notes-text-field')), 'some-random-note');
      final dateFinder = find.byKey(const Key('date-text-field'));
      await tester.enterText(dateFinder, '01/01/2000');
      await tester.pumpAndSettle();

      final button = find.byKey(const Key('add-expense-button'));
      await tester.ensureVisible(button);
      await tester.tap(button);
      await tester.pumpAndSettle();
      verify(mockExpenseVM.addExpenseByValue(any, any, any, any, any, 'USD', any, any)).called(1);
      verify(mockTopicVM.updateLastUpdated(any)).called(1);
    });

  });

}

Widget _getMaterialApp(MockExpenseViewModel mockExpenseVM, MockCategoryViewModel mockCategoryVM,
    MockTopicViewModel mockTopicVM, MockHomeViewModel mockHomeVM) {

  return MultiProvider(providers: [
    ChangeNotifierProvider<ExpenseViewModel>.value(value: mockExpenseVM),
    ChangeNotifierProvider<CategoryViewModel>.value(value: mockCategoryVM),
    ChangeNotifierProvider<TopicViewModel>.value(value: mockTopicVM),
    ChangeNotifierProvider<HomeViewModel>.value(value: mockHomeVM),
  ], child: MaterialApp(
    routes: {
      Constants.topicOnlyList: (_) => const Scaffold(body: Text('Topics'))
    },
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    locale: const Locale('en'),
      home: MediaQuery(data: const MediaQueryData(size: Size(1080, 1920)),
          child: Builder(builder: (context) {
            R.init(context);
            return const Scaffold(
              body: AddExpenseWidget()
            );
          }))
  ));
}