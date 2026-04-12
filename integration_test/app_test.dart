import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:kashew/main.dart' as app;
import 'package:kashew/utils/constants.dart';
import 'package:kashew/views/home/home_screen.dart';

import 'test_database_helper.dart';

void main() {

  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  TestDatabaseHelper dbHelper = TestDatabaseHelper.dbHelper;

  group("Integration Test", () {

    testWidgets("should run smooth and show Welcome Screen on first launch.", (tester) async {

      app.main();
      await tester.pumpAndSettle(Duration(seconds: 1));
      dbHelper.resetDatabase(true);

      // Expect to find the splash logo.
      expect(find.byType(Image), findsOneWidget);
      await tester.pumpAndSettle(Duration(seconds: Constants.splashDelay));

      // Expect to find the welcome screen.
      expect(find.byType(Image), findsNothing);
      expect(find.text("Welcome to KASHew App"), findsOneWidget);
      
      // Find and tap on button.
      final button = find.byType(ElevatedButton);
      expect(button, findsOneWidget);
      await tester.tap(button);
      await tester.pumpAndSettle();

      // Expect to find the home screen.
      expect(find.byKey(const Key("home-body")), findsOneWidget);
      await tester.pumpAndSettle();
    });

    testWidgets("should run the app smooth on consecutive app launch.", (tester) async {

      app.main();
      await tester.pumpAndSettle(Duration(seconds: 1));
      dbHelper.resetDatabase(false);

      // Expect to find the splash logo.
      expect(find.byType(Image), findsOneWidget);
      await tester.pumpAndSettle(Duration(seconds: Constants.splashDelay));

      // Expect to find the home screen.
      final home = find.byKey(const Key("home-body"));
      expect(home, findsOneWidget);
      await tester.pumpAndSettle();

      // Click on the settings icon in the home screen.
      final settings = find.byType(IconButton);
      await tester.tap(settings);
      await tester.pumpAndSettle();
      // Expect to find the settings screen.
      expect(find.text("Preferences"), findsOneWidget);
      await tester.tap(find.backButton());
      await tester.pumpAndSettle();
      // Expect to go back to home screen.
      expect(home, findsOneWidget);

      // Click on add expense button.
      final addExpense = find.byType(FloatingActionButton);
      await tester.tap(addExpense);
      await tester.pumpAndSettle();

      // Expect to find the add expense screen.
      expect(find.byKey(const Key('add-expense-button')), findsOneWidget);
      // Click on close button.
      await tester.tap(find.byKey(const Key("close-button")));
      await tester.pumpAndSettle();
      // Expect to go back to home screen.
      expect(home, findsOneWidget);

    });
  });

}