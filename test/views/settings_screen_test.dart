import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kashew/l10n/app_localizations.dart';
import 'package:kashew/models/currency_model.dart';
import 'package:kashew/utils/constants.dart';
import 'package:kashew/utils/responsive.dart';
import 'package:kashew/view_models/currency_viewmodel.dart';
import 'package:kashew/views/settings_screen.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';
import 'package:kashew/view_models/currency_viewmodel.dart';
import 'package:kashew/view_models/language_viewmodel.dart';
import 'currency_only_list_screen_test.mocks.dart';
import 'language_only_list_screen_test.mocks.dart';
@GenerateMocks([CurrencyViewModel, LanguageViewModel])

void main() {

  late MockCurrencyViewModel mockCurrencyVM;
  late MockLanguageViewModel mockLanguageVM;
  const testScreenSizes = [
    Size(320, 568),  // small phone
    Size(360, 640),  // normal phone
    Size(412, 915),  // large phone
    Size(768, 1024), // tablet portrait
    Size(1024, 768), // tablet landscape
  ];

  setUp(() {
    mockCurrencyVM = MockCurrencyViewModel();
    mockLanguageVM = MockLanguageViewModel();

    when(mockCurrencyVM.defaultCurrency).thenReturn(CurrencyModel('usd'));
    when(mockLanguageVM.locale).thenReturn(Locale('en'));
  });

  for (var size in testScreenSizes) {
    testWidgets("Settings Screen UI - All items visibility - Under size: ${size.width}x${size.height}", (
        tester) async {
      await tester.pumpWidget(materialApp(size, mockLanguageVM, mockCurrencyVM));
      expect(find.text("Preferences"), findsOneWidget);
      expect(find.text("Languages"), findsOneWidget);
      expect(find.text("About App"), findsOneWidget);
      expect(find.textContaining("App Version"), findsOneWidget);
    });
  }

  testWidgets("Settings Screen UI - Currency", (WidgetTester tester) async {

    await tester.pumpWidget(
      materialApp(Size(1080, 1920), mockLanguageVM, mockCurrencyVM)
    );

    // Check items visibility
    expect(find.text("Preferences"), findsOneWidget);
    expect(find.text("Languages"), findsOneWidget);
    expect(find.text("About App"), findsOneWidget);
    expect(find.textContaining("App Version"), findsOneWidget);

    // Tap on currency
    final currencyItem = find.byKey(const Key("Currency Settings"));
    await tester.tap(currencyItem.hitTestable());
    await tester.pumpAndSettle();
    expect(find.text("Currencies"), findsOneWidget);

  });

  testWidgets("Settings Screen UI - Language", (tester) async {

    await tester.pumpWidget(
        materialApp(Size(1080, 1920), mockLanguageVM, mockCurrencyVM)
    );

    // Tap on language
    final languageItem = find.byKey(const Key("Languages"));
    await tester.ensureVisible(languageItem);
    await tester.tap(languageItem);
    await tester.pumpAndSettle();
    expect(find.text("Languages"), findsOneWidget);
  });

}

Widget materialApp(Size size, MockLanguageViewModel mockLanguageVM, MockCurrencyViewModel mockCurrencyVM) {

  return MultiProvider(providers: [
    ChangeNotifierProvider<CurrencyViewModel>.value(value: mockCurrencyVM),
    ChangeNotifierProvider<LanguageViewModel>.value(value: mockLanguageVM)
  ],
      child: MaterialApp(
        routes: {
          Constants.languageOnlyList: (_) => const Scaffold(body: Text("Languages")),
          Constants.currencyOnlyList: (_) => const Scaffold(body: Text("Currencies")),
        },
        localizationsDelegates: const [ AppLocalizations.delegate ],
        supportedLocales: AppLocalizations.supportedLocales,
        locale: Locale('en'),
        home: MediaQuery(data: MediaQueryData(size: size),
            child: Builder(builder: (context) {
              R.init(context);
              return const SettingsScreen();
            })),
      ));
}
