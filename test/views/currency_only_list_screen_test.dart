import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kashew/l10n/app_localizations.dart';
import 'package:kashew/models/currency_model.dart';
import 'package:kashew/utils/constants.dart';
import 'package:kashew/utils/responsive.dart';
import 'package:kashew/views/currency_only_list_screen.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:kashew/view_models/currency_viewmodel.dart';
import 'package:provider/provider.dart';
import 'splash_screen_test.mocks.dart';
@GenerateMocks([CurrencyViewModel])

void main() {

  late MockCurrencyViewModel mockCurrencyVM;

  setUp(() {
    mockCurrencyVM = MockCurrencyViewModel();
  });

  testWidgets("Currency Only List UI", (tester) async {

    when(mockCurrencyVM.currencies).thenReturn([
      CurrencyModel(CurrencyModel.usd), CurrencyModel(CurrencyModel.eur), CurrencyModel(CurrencyModel.gbp),
      CurrencyModel(CurrencyModel.yen), CurrencyModel(CurrencyModel.aud), CurrencyModel(CurrencyModel.inr),
      CurrencyModel(CurrencyModel.npr),
    ]);
    when(mockCurrencyVM.selectCurrency(any)).thenAnswer((_) async {});

    await tester.pumpWidget(
      MultiProvider(providers: [
        ChangeNotifierProvider<CurrencyViewModel>.value(value: mockCurrencyVM)
      ],
      child: MaterialApp(
          routes: {
            Constants.home : (_) => const Scaffold(body: Text("Home"))
          },
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          locale: const Locale('en'),
          home: MediaQuery(data: const MediaQueryData(size: Size(1080, 1920)),
              child: Builder(builder: (context) {
                R.init(context);
                return const CurrencyListScreen();
              }))
      ))
    );

    // Check appearance
    expect(find.text("All Currencies"), findsOneWidget);
    final listFinder = find.byKey(const Key('currency-list'));
    expect(listFinder, findsOneWidget);

    // Check currency loaded
    expect(find.textContaining(CurrencyModel.currencyMap[CurrencyModel.usd]!), findsOneWidget);

    // Check scroll
    final aud = find.byKey(const Key('currency-item-AUD'));
    await tester.scrollUntilVisible(aud, 300);
    expect(aud, findsOneWidget);

    // Tap on currency item
    final npr = find.byKey(const Key('currency-item-NPR'));
    await tester.scrollUntilVisible(npr, 300);
    await tester.tap(npr.hitTestable());
    await tester.pumpAndSettle();
    verify(mockCurrencyVM.selectCurrency(any)).called(1);

  });

}