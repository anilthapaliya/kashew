import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kashew/l10n/app_localizations.dart';
import 'package:kashew/models/category_model.dart';
import 'package:kashew/models/currency_model.dart';
import 'package:kashew/utils/responsive.dart';
import 'package:kashew/view_models/currency_viewmodel.dart';
import 'package:kashew/views/widgets/add_topic_widget.dart';
import 'package:mockito/annotations.dart';
import 'package:kashew/view_models/category_viewmodel.dart';
import 'package:kashew/view_models/expense_viewmodel.dart';
import 'package:kashew/view_models/topic_viewmodel.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';
import 'package:kashew/utils/constants.dart';
import 'add_topic_widget_test.mocks.dart';
@GenerateMocks([])
@GenerateNiceMocks([
  MockSpec<CurrencyViewModel>(), MockSpec<CategoryViewModel>(), MockSpec<TopicViewModel>()
])

void main() {

  late MockCurrencyViewModel mockCurrencyVM;
  late MockCategoryViewModel mockCategoryVM;
  late MockTopicViewModel mockTopicVM;

  setUp(() {
    mockCurrencyVM = MockCurrencyViewModel();
    mockCategoryVM = MockCategoryViewModel();
    mockTopicVM = MockTopicViewModel();

    when(mockCategoryVM.categories).thenReturn([
      CategoryModel(categoryName: 'Category1'), CategoryModel(categoryName: 'Category2'),
      CategoryModel(categoryName: 'Category3'), CategoryModel(categoryName: 'Category4'),
    ]);
    when(mockCurrencyVM.currencies).thenReturn([
      CurrencyModel(CurrencyModel.usd), CurrencyModel(CurrencyModel.eur), CurrencyModel(CurrencyModel.gbp),
      CurrencyModel(CurrencyModel.yen), CurrencyModel(CurrencyModel.aud), CurrencyModel(CurrencyModel.inr),
      CurrencyModel(CurrencyModel.npr),
    ]);
    when(mockCurrencyVM.defaultCurrency).thenReturn(CurrencyModel(CurrencyModel.usd));
  });

  group("Add Topic UI", () {

    testWidgets("should load fine", (tester) async {
      await tester.pumpWidget(_getMaterialApp(mockCurrencyVM, mockCategoryVM, mockTopicVM));

      expect(find.byKey(const Key("header")), findsOneWidget);
    });

    testWidgets("add button should be present", (tester) async {
      await tester.pumpWidget(_getMaterialApp(mockCurrencyVM, mockCategoryVM, mockTopicVM));
      await tester.pumpAndSettle();

      expect(find.byKey(const Key('add-topic-button')), findsOneWidget);
    });

    testWidgets("empty fields and add button should not work", (tester) async {

      when(mockTopicVM.addTopic(any, any)).thenAnswer((_) async => Constants.failure);
      await tester.pumpWidget(_getMaterialApp(mockCurrencyVM, mockCategoryVM, mockTopicVM));
      await tester.pumpAndSettle();

      final buttonFinder = find.byKey(const Key('add-topic-button'));
      await tester.ensureVisible(buttonFinder);
      await tester.tap(buttonFinder);
      await tester.pumpAndSettle();
      expect(buttonFinder, findsOneWidget);
      verify(mockTopicVM.addTopic(any, any)).called(1);
    });

    testWidgets("filled fields and add button should work", (tester) async {

      when(mockTopicVM.addTopic(any, any)).thenAnswer((_) async => Constants.success);
      await tester.pumpWidget(_getMaterialApp(mockCurrencyVM, mockCategoryVM, mockTopicVM));
      await tester.pumpAndSettle();

      final topicFinder = find.byKey(const Key('topic-text-field'));
      await tester.enterText(topicFinder, 'random-topic');
      final descFinder = find.byKey(const Key('desc-text-field'));
      await tester.enterText(descFinder, 'random description');
      await tester.pumpAndSettle();

      final buttonFinder = find.byKey(const Key('add-topic-button'));
      expect(buttonFinder, findsOneWidget);
      await tester.ensureVisible(buttonFinder);
      await tester.tap(buttonFinder);
      await tester.pumpAndSettle();
      verify(mockTopicVM.addTopic(any, any)).called(1);
    });

  });

}

Widget _getMaterialApp(MockCurrencyViewModel mockCurrencyVM,
    MockCategoryViewModel mockCategoryVM, MockTopicViewModel mockTopicVM) {

  return MultiProvider(providers: [
    ChangeNotifierProvider<CurrencyViewModel>.value(value: mockCurrencyVM),
    ChangeNotifierProvider<CategoryViewModel>.value(value: mockCategoryVM),
    ChangeNotifierProvider<TopicViewModel>.value(value: mockTopicVM),
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
                body: AddTopicWidget()
            );
          }))
  ));
}