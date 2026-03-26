import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kashew/models/currency_model.dart';
import 'package:kashew/models/language_model.dart';
import 'package:kashew/views/welcome_screen.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:kashew/view_models/welcome_viewmodel.dart';
import 'package:kashew/view_models/language_viewmodel.dart';
import 'package:kashew/view_models/currency_viewmodel.dart';
import 'package:provider/provider.dart';
import 'welcome_screen_test.mocks.dart';
import 'package:kashew/utils/constants.dart';
import 'package:kashew/utils/responsive.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:kashew/l10n/app_localizations.dart';
@GenerateMocks([WelcomeViewModel, LanguageViewModel, CurrencyViewModel])

void main() {

  late MockWelcomeViewModel mockWelcomeVM;
  late MockLanguageViewModel languageVM;
  late MockCurrencyViewModel currencyVM;

  setUp(() {
    mockWelcomeVM = MockWelcomeViewModel();
    languageVM = MockLanguageViewModel();
    currencyVM = MockCurrencyViewModel();
  });

  testWidgets("Welcome Screen UI", (tester) async {

    await tester.binding.setSurfaceSize(const Size(1080, 1920));

    when(languageVM.locale).thenReturn(const Locale('en'));
    when(languageVM.languages).thenReturn(
        [LanguageModel(code: 'en', language: 'English'), LanguageModel(code: 'de', language: 'Deutsch')]);
    when(languageVM.getLanguage(any)).thenReturn(LanguageModel(code: 'en', language: 'English'));
    when(currencyVM.defaultCurrency).thenReturn(CurrencyModel('USD'));
    when(currencyVM.currencies).thenReturn([
      CurrencyModel('USD'), CurrencyModel('EUR')
    ]);
    when(mockWelcomeVM.loadDefaults()).thenAnswer((_) async => {});

    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider<WelcomeViewModel>.value(value: mockWelcomeVM),
          ChangeNotifierProvider<LanguageViewModel>.value(value: languageVM),
          ChangeNotifierProvider<CurrencyViewModel>.value(value: currencyVM)
        ],
        child: MaterialApp(
          routes: {
            Constants.home: (_) => const Scaffold(body: Text("Home")),
          },
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: AppLocalizations.supportedLocales,
          locale: Locale('en'),
          home: MediaQuery(data: const MediaQueryData(size: Size(1080, 1920)),
              child: Builder(builder: (context) {
                R.init(context);
                return const WelcomeScreen();
              })),
        ),
      )
    );

    await tester.pump(); // triggers post frame callback
    verify(mockWelcomeVM.loadDefaults()).called(1);

    // Check default currency and language
    expect(find.text(CurrencyModel.currencyMap['USD']!), findsOneWidget);
    expect(find.text("English"), findsOneWidget);

    // Tap on language dropdown
    await tester.tap(find.byType(DropdownMenu<LanguageModel>));
    await tester.pumpAndSettle();
    final langMenuItem = find.descendant(of: find.byType(MenuItemButton),
        matching: find.text('Deutsch'));
    await tester.tap(langMenuItem.hitTestable().first);
    await tester.pumpAndSettle();

    verify(languageVM.changeLanguage(any)).called(1);

    // Tap on currency dropdown
    await tester.tap(find.byType(DropdownMenu<CurrencyModel>));
    await tester.pumpAndSettle();
    final currencyItem = find.descendant(of: find.byType(MenuItemButton),
        matching: find.text(CurrencyModel.currencyMap['EUR']!));
    await tester.tap(currencyItem.hitTestable().first);
    await tester.pumpAndSettle();

    verify(currencyVM.selectCurrency(any)).called(1);
  });

}
