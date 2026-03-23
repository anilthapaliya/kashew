import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kashew/utils/constants.dart';
import 'package:kashew/utils/responsive.dart';
import 'package:kashew/view_models/language_viewmodel.dart';
import 'package:kashew/view_models/splash_viewmodel.dart';
import 'package:kashew/view_models/currency_viewmodel.dart';
import 'package:kashew/views/splash_screen.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';
import 'splash_screen_test.mocks.dart';
@GenerateMocks([SplashViewModel, LanguageViewModel, CurrencyViewModel])

void main() {

  testWidgets("Splash Screen UI", (tester) async {

    final mockSplashVM = MockSplashViewModel();
    when(mockSplashVM.initializeApp(any)).thenAnswer((_) async => Constants.home);

    await tester.pumpWidget(
        ChangeNotifierProvider<SplashViewModel>.value(
          value: mockSplashVM,
          child: MaterialApp(
            routes: {
              Constants.home: (_) => const Scaffold(body: Text("Home")),
            },
            home: MediaQuery(data: const MediaQueryData(size: Size(1080, 1920)),
                child: Builder(builder: (context) {
                  R.init(context);
                  return const SplashScreen();
                })),
          ),
        )
    );

    expect(find.byType(Image), findsOneWidget);
    await tester.pumpAndSettle();
    expect(find.text("Home"), findsOneWidget);
  });

}