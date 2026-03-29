import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kashew/l10n/app_localizations.dart';
import 'package:kashew/models/language_model.dart';
import 'package:kashew/utils/constants.dart';
import 'package:kashew/utils/responsive.dart';
import 'package:kashew/views/language_only_list_screen.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:kashew/view_models/language_viewmodel.dart';
import 'package:provider/provider.dart';
import 'welcome_screen_test.mocks.dart';
@GenerateMocks([LanguageViewModel])

void main() {

  late MockLanguageViewModel mockLanguageVM;

  setUp(() {
    mockLanguageVM = MockLanguageViewModel();
  });

  testWidgets("Language Only List UI", (tester) async {

    when(mockLanguageVM.languages).thenReturn([
      LanguageModel(code: 'en', language: 'English'),
      LanguageModel(code: 'es', language: 'Espanol'),
      LanguageModel(code: 'de', language: 'Deutsch'),
      LanguageModel(code: 'in', language: 'Hindi'),
      LanguageModel(code: 'np', language: 'Nepali'),
      LanguageModel(code: 'mn', language: 'Chinese'),
      LanguageModel(code: 'kr', language: 'Korean'),
      LanguageModel(code: 'jp', language: 'Japanese'),
      LanguageModel(code: 'ur', language: 'Urdu'),
      LanguageModel(code: 'gj', language: 'Gujarati'),
      LanguageModel(code: 'mr', language: 'Marathi'),
      LanguageModel(code: 'br', language: 'Bhojpuri'),
      LanguageModel(code: 'af', language: 'Afrikaans'),
      LanguageModel(code: 'mx', language: 'Mexican'),
      LanguageModel(code: 'sc', language: 'Scottish'),
      LanguageModel(code: 'cp', language: 'Chepang'),
      LanguageModel(code: 'tm', language: 'Tamang'),
    ]);
    when(mockLanguageVM.changeLanguage(any)).thenAnswer((_) async {});

    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider<LanguageViewModel>.value(value: mockLanguageVM)
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
                return const LanguageListScreen();
              }))
        ),
      )
    );

    // Check appearance
    expect(find.text("All Languages"), findsOneWidget);
    final listFinder = find.byKey(const Key('language-list'));
    expect(listFinder, findsOneWidget);

    // Check language loaded
    expect(find.text("English"), findsOneWidget);
    expect(find.text("Deutsch"), findsOneWidget);

    // Check list scroll
    await tester.scrollUntilVisible(find.text("Espanol"), 500);
    expect(find.text("Espanol"), findsOneWidget);
    await tester.scrollUntilVisible(find.byKey(const Key('language-item-cp')), 500);
    expect(find.text('Chepang'), findsOneWidget);

    // Tap on language item
    await tester.scrollUntilVisible(find.byKey(const Key('language-item-mx')), 500);
    await tester.tap(find.text('Mexican').hitTestable());
    await tester.pumpAndSettle();
    verify(mockLanguageVM.changeLanguage('mx')).called(1);
  });

}